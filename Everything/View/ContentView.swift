//
//  ContentView.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 25.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var quoutationDao : Quoutations = Quoutations()
    
    var body: some View {
        Text(String(quoutationDao.quotations.count))
    
     .onAppear {
        self.quoutationDao.fetchPublish()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
