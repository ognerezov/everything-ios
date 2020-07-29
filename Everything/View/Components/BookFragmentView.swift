//
//  BookFragmentView.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 28.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import WebKit
import SwiftUI

struct BookFragmentView:  UIViewRepresentable {
    let text: String

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UILabel {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        
        label.text = text
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
    
    }
}

struct BookFragmentView_Previews: PreviewProvider {
    static var previews: some View {
        BookFragmentView(text: "texttttttttttttttttttttt")
    }
}
