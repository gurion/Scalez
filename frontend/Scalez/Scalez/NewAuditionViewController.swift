//
//  NewAuditionViewController.swift
//  Scalez
//
//  Created by Gurion on 12/5/18.
//  Copyright © 2018 OOSE. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift
import SwiftyJSON
import Alamofire

class NewAuditionViewController : UIViewController {
    
    @IBOutlet var auditioneeField: UITextField!
    @IBOutlet var createAuditionButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logInButton(_ sender: Any) {
        let auditionee = auditioneeField.text!
        let scale = 
        self.handleLogIn(u:u, p:p)
    }
    
    func handleLogIn(u : String, p : String) {
        self.username = u
        self.password = self.passwordHash(u : u, p : p)
        logInToServer(u : self.username, p : self.password)
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
    
    func generalAlert() {
        self.okButtonAlert(title: "Something went wrong!", message: "Sorry! Please try again.")
    }
    
    func logInToServer(u: String, p: String) {
        let url: String = "https://testdeployment-scalez.herokuapp.com/user/login"
        let params:[String:String] = ["username" : u,
                                      "password" : passwordHash(u: u, p: p)]
        print(params)
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                if let status = response.response?.statusCode {
                    print(status)
                    switch(status) {
                    case 200:
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
        }
        
    }
    
}
