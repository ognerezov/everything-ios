//
//  LogoutScreen.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 26.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct LogoutScreen: View {
    var chapters : [Chapter]
    var user : User?
    var body: some View {
        VStack{
            QuotationsView(chapters: chapters)
            Spacer()
            LogoutControl.get(for : self.user)
        }
    }
}

struct LogoutScreen_Previews: PreviewProvider {
    static var previews: some View {
        LogoutScreen(chapters: [], user: nil)
    }
}
