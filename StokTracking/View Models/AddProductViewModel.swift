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
    
    weak var coordinator : AddProductCoordinator?
    
    var features = [Features]()
    
    var showError: ((ShowError) -> Void)?
    var coreDataManager: CoreDataManager = .shared
    var onUpdate = {}
    
    func setupProductCell() {
        features = [
            Features(title: "Ürün Adı", overview: ""),
            Features(title: "Ürün Fiyatı", overview: ""),
            Features(title: "Ürün Adedi", overview: "")]
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
    
    func isEmpty() -> Bool {
        var result = true
        features.forEach { features in
            guard features.overview.isNotEmpty() else {
                result = false
                return
            }
        }
        return result
    }
    
    func tappedDone() -> Bool {
        if isEmpty() {
            if !(coreDataManager.isContains(text: features.first!.overview)) {
                return true
            } else {
                showError!(.alreadyName)
                return false
            }
        } else {
            showError!(.emptyProductName)
            return false
        }
    }
    
    func updateModal() -> FeaturesModel {
        return FeaturesModel(imageName: "clothes1", titleModel: self.features)
    }
    
    func tappedDelete(_ index: Int) {
        features.remove(at: index)
        onUpdate()
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
    
    deinit {
        print("AddProductViewModel: I'm Deinit")
    }
    
}
