//
//  QRScanScreenVC.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import UIKit
import QRCodeReader
import AVFoundation

class QRScanScreenVC: UIViewController, QRCodeReaderViewControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scanButton: UIButton!
    
    // MARK: - Properties
    var coordinator: QRScanScreenCoordinator?
    var viewModel: QRScanScreenViewModel?
    private var isProcessingQRCode = false // Flag to prevent multiple processing
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton = true
            $0.showSwitchCameraButton = false
            $0.showCancelButton = true
            $0.showOverlayView = true
            $0.handleOrientationChange = true
        }
        return QRCodeReaderViewController(builder: builder)
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        setupScanButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coordinator?.showNavigationBar(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = "Scan QR Code"
        view.backgroundColor = .black
        
        // Setup instruction label
        instructionLabel.text = "Tap the button below to start scanning QR codes"
        instructionLabel.textColor = .white
        instructionLabel.textAlignment = .center
        instructionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        // Setup activity indicator
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
    }
    
    private func setupViewModel() {
        // Remove duplicate view model setup - it's already set in setViewModel() from coordinator
        // viewModel = QRScanScreenViewModel()
        // viewModel?.delegate = self
    }
    
    private func setupScanButton() {
        scanButton.setTitle("Scan QR Code", for: .normal)
        scanButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        scanButton.backgroundColor = UIColor(red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0)
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.layer.cornerRadius = 25
        scanButton.layer.masksToBounds = true
        scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
    }
    
    @objc private func scanButtonTapped() {
        startQRCodeReader()
    }
    
    func startQRCodeReader() {
        isProcessingQRCode = false // Reset flag when starting new scan
        readerVC.delegate = self
        present(readerVC, animated: true, completion: nil)
    }
    
    // MARK: - QRCodeReaderViewControllerDelegate
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        guard !isProcessingQRCode else { return } // Prevent multiple processing
        isProcessingQRCode = true
        
        reader.stopScanning()
        dismiss(animated: true) { [weak self] in
            self?.viewModel?.processQRCode(result.value)
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        isProcessingQRCode = false // Reset flag when user cancels
        reader.stopScanning()
        dismiss(animated: true) { [weak self] in
            // Navigate back to previous screen when user cancels
            self?.coordinator?.pop(animated: true)
        }
    }
}

// MARK: - QRScanScreenViewModelDelegate
extension QRScanScreenVC: QRScanScreenViewModelDelegate {
    func qrCodeScanned(_ qrData: QRCodeData) {
        isProcessingQRCode = false // Reset flag
        coordinator?.presentProductDetailFromQR(qrData: qrData)
    }
    
    func qrCodeError(_ error: QRCodeError) {
        isProcessingQRCode = false // Reset flag
        let alert = UIAlertController(title: "Invalid QR Code", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default) { [weak self] _ in
            // Restart the QR reader after error dismissal
            self?.startQRCodeReader()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            // Navigate back to previous screen if user cancels
            self?.coordinator?.pop(animated: true)
        })
        present(alert, animated: true)
    }
    
    func cameraPermissionDenied() {
        isProcessingQRCode = false // Reset flag
        let alert = UIAlertController(title: "Camera Access Required", message: "Please enable camera access in Settings to scan QR codes.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Navigate back to previous screen when camera permission is denied
            self?.coordinator?.pop(animated: true)
        })
        present(alert, animated: true)
    }
}

// MARK: - Public Methods
extension QRScanScreenVC {
    func setCoordinator(coordinator: QRScanScreenCoordinator) {
        self.coordinator = coordinator
    }
    
    func setViewModel(viewModel: QRScanScreenViewModel) {
        self.viewModel = viewModel
        self.viewModel?.delegate = self
    }
}

// MARK: - Storyboard Constants
extension QRScanScreenVC {
    static let storyboard = "QRScanScreen"
    static let identifier = "QRScanScreenVC"
} 