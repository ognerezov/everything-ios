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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        
        var type = record.type
        let padding : CGFloat = type == .quotation || type == .poem ?
            (horizontalSizeClass == .compact ? 10 : 30 ): 0
        
        
        if !state.user.canRead && (type == .quotation || type == .poem){
            type = .regular
        }
        
        let label = LabelFactory.label(content: self.record.spans, width: width - padding * 2, isDark: colorScheme == .dark, type: type, fontSize: self.state.settings.fontSize, interactable: interactable)
        label.sizeToFit()
        return
            ZStack{
                textBackground
                ProxyView(view: label, state : self.state)
            }
            .padding(.horizontal, padding)
    }
    
    @ViewBuilder
    var textBackground: some View {
        if record.type == .quotation || record.type == .poem || record.type == .formula{
            RoundedRectangle(cornerRadius: 1)
                .fill(Color.secondary)
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
