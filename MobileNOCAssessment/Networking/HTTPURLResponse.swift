//
//  HTTPURLResponse.swift
//  MobileNOCAssessment
//
//  Created by Daian Aiziatov on 27/11/2018.
//  Copyright © 2018 Daian Aiziatov. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}
