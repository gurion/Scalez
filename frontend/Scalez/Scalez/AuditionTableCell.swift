//
//  AuditionTableCell.swift
//  Scalez
//
//  Created by Gurion on 12/14/18.
//  Copyright © 2018 OOSE. All rights reserved.
//

import Foundation
import UIKit

class AuditionTableCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scaleLabel: UILabel!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var isCompleteGUI: UIView!
    var isComplete: Bool!
    var audtionID: String!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if (isComplete) {
            isCompleteGUI.backgroundColor = UIColor.green
        } else {
            isCompleteGUI.backgroundColor = UIColor.red
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
