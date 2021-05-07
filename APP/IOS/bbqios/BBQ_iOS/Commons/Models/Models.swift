//
//  Models.swift
//  BBQ_iOS
//
//  Created by winter on 2019. 1. 10..
//  Copyright © 2019년 fuzewire. All rights reserved.
//

import UIKit
import WebKit

class PopupWebViewModel: NSObject {
    var rootUrl: URL?
    var webView: WKWebView?
    
    required override init() {
        super.init()
    }
    
    func createPopupWebView(createWebViewWith configuration: WKWebViewConfiguration,
                            for navigationAction: WKNavigationAction,
                            popupWebViewSize: CGRect) -> PopupWebViewModel? {
        
        
        guard let url = navigationAction.request.url else {
            print("error => url is nil")
            return nil;
        }
        
        self.rootUrl = url
        
        if #available(iOS 9, *) { }
        else {
            let path = Utils().getWithoutProtocolName(url: self.rootUrl!)
            
            let script = String(format:"var originalWindowClose=window.close;window.close=function(){var iframe=document.createElement('IFRAME');iframe.setAttribute('src','back://%@'),document.documentElement.appendChild(iframe);originalWindowClose.call(window)};", path)
            
            let userScript = WKUserScript.init(source: script, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
            
            let userController = WKUserContentController.init()
            
            userController.addUserScript(userScript)
            
            configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
            configuration.userContentController = userController
        }
        
        let wkWebView_popup = WKWebView.init(frame: popupWebViewSize,
                                             configuration: configuration)
        
        self.webView = wkWebView_popup
        
        return self

    }
    
    
}
