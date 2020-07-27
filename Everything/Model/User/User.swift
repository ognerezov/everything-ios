//
//  User.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 25.07.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import Foundation

class User {
    var hasAccess : Bool?
    var accessCode : String?
    var token :String?
    var refreshToken :String?
    var username :String?
    var emailStatus :String?
    var roles : [String]?
    
    var isLoggedIn : Bool {
        return username != nil
    }
    
    var isReader : Bool {
        return roles != nil && roles!.contains(User.READER_ROLE)
    }
   
    var canRead : Bool{
        get{
            if let access = hasAccess{
                return access && accessCode != nil
            }
            return isReader
        }
    }
    
    func save(){
        User.save(self)
    }
}


/*
    Constants
 */

extension User{
    static let DEFAULTS_KEY : String = "user"
    static let READER_ROLE : String = "ROLE_READER"
}

/*
    Singleton
 */

extension User{
    
       static func save(_ user: User){
           UserDefaults.standard.set(user, forKey: DEFAULTS_KEY )
       }
       
       static func load()->User{
           if let user = UserDefaults.standard.value(forKey: DEFAULTS_KEY) as? User{
               return user
           }
           
           return User()
       }
       
       private static var _user : User?
       
       static var user : User{
           
           get{
               if let user = _user{
                   return user
               }
               _user = load()
               return _user!
           }
           
           set(val){
               _user = val
               save(val)
           }
       }
}
