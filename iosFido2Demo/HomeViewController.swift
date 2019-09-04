//
//  HomeViewController.swift
//  iOS Example2
//
//  Created by neetin on 6/18/19.
//  Copyright © 2019 SingularKey. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  @IBAction func logoutButtonPressed(_ sender: Any) {
    Global.User.logout()
  }

}
