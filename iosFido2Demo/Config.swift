//
//  Config.swift
//  iOS Example2
//
//  Created by neetin on 6/17/19.
//  Copyright © 2019 SingularKey. All rights reserved.
//

import Foundation
import CommonCrypto

#if targetEnvironment(simulator)
struct OSTarget {
  static let isSimulator = true;
}
#else
struct OSTarget {
  static let isSimulator = false;
}
#endif

struct Config {
  static let baseURL = "ADD_YOUR_RP_SERVER_URL_HERE" //e.g., https://api.singularkey.com
  static let rpId = "ADD_YOUR_RPID_HERE"           //e.g., api.singularkey.com
  static let origin =  "ios:bundle-id:com.singularkey.iOSFido2Demo" //"ios:bundle-di:<yourBundleId>"
}

