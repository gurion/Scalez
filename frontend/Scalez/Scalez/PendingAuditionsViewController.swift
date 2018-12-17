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
    
    @IBAction func reloadButton(_ sender: Any) {
        self.getAuditions(completion: {
            if self.auditionee.count + self.auditioner.count > 0 {
                self.pendingAuditions.reloadData()
            }
        })
    }
    
    @IBAction func backButton(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    let sections = ["auditionee", "auditioner"]
    var auditionee = [JSON]()
    var auditioner = [JSON]()
    let cellReuseIdentifier = "Cell"
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAuditions(completion: {
            if self.auditionee.count + self.auditioner.count > 0 {
                self.pendingAuditions.reloadData()
            }
        })
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
            let audition = auditionee[indexPath.row]
            cell.usernameLabel.text = "Auditioner: " + audition["auditioner"].stringValue
            cell.scaleLabel.text = "Scale: " + audition["scale"].stringValue
            cell.keyLabel.text = "Key: " + audition["key"].stringValue
            cell.scoreLabel.text = "Score: " + audition["score"].stringValue
            cell.isComplete = audition["isComplete"].boolValue
            cell.audtionID = audition["id"].stringValue
        } else if indexPath.section == 1 {
            let audition = auditioner[indexPath.row]
            cell.usernameLabel.text = "Auditionee: " + audition["auditionee"].stringValue
            cell.scaleLabel.text = "Scale: " + audition["scale"].stringValue
            cell.keyLabel.text = "Key: " + audition["key"].stringValue
            cell.scoreLabel.text = "Score: " + audition["score"].stringValue
            cell.isComplete = audition["isComplete"].boolValue
            cell.audtionID = audition["id"].stringValue
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 0 {
            selectedIndex = indexPath.row
            performSegue(withIdentifier: "completeAudition", sender: self)
        } else if indexPath.section == 1 {
            return
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "completeAudition") {
            if let completeAuditionVC = segue.destination as? CompleteAuditionViewController {
                completeAuditionVC.auditionID = auditionee[selectedIndex]["id"].stringValue
                completeAuditionVC.auditionerUsernameLabel.text = "Auditioner: " + auditionee[selectedIndex]["auditioner"].stringValue
                completeAuditionVC.scaleLabel.text = "Scale: " + auditionee[selectedIndex]["scale"].stringValue
                completeAuditionVC.keyLabel.text = "Key: " + auditionee[selectedIndex]["key"].stringValue
            }
        }
    }
    
    func okButtonAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func generalAlert() {
        self.okButtonAlert(title: "Something went wrong!", message: "Sorry! Please try again.")
    }
    
    func getAuditions(completion : @escaping ()->()) {
        let url: String = UserDefaults.standard.string(forKey: "userUrl")!+"/audition"
        Alamofire.request(url).responseJSON { response in
            if let status = response.response?.statusCode {
                switch(status) {
                case 200:
                    let jsonResponse = JSON(response.result.value!)
                    self.auditionee = jsonResponse["auditions"]["auditionee"].arrayValue
                    self.auditioner = jsonResponse["auditions"]["auditionee"].arrayValue
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
