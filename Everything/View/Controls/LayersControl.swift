//
//  LayersControl.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 23.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct LayersControl: View {
    var collumns = 6
    var selected : Int?
    var layers : [Int]
    var vPadding = 5
    var fontSize = 12
    var optional = false
    var onClick : (_ : Int) -> Void
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    
    var maxRows : Int{
        verticalSizeClass == .compact ? 3 : 6
    }
    
    var grid : [[Int]]{
        get{
            var result : [[Int]] = [[]]
            
            var rows : Int = layers.count / collumns
            
            rows = rows > maxRows ? maxRows : rows
            
            for j in 0...rows{
                result.append([])
                
                var i = j * collumns
                
                while i < layers.count && i < (j+1) * collumns {
                    result [j].append(layers[i])
                    i += 1
                }
            }
            
            return result
        }
    }
    
    var selectedItem : Int{
        if let res = selected{
            return layers [res]
        }
        return layers [layers.count - 1]
    }
    
    @ViewBuilder
    var body: some View {
        if layers.count < 2{
            EmptyView()
        } else{
            ZStack{
                if optional {
                    EmptyView()
                } else {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.accentDark)
                }

                VStack{
                ForEach(grid, id: \.self){
                    row in
                    HStack{
                        ForEach(row, id: \.self){
                            element in
                            ChapterSelector (number: element,
                                             isSelected: self.optional ? false : element == self.selectedItem ,
                                             onClick: self.onClick,
                                             fontSize: self.fontSize,
                                             hasContrast : self.optional )
                        }
                    }.padding(.horizontal)
                }.padding(.bottom, CGFloat(vPadding))
                }.padding(.top, CGFloat(vPadding))
            }
            .frame(maxHeight: CGFloat((fontSize + 2 + 2 * vPadding) * (grid.count)) , alignment : .top)
        }
    }
}

#if DEBUG
struct LayersControl_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            LayersControl(layers: [1,2,33,44,105,177, 1000, 233,234, 567]){
                _ in
            }
            LayersControl(layers: [1]){
                _ in
            }
        }
    }
}
#endif
