//
//  RestAPI.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 12/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation
import Alamofire

enum EnrollmentStatus: String {
    case enrolled = "ENROLLED"
    case pending = "PENDING"
    case error = "ERROR"
    case duplicate = "DUPLICATE_DETECTED"
}

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
        case enrollmentResult(String)
        
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
                
            case .enrollmentResult(let token):
                urlString += "/enrollment-results/\(token)/1"
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
                return headers
                
            case .enrollmentResult:
//                headers.removeValue(forKey: "Authorization")
                headers["Accept"] = "application/vnd.tascent-bio.v1+json"
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
    
    func getEnrollmentResult(for token: String, completion: @escaping ((EnrollmentStatus?, Error?) -> ())) {
        //        curl -u apiuser:aRT98dPogR -k -H "Content-Type: application/vnd.tascent-bio.v1+json" -X GET https://<TIP_IP>:9090/enrollment-results/<token>/1
        let endpoint = Endpoint.enrollmentResult(token)
        
        var request = URLRequest(url: try! endpoint.asURL())
        var headers = endpoint.headers
//        headers?.removeValue(forKey: "Authorization")
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let httpResponse = response as? HTTPURLResponse {
                if error == nil {
                    if let status = HTTPStatusCode(HTTPResponse: httpResponse) {
                        switch status {
                        case .ok:
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: String], let statusString = json["status"] {
                                    if let status = EnrollmentStatus(rawValue: statusString) {
                                        completion(status, nil)
                                    } else {
                                        completion(nil, "Unknown status string returned from API: \(statusString)")
                                    }
                                } else {
                                    completion(nil, "Serialization error")
                                }
                            } catch {
                                completion(nil, "Error in JSONSerialization")
                            }
                            
                        case .badRequest:
                            completion(nil, "BAD REQUEST\nResponse: \n\(response?.debugDescription ?? "Empty")")
                            
                        case .notFound:
                            completion(nil, "Enrollment token '\(token)' not found!")
                            
                        default:
                            completion(nil, "Unexpected status code \(status)(\(status.rawValue))\nResponse: \n\(response?.debugDescription ?? "Empty")")
                        }
                    } else {
                        completion(nil, "Unexpected status code \(httpResponse.statusCode)\nResponse: \n\(response?.debugDescription ?? "Empty")")
                    }
                } else {
                    completion(nil, error!)
                }
            } else {
                completion(nil, "Error casting to HTTPURLResponse")
            }
        }
        task.resume()

    }
    
    func enroll(user: User, completion: @escaping BoolErrorBlock) {
        let endpoint = Endpoint.enroll
        
        let jsonData = try! Data(contentsOf: Bundle.main.url(forResource: "face", withExtension: "json")!)
        var json = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
        json["token"] = "526d730f1c804b30a873b4d6efe8ec87"
        
        var request = URLRequest(url: try! endpoint.asURL())
        request.allHTTPHeaderFields = endpoint.headers
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let httpResponse = response as? HTTPURLResponse {
                if error == nil {
                    switch httpResponse.statusCode {
                    case 200:
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: String], let token = json["value"] {
                                AppDefaults.shared.set(token: token)
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
