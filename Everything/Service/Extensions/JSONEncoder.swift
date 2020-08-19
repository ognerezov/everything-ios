//
//  JSONEncoder.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 19.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import Foundation

extension JSONEncoder{
    func optionalEncode<T: Encodable>(_ object: T) -> Data? {
        do{
            return try encode(object)
        }catch{
            print(error)
            return nil
        }
    }
}
