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
    @IBOutlet var back: UIButton!

    let sections = ["auditionee", "auditioner"]
    var auditionee = [[String : Any]]()
    var auditioner = [[String : Any]]()
    let cellReuseIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAuditions()
        self.pendingAuditions.delegate   = self
        self.pendingAuditions.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section] as? String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return auditionee.count
        } else if (section == 1) {
            return auditioner.count
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell:AuditionTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! AuditionTableCell
        
        if indexPath.section == 0 {
            cell.usernameLabel.text = auditionee[IndexPath]["auditioner"]
            cell.scaleLabel.text = auditionee[IndexPath]["scale"]
            cell.keyLabel.text = auditionee[IndexPath]["key"]
            cell.scoreLabel.text = auditionee[IndexPath]["score"]
            cell.isComplete = auditionee[IndexPath]["isComplete"]
            cell.audtionID = auditionee[IndexPath]["id"]
        } else if indexPath.section == 1 {
            cell.usernameLabel.text = ""
            cell.scaleLabel.text = ""
            cell.keyLabel.text = ""
            cell.scoreLabel.text = ""
            cell.isComplete = false
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 0 {
            
        } else if indexPath.section == 1 {
            return
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let completeAuditionVC = segue.destination as? CompleteAuditionViewController {
            completeAuditionVC.auditionID = self.auditionID
        }
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
