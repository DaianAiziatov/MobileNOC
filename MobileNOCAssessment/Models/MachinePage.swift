//
//  MachinePage.swift
//  MobileNOCAssessment
//
//  Created by Daian Aiziatov on 27/11/2018.
//  Copyright © 2018 Daian Aiziatov. All rights reserved.
//

import Foundation

class MachineData: Decodable {
    
    private(set) var content: [Machine]?
    private(set) var totalPages: Int?
    private(set) var totalElements: Int?
    private(set) var size: Int?
    private(set) var number: Int?
    
}
