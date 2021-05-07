//
//  RequestService.swift
//  BBQ_iOS
//
//  Created by winter on 2019. 1. 10..
//  Copyright © 2019년 fuzewire. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import Moya_ObjectMapper
import ObjectMapper
import Alamofire


class RequestService: NSObject {
    
    let disposeBag = DisposeBag()
  
    
    func requestToServer(requestModel: RequestServiceModel,
                         successBlock: @escaping (_ responseJSONbody: String) -> (Void),
                         failBlock:  @escaping (_ failMessage: String) -> (Void),
                         errorBlock:  @escaping (_ errorMessage: String) -> (Void)) {
        
        self.requestToServer(requestModel: requestModel,
                             successBlock: successBlock,
                             failBlock: failBlock,
                             errorBlock: errorBlock,
                             isProgress: true)
        
    }
    
    
    func requestToServer(requestModel: RequestServiceModel,
                         successBlock: @escaping (_ responseJSONbody: String) -> (Void),
                         failBlock:  @escaping (_ failMessage: String) -> (Void),
                         errorBlock: @escaping (_ errorMessage: String) -> (Void),
                         isProgress: Bool) {
        
        let provider = MoyaProvider<RequestServiceModel>(plugins: [NetworkLoggerPlugin()])
        
        if isProgress {
            Utils().showProgress()
        }
       
        provider.request(requestModel) { result in
            
            Utils().dismissProgress(completion: { })
            
            switch result {
            case .success(let response):
                if let httpResponse = response.response {
                   
                    let statusCode =  httpResponse.statusCode
                    Utils().dismissProgress(completion: { })
                    //성공일떄는 200대
                       if statusCode >= 200 &&  statusCode < 300 {
                        let respString = String(data: response.data,
                                                encoding: String.Encoding.utf8) as String?
                       
                        successBlock(respString!)
                       } else {

//                        let respString = String(data: response.data,
//                                                encoding: String.Encoding.utf8) as String?
//                        let dic = Utils().convertToDictionary(jsonText: respString!)
//                        if dic != nil {
//                            print("서버 메시지 -  \(dic!["message"] as! String)")
//                            failBlock(dic!["message"] as! String)
//                        } else {
                            failBlock("서버 연결오류 입니다!")
//                        }
                    }
                }
                break
            case .failure(let error):
                Utils().dismissProgress(completion: { })
                print(error.errorDescription!)
                errorBlock(error.errorDescription!)
                break
                
           
            }
        }
    }
}


extension RequestService {
    

}
