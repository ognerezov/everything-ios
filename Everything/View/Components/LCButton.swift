//
//  LCButton.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 18.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct LCButton: View {
    var text = "Next"
    var action: (()->()) = {}
    var disabled = false
    
    var currentColor : Color{
        disabled ? Color.contrastColor.opacity(0.2) : Color.contrastColor
    }
    
    
    var body: some View {
      Button(action: {
        self.action()
      })
      {
        HStack {
            Text(text)
                .bold()
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.vertical)
                .accentColor(Color.main)
                .background(currentColor)
                .cornerRadius(6)
            }
        }
      .disabled(disabled)
    }
}

struct LCButton_Previews: PreviewProvider {
    static var previews: some View {
        LCButton()
    }
}
