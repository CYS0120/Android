//
//  SplashViewController.swift
//  BBQ_iOS
//
//  Created by winter on 2019. 1. 10..
//  Copyright © 2019년 fuzewire. All rights reserved.
//

import UIKit
import Firebase


class SplashViewController: BasicViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkVersion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if bool_autorotation {
//            return .allButUpsideDown
//        } else {
            return .portrait
//        }
    }
    
//    override var shouldAutorotate: Bool {
//        return true
//    }
    
    
    //
    // MARK: private
    //
    

    
    
    /*-----------------------------------------------------------------------
     * firebase에 등록된 iOS 버전 정보 획득
     *-----------------------------------------------------------------------*/
    func checkVersion() {
        
        let remoteConfig = RemoteConfig.remoteConfig()
        
        /*
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 60*10*6*24 // 하루에 한번만 체크
//        settings.minimumFetchInterval = 0               // 계속 체크
        remoteConfig.configSettings = settings
         */
        
        //
        // remote config 에서 매개변수 값 가져오기 - 60*10*6*24(하루에 한번)
        //
//        remoteConfig.fetch(withExpirationDuration: TimeInterval(60*10*6*24)) { status, error in
        remoteConfig.fetch(withExpirationDuration: TimeInterval(0)) { status, error in
            if let _ = error {
                self.goMain("MAIN")
                return
            }
            
            //
            // 정보추출 및 화면 이동 관련 처리
            //
            remoteConfig.activate { status, error in
                if error == nil {
                    
                    // splash 이미지 url 정보
                    if let splashImg = remoteConfig["SplashImage"].stringValue {
                        UserDefaults.standard.set(splashImg, forKey: "SplashImage")
                    }
                    
                    // cloud 버전
                    guard let cloudVersion = remoteConfig["IosVersion"].stringValue else {
                        self.goMain("MAIN")
                        return
                    }
                    
                    // 현재 앱 버전
                    guard let info       = Bundle.main.infoDictionary,
                          let curVersion = info["CFBundleShortVersionString"] as? String else {
                              self.goMain("MAIN")
                              return
                    }
                    
                    let cloud = Int(cloudVersion.replacingOccurrences(of: ".", with: "")) ?? 0
                    let cur   = Int(curVersion.replacingOccurrences(of: ".", with: "")) ?? 0
                    
                    // cloud 버전이 current 버전보다 큰 경우에만 업데이트 알림
                    if cloud > cur {
                        DispatchQueue.main.async {
                            self.showAlert()
                        }
                    } else {
                        self.goMain("MAIN")
                    }
                    
                    /*
                    // 버전 비교 처리 
                    if cloudVersion == curVersion {
                        self.goMain("MAIN")
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert()
                        }
                    }
                     */
                } else {
                    self.goMain("MAIN")
                }
            }
        }
    }
    
    
    /*-----------------------------------------------------------------------
     * 새로운 버전 등록에 대한 alert 보여준다.
     *-----------------------------------------------------------------------*/
    func showAlert() {
        
        //
        // 1. alert 생성
        //
        let alert = UIAlertController(title: "", message: "새로운 버전이 등록 되었습니다.\n업데이트 하시겠습니까?.", preferredStyle: .alert)

        
        //
        // 2. 취소 추가
        //
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
            self.goMain("MAIN")
        }
        alert.addAction(cancelAction)

        
        //
        // 3. 앱스토어로 이동 추가
        //
        let okAction = UIAlertAction(title: "이동", style: .default) { (action) in
            self.openScheme()
            self.goMain("MAIN")
        }
        alert.addAction(okAction)

//        print(Utils().getNowDateOnly())
//        Utils().setUpdateCheckDate(date: Utils().getNowDateOnly())
        
        //
        // 4. alert 보여준다.
        //
        self.present(alert, animated: true)
    }
    
    
    func openScheme() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: URL_UPDATE_STORE)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: URL_UPDATE_STORE)!)
        }
    }

    
    func goMain(_ url_type: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        appDelegate.shouldSupportAllOrientation = true
        appDelegate.goMain(url_type)
    }
}
