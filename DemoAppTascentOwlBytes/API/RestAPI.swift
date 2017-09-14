//
//  RestAPI.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 12/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation
import Alamofire

class RestAPI: NSObject, APIClientProtocol, URLSessionDelegate {
    
    private enum Endpoint: URLConvertible {
        private struct Authentication {
            private static let user = "apiuser"
            private static let pwd = "aRT98dPogR"
            
            static func asHeader() -> HTTPHeaders? {
                guard let value = String(format: "%@:%@", Authentication.user, Authentication.pwd).utf8Data?.base64 else {
                    debugPrint("Error getting utfData as base64")
                    return nil
                }
                
                return ["Authorization":"Basic \(value)"]
            }
        }
        
        case qualityCheck
        case enroll
        
        func asURL() throws -> URL {
            var urlString = "https://18.194.82.72:8080"
            switch self {
            case .qualityCheck:
                urlString += "/qualityCheck/"
                if let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    urlString = urlStringEncoded
                }
            case .enroll:
                urlString += "/enroll"
            }
            
            return URL(string: urlString)!
        }
        
        var headers: HTTPHeaders? {
            guard var headers = Authentication.asHeader() else {
                debugPrint("Error while getting authorization header")
                return nil
            }
            
            switch self {
            case .qualityCheck:
                return nil
                
            case .enroll:
                headers["Content-Type"] = "application/vnd.tascent-bio.v1+json"
                //                headers["Accept"] = "application/json"
                return headers
            }
        }
    }
    
    private let delay = 0.5
    
    func qualityCheck(imageData: Data, completion: @escaping BoolErrorBlock) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(true, nil)
        }
        
    }
    
    private func getEnrollmentResult(from token: String) {
        //        curl -u apiuser:aRT98dPogR -k -H "Content-Type: application/vnd.tascent-bio.v1+json" -X GET https://<TIP_IP>:9090/enrollment-results/<token>/1
    }
    
    func enroll(user: User, completion: @escaping BoolErrorBlock) {
        let endpoint = Endpoint.enroll
        
        let jsonData = try! Data(contentsOf: Bundle.main.url(forResource: "face", withExtension: "json")!)
        var json = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
        json["token"] = "526d730f1c804b30a873b4d6efe8ec87"
        
        var request = URLRequest(url: try! endpoint.asURL())
        request.allHTTPHeaderFields = endpoint.headers
        request.httpMethod = "POST"
//        request.httpBody = "{\"key\":\"value\"}".data(using: String.Encoding.utf8)
        request.httpBody = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let httpResponse = response as? HTTPURLResponse {
                if error == nil {
                    switch httpResponse.statusCode {
                    case 200:
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: String], let token = json["value"] {
                                AppDefaults.shared.set(token: token, for: user)
                                completion(true, nil)
                            } else {
                                completion(false, "Serialization error")
                            }
                        } catch {
                            completion(false, "Error in JSONSerialization")
                        }
                        
                    case 400:
                        completion(false, "BAD REQUEST\nResponse: \n\(response?.debugDescription ?? "Empty")")
                        
                    default:
                        completion(false, "Unexpected status code \(httpResponse.statusCode)\nResponse: \n\(response?.debugDescription ?? "Empty")")
                    }
                    
                    
                } else {
                    completion(false, error!)
                }
            } else {
                completion(false, "Error casting to HTTPURLResponse")
            }
        }
        task.resume()
    }
    
    func buyTicket(for: Event, completion: @escaping BoolErrorBlock) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(true, nil)
        }
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // Always accepting since the provided url is https but is signed by a unknown authority
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    
}


// For Swift 3 and Alamofire 4.0
open class MyServerTrustPolicyManager: ServerTrustPolicyManager {
    
    // Override this function in order to trust any self-signed https
    open override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        return ServerTrustPolicy.disableEvaluation
        
        // or, if `host` contains substring, return `disableEvaluation`
        // Ex: host contains `my_company.com`, then trust it.
    }
}

//extension Dictionary where Key: String, Element: Any {
//    var jsonData: Data {
//        return try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
//    }
//}
