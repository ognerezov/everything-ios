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

        Form {
            Section(header: Text("Ввести кода доступа")){
                HStack{
                    TextField("Код доступа", text: $accessCode)
                    .autocapitalization(.none)
                    Button(action: {
                        self.show = false
                        AppState.setAccessCode(self.accessCode)
                    }){
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                            .fill(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                            .frame(width: 130, height: 40)
                            Text("Войти")
                            .font(.custom("Roboto Black", size: 15))
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                            .tracking(0.52)
                            .multilineTextAlignment(.center)
                        }
                    }.padding()
                }
            }
        }.padding()

    }
}
#if DEBUG
struct LoginDialog_Previews: PreviewProvider {
    static var previews: some View {
        LoginDialog(show: .constant(true))
    }
}
#endif
