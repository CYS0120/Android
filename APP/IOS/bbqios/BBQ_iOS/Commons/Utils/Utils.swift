//
//  Utils.swift
//  BBQ_iOS
//
//  Created by winter on 2019. 1. 10..
//  Copyright © 2019년 fuzewire. All rights reserved.
//

import UIKit
import KeychainSwift
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class Utils: NSObject {
    func indicatorWith(animate: Bool) {
        let activiyData: ActivityData = ActivityData(size: CGSize(width: 50, height: 50), message: nil, messageFont: UIFont.systemFont(ofSize: 15), type: .ballClipRotatePulse, color: UIColor.white, padding: 0, displayTimeThreshold: 1, minimumDisplayTime: 2)
        
        if animate {
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activiyData, nil)
        } else {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
        }
    }
    
    func setupIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        //IQKeyboardManager.sharedManager().disabledToolbarClasses = self.getIQKeyboardManagerDisableViewControllers()
        //IQKeyboardManager.sharedManager().disabledDistanceHandlingClasses = self.getIQKeyboardManagerDisableViewControllers()
        //IQKeyboardManager.sharedManager().disabledTouchResignedClasses = self.getIQKeyboardManagerDisableViewControllers()
    }
    
    func showProgress() {
        self.indicatorWith(animate: true)
    }
    
    func dismissProgress(completion: (() -> ())?) {
        self.indicatorWith(animate: false)
    }
    
    func getProtocolName(url: URL) -> String {
        var httpProtocol = url.scheme
        httpProtocol = String(format:"%@://", httpProtocol!)
        
        return httpProtocol!
    }
    
    func getWithoutProtocolName(url: URL) -> String {
        var targetUrl = url.absoluteString
        let strHttpProtocol = self.getProtocolName(url: url)
        targetUrl = targetUrl.replacingOccurrences(of: strHttpProtocol, with: "")
        
        return targetUrl
    }
    
    //UUID 얻기
    func setUUID() {
        let keychain = KeychainSwift()
        if getUUID() == "" {
            let uuid = UUID().uuidString
            keychain.set(uuid, forKey: "key_uuid")
        }
        
        
    }
    
    func getUUID() -> String {
        let keychain = KeychainSwift()
        
        if let uuid = keychain.get("key_uuid") {
            return uuid
        }
        else {
            return ""
        }
    }
    
    //RGB 핵사코드로 부터 UIColor 얻기
    func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func setPushOnOff(state: Bool, key : String) {
        let keychain = KeychainSwift()
        keychain.set(state, forKey: key)
    }
    
    func getPushOnOff(key : String) -> Bool {
        let keychain = KeychainSwift()
        
        if let state = keychain.getBool(key) {
            return state
        }
        else {
            return false
        }
    }
    
    // set DevicePushYn
    func setDevicePushYn(yn: String) {
        let keychain = KeychainSwift()
        keychain.set(yn, forKey: "key_devicepushyn")
    }
    
    // get DevicePushYn
    func getDevicePushYn() -> String {
        let keychain = KeychainSwift()
        
        if let yn = keychain.get("key_devicepushyn") {
            return yn
        }
        else {
            return ""
        }
    }
    
    // set updateYn
    func setUpdateYn(yn: String) {
        let keychain = KeychainSwift()
        keychain.set(yn, forKey: "key_updateyn")
    }
    
    // get updateYn
    func getUpdateYn() -> String {
        let keychain = KeychainSwift()
        
        if let yn = keychain.get("key_updateyn") {
            return yn
        }
        else {
            return ""
        }
    }
    
    
    
    
    // set setUserPushYn
    func setUserPushYn(yn: String) {
        let keychain = KeychainSwift()
        keychain.set(yn, forKey: "key_userpushyn")
    }
    
    // get getUserPushYn
    func getUserPushYn() -> String {
        let keychain = KeychainSwift()
        
        if let yn = keychain.get("key_userpushyn") {
            return yn
        }
        else {
            return "Y"
        }
    }
    
    
    // set updateVersion
    func setUpdateVersion(version: String) {
        let keychain = KeychainSwift()
        keychain.set(version, forKey: "key_updateversion")
    }
    
    // get updateVersion
    func getUpdateVersion() -> String {
        let keychain = KeychainSwift()
        
        if let version = keychain.get("key_updateversion") {
            return version
        }
        else {
            return ""
        }
    }
    
    // set AccessToken
    func setAccessToken(token: String) {
        let keychain = KeychainSwift()
        keychain.set(token, forKey: "key_accesstoken")
    }
    
    // get AccessToken
    func getAccessToken() -> String {
        let keychain = KeychainSwift()
        
        if let token = keychain.get("key_accesstoken") {
            return token
        }
        else {
            return ""
        }
    }
    
    // set PushToken
    func setPushToken(token: String!) {
        let keychain = KeychainSwift()
        if (token != nil) {
            keychain.set(token, forKey: "key_pushtoken")
        } else {
            keychain.set("", forKey: "key_pushtoken")
        }
        
    }
    
    // get PushToken
    func getPushToken() -> String {
        let keychain = KeychainSwift()
        
        if let token = keychain.get("key_pushtoken") {
            return token
        }
        else {
            return ""
        }
    }
    
    //Keychain 저장소에 데이터 넣기
    func setUserid(userid: String) {
        let keychain = KeychainSwift()
        keychain.set(userid, forKey: "key_userid")
    }
    
    //Keychain 저장소에서 데이터 가져오기
    func getUserid() -> String {
        let keychain = KeychainSwift()
        
        if let userid = keychain.get("key_userid") {
            return userid
        }
        else {
            return ""
        }
    }
    
    //Keychain 저장 데이터 클리어
    func removeUserInfoAll() {
        let keychain = KeychainSwift()
        keychain.clear()
    }
    
    //현재 날짜 가져오기
    func getNowDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let result = formatter.string(from: date)
        
        return result
    }
    
    //현재 날짜 가져오기
    func getNowDateOnly() -> String {
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyyMMdd"
        
        let result = formatter.string(from: date)
        
        return result
    }
    
    // set PushToken
    func setUpdateCheckDate(date: String!) {
        let keychain = KeychainSwift()
//        print(date)
        if (date != nil) {
            keychain.set(date, forKey: "key_updatecheckdate")
        } else {
            keychain.set("", forKey: "key_updatecheckdate")
        }
        
    }
    
    // get PushToken
    func getUpdateCheckDate() -> String {
        let keychain = KeychainSwift()
        
        if let date = keychain.get("key_updatecheckdate") {
//            print(date)
            return date
        }
        else {
            return ""
        }
    }
    
    //현재 날짜 가져오기
    func getDateAdd(addDate: Int = 1) -> String {
        //        let date = Date()
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyyMMdd"
        
        if addDate == 12 {
            let date = Calendar.current.date(byAdding: .year, value: 1, to: Date())
            return formatter.string(from: date!)
        } else {
            let date = Calendar.current.date(byAdding: .month, value: addDate, to: Date())
            return formatter.string(from: date!)
        }
        
        
        //        let result = formatter.string(from: date!)
        //
        //        return result
    }
    
    //날짜 문자열을 Date 형태로 바꾸기
    func convertStringToDate(strDate: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: strDate)
        
        return date!
        
    }
    
    //날짜 문자열을 Date 년월일 형태로 바꾸기
    func convertStringToDateString(strDate: String, onlyDate: Bool) -> String {
        
        let dateFormatter = DateFormatter()
        if onlyDate {
            dateFormatter.dateFormat = "yyyy-MM-dd"
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        let date: Date = dateFormatter.date(from: strDate)!
        
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let updatedString = dateFormatter.string(from: date)
        return updatedString
        
    }
    
    func resizeImageSize(image: UIImage, newWidth: CGFloat) -> CGSize {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        return CGSize(width: newWidth, height: newHeight)
    }
    
    //JSON 텍스트 딕셔너리 형태로 변경
    func convertToDictionary(jsonText: String) -> [String: Any]? {
        if let data = jsonText.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
    
    
//    //인디케이터 초기화
//    func indicatorWith(animate: Bool) {
//        let activiyData: ActivityData = ActivityData(size: CGSize(width: 50, height: 50), message: nil, messageFont: UIFont.systemFont(ofSize: 15), type: .ballClipRotatePulse, color: UIColor.white, padding: 0, displayTimeThreshold: 1, minimumDisplayTime: 2)
//
//        if animate {
//            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activiyData)
//        } else {
//            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
//        }
//    }
//
//    //인디케이터 띄우기
//    func showProgress() {
//        self.indicatorWith(animate: true)
//    }
//
//    //인디케이터 없애기
//    func dismissProgress(completion: (() -> ())?) {
//        self.indicatorWith(animate: false)
//    }
    
//    //키보드 닫기 버튼 활성화
//    func setupIQKeyboardManager() {
//        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.disabledToolbarClasses = self.getIQKeyboardManagerDisableViewControllers()
//        IQKeyboardManager.shared.disabledDistanceHandlingClasses = self.getIQKeyboardManagerDisableViewControllers()
//        IQKeyboardManager.shared.disabledTouchResignedClasses = self.getIQKeyboardManagerDisableViewControllers()
//    }
    
    //키보드 닫기 버튼 예외 처리
    //(이곳에 추가하는 클래스는 키보드 상단 닫기 버튼이 비활성화 됨)
    func getIQKeyboardManagerDisableViewControllers() -> [UIViewController.Type] {
        return [MainViewController.self]
    }
    
    //앱버전 가져오기
    func getAppVersion() -> String {
        
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        return version
    }
    
    //UInt -> String
    func convertUIntToString(uint: UInt) -> String {
        
        let strUInt : String = String(format:"%u", uint)
        return strUInt
    }
    
//    //Double -> String
//    func convertDoubleToString(double: Double) -> String {
//        //        let aa = double.cleanDecimal()
//        //        print(aa)
//        let strDouble : String = double.cleanDecimal()//String(format:"%f", double)
//        return strDouble
//    }
    
    //Double -> String : 세자리 , 변환 / 소수점 자리수 지정...
    func convertDoubleToDecimalString(double: Double, decimal_point : Int = 0) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = NumberFormatter.RoundingMode.halfUp
        numberFormatter.maximumFractionDigits = decimal_point
        
        //        let price = Double("10005000.123456789")!
        let result = numberFormatter.string(from: NSNumber(value:double))!
        
        return result
    }
    
    //1 : 최신버전
    //-1 : 강제업데이트
    //0 : 최신버전 아님
    func checkVersionWithServerVersion (_ serverVersion : String!, _ compulsionNumber: NSInteger! ) -> (NSInteger) {
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        var arrDeviceVersion = version?.components(separatedBy: ".")
        var arrServerVersion = serverVersion?.components(separatedBy: ".")
        
        
        for (index, element) in (arrServerVersion?.enumerated())! {
            var nDevice =  Int((arrDeviceVersion![index] as String?)!)
            var nServer =  Int((element as String?)!)
            
            
            
            if nDevice! < 10 {
                nDevice =  nDevice! * 10
            } else {
                nDevice =  nDevice!
            }
            
            if nServer! < 10 {
                nServer = nServer! * 10
            } else {
                nServer = nServer!
            }
            
            if nDevice! < nServer! {
                if compulsionNumber <= (index+1) {
                    return -1
                }
                return 0
            }
        }
        
        return 1;
        
    }
    
}
