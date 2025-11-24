//
//  LoginViewController.swift
//  HomeFitPoints
//
//  Created by Fabian Armenta on 23/11/25.
//


import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    var onLoginSuccess: (() -> Void)?
    private var isLoginMode = true
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let actionButton = UIButton(type: .system)
    private let toggleButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = Theme.Colors.background
        
        logoImageView.image = UIImage(named: "LogoApp")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = NSLocalizedString("login_title", comment: "")
        titleLabel.font = Theme.Fonts.title(size: 28)
        titleLabel.textColor = Theme.Colors.primaryBlack
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        styleTextField(emailField, placeholder: NSLocalizedString("login_email_ph", comment: ""))
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none
        
        styleTextField(passwordField, placeholder: NSLocalizedString("login_pass_ph", comment: ""))
        passwordField.isSecureTextEntry = true
        
        actionButton.setTitle(NSLocalizedString("login_btn", comment: ""), for: .normal)
        actionButton.backgroundColor = Theme.Colors.primaryOrange
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        actionButton.layer.cornerRadius = 12
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        toggleButton.setTitle(NSLocalizedString("login_toggle_signup", comment: ""), for: .normal)
        toggleButton.setTitleColor(.gray, for: .normal)
        toggleButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(actionButton)
        view.addSubview(toggleButton)
        actionButton.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 40),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: actionButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: actionButton.centerYAnchor),
            
            toggleButton.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 20),
            toggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func styleTextField(_ tf: UITextField, placeholder: String) {
        tf.placeholder = placeholder
        tf.borderStyle = .none
        tf.layer.backgroundColor = UIColor.systemGray6.cgColor
        tf.layer.cornerRadius = 8
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 50))
        tf.leftViewMode = .always
        tf.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupActions() {
        actionButton.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        toggleButton.addTarget(self, action: #selector(toggleMode), for: .touchUpInside)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @objc private func toggleMode() {
        isLoginMode.toggle()
        UIView.transition(with: view, duration: 0.2, options: .transitionCrossDissolve, animations: {
            if self.isLoginMode {
                self.titleLabel.text = NSLocalizedString("login_title", comment: "")
                self.actionButton.setTitle(NSLocalizedString("login_btn", comment: ""), for: .normal)
                self.toggleButton.setTitle(NSLocalizedString("login_toggle_signup", comment: ""), for: .normal)
            } else {
                self.titleLabel.text = NSLocalizedString("signup_title", comment: "")
                self.actionButton.setTitle(NSLocalizedString("signup_btn", comment: ""), for: .normal)
                self.toggleButton.setTitle(NSLocalizedString("login_toggle_login", comment: ""), for: .normal)
            }
        }, completion: nil)
    }
    
    @objc private func handleAction() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            showAlert(message: NSLocalizedString("login_error_empty", comment: ""))
            return
        }
        
        if !isValidEmail(email) {
            showAlert(message: NSLocalizedString("login_error_invalid_email", comment: ""))
            return
        }
        
        setLoading(true)
        
        if isLoginMode {
            AuthManager.shared.login(email: email, password: password) { [weak self] result in
                guard let self = self else { return }
                self.setLoading(false)
                switch result {
                case .success(_):
                    self.dismiss(animated: true) { self.onLoginSuccess?() }
                case .failure(let error):
                    self.showAlert(message: error.localizedDescription)
                }
            }
        } else {
            AuthManager.shared.register(email: email, password: password) { [weak self] result in
                guard let self = self else { return }
                self.setLoading(false)
                switch result {
                case .success(_):
                    self.dismiss(animated: true) { self.onLoginSuccess?() }
                case .failure(let error):
                    let friendlyMessage = self.getLocalizedErrorMessage(error)
                    self.showAlert(message: friendlyMessage)
                }
            }
        }
    }
    
    private func setLoading(_ loading: Bool) {
        actionButton.setTitle(loading ? "" : (isLoginMode ? NSLocalizedString("login_btn", comment: "") : NSLocalizedString("signup_btn", comment: "")), for: .normal)
        actionButton.isEnabled = !loading
        if loading { activityIndicator.startAnimating() } else { activityIndicator.stopAnimating() }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("error_title", comment: ""), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default))
        present(alert, animated: true)
    }
    
    private func getLocalizedErrorMessage(_ error: Error) -> String {
        let nsError = error as NSError
        
        if let errorCode = AuthErrorCode(rawValue: nsError.code) {
            switch errorCode {
            case .userNotFound:
                return NSLocalizedString("auth_error_user_not_found", comment: "")
            case .wrongPassword:
                return NSLocalizedString("auth_error_wrong_password", comment: "")
            case .emailAlreadyInUse:
                return NSLocalizedString("auth_error_email_already_in_use", comment: "")
            case .invalidEmail:
                return NSLocalizedString("auth_error_invalid_email", comment: "")
            case .weakPassword:
                return NSLocalizedString("auth_error_weak_password", comment: "")
            case .invalidCredential:
                return NSLocalizedString("auth_error_invalid_credential", comment: "")
            case .networkError:
                return NSLocalizedString("error_no_internet", comment: "")
            default:
                return NSLocalizedString("auth_error_generic", comment: "")
            }
        }
        
        return NSLocalizedString("auth_error_generic", comment: "")
    }
}
