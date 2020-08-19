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
            BookView(chapters: state.chapters)
                .background(Color.main)
                .alert(isPresented: Binding.constant($state.error.hasError.wrappedValue)){
                    alert
            }
        }else{
            LogoutScreen(chapters: state.quotations, user : state.user)
            .background(Color.main)
            .alert(isPresented: Binding.constant($state.error.hasError.wrappedValue)){
                alert
            }
        }
    }
    
    var alert : Alert{
        Alert(title:
            Text($state.error.wrappedValue.description),
            primaryButton:
            .default(Text("Повторить")){
                AppState.noException()
                LogoutControl.alert()
            },
            secondaryButton:
            .destructive(Text("Закрыть")){AppState.noException()})
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            AppView()
            .environment(\.colorScheme, .dark)
            AppView()
            .environment(\.colorScheme, .light)
        }
    }
}

#endif
