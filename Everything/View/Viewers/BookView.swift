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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var chapter : Chapter?{
        state.chapters.count > 0 ?  state.settings.chapter(from: state.chapters) : nil
    }
    
    var headerFont : Font{
        horizontalSizeClass == .regular ? .title : .subheadline
    }

    @ViewBuilder
    var body: some View {
        if state.chapters.count > 0 {
            VStack{
                underChapter
            }
            .sheet(isPresented: .constant (self.showTools || state.settings.layers.count > 1 || self.state.suggestedNumbers.count > 0),
                onDismiss: {
                    if self.state.suggestedNumbers.count > 0{
                        self.state.suggestedNumbers = []
                    } else if !self.showTools{
                        AppState.cutTop()
                    } else{
                        self.showTools = false
                    }
                }){
                    if self.state.suggestedNumbers.count > 0{
                        NumberSuggestionControl(state: state)
                    } else if self.showTools{
                        BookTools(show: self.$showTools)
                    } else{
                        self.chaptersView
                    }
                }
        } else{
            VStack{
                Spacer()
                Text("Загружаю числа")
                InifnityBar(value: 0)
                    .frame(maxHeight: 20)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func topPanel(_ chapter : Chapter) -> some View{
        if state.error == .Processing {
            Spacer()
            InifnityBar(value: 0)
                .frame(maxHeight: 20)
            Spacer()
        } else {
            HStack{
                Button(action: prev) {
                    HStack{
                        Image(systemName:"chevron.left")
                        Text(chapter.number > 1  ? String(chapter.number - 1) : "")
                        .font(headerFont)
                    }
                }
                .disabled(chapter.number == 1)
                Button(action: {AppState.decreaseFont()}) {
                    Image(systemName:"textformat.size")
                    .rotation3DEffect(Angle(degrees: 180), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
                }
                .padding(.horizontal)
                Spacer()
                Text(String(chapter.number))
                .font(headerFont)
                Spacer()
                Button(action: {AppState.increaseFont()}) {
                    Image(systemName:"textformat.size")
                }
                .padding(.horizontal)
                Button(action: next) {
                    HStack{
                        Text(String(chapter.number + 1))
                        .font(headerFont)
                        Image(systemName:"chevron.right")
                    }
                }
                Button(action: {self.showTools = true}) {
                    Image("icon123")
                }

            }.padding(.horizontal)
        }
    }
    
    func getBody(chapter : Chapter,with layers: Bool = true) ->  some View {
        VStack{
            topPanel(chapter)
            ChapterViewer(chapter: chapter, state: state)
            .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .local)
                                .onEnded({ value in
                                    if abs(value.translation.height) >= abs(value.translation.width){
                                        return
                                    }
                                    
                                    if value.translation.width < 0 {
                                        next()
                                    }

                                    if value.translation.width > 0 {
                                        prev()
                                    }
                                }))
                .sheet(isPresented: .constant(self.state.suggestedNumbers.count > 0), onDismiss: {
                    self.state.suggestedNumbers = []
                }){
                    NumberSuggestionControl(state: state)
                }
            if layers{
                LayersControl(layers : state.settings.layers){number in
                        AppState.add(number: number)
                    }
            }
        }
    }
    
    var underChapter : some View {
        getBody(chapter: state.settings.underChapter(from: state.chapters), with: false)
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
            if (currentChapter.number > 1 ){
                go(to: currentChapter.number - 1)
            }
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
