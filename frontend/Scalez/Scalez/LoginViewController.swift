//
//  LoginViewController.swift
//  Scalez
//
//  Created by Gurion on 11/15/18.
//  Copyright © 2018 OOSE. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

class LoginViewController : UIViewController {
    var username: String = ""
    var password: String = ""
    var isLoggedIn: Bool = false
    
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var createAccount: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var createAccountButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.setImage(UIImage(named: "sign_in"), for: .normal)
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
    
    @IBAction func logInButton(_ sender: Any) {
        let u = usernameField.text!
        let p = passwordField.text!
        
        if (u.isEqual("") || p.isEqual("")) {
            return
        }
        self.handleLogIn(u:u, p:p)
    }
    
    func handleLogIn(u : String, p : String) {
        self.username = u
        self.password = p
        logInToServer()
        present(RecordViewController(), animated: true, completion: nil)
    }
    
    func passwordHash(u : String, p : String) -> String {
        return "\(p).\(u)".sha256()
    }
    
    func setUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "isLoggedIn")
        defaults.set(self.username, forKey: "username")
        defaults.set("https://testdeployment-scalez.herokuapp.com/user/\(self.username)", forKey: "userUrl")
    }
    
    func loginErrorAlert() {
        let alert = UIAlertController(title: "Invalid username or password.", message: "Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func errorHandling(statusCode : Int) {
        if (statusCode == 200) {
            self.setUserDefaults()
        } else {
            self.loginErrorAlert()
        }
    }
    
    func logInToServer() {
        let parameters = ["username": self.username, "password" : self.password]
        
        guard let url = URL(string: "https://testdeployment-scalez.herokuapp.com/user/login?username=\(self.username)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print(response)
//                self.errorHandling(statusCode: response.statusCode)
            }
            if data != nil {
                do {
                    
                } catch {
                    print("This is the error being printed error")
                }
            }
            }
        task.resume()
    }
    
}

