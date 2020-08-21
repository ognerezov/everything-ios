//
//  SignupView.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 17.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct SignupView: View {
     
    @Binding var show : Bool
    @Binding var email : String
    @State private var password = ""
    @State private var confirmedPassword = ""
    
    @State private var formOffset: CGFloat = 0
    
    var onSuccess : () -> Void
    
    var disabled : Bool{
        self.$confirmedPassword.wrappedValue != self.$password.wrappedValue ||
        !self.$email.wrappedValue.isValidEmail() ||
        self.$password.wrappedValue.isEmpty
    }
    
    var body: some View {
        
       return VStack(spacing: 40) {
            Image("Logo")
            Text("Регистрация").font(.title).bold()
            VStack {
                LCTextfield(value: self.$email,
                            placeholder: "Email",
                            icon: Image(systemName: "at"),
                            onEditingChanged: { flag in
                                    withAnimation {
                                        self.formOffset = flag ? -150 : 0
                                    }
                            },
                            valid:self.$email.wrappedValue.isEmpty || self.$email.wrappedValue.isValidEmail()
                        ).autocapitalization(.none)
                
                LCTextfield(value: self.$password,
                            placeholder: "Пароль",
                            icon: Image(systemName: "lock"),
                            isSecure: true
                    ).autocapitalization(.none)
                
                LCTextfield(value: self.$confirmedPassword,
                            placeholder: "Подтвердите Пароль",
                            icon: Image(systemName: "lock.rotation"),
                            isSecure: true,
                            valid: self.$confirmedPassword.wrappedValue == self.$password.wrappedValue
                    ).autocapitalization(.none)
                
                LCButton(text: "Регистрация",disabled: disabled) {
                    self.show = false
                    AppState.register(username: self.email, password: self.password, allertAction: {
                        self.show = true
                        print ("storred allert action")
                    }){
                        self.onSuccess()
                    }
                }
            }
            
            Button(action: {
            }) {
              HStack {
                Text("Уже зарегистрированы?").accentColor(Color.accentColor)
                  }
              }
            
       }.padding().offset(y: self.formOffset)
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(show: .constant(true), email: .constant("")){
            
        }
    }
}
