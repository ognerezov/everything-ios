//
//  KeyChainStore.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 02.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import Foundation

enum KeychainError: Error {
    case noToken
    case noData
    case unexpectedTokenData
    case unhandledError(status: OSStatus)
}

class KeyChainStore{
    static let server = "everything-from.one"
    static let defaultUser = "default"
    
    static func addQuery(for username: String, with token: String) -> CFDictionary{
        return [kSecClass as String: kSecClassInternetPassword,
        kSecAttrAccount as String: username,
        kSecAttrServer as String: server,
        kSecValueData as String: token.data(using: String.Encoding.utf8)!] as CFDictionary
    }
    
    static func findQuery(for username: String) -> CFDictionary{
        return [kSecClass as String: kSecClassInternetPassword,
        kSecAttrServer as String: server,
        kSecAttrAccount as String: username,
        kSecMatchLimit as String: kSecMatchLimitOne,
        kSecReturnAttributes as String: true,
        kSecReturnData as String: true] as CFDictionary
    }
    
    static func query(_ username: String) -> CFDictionary {
        return [kSecClass as String: kSecClassInternetPassword,
                kSecAttrAccount as String: username,
                kSecAttrServer as String: server] as CFDictionary
    }
    
    static func saveData(_ data: Data?) throws{
        guard data != nil else {
            throw KeychainError.noToken
        }
        var query = [kSecClass as String: kSecClassInternetPassword,
                    kSecAttrAccount as String: defaultUser,
                    kSecAttrServer as String: server] as [String : Any]
        
        let delStatus = SecItemDelete(query as CFDictionary)
        print(delStatus)
        
        query[kSecValueData as String] = data!
        
        let status = SecItemAdd(query as CFDictionary, nil)
        print(status)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status) }
    }
    
    
    class func getData() throws -> Data? {
        let query = [kSecClass as String: kSecClassInternetPassword,
        kSecAttrServer as String: server,
        kSecAttrAccount as String: defaultUser,
        kSecMatchLimit as String: kSecMatchLimitOne,
        kSecReturnAttributes as String: true,
        kSecReturnData as String: true ] as [String : Any]

        var item: CFTypeRef?

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &item)

        guard status != errSecItemNotFound else { throw KeychainError.noData }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }

        
        if let existingItem = item as? [String : Any]{
            return existingItem[kSecValueData as String] as? Data
        }

        throw KeychainError.unexpectedTokenData
        
    }
    
    static func addSecret(for username: String, with token: String?) throws{
        guard token != nil else {
            throw KeychainError.noToken
        }
        let status = SecItemAdd(addQuery(for: username, with: token!), nil)
        print(status)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status) }
    }

    
    static func deleteSecret(for username: String) throws{
        let status = SecItemDelete(query(username))
        print("delete status: " + String(status))
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status) }
    }
    
    static func getSecret(for username: String) throws -> String{
        var item: CFTypeRef?
        let status = SecItemCopyMatching(findQuery(for: username), &item)
        guard status != errSecItemNotFound else { throw KeychainError.noToken }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }

        guard let existingItem = item as? [String : Any],
            let tokenData = existingItem[kSecValueData as String] as? Data,
            let token = String(data: tokenData, encoding: String.Encoding.utf8)
        else {
            throw KeychainError.unexpectedTokenData
        }
        
        return token
    }
}
