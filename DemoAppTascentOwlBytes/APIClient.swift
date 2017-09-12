//
//  APIClient.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 12/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation

typealias BoolErrorBlock = (Bool, Error?) -> ()

protocol APIClientProtocol {
    func qualityCheck(imageData: Data, completion: @escaping BoolErrorBlock)
    func enroll(completion: @escaping BoolErrorBlock)
    func buyTicket(for: Event, completion: @escaping BoolErrorBlock)
}
