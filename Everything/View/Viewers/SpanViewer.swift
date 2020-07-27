//
//  SpanViewer.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 26.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct SpanViewer: View {
    var span : Span
    @ViewBuilder
    var body: some View {
        if span.number{
            Button(action: select){
                Text(span.text)
                .foregroundColor(Color.white)
                .background(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/)
                .font(.custom("Roboto Black", size: 19))
            }
        } else{
            Text(span.text.replacingOccurrences(of: ".\t", with: ""))
            .font(.custom("Roboto Black", size: 15))
        }

    }
    
    func select(){
        print(span.text)
    }
}

struct SpanViewer_Previews: PreviewProvider {
    static var previews: some View {
        SpanViewer(span: Span(text: "Hello", number: true))
    }
}
