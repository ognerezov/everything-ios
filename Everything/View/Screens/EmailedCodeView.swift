//
//  EmailedCodeView.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 13/09/2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct EmailedCodeView: View {
    @State private var code = ""
    @Binding var show: Bool
    
    var body: some View {
        VStack(spacing: 40) {
                Text("Код отправлен на указанную почту").font(.title).bold()
                VStack {
                    LCTextfield(value: self.$code,
                                placeholder: "Введите код",
                                icon: Image(systemName: "at"))
                    .autocapitalization(.none)
                    Button("Отправить") {

                    }
                }
                
                Button(action: {
                    self.show.toggle()
                }) {
                  HStack {
                    Text("Cancel").accentColor(Color.accentColor)
                      }
                  }
                
            }.padding()
        }
}
