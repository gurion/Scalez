//
//  SignupViewController.swift
//  Scalez
//
//  Created by Gurion on 11/17/18.
//  Copyright © 2018 OOSE. All rights reserved.
//

import Foundation
import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet var firstnameField: UITextField!
    @IBOutlet var lastnameField: UITextField!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var checkPasswordField: UITextField!
    @IBOutlet var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        let f = firstnameField.text!
        let l = lastnameField.text!
        let u = usernameField.text!
        let p = passwordField.text!
        let q = checkPasswordField.text!
        
        if (f.isEmpty || l.isEmpty || u.isEmpty || p.isEmpty || q.isEmpty) {
            return
        } else if (self.checkIfPasswordsMatch()) {
            self.passwordsMatchAlert()
        } else {
            self.handleCreateAccount(f:f, l:l, u:u, p:p)
        }
    }
    
    func handleCreateAccount(f : String, l : String, u : String, p : String) {
        postDataToServer(f: f, l: l, u: u, p: p)
        if (UserDefaults.standard.bool(forKey: "isLoggedIn")) {
            present(RecordViewController(), animated: true, completion: nil)
        }
    }
    
    func checkIfPasswordsMatch() -> Bool {
        return self.passwordField.isEqual(self.checkPasswordField)
    }
    
    func passwordHash(u : String, p : String) -> String {
        return "\(p).\(u)".sha256()
    }
    
    func passwordsMatchAlert() {
        let alert = UIAlertController(title: "Password must match!", message: "Please re-enter you password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func usernameTakenAlert() {
            let alert = UIAlertController(title: "Username already taken!", message: "Please pick another username", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
    }
    
    func generalAlert() {
        let alert = UIAlertController(title: "Something went wrong", message: "Sorry! Please try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func setUserDefaults(u : String) {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "isLoggedIn")
        defaults.set(u, forKey: "username")
        defaults.set("https://testdeployment-scalez.herokuapp.com/user/\(u)", forKey: "userUrl")
    }
    
    func postDataToServer(f : String, l : String, u : String, p : String) {
        let parameters = ["username": u, "password" : p, "firstname" : f, "lastname" : l]
        let urlString = "https://testdeployment-scalez.herokuapp.com/user/\(u)"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.httpBody = httpBody
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if (statusCode == 201) {
                    self.setUserDefaults(u: u)
                } else if (statusCode == 400) {
                    self.usernameTakenAlert()
                } else {
                    self.generalAlert()
                }
            }
        }
        task.resume()
    }
}



