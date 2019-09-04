//
//  LoginViewModel.swift
//  iOSFido2Demo
//
//  Created by neetin on 9/3/19.
//  Copyright © 2019 SingularKey. All rights reserved.
//

import Foundation

struct LoginViewModel {
  static func authInitiate(name: String, callback: @escaping ( (publicKeyId: String, challenge: String)?, _ error: String?) -> () ) {
    let contentType = APIHTTPHeader.contentType
    let authInitiateEndPoint = AuthEndpoint.initiate
    let authRequest = NetworkAPIRequestFor(endpoint: authInitiateEndPoint, headers: [contentType], parameter: ["name" : name])
    NetworkAPIUtils.getRequest(authRequest) { (data, error) in
      if let err = error {
        callback(nil, err.localizedDescription)
        return
      }
      guard let data = data else {
        callback(nil, "Invalid Response!")
        return
      }
      do {
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
          callback(nil, "Invalid Response!")
          return
        }
        if let statusCode = json["statusCode"] as? Int, let msg = json["message"] as? String {
          if statusCode == 400 {
            callback(nil, msg)
            return
          }
        }
        guard let allowCredentials = json["allowCredentials"] as? [[String : String]],
          let challenge = json["challenge"] as? String else {
            callback(nil, "Invalid Response!")
            return
        }
        guard let publicKeyId = allowCredentials.first?["id"]  else {
          callback(nil, "Invalid Response!")
          return
        }
        callback((publicKeyId, challenge), nil)
      }
      catch let error {
        callback(nil, error.localizedDescription)
      }
    }
  }
  
  static func authComplete(credentials: [String: Any], callback: @escaping (_ error: String?) -> () ) {
    let contentType = APIHTTPHeader.contentType
    let authInitiateCompleteEndPoint = AuthEndpoint.complete
    let authCompleteRequest = NetworkAPIRequestFor(endpoint: authInitiateCompleteEndPoint, headers: [contentType], parameter: credentials)
    NetworkAPIUtils.getRequest(authCompleteRequest, callback: { (data, error) in
      if let err = error {
        callback(err.localizedDescription)
        return
      }
      guard let data = data else {
        callback("Invalid Response!")
        return
      }
      do {
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
          callback("Invalid Response!")
          return
        }
        guard let success = json["success"] as? Int else {
          callback("Invalid Response!")
          return
        }
        if success == 1 {
          Global.UserDefaultsUtil.setUserLoggedIn()
          callback(nil) // success with no error
        }
      } catch let error {
        callback(error.localizedDescription)
      }
    })
  }
}
