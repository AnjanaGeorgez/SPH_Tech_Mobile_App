//
//  Service.swift
//  SPH_Mobile_App
//
//  Created by Anjana George on 15/8/20.
//  Copyright © 2020 Anjana George. All rights reserved.
//

import Moya

enum Service {
    case getData
}

// MARK: - TargetType Protocol Implementation
extension Service: TargetType {
    
    var baseURL: URL { return URL(string: "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f")! }
    var path: String {
        switch self {
        case .getData:
            return ""
        }
    }
    var method: Moya.Method {
        switch self {
        case .getData:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .getData: // Send no parameters
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getData:
            // Provided you have a file named mockData.json 
            guard let url = Bundle.main.url(forResource: "mockData", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
