//
//  BasicViewController.swift
//  BBQ_iOS
//
//  Created by winter on 2019. 1. 10..
//  Copyright © 2019년 fuzewire. All rights reserved.
//

import UIKit

import Foundation

public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    let output = items.map { "\($0)" }.joined(separator: separator)
    Swift.print(output, terminator: terminator)
//    #else
//    let output = items.map { "\($0)" }.joined(separator: separator)
//    Swift.print("", terminator: terminator)
    #endif
}

class BasicViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backClicked()  {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
//    func goGuide()  {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let guideViewController = storyboard.instantiateViewController(withIdentifier: "GuideViewController") as! GuideViewController
//        guideViewController.modalPresentationStyle = .popover
//        self.navigationController?.definesPresentationContext = true
//        self.present(guideViewController, animated: false, completion: nil)
//    }

}
