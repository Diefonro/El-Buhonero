//
//  QRScanScreenViewModel.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import Foundation
import AVFoundation

protocol QRScanScreenViewModelDelegate: AnyObject {
    func qrCodeScanned(_ qrData: QRCodeData)
    func qrCodeError(_ error: QRCodeError)
    func cameraPermissionDenied()
}

class QRScanScreenViewModel {
    
    weak var delegate: QRScanScreenViewModelDelegate?
    
    init() {
        // Initialize view model
    }
    
    func checkCameraPermission() -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if !granted {
                        self?.delegate?.cameraPermissionDenied()
                    }
                }
            }
            return true
        case .denied, .restricted:
            delegate?.cameraPermissionDenied()
            return false
        @unknown default:
            return false
        }
    }
    
    func processQRCode(_ qrString: String) {
        let result = QRCodeParser.parseQRCode(qrString)
        
        switch result {
        case .success(let qrData):
            delegate?.qrCodeScanned(qrData)
        case .failure(let error):
            delegate?.qrCodeError(error)
        }
    }
} 