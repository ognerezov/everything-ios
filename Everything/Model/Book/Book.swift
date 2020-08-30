//
//  Book.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 30.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import Foundation

struct Book{
    
    static func getDividers(_ n : Int) -> [Int] {
        var min : Int  = 2
        var max : Int = n / 2
        var resMin : [Int] = []
        var resMax : [Int] = []
        
        while (min < max){
            let rem : Int = n % min
            if rem == 0{
                resMin.append(min);
                resMax.insert(max, at: 0);
            }
            min += 1
            max = n / min
            if min == max && min * max == n {
                resMin.append(min);
            }
        }

        resMin.append(contentsOf: resMax)
        return resMin;
    }
    
    static func getLevel(_ n : Int) -> Int {
        if (n <= 0){
            return 0
        }
        var res = 1
        var next = 3

        while (n > next){
            res += 1
            next += res + 1;
        }
        return res;
    }
}
