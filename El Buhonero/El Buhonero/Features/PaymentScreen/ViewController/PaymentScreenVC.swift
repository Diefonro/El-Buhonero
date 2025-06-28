//
//  PaymentScreenVC.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import UIKit

class PaymentScreenVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var cardholderField: UITextField!
    @IBOutlet weak var cvvField: UITextField!
    @IBOutlet weak var expiryField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    
    // MARK: - Properties
    var coordinator: PaymentScreenCoordinator?
    var viewModel: PaymentScreenViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        setupTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = "Payment"
        view.backgroundColor = UIColor(red: 0.047, green: 0.047, blue: 0.047, alpha: 1.0)
        
        // Setup total label
        totalLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        totalLabel.textColor = .white
        totalLabel.text = "Total: $0.00"
        
        // Setup pay button
        payButton.setTitle("Pay Now", for: .normal)
        payButton.backgroundColor = .systemBlue
        payButton.setTitleColor(.white, for: .normal)
        payButton.layer.cornerRadius = 8
        payButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    private func setupViewModel() {
        viewModel?.delegate = self
        
        // Update UI with product info
        if let price = viewModel?.productPrice {
            totalLabel.text = "Total: \(price)"
        }
    }
    
    private func setupTextFields() {
        // Setup text field delegates
        cardNumberField.delegate = self
        cardholderField.delegate = self
        cvvField.delegate = self
        expiryField.delegate = self
        
        // Setup text field appearance
        let textFields = [cardNumberField, cardholderField, cvvField, expiryField]
        for textField in textFields {
            textField?.textColor = .black
            textField?.backgroundColor = .white
            textField?.layer.cornerRadius = 8
            textField?.layer.borderWidth = 1
            textField?.layer.borderColor = UIColor.systemGray4.cgColor
        }
        
        // Setup placeholders
        cardNumberField.placeholder = "Card Number"
        cardholderField.placeholder = "Cardholder Name"
        cvvField.placeholder = "CVV"
        expiryField.placeholder = "MM/YY"
        
        // Setup keyboard types
        cardNumberField.keyboardType = .numberPad
        cvvField.keyboardType = .numberPad
        expiryField.keyboardType = .numberPad
        
        // Setup input masks
        cardNumberField.addTarget(self, action: #selector(cardNumberChanged), for: .editingChanged)
        expiryField.addTarget(self, action: #selector(expiryChanged), for: .editingChanged)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
    }
    
    private func validateForm() -> Bool {
        guard let cardNumber = cardNumberField.text, !cardNumber.isEmpty else {
            showAlert(title: "Error", message: "Please enter card number")
            return false
        }
        
        guard let cardholder = cardholderField.text, !cardholder.isEmpty else {
            showAlert(title: "Error", message: "Please enter cardholder name")
            return false
        }
        
        guard let cvv = cvvField.text, !cvv.isEmpty else {
            showAlert(title: "Error", message: "Please enter CVV")
            return false
        }
        
        guard let expiry = expiryField.text, !expiry.isEmpty else {
            showAlert(title: "Error", message: "Please enter expiration date")
            return false
        }
        
        return true
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @IBAction func payButtonTapped(_ sender: UIButton) {
        guard validateForm() else { return }
        
        // Extract month and year from expiry field
        let expiryText = expiryField.text ?? ""
        let components = expiryText.split(separator: "/")
        let month = components.count > 0 ? String(components[0]) : ""
        let year = components.count > 1 ? String(components[1]) : ""
        
        // Clean card number by removing spaces
        let cleanCardNumber = (cardNumberField.text ?? "").replacingOccurrences(of: " ", with: "")
        
        let card = PaymentCard(
            number: cleanCardNumber,
            cvv: cvvField.text ?? "",
            expirationMonth: month,
            expirationYear: year
        )
        
        // Debug: Print card details
        print("🔍 Processing Payment:")
        print("   Card Number: '\(cleanCardNumber)'")
        print("   CVV: '\(card.cvv)'")
        print("   Month: '\(card.expirationMonth)'")
        print("   Year: '\(card.expirationYear)'")
        print("   Expected: '4111111111111111', '123', '12', '25'")
        
        viewModel?.processPayment(card: card)
    }
    
    @objc private func cardNumberChanged() {
        guard let text = cardNumberField.text else { return }
        let cleaned = text.replacingOccurrences(of: " ", with: "")
        let formatted = formatCardNumber(cleaned)
        cardNumberField.text = formatted
    }
    
    @objc private func expiryChanged() {
        guard let text = expiryField.text else { return }
        let cleaned = text.replacingOccurrences(of: "/", with: "")
        
        if cleaned.count >= 2 {
            let month = String(cleaned.prefix(2))
            let year = cleaned.count > 2 ? String(cleaned.suffix(cleaned.count - 2)) : ""
            expiryField.text = "\(month)/\(year)"
        } else {
            expiryField.text = cleaned
        }
        
        // Limit to MM/YY format
        if cleaned.count > 4 {
            expiryField.text = String(cleaned.prefix(4))
        }
    }
    
    private func formatCardNumber(_ number: String) -> String {
        let cleaned = number.replacingOccurrences(of: " ", with: "")
        var formatted = ""
        
        for (index, character) in cleaned.enumerated() {
            if index > 0 && index % 4 == 0 {
                formatted += " "
            }
            formatted += String(character)
        }
        
        return formatted
    }
}

// MARK: - UITextFieldDelegate
extension PaymentScreenVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        switch textField {
        case cardNumberField:
            return newText.replacingOccurrences(of: " ", with: "").count <= 16
        case cvvField:
            return newText.count <= 4
        case expiryField:
            return newText.replacingOccurrences(of: "/", with: "").count <= 4
        default:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case cardNumberField:
            cardholderField.becomeFirstResponder()
        case cardholderField:
            cvvField.becomeFirstResponder()
        case cvvField:
            expiryField.becomeFirstResponder()
        case expiryField:
            textField.resignFirstResponder()
            payButtonTapped(payButton)
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - PaymentScreenViewModelDelegate
extension PaymentScreenVC: PaymentScreenViewModelDelegate {
    func paymentProcessing(_ isProcessing: Bool) {
        if isProcessing {
            payButton.isEnabled = false
            payButton.setTitle("Processing...", for: .disabled)
        } else {
            payButton.isEnabled = true
            payButton.setTitle("Pay Now", for: .normal)
        }
    }
    
    func paymentSuccess(orderNumber: String) {
        coordinator?.showPaymentSuccess(orderNumber: orderNumber)
    }
    
    func paymentFailed(_ error: PaymentError) {
        coordinator?.showPaymentError(error)
    }
}

// MARK: - Public Methods
extension PaymentScreenVC {
    func setCoordinator(coordinator: PaymentScreenCoordinator) {
        self.coordinator = coordinator
    }
    
    func setViewModel(viewModel: PaymentScreenViewModel) {
        self.viewModel = viewModel
        self.viewModel?.delegate = self
    }
}

// MARK: - Storyboard Constants
extension PaymentScreenVC {
    static let storyboard = "PaymentScreen"
    static let identifier = "PaymentScreenVC"
} 