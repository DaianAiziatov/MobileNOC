//
//  MachinePage.swift
//  MobileNOCAssessment
//
//  Created by Daian Aiziatov on 27/11/2018.
//  Copyright © 2018 Daian Aiziatov. All rights reserved.
//

import Foundation

struct MachinePage: Decodable {
    
    private(set) var machines: [Machine]?
    private(set) var totalElements: Int
    private(set) var totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case machines = "content"
        case totalElements
        case totalPages
    }
    
}

