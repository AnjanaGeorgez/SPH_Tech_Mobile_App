//
//  DataUsage.swift
//  SPH_Mobile_App
//
//  Created by Anjana George on 15/8/20.
//  Copyright © 2020 Anjana George. All rights reserved.
//

import Foundation

struct DataUsage: Codable {
    var result: Result?
}

struct Result: Codable {
    var records: [Record]?
}

struct Record: Codable {
    var volume_of_mobile_data: String = ""
    var quarter: String = ""
}
