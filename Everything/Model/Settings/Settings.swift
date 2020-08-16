//
//  Settings.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 15.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import Foundation

class Settings{
    var layers = [1]
    
    func setTop(to number: Int){
        layers[layers.count - 1] = number
        save()
    }
    
    func save(){
        Settings.save(self)
    }
}

/*
    MARK: static
*/

extension Settings{
    static func save (_ settings: Settings){
        UserDefaults.standard.set(settings.layers, forKey: layers_key)
    }
    
    static func load() -> Settings{
        let res = Settings()
        
        if let layers : [Int] = UserDefaults.standard.array(forKey: layers_key) as? [Int]{
            res.layers = layers
        }
        
        return res
    }
}

/*
    MARK: singleton
*/

extension Settings{
    
    static private var _settings : Settings?
    
    static var setting : Settings{
        get{
            if let s = _settings{
                return s
            }
            
            _settings = load()
            return _settings!
        }
        
        set(s){
            _settings = s
            save(s)
        }
    }
}

/*
    MARK: Constants
*/
extension Settings{
    static let layers_key = "Settings layers"
}


