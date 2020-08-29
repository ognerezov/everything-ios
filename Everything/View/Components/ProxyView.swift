//
//  ProxyView.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 31.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct ProxyView <T : UIView>:  UIViewRepresentable{
    var view : T
    @ObservedObject var state : AppState
    @Environment(\.colorScheme) var colorScheme
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> T {
        return view
    }
    
    func updateUIView(_ uiView: T, context: Context) {
        if uiView is RecordLabel{
            let label : RecordLabel = uiView as! RecordLabel
            label.set(isDark: colorScheme == .dark, fontSize: state.settings.fontSize)
        }
    }
}

struct ProxyView_Previews: PreviewProvider {
    static var previews: some View {
        ProxyView(view: UILabel(), state: AppState())
    }
}
