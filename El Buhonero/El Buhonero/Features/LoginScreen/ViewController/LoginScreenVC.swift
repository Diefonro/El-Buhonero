//
//  LoginScreenVC.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import UIKit

class LoginScreenVC: UIViewController, StoryboardInfo {
    
    var loginCoordinator: LoginScreenCoordinator?
    
    static var storyboard = "LoginScreen"
    static var identifier = "LoginScreenVC"
    
    var viewModel: LoginViewModel?
    
    // MARK: - IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }
    
    func setCoordinator(coordinator: LoginScreenCoordinator?) {
        self.loginCoordinator = coordinator
    }
    
    func setViewModel(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        usernameTextField.placeholder = "Username"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.autocorrectionType = .no
        usernameTextField.autocapitalizationType = .none
        usernameTextField.delegate = self
        
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 8
        
        googleLoginButton.setTitle("Login with Google", for: .normal)
        googleLoginButton.backgroundColor = .systemRed
        googleLoginButton.setTitleColor(.white, for: .normal)
        googleLoginButton.layer.cornerRadius = 8
        
        appleLoginButton.setTitle("Login with Apple", for: .normal)
        appleLoginButton.backgroundColor = .black
        appleLoginButton.setTitleColor(.white, for: .normal)
        appleLoginButton.layer.cornerRadius = 8
        
        errorLabel.textColor = .systemRed
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
    }
    
    private func setupViewModel() {
        viewModel?.onLoginSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.hideError()
                self?.navigateToHome()
            }
        }
        
        viewModel?.onLoginError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showError(message: errorMessage)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !username.isEmpty else {
            showError(message: "Please enter a username")
            return
        }
        
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !password.isEmpty else {
            showError(message: "Please enter a password")
            return
        }
        
        hideError()
        startLoading()
        viewModel?.login(username: username, password: password)
    }
    
    @IBAction func googleLoginButtonTapped(_ sender: Any) {
        // TODO: Implement Google login with Firebase Auth
        print("Google login tapped")
    }
    
    @IBAction func appleLoginButtonTapped(_ sender: Any) {
        // TODO: Implement Apple login with Firebase Auth
        print("Apple login tapped")
    }
    
    // MARK: - Helper Methods
    private func showError(message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        stopLoading()
    }
    
    private func hideError() {
        errorLabel.isHidden = true
        stopLoading()
    }
    
    private func navigateToHome() {
        loginCoordinator?.pushToHomeScreen()
    }
    
    private func startLoading() {
        activityIndicator.startAnimating()
        loginButton.isEnabled = false
        loginButton.setTitle("Logging in...", for: .disabled)
    }
    
    private func stopLoading() {
        activityIndicator.stopAnimating()
        loginButton.isEnabled = true
        loginButton.setTitle("Login", for: .normal)
    }
}

// MARK: - UITextFieldDelegate
extension LoginScreenVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            loginButtonTapped(loginButton as Any)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideError()
    }
} 
 