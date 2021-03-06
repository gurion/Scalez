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
import SwiftyJSON
import Alamofire

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
        self.hideKeyboardWhenTappedAround()
        loginButton.setImage(UIImage(named: "sign_in"), for: .normal)
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }

    @IBAction func logInButton(_ sender: Any) {
        let u = usernameField.text!
        let p = passwordField.text!

        if (u.isEmpty || p.isEmpty) {
            self.okButtonAlert(title: "Please enter username and password", message: "")
            return
        }
        self.handleLogIn(u:u, p:p)
    }

    func handleLogIn(u : String, p : String) {
        self.username = u
        self.password = p
        logInToServer(u : self.username, p : self.password, completion: {
            if (UserDefaults.standard.bool(forKey: "isLoggedIn")) {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        })
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

        if (UserDefaults.standard.bool(forKey: "isLoggedIn")) {
            return true
        } else if (identifier == "createAccountSegue") {
            self.performSegue(withIdentifier: "createAccountSegue", sender: self)
        }
        return false
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

    func generalAlert() {
        self.okButtonAlert(title: "Something went wrong!", message: "Sorry! Please try again.")
    }

    func logInToServer(u: String, p: String, completion : @escaping ()->()) {
        let url: String = "https://testdeployment-scalez.herokuapp.com/user/login"
        let params:[String:String] = ["username" : u,
                                      "password" : passwordHash(u: u, p: p)]

        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let status = response.response?.statusCode {
                    switch(status) {
                    case 201:
                        self.setUserDefaults()
                    case 404:
                        DispatchQueue.main.async {
                            self.loginErrorAlert()
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
