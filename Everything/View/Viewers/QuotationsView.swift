//
//  QuotationView.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 26.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct QuotationsView: View {
    @State var current : Int = 0
    var chapters : [Chapter]
    
    @ViewBuilder
    var body: some View {
        if chapters.count > 0 {
            VStack{
                HStack{
                    Button(action: next) {
                        HStack{
                            Image(systemName:"chevron.left")
                            Text("Back")
                        }
                    }
                    .disabled(current == 0)
                    Spacer()
                    Text("Цитаты")
                    Spacer()
                    Button(action: next) {
                        HStack{
                            Text("Next")
                            Image(systemName:"chevron.right")
                        }
                    }
                }
                .padding()
                ChapterViewer(chapter: chapters[current])
            }
        } else{
            VStack{
                Spacer()
                InifnityBar(value: 0)
                    .frame(maxHeight: 20)
                Spacer()
            }
        }
    }
    
    func next(){
        current += 1
        if current == chapters.count{
            current = 0
            AppState.refreshQuotations()
        }
    }
    
    func prev(){
        current -= 1
        if current < 0{
            current = chapters.count - 1
        }
    }
}

struct QuotationView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
        QuotationsView(chapters: [
            Chapter(number: 1, type:.chapter , level: 1, records: [])
        ])
        QuotationsView(chapters: [])
        }
    }
}
