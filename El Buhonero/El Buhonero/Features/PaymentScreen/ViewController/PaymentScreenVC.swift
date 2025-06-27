//
//  PaymentScreenVC.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import UIKit

class PaymentScreenVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var expirationMonthTextField: UITextField!
    @IBOutlet weak var expirationYearTextField: UITextField!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var testCardInfoLabel: UILabel!
    
    // MARK: - Properties
    var coordinator: PaymentScreenCoordinator?
    var viewModel: PaymentScreenViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        setupTextFields()
        showTestCardInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = "Payment"
        view.backgroundColor = .systemBackground
        
        // Setup product info
        productTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        productPriceLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        productPriceLabel.textColor = .systemBlue
        
        // Setup pay button
        payButton.setTitle("Pay Now", for: .normal)
        payButton.backgroundColor = .systemBlue
        payButton.setTitleColor(.white, for: .normal)
        payButton.layer.cornerRadius = 8
        payButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        // Setup activity indicator
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        
        // Setup test card info
        testCardInfoLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        testCardInfoLabel.textColor = .secondaryLabel
        testCardInfoLabel.numberOfLines = 0
    }
    
    private func setupViewModel() {
        viewModel?.delegate = self
        
        // Update UI with product info
        productTitleLabel.text = viewModel?.productTitle
        productPriceLabel.text = viewModel?.productPrice
    }
    
    private func setupTextFields() {
        // Setup text field delegates
        cardNumberTextField.delegate = self
        cvvTextField.delegate = self
        expirationMonthTextField.delegate = self
        expirationYearTextField.delegate = self
        
        // Setup placeholders
        cardNumberTextField.placeholder = "Card Number"
        cvvTextField.placeholder = "CVV"
        expirationMonthTextField.placeholder = "MM"
        expirationYearTextField.placeholder = "YY"
        
        // Setup keyboard types
        cardNumberTextField.keyboardType = .numberPad
        cvvTextField.keyboardType = .numberPad
        expirationMonthTextField.keyboardType = .numberPad
        expirationYearTextField.keyboardType = .numberPad
        
        // Setup input masks
        cardNumberTextField.addTarget(self, action: #selector(cardNumberChanged), for: .editingChanged)
        expirationMonthTextField.addTarget(self, action: #selector(expirationMonthChanged), for: .editingChanged)
        expirationYearTextField.addTarget(self, action: #selector(expirationYearChanged), for: .editingChanged)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
    }
    
    private func showTestCardInfo() {
        let testCard = viewModel?.getValidTestCard()
        testCardInfoLabel.text = "Test Card: \(testCard?.number ?? "") | CVV: \(testCard?.cvv ?? "") | Exp: \(testCard?.expirationMonth ?? "")/\(testCard?.expirationYear ?? "")"
    }
    
    private func validateForm() -> Bool {
        guard let cardNumber = cardNumberTextField.text, !cardNumber.isEmpty else {
            showAlert(title: "Error", message: "Please enter card number")
            return false
        }
        
        guard let cvv = cvvTextField.text, !cvv.isEmpty else {
            showAlert(title: "Error", message: "Please enter CVV")
            return false
        }
        
        guard let month = expirationMonthTextField.text, !month.isEmpty else {
            showAlert(title: "Error", message: "Please enter expiration month")
            return false
        }
        
        guard let year = expirationYearTextField.text, !year.isEmpty else {
            showAlert(title: "Error", message: "Please enter expiration year")
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
        
        let card = PaymentCard(
            number: cardNumberTextField.text ?? "",
            cvv: cvvTextField.text ?? "",
            expirationMonth: expirationMonthTextField.text ?? "",
            expirationYear: expirationYearTextField.text ?? ""
        )
        
        viewModel?.processPayment(card: card)
    }
    
    @objc private func cardNumberChanged() {
        guard let text = cardNumberTextField.text else { return }
        let cleaned = text.replacingOccurrences(of: " ", with: "")
        let formatted = formatCardNumber(cleaned)
        cardNumberTextField.text = formatted
    }
    
    @objc private func expirationMonthChanged() {
        guard let text = expirationMonthTextField.text else { return }
        if text.count > 2 {
            expirationMonthTextField.text = String(text.prefix(2))
        }
    }
    
    @objc private func expirationYearChanged() {
        guard let text = expirationYearTextField.text else { return }
        if text.count > 2 {
            expirationYearTextField.text = String(text.prefix(2))
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
        case cardNumberTextField:
            return newText.replacingOccurrences(of: " ", with: "").count <= 16
        case cvvTextField:
            return newText.count <= 4
        case expirationMonthTextField:
            return newText.count <= 2
        case expirationYearTextField:
            return newText.count <= 2
        default:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case cardNumberTextField:
            cvvTextField.becomeFirstResponder()
        case cvvTextField:
            expirationMonthTextField.becomeFirstResponder()
        case expirationMonthTextField:
            expirationYearTextField.becomeFirstResponder()
        case expirationYearTextField:
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
            activityIndicator.startAnimating()
            payButton.isEnabled = false
            payButton.setTitle("Processing...", for: .disabled)
        } else {
            activityIndicator.stopAnimating()
            payButton.isEnabled = true
            payButton.setTitle("Pay Now", for: .normal)
        }
    }
    
    func paymentSuccess() {
        coordinator?.showPaymentSuccess()
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