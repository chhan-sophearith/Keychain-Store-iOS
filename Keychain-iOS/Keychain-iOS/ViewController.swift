//
//  ViewController.swift
//  Keychain-iOS
//
//  Created by Chhan Sophearith on 19/10/23.
//

import UIKit
import Security

class ViewController: UIViewController {
    

    let service = "com.yourDomain.Keychain-iOS"
    @IBOutlet weak var secretKeyTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapAdd(_ sender: Any) {
        
        let account = accountTextField.text ?? ""
        let password =  secretKeyTextField.text ?? ""

        do {
            let result = try Keychain.shared.saveKeychainGroup(account: account, data: password)
//        //    let retrieved = String(data: result, encoding: .utf8)
//            let alert = UIAlertController(title: "Secret", message: retrieved, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "ok", style: .cancel))
//            present(alert, animated: true)
        } catch {
            print("Keychain error: \(error)")
        }
        
        /*
        do {
            let passwordData = password.data(using: .utf8)!
            try Keychain.shared.saveToKeychain(service: service, account: account, data: passwordData)
//
//            let retrievedData = try Keychain.shared.loadFromKeychain(service: service, account: account)
//            let retrieved = String(data: retrievedData, encoding: .utf8)
//            print("Retrieved: \(retrieved ?? "")")

//            let updatedPassword = "newsecretpassword"
//            let updatedPasswordData = updatedPassword.data(using: .utf8)!
//            try updateKeychain(service: service, account: account, data: updatedPasswordData)
//
//            let updatedData = try loadFromKeychain(service: service, account: account)
//            let updatedPassword = String(data: updatedData, encoding: .utf8)
//            print("Updated password: \(updatedPassword ?? "")")
//
//            try deleteFromKeychain(service: service, account: account)
        } catch let error as NSError {
            print("Keychain error: \(error)")
        }
         */
    }
    
    @IBAction func tapShow(_ sender: Any) {

        let account = accountTextField.text ?? ""
    //    let password = secretKeyTextField.text ?? ""

        do {
            let retrievedData = try Keychain.shared.loadFromKeychain(service: service, account: account)
            let retrieved = String(data: retrievedData, encoding: .utf8)
            print("Retrieved: \(retrieved ?? "")")
            
            let alert = UIAlertController(title: "Secret", message: retrieved, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .cancel))
            present(alert, animated: true)
//            let updatedPassword = "newsecretpassword"
//            let updatedPasswordData = updatedPassword.data(using: .utf8)!
//            try updateKeychain(service: service, account: account, data: updatedPasswordData)
//
//            let updatedData = try loadFromKeychain(service: service, account: account)
//            let updatedPassword = String(data: updatedData, encoding: .utf8)
//            print("Updated password: \(updatedPassword ?? "")")
//
//            try deleteFromKeychain(service: service, account: account)
        } catch let error as NSError {
            print("Keychain error: \(error)")
        }
        
        
        
        
    }
}

