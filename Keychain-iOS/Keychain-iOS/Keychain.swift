//
//  Keychain.swift
//  Keychain-iOS
//
//  Created by Chhan Sophearith on 19/10/23.
//

import Foundation
import Security

class Keychain {
    
    static let shared = Keychain()
    
    let KeychainErrorDomain = "com.yourDomain.Keychain-iOS"
    let KeychainItemNotFoundError = 1
    let KeychainItemCreationError = 2
    let KeychainItemUpdateError = 3
    let KeychainItemDeletionError = 4
    let KeychainItemDuplicateError = 5
    
    func saveKeychainGroup(account: String, data: String) throws {
        
        let itemData: Data = data.data(using: .utf8)!

        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrAccessGroup as String: "com.yourDomain.Keychain-iOS",
            kSecValueData as String: itemData
        ]

        let status = SecItemAdd(addQuery as CFDictionary, nil)
        if status != errSecSuccess {
            throw NSError(domain: KeychainErrorDomain, code: KeychainItemCreationError, userInfo: nil)
        } else {
            print("success....")
        }
    }
    
    func getKeychainGroup(account: String) throws -> Data {
        
        let keychainQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
             //   kSecAttrService as String: "com.chhan.Keychain-iOS",
                kSecAttrAccount as String: account,
                kSecAttrAccessGroup as String: "com.yourDomain.Keychain-iOS",
                kSecReturnData as String: kCFBooleanTrue!,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]

         //   var item: CFTypeRef?
         //   let status = SecItemCopyMatching(keychainQuery as CFDictionary, &item)
        
        var result: AnyObject?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &result)

        if status == errSecItemNotFound {
           throw NSError(domain: KeychainErrorDomain, code: KeychainItemNotFoundError, userInfo: nil)
        }
        
        guard let data = result as? Data else {
            throw NSError(domain: KeychainErrorDomain, code: KeychainItemCreationError, userInfo: nil)
        }

        return data
    }
    
    func saveToKeychain(service: String, account: String, data: Data) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: data
        ] as [String: Any]

        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            throw NSError(domain: KeychainErrorDomain, code: KeychainItemDuplicateError, userInfo: nil)
        }

        if status != errSecSuccess {
            throw NSError(domain: KeychainErrorDomain, code: KeychainItemCreationError, userInfo: nil)
        }
    }

    func loadFromKeychain(service: String, account: String) throws -> Data {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true
        ] as [String: Any]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status != errSecSuccess {
            throw NSError(domain: KeychainErrorDomain, code: KeychainItemNotFoundError, userInfo: nil)
        }

        guard let data = result as? Data else {
            throw NSError(domain: KeychainErrorDomain, code: KeychainItemCreationError, userInfo: nil)
        }

        return data
    }

    func updateKeychain(service: String, account: String, data: Data) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as [String: Any]

        let attributes = [
            kSecValueData: data
        ] as [String: Any]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

        if status != errSecSuccess {
            throw NSError(domain: KeychainErrorDomain, code: KeychainItemUpdateError, userInfo: nil)
        }
    }

    func deleteFromKeychain(service: String, account: String) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as [String: Any]

        let status = SecItemDelete(query as CFDictionary)

        if status != errSecSuccess {
            throw NSError(domain: KeychainErrorDomain, code: KeychainItemDeletionError, userInfo: nil)
        }
    }
}
