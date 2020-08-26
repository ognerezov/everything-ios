//
//  BookTools.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 25.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct BookTools: View {
    @Binding var show : Bool
    @State var searchString : String = ""
    var body: some View {
        VStack{
            ImageButton(
                text : "Читать сначала",
                icon: "backward.end.fill"){
                AppState.set(to: 1)
                self.show = false
            }
            LCTextfield(value: self.$searchString,
                        placeholder: "Введите число или текст",
                        icon: Image(systemName: "magnifyingglass"))
                    .autocapitalization(.none)
            ImageButton(
                text : "Поиск",
                icon: "magnifyingglass",
                disabled:  self.$searchString.wrappedValue.count == 0){
                    self.search()
                    self.show = false
            }
        }.padding()
    }
    
    func search(){
        if let number = Int(searchString){
            AppState.set(to: number)
        } else{
            AppState.textSearch(searchString)
        }
    }
}

struct BookTools_Previews: PreviewProvider {
    static var previews: some View {
        BookTools(show: .constant(true))
    }
}
