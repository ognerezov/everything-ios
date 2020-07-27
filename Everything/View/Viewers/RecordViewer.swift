//
//  RecordViewer.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 26.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct RecordViewer: View {
    var record : Record
    var body: some View {
        HStack{
            ForEach(record.spans){
                SpanViewer(span: $0)
            }
        }
    }
}

struct RecordViewer_Previews: PreviewProvider {
    static var previews: some View {
        RecordViewer(record: Record(number: 1, type: .chapter, spans: []))
    }
}
