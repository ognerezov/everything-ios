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
    var settings : Settings
    
    var chapter : Chapter?{
        chapters.count > 0 ?  settings.chapter(from: chapters) : nil
    }
    
    @ViewBuilder
    var body: some View {
        if chapters.count > 0 {
            VStack{
                underChapter
                    .sheet(
                    isPresented: .constant(self.settings.layers.count > 1),
                    onDismiss: {AppState.cutTop()}
                    ){
                        self.chaptersView
                    }
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
    
    @ViewBuilder
    func topPanel(_ chapter : Chapter) -> some View{
        HStack{
            Button(action: prev) {
                HStack{
                    Image(systemName:"chevron.left")
            Text(chapter.number > 1  ? String(chapter.number - 1) : "")
                }
            }
            .disabled(chapter.number == 1)
            Spacer()
            Text(String(chapter.number))
            Spacer()
            Button(action: next) {
                HStack{
                    Text(String(chapter.number + 1))
                    Image(systemName:"chevron.right")
                }
            }
            Button(action: next) {
                Image(systemName:"book.circle").foregroundColor(Color.gray)
            }
        }.padding()
    }
    
    func getBody(chapter : Chapter) ->  some View {
        VStack{
            topPanel(chapter)
            ChapterViewer(chapter: chapter)
            LayersControl(layers : settings.layers){number in
                    AppState.add(number: number)
            }
            .frame(maxHeight: 50)
        }
    }
    
    var underChapter : some View {
        getBody(chapter: settings.underChapter(from: chapters))
    }
    
    var chaptersView : some View{
        getBody(chapter: settings.chapter(from: chapters))
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
        BookView(chapters: [], settings: Settings())
    }
}
