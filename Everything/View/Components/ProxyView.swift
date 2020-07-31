//
//  ProxyView.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 31.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct ProxyView:  UIViewRepresentable{
    var view : UIView
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIView {
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    
    }
}

struct ProxyView_Previews: PreviewProvider {
    static var previews: some View {
        ProxyView(view: UILabel())
    }
}
