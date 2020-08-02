//
//  InifnityBar.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 01.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct InifnityBar: View {
    @State var value: Float = 0
    var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ProgressBar(value: $value)
            .onAppear(perform: restart)
            .onReceive(timer){
                input in
                self.value = self.value >= 1 ? 0 : self.value + 0.01
        }
    }
    
    func restart(){
        value = 0
    }
    
}

struct InifnityBar_Previews: PreviewProvider {
    static var previews: some View {
        InifnityBar()
    }
}
