//
//  LoginView.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 17.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @Binding var show : Bool
    @Binding var showRegister : Bool
    @Binding var email : String
    @Binding var password : String
    @State private var formOffset: CGFloat = 0
    @State private var presentPasswordRecoverySheet = false
    @State private var emailedCodeSheet = false

    var onSuccess : () -> Void
    
    var disabled : Bool{
        !self.$email.wrappedValue.isValidEmail() ||
        self.$password.wrappedValue.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Text("Войти").font(.title).bold()
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
                            isSecure: true)
                        .autocapitalization(.none)
                
                LCButton(text: "Войти",disabled: disabled) {
                    self.show = false
                    AppState.login(username: self.email, password: self.password, allertAction: {
                        self.show = true
                    }, onSucces: self.onSuccess)
                }
            }
            
            Button(action: {
                self.show = false
                self.showRegister = true
                UIApplication.shared.endEditing()
            }) {
              HStack {
                Text("Зарегистрироваться").accentColor(Color.accentColor)
                  }
              }
            
            Button(action: {
                self.presentPasswordRecoverySheet.toggle()
            }) {
              HStack {
                Text("Забыли пароль?").accentColor(Color.purple)
                  }
              }.sheet(isPresented: self.$presentPasswordRecoverySheet) {
                RecoverPasswordView(email: self.email, show: self.$presentPasswordRecoverySheet)
              }
            
        }.padding().offset(y: self.formOffset)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(show: .constant(true), showRegister : .constant(true), email: .constant(""), password: .constant("")){
            
        }
    }
}
