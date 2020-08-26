//
//  ImageButton.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 25.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct ImageButton: View {
    var text = "Next"
    var icon = "questionmark.circle.fill"
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
        ZStack{
            RoundedRectangle(cornerRadius: 6)
            .fill(currentColor)
            .frame(height: 52)
            HStack{
                Image(systemName: icon)
                    .foregroundColor(Color.main)
                    .padding(.leading)
                Spacer()
            }
            Text(text)
                .bold()
                .frame(minWidth: 0, maxWidth: .infinity)
                .accentColor(Color.main)
                .padding()
        }
      }
      .disabled(disabled)
    }
}

struct ImageButton_Previews: PreviewProvider {
    static var previews: some View {
        ImageButton()
    }
}
