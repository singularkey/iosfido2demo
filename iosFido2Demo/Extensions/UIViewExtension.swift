//
//  UIViewExtension.swift
//  SingularKey
//
//  Created by neetin on 2/19/19.
//  Copyright © 2019 SingularKey. All rights reserved.
//

import UIKit

extension UIView {
  func roundedCornerBottomSide() {
    DispatchQueue.main.async {
      let rectShape = CAShapeLayer()
      rectShape.bounds = self.frame
      rectShape.position = self.center
      rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomRight, .bottomLeft], cornerRadii: CGSize(width: 8, height: 8)).cgPath
      self.layer.mask = rectShape
    }
  }
  
  func roundCornerAllSide(radius: CGFloat = 8) {
    self.layer.cornerRadius = radius
    self.clipsToBounds = true
  }
}
