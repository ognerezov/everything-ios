//
//  BookView.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 02.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct BookView: View {

    @ObservedObject var state : AppState
    @State var showTools : Bool = false
    
    var chapter : Chapter?{
        state.chapters.count > 0 ?  state.settings.chapter(from: state.chapters) : nil
    }

    @ViewBuilder
    var body: some View {
        if state.chapters.count > 0 {
            VStack{
                underChapter
            }
            .sheet(isPresented: .constant (self.showTools || state.settings.layers.count > 1),
                onDismiss: {
                    if !self.showTools{
                        AppState.cutTop()
                    } else{
                        self.showTools = false
                    }
                }){
                    if self.showTools{
                        BookTools(show: self.$showTools)
                    } else{
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
            Button(action: {self.showTools = true}) {
                Image(systemName:"circle.grid.2x2")
            }

        }.padding()
    }
    
    func getBody(chapter : Chapter) ->  some View {
        VStack{
            topPanel(chapter)
            ChapterViewer(chapter: chapter)
            LayersControl(layers : state.settings.layers){number in
                    AppState.add(number: number)
            }
        }
    }
    
    var underChapter : some View {
        getBody(chapter: state.settings.underChapter(from: state.chapters))
    }
    
    var chaptersView : some View{
        getBody(chapter: state.settings.chapter(from: state.chapters))
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
        BookView(state: AppState())
    }
}
