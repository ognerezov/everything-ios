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
    
    
    var body: some View {
        VStack(spacing: 40) {
            Text(processing ? "Запрос обрабатывается":
                (showCodeInput ? "Код выслан на email: \(email)":
                    "Восстановление пароля")).font(.title).bold()
            
            if processing {
                InifnityBar()
                    .frame(maxHeight: 20)
            } else {
                VStack {
                    
                        if showCodeInput {
                            
                            LCTextfield(value: self.$code,
                                        placeholder: "Введите код",
                                        icon: Image(systemName: "keyboard"))
                            .autocapitalization(.none)
                            
                            LCButton(text: "Отправить",
                                     disabled: !self.$code.wrappedValue.isEmpty){
                                        self.processing = true
                                        self.error = .NoException
                                        AppState.loginWithCode(code: self.code,
                                            onError:{error in
                                                
                                            self.error = error
                                            self.processing = false
                                        })
                                        {
                                            print("success")
                                            self.processing = false
                                        }
                            }
                            
                        } else {
                        
                            LCTextfield(value: self.$email,
                                        placeholder: "Email",
                                        icon: Image(systemName: "at"),
                                        valid:self.$email.wrappedValue.isEmpty || self.$email.wrappedValue.isValidEmail())
                            .autocapitalization(.none)
                            
                            LCButton(text: "Восстановить пароль",
                                     disabled: !self.$email.wrappedValue.isValidEmail()){
                                        
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
                            }
                    }
                }.alert(isPresented: .constant(error.hasError)){
                    Alert(title:
                        Text(error.description),
                        dismissButton:
                        .default(Text("Ок")){
                            self.error = .NoException
                        }
                    )
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
