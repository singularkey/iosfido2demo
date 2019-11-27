//
//  LoginViewController.swift
//  SingularKey
//
//  Created by neetin on 1/16/19.
//  Copyright © 2019 SingularKey. All rights reserved.
//

import UIKit
import SingularKey

class LoginViewController: UIViewController {
  @IBOutlet weak var usernameTextField: BorderTextField!
  @IBOutlet weak var loginButton: ShadowButton!
  let contentType = APIHTTPHeader.contentType
  
  let credManager = CredentialsManager()
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func loginButttonPressed(_ sender: Any) {
    guard let username = usernameTextField.text else {
      Global.Alert.showAlert(self, message: "Please input username!")
      return
    }
    if username.isEmpty {
      Global.Alert.showAlert(self, message: "Please input username!")
      return
    }
    self.view.endEditing(true)
    
    //**********************************************************************************//
    //***************************** FIDO2 Authentication Step 1 ************************//
    //**************************** Get challenge from the Server ***********************//
    //**********************************************************************************//
    LoginViewModel.authInitiate(name: username) { (result, error) in
      if let error = error {
        Global.Alert.showAlert(self, message: error)
        return
      }
      guard let result = result else {
        Global.Alert.showAlert(self, message: "Server Error!")
        return
      }
        
        
      //**********************************************************************************//
      //***************************** FIDO2 Authentication Step 2 ************************//
      //***************************** Invoke Singular Key FIDO2 API **********************//
      //**********************************************************************************//
      self.credManager.credentialsGet(rpId: Config.rpId, origin: Config.origin, publicKeyIds: result.publicKeyIds, challenge: result.challenge, callback: { (result, errorMessage) in
        guard let result = result else {
          if let err = errorMessage {
            Global.Alert.showAlert(self, message: err)
            return
          } else {
            Global.Alert.showAlert(self, message: "No Internal Stored Credentials found!")
            return
          }
        }
        
        //**********************************************************************************//
        //******************************* FIDO2 Authentication Step 3 **********************//
        //******* Send Signed Challenge (Assertion) to the Server for verification *********//
        //**********************************************************************************//
        LoginViewModel.authComplete(credentials: result) { (error) in
          if let error = error {
            Global.Alert.showAlert(self, message: error)
            return
          }
          // no error, login success, redirect to home
          Global.Open.homeViewController()
        }
      })
    }
  }
}
