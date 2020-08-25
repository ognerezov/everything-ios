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
        ZStack{
            if(state.user.canRead){
                BookView(chapters: state.chapters, settings : $state.settings.wrappedValue)
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
            if state.error == .Processing{
                VStack{
                    Spacer()
                    ZStack{
                        Rectangle()
                            .fill(Color.main)
                            .frame(maxHeight: 60)
                        InifnityBar(value: 0)
                            .frame(maxHeight: 20)
                    }
                    Spacer()
                }
            } else{
                EmptyView()
            }
        }
        
    }
    
    var alert : Alert{
        Alert(title:
            Text($state.error.wrappedValue.description),
            primaryButton:
            .default(Text("Повторить")){
                AppState.noException()
                AppState.runAllertAction()
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
