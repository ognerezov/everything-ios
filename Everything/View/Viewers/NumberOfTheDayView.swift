//
//  NumberOfTheDayView.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 04.09.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct NumberOfTheDayView: View {
    var chapter: Chapter
    @ObservedObject var state : AppState
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.contrastColor)
                Text("Число дня")
                    .foregroundColor(Color.main)
                    .padding(.horizontal)
            }.scaledToFit()
            ChapterViewer(chapter: chapter, interactable: false, state: state)
        }
    }
}


