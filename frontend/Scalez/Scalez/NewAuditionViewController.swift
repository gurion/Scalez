////
////  NewAuditionViewController.swift
////  Scalez
////
////  Created by Gurion on 12/7/18.
////  Copyright © 2018 OOSE. All rights reserved.
////
//
//import Foundation
//import UIKit
//import SwiftyJSON
//import Alamofire
//
//class NewAuditionViewController : UIViewController {
//
//    @IBOutlet var auditioneeNameField: UITextField!
//
//    @IBOutlet var c: KeyboardButton!
//    @IBOutlet var csharp: BlackKeyboardButton!
//    @IBOutlet var d: KeyboardButton!
//    @IBOutlet var dsharp: BlackKeyboardButton!
//    @IBOutlet var e: KeyboardButton!
//    @IBOutlet var f: KeyboardButton!
//    @IBOutlet var fsharp: BlackKeyboardButton!
//    @IBOutlet var g: KeyboardButton!
//    @IBOutlet var gsharp: BlackKeyboardButton!
//    @IBOutlet var a: KeyboardButton!
//    @IBOutlet var asharp: BlackKeyboardButton!
//    @IBOutlet var b: KeyboardButton!
//
//    @IBOutlet var majorMinorSelector: UISegmentedControl!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.setAlternateButtons()
//    }
//
//    override func awakeFromNib() {
//        self.view.layoutIfNeeded()
//        self.setInitialKeyboardState()
//
//        
//    }
//
//    func setInitialKeyboardState() {
//        c.selected = false
//        csharp.selected = false
//        d.selected = false
//        dsharp.selected = false
//        e.selected = false
//        f.selected = false
//        fsharp.selected = false
//        g.selected = false
//        gsharp.selected = false
//        a.selected = false
//        asharp.selected = false
//        b.selected = false
//    }
//
//    func setAlternateButtons() {
//        c?.alternateButtons = [csharp!, d!, dsharp!, e!, f!, fsharp!, g!, gsharp!, a!, asharp!, b!]
//        csharp?.alternateButtons = [c!, d!, dsharp!, e!, f!, fsharp!, g!, gsharp!, a!, asharp!, b!]
//        d?.alternateButtons = [c!, csharp!, dsharp!, e!, f!, fsharp!, g!, gsharp!, a!, asharp!, b!]
//        dsharp?.alternateButtons = [c!, csharp!, d!, e!, f!, fsharp!, g!, gsharp!, a!, asharp!, b!]
//        e?.alternateButtons = [c!, csharp!, d!, dsharp!, f!, fsharp!, g!, gsharp!, a!, asharp!, b!]
//        esharp?.alternateButtons = [c!, csharp!, d!, dsharp!, e!, f!, fsharp!, g!, gsharp!, a!, asharp!, b!]
//        f?.alternateButtons = [c!, csharp!, d!, dsharp!, e!, esharp!, fsharp!, g!, gsharp!, a!, asharp!, b!]
//        fsharp?.alternateButtons = [c!, csharp!, d!, dsharp!, e!, esharp!, f!, g!, gsharp!, a!, asharp!, b!]
//        g?.alternateButtons = [c!, csharp!, d!, dsharp!, e!, esharp!, f!, fsharp!, gsharp!, a!, asharp!, b!]
//        gcharp?.alternateButtons = [c!, csharp!, d!, dsharp!, e!, esharp!, f!, fsharp!, g!, a!, asharp!, b!]
//        a?.alternateButtons = [c!, csharp!, d!, dsharp!, e!, esharp!, f!, fsharp!, g!, gsharp!, asharp!, b!]
//        asharp?.alternateButtons = [c!, csharp!, d!, dsharp!, e!, esharp!, f!, fsharp!, g!, gsharp!, a!, b!]
//        b?.alternateButtons = [c!, csharp!, d!, dsharp!, e!, esharp!, f!, fsharp!, g!, gsharp!, a!, asharp!]
//    }
//
//    @IBAction func newAuditionButton(_ sender: Any) {
//        if (self.auditioneeNameField.isEmpty) {
//            DispatchQueue.main.async {
//                self.noAuditioneeAlert()
//            }
//            return
//        } else {
//            self.handleNewAudition()
//        }
//    }
//
//    func handleNewAudition() {
//        postNewAudition()
//    }
//
//    func okButtonAlert(title : String, message : String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        self.present(alert, animated: true)
//    }
//
//    func auditionSentAlert(username : String) {
//        self.okButtonAlert(title: "Audition sent to \(username)!", message: "")
//    }
//
//    func noAuditioneeAlert() {
//        self.okButtonAlert(title: "Please enter an auditionee", message: "")
//    }
//
//    func generalAlert() {
//        self.okButtonAlert(title: "Something went wrong!", message: "Sorry! Please try again.")
//    }
//
//    func convertIntToMajorMinor() -> String {
//        let value = self.majorMinorSelector.selectedSegmentIndex
//        if (value == 1) {
//            return "major"
//        } else {
//            return "minor"
//        }
//    }
//
//    func getSelectedScale() -> String {
//
//    }
//
//    func postNewAudition() {
//        let url: String = UserDefaults.standard.string(forKey: "userUrl")!+"/audition"
//        let params:[String:String] = ["auditionee" : self.auditioneeNameField.text, "scale" : ,"majorminor" : self.convertIntToMajorMinor()]
//
//        print(params)
//
//        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
//            .responseJSON { response in
//                print(response)
//                if let status = response.response?.statusCode {
//                    print(status)
//                    switch(status) {
//                    case 200:
//                        DispatchQueue.main.async {
//                            self.auditionSentAlert(username: params["auditionee"])
//                        }
//                    default:
//                        DispatchQueue.main.async {
//                            self.generalAlert()
//                        }
//                    }
//                }
//        }
//
//    }
//
//}
//
