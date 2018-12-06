//
//  MachineAction.swift
//  MobileNOCAssessment
//
//  Created by Daian Aiziatov on 30/11/2018.
//  Copyright © 2018 Daian Aiziatov. All rights reserved.
//

import Foundation

class MachineAction {
    
    private(set) var type: ActionType
    var isSelected: Bool!
    
    init(type: ActionType) {
        self.type = type
        self.isSelected = false
    }
    
    enum ActionType {
        case mute
        case timer
        case call
        case check
    }
}
