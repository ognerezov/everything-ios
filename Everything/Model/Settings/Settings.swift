//
//  Settings.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 15.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import Foundation

struct Settings{
    var layers = [1]
    var selected : Int?
    
    var top : Int{
        layers[layers.count - 1]
    }
    
    var selectedValue : Int {
        layers[selected ?? layers.count - 1]
    }
    
    fileprivate func getChapterOfNumber(_ chapters: [Chapter], _ number: Int) -> Chapter {
        if let result = chapters.first(where: {chapter in return chapter.number == number}){
            return result
        }
        return chapters [chapters.count - 1]
    }
    
    func chapter(from chapters: [Chapter]) -> Chapter{
        let number = selectedValue
        return getChapterOfNumber(chapters, number)
    }
    
    func underChapter(from chapters: [Chapter]) -> Chapter{
        
        let number = layers[0]
        
        return getChapterOfNumber(chapters, number)
    }
    
    mutating func clone(){
        self = Settings(layers: self.layers, selected: self.selected)
    }
    
    mutating func setTop(to number: Int) -> Bool{
        var result = false
        if layers.firstIndex(of: number) != nil{
            result = true
        }
        layers[layers.count - 1] = number
        clone()
        save()
        return result
    }
    
    mutating func addTop(number : Int) -> Bool{
        var result = false
        if let i = layers.firstIndex(of: number){
            layers.remove(at: i)
            result = true
        } 
        layers.append(number);
        clone()
        save()
        return result
    }
    
    mutating func cutTop(){
        if layers.count < 2 {
            return
        }
        layers.remove(at: layers.count - 1)
        clone()
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
        if let selected = settings.selected{
            UserDefaults.standard.set(selected, forKey: selected_key)
        } else{
            UserDefaults.standard.removeObject(forKey: selected_key)
        }

    }
    
    static func load() -> Settings{
        var res = Settings()
        
        if let layers : [Int] = UserDefaults.standard.array(forKey: layers_key) as? [Int]{
            res.layers = layers
        }
        
        let selected  = UserDefaults.standard.integer(forKey: selected_key)
        if selected < res.layers.count && selected > 0{
            res.selected = selected
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
    static let selected_key = "Settings selected"
}


