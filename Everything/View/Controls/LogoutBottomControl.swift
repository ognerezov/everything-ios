//
//  LogoutBottomControl.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 26.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI
import UIKit

struct LogoutBottomControl: View, TextConsumer {
    
    @State private var accessCode : String?
    
    let textListener = TextListener()
    
    var body: some View {
        Button(action: {
            self.alert()
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
            }.padding()
        }
    }
    
    func alert() {
        let alert = UIAlertController(title: "Авторизация с помощью кода доступа", message: "Введите код ", preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.placeholder = "Код доступа"
            self.textListener.addConsumer(key :"Logout screen",self)
            textField.delegate = self.textListener
        }
        
        alert.addAction(UIAlertAction(title: "Ввод", style: .default) { _ in
            if let code = self.accessCode {
                print("login with "+code)
                AppState.setAccessCode(code)
            } else{
                print("no code")
            }
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive) { _ in})

        UIKitTools.showAlert(alert: alert)
    }


    func receiveText(_ code: String?){
        accessCode = code
    }
}

struct LogoutBottomControl_Previews: PreviewProvider {
    static var previews: some View {
        Group{
                LogoutBottomControl()
                        .environment(\.colorScheme, .light)
                LogoutBottomControl()
                        .environment(\.colorScheme, .dark)
        }
    }
}
