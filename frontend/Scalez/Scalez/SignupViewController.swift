//
//  SignupViewController.swift
//  Scalez
//
//  Created by Gurion on 11/17/18.
//  Copyright © 2018 OOSE. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

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
    
    @IBAction func backButton(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        let f = firstnameField.text!
        let l = lastnameField.text!
        let u = usernameField.text!
        let p = passwordField.text!
        let q = checkPasswordField.text!
        

        if (f.isEmpty || l.isEmpty || u.isEmpty || p.isEmpty || q.isEmpty) {
            return
        } else if (!self.checkIfPasswordsMatch(p: p, q: q)) {
            DispatchQueue.main.async {
                self.passwordsMatchAlert()
            }
            return
        } else {
            self.handleCreateAccount(f:f, l:l, u:u, p:p)
        }
    }

    func handleCreateAccount(f : String, l : String, u : String, p : String) {
        postDataToServer(f: f, l: l, u: u, p: p, completion: {
            if (UserDefaults.standard.bool(forKey: "isLoggedIn")) {
                self.performSegue(withIdentifier: "createAccountSegue", sender: self)
            }
        })
    }

    func checkIfPasswordsMatch(p: String, q: String) -> Bool {
        return p.isEqual(q)
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

    func postDataToServer(f: String, l: String, u: String, p: String, completion : @escaping ()->()) {
        let url: String = "https://testdeployment-scalez.herokuapp.com/user/"
        let params:[String:String] = ["firstname": f,
                                      "lastname" : l,
                                      "username" : u,
                                      "password" : passwordHash(u: u, p: p)]

        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                if let status = response.response?.statusCode {
                    print(status)
                    switch(status) {
                    case 201:
                        self.setUserDefaults(u: u)
                    case 400:
                        DispatchQueue.main.async {
                            self.usernameTakenAlert()
                        }
                    default:
                        DispatchQueue.main.async {
                            self.generalAlert()
                        }
                    }
                }
                completion()
        }
    }
}
