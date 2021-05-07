//
//  Extensions.swift
//  BBQ_iOS
//
//  Created by winter on 2019. 1. 10..
//  Copyright © 2019년 fuzewire. All rights reserved.
//

import UIKit
import PopupDialog

extension UIViewController {
    
    func showConfirmDialog (title: String,
                            message: String) {
        self.showConfirmDialog(title: title, message: message) { }
    }
    
    func showConfirmDialog (title: String,
                            message: String,
                            completion: (() -> Void)? = nil) {
        
//        let popup = PopupDialog(title: title,
//                                message: message,
//                                buttonAlignment: .horizontal,
//                                transitionStyle: .zoomIn,
//                                gestureDismissal: true,
//                                completion: completion)

        let popup = PopupDialog(title: title,
                                message: message,
                                image: nil,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                preferredWidth: 340,
                                tapGestureDismissal: true,
                                panGestureDismissal: false,
                                hideStatusBar: false,
                                completion: completion)
        
        let button = DefaultButton(title: "확인") { }
        
        popup.addButtons([button])
        
        self.present(popup, animated: true, completion: nil)
    }
    
    func showConfirmSelectDialog (title: String,
                                  message: String,
                                  positiveButtonTitle: String,
                                  nagativeButtonTitle: String,
                                  positiveCompletion: (() -> Void)? = nil,
                                  nagativeCompletion: (() -> Void)? = nil,
                                  completion: (() -> Void)? = nil) {
        
//        let popup = PopupDialog(title?: title,
//                                message: message,
//                                buttonAlignment: .horizontal,
//                                transitionStyle: .zoomIn,
//                                gestureDismissal: true,
//                                completion: completion)

        let popup = PopupDialog(title: title,
                                message: message,
                                image: nil,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                preferredWidth: 340,
                                tapGestureDismissal: true,
                                panGestureDismissal: false,
                                hideStatusBar: false,
                                completion: completion)

        let pbutton = DefaultButton(title: positiveButtonTitle, action: positiveCompletion)
        let nbutton = CancelButton(title: nagativeButtonTitle, action: nagativeCompletion)
        
        popup.addButtons([pbutton, nbutton])
        
        self.present(popup, animated: true, completion: nil)
    }
    
    func showDialog (title: String,
                     message: String,
                     button1: CancelButton,
                     button2: DefaultButton) {
        
//        let popup = PopupDialog(title: title,
//                                message: message,
//                                buttonAlignment: .horizontal,
//                                transitionStyle: .zoomIn,
//                                gestureDismissal: true) { }

        let popup = PopupDialog(title: title,
                                message: message,
                                image: nil,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                preferredWidth: 340,
                                tapGestureDismissal: true,
                                panGestureDismissal: false,
                                hideStatusBar: false,
                                completion: nil)

        popup.addButtons([button1, button2])
        
        self.present(popup, animated: true, completion: nil)
    }
    
}

extension Array where Element: Equatable {
    
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
