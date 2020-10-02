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
    var fontSize = 16
    var numberOfTheDay : Int?
    var selected : Int?
    
    var top : Int{
        layers[layers.count - 1]
    }
    
    var selectedValue : Int {
        layers[selected ?? layers.count - 1]
    }
    
    var canCollapse : Bool{
        layers.count > 1
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
    
    func contains (_ number: Int) -> Bool{
        return layers.firstIndex(of: number) != nil
    }
    
    
    mutating func clone(){
        self = Settings(layers: self.layers, fontSize : self.fontSize, numberOfTheDay: self.numberOfTheDay, selected: self.selected)
    }
    
    mutating func sort(){
        layers.sort()
        clone()
        save()
    }
    
    mutating func increaseFont (){
        print(fontSize)
        if fontSize == Settings.maxFontSize {
            return
        }
        
        fontSize += 1
        clone()
        save()
    }
    
    mutating func decreaseFont (){
        print(fontSize)
        if fontSize == Settings.minFontSize {
            return
        }
        
        fontSize -= 1
        clone()
        save()
    }
    
    mutating func set(with numbers: [Int]){
        layers = numbers
        clone()
        save()
    }
    
    mutating func set(to number: Int) -> Bool{
        let result = contains(number)
        layers = [number]
        clone()
        save()
        return result
    }
    
    mutating func setTop(to number: Int) -> Bool{
        let result = contains(number)
        layers[layers.count - 1] = number
        clone()
        save()
        return result
    }
    
    mutating func collapse(){
        layers = [layers[0]]
        clone()
        save()
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
    
    mutating func setNumberOfTheDay(_ number: Int){
        numberOfTheDay = number
        clone()
        save()
    }
    
    mutating func validate (){
        var l = layers.filter(){ $0 > 0}
    
        if l.count > 0 && l.count == layers.count {
            return
        }
        
        if l.count == 0 {
            l = [1]
        }
        
        layers = l
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
        
        UserDefaults.standard.set(settings.numberOfTheDay, forKey: number_of_the_day_key)
        
        UserDefaults.standard.set(settings.fontSize,forKey: font_size_key)
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
        
        let size = UserDefaults.standard.integer(forKey: font_size_key)
        
        if size >= minFontSize && size <= maxFontSize {
            res.fontSize = size
        }
        
        res.numberOfTheDay = UserDefaults.standard.integer(forKey: number_of_the_day_key)
    
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
            var loaded = load()
            loaded.validate()
            
            _settings = loaded
            return loaded
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
    static let minFontSize = 8
    static let maxFontSize = 50
    static let layers_key = "Settings layers"
    static let selected_key = "Settings selected"
    static let font_size_key = "Settings font size"
    static let number_of_the_day_key = "Settings number of the day"
}


