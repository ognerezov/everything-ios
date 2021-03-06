//
//  NumberSuggestionControl.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 02/10/2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct NumberSuggestionControl: View {
    @ObservedObject var state : AppState
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var k : Int {
        horizontalSizeClass == .regular ? 2 : 1
    }
    
    
    var body: some View {
        VStack{
            Text("Открыть статью об одном из этих чисел?")
                .padding()
            LayersControl(collumns : 4, layers : state.suggestedNumbers,
                          vPadding : 10 * k,
                          fontSize: 15 * k,
                          optional : true){number in
                AppState.add(number: number)
                state.suggestedNumbers = []
            }
        }
    }
}

