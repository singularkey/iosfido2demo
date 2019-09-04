//
//  NetworkUtils.swift
//  iOS Example2
//
//  Created by neetin on 6/18/19.
//  Copyright © 2019 SingularKey. All rights reserved.
//

import Foundation

public protocol APIEndpoint {
  var path: String { get }
  var method: APIHTTPMethod { get }
}

public enum RegisterEndpoint : APIEndpoint {
  case initiate
  case fidoRegisterInitiate
  case fidoRegisterComplete
  
  public var path: String {
    switch self {
    case .initiate: return "/users"
    case .fidoRegisterInitiate: return "/register/initiate"
    case .fidoRegisterComplete: return "/register/complete"
    }
  }
  
  public var method: APIHTTPMethod {
    switch self {
    case .initiate, .fidoRegisterInitiate, .fidoRegisterComplete: return .post
    }
  }
}

public enum AuthEndpoint : APIEndpoint {
  case initiate
  case complete
  
  public var path: String {
    switch self {
    //Singular Key FIDO2 Authentication Initiate API call
    case .initiate: return "/auth/initiate"
    case .complete: return "/auth/complete"
    }
  }
  
  public var method: APIHTTPMethod {
    switch self {
    case .initiate, .complete: return .post
    }
  }
}

public enum APIHTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
  case patch = "PATCH"
}


public enum APIHTTPHeader {
  case authorization(accessToken: String)
  case custom(String, String)
  case contentType
  
  var key: String {
    switch self {
    case .authorization: return "Authorization"
    case .custom(let key, _): return key
    case .contentType: return "Content-Type"
    }
  }
  
  var requestHeaderValue: String {
    switch self {
    case .authorization(let token):
      return token
    case .custom(_, let value):
      return value
    case .contentType:
      return "application/json"   // content type is always set to Application/json, if you want it different then remove this case.
    }
  }
}

/** This protocol is used to format API request stuffs
 - Parameter parameter: it is a parameter dictionary for request
 - Parameter endpoint: this is endpoint that contains `path` and `method`
 - Parameter headers: it is list of HTTPHeaders object
 */
public protocol NetworkAPIRequestType {
  var parameter: [String : Any]? { get }
  var endpoint: APIEndpoint { get }
  var headers: [APIHTTPHeader]? { get }
}


public struct NetworkAPIRequestFor: NetworkAPIRequestType {
  public var parameter: [String : Any]?
  public let endpoint: APIEndpoint
  public var resourceURL: String = Config.baseURL
  public let headers: [APIHTTPHeader]?
  
  /** This struct is used to format API request stuffs
   - Parameter endpoint: this is endpoint that contains `path` and `method`
   - Parameter isProxyEndPoint: whether you want to request to proxy URL or not
   - Parameter headers: it is list of HTTPHeaders object
   - Parameter parameter: it is a parameter dictionary for request
   */
  public init(endpoint: APIEndpoint, headers: [APIHTTPHeader]? = [], parameter: [String : Any]?) {
    self.resourceURL = Config.baseURL
    self.parameter = parameter
    self.endpoint = endpoint
    self.headers = headers
    
    resourceURL += self.endpoint.path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
  }
}


struct NetworkAPIUtils {
  
  /** This function is a generic network API request function.
   - Parameter requestFor: it is a APIRequestType which contain information about reqsource URL, request method type and parameters
   - Parameter callback: it is a response closure block which will return optional Data and optional Error
   */
  static func getRequest(_ requestFor: NetworkAPIRequestFor, callback: @escaping (_ data: Data?, _ error: Error?) -> ()) {
    guard let url = URL(string: requestFor.resourceURL) else {
      let error = MyNetworkError.invalidURL(suppliedURL: requestFor.resourceURL)
      callback(nil, error)
      return
    }
    var urlRequst = URLRequest(url: url)
    urlRequst.httpMethod = requestFor.endpoint.method.rawValue
    if let headers = requestFor.headers {
      for header in headers {
        urlRequst.setValue(header.requestHeaderValue, forHTTPHeaderField: header.key)
      }
    }
    if let parameter = requestFor.parameter {
      do {
        let httpBody = try JSONSerialization.data(withJSONObject: parameter, options: [])
        urlRequst.httpBody = httpBody
      } catch let error {
        callback(nil, error)
      }
    }
    let urlSession = URLSession(configuration: .default)
    var task: URLSessionDataTask?
    task = urlSession.dataTask(with: urlRequst) { data, response, error in
      callback(data, error)
    }
    task?.resume()
  }
}
