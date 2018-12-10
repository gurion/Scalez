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

class PendingAuditionsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var pendingAuditions: UITableView!
    var auditions = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pendingAuditions.delegate   = self
        self.pendingAuditions.dataSource = self
        self.getAuditions()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return auditions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "jsonCell")!
        var dict = auditions[indexPath.row]
        cell.textLabel?.text = dict["auditioner"] as? String
        cell.detailTextLabel?.text = dict["id"] as? String
        return cell    }
    
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
    
    func getAuditions() {
        let url: String = UserDefaults.standard.string(forKey: "userUrl")!+"/audition"
        Alamofire.request(url).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["auditions"].arrayObject {
                    self.auditions = resData as! [[String:AnyObject]]
                }
                if self.auditions.count > 0 {
                    self.pendingAuditions.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.generalAlert()
                }
            }
        }
        
    }
    
}
