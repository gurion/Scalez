//
//  ProfileViewController.swift
//  Scalez
//
//  Created by Eric Feldman on 12/6/18.
//  Copyright © 2018 OOSE. All rights reserved.
//

import Foundation
import UIKit
import Charts
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var LineChart: LineChartView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        let xAxis = LineChart.xAxis
        xAxis.granularity = 3600.0
        usernameLabel.text = "Username: " + UserDefaults.standard.string(forKey: "username")!
        getChartFromServer()
        // Do any additional setup after loading the view.
    }
    
    
    func setChartValues (data: JSON) {
        var values: [ChartDataEntry] = []
        var i = 0
        //var leaderboard = data["leaderboard"]
        let leaderboard = [
            "2018-12-10 19:42:09.993531" : 1.0,
            "2018-12-11 19:42:29.237272" : 2,
            "2018-12-12 19:42:29.237272" : 0,
            "2018-12-13 19:42:29.237272" : 1,
            "2018-12-14 19:42:29.237272" : 3,
            "2018-12-15 19:42:29.237272" : 2
        ]
        //print(leaderboard)
        for (_,subJson):(String, Double) in leaderboard {
            //let score = subJson.doubleValue
            values.append(ChartDataEntry(x: Double(i), y: Double(subJson)))
            i = i + 1
        }
        
        let set = LineChartDataSet(values: values, label: "dataset")
        let d = LineChartData(dataSet: set)
        
        self.LineChart.data = d
    }
    
    func getChartFromServer() {
        let url:String = UserDefaults.standard.string(forKey: "userUrl")! + "/leaderboard"
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                if let status = response.response?.statusCode {
                    print(status)
                    switch(status) {
                    case 200:
                        let json = JSON(response.result.value!)
                        self.setChartValues(data: json)
                    default:
                        DispatchQueue.main.async {
                            self.generalAlert()
                        }
                    }
                }
        }
    }
    
    func okButtonAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func generalAlert() {
        self.okButtonAlert(title: "Something went wrong", message: "Sorry! Please try again")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
