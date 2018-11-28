//
//  Result.swift
//  MobileNOCAssessment
//
//  Created by Daian Aiziatov on 27/11/2018.
//  Copyright © 2018 Daian Aiziatov. All rights reserved.
//

import Foundation

enum Result<T, U: Error> {
    case success(T)
    case failure(U)
}
