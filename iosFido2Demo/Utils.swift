//
//  Utils.swift
//  SingularKey
//
//  Created by neetin on 1/22/19.
//  Copyright © 2019 SingularKey. All rights reserved.
//

import UIKit

struct Color {
    static var primaryAppColor = UIColor(hex:"99c852")
  static var primaryGray = UIColor(hex: "595957")
}

private enum UserDefaultUtilKey: String {
  case userName = "userName"
  case userLoggedIn = "userLoggedIn"
  case skUserId = "skUserId"
}

struct Global {
  static func setAppearance() {
    UINavigationBar.appearance().barTintColor = Color.primaryGray
    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
  }
  
  struct CustomDelay {
    // custom delay closure
    static func delay(_ delay:Double, closure:@escaping ()->()) {
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
  }
  
  struct Alert {
    static func showAlert(_ viewController: UIViewController, message: String, title: String? = "Singular Key Fido2 Demo") {
      DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title : "OK" , style : .cancel, handler:nil))
        viewController.present(alert, animated: true, completion: nil)
      }
    }
  }
  
  struct User {
    static func logout() {
      Global.UserDefaultsUtil.deleteUserLoggedIn()
      Global.Open.welcomeViewController(flipAnimation: true)
    }
  }
  
  struct Open {
    static func welcomeViewController(flipAnimation: Bool = false) {
      DispatchQueue.main.async {
        let welcomeVC: WelcomeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        let window = UIApplication.shared.delegate?.window
        if flipAnimation {
          UIView.transition(with: window!!, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            window??.rootViewController = welcomeVC
          }, completion: { (success) in
            window??.makeKeyAndVisible()
          })
        } else {
          window??.rootViewController = welcomeVC
          window??.makeKeyAndVisible()
        }
      }
    }
    
    static func homeViewController(flipAnimation: Bool = false) {
      DispatchQueue.main.async {
        let homeVC: HomeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let nav = UINavigationController(rootViewController: homeVC)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        guard let window = delegate.window else { return }
        if flipAnimation {
          UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            window.rootViewController = nav
          }, completion: { (success) in
            window.makeKeyAndVisible()
          })
        } else {
          window.rootViewController = nav
          window.makeKeyAndVisible()
        }
      }
    }
  }
  
  struct UserDefaultsUtil {
    static func deleteUserName() {
      UserDefaults.standard.removeObject(forKey: UserDefaultUtilKey.userName.rawValue)
      UserDefaults.standard.synchronize()
    }
    
    static func setUserName(name: String) {
      UserDefaults.standard.setValue(name, forKey: UserDefaultUtilKey.userName.rawValue)
      UserDefaults.standard.synchronize()
    }
    
    static func getUserName() -> String? {
      guard let name = UserDefaults.standard.value(forKey: UserDefaultUtilKey.userName.rawValue) as? String else { return nil }
      return name
    }
    
    static func deleteSKUserId() {
      UserDefaults.standard.removeObject(forKey: UserDefaultUtilKey.skUserId.rawValue)
      UserDefaults.standard.synchronize()
    }
    
    static func setSKUserId(id: String) {
      UserDefaults.standard.setValue(id, forKey: UserDefaultUtilKey.skUserId.rawValue)
      UserDefaults.standard.synchronize()
    }
    
    static func getSKUserId() -> String? {
      guard let name = UserDefaults.standard.value(forKey: UserDefaultUtilKey.skUserId.rawValue) as? String else { return nil }
      return name
    }
    
    static func setUserLoggedIn() {
      UserDefaults.standard.setValue(true, forKey: UserDefaultUtilKey.userLoggedIn.rawValue)
      UserDefaults.standard.synchronize()
    }
    
    static func deleteUserLoggedIn() {
      UserDefaults.standard.removeObject(forKey: UserDefaultUtilKey.userLoggedIn.rawValue)
      UserDefaults.standard.synchronize()
    }
    
    static func getUserloggedIn() -> Bool? {
      guard let loggedIn = UserDefaults.standard.value(forKey: UserDefaultUtilKey.userLoggedIn.rawValue) as? Bool else { return nil }
      return loggedIn
    }
  }
}


/// NetworkError are errors on network stuffs, suchs as invalid URL, error on data serialization, authentication failuer
enum MyNetworkError: Error {
  case invalidURL(suppliedURL: String)
  case serialize(data: Data)
  case authenticationFailuer(message: String)
  case badRequest(message: String)
}

extension MyNetworkError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .invalidURL(let suppliedURL):
      return NSLocalizedString("Could not convert supplied string \(suppliedURL) to URL", comment: "Invalid URL string")
    case .serialize(let data):
      return NSLocalizedString("Could not do JSONSerialization for supplied data, data: \(data) ", comment: "JSONSerialization error")
    case .authenticationFailuer(let message):
      return NSLocalizedString(message, comment: "Authentication failuer error")
    case .badRequest(let message):
      return NSLocalizedString(message, comment: "Bad request error")
    }
  }
}
