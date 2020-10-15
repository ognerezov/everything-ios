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
    
    static func dummy()->Chapter{
        return Chapter(number: -1, type: .chapter, level: 1, records: [])
    }
    
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
    
    static var numberOfTheDay : Int{
        get{
            
            let calanderDate = Calendar.current.dateComponents([.day, .year, .month], from: Date())
            let day = calanderDate.day!
            let month = calanderDate.month!
            let year = reduce(calanderDate.year!)
        
            var res = day
            
            if month > res && month <= max{
                res  = month
            }
            
            if year > res && year <= max{
                res = year
            }
            
            let dm = day * month
            let dy  = day * year
            let my = month * year
            let dmy = dm * year
            
            if dm > res && dm <= max{
                res = dm
            }
            
            if dy > res && dy <= max {
                res = dy
            }
            
            if my > res && my <= max{
                res = my
            }
            
            if dmy > res && dmy <= max{
                res = dmy
            }
            
            
            return res
        }
    }
    
    static func reduce(_ number: Int) -> Int{
        var res = 0
        var n = number
        
        repeat {
            res += n % 10
            n = n / 10
        } while n > 0
    
        return res
    }
    
    static func empty(number: Int) ->Chapter{
        return Chapter(number: number, type: .chapter, level: 0, records: [])
    }
}
