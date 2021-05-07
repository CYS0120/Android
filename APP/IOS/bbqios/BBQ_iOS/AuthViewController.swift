//
//  AuthViewController.swift
//  BBQ_iOS
//
//  Created by 장효원 on 2021/04/07.
//  Copyright © 2021 winter. All rights reserved.
//

import Foundation
import WebKit
import SwiftEventBus

class AuthViewController: BasicViewController {
    var wkWebView:WKWebView!
    var url:String!
    var checkFirst:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad()")
        
        let config = WKWebViewConfiguration()
        
        wkWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), configuration: config)
        
        wkWebView.uiDelegate = self
        wkWebView.navigationDelegate = self
        
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        wkWebView.allowsBackForwardNavigationGestures = true
        view.addSubview(wkWebView)
        
        if let url2 = URL(string: URL_BASE + url) {
            let request = URLRequest(url: url2)
            self.wkWebView.load(request)
            print("URL_BASE + url : \(URL_BASE + url)")
        }
    }
}
extension AuthViewController : WKNavigationDelegate, WKUIDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish webView url : \(webView.url?.absoluteString)")
        if webView.url != nil {
            if webView.url!.absoluteString == URL_BASE + "/pay/danal_auth/mobile/Ready.asp" {
                if checkFirst {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    checkFirst = true
                }
            }
            if webView.url!.absoluteString == URL_BASE + "/pay/danal_auth/mobile/Success.asp" {
                SwiftEventBus.postToMainThread("AuthViewController.finish")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
//    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
//        print("runJavaScriptAlertPanelWithMessage")
//    }
//
//    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        print("URLAuthenticationChallenge")
//    }
}
