//
//  WelcomeViewController.swift
//  iOS Example
//
//  Created by neetin on 5/31/19.
//  Copyright © 2019 SingularKey. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
  
  @IBOutlet weak var loginSubView: UIView!
  @IBOutlet weak var signupSubView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setBackgroudColor()
  }
  
  func setBackgroudColor() {
    let gradient = CAGradientLayer()
    gradient.frame = view.bounds
    gradient.colors = [UIColor(hex: "252525").cgColor, UIColor(hex: "706E6E").cgColor, UIColor(hex: "706E6E").cgColor]
    view.layer.insertSublayer(gradient, at: 0)
  }
  
  @IBAction func userAuthSegmentAction(_ sender: UISegmentedControl) {
    loginSubView.isHidden = !(sender.selectedSegmentIndex == 0)
    signupSubView.isHidden = (sender.selectedSegmentIndex == 0)
  }
  
  @IBAction func aboutSingularKeyButtonPressed(_ sender: Any) {
    if let url = URL(string: "https://singularkey.com") {
      UIApplication.shared.open(url, options: [:])
    }
  }
}
