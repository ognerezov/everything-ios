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
                self.show = false
                AppState.set(to: 1)
            }
            if AppState.canCollapse() {
                ImageButton(
                    text : "Закрыть слои",
                    icon: "doc.on.doc.fill"){
                    self.show = false
                    AppState.collapse()
                }
            }
            ImageButton(
                text : "Числа дня",
                icon: "calendar"){

                AppState.getNumbersOfTheDay()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.show = false
                }
            }
            LCTextfield(value: self.$searchString,
                        placeholder: "Введите число или текст",
                        icon: Image(systemName: "magnifyingglass"))
                    .autocapitalization(.none)
            ImageButton(
                text : "Поиск",
                icon: "magnifyingglass",
                action: {
                    self.search()
                    self.show = false
                }, disabled:  self.$searchString.wrappedValue.count == 0)
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
