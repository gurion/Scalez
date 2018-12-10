//
//  PendingAuditionsViewController.swift
//  Scalez
//
//  Created by Gurion on 12/10/18.
//  Copyright © 2018 OOSE. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class PendingAuditionsViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAuditions()
    }
    
    @IBAction func reloadButton(_ sender: Any) {
        self.getAuditions()
    }
    
    func okButtonAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func generalAlert() {
        self.okButtonAlert(title: "Something went wrong!", message: "Sorry! Please try again.")
    }
    
    func fillAuditionTable() {
        
    }
    
    func getAuditions() {
        let url: String = UserDefaults.standard.string(forKey: "userUrl")!+"/audition"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                if let status = response.response?.statusCode {
                    print(status)
                    switch(status) {
                    case 200:
                        DispatchQueue.main.async {
                            self.fillAuditionTable()
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
