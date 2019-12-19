//
//  SignUpViewModel.swift
//  iOSFido2Demo
//
//  Created by neetin on 9/3/19.
//  Copyright © 2019 SingularKey. All rights reserved.
//

import Foundation

struct SignUpViewModel {
  
  static func registerInitiate(name: String, callback: @escaping (_ json: [String : AnyObject]?, _ error: String?) -> ()) {
    let contentType = APIHTTPHeader.contentType
    let registerInitiateEndPoint = RegisterEndpoint.fidoRegisterInitiate
    let registerInitiateRequest = NetworkAPIRequestFor(endpoint: registerInitiateEndPoint, headers: [ contentType], parameter: ["name" : name])
    
    NetworkAPIUtils.getRequest(registerInitiateRequest, callback: { (data, error) in
      if let err = error {
        callback(nil, err.localizedDescription)
        return
      }
      guard let data = data else {
        callback(nil, "Invalid Response! Data not found")
        return
      }
      
      do {
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
          callback(nil, "Invalid Response! JSON data conversion error")
          return
        }
        
        callback(json, nil)
      } catch let error {
        callback(nil, error.localizedDescription)
      }
    })
  }
  
  static func registerComplete(createCredResponse: [String: Any], callback: @escaping (_ userInfo: [String: Any]?, _ error: String?) -> () ) {
    let contentType = APIHTTPHeader.contentType
    let registerCompleteEndPoint = RegisterEndpoint.fidoRegisterComplete
    let registerCompleteRequest = NetworkAPIRequestFor(endpoint: registerCompleteEndPoint, headers: [contentType], parameter: createCredResponse)
    NetworkAPIUtils.getRequest(registerCompleteRequest, callback: { (data, error) in
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
        if let errorMsg = json["errorMessage"] as? String {
          callback(nil, errorMsg)
          return
        }
        guard let appUserInfo = json["appUserInfo"] as? [String: Any] else {
          callback(nil, "Invalid Response!")
          return
        }
        guard let username = appUserInfo["username"] as? String else {
          callback(nil, "Invalid Response!")
          return
        }
        Global.UserDefaultsUtil.setUserName(name: username)
        Global.UserDefaultsUtil.setUserLoggedIn()
        callback(appUserInfo, nil)
      } catch let error {
        callback(nil, error.localizedDescription)
        return
      }
    })
  }
}

