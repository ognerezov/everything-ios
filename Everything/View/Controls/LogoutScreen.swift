//
//  LogoutScreen.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 26.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct LogoutScreen: View {
    @ObservedObject var state : AppState
    
    var body: some View {
        VStack{
            QuotationsView(state: state)
            Spacer()
            LogoutControl.get(for : self.state.user)
        }
    }
}

struct LogoutScreen_Previews: PreviewProvider {
    static var previews: some View {
        LogoutScreen(state: AppState())
    }
}
