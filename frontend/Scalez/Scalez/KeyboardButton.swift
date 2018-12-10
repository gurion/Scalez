//
//  KeyboardButton.swift
//  Scalez
//
//  Created by Gurion on 12/9/18.
//  Copyright © 2018 OOSE. All rights reserved.
//

import Foundation
import UIKit

class KeyboardButton: UIButton {
    var alternateButtons:Array<UIButton>?
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
    }
    
    func unselectAlternateButtons(){
        if alternateButton != nil {
            self.isSelected = true
            
            for aButton:KeyboardButton in alternateButton! {
                aButton.isSelected = false
            }
        } else {
            toggleButton()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent? {
        unselectAlternateButtons()
        super.touchesBegan(touches, with: event)
    }
    
    func toggleButton(){
        self.isSelected = !isSelected
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.layer.borderColor = Color.red.cgColor
                self.layer.backgroundColor = Color.red.cgColor
                self.setTitleColor(.white, for: .selected)
            } else {
                self.layer.borderColor = Color.black.cgColor
                self.layer.backgroundColor = Color.white.cgColor
                self.setTitleColor(.black, for: .normal)
            }
        }
    }
}
