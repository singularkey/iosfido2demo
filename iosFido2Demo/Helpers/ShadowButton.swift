//
//  ShadowButton.swift
//  SingularKey
//
//  Created by neetin on 1/16/19.
//  Copyright © 2019 SingularKey. All rights reserved.
//

import UIKit

class ShadowButton: UIButton {

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    customize()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    customize()
  }
  
  private func customize() {
    self.layer.cornerRadius = 4.0
    self.layer.shadowRadius = 2.0
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOffset = CGSize(width: 2, height: 2)
    self.layer.shadowOpacity = 0.5
    self.backgroundColor = UIColor(hex: "99c852")
    self.setTitleColor(.white, for: .normal)
    self.setTitleColor(.gray, for: .highlighted)
  }
}
