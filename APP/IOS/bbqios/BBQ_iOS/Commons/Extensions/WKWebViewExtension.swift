//
//  WKWebViewExtension.swift
//  BBQ_iOS
//
//  Created by Seungmin Park on 2022/04/29.
//  Copyright © 2022 winter. All rights reserved.
//

import Foundation
import WebKit


typealias HTTPCookieHandler = ([HTTPCookie]?) -> Void


extension WKWebView {
    
    
    //
    // 모든 쿠키 정보 획득
    //
    func getAllCookies(completion: @escaping HTTPCookieHandler) {
        if #available(iOS 11.0, *) {
            configuration.websiteDataStore.httpCookieStore.getAllCookies { (cookies) in
                completion(cookies)
            }
        } else {
            completion(HTTPCookieStorage.shared.cookies)
        }
    }
    
    //
    // host에 해당하는 모든 쿠키 정보 획득
    //
    func getAllCookies(filter host: String, completion: @escaping HTTPCookieHandler) {
        getAllCookies { (cookies) in
            completion(cookies?.filter { host.range(of: $0.domain) != nil })
        }
    }
    
    //
    // cookie 정보 획득
    //
    func getCookie(filter host: String, name: String, completion: @escaping HTTPCookieHandler) {
        getAllCookies(filter: host) { (cookies) in
            completion(cookies?.filter {name.range(of: $0.name) != nil})
        }
    }
    
    
    func saveCookieToken(_ refreshToken: String) {
        if #available(iOS 11.0, *) {
            
//            let name = "refresh_token".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

            let cookie = HTTPCookie(properties: [
                .domain: COOKIE_URL,
                .path: "/",
                .name: "refresh_token",   // refresh_token, refresh%5Ftoken
                .value: refreshToken,
                .secure: "FALSE",
                .expires: NSDate(timeIntervalSinceNow: 31556926)
            ])!

//            let wkDataStore = WKWebsiteDataStore.nonPersistent()
////            wkDataStore.httpCookieStore.setCookie(cookie)
//            wkDataStore.httpCookieStore.setCookie(cookie) {
//                print("finish")
//            }

            configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
    }
}
