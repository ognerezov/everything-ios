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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let label = LabelFactory.label(content: self.record.spans, width: width, isDark: colorScheme == .dark)
        label.sizeToFit()
        return
            ZStack{
                textBackground
                ProxyView(view: LabelFactory.label(content: self.record.spans, width: width, isDark: colorScheme == .dark))
                .scaledToFit()
            }
    }
    
    @ViewBuilder
    var textBackground: some View {
        if(record.type == .quotation || record.type == .poem){
            RoundedRectangle(cornerRadius: 6).fill(Color.accentLight)
        }
        else{
            EmptyView()
        }

    }
}

struct RecordViewer_Previews: PreviewProvider {
    static var previews: some View {
        Group{
        RecordViewer(record: Record(number: 1, type: .quotation, spans: []), width: 300)
            .environment(\.colorScheme, .dark)
        RecordViewer(record: Record(number: 1, type: .quotation, spans: []), width: 300)
            .environment(\.colorScheme, .light)
        }
    }
}
