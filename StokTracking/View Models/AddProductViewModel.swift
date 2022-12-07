//
//  AddProductViewModel.swift
//  StokTracking
//
//  Created by İbrahim Taşdemir on 9.11.2022.
//

import Foundation
import AVFoundation
import SwiftQRScanner

final class AddProductViewModel {
    
    var title = "Add Product"
    
    var coordinator : AddProductCoordinator?
    
    var features = [Features]()
    
    var onUpdate = {}
    
    func setupProductCell() {
        features = [
            Features(title: "Ürün Adı", overview: ""),
            Features(title: "Ürün Fiyatı", overview: ""),
            Features(title: "S.K.T", overview: "")]
        onUpdate()
    }
    
    func viewDidLoad() {
        setupProductCell()
    }
    
    func viewDidDisappear() {
        coordinator?.didFinish()
    }
    
    func tappedAddCell() {
        features.append(Features(title: " ", overview: " "))
        onUpdate()
    }
    
    func tappedDone(image: String,completion: @escaping([Features]) -> Void) {
        completion(features)
        coordinator?.didFinishSaveProduct()
    }
    
    func cellUpdateTextField(_ indexPath : IndexPath , _ text : String) {
        features[indexPath.row].updateTitle(text)
    }
    
    func cellUpdateTextView(_ indexPath : IndexPath , _ text : String) {
        features[indexPath.row].updateOverview(text)
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
