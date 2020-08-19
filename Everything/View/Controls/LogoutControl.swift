//
//  LogoutBottomControl.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 26.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI
import UIKit

struct LogoutControl: View {
    
    @State private var accessCode : String?
    @State private var showLogin : Bool = false
    
    var user : User?
    let textListener = TextListener()
    
    var body: some View {
        
        var isLoggedIn = false
        if let currentUser = user{
            isLoggedIn = currentUser.username != nil
        }
        
        return HStack{
            if isLoggedIn{
                Button(action: {
                    self.showLogin = true
                }){
                    ZStack{
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.contrastColor)
                        .frame(width: 167, height: 52)

                        Text("Постоянный доступ")
                        .font(.custom("Roboto Black", size: 15))
                            .foregroundColor(Color.main)
                        .tracking(0.52)
                        .multilineTextAlignment(.center)
                    }
                }.sheet(isPresented: $showLogin){
                  //  LoginDialog(show : self.$showLogin)
                    SignupView().transition(.move(edge: .bottom))
                }
                
            } else{
                
                Button(action: {
                    self.showLogin = true
                }){
                    ZStack{
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.contrastColor)
                        .frame(width: 167, height: 52)

                        Text("Войти")
                        .font(.custom("Roboto Black", size: 15))
                            .foregroundColor(Color.main)
                        .tracking(0.52)
                        .multilineTextAlignment(.center)
                    }
                }.sheet(isPresented: $showLogin){
                  //  LoginDialog(show : self.$showLogin)
                    SignupView().transition(.move(edge: .bottom))
                }
            }
            Button(action: {
                self.alert()
            }){
                ZStack{
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.contrastColor)
                    .frame(width: 167, height: 52)

                    Text("Читать")
                    .font(.custom("Roboto Black", size: 15))
                        .foregroundColor(Color.main)
                    .tracking(0.52)
                    .multilineTextAlignment(.center)
                }
            }
        }.padding()
    }
    
    func alert() {
        let alert = UIAlertController(title: "Авторизация с помощью кода доступа", message: "Введите код ", preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.placeholder = "Код доступа"
            textField.delegate = self.textListener
        }
        
        alert.addAction(UIAlertAction(title: "Ввод", style: .default) { _ in
            if let code = self.textListener.text {
                print("login with "+code)
                AppState.setAccessCode(code)
            } else{
                print("no code")
            }
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive) { _ in})

        UIKitTools.showAlert(alert: alert)
    }

    static var instance : LogoutControl?
    
    static func get(for user: User?) -> LogoutControl{
        instance = LogoutControl(user: user)
        return instance!
    }
    
    static func alert(){
        if let logoutControl = instance{
            logoutControl.alert()
        }else{
            print("Logout control is nil")
        }
    }
}

#if DEBUG
struct LogoutControl_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            LogoutControl()
                        .environment(\.colorScheme, .light)
                LogoutControl()
                        .environment(\.colorScheme, .dark)
        }
    }
}
#endif
