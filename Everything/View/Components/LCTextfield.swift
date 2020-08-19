//
//  LCTextfield.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 17.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct LCTextfield: View {
    
    @Binding var value: String
    var placeholder = "Placeholder"
    var icon = Image(systemName: "person.crop.circle")
    let errorIcon = Image(systemName: "exclamationmark.triangle.fill")
    var color = Color.contrastColor
    var isSecure = false
    var onEditingChanged: ((Bool)->()) = {_ in }
    var valid = true
    
    var currentColor:  Color {
        valid ? color : Color.error
    }
    
    var body: some View {
        HStack {
            
            if isSecure{
                SecureField(placeholder, text: self.$value, onCommit: {
                    self.onEditingChanged(false)
                }).padding()
            } else {
                TextField(placeholder, text: self.$value, onEditingChanged: { flag in
                    self.onEditingChanged(flag)
                }).padding()
            }
            if valid {
                icon.imageScale(.large)
                    .padding()
                    .foregroundColor(color)
            } else{
                errorIcon.imageScale(.large)
                    .padding()
                    .foregroundColor(Color.error)
            }
        }.background(currentColor.opacity(0.2)).cornerRadius(6)
    }
}

struct LCTextfield_Previews: PreviewProvider {
    static var previews: some View {
        LCTextfield(value: .constant(""))
    }
}
