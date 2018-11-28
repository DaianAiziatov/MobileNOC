//
//  APIRequest.swift
//  MobileNOCAssessment
//
//  Created by Daian Aiziatov on 27/11/2018.
//  Copyright © 2018 Daian Aiziatov. All rights reserved.
//

import Foundation

struct APIRequest {
    var path: String {
        return "api/machine"
    }
    
    private(set) var username: String
    private(set) var password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
