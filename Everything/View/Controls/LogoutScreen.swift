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
            .sheet(isPresented: .constant($state.chapterOfTheDay.wrappedValue != nil),
                    onDismiss: {AppState.dismissNumberOfTheDay()}){
                NumberOfTheDayView(chapter: self.state.chapterOfTheDay!, state: self.state)
            }
            Spacer()
            LogoutControl.get(for : self.state)
        }
    }
}

struct LogoutScreen_Previews: PreviewProvider {
    static var previews: some View {
        LogoutScreen(state: AppState())
    }
}
