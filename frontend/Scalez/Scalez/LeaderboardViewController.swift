//
//  LeaderboardViewController.swift
//  Scalez
//
//  Created by Gurion on 11/15/18.
//  Copyright © 2018 OOSE. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class LeaderboardViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let sections = ["Top Scores"]
    var leaderboard = [[String : Any]]()
    let cellReuseIdentifier = "Cell"
    
    @IBOutlet var leaderboardTable: UITableView!
    
    @IBAction func reloadButton(_ sender: Any) {
        self.getAuditions(completion: {
            if self.leaderboard.count > 0 {
                self.leaderboardTable.reloadData()
            }
        })
    }
    
    override func awakeFromNib() {
        self.tabBarItem.title = "Leaderboard"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAuditions(completion: {
            if self.leaderboard.count > 0 {
                self.leaderboardTable.reloadData()
            }
        })
        self.leaderboardTable.delegate   = self
        self.leaderboardTable.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section] as? String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboard.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:LeaderboardTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! LeaderboardTableCell
        let recording = leaderboard[indexPath.row]
        
        cell.usernameLabel.text = "User: " + (recording["auditioner"] as! String)
        cell.scaleLabel.text = "Scale: " + (recording["scale"] as! String) + " " + (recording["key"] as! String)
        cell.scoreLabel.text = "Score: " + (recording["score"] as! String)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
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
        let url: String = "https://testdeployment-scalez.herokuapp.com/leaderboard"
        Alamofire.request(url).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let jsonResponse = JSON(responseData.result.value!)
                
                if let array = jsonResponse["leaderboard"].arrayObject {
                    self.leaderboard = array[0] as! [[String : Any]]
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
