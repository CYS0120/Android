//
//  RequestServiceModel.swift
//  BBQ_iOS
//
//  Created by winter on 2019. 1. 10..
//  Copyright © 2019년 fuzewire. All rights reserved.
//

import UIKit
import Moya

enum RequestServiceModel {
    case recordStartPrepare(mb_id: String, wr_id: String, channel_num : String)
}

// MARK: - TargetType Protocol Implementation
extension RequestServiceModel: TargetType {
    
    var baseURL: URL { return URL(string: URL_BASE)! }

    var path: String {
        switch self {
        case .recordStartPrepare(_, _, _) :
            return MAIN_URL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .recordStartPrepare:
            return .post
        }
    }
    
    var task: Task {
        switch self {

        case .recordStartPrepare(let mb_id, let wr_id, let channel_num):
            return .requestParameters(parameters: ["wContentId": wr_id, "chName": channel_num, "streamName": channel_num],
                                      encoding: JSONEncoding.default)

        }
    }
    
    var headers: [String: String]? {
        var token : String!
        if Utils().getAccessToken() == "" {
            token = ""
        } else {
            token = "JWT " +  Utils().getAccessToken()
        }
      
        return ["Content-type": "application/json",
                "os": "I",
                "version": Utils().getAppVersion(),
                "AUTHORIZATION": token ]
       
    }
    
    var sampleData: Data {
        return Data()
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

