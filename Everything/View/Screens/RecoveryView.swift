//
//  RecoveryView.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 17.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct RecoverPasswordView: View {
    @State private var email = ""
    @Binding var presentPasswordRecoverySheet: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Image("Logo")
            Text("Recover Password").font(.title).bold()
            VStack {
                LCTextfield(value: self.$email, placeholder: "Email", icon: Image(systemName: "at"))
                Button("Reset Password") {}
            }
            
            Button(action: {
                self.presentPasswordRecoverySheet.toggle()
            }) {
              HStack {
                Text("Cancel").accentColor(Color.accentColor)
                  }
              }
            
        }.padding()
    }

}

struct RecoverEmailView_Previews: PreviewProvider {
    static var previews: some View {
        RecoverPasswordView(presentPasswordRecoverySheet: .constant(false))
    }
}
