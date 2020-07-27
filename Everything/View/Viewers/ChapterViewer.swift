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
    var body: some View {
        List(chapter.records){
            RecordViewer(record: $0)
        }
    }
}

struct ChapterViewer_Previews: PreviewProvider {
    static var previews: some View {
        ChapterViewer(chapter:             Chapter(number: 1, type:.chapter , level: 1, records: [
        ]))
    }
}

