//
//  StubAPI.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 12/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation

class StubAPI: APIClientProtocol {
    
    private let delay = 0.5
    
    func qualityCheck(imageData: Data, completion: @escaping BoolErrorBlock) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(true, nil)
        }
    }
    
    func enroll(user: User, completion: @escaping EnrollmentBlock) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(true, nil, "TOKEN MOCADO")
        }
    }
    
    func buyTicket(for: Event, completion: @escaping BoolErrorBlock) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(true, nil)
        }
    }
    
    func getEnrollmentResult(for user: User, completion: @escaping (EnrollmentResultBlock)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(EnrollmentStatus.enrolled, nil)
        }
    }
}
