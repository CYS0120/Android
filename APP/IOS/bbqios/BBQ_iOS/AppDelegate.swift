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

    let mainStoryboard : UIStoryboard
    let mainViewController : MainViewController
    let nvc: UINavigationController
    
    
    let gcmMessageIDKey = "gcm.message_id"
    
    override init() {
       mainStoryboard =  UIStoryboard(name: "Main", bundle: nil)
       mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        nvc = MainNavigationController(rootViewController: mainViewController)
//        setNavigationController(nvc)
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
        // token 정보 저장 ??, 여기서 하는지 확인 할 것
        //
        if let token = Messaging.messaging().fcmToken {
            Utils().setPushToken(token: token)
        }
        
        
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
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

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
        
        
        //
        // TODO: token 정보 여기서 저장하는게 나은지 확인 할 것
        //
        let deviceToken = deviceToken.map { String(format: "%02x", $0) }.joined()
        Utils().setPushToken(token: deviceToken)
        print("deviceToken: \(deviceToken)")
    }
}


// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
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

    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
//        let deviceId = UIDevice.current.identifierForVendor!.uuidString
//        print("deviceId :: \(deviceId)")

        //푸시 분기처리
        /*
        var push_type : String = ""
        if userInfo["PUSHTYPE"] != nil {
            push_type = userInfo["PUSHTYPE"] as! String
        }
        
        if push_type != "" {
            if let url = URL(string: "https://m.bbq.co.kr/main.asp?pushtype=" + push_type) {
                UIApplication.shared.open(url, options: [:])
            }
        }
         */
        
        if let pushType = userInfo["PUSHTYPE"] as? String {
            
            // TODO: main으로 broadcast 한다.
            if let url = URL(string: "https://m.bbq.co.kr/main.asp?pushtype=" + pushType) {
                UIApplication.shared.open(url, options: [:])
            }
        }

        
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate: MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        //
        // TODO: token 정보 여기서 저장하는게 나은지 확인 할 것
        //
        Utils().setPushToken(token: fcmToken)
    }
    
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("Received data message: \(remoteMessage.appData)")
//    }
    
    
    // [END ios_10_data_message]
}

