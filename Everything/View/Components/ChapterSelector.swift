//
//  ChapterSelector.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 24.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct ChapterSelector: View {
        var number : Int
        var isSelected : Bool = false
        var onClick : (_ : Int) -> Void
        
        @ViewBuilder
        var body: some View {

                Button(action:{
                    if !self.isSelected{
                        self.onClick(self.number)
                    }
                }){
                    ZStack{
                        RoundedRectangle(cornerRadius: 6)
                            .fill(isSelected ? Color.accentLight : Color.accentDark)
                        Text(String(self.number))
                            .foregroundColor(self.isSelected ? Color.contrastColor : Color.main)
                    }
                }
            
        }
    }

    struct ChapterSelector_Previews: PreviewProvider {
        static var previews: some View {
            ChapterSelector(number: 1){
                _ in
            }
        }
    }
