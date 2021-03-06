//
//  ContentView.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 25.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct AppView: View {
    
    @ObservedObject var appState : AppState = AppState()
    
//    @ViewBuilder
    var body: some View {
        VStack{
            List(appState.quotations){
                quotation in
                Text(String(quotation.number))
            }
            Text(String(appState.quotations.count))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
