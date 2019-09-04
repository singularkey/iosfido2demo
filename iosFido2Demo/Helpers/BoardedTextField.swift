//
//  BoardedTextField.swift
//  SingularKey
//
//  Created by neetin on 1/16/19.
//  Copyright © 2019 SingularKey. All rights reserved.
//

import UIKit

class BorderTextField: UITextField {

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = .always
    self.backgroundColor = UIColor(hex: "8C8A8A")
    self.textColor = UIColor.white
  }
  
  @IBInspectable var borderColor: UIColor = UIColor(hex: "99c852"){
    didSet {
      self.layer.borderColor = borderColor.cgColor
    }
  }
  
  @IBInspectable var borderWidth: CGFloat = 1.0 {
    didSet {
      self.layer.borderWidth = borderWidth
    }
  }
}
