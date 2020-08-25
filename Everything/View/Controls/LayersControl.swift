//
//  LayersControl.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 23.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct LayersControl: View {
    var collumns = 4
    var selected : Int?
    var layers : [Int]
    var onClick : (_ : Int) -> Void
    
    var grid : [[Int]]{
        get{
            var result : [[Int]] = [[]]
            
            let rows : Int = layers.count / collumns
            
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
            ScrollView(.vertical, showsIndicators: false){
            ForEach(grid, id: \.self){
                row in
                HStack{
                    ForEach(row, id: \.self){
                        element in
                        ChapterSelector (number: element, isSelected: element == self.selectedItem , onClick: self.onClick)

                    }
                }.padding(.horizontal)
            }
        }
    }
    }
}

#if DEBUG
struct LayersControl_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            LayersControl(layers: [1,2,33,44,105,177]){
                _ in
            }
            LayersControl(layers: [1]){
                _ in
            }
        }
    }
}
#endif