//
//  RequestAuditionViewController.swift
//  Scalez
//
//  Created by Gurion on 12/9/18.
//  Copyright © 2018 OOSE. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class RequestAuditionViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var auditioneeNameField: UITextField!
    @IBOutlet var majorMinorSelector: UISegmentedControl!
    @IBOutlet var scaleSelector: UIPickerView!
    var possibleScales: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scaleSelector.delegate = self
        self.scaleSelector.dataSource = self
        self.possibleScales = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row] as String
    }
    
    @IBAction func newAuditionButton(_ sender: Any) {
        if (self.auditioneeNameField.isEmpty) {
            DispatchQueue.main.async {
                self.noAuditioneeAlert()
            }
            return
        } else {
            self.handleNewAudition()
        }
    }
    
    func handleNewAudition() {
        postNewAudition()
    }
    
    func okButtonAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func auditionSentAlert(username : String) {
        self.okButtonAlert(title: "Audition request for a \(getSelectedScale()) \(convertIntToMajorMinor()) scale sent to \(username)!", message: "")
    }
    
    func noAuditioneeAlert() {
        self.okButtonAlert(title: "Please enter an auditionee", message: "")
    }
    
    func generalAlert() {
        self.okButtonAlert(title: "Something went wrong!", message: "Sorry! Please try again.")
    }
    
    func convertIntToMajorMinor() -> String {
        let value = self.majorMinorSelector.selectedSegmentIndex
        if (value == 1) {
            return "major"
        } else {
            return "minor"
        }
    }
    
    func getSelectedScale() -> String {
        
    }
    
    func postNewAudition() {
        let url: String = UserDefaults.standard.string(forKey: "userUrl")!+"/audition"
        let params:[String:String] = ["auditionee" : self.auditioneeNameField.text, "scale" : getSelectedScale(),"majorminor" : self.convertIntToMajorMinor()]
        
        print(params)
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                if let status = response.response?.statusCode {
                    print(status)
                    switch(status) {
                    case 200:
                        DispatchQueue.main.async {
                            self.auditionSentAlert(username: params["auditionee"])
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
