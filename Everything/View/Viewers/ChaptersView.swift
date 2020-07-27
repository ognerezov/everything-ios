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
            Text(String(chapters[current].number))
        
            Button(action: {
                self.current += 1
                if self.current == self.chapters.count{
                    self.current = 0
                }
            }) {
                Text("Next")
            }
        }
        } else{
            Text("Nothing")
        }
    }
}

struct QuotationView_Previews: PreviewProvider {
    static var previews: some View {
        QuotationsView(chapters: [])
    }
}
