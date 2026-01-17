//
//  AddressValidatorViewController.swift
//  Bitcoin
//
//  Created on 2026/1/11.
//

import UIKit
import SnapKit


class AddressValidatorViewController: UIViewController {
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
    
    // MARK: - Address Input Section
    private lazy var addressSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Validate Address"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var addressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Bitcoin address"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(addressTextFieldChanged), for: .editingChanged)
        return textField
    }()
    
    // MARK: - Validate Button
    private lazy var validateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Validate Address", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(validateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Results Section
    private lazy var resultsSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Validation Result"
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
    
    private lazy var validationStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Validation Status: -"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var addressTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Address Type: -"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var networkTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Network Type: -"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var addressDisplayLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var copyAddressButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Copy Address", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(copyAddressTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Data
    private var validationResult: AddressValidationResult_V1?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        title = "Address Validator"
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Address Input
        contentView.addSubview(addressSectionLabel)
        contentView.addSubview(addressTextField)
        
        // Validate Button
        contentView.addSubview(validateButton)
        
        // Results Section
        contentView.addSubview(resultsSectionLabel)
        contentView.addSubview(resultsContainer)
        resultsContainer.addSubview(validationStatusLabel)
        resultsContainer.addSubview(addressTypeLabel)
        resultsContainer.addSubview(networkTypeLabel)
        resultsContainer.addSubview(addressDisplayLabel)
        resultsContainer.addSubview(copyAddressButton)
        
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
        
        // Address Input
        addressSectionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        addressTextField.snp.makeConstraints { make in
            make.top.equalTo(addressSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // Validate Button
        validateButton.snp.makeConstraints { make in
            make.top.equalTo(addressTextField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        // Results Section
        resultsSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(validateButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        resultsContainer.snp.makeConstraints { make in
            make.top.equalTo(resultsSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        validationStatusLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        addressTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(validationStatusLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        networkTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(addressTypeLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        addressDisplayLabel.snp.makeConstraints { make in
            make.top.equalTo(networkTypeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        copyAddressButton.snp.makeConstraints { make in
            make.top.equalTo(addressDisplayLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    // MARK: - Actions
    @objc private func addressTextFieldChanged() {
        // When input changes, can validate in real-time or clear result
        resultsContainer.isHidden = true
        validationResult = nil
    }
    
    @objc private func validateButtonTapped() {
        guard let address = addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !address.isEmpty else {
            showAlert(title: "Error", message: "Please enter Bitcoin address")
            return
        }
        
        // Show loading state
        validateButton.isEnabled = false
        validateButton.setTitle("Validating...", for: .normal)
        
        // Use async/await for concurrent execution
        Task {
            await validateAddress(address: address)
        }
    }
    
    // MARK: - Async/Await Implementation
    @available(iOS 13.0, *)
    private func validateAddress(address: String) async {
        // Ensure Bitcoin is initialized
        if !bitcoin.isSuccess {
            await withCheckedContinuation { continuation in
                bitcoin.setup(showLog: true) { _ in
                    continuation.resume()
                }
            }
        }
        
        // Validate address using async/await
        let (success, result, error) = await bitcoin.validateAddress(address: address)
        
        // Update UI on main thread
        await MainActor.run {
            // Restore button state
            self.validateButton.isEnabled = true
            self.validateButton.setTitle("Validate Address", for: .normal)
            
            if success, let result = result {
                // Success: Update UI to display validation result
                self.updateResults(with: result, address: address)
            } else {
                // Failure: Display error message
                let errorMessage = error ?? "Unknown error"
                self.showToast(message: "Validation failed: \(errorMessage)")
            }
        }
    }
    
    @MainActor
    private func updateResults(with result: AddressValidationResult_V1, address: String) {
        validationResult = result
        
        // Update validation status
        if result.isValid {
            self.validationStatusLabel.text = "Validation Status: ✅ Valid"
            self.validationStatusLabel.textColor = .systemGreen
        } else {
            self.validationStatusLabel.text = "Validation Status: ❌ Invalid"
            self.validationStatusLabel.textColor = .systemRed
        }
        
        // Update address type
        self.addressTypeLabel.text = "Address Type: \(result.typeDisplayName)"
        
        // Update network type
        self.networkTypeLabel.text = "Network Type: \(result.networkDisplayName)"
        
        // Update address display
        self.addressDisplayLabel.text = address
        
        // Show result container
        self.resultsContainer.isHidden = false
        
        // Scroll to result area
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
            let rect = self.resultsContainer.frame
            self.scrollView.scrollRectToVisible(rect, animated: true)
        }
    }
    
    @objc private func copyAddressTapped() {
        guard let address = addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !address.isEmpty else {
            showToast(message: "No address to copy")
            return
        }
        
        UIPasteboard.general.string = address
        showToast(message: "Address copied to clipboard")
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showToast(message: String) {
        print("Toast: \(message)")
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true)
        }
    }
}

