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
    
    func accessGranted(with accessCode: String) {
        self.accessCode = accessCode
        self.hasAccess = true
        save()
    }
}


/*
    MARK: Constants
*/
extension User{
    static let DEFAULTS_KEY : String = "user"
    static let READER_ROLE : String = "ROLE_READER"
    static let readerUsername : String = "reader"
}

/*
    MARK: Singleton
 */

extension User{
    
       static func save(_ user: User){
        do{
            try KeyChainStore.addSecret(for: readerUsername, with: user.accessCode)
        }catch{
            print(error)
        }
           //UserDefaults.standard.set(user, forKey: DEFAULTS_KEY )
       }
       
       static func load()->User{
            let user = User()
            do{
                user.accessCode = try KeyChainStore.getSecret(for: readerUsername)
//                print(user.accessCode)
            }catch{
                print(error)
            }
           return user
       }
       
       private static var _user : User?
       
       static var user : User{
           
           get{
               if let res = _user{
                    return res
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
