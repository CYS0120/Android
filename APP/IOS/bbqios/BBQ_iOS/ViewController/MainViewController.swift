//
//  MainViewController.swift
//  BBQ_iOS
//
//  Created by winter on 2019. 1. 10..
//  Copyright © 2019년 fuzewire. All rights reserved.
//

import UIKit
import WebKit
import PopupDialog
import QuickLook
import SwiftEventBus

import SafariServices
import Lottie


class MainViewController: BasicViewController, UIScrollViewDelegate, QLPreviewControllerDataSource, SFSafariViewControllerDelegate {

    var wkWebView: WKWebView!
    var webViews: Array<PopupWebViewModel> = []
    var currentTopWebView: WKWebView?
    var isFirst: Bool = true

    @IBOutlet weak var layerView: UIView!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var splashImageView: UIImageView!
    
    var wkWebViewBottomConstraint: NSLayoutConstraint!
    var wkWebViewTopConstraint: NSLayoutConstraint!
    var wkWebViewRightConstraint: NSLayoutConstraint!
    var wkWebViewLeftConstraint: NSLayoutConstraint!

    var lastContentOffset: CGPoint!

    var documentPreviewController = QLPreviewController()
    var documentUrl = URL(fileURLWithPath: "")
    var documentDownloadTask: URLSessionTask?
    
    var url_type: String = "LOGIN"
    
    var bool_autorotation = false
    var bool_liveautorotation = false
    
    //요기요처리
    var goMain = false
    var installedyogiyo = false
    
    var isGoMain = false
    
    
    //
    var year : Int?;
    var month : Int? ;
    var day :Int? ;
    var hour : Int? ;
    var min : Int? ;
    
    var caching : Bool?;
    
    //2019 0524 바코드값 저장
    public var strBarCode : String?
    public var isSetBarCode : Bool = false
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
//        print("init nibName style")
//        self.year = UserDefaults.standard.value(forKey: "year") as! Int
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }

    required init?(coder aDecoder: NSCoder) {
        print("init coder style")
    
        self.year = UserDefaults.standard.value(forKey: "year") as? Int
        self.month = UserDefaults.standard.value(forKey: "month") as? Int
        self.day   = UserDefaults.standard.value(forKey: "day") as? Int
        self.hour  = UserDefaults.standard.value(forKey: "hour") as? Int
        self.min   = UserDefaults.standard.value(forKey: "min") as? Int
        print(self.year ?? 0)
        print(self.month ?? 0)
        print(self.day ?? 0)
        print(self.hour ?? 0)
        print(self.min ?? 0)

        super.init(coder: aDecoder)
    }



    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnBack.isHidden = true

        
        let animationView = AnimationView(name:"bbq-logo")
        animationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 200 , height: self.view.frame.height)
        animationView.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 40)
        animationView.contentMode = .scaleAspectFit
        self.view.addSubview(animationView)

        animationView.play { _ in
            UIView.transition(with: self.view, duration: 0.4, options: [.transitionCrossDissolve], animations: {
                animationView.removeFromSuperview()
            })

//            let url = URL(string: "https://m.bbq.co.kr/images/Loading_Image.png")
            if let splash = UserDefaults.standard.string(forKey: "SplashImage"), let url = URL(string: splash) {
                if let data = try? Data(contentsOf: url) {
                    self.splashImageView.image = UIImage(data: data)
                }
            }
            
            self.initWebKit()
            self.lastContentOffset = CGPoint(x: 0.0, y: 0.0)
        }

        
//        // 비동기 호출방식일경우
//        _ = try? self.updateVersionInfo { (update, error) in
//            if let error = error {
//                print(error)
//            } else if let update = update {
//                print(update)
//            }
//        }
        
//        self.createUserPassword()
    }

//    enum VersionError: Error {
//        case invalidResponse, invalidBundleInfo
//    }
    
    
    @IBAction func onPressedWebViewHomeButton(_ sender: Any) {
        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(isSetBarCode)
        {
            isSetBarCode = false
            wkWebView.evaluateJavaScript("iosbarCodeData('\(strBarCode ?? "")')",completionHandler: nil)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if bool_autorotation {
            return .allButUpsideDown
        } else if bool_liveautorotation {
            return .landscape
        } else {
            return .portrait
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    func bringToFromWebViewNavigationItems(topWebView: WKWebView) {
        self.view.bringSubviewToFront(self.btnBack)
        self.currentTopWebView = topWebView
    }

    @IBAction func onPressedWebViewHistoryBackButton(_ sender: Any) {
        
        if (self.currentTopWebView?.canGoBack)! {
            self.currentTopWebView?.goBack()
        }
        else {
            var foundWebView: PopupWebViewModel? = nil
            
            for wv in self.webViews {
                if (wv.webView?.isEqual(self.currentTopWebView))! {
                    wv.webView?.removeFromSuperview()
                    foundWebView = wv
                    break;
                }
            }
            
            if let foundWv = foundWebView {
                self.webViews.remove(object: foundWv)
            }
            
            if self.webViews.count > 0 {
                self.bringToFromWebViewNavigationItems(topWebView: (self.webViews.last?.webView)!)
            }
            else {
                self.onPressedWebViewHomeButton((Any).self)
                //self.bringToFromWebViewNavigationItems(topWebView: self.wkWebView)
            }
            self.btnBack.isHidden = true
        }
        
    }
    
    
    func clearCache(arr :DateComponents)
    {
        // 웹뷰 디스크캐시 삭제
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeLocalStorage])
        let date_data = NSDate(timeIntervalSince1970: 0)
        
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set, modifiedSince: date_data as Date, completionHandler: {})
        //   모든 열어본 페이지에 대한 데이터를 모두 삭제 //https://g-y-e-o-m.tistory.com/83
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("[WebCacheCleaner] Record \(record) deleted")
            }
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(arr.year,forKey: "year")
        print(self.year ?? 0)
        userDefaults.set(arr.month,forKey: "month")
        print(self.month ?? 0)
        userDefaults.set(arr.day,forKey: "day")
        print(self.day ?? 0)
        userDefaults.set(arr.hour,forKey: "hour")
        print(self.hour ?? 0)
        userDefaults.set(arr.minute,forKey: "min")
        print(self.min ?? 0)
    }
    
    func initWebKit() {

        currentTopWebView = self.wkWebView

        var viewBounds = self.view.bounds
        viewBounds.origin.y = viewBounds.origin.y
        viewBounds.size.height = viewBounds.size.height


        let contentController = WKUserContentController()
        contentController.add(
            self,
            name: "callbackHandler"
        )
        contentController.add(
            self,
            name: "bbqHandler"
        )
        // init this view controller to receive JavaScript callbacks
        contentController.add(self, name: "openDocument")
        contentController.add(self, name: "jsError")
        contentController.add(self, name: "openPopup")
        
        // QuickLook document preview
        documentPreviewController.dataSource  = self
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        // inline video 허용여부
        config.allowsInlineMediaPlayback = true
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        //calendar 정보 받아오기
        let cal = Calendar.current
        let date = Date()
        let arr = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        print(arr)
        
        
        
       
        
        //현재 시간과 저장된 시간을 비교해서 3시간 이상이면 캐시설정을 clear하고,캐시설정이 clear이면 캐시설정을 캐싱으로 하고 다시 시간을 처음부터 설정하여 체크한다.
        
        //self.year nil 이면 최초라는 의미
        if let lyear = self.year
        {
            //3시간 초과
            if(lyear < arr.year!)
            {
                 clearCache(arr: arr)
            }
            else
            {
                if let lmonth = self.month
                {
                    if(lmonth < arr.month!)//3시간초과
                    {
                        clearCache(arr: arr)
                    }
                    else
                    {
                        if let lday = self.day
                        {
                            if(lday < arr.day!)//3시간초과
                          {
                             clearCache(arr: arr)
                          }
                           else{
                              if let lhour = self.hour{
                                if(lhour + 3 <= arr.hour!)
                                {
                                    if let lmin = self.min
                                    {
                                        if(lmin < arr.minute!)//3시간 초과시,
                                        {
                                            print("if(lmin < arr.minute!)")
                                            // 웹뷰 디스크캐시 삭제
                                            let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeLocalStorage])
                                            let date_data = NSDate(timeIntervalSince1970: 0)
                                            
                                            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set, modifiedSince: date_data as Date, completionHandler: {})
                                            //   모든 열어본 페이지에 대한 데이터를 모두 삭제 //https://g-y-e-o-m.tistory.com/83
                                            WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                                                records.forEach { record in
                                                    WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                                                    print("[WebCacheCleaner] Record \(record) deleted")
                                                }
                                            }
                                            let userDefaults = UserDefaults.standard
                                        
                                            userDefaults.set(arr.hour,forKey: "hour")
                                            print(self.hour)
                                            userDefaults.set(arr.minute,forKey: "min")
                                            print(self.min)
                                        }
                                    }
                                }
                                else
                                {
                                   print(" if(lhour + 3 <= arr.hour!) 3시간초과하지않음")
                                }
                               }
                             else
                              {
                             
                              }
                            }
                        }
                    }
                }
                
            }
        }
        else
        {
            let userDefaults = UserDefaults.standard
            userDefaults.set(arr.year,forKey: "year")
            print(self.year ?? 0)
            userDefaults.set(arr.month,forKey: "month")
            print(self.month ?? 0)
            userDefaults.set(arr.day,forKey: "day")
            print(self.day ?? 0)
            userDefaults.set(arr.hour,forKey: "hour")
            print(self.hour ?? 0)
            userDefaults.set(arr.minute,forKey: "min")
            print(self.min ?? 0)
        }
        
//        //default data store 캐쉬 저장여부 작업 20190507
//        config.websiteDataStore = WKWebsiteDataStore.default()
//        //no data cache will be written to the file 아래의 웹뷰 디스크캐시 삭제와 같이 적용,이부분안해주면 안된다고
//        //하는 인터넷 내용이 있어 추가
//        config.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        
        //https://novemberfive.co/blog/WKWebView-redirect-with-cookies
        //https://learnappmaking.com/wkwebview-how-to/
        //https://github.com/ShingoFukuyama/WKWebViewTips
        //https://g-y-e-o-m.tistory.com/83
        

        wkWebView = WKWebView(frame: CGRect.zero, configuration: config)
        wkWebView.uiDelegate = self
        wkWebView.navigationDelegate = self

        wkWebView.scrollView.delegate = self

        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        
        wkWebView.allowsBackForwardNavigationGestures = true
        
//        wkWebView.allcowsIn
        
        
        // 캐쉬 삭제 wkwebview는 nsurlcache를 사용하지 않는다.
    
        // 웹뷰 디스크캐시 삭제
//        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeLocalStorage])
//        let date_data = NSDate(timeIntervalSince1970: 0)
//
//        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set, modifiedSince: date_data as Date, completionHandler: {})


        
        print("delete disk cache")
        

//        wkWebView.isOpaque = false
//        wkWebView.backgroundColor = UIColor.black
        view.addSubview(layerView)
        wkWebView.isHidden = true
        view.addSubview(wkWebView)
        self.wkWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
//        self.wkWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack), options: .new, context: nil)
//        self.wkWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward), options: .new, context: nil)


        self.initWebViewConstraints(webView: self.wkWebView)

        print(url_type)
        
        // custom agent
        self.wkWebView.evaluateJavaScript("navigator.userAgent") { [weak self] (result, error) in
            if self == nil || error != nil {
                return
            }
            if let userAgent = result as? String {
                self?.wkWebView.customUserAgent = userAgent + "bbqiOS"
            }
            
            self?.wkWebView.evaluateJavaScript("navigator.userAgent") { [weak self] (result, error) in
                if self == nil || error != nil {
                    return
                }
                if let userAgent = result as? String {
                    print(";"+userAgent+";")
                }
            }
            
        }
        
        self.loadUrl()

        self.bringToFromWebViewNavigationItems(topWebView: wkWebView)

        
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") { // listen to changes and updated view
            if self.wkWebView.estimatedProgress == 1 {
                self.dismissProgreeForWebView()
            }
            else {
//                print(Float(self.wkWebView.estimatedProgress))
            }
        }
        if keyPath == #keyPath(WKWebView.canGoBack) || keyPath == #keyPath(WKWebView.canGoForward) {
            // Do Something...
        }
    }
    
//    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
//        return navigationController.visibleViewController?.supportedInterfaceOrientations ?? .portrait
//    }
    
    
    
    /*
        TODO
        이동하는 url 정보 : https://m.bbq.co.kr/main.asp?deviceId="+deviceId+"&token="+token+"&osTypeCd=ANDROID&pushtype="+pushType+"&version="+appVersion
     */
    func loadUrl() {
//        // push token test...
//        Utils().setPushToken(token: "testtoken")
        let DELAY_SECONDS = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + DELAY_SECONDS) {
            let deviceId = Utils().getUUID()
            let token    = Utils().getPushToken()
            let version  = Utils().getAppVersion()
            
            
            print("self.url_type :: \(self.url_type)")
            if self.url_type == "MAIN" {
                if let url = URL(string: MAIN_URL+"/main.asp?osTypeCd=IOS&deviceId=" + deviceId + "&token=" + token + "&version=" + version) {
                    let request = URLRequest(url: url)
                    self.wkWebView.load(request)
                }
            } else {
                if let url = URL(string: MAIN_URL) {
                    let request = URLRequest(url: url)
                    self.wkWebView.load(request)
                }
            }
        }
    }

        
    //
    // 수신한 push 정보로 webView url 이동
    //
    func loadPushUrl(_ pushType: String) {
        let deviceId = Utils().getUUID()
        let token    = Utils().getPushToken()
        let version  = Utils().getAppVersion()
        
        let move     = MAIN_URL + "main.asp?osTypeCd=IOS&deviceId=" + deviceId + "&token=" + token + "&pushtype=" + pushType + "&version=" + version
        
        guard let url = URL(string: move) else {
            return
        }
        
        let request = URLRequest(url: url)
        self.wkWebView.load(request)
    }
    
    
    func showProgressForWebView() {
        Utils().showProgress()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    @objc func dismissProgreeForWebView() {
        Utils().dismissProgress { }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("scrollView.contentOffset.y \(scrollView.contentOffset.y), scrollView.contentSize.height \(scrollView.contentSize.height)")
        if lastContentOffset.y < scrollView.contentOffset.y && scrollView.contentOffset.y > 0 {
            //            print("down")
        } else if lastContentOffset.y > scrollView.contentOffset.y && scrollView.contentOffset.y < scrollView.contentSize.height - scrollView.frame.size.height {
            //            print("up")
        }
        lastContentOffset = scrollView.contentOffset
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset
    }

    func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        return Swift.min(statusBarSize.width, statusBarSize.height)
    }

    func initWebViewConstraints(webView: WKWebView) {
        if #available(iOS 11.0, *) {
            let safeArea = self.view.safeAreaLayoutGuide
            wkWebView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
            wkWebView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
            wkWebView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
            wkWebView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        } else {
            wkWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            wkWebView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
            wkWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            wkWebView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        }
    }


    // Native -> JavaScript 호출 (두번째 방법)
    @IBAction func didTapchangeButton(_ sender: UIButton) {
        if let webView = self.wkWebView {
            webView.evaluateJavaScript("blueHeader()") { (result, error) in
                if let error = error {
                    print(error)
                } else if let result = result {
                    print(result)
                }
            }
        }
    }
}

/*

 WKWebView delegates extension

 */
extension MainViewController: WKUIDelegate, WKNavigationDelegate {

    func webViewDidClose(_ webView: WKWebView) {

        var foundPopupWebViewModel: PopupWebViewModel? = nil

        for popupWebViewModel in self.webViews {
            if popupWebViewModel.webView == webView {
                popupWebViewModel.webView?.removeFromSuperview()
                foundPopupWebViewModel = popupWebViewModel
                break;
            }
        }

        if let foundWv = foundPopupWebViewModel {
            self.webViews.remove(object: foundWv)
        }

        if self.webViews.count > 0 {
            self.bringToFromWebViewNavigationItems(topWebView: (self.webViews.last?.webView)!)
        }
        else {
            self.bringToFromWebViewNavigationItems(topWebView: self.wkWebView)
        }
        self.btnBack.isHidden = true
        print("webViewDidClose :: \(String(describing: webView.url))")

    }

    func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Swift.Void) {

        self.dismissProgreeForWebView()
        
        self.showConfirmDialog(title: "", message: message) {() -> Void
             in completionHandler()
        }
        print("runJavaScriptAlertPanelWithMessage :: \(String(describing: webView.url))")

    }

    func webView(_ webView: WKWebView,
                 runJavaScriptConfirmPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {

        let confirm = DefaultButton(title: "확인", height: 60) {() -> Void
             in completionHandler(true)
        }

        let cancel = CancelButton(title: "취소", height: 60) {() -> Void
             in completionHandler(false)
        }

        self.dismissProgreeForWebView()
        
        self.showDialog(title: "",
                        message: message,
                        button1: cancel, button2: confirm)
        print("runJavaScriptConfirmPanelWithMessage :: \(String(describing: webView.url))");
    }

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping ((WKNavigationActionPolicy) -> Void)) {

        let url = navigationAction.request.url//?.absoluteString
        print("decidePolicyFor :: \(String(describing: url))");

//        print("url="+(url?.absoluteString)!)
        let findKeyword = "back://"

        if openInDocumentPreview(url!) {
            decisionHandler(.cancel)
            
            executeDocumentDownloadScript(forAbsoluteUrl: url!.absoluteString)
            self.showProgressForWebView()

            _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.dismissProgreeForWebView), userInfo: nil, repeats: false)
            return
        } else {
//            decisionHandler(.allow)
        }
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if openInVideoPlayView(url!) {
            bool_autorotation = true
        } else {
            bool_autorotation = false

            if UIDevice.current.orientation != UIDeviceOrientation.portrait {
                let value = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
            }
        }
        
//        if url!.absoluteString.contains("/bbs/logout.php") {
//            self.deleteCookie()
//        }
        
        switch navigationAction.navigationType {
        case .linkActivated, .other:
            if let url = navigationAction.request.url, url.scheme != "http" && url.scheme != "https" {

                //요기요나오면 메인 페이지로이도
                if let urlString = navigationAction.request.url?.absoluteString
                {
                    if urlString.contains("yogiyoapp")
                    {
                        self.goMain = true
                        self.installedyogiyo = true
                    }
                }
                
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: {
                        (success) in
                        if success {
                            print("Success iOS 10")
                            // Success
                            if self.goMain && self.installedyogiyo {
                                self.goMain = false
                                if let url = URL(string: MAIN_URL) {
                                    let request = URLRequest(url: url)
                                    self.wkWebView.load(request)
                                }
                            }
                        }
                        else {
                            if let urlString = navigationAction.request.url?.absoluteString, urlString != "about:blank" && urlString.range(of: findKeyword) == nil {

                                let alert = UIAlertController(title: "", message: "해당 앱이 설치되어 있지 않거나\n연결할 수 없는 URL 입니다.", preferredStyle: .alert)
                                //alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                                if self.goMain {
                                    self.installedyogiyo = false
                                }
                                
                                alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { action in if self.goMain {
                                                                            self.goMain = false
                                                                            if let url = URL(string: MAIN_URL) {
                                                                                let request = URLRequest(url: url)
                                                                                self.wkWebView.load(request)
                                                                            }
                                    }}))
                                self.present(alert, animated: true, completion: nil)
//                                self.present(alert, animated: true, completion: {
//                                    if self.goMain {
//                                        self.goMain = false
//                                        if let url = URL(string: MAIN_URL) {
//                                            let request = URLRequest(url: url)
//                                            self.wkWebView.load(request)
//                                        }
//                                    } })
                            }
//                            //요기요나오면 메인 페이지로이도
//                              if let urlString = navigationAction.request.url?.absoluteString
//                              {
//                                if urlString.contains("yogiyoapp")
//                                {
//                                      self.goMain = true
//                                }
//                              }

//                            if let urlString = navigationAction.request.url?.absoluteString, urlString == "about:blank"  {
//                                self.goMain = true
////                                if self.goMain {
////                                  self.goMain = false
////                                    if let url = URL(string: MAIN_URL) {
////                                        let request = URLRequest(url: url)
////                                        self.wkWebView.load(request)
////                                    }
////                                }
//                            }
                            
                        }
                    })
                } else {
                    if UIApplication.shared.openURL(url) {
                        // Success
                         print("Success")
                        if self.goMain && self.installedyogiyo {
                            self.goMain = false
                            if let url = URL(string: MAIN_URL) {
                                let request = URLRequest(url: url)
                                self.wkWebView.load(request)
                            }
                        }
                    }
                    else {
                        if let urlString = navigationAction.request.url?.absoluteString, urlString != "about:blank" && urlString.range(of: findKeyword) == nil {

                            let alert = UIAlertController(title: "", message: "해당 앱이 설치되어 있지 않거나\n연결할 수 없는 URL 입니다.", preferredStyle: .alert)
                            if self.goMain {
                                self.installedyogiyo = false
                            }
                           // alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { action in if self.goMain {
                                self.goMain = false
                                if let url = URL(string: MAIN_URL) {
                                    let request = URLRequest(url: url)
                                    self.wkWebView.load(request)
                                }
                                }}))
                            present(alert, animated: true, completion: nil)
                        }
                    }
                }

                decisionHandler(.cancel)

            }
            else {
                decisionHandler(.allow)
            }
            break
        case .formSubmitted:
            decisionHandler(.allow)
            break
        case .backForward:
            if (webView.canGoBack || webView.canGoForward) {
                decisionHandler(.allow)
            } else {
                decisionHandler(.cancel)
            }
            break
        case .reload:
            decisionHandler(.allow)
            break
        case .formResubmitted:
            decisionHandler(.allow)
            break
        }

    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        // get header and print it
        decisionHandler(.allow)
        print("decidePolicyFor navigationResponse :: \(String(describing: webView.url))")

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        wkWebView.frame = self.view.frame
        print("viewWillTransition :: \(String(describing: wkWebView.url))")
    }
    
    
    /*
     Open downloaded document in QuickLook preview
     */
    private func previewDocument(messageBody: String) {
        // messageBody is in the format ;data:;base64,

        // split on the first ";", to reveal the filename
        let filenameSplits = messageBody.split(separator: ";", maxSplits: 1, omittingEmptySubsequences: false)

        let filename = String(filenameSplits[0])
        print(filename)
        // split the remaining part on the first ",", to reveal the base64 data
        let dataSplits = filenameSplits[1].split(separator: ",", maxSplits: 1, omittingEmptySubsequences: false)

        let data = Data(base64Encoded: String(dataSplits[1]))

        if (data == nil) {
            debugPrint("Could not construct data from base64")
            return
        }

        // store the file on disk (.removingPercentEncoding removes possible URL encoded characters like "%20" for blank)
        let localFileURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename.removingPercentEncoding ?? filename)

        do {
            try data!.write(to: localFileURL);
        } catch {
            debugPrint(error)
            return
        }

        // and display it in QL
        DispatchQueue.main.async {
            self.documentUrl = localFileURL
            self.documentPreviewController.refreshCurrentPreviewItem()
            self.present(self.documentPreviewController, animated: true, completion: nil)
        }
        print("previewDocument :: \(String(describing: wkWebView.url))");

    }
    
    func deleteCookie() {
        // 웹뷰 디스크캐시 삭제
//        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeCookies])
//        let date_data = NSDate(timeIntervalSince1970: 0)
//
//        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set, modifiedSince: date_data as Date, completionHandler: {})
        print("deleteCookie :: \(String(describing: wkWebView.url))");
    }

    /*
     Implementation for QLPreviewControllerDataSource
     */
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        print("previewController :: \(String(describing: wkWebView.url))");

        return documentUrl as QLPreviewItem
    }


    /*
     Implementation for QLPreviewControllerDataSource
     We always have just one preview item
     */
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }


    /*
     Checks if the given url points to a document download url
     */
    private func openInDocumentPreview(_ url : URL) -> Bool {
        // this is specific for our application - can be everything in your application
        return url.absoluteString.contains("/bbs/download.php")
    }
    
    private func openInVideoPlayView(_ url : URL) -> Bool {
        // this is specific for our application - can be everything in your application
        return url.absoluteString.contains("/bbs/ch.vplay.php")
    }

    /*
     Intercept the download of documents in webView, trigger the download in JavaScript and pass the binary file to JavaScript handler in Swift code
     */
    private func executeDocumentDownloadScript(forAbsoluteUrl absoluteUrl : String) {
        // TODO: Add more supported mime-types for missing content-disposition headers
        print("executeDocumentDownloadScript :: \(absoluteUrl)");

        wkWebView.evaluateJavaScript("""
            (async function download() {
            const url = '\(absoluteUrl)';
            try {
            // we use a second try block here to have more detailed error information
            // because of the nature of JS the outer try-catch doesn't know anything where the error happended
            let res;
            try {
            res = await fetch(url, {
            credentials: 'include'
            });
            } catch (err) {
            window.webkit.messageHandlers.jsError.postMessage(`fetch threw, error: ${err}, url: ${url}`);
            return;
            }
            if (!res.ok) {
            window.webkit.messageHandlers.jsError.postMessage(`Response status was not ok, status: ${res.status}, url: ${url}`);
            return;
            }
            const contentDisp = res.headers.get('content-disposition');
            if (contentDisp) {
            const match = contentDisp.match(/(^;|)\\s*filename=\\s*(\"([^\"]*)\"|([^;\\s]*))\\s*(;|$)/i);
            if (match) {
            filename = match[3] || match[4];
            } else {
            // TODO: we could here guess the filename from the mime-type (e.g. unnamed.pdf for pdfs, or unnamed.tiff for tiffs)
            window.webkit.messageHandlers.jsError.postMessage(`content-disposition header could not be matched against regex, content-disposition: ${contentDisp} url: ${url}`);
            }
            } else {
            window.webkit.messageHandlers.jsError.postMessage(`content-disposition header missing, url: ${url}`);
            return;
            }
            if (!filename) {
            const contentType = res.headers.get('content-type');
            if (contentType) {
            if (contentType.indexOf('application/json') === 0) {
            filename = 'unnamed.pdf';
            } else if (contentType.indexOf('image/tiff') === 0) {
            filename = 'unnamed.tiff';
            }
            }
            }
            if (!filename) {
            window.webkit.messageHandlers.jsError.postMessage(`Could not determine filename from content-disposition nor content-type, content-dispositon: ${contentDispositon}, content-type: ${contentType}, url: ${url}`);
            }
            let data;
            try {
            data = await res.blob();
            } catch (err) {
            window.webkit.messageHandlers.jsError.postMessage(`res.blob() threw, error: ${err}, url: ${url}`);
            return;
            }
            const fr = new FileReader();
            fr.onload = () => {
            window.webkit.messageHandlers.openDocument.postMessage(`${filename};${fr.result}`)
            };
            fr.addEventListener('error', (err) => {
            window.webkit.messageHandlers.jsError.postMessage(`FileReader threw, error: ${err}`)
            })
            fr.readAsDataURL(data);
            } catch (err) {
            // TODO: better log the error, currently only TypeError: Type error
            window.webkit.messageHandlers.jsError.postMessage(`JSError while downloading document, url: ${url}, err: ${err}`)
            }
            })();
            // null is needed here as this eval returns the last statement and we can't return a promise
            null;
        """) { (result, err) in
            if (err != nil) {
                debugPrint("JS ERR: \(String(describing: err))")
            }
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {

        controller.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
//        if let url = url.absoluteString.contains("/bbs/download.php")
        
        if navigationAction.targetFrame == nil, let url = navigationAction.request.url, url.absoluteString.contains("/bbs/view_image.php") {

            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true, completion: nil)
            safariViewController.delegate = self

            return nil;
        }

//        // test
//        let url = navigationAction.request.url!
//        
//        let safariViewController = SFSafariViewController(url: url)
//        self.present(safariViewController, animated: true, completion: nil)
//        safariViewController.delegate = self
//        
//        return nil;

        
        let popupWebView = PopupWebViewModel().createPopupWebView(createWebViewWith: configuration,
                                                                  for: navigationAction,
                                                                  popupWebViewSize: self.wkWebView.frame)

        guard let newWebView = popupWebView else {
            return nil;
        }

        newWebView.webView?.navigationDelegate = self
        newWebView.webView?.uiDelegate = self



        self.view.addSubview(newWebView.webView!)
        newWebView.webView!.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)

        self.webViews.append(newWebView)

        self.bringToFromWebViewNavigationItems(topWebView: newWebView.webView!)

        newWebView.webView!.translatesAutoresizingMaskIntoConstraints = false

        self.initWebViewConstraints(webView: newWebView.webView!)

        self.btnBack.isHidden = false
        print("createWebViewWith 1 :: \(String(describing: wkWebView?.url))")
        print("createWebViewWith 2 :: \(String(describing: newWebView.webView?.url))");

        return newWebView.webView
    }

    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //        self.showProgressForWebView()
        print("didStartProvisionalNavigation :: \(String(describing: webView.url))");
        self.showProgressForWebView()
       
        
        
//        if self.isFirst{
//          wkWebView.isHidden = false
//            self.isFirst = false
//            wkWebView.alpha = 0
//            UIView.animate(withDuration: 2.3) {
//                self.wkWebView.alpha = 1
//            }
//        }
//
//
//        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.dismissProgreeForWebView), userInfo: nil, repeats: false)
    }
    
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("========== webView(didCommit) - start ==========")
        //print(navigation)
        if self.isFirst{
            wkWebView.isHidden = false
            self.isFirst = false
            wkWebView.alpha = 0
            UIView.animate(withDuration: 1.3) {
                self.wkWebView.alpha = 1
            }
        }

        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.dismissProgreeForWebView), userInfo: nil, repeats: false)
        print("didCommit 1 :: \(String(describing: wkWebView?.url))");
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

//        webView.evaluateJavaScript("document.cookie") { (object, error) in
//                if let document_cookie: String = object as? String {
//                    print(document_cookie)
////                    Utils().setCookie(cookie: document_cookie)
//                }
//            }
           self.layerView.isHidden = true
           self.view.bringSubviewToFront(self.btnHome)
        print("didFinish 1 :: \(String(describing: wkWebView?.url))");

    }

    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation,
                 withError error: Error) {
        print(error.localizedDescription)
          self.layerView.isHidden = true
        print("didFail 1 :: \(String(describing: wkWebView?.url))");

    }

//    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
//        return .none
//    }
}


extension MainViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {

        print("message.body : ", message.body)
        
        if (message.name == "openDocument") {
            previewDocument(messageBody: message.body as! String)
//            self.dismissProgreeForWebView()
            _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.dismissProgreeForWebView), userInfo: nil, repeats: false)
        } else if (message.name == "jsError") {
            debugPrint(message.body as! String)
//            self.dismissProgreeForWebView()
            _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.dismissProgreeForWebView), userInfo: nil, repeats: false)
        } else if (message.name == "openPopup") {
            print("openPopup")
            
            SwiftEventBus.onMainThread(self, name: "AuthViewController.finish"){_ in
                let script = "setACheck('Y')"
                self.wkWebView.evaluateJavaScript(script, completionHandler:nil)
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
            controller.url = message.body as! String
            print("controller.url :: \(controller.url)");

            self.navigationController?.pushViewController(controller, animated: false)
            
        } else {
            if (message.name == "callbackHandler" || message.name == "bbqHandler") {
                print("JavaScript is sending a message \(message.body)")

                let alertBody = "called function name is '\(message.name)' with \(message.body) "

                print (alertBody)
                
//                if (message.name == "bbqHandler" && message.body as! String == "app_version") {
//                    wkWebView.evaluateJavaScript("app_version('\(Utils().getAppVersion())')", completionHandler: {(result, error) in
//                        if let result = result {
//                            print(result)
//                        }
//                    })
//                }
                if (message.name == "bbqHandler") {
                    
//                    let js_parameters:[String:String] = message.body as! Dictionary
//                    print("\(js_parameters["mb_id"]!) / \(js_parameters["wr_id"]!) / \(js_parameters["channel_num"]!)")
                    //바코드스캔 20190523
                    if let message = message.body as? String{
                        if message == "barCodeScan" {
                       
//                            guard let uvc : ScanBarCodeViewController = self.storyboard?.instantiateViewController(withIdentifier: "SCanBarCode") as? ScanBarCodeViewController else{
//                                return
//                            }
//                            uvc.mainVC = self
//                            self.isSetBarCode = true
//                            self.present(uvc,animated: false,completion: nil)
                            
                            guard let uvc : QRScanViewController = self.storyboard?.instantiateViewController(withIdentifier: "QRScanCode") as? QRScanViewController else {
                                    return
                                }
                                uvc.mainVC = self
                                self.isSetBarCode = true
                                self.present(uvc,animated: false,completion: nil)
//                            wkWebView.evaluateJavaScript("iosbarCodeData('barcodetestdata');",completionHandler: nil)
                        }
                        else if message == "echoData" {
                          print("call echoData")
                        }
                    }
                }
            }
        }
    }
}
