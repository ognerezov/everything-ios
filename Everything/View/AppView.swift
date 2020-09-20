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
        VStack{
            if(state.hasInternetConnection || state.hasContent){
                if(state.user.canRead){
                    BookView(state : state)
                        .background(Color.main)
                        .alert(isPresented: Binding.constant($state.error.hasError.wrappedValue)){
                            alert
                    }
                }else{
                    LogoutScreen(state: state)
                    .background(Color.main)
                    .alert(isPresented: Binding.constant($state.error.hasError.wrappedValue)){
                        alert
                    }
                }
            } else {
                Image(systemName:"wifi.exclamationmark")
                    .foregroundColor(Color.accentLight)
                    .scaledToFill()
                    .padding()
                Text("Отсутствует интернет-соединение")
                    
            }
        }
        
    }
    
    
    var alert : Alert{
        if state.hasAllertAction{
            return Alert(title:
                Text($state.error.wrappedValue.description),
                primaryButton:
                .default(Text("Повторить")){
                    AppState.noException()
                    AppState.runAllertAction()
                },
                secondaryButton:
                .destructive(Text("Закрыть")){AppState.noException()})
        } else{
            return Alert(title:
                Text($state.error.wrappedValue.description),
                dismissButton:
                .default(Text("Закрыть")){AppState.noException()})
        }
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
