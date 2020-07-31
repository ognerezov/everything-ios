//
//  RecordViewer.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 26.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI


struct RecordViewer: View  {
    var record : Record
    var width : CGFloat
    
    var body: some View {
        let label = LabelFactory.label(content: self.record.spans, width: width)
        label.sizeToFit()
        return
            ZStack{
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(#colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)))
            ProxyView(view: LabelFactory.label(content: self.record.spans, width: width))
            .scaledToFit()
            }
//            .padding(.bottom)

    }
}

struct RecordViewer_Previews: PreviewProvider {
    static var previews: some View {
        RecordViewer(record: Record(number: 1, type: .chapter, spans: []), width: 300)
    }
}
