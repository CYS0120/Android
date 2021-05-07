//
//  ScanBarCodeViewController.swift
//  BBQ_iOS
//
//  Created by mac on 24/05/2019.
//  Copyright © 2019 winter. All rights reserved.
//

import UIKit
import AVFoundation

//public class ScanBarCodeViewController : UIViewController
//{
//    @IBOutlet weak var resultlbl: UILabel!
//
//    @IBOutlet weak var scanView: UIView!
//
//    public weak var mainVC : UIViewController?
//
//    private var captureSession: AVCaptureSession = AVCaptureSession()
//    private let sessionQueue = DispatchQueue(label: "Capture Session Queue")
//
//    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
//
//    private func setupCaptureSession() {
//        sessionQueue.sync {
//            self.captureSession.beginConfiguration()
//
//            let output = AVCaptureMetadataOutput()
//
//            if let device = AVCaptureDevice.default(for: .video),
//                let input = try? AVCaptureDeviceInput(device: device),
//                self.captureSession.canAddInput(input) && self.captureSession.canAddOutput(output) {
//                self.captureSession.addInput(input)
//                self.captureSession.addOutput(output)
//
//                output.metadataObjectTypes = [
//                    .aztec,
//                    .code39,
//                    .code39Mod43,
//                    .code93,
//                    .code39Mod43,
//                    .code128,
//                    .dataMatrix,
//                    .ean8,
//                    .ean13,
//                    .interleaved2of5,
//                    .itf14,
//                    .interleaved2of5,
//                    .pdf417,
//                    .qr,
//                    .upce
//                ]
//
//                output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            }
//
//            self.captureSession.commitConfiguration()
//
//            DispatchQueue.main.async {
//                self.setupPreviewLayer(session: self.captureSession)
//
//            }
//
//            self.captureSession.startRunning()
//        }
//    }
//
//    private func setupPreviewLayer(session: AVCaptureSession) {
//        previewLayer = AVCaptureVideoPreviewLayer(session: session)
//        previewLayer.frame = scanView.layer.bounds
//        previewLayer.videoGravity = .resizeAspectFill
//
//        scanView.layer.addSublayer(previewLayer)
//    }
//    private var resetTimer: Timer?
//    fileprivate func resetResultLabel(after: Double) {
//        resetTimer?.invalidate()
//        resetTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval() + after,
//                                          repeats: false) {
//                                            [weak self] (timer) in
//                                            self?.resultlbl.text = nil }
//    }
//
//
//  public   override func viewDidLoad() {
//        super.viewDidLoad()
//       setupCaptureSession()
//
//    }
//  public  override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
////        if let vc = mainVC as? MainViewController
////        {
////            vc.strBarCode = "adkdkdkdkdkkd"
////            self.presentingViewController?.dismiss(animated: false, completion: nil)
////        }
//    }
//
//}
//
//
//extension ScanBarCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
//            self.resultlbl.text = object.stringValue
//
//            guard let transformedObject = previewLayer.transformedMetadataObject(for: object) as? AVMetadataMachineReadableCodeObject else {
//                return
//            }
//
//            resetResultLabel(after: 0.1)
//
//            if let vc = mainVC as? MainViewController
//            {
//                vc.strBarCode = self.resultlbl.text
//                self.presentingViewController?.dismiss(animated: false, completion: nil)
//            }
//
//            //            updateBoundingBox(transformedObject.corners)
//            //            hideBoundingBox(after: 0.25)
//        }
//    }
//}


//class ScanViewController: UIViewController {
//
//    @IBOutlet weak var previewContainer: UIView!
//    @IBOutlet weak var resultsLabel: UILabel!
//
//    private var captureSession: AVCaptureSession = AVCaptureSession()
//    private let sessionQueue = DispatchQueue(label: "Capture Session Queue")
//
//    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupCaptureSession()
//    }
//
//    private func setupCaptureSession() {
//        sessionQueue.sync {
//            self.captureSession.beginConfiguration()
//
//            let output = AVCaptureMetadataOutput()
//
//            if let device = AVCaptureDevice.default(for: .video),
//                let input = try? AVCaptureDeviceInput(device: device),
//                self.captureSession.canAddInput(input) && self.captureSession.canAddOutput(output) {
//                self.captureSession.addInput(input)
//                self.captureSession.addOutput(output)
//
//                output.metadataObjectTypes = [
//                    .aztec,
//                    .code39,
//                    .code39Mod43,
//                    .code93,
//                    .code39Mod43,
//                    .code128,
//                    .dataMatrix,
//                    .ean8,
//                    .ean13,
//                    .interleaved2of5,
//                    .itf14,
//                    .interleaved2of5,
//                    .pdf417,
//                    .qr,
//                    .upce
//                ]
//
//                output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            }
//
//            self.captureSession.commitConfiguration()
//
//            DispatchQueue.main.async {
//                self.setupPreviewLayer(session: self.captureSession)
//                self.setupBoundingBox()
//            }
//
//            self.captureSession.startRunning()
//        }
//    }
//
//    private func setupPreviewLayer(session: AVCaptureSession) {
//        previewLayer = AVCaptureVideoPreviewLayer(session: session)
//        previewLayer.frame = previewContainer.layer.bounds
//        previewLayer.videoGravity = .resizeAspectFill
//
//        previewContainer.layer.addSublayer(previewLayer)
//    }
//
//    // MARK - Bounding Box
//    private var boundingBox = CAShapeLayer()
//    private func setupBoundingBox() {
//        boundingBox.frame = previewContainer.layer.bounds
//        boundingBox.strokeColor = UIColor.red.cgColor
//        boundingBox.lineWidth = 4.0
//        boundingBox.fillColor = UIColor.clear.cgColor
//
//        previewContainer.layer.addSublayer(boundingBox)
//    }
//
//    fileprivate func updateBoundingBox(_ points: [CGPoint]) {
//        guard let firstPoint = points.first else {
//            return
//        }
//
//        let path = UIBezierPath()
//        path.move(to: firstPoint)
//
//        var newPoints = points
//        newPoints.removeFirst()
//        newPoints.append(firstPoint)
//
//        newPoints.forEach { path.addLine(to: $0) }
//
//        boundingBox.path = path.cgPath
//        boundingBox.isHidden = false
//    }
//
//    private var resetTimer: Timer?
//    fileprivate func hideBoundingBox(after: Double) {
//        resetTimer?.invalidate()
//        resetTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval() + after,
//                                          repeats: false) {
//                                            [weak self] (timer) in
//                                            self?.resetViews() }
//    }
//
//    private func resetViews() {
//        boundingBox.isHidden = true
//        resultsLabel.text = nil
//    }
//}
//
//extension ViewController: AVCaptureMetadataOutputObjectsDelegate {
//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
//            self.resultsLabel.text = object.stringValue
//
//            guard let transformedObject = previewLayer.transformedMetadataObject(for: object) as? AVMetadataMachineReadableCodeObject else {
//                return
//            }
//
//            //            updateBoundingBox(transformedObject.corners)
//            //            hideBoundingBox(after: 0.25)
//        }
//    }
//}
//
//
//public class ScanBarCodeViewController : UIViewController
//{
//    @IBOutlet weak var resultlbl: UILabel!
//
//    @IBOutlet weak var scanView: UIView!
//
//    public weak var mainVC : UIViewController?
//
//    private var captureSession: AVCaptureSession = AVCaptureSession()
//    private let sessionQueue = DispatchQueue(label: "Capture Session Queue")
//
//    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
//
//    private func setupCaptureSession() {
//        sessionQueue.sync {
//            self.captureSession.beginConfiguration()
//
//            let output = AVCaptureMetadataOutput()
//
//            if let device = AVCaptureDevice.default(for: .video),
//                let input = try? AVCaptureDeviceInput(device: device),
//                self.captureSession.canAddInput(input) && self.captureSession.canAddOutput(output) {
//                self.captureSession.addInput(input)
//                self.captureSession.addOutput(output)
//
//                output.metadataObjectTypes = [
//                    .aztec,
//                    .code39,
//                    .code39Mod43,
//                    .code93,
//                    .code39Mod43,
//                    .code128,
//                    .dataMatrix,
//                    .ean8,
//                    .ean13,
//                    .interleaved2of5,
//                    .itf14,
//                    .interleaved2of5,
//                    .pdf417,
//                    .qr,
//                    .upce
//                ]
//
//                output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            }
//
//            self.captureSession.commitConfiguration()
//
//            DispatchQueue.main.async {
//                self.setupPreviewLayer(session: self.captureSession)
//
//            }
//
//            self.captureSession.startRunning()
//        }
//    }
//
//    private func setupPreviewLayer(session: AVCaptureSession) {
//        previewLayer = AVCaptureVideoPreviewLayer(session: session)
//        previewLayer.frame = scanView.layer.bounds
//        previewLayer.videoGravity = .resizeAspectFill
//
//        scanView.layer.addSublayer(previewLayer)
//    }
//    private var resetTimer: Timer?
//    fileprivate func resetResultLabel(after: Double) {
//        resetTimer?.invalidate()
//        resetTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval() + after,
//                                          repeats: false) {
//                                            [weak self] (timer) in
//                                            self?.resultlbl.text = nil }
//    }
//
//
//    public   override func viewDidLoad() {
//        super.viewDidLoad()
//        setupCaptureSession()
//
//    }
//    public  override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        //        if let vc = mainVC as? MainViewController
//        //        {
//        //            vc.strBarCode = "adkdkdkdkdkkd"
//        //            self.presentingViewController?.dismiss(animated: false, completion: nil)
//        //        }
//    }
//
//}
//
//
//extension ScanBarCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
//            self.resultlbl.text = object.stringValue
//
//            guard let transformedObject = previewLayer.transformedMetadataObject(for: object) as? AVMetadataMachineReadableCodeObject else {
//                return
//            }
//
//            resetResultLabel(after: 0.1)
//
//            if let vc = mainVC as? MainViewController
//            {
//                vc.strBarCode = self.resultlbl.text
//                self.presentingViewController?.dismiss(animated: false, completion: nil)
//            }
//
//            //            updateBoundingBox(transformedObject.corners)
//            //            hideBoundingBox(after: 0.25)
//        }
//    }
//}
