//
//  SignUpViewController.swift
//  iOS Example
//
//  Created by neetin on 5/31/19.
//  Copyright © 2019 SingularKey. All rights reserved.
//

import UIKit
import SingularKey

class SignUpViewController: UIViewController {
  
  @IBOutlet weak var usernameTextField: BorderTextField!
  let contentType = APIHTTPHeader.contentType
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

    let credManager = CredentialsManager()

  @IBAction func signUpButtonPressed(_ sender: UIButton) {
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
    //******************************* FIDO2 Registration Step 1 ************************//
    //******************************* Get challenge from the Server ********************//
    //**********************************************************************************//
    SignUpViewModel.registerInitiate(name: username) { (challenge, error) in
      if let error = error {
        Global.Alert.showAlert(self, message: error)
        return
      }
      guard let challenge = challenge else {
        Global.Alert.showAlert(self, message: "Server Error!")
        return
      }
      let modality = SecAccessControlCreateFlags.biometryAny

      //**********************************************************************************//
      //******************************* FIDO2 Registration Step 2 ************************//
      //***************************** Invoke Singular Key FIDO2 API **********************//
      //**********************************************************************************//
      self.credManager.credentialsCreate(rpId: Config.rpId, origin: Config.origin, modality: modality, challenge: challenge) { (result, error) in
        if let err = error {
          Global.Alert.showAlert(self, message: err.localizedDescription)
          return
        }
        guard let result = result else {
          Global.Alert.showAlert(self, message: "Invalid Response!")
          return
        }
        guard let createCredResponse = result["createCredResponse"] as? [String: Any] else {
          Global.Alert.showAlert(self, message: "Invalid Response!")
          return
        }
        
        //**********************************************************************************//
        //******************************* FIDO2 Registration Step 3 ************************//
        //******* Send Signed Challenge (Attestation) to the Server for validation *********//
        //**********************************************************************************//
        SignUpViewModel.registerComplete(createCredResponse: createCredResponse) { (userInfo, error) in
          if let error = error {
            Global.Alert.showAlert(self, message: error)
          }
          guard let _ = userInfo else {
            Global.Alert.showAlert(self, message: "Unknown Server Error!")
            return
          }
          Global.Open.homeViewController()
        }
      }
    }
  }
}
