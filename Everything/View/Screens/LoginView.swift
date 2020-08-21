//
//  LoginView.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 17.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var formOffset: CGFloat = 0
    @State private var presentSignupSheet = false
    @State private var presentPasswordRecoverySheet = false

    
    var body: some View {
        VStack(spacing: 40) {
            Image("Logo")
            Text("Login").font(.title).bold()
            VStack {
                LCTextfield(value: self.$email, placeholder: "Email", icon: Image(systemName: "at"), onEditingChanged: { flag in
                    withAnimation {
                        self.formOffset = flag ? -150 : 0
                    }
                })
                LCTextfield(value: self.$password, placeholder: "Password", icon: Image(systemName: "lock"), isSecure: true)
                LCButton(text: "Login") {
                    
                }
            }
            
            Button(action: {
                self.presentSignupSheet.toggle()
            }) {
              HStack {
                Text("Don't have an account? Sign up.").accentColor(Color.accentColor)
                  }
              }.sheet(isPresented: self.$presentSignupSheet) {
                SignupView(show: .constant(true), email: .constant("")){}
              }
            
            Button(action: {
                self.presentPasswordRecoverySheet.toggle()
            }) {
              HStack {
                Text("Forgot your password?").accentColor(Color.purple)
                  }
              }.sheet(isPresented: self.$presentPasswordRecoverySheet) {
                RecoverPasswordView(presentPasswordRecoverySheet: self.$presentPasswordRecoverySheet)
              }
            
        }.padding().offset(y: self.formOffset)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
