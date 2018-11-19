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
        
        if (u.isEmpty || p.isEmpty) {
            return
        }
        self.handleLogIn(u:u, p:p)
    }
    
    func handleLogIn(u : String, p : String) {
        self.username = u
        self.password = self.passwordHash(u: u, p: p)
        logInToServer()
        if (UserDefaults.standard.bool(forKey: "isLoggedIn")) {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "RecordVC") as! RecordViewController
            present(next, animated: true, completion: nil)
        }
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
    
    func okButtonAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func loginErrorAlert() {
        self.okButtonAlert(title: "Invalid username or password", message: "Please try again")
    }
    
    func logInToServer() {
        let parameters = ["username": self.username, "password" : self.passwordHash(u: self.username, p: self.password)]
        print(parameters)
        let urlString = "https://testdeployment-scalez.herokuapp.com/user/login"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            print("response")
            print(response)
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                print("Status Code")
                print(statusCode)
                if (statusCode == 200) {
                    DispatchQueue.main.async {
                        self.setUserDefaults()
                    }
                } else if (statusCode == 404) {
                    DispatchQueue.main.async {
                        self.loginErrorAlert()
                    }
                }
            }
        }
        task.resume()
    }
}

