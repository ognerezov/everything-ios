//
//  ContentView.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 25.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct AppView: View {
    
    @ObservedObject var state : AppState = AppState()
    
    @ViewBuilder
    var body: some View {
        if(state.user.canRead){
            Text("Book")
        }else{
            LogoutScreen(chapters: state.quotations)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
