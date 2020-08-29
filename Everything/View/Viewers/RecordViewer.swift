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
    var interactable : Bool
    @ObservedObject var state : AppState
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let label = LabelFactory.label(content: self.record.spans, width: width, isDark: colorScheme == .dark, type: record.type, fontSize: self.state.settings.fontSize, interactable: interactable)
        label.sizeToFit()
        return
            ZStack{
                textBackground
                ProxyView(view: label, state : self.state)
            }
    }
    
    @ViewBuilder
    var textBackground: some View {
        
        if record.type == .quotation || record.type == .poem {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.accentLight)
        } else if record.type == .formula {
            RoundedRectangle(cornerRadius: 6)
            .stroke(Color.accentDark)
        } else if record.type == .rule {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.contrastColor)
        } else if record.type == .ruleBody {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.accentDark)
        }else{
            EmptyView()
        }
    }
}

struct RecordViewer_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            RecordViewer(record: Record(number: 1, type: .quotation, spans: []), width: 300, interactable: true, state: AppState())
            .environment(\.colorScheme, .dark)
        RecordViewer(record: Record(number: 1, type: .quotation, spans: []), width: 300, interactable: true, state: AppState())
            .environment(\.colorScheme, .light)
        }
    }
}
