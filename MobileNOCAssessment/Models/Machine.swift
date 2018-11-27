//
//  Machine.swift
//  MobileNOCAssessment
//
//  Created by Daian Aiziatov on 27/11/2018.
//  Copyright © 2018 Daian Aiziatov. All rights reserved.
//

import Foundation

struct Machine {
    
    private(set) var name: String
    private(set) var serialNumber: String?
    private(set) var ipAddress: String?
    private(set) var ipSubnetMask: String?
    private(set) var statusId: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case serialNumber
        case ipAddress
        case ipSubnetMask
        case status
    }
    
    enum StatusKeys: String, CodingKey {
        case statusId = "id"
    }
    
}

extension Machine: Decodable {
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        serialNumber = try? values.decode(String.self, forKey: .serialNumber)
        ipAddress = try? values.decode(String.self, forKey: .ipAddress)
        ipSubnetMask = try? values.decode(String.self, forKey: .ipSubnetMask)
        
        let status = try values.nestedContainer(keyedBy: StatusKeys.self, forKey: .status)
        statusId = try status.decode(Int.self, forKey: .statusId)
    }
    
}

