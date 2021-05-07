//
//  ResponseObjectMapperModels.swift
//  hongbanjang-iOS
//
//  Created by winter on 2019. 1. 10..
//  Copyright © 2019년 fuzewire. All rights reserved.
//

import UIKit
import ObjectMapper

// Response Object Model
// 전문의 형태대로 맵핑할 모델 정의
class ROMVersion: Mappable {
    var version_ios: String?
    var version_android: String?
    var updatedDate: String?
    
    required init?(map: Map) { }
    
    
    // ex) {"key1": {"key1-2":"value1"}}
    // 위와 같은 방식일때 key1-2 를 key1.key1-2 방식 사용 가능.
    // 만약 key1 을 모델화 하려면 key1을 dictionary 형태로 정의.
    func mapping(map: Map) {
        version_ios         <- map["newestVersions.iOS"]
        version_android     <- map["newestVersions.android"]
        updatedDate         <- map["newestUpdateDate"]
    }
}
