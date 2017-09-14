//
//  RestAPI.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 12/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation
import Alamofire

class RestAPI: APIClientProtocol {
    
    private enum Endpoint: URLConvertible {
        case qualityCheck
        case enroll
        
        func asURL() throws -> URL {
            var urlString = "https://api.address.com/api"
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
            switch self {
            case .qualityCheck:
                return nil
            case .enroll:
                return ["Content-Type":"application/vnd.tascent-bio.v1+json"]
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
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(true, nil)
        }
        
        return
        
        //        curl -u apiuser:aRT98dPogR -k -H "Content-Type: application/vnd.tascent-bio.v1+json" -X POST -d @face.json https://<TIP_IP>:8080/enroll/
        //        let parms = Parameters?
        let endpoint = Endpoint.enroll
        let data = Data()
        
        Alamofire.upload(data, to: endpoint)
            .uploadProgress(queue: DispatchQueue.main) { (progress: Progress) in
                debugPrint("Progress: \(progress.fractionCompleted)")
            }
            .response { (response: DefaultDataResponse) in
                debugPrint(response)
        }
        //            .responseJSON { (response: DataResponse<Any>) in
        //                if let error = response.error {
        //                    completion(false, error)
        //                } else {
        //                    if let json = response.value as? [String:Any] {
        //                        debugPrint(json)
        //                    } else {
        //                        completion(false, "Error parsing: \(response.value ?? "nil")")
        //                    }
        //                }
        //    }
        
        //        Alamofire.request(endpoint,
        //                          method: .post,
        //                          parameters: nil,
        //                          encoding: JSONEncoding.default,
        //                          headers: endpoint.headers)
        //            .pro { (progress: Progress) in
        //                debugPrint(progress)
        //            }
        //            .responseJSON { (response: DataResponse<Any>) in
        //                if let jsonData = response.data, let json = JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
        //                    debugPrint("")
        //                }
        //        }
    }
    
    func buyTicket(for: Event, completion: @escaping BoolErrorBlock) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(true, nil)
        }
    }
    
}
