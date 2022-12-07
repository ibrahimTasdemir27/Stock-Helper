//
//  ArrangedViewModel.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 2.12.2022.
//

import Foundation
import SwiftQRScanner
import AVFoundation
import CoreData

class ArrangedViewModel {
    
    var title = "Arrange Item"
    
    private var featuresModel: FeaturesModel
    
    var onUpdate = {}
    
    var imageName: String {
        return featuresModel.imageName
    }
    
    init(_ featuresModel: FeaturesModel) {
        self.featuresModel = featuresModel
    }
    
    func updatedModel() -> FeaturesModel {
        return self.featuresModel
    }
    
    func numberOfRows() -> Int {
        return featuresModel.titleModel.count
    }
    
    func modalAt(_ indexPath: Int) -> Features {
        return featuresModel.titleModel[indexPath]
    }
    
    func tappedAddCell() {
        featuresModel.titleModel.append(Features(title: " ", overview: " "))
        onUpdate()
    }
    
    func cellUpdateTextField(_ indexPath: Int, _ text: String) {
        featuresModel.titleModel[indexPath].updateTitle(text)
    }
    
    func cellUpdateTextView(_ indexPath: Int, _ text: String) {
        featuresModel.titleModel[indexPath].updateOverview(text)
    }
    
    func prepareScanner<D: QRScannerCodeDelegate & UIViewController >(_ scannerDelegate: D) {
        var configuration = QRScannerConfiguration()
        configuration.cameraImage = UIImage(named: "camera")
        configuration.flashOnImage = UIImage(named: "flash-on")
        configuration.galleryImage = UIImage(named: "photos")
        
        let scanner = QRCodeScannerController(qrScannerConfiguration: configuration)
        scanner.delegate = scannerDelegate
        scannerDelegate.present(scanner, animated: true, completion: nil)
    }
    
    func requestAuthorization(isPermission : @escaping(Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            isPermission(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    guard granted else {
                        isPermission(false)
                        return
                    }
                }
            }
        case .denied, .restricted:
            isPermission(false)
        @unknown default:
            isPermission(false)
        }
    }
}
