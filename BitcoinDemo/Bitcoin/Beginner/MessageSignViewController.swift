//
//  MessageSignViewController.swift
//  Bitcoin
//
//  Created on 2026/1/11.
//

import UIKit
import SnapKit
import Bitcoin_alpha
class MessageSignViewController: UIViewController {
    lazy var bitcoin: Bitcoin_V1 = {
        let btc = Bitcoin_V1()
        return btc
    }()
    
    // MARK: - UI Components
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemGroupedBackground
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Network Selection
    private lazy var networkSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Network Type"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var networkSegmentedControl: UISegmentedControl = {
        let items = ["Mainnet", "Testnet"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 1 // Default to testnet
        return control
    }()
    
    // MARK: - Private Key Section
    private lazy var privateKeySectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Private Key (Hex)"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var privateKeyTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter private key (for signing)"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var privateKeyHintLabel: UILabel = {
        let label = UILabel()
        label.text = "Tip: Leave empty to use wallet private key from above"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Message Section
    private lazy var messageSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Message Content"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.backgroundColor = .systemBackground
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.separator.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        return textView
    }()
    
    // MARK: - Address Type Section
    private lazy var addressTypeSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Address Type"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var addressTypeSegmentedControl: UISegmentedControl = {
        let items = ["Legacy (P2PKH)", "Segwit (P2WPKH)", "Taproot (P2TR)"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 1 // Default to Segwit
        return control
    }()
    
    // MARK: - Sign Button
    private lazy var signButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Message", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(signButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Results Section
    private lazy var resultsSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Signature Result"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var resultsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
        view.isHidden = true
        return view
    }()
    
    private lazy var successLabel: UILabel = {
        let label = UILabel()
        label.text = "✅ Signature successful!"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .systemBlue
        return label
    }()
    
    private lazy var addressInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Address Used:"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemBlue
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var signatureInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Signature (Base64):"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var signatureLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var copySignatureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📋 Copy Signature", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(copySignatureTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Data
    private var signatureResult: String?
    private var usedAddress: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDefaultValues()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        title = "Sign Message"
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Network Selection
        contentView.addSubview(networkSectionLabel)
        contentView.addSubview(networkSegmentedControl)
        
        // Private Key
        contentView.addSubview(privateKeySectionLabel)
        contentView.addSubview(privateKeyTextField)
        contentView.addSubview(privateKeyHintLabel)
        
        // Message
        contentView.addSubview(messageSectionLabel)
        contentView.addSubview(messageTextView)
        
        // Address Type
        contentView.addSubview(addressTypeSectionLabel)
        contentView.addSubview(addressTypeSegmentedControl)
        
        // Sign Button
        contentView.addSubview(signButton)
        
        // Results Section
        contentView.addSubview(resultsSectionLabel)
        contentView.addSubview(resultsContainer)
        resultsContainer.addSubview(successLabel)
        resultsContainer.addSubview(addressInfoLabel)
        resultsContainer.addSubview(addressLabel)
        resultsContainer.addSubview(signatureInfoLabel)
        resultsContainer.addSubview(signatureLabel)
        resultsContainer.addSubview(copySignatureButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        // Network Selection
        networkSectionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        networkSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(networkSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Private Key
        privateKeySectionLabel.snp.makeConstraints { make in
            make.top.equalTo(networkSegmentedControl.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        privateKeyTextField.snp.makeConstraints { make in
            make.top.equalTo(privateKeySectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        privateKeyHintLabel.snp.makeConstraints { make in
            make.top.equalTo(privateKeyTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Message
        messageSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(privateKeyHintLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        messageTextView.snp.makeConstraints { make in
            make.top.equalTo(messageSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(120)
        }
        
        // Address Type
        addressTypeSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(messageTextView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        addressTypeSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(addressTypeSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Sign Button
        signButton.snp.makeConstraints { make in
            make.top.equalTo(addressTypeSegmentedControl.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        // Results
        resultsSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(signButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        resultsContainer.snp.makeConstraints { make in
            make.top.equalTo(resultsSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        successLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        addressInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(successLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(addressInfoLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        signatureInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        signatureLabel.snp.makeConstraints { make in
            make.top.equalTo(signatureInfoLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        copySignatureButton.snp.makeConstraints { make in
            make.top.equalTo(signatureLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setupDefaultValues() {
        messageTextView.text = "Hello, Bitcoin!"
    }
    
    // MARK: - Actions
    
    @objc private func signButtonTapped() {
        // Validate input
        let privKeyHex = privateKeyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let message = messageTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !message.isEmpty else {
            showAlert(title: "Error", message: "Please enter message to sign")
            return
        }
        
        // Show loading state
        signButton.isEnabled = false
        signButton.setTitle("Signing...", for: .normal)
        resultsContainer.isHidden = true
        signatureResult = nil
        usedAddress = nil
        
        let isTestnet = networkSegmentedControl.selectedSegmentIndex == 1
        let addressTypeIndex = addressTypeSegmentedControl.selectedSegmentIndex
        let addressType: String
        switch addressTypeIndex {
        case 0:
            addressType = "legacy"
        case 1:
            addressType = "segwit"
        case 2:
            addressType = "taproot"
        default:
            addressType = "segwit"
        }
        
        // Use async/await for concurrent execution
        Task {
            await performSign(message: message, privKeyHex: privKeyHex, addressType: addressType, isTestnet: isTestnet)
        }
    }
    
    // MARK: - Async/Await Implementation
    @available(iOS 13.0, *)
    private func performSign(message: String, privKeyHex: String?, addressType: String, isTestnet: Bool) async {
        // Ensure Bitcoin is initialized
        if !bitcoin.isSuccess {
            await withCheckedContinuation { continuation in
                bitcoin.setup(showLog: true) { _ in
                    continuation.resume()
                }
            }
        }
        
        // Call message signing method using async/await
        let (success, address, signature, errorMessage) = await bitcoin.signMessage(
            message: message,
            privKeyHex: privKeyHex,
            addressType: addressType,
            isTestnet: isTestnet
        )
        
        // Update UI on main thread
        await MainActor.run {
            self.signButton.isEnabled = true
            self.signButton.setTitle("Sign Message", for: .normal)
            
            if success, let address = address, let signature = signature {
                self.updateResults(address: address, signature: signature)
                self.showToast(message: "Message signed successfully")
            } else {
                self.showAlert(title: "Signing Failed", message: errorMessage ?? "Unknown error")
            }
        }
    }
    
    @objc private func copySignatureTapped() {
        guard let signature = signatureResult, !signature.isEmpty else {
            showToast(message: "No signature to copy")
            return
        }
        
        UIPasteboard.general.string = signature
        showToast(message: "Signature copied to clipboard")
    }
    
    @MainActor
    private func updateResults(address: String, signature: String) {
        signatureResult = signature
        usedAddress = address
        
        self.addressLabel.text = address
        self.signatureLabel.text = signature
        self.resultsContainer.isHidden = false
        
        // Scroll to result area
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
            let rect = self.resultsContainer.frame
            self.scrollView.scrollRectToVisible(rect, animated: true)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showToast(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true)
        }
    }
}

