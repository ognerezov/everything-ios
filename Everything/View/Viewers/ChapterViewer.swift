//
//  ChapterViewer.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 26.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct ChapterViewer: View {
    var chapter : Chapter
    var interactable = true
    @ObservedObject var state : AppState
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false){
                VStack{
                    ForEach(self.chapter.records){
                        RecordViewer(record: $0, width: geometry.size.width, interactable : self.interactable, state: self.state)
                    }
                    
                }
            }
        }.padding(.all)
        .frame(maxHeight: .infinity)
    }
}

struct ChapterViewer_Previews: PreviewProvider {
    static var previews: some View {
        ChapterViewer(chapter: Chapter(number: 1, type:.chapter , level: 1, records: [
        ]),state: AppState())
    }
}

