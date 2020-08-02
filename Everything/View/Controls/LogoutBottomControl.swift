//
//  LogoutBottomControl.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 26.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct LogoutBottomControl: View {
    @State private var showLogin: Bool = false
    var body: some View {
        Button(action: {self.showLogin = true}){
            ZStack{
                RoundedRectangle(cornerRadius: 6)
                .fill(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                .frame(width: 167, height: 52)

                Text("Войти")
                .font(.custom("Roboto Black", size: 15))
                .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                .tracking(0.52)
                .multilineTextAlignment(.center)
            }.padding()
        }.sheet(isPresented: self.$showLogin){
            LoginDialog(show : self.$showLogin)
        }
    }
}

struct LogoutBottomControl_Previews: PreviewProvider {
    static var previews: some View {
        LogoutBottomControl()
    }
}
