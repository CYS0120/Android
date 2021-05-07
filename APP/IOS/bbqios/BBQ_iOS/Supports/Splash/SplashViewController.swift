//
//  SplashViewController.swift
//  BBQ_iOS
//
//  Created by winter on 2019. 1. 10..
//  Copyright © 2019년 fuzewire. All rights reserved.
//

import UIKit

class SplashViewController: BasicViewController {
 
//    @IBOutlet weak var backgroundImageView : UIImageView!
    
    

    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        UIGraphicsBeginImageContext(view.frame.size)
//        UIImage(named: "splash_pattern")?.draw(in: self.view.bounds)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//
//        self.view.backgroundColor = UIColor.init(patternImage: image!)
//
  
//        if let bgColor = UIImage(named: "splash_pattern") {
//            let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
//            backgroundImageView.backgroundColor = UIColor.init(patternImage: bgColor)
//            self.view.insertSubview(backgroundImageView, at: 0)
//        }
//        self.backgroundImageView.backgroundColor = UIColor.green
        
//        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
//        backgroundImage.image = UIImage(named: "splash_pattern")
//        self.view.insertSubview(backgroundImage, atIndex: 0)

        
//        backgroundImageView.backgroundColor = UIColor.init(patternImage: UIImage(named: "splash_pattern")!)
        
//        UIGraphicsBeginImageContext(self.view.frame.size)
//        UIImage(named: "splash_pattern")?.draw(in: self.view.bounds)
//
//        if let image = UIGraphicsGetImageFromCurrentImageContext(){
//            UIGraphicsEndImageContext()
//            self.view.backgroundColor = UIColor(patternImage: image)
//        }else{
//            UIGraphicsEndImageContext()
//            debugPrint("Image not available")
//        }
        
        // test 추후 버전체크로 처리해야 함
        _ = try? isUpdateAvailable { (update, error) in
            if let error = error {
                print(error)
                self.goMain("MAIN")
            } else if let update = update {
                print(update)
                
//                _ = try? self.updateVersionInfo { (update, error) in
//                    if let error = error {
//                        print(error)
//                    } else if let update = update {
//                        print(update)
//                        
//                        
//                    }
//                }
                
                DispatchQueue.main.async {
                    if update { // 강제 업데이트 처리

                        if Utils().getUpdateCheckDate() == Utils().getNowDateOnly() {
                            self.goMain("MAIN")
                        } else {
                            let alertController = UIAlertController(title: "", message: "새로운 버전이 등록 되었습니다.\n업데이트 하시겠습니까?.", preferredStyle: .alert)

                            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
                                // do something
                                self.goMain("MAIN")
                            }
                            alertController.addAction(cancelAction)

                            let okAction = UIAlertAction(title: "이동", style: .default) { (action) in
                                // do something
                                self.openScheme()
                                self.goMain("MAIN")
                            }
                            alertController.addAction(okAction)

                            print(Utils().getNowDateOnly())
                            Utils().setUpdateCheckDate(date: Utils().getNowDateOnly())
                            self.present(alertController, animated: true)
                        
    //                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //                        appDelegate.goAppStore()
                        }
                    } else {
                        self.goMain("MAIN")
                    }
                }
                
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
//        UIGraphicsBeginImageContext(view.frame.size)
//        UIImage(named: "splash_pattern")?.draw(in: self.view.bounds)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//
//        self.view.backgroundColor = UIColor.init(patternImage: image!)
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "splash_pattern")!)
//        if let bgColor = UIImage(named: "splash_pattern") {
//            self.backgroundImageView.backgroundColor = UIColor.init(patternImage: bgColor)
//        }
        
        if UIDevice.current.orientation != UIDeviceOrientation.portrait {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            //            _ = self.shouldAutorotate
        }
        
//        self.goMain()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
     
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//
//    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if bool_autorotation {
//            return .allButUpsideDown
//        } else {
            return .portrait
//        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    enum VersionError: Error {
        case invalidResponse, invalidBundleInfo
    }
    
    func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) throws -> URLSessionDataTask {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
//            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=com.fuzewire.t-tube") else {
//                throw VersionError.invalidBundleInfo
            let url = URL(string: "http://itunes.apple.com/kr/lookup?bundleId=\(identifier)") else {
                    throw VersionError.invalidBundleInfo
        }
        print(currentVersion)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                print(json as Any)
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
                    throw VersionError.invalidResponse
                }
                let result_compare = Utils().checkVersionWithServerVersion(version, 1)
                
//                completion(version != currentVersion, nil)
//                print(Utils().checkVersionWithServerVersion(version, 1))
                completion(result_compare != 1, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }
    
    
    
    func openScheme() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: URL_UPDATE_STORE)!, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(URL(string: URL_UPDATE_STORE)!)
        }
    }

    
    func goMain (_ url_type: String) {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        appDelegate.shouldSupportAllOrientation = true
        appDelegate.goMain(url_type)

    }
    
    

    
}
