//
//  RecoveryView.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 17.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct RecoverPasswordView: View {
    @State var email = ""
    @State private var code = ""
    @Binding var show: Bool
    @State private var showCodeInput = false
    @State private var processing = false
    @State private var error : ErrorType = .NoException
    @State private var codeAccepted = false
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var passwordChanged = false
    
    
    var body: some View {
        VStack(spacing: 40) {
            Text(processing ? "Запрос обрабатывается":
                (showCodeInput ? "Код выслан на email: \(email)":
                (codeAccepted ?  "Задайте новый пароль"
                    : "Восстановление пароля"))).font(.title).bold()
            
            if processing {
                InifnityBar()
                    .frame(maxHeight: 20)
            } else {
                VStack {
                    
                        if showCodeInput {
                            
                            LCTextfield(value: self.$code,
                                        placeholder: "Введите код",
                                        keyboard: .numberPad,
                                        icon: Image(systemName: "keyboard"))
                            .autocapitalization(.none)
                            
                            LCButton(text: "Отправить",
                                     action: {
                                        self.processing = true
                                        self.error = .NoException
                                        AppState.loginWithCode(code: self.code,
                                                               onError:{error in
                                                                
                                                                self.error = error
                                                                self.processing = false
                                                               })
                                        {
                                            self.showCodeInput = false
                                            self.codeAccepted = true
                                            self.processing = false
                                        }
                                     }, disabled: self.$code.wrappedValue.isEmpty)
                            
                        } else if codeAccepted{
                            
                            LCTextfield(value: self.$newPassword,
                                        placeholder: "Пароль",
                                        icon: Image(systemName: "lock"),
                                        isSecure: true
                                ).autocapitalization(.none)
                            
                            LCTextfield(value: self.$confirmPassword,
                                        placeholder: "Подтвердите Пароль",
                                        icon: Image(systemName: "lock.rotation"),
                                        isSecure: true,
                                        valid: self.$newPassword.wrappedValue == self.$confirmPassword.wrappedValue
                                ).autocapitalization(.none)
                            
                            LCButton(text: "Изменить пароль",
                                     action: {
                                        self.processing = true
                                        AppState.changePassword(to: self.newPassword, onError:{error in
                                            self.error = error
                                            self.processing = false
                                        }, onSucces:{
                                            self.processing = false
                                            self.passwordChanged = true
                                            print("success")
                                            
                                        })
                                     }, disabled: self.$newPassword.wrappedValue.count == 0 || self.$newPassword.wrappedValue != self.$confirmPassword.wrappedValue)
                        } else {
                            LCTextfield(value: self.$email,
                                        placeholder: "Email",
                                        keyboard: .emailAddress,
                                        icon: Image(systemName: "at"),
                                        valid:self.$email.wrappedValue.isEmpty || self.$email.wrappedValue.isValidEmail())
                            .autocapitalization(.none)
                            
                            LCButton(text: "Восстановить пароль",
                                     action: {
                                        self.processing = true
                                        AppState.forget(for: self.email,
                                                        onError:  {error in
                                                            self.error = error
                                                            self.processing = false
                                                            self.showCodeInput = false
                                                        },
                                                        onSucces: {
                                                            self.processing = false
                                                            self.showCodeInput = true
                                                        })
                                     }, disabled: !self.$email.wrappedValue.isValidEmail())
                    }
                }.alert(isPresented: .constant(error.hasError || self.$passwordChanged.wrappedValue)){
                    if self.passwordChanged{
                        return Alert(title:
                            Text("Пароль успешно изменен"),
                            dismissButton:
                            .default(Text("Ок")){
                                self.show = false
                                self.passwordChanged = false
                            }
                        )
                    } else {
                        return Alert(title:
                            Text(error.description),
                            dismissButton:
                            .default(Text("Ок")){
                                self.error = .NoException
                            }
                        )
                    }
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
