//
//  RestAPI.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 12/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation

class RestAPI: APIClientProtocol {
    
    private enum Enpoint {
        case qualityCheck
        
        var url: URL {
            var urlString = "https://api.address.com/"
            switch self {
            case .qualityCheck:
                urlString += "/qualityCheck/"
                if let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    urlString = urlStringEncoded
                }
            }
            
            return URL(string: urlString)!
        }
    }
    
    func qualityCheck(imageData: Data, completion: @escaping BoolErrorBlock) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(true, nil)
        }
    }
    
    func enroll(completion: @escaping BoolErrorBlock) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(true, nil)
        }
    }
    
    func buyTicket(for: Event, completion: @escaping BoolErrorBlock) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(true, nil)
        }
    }
    
}
