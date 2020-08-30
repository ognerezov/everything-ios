//
//  Chapter.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 25.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import Foundation


struct Chapter : Codable, Identifiable, Hashable{
    
    static func == (lhs: Chapter, rhs: Chapter) -> Bool {
        return lhs.number == rhs.number
    }
    
    func hash(into hasher: inout Hasher){
        hasher.combine(number)
    }
    
    var id : Int {
        return number
    }
    let number : Int
    let type : RecordType
    let level : Int
    let records : [Record]
}

extension Chapter{
    static var max = 231
    
    static func build(from number : Int) -> Chapter {
        let level = Book.getLevel(number)
        let dividers = Book.getDividers(number)
        var root : Int?

        if dividers.count % 2 != 0{
            root = dividers[dividers.count / 2]
        }
        
        var records : [Record] = [
            Record(number: number, type: .chapter, spans: [
                Span(text: String(number), number: true),
                Span(text: ". Этого числа еще нет в книге", number: false)
            ]),
            Record(number: number, type: .level, spans: [
                Span(text: "Число находится на уровне ", number: false),
                Span(text: String(level), number: true)
            ])
        ]
        
        if let squareRoot = root{
            records.append(Record(number: number, type: .rule, spans: [
                Span(text: String(number), number: true),
                Span(text: " = ", number: false),
                Span(text: String(squareRoot), number: true),
                Span(text: " ^ ", number: false),
                Span(text: "2", number: true)
            ]))
        }
        
        for i in 0..<dividers.count / 2{
            records.append(Record(number: number, type: .ruleBody, spans: [
                Span(text: String(number), number: true),
                Span(text: " = ", number: false),
                Span(text: String(dividers[dividers.count - 1 - i]), number: true),
                Span(text: " x ", number: false),
                Span(text: String(dividers[i]), number: true)
            
            ]))
        }
        if records.count == 2 {
            records.append(Record(number: number, type: .quotation, spans: [
                Span(text: "Это простое число - абсолютно новый принцип", number: false),
            ]))
            
        }

        return Chapter(number: number, type: .chapter, level: level, records: records)
    }
}
