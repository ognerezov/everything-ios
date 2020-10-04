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
    @State private var showRegistration : Bool = false
    @State private var showLogin : Bool = false
    @State private var email = ""
    @State private var password = ""
    @State private var confirmedPassword = ""
    var user : User?
    var storeObserver : StoreObserver
    let textListener = TextListener()
    
    var body: some View {
        
        var isLoggedIn = false
        if let currentUser = user{
            isLoggedIn = currentUser.username != nil
        }
        
        return HStack{
            if isLoggedIn{
                if (storeObserver.productAvailable){
                Button(action: {
                    storeObserver.purchase()
                }){
                    ZStack{
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.contrastColor)
                        .frame(width: 167, height: 52)
                        HStack{
                            Image(systemName: "cart")
                                .foregroundColor(Color.main)
                            Text("Доступ")
                            .font(.custom("Roboto Black", size: 14))
                                .foregroundColor(Color.main)
                            .tracking(0.52)
                            .multilineTextAlignment(.center)
                        }
                    }
                }
                } else{
                    EmptyView()
                }
                
            } else{
                
                Button(action: {
                    self.showRegistration = true
                }){
                    ZStack{
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.contrastColor)
                        .frame(width: 167, height: 52)

                        HStack{
                            Image(systemName: "person")
                                .foregroundColor(Color.main)
                            Text("Войти")
                            .font(.custom("Roboto Black", size: 14))
                                .foregroundColor(Color.main)
                            .tracking(0.52)
                            .multilineTextAlignment(.center)
                        }
                    }
                }.sheet(isPresented: $showRegistration){
                    self.signUp
                }
            }
            
            Button(action: {
                self.alert()
            }){
                ZStack{
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.contrastColor)
                    .frame(width: 167, height: 52)
                    HStack{
                        Image(systemName: "key")
                            .foregroundColor(Color.main)
                        Text("Читать")
                        .font(.custom("Roboto Black", size: 14))
                            .foregroundColor(Color.main)
                        .tracking(0.52)
                        .multilineTextAlignment(.center)
                    }
                }
            }
            .sheet(isPresented: $showLogin){
                LoginView(show: self.$showLogin, showRegister : self.$showRegistration, email: self.$email, password: self.$password){
                    self.message("Вы успешно авторизованы в системе"){
                        self.showLogin = false
                    }
                }.transition(.move(edge: .bottom))
            }
        }.padding()
    }
    
    @ViewBuilder
    var signUp: some View {
        SignupView(show: self.$showRegistration, showLogin : self.$showLogin, email: self.$email, password: self.$password, confirmedPassword: self.$confirmedPassword){
          self.registerAlert()
        }.transition(.move(edge: .bottom))
    }
    
    func registerAlert(){
        alert(LogoutControl.registerAlertTitle + email)
    }
    
    func alert() {
        alert(LogoutControl.defaultAlertTitle)
    }
    
    func alert(_ title: String) {
        let alert = UIAlertController(title: title, message: "Введите код ", preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.placeholder = "Код доступа"
            textField.delegate = self.textListener
            textField.keyboardType = .numberPad
        }
        
        alert.addAction(UIAlertAction(title: "Ввод", style: .default) { _ in
            if let code = self.textListener.text {
                print("login with "+code)
                AppState.setAccessCode(code){
                    self.alert()
                }
            } else{
                print("no code")
            }
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive) { _ in})

        UIKitTools.showAlert(alert: alert)
    }
    
    func message(_ title: String, do action: @escaping ()->Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ок", style: .default) { _ in action()})

        UIKitTools.showAlert(alert: alert)
    }
    
}

//MARK: static

extension LogoutControl{
    static let defaultAlertTitle = "Авторизация с помощью кода доступа"
    static let registerAlertTitle = "Код доступа выслан на email "
}

//MARK: singleton

extension LogoutControl{
    static var instance : LogoutControl?
    
    static func get(for state: AppState) -> LogoutControl{
        instance = LogoutControl(user: state.user, storeObserver: state.storeObserver)
        return instance!
    }
    
    static func alert(){
        if let logoutControl = instance{
            logoutControl.alert()
        }else{
            print("Logout control is nil")
        }
    }
    
    static func loginSuccess(do action: @escaping ()->Void){
        if let logoutControl = instance{
            logoutControl.message("Вы успешно авторизованы в системе", do: action)
        }
    }
}

#if DEBUG
struct LogoutControl_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            LogoutControl(user: nil, storeObserver: StoreObserver())
                        .environment(\.colorScheme, .light)
                LogoutControl(user: nil, storeObserver: StoreObserver())
                        .environment(\.colorScheme, .dark)
        }
    }
}
#endif
