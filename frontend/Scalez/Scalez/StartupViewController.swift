//
//  StartupViewController.swift
//  Scalez
//
//  Created by Gurion on 11/15/18.
//  Copyright © 2018 OOSE. All rights reserved.
//

import Foundation
import UIKit

class StartupViewController : UIViewController {
    var firstname: String = ""
    var lastname: String = ""
    var username: String = ""
    var password: String = ""

    @IBOutlet var createAccount: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logIn(_ sender: Any) {
        self.loginAlert()
    }
    
    func loginAlert() {
        let alert = UIAlertController(title: "Please Log In", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "First Name"
        }
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Last Name"
        }
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Username"
        }
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        let loginAction = UIAlertAction(title: "Login", style: .default) { action in

            let firstnameField = alert.textFields![0] as UITextField
            let lastnameField = alert.textFields![1] as UITextField
            let usernameField = alert.textFields![2] as UITextField
            let passwordField = alert.textFields![3] as UITextField
            
            self.firstname = firstnameField.text!
            self.lastname = lastnameField.text!
            self.username = usernameField.text!
            self.password = passwordField.text!
            
            self.postUserData()
            self.setUserDefaults()
            
            self.performSegue(withIdentifier: "Login" , sender: self)
        }
        

        alert.addAction(loginAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func setUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "Login")
        defaults.set(self.firstname, forKey: "firstname")
        defaults.set(self.lastname, forKey: "lastname")
        defaults.set(self.username, forKey: "username")
        defaults.set(self.password, forKey: "password")
        
    }
    
    func postUserData() {
        let parameters = ["username": self.username, "password" : self.password, "firstname" : self.firstname, "lastname" : self.lastname]
        
        guard let url = URL(string: "https://testdeployment-scalez.herokuapp.com/user/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if data != nil {
                do {
                    
                } catch {
                    print("This is the error being printed error")
                }
            }
            }.resume()
    }
    
}
