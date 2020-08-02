//
//  BookView.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 02.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct BookView: View {
    var chapters : [Chapter]
    var chapter : Chapter?{
        chapters.count > 0 ?  chapters[chapters.count - 1] : nil
    }
    
    @ViewBuilder
    var body: some View {
        if chapters.count > 0 {
            VStack{
                HStack{
                    Button(action: prev) {
                        HStack{
                            Image(systemName:"chevron.left")
                    Text(self.chapter != nil && self.chapter!.number > 1  ? String(self.chapter!.number - 1) : "")
                        }
                    }
                    .disabled(self.chapter == nil || self.chapter!.number == 1)
                    Spacer()
                    Text(self.chapter != nil ? String(self.chapter!.number) : "")
                    Spacer()
                    Button(action: next) {
                        HStack{
                            Text(self.chapter != nil ?  String(self.chapter!.number + 1) : "")
                            Image(systemName:"chevron.right")
                        }
                    }
                }
                .padding()
                ChapterViewer(chapter: chapters[chapters.count-1])
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
        if let currentChapter = chapter{
            go(to: currentChapter.number + 1)
        }
    }
    
    func prev(){
        if let currentChapter = chapter{
            go(to: currentChapter.number - 1)
        }
    }
    
    func go(to number: Int){
        AppState.go(to: number)
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(chapters: [])
    }
}
