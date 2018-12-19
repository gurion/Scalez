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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var avgScoreLabel: UILabel!

    var userInfo = [String:String]()
    var chartData = [JSON]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let xAxis = LineChart.xAxis
        xAxis.granularity = 3600.0
        xAxis.labelPosition = XAxis.LabelPosition.bottom

        LineChart.legend.enabled = false
        LineChart.rightAxis.enabled = false

        getUserInfo(completion: {
            self.setUserInfo()
        })

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getChartFromServer(completion: {
            self.setChartValues()
        })
    }

    @IBAction func logoutButton(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "isLoggedIn")
        defaults.set("", forKey: "username")
        defaults.set("", forKey: "userUrl")
        self.performSegue(withIdentifier: "backToLoginSegue", sender: self)
    }

    override func awakeFromNib() {
        self.tabBarItem.title = "Profile"
    }

    func setUserInfo() {
        usernameLabel.text = "Username: " + UserDefaults.standard.string(forKey: "username")!
        nameLabel.text = userInfo["firstname"]! + " " + userInfo["lastname"]!
        highScoreLabel.text = "High Score: " + userInfo["top_score"]!
        avgScoreLabel.text = "Average Score: " + userInfo["average_score"]!
    }

    func setChartValues () {
        var values: [ChartDataEntry] = []
        var i = 0

        for entry in chartData {
            let score = entry["score"].doubleValue
            values.append(ChartDataEntry(x: Double(i), y: score))
            i = i + 1
        }

        let set = LineChartDataSet(values: values, label: "dataset")

        set.setColor(UIColor.red)
        set.circleRadius = 3
        set.setCircleColor(UIColor.black)
        set.drawFilledEnabled = false

        let d = LineChartData(dataSet: set)

        self.LineChart.data = d
    }

    func getUserInfo(completion : @escaping ()->()) {
        let url:String = UserDefaults.standard.string(forKey: "userUrl")! + "/info"

        Alamofire.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let status = response.response?.statusCode {
                    switch(status) {
                    case 200:
                        if let data = response.result.value as? [String:Any] {
                            self.userInfo = data["info"] as! [String:String]
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

    func getChartFromServer(completion : @escaping ()->()) {
        let url:String = UserDefaults.standard.string(forKey: "userUrl")! + "/leaderboard"

        Alamofire.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let status = response.response?.statusCode {
                    switch(status) {
                    case 200:
                        let json = JSON(response.result.value!)
                        self.chartData = json["history"].arrayValue
                    default:
                        DispatchQueue.main.async {
                            self.generalAlert()
                        }
                    }
                }
                completion()
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
