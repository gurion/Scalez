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
            DispatchQueue.main.async {
                self.passwordsMatchAlert()
            }
            return
        } else {
            self.handleCreateAccount(f:f, l:l, u:u, p:p)
        }
    }
    
    func handleCreateAccount(f : String, l : String, u : String, p : String) {
        postDataToServer(f: f, l: l, u: u, p: p)
        if (UserDefaults.standard.bool(forKey: "isLoggedIn")) {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "RecordVC") as! RecordViewController
            present(next, animated: true, completion: nil)
        }
    }
    
    func checkIfPasswordsMatch() -> Bool {
        return self.passwordField.isEqual(self.checkPasswordField)
    }
    
    func passwordHash(u : String, p : String) -> String {
        return "\(p).\(u)".sha256()
    }
    
    func okButtonAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func incompleteFieldsAlert() {
        self.okButtonAlert(title: "Please fill out all fields", message: "")
    }
    
    func passwordsMatchAlert() {
        self.okButtonAlert(title: "Password does not match", message: "Please re-enter you password")
    }
    
    func usernameTakenAlert() {
        self.okButtonAlert(title: "Username already taken", message: "Please pick another username")
    }
    
    func generalAlert() {
        self.okButtonAlert(title: "Something went wrong", message: "Sorry! Please try again")
    }
    
    func setUserDefaults(u : String) {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "isLoggedIn")
        defaults.set(u, forKey: "username")
        defaults.set("https://testdeployment-scalez.herokuapp.com/user/\(u)", forKey: "userUrl")
    }

    func postDataToServer(f : String, l : String, u : String, p : String) {
        let parameters = ["username": u, "password" : passwordHash(u: u, p: p), "firstname" : f, "lastname" : l]
        print(parameters)
        let urlString = "https://testdeployment-scalez.herokuapp.com/user/"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        print(httpBody)
        request.httpBody = httpBody
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            print("response")
            print(response)
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                print("Status code")
                print(statusCode)
                if (statusCode == 201 || statusCode == 200) {
                    DispatchQueue.main.async {
                        self.setUserDefaults(u: u)
                    }
                } else if (statusCode == 400) {
                    DispatchQueue.main.async {
                        self.usernameTakenAlert()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.generalAlert()
                    }
                }
            }
        }
        task.resume()
    }
}



