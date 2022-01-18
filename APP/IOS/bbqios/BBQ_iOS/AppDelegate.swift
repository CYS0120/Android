//
//  AppDelegate.swift
//  BBQ_iOS
//
//  Created by winter on 09/01/2019.
//  Copyright © 2019 winter. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let mainStoryboard: UIStoryboard
    let mainViewController: MainViewController
    let nvc: UINavigationController
    let gcmMessageIDKey = "gcm.message_id"
    
    
    override init() {
        mainStoryboard      =  UIStoryboard(name: "Main", bundle: nil)
        mainViewController  = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        nvc = MainNavigationController(rootViewController: mainViewController)
    }

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UIApplication.shared.applicationIconBadgeNumber = 0
        
        
        //앱 최초 실행시 키체인 비워준다.
        if !UserDefaults.standard.bool(forKey:"FirstRun") {
            UserDefaults.standard.set(true, forKey: "FirstRun")
            Utils().removeUserInfoAll()
        }
        
        HTTPCookieStorage.shared.cookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
        
        
        //
        // push(원격 알림 등록)
        //
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        
        //
        // splash 화면 보여준다.
        //
        let storyboard = UIStoryboard(name: "Splash", bundle: nil)
        let splashViewController = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController

        // self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = splashViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


    /*-----------------------------------------------------------------------
     * 푸시 수신시 처리
     *-----------------------------------------------------------------------*/
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        
        if application.applicationState == .active {
            print("앱이 켜져있는 상태")
        } else if application.applicationState == .background {
            print("앱이 내려가 있음")
        } else {
            print("푸시 메시지를 클릭하고 들어옴")
        }
        
    }
    

    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        Messaging.messaging().apnsToken = deviceToken
    }
    

    func goMain(_ url_type: String) {
        Utils().setUUID()
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { isCheck, error in
                if isCheck {
                    Utils().setDevicePushYn(yn: "Y")
                    Utils().setUserPushYn(yn: "Y")
                } else {
                    Utils().setDevicePushYn(yn: "N")
                    Utils().setUserPushYn(yn: "N")
                }
                
                self.mainViewController.url_type = url_type
            
                self.setNavigationController(self.nvc)
                
                DispatchQueue.main.async {
                    self.nvc.isNavigationBarHidden = true
                    self.window?.backgroundColor = UIColor.white
                    self.window?.rootViewController = self.nvc//mainViewController//nvc
                    self.window?.makeKeyAndVisible()
                }
        })
    }
     
    
    func setNavigationController(_ navigationController : UINavigationController) {
//        navigationController.navigationBar.tintColor = UIColor.black
//        navigationController.navigationBar.barTintColor = UIColor.white
//        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    

//    enum VersionError: Error {
//        case invalidResponse, invalidBundleInfo
//    }
//
    
    /*
    func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) throws -> URLSessionDataTask {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            //            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=com.fuzewire.t-tube") else {
            //                throw VersionError.invalidBundleInfo
            let url = URL(string: "http://itunes.apple.com/kr/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
//        print(currentVersion)
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
     */
}


//
//  MARK: push 수신시 처리
//


extension AppDelegate : UNUserNotificationCenterDelegate {
    
    /*-----------------------------------------------------------------------
     * 앱이 실행되는 도중에 알림이 도착하는 경우에 발생, 앱 실행중 알림배너를 표시하고 싶으면 구현한다.
     *-----------------------------------------------------------------------*/
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        
        // Change this to your preferred presentation option
        completionHandler([UNNotificationPresentationOptions.alert, UNNotificationPresentationOptions.sound])
    }

    
    /*-----------------------------------------------------------------------
     * 앱이 실행, 미실행 상관없이 로컬알림을 클릭했을때 동일하게 호출된다.
     *-----------------------------------------------------------------------*/
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        //
        // Print full message.
        //
        print(userInfo)
        
        UIApplication.shared.applicationIconBadgeNumber = 0

        
        //
        // TODO: 확인 할 것
        //
        if let pushType = userInfo["PUSHTYPE"] as? String {
            self.mainViewController.loadPushUrl(pushType)
        }

        completionHandler()
    }
}



//
// MARK:  MessagingDelegate
//



extension AppDelegate: MessagingDelegate {
    

    /*-----------------------------------------------------------------------
     * 토큰 정보 획득하여 저장
     *-----------------------------------------------------------------------*/
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        Utils().setPushToken(token: fcmToken)
    }
    
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("Received data message: \(remoteMessage.appData)")
//    }
}

