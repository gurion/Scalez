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
    
    let sections = ["auditionee", "auditioner"]
    var auditionee = [[String : Any]]()
    var auditioner = [[String : Any]]()
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
    
    @IBAction func backButton(_ sender: Any) {
             dismiss(animated: true, completion: nil)
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
            cell.usernameLabel.text = audition["auditioner"] as! String
            cell.scaleLabel.text = audition["scale"] as! String
            cell.keyLabel.text = audition["key"] as! String
            cell.scoreLabel.text = audition["score"] as! String
            cell.isComplete = audition["isComplete"] as! Bool
            cell.audtionID = audition["id"] as! String
        } else if indexPath.section == 1 {
            let audition = auditioner[indexPath.row]
            cell.usernameLabel.text = audition["auditionee"] as! String
            cell.scaleLabel.text = audition["scale"] as! String
            cell.keyLabel.text = audition["key"] as! String
            cell.scoreLabel.text = audition["score"] as! String
            cell.isComplete = audition["isComplete"] as! Bool
            cell.audtionID = audition["id"] as! String
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
                completeAuditionVC.auditionID = auditionee[selectedIndex]["id"] as! String
                completeAuditionVC.auditionerUsernameLabel.text = "Auditioner: " + (auditionee[selectedIndex]["auditioner"] as! String)
                completeAuditionVC.scaleLabel.text = "Scale: " + (auditionee[selectedIndex]["scale"] as! String)
                completeAuditionVC.keyLabel.text = "Key: " + (auditionee[selectedIndex]["key"] as! String)
<<<<<<< HEAD
=======
        }
        
        }
    }
    
    @IBAction func reloadButton(_ sender: Any) {
        self.getAuditions(completion: {
            if self.auditionee.count + self.auditioner.count > 0 {
                self.pendingAuditions.reloadData()
>>>>>>> 06bdf39... add functionality to push data over complete audition segue
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
        Alamofire.request(url).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let jsonResponse = JSON(responseData.result.value!)
                
                if let array = jsonResponse["auditions"].arrayObject {
                    self.auditionee = array[0] as! [[String : Any]]
                    self.auditioner = array[1] as! [[String : Any]]
                }
            } else {
                DispatchQueue.main.async {
                    self.generalAlert()
                }
            }
            completion()
        }
        
    }
    
}
