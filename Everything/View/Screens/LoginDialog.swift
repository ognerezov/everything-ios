//
//  LoginDialog.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 01.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct LoginDialog: View {
    @State var accessCode : String = ""
    @Binding var show : Bool
    var body: some View {
        VStack{
            Text("Зарегистрируйтесь чтобы получить код дотсупа к книге")
                .font(.custom("Roboto Black", size: 20))
                .padding()
            Text("Введите email")
                .font(.custom("Roboto Black", size: 15))
                .foregroundColor(Color.accentDark)
                .multilineTextAlignment(.leading)
            ZStack{
                TextField("Email", text: $accessCode)
                    .autocapitalization(.none)
                    .padding()
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.accentDark)
                    .frame(height: 40)
                    .padding(.horizontal)
                
            }
//                Text("Пароль")
                ZStack{
                    TextField("Пароль", text: $accessCode)
                        .autocapitalization(.none)
                        .padding()
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.accentDark)
                        .frame(height: 40)
                        .padding(.horizontal)
                }
//                Text("Повторите пароль")
                ZStack{
                    TextField("Подтвердите пароль", text: $accessCode)
                        .autocapitalization(.none)
                        .padding()
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.accentDark)
                        .frame(height: 40)
                        .padding(.horizontal)
                    
                }
            Spacer()
        }
    }
}
#if DEBUG
struct LoginDialog_Previews: PreviewProvider {
    static var previews: some View {
        LoginDialog(show: .constant(true))
    }
}
#endif
