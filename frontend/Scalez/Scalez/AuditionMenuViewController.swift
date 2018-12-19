//
//  AuditionMenuViewController.swift
//  Scalez
//
//  Created by Gurion on 10/15/18.
//  Copyright © 2018 OOSE. All rights reserved.
//

import Foundation
import UIKit

class AuditionMenuViewController: UIViewController {

    @IBOutlet var request: UIButton!
    @IBOutlet var pending: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        title = "Auditions"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func awakeFromNib() {
        self.tabBarItem.title = "Auditions"
    }
    
    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue) {
        self.performSegue(withIdentifier: "AuditionMenuViewController", sender: self)
    }
    
}

