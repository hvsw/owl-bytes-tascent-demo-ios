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

class RestAPI: NSObject, APIClientProtocol, URLSessionDelegate, XMLParserDelegate, NSURLConnectionDelegate {
    
    private var mutableData = Data()
    
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
            var urlString = "https://18.194.82.72"
            switch self {
            case .qualityCheck:
                urlString = "http://52.59.48.9:8080"
                
            case .enroll:
                urlString += ":8080/enroll"
                
            case .enrollmentResult(let token):
                urlString += ":9090/enrollment-results/\(token)/1"
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
                headers["Accept"] = "application/vnd.tascent-bio.v1+json"
                return headers
            }
        }
    }
    
    
    private let delay = 0.5
    
    private func generateSoapString(imageId: String, imageContent: String) -> String {
        var soapString = "<soap:Envelope\n"
        soapString += "xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"\n"
        soapString += "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n"
        soapString += "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">\n"
        soapString += "<soap:Body>\n"
        soapString += "<SimpleQualityCheckRequest xmlns=\"http://docs.oasis-open.org/bias/ns/bias-1.0/\">\n"
        // soapString += "<algorithm>algorithm</algorithm>\n"
        soapString += "<biometricImages>\n"
        soapString += "<biometricImage>\n"
        soapString += "<imageId>\(imageId)</imageId>\n"
        soapString += "<modality>FACE</modality>\n"
        soapString += "<imageContent>\(imageContent)</imageContent>\n"
        soapString += "</biometricImage>\n"
        soapString += "</biometricImages>\n"
        soapString += "</SimpleQualityCheckRequest>\n"
        soapString += "</soap:Body>\n"
        soapString += "</soap:Envelope>"
        
        return soapString
    }
    
    func qualityCheck(imageData: Data, completion: @escaping BoolErrorBlock) {
        let soapMessage = generateSoapString(imageId: "1", imageContent: imageData.base64)
        var theRequest = URLRequest(url: URL(string: "http://52.59.48.9:8080/")!)
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        URLSession.shared.dataTask(with: theRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            print(data)
            print(response)
            print(error)
        }.resume()
        
    }
    
    //        curl -u apiuser:aRT98dPogR -k -H "Content-Type: application/vnd.tascent-bio.v1+json" -X GET https://18.194.82.72:9090/enrollment-results/<token>/1
    func getEnrollmentResult(for user: User, completion: @escaping ((EnrollmentStatus?, Error?) -> ())) {
        let endpoint = Endpoint.enrollmentResult(user.token)
        
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
                            completion(nil, "Enrollment token '\(user.token)' not found!")
                            
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
    
    //    curl -u apiuser:aRT98dPogR -k -H "Content-Type: application/vnd.tascent-bio.v1+json" -X POST -d @face.json https://18.194.82.72:8080/enroll/
    func enroll(user: User, completion: @escaping EnrollmentBlock) {
        let endpoint = Endpoint.enroll
        
        let jsonData = try! Data(contentsOf: Bundle.main.url(forResource: "face", withExtension: "json")!)
        var json = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
        //        json["token"] = "526d730f1c804b30a873b4d6efe8ec87"
        
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
                                completion(true, nil, token)
                            } else {
                                completion(false, "Serialization error", nil)
                            }
                        } catch {
                            completion(false, "Error in JSONSerialization", nil)
                        }
                        
                    case 400:
                        completion(false, "BAD REQUEST\nResponse: \n\(response?.debugDescription ?? "Empty")", nil)
                        
                    default:
                        completion(false, "Unexpected status code \(httpResponse.statusCode)\nResponse: \n\(response?.debugDescription ?? "Empty")", nil)
                    }
                    
                    
                } else {
                    completion(false, error!, nil)
                }
            } else {
                completion(false, "Error casting to HTTPURLResponse", nil)
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
//open class MyServerTrustPolicyManager: ServerTrustPolicyManager {
//
//    // Override this function in order to trust any self-signed https
//    open override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
//        return ServerTrustPolicy.disableEvaluation
//
//        // or, if `host` contains substring, return `disableEvaluation`
//        // Ex: host contains `my_company.com`, then trust it.
//    }
//}

//extension Dictionary where Key: String, Element: Any {
//    var jsonData: Data {
//        return try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
//    }
//}
