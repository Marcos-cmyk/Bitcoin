//
//  ImportWalletViewController.swift
//  Bitcoin
//
//  Created on 2026/1/10.
//

import UIKit
import SnapKit

class ImportWalletViewController: UIViewController {
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
    
    private lazy var networkStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var networkLabel: UILabel = {
        let label = UILabel()
        label.text = "Network:"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var networkSegmentedControl: UISegmentedControl = {
        let items = ["Mainnet", "Testnet"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 1 // Default to testnet
        control.addTarget(self, action: #selector(networkChanged), for: .valueChanged)
        return control
    }()
    
    // MARK: - Import Type Selection
    private lazy var importTypeSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Import Method"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var importTypeSegmentedControl: UISegmentedControl = {
        let items = ["Mnemonic", "Private Key"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0 // Default to mnemonic
        control.addTarget(self, action: #selector(importTypeChanged), for: .valueChanged)
        return control
    }()
    
    // MARK: - Import Mnemonic Section
    private lazy var mnemonicInputSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Mnemonic"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var mnemonicTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.monospacedSystemFont(ofSize: 15, weight: .regular)
        textView.backgroundColor = .systemBackground
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.separator.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.delegate = self
        return textView
    }()
    
    private lazy var mnemonicPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter 12 or 24 mnemonic words, separated by spaces\nExample: abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
        label.font = UIFont.monospacedSystemFont(ofSize: 15, weight: .regular)
        label.textColor = .placeholderText
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Import Private Key Section
    private lazy var privateKeyInputSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Private Key"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var privateKeyTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter hexadecimal private key (64 characters)"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.font = UIFont.monospacedSystemFont(ofSize: 15, weight: .regular)
        textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(privateKeyTextChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var showPrivateKeyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(togglePrivateKeyVisibility), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Import Button
    private lazy var importButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Import Wallet", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(importWalletTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Wallet Info Display Section
    private lazy var walletInfoSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Wallet Information"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var walletInfoHeaderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var copyAllWalletDataButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Copy All JSON", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        button.addTarget(self, action: #selector(copyAllWalletDataTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var walletInfoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
        view.isHidden = true // Initially hidden, shown after successful import
        return view
    }()
    
    private lazy var mnemonicInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Mnemonic:"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var mnemonicDisplayLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.monospacedSystemFont(ofSize: 15, weight: .regular)
        label.textColor = .systemOrange
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var mnemonicCopyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(copyMnemonicTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var privateKeyInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Private Key (Hex):"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var privateKeyDisplayLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var privateKeyCopyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(copyPrivateKeyTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var publicKeyInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Public Key (Hex):"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var publicKeyDisplayLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var publicKeyCopyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(copyPublicKeyTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var addressesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var legacyAddressView = createAddressView(title: "Legacy Address (P2PKH):", tag: 1001)
    private lazy var segwitAddressView = createAddressView(title: "Segwit Address (P2WPKH):", tag: 1002)
    private lazy var taprootAddressView = createAddressView(title: "Taproot Address (P2TR):", tag: 1003)
    
    // MARK: - Data
    private var isImportingMnemonic: Bool = true // true: mnemonic, false: private key
    private var isPrivateKeyVisible: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        title = "Import Wallet"
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Network Selection
        contentView.addSubview(networkSectionLabel)
        contentView.addSubview(networkStackView)
        networkStackView.addArrangedSubview(networkLabel)
        networkStackView.addArrangedSubview(networkSegmentedControl)
        
        // Import Type Selection
        contentView.addSubview(importTypeSectionLabel)
        contentView.addSubview(importTypeSegmentedControl)
        
        // Mnemonic Input Section
        contentView.addSubview(mnemonicInputSectionLabel)
        contentView.addSubview(mnemonicTextView)
        mnemonicTextView.addSubview(mnemonicPlaceholderLabel)
        
        // Private Key Input Section
        contentView.addSubview(privateKeyInputSectionLabel)
        contentView.addSubview(privateKeyTextField)
        contentView.addSubview(showPrivateKeyButton)
        
        // Import Button
        contentView.addSubview(importButton)
        
        // Wallet Info Section
        contentView.addSubview(walletInfoHeaderStackView)
        walletInfoHeaderStackView.addArrangedSubview(walletInfoSectionLabel)
        walletInfoHeaderStackView.addArrangedSubview(copyAllWalletDataButton)
        contentView.addSubview(walletInfoContainer)
        
        walletInfoContainer.addSubview(mnemonicInfoLabel)
        walletInfoContainer.addSubview(mnemonicDisplayLabel)
        walletInfoContainer.addSubview(mnemonicCopyButton)
        
        walletInfoContainer.addSubview(privateKeyInfoLabel)
        walletInfoContainer.addSubview(privateKeyDisplayLabel)
        walletInfoContainer.addSubview(privateKeyCopyButton)
        
        walletInfoContainer.addSubview(publicKeyInfoLabel)
        walletInfoContainer.addSubview(publicKeyDisplayLabel)
        walletInfoContainer.addSubview(publicKeyCopyButton)
        
        walletInfoContainer.addSubview(addressesStackView)
        
        addressesStackView.addArrangedSubview(legacyAddressView)
        addressesStackView.addArrangedSubview(segwitAddressView)
        addressesStackView.addArrangedSubview(taprootAddressView)
        
        setupConstraints()
        updateImportTypeUI()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        // Network Selection
        networkSectionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        networkStackView.snp.makeConstraints { make in
            make.top.equalTo(networkSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        networkSegmentedControl.snp.makeConstraints { make in
            make.width.equalTo(250)
        }
        
        // Import Type Selection
        importTypeSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(networkStackView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        importTypeSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(importTypeSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(32)
        }
        
        // Mnemonic Input Section
        mnemonicInputSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(importTypeSegmentedControl.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        mnemonicTextView.snp.makeConstraints { make in
            make.top.equalTo(mnemonicInputSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(120)
        }
        
        mnemonicPlaceholderLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(12)
        }
        
        // Private Key Input Section (initial position same as mnemonic, dynamically adjusted based on import type)
        privateKeyInputSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(importTypeSegmentedControl.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        privateKeyTextField.snp.makeConstraints { make in
            make.top.equalTo(privateKeyInputSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        showPrivateKeyButton.snp.makeConstraints { make in
            make.top.equalTo(privateKeyTextField.snp.bottom).offset(8)
            make.trailing.equalToSuperview().inset(20)
        }
        
        // Import Button (dynamically adjusted based on currently displayed input area)
        importButton.snp.makeConstraints { make in
            make.top.equalTo(mnemonicTextView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        // Wallet Info Section
        walletInfoHeaderStackView.snp.makeConstraints { make in
            make.top.equalTo(importButton.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        walletInfoSectionLabel.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(100)
        }
        
        copyAllWalletDataButton.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(100)
        }
        
        walletInfoContainer.snp.makeConstraints { make in
            make.top.equalTo(walletInfoHeaderStackView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        // Wallet Info Content
        mnemonicInfoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(mnemonicCopyButton.snp.leading).offset(-8)
        }
        
        mnemonicCopyButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(24)
        }
        
        mnemonicDisplayLabel.snp.makeConstraints { make in
            make.top.equalTo(mnemonicInfoLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        privateKeyInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(mnemonicDisplayLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(privateKeyCopyButton.snp.leading).offset(-8)
        }
        
        privateKeyCopyButton.snp.makeConstraints { make in
            make.top.equalTo(privateKeyInfoLabel.snp.top)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(24)
        }
        
        privateKeyDisplayLabel.snp.makeConstraints { make in
            make.top.equalTo(privateKeyInfoLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        publicKeyInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(privateKeyDisplayLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(publicKeyCopyButton.snp.leading).offset(-8)
        }
        
        publicKeyCopyButton.snp.makeConstraints { make in
            make.top.equalTo(publicKeyInfoLabel.snp.top)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(24)
        }
        
        publicKeyDisplayLabel.snp.makeConstraints { make in
            make.top.equalTo(publicKeyInfoLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        addressesStackView.snp.makeConstraints { make in
            make.top.equalTo(publicKeyDisplayLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    // MARK: - Helper Methods
    private func setupNotifications() {
        // Use UITextViewDelegate to handle text changes, no longer need NotificationCenter
    }
    
    private func updateImportTypeUI() {
        let isMnemonic = isImportingMnemonic
        
        // Update mnemonic area display
        mnemonicInputSectionLabel.isHidden = !isMnemonic
        mnemonicTextView.isHidden = !isMnemonic
        
        // Update private key area display
        privateKeyInputSectionLabel.isHidden = isMnemonic
        privateKeyTextField.isHidden = isMnemonic
        showPrivateKeyButton.isHidden = isMnemonic
        
        // Update placeholder display
        updatePlaceholderVisibility()
        
        // Update import button position
        if isMnemonic {
            importButton.snp.remakeConstraints { make in
                make.top.equalTo(mnemonicTextView.snp.bottom).offset(30)
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(50)
            }
        } else {
            importButton.snp.remakeConstraints { make in
                make.top.equalTo(showPrivateKeyButton.snp.bottom).offset(30)
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(50)
            }
        }
        
        // Update constraints
        view.layoutIfNeeded()
    }
    
    private func updatePlaceholderVisibility() {
        mnemonicPlaceholderLabel.isHidden = !mnemonicTextView.text.isEmpty
    }
    
    private func createAddressView(title: String, tag: Int) -> UIView {
        let containerView = UIView()
        containerView.tag = tag
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .secondaryLabel
        
        let addressLabel = UILabel()
        addressLabel.text = "-"
        addressLabel.font = UIFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        addressLabel.textColor = .label
        addressLabel.numberOfLines = 0
        addressLabel.tag = tag + 100
        
        let copyButton = UIButton(type: .system)
        copyButton.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        copyButton.tintColor = .systemBlue
        copyButton.tag = tag + 200
        copyButton.addTarget(self, action: #selector(copyAddressTapped(_:)), for: .touchUpInside)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(addressLabel)
        containerView.addSubview(copyButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalTo(copyButton.snp.leading).offset(-8)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        copyButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        return containerView
    }
    
    // MARK: - Actions
    @objc private func networkChanged(_ sender: UISegmentedControl) {
        let isTestnet = sender.selectedSegmentIndex == 1
        print("Network changed to: \(isTestnet ? "Testnet" : "Mainnet")")
        // TODO: Implement network switching logic
    }
    
    @objc private func importTypeChanged(_ sender: UISegmentedControl) {
        isImportingMnemonic = sender.selectedSegmentIndex == 0
        updateImportTypeUI()
        print("Import type changed to: \(isImportingMnemonic ? "Mnemonic" : "Private Key")")
    }
    
    
    @objc private func privateKeyTextChanged() {
        // Can add private key format validation here
    }
    
    @objc private func togglePrivateKeyVisibility() {
        isPrivateKeyVisible.toggle()
        privateKeyTextField.isSecureTextEntry = !isPrivateKeyVisible
        showPrivateKeyButton.setTitle(isPrivateKeyVisible ? "Hide" : "Show", for: .normal)
    }
    
    @objc private func importWalletTapped() {
        // Get network type
        let isTestnet = networkSegmentedControl.selectedSegmentIndex == 1
        
        // Show loading state
        importButton.isEnabled = false
        importButton.setTitle("Importing...", for: .normal)
        
        if isImportingMnemonic {
            // Import mnemonic
            let mnemonic = mnemonicTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            if mnemonic.isEmpty {
                importButton.isEnabled = true
                importButton.setTitle("Import Wallet", for: .normal)
                showAlert(title: "Error", message: "Please enter mnemonic")
                return
            }
            
            // Validate mnemonic format (simple validation)
            let words = mnemonic.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
            if words.count != 12 && words.count != 24 {
                importButton.isEnabled = true
                importButton.setTitle("Import Wallet", for: .normal)
                showAlert(title: "Error", message: "Mnemonic must be 12 or 24 words")
                return
            }
            
            // Use async/await for concurrent execution
            Task {
                await importAccountFromMnemonic(mnemonic: mnemonic, isTestnet: isTestnet)
            }
        } else {
            // Import private key
            guard let privateKey = privateKeyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !privateKey.isEmpty else {
                importButton.isEnabled = true
                importButton.setTitle("Import Wallet", for: .normal)
                showAlert(title: "Error", message: "Please enter private key")
                return
            }
            
            // Validate private key format (simple validation)
            let hexCharacterSet = CharacterSet(charactersIn: "0123456789abcdefABCDEF")
            if privateKey.count != 64 || privateKey.rangeOfCharacter(from: hexCharacterSet.inverted) != nil {
                importButton.isEnabled = true
                importButton.setTitle("Import Wallet", for: .normal)
                showAlert(title: "Error", message: "Private key must be 64 hexadecimal characters")
                return
            }
            
            // Use async/await for concurrent execution
            Task {
                await importAccountFromPrivateKey(privateKey: privateKey, isTestnet: isTestnet)
            }
        }
    }
    
    // MARK: - Async/Await Implementation
    @available(iOS 13.0, *)
    private func importAccountFromMnemonic(mnemonic: String, isTestnet: Bool) async {
        // Ensure Bitcoin is initialized
        if !bitcoin.isSuccess {
            await withCheckedContinuation { continuation in
                bitcoin.setup(showLog: true) { _ in
                    continuation.resume()
                }
            }
        }
        
        // Import wallet from mnemonic using async/await
        let (success, wallet, error) = await bitcoin.importAccountFromMnemonic(mnemonic: mnemonic, isTestnet: isTestnet, language: nil)
        
        // Update UI on main thread
        await MainActor.run {
            // Restore button state
            self.importButton.isEnabled = true
            self.importButton.setTitle("Import Wallet", for: .normal)
            
            if success, let wallet = wallet {
                // Success: Fill wallet data into UI controls
                self.updateWalletUI(with: wallet)
                self.showToast(message: "Wallet imported successfully")
            } else {
                // Failure: Display error message
                let errorMessage = error ?? "Unknown error"
                self.showToast(message: "Import failed: \(errorMessage)")
            }
        }
    }
    
    @available(iOS 13.0, *)
    private func importAccountFromPrivateKey(privateKey: String, isTestnet: Bool) async {
        // Ensure Bitcoin is initialized
        if !bitcoin.isSuccess {
            await withCheckedContinuation { continuation in
                bitcoin.setup(showLog: true) { _ in
                    continuation.resume()
                }
            }
        }
        
        // Import wallet from private key using async/await
        let (success, wallet, error) = await bitcoin.importAccountFromPrivateKey(privateKey: privateKey, isTestnet: isTestnet)
        
        // Update UI on main thread
        await MainActor.run {
            // Restore button state
            self.importButton.isEnabled = true
            self.importButton.setTitle("Import Wallet", for: .normal)
            
            if success, let wallet = wallet {
                // Success: Fill wallet data into UI controls
                self.updateWalletUI(with: wallet)
                self.showToast(message: "Wallet imported successfully")
            } else {
                // Failure: Display error message
                let errorMessage = error ?? "Unknown error"
                self.showToast(message: "Import failed: \(errorMessage)")
            }
        }
    }
    
    /// Fill wallet data into UI controls
    @MainActor
    private func updateWalletUI(with wallet: BitcoinWallet_V1) {
        // Fill mnemonic
        if let mnemonic = wallet.mnemonic {
            mnemonicDisplayLabel.text = mnemonic
        } else {
            mnemonicDisplayLabel.text = "-"
        }
        
        // Fill private key
        privateKeyDisplayLabel.text = wallet.privateKey
        
        // Fill public key
        publicKeyDisplayLabel.text = wallet.publicKey
        
        // Fill address information
        // Legacy address (tag = 1001 + 100 = 1101)
        if let legacyLabel = legacyAddressView.viewWithTag(1101) as? UILabel {
            legacyLabel.text = wallet.addresses.legacy
        }
        
        // Segwit address (tag = 1002 + 100 = 1102)
        if let segwitLabel = segwitAddressView.viewWithTag(1102) as? UILabel {
            segwitLabel.text = wallet.addresses.segwit
        }
        
        // Taproot address (tag = 1003 + 100 = 1103)
        if let taprootLabel = taprootAddressView.viewWithTag(1103) as? UILabel {
            taprootLabel.text = wallet.addresses.taproot
        }
        
        // Show wallet info container
        walletInfoContainer.isHidden = false
        
        // Scroll to wallet info area
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let rect = self.walletInfoContainer.frame
            self.scrollView.scrollRectToVisible(rect, animated: true)
        }
    }
    
    @objc private func copyMnemonicTapped() {
        if let mnemonic = mnemonicDisplayLabel.text, mnemonic != "-" {
            UIPasteboard.general.string = mnemonic
            showToast(message: "Mnemonic copied")
        }
    }
    
    @objc private func copyPrivateKeyTapped() {
        if let privateKey = privateKeyDisplayLabel.text, privateKey != "-" {
            UIPasteboard.general.string = privateKey
            showToast(message: "Private key copied")
        }
    }
    
    @objc private func copyPublicKeyTapped() {
        if let publicKey = publicKeyDisplayLabel.text, publicKey != "-" {
            UIPasteboard.general.string = publicKey
            showToast(message: "Public key copied")
        }
    }
    
    @objc private func copyAddressTapped(_ sender: UIButton) {
        let addressLabelTag = sender.tag - 100
        if let containerView = sender.superview,
           let addressLabel = containerView.viewWithTag(addressLabelTag) as? UILabel,
           let address = addressLabel.text, address != "-" {
            UIPasteboard.general.string = address
            showToast(message: "Address copied")
        }
    }
    
    @objc private func copyAllWalletDataTapped() {
        guard let mnemonic = mnemonicDisplayLabel.text, mnemonic != "-",
              let privateKey = privateKeyDisplayLabel.text, privateKey != "-",
              let publicKey = publicKeyDisplayLabel.text, publicKey != "-" else {
            showToast(message: "Please import wallet first")
            return
        }
        
        // Get address information
        var legacyAddress = "-"
        var segwitAddress = "-"
        var taprootAddress = "-"
        
        if let legacyLabel = legacyAddressView.viewWithTag(1101) as? UILabel,
           let address = legacyLabel.text, address != "-" {
            legacyAddress = address
        }
        if let segwitLabel = segwitAddressView.viewWithTag(1102) as? UILabel,
           let address = segwitLabel.text, address != "-" {
            segwitAddress = address
        }
        if let taprootLabel = taprootAddressView.viewWithTag(1103) as? UILabel,
           let address = taprootLabel.text, address != "-" {
            taprootAddress = address
        }
        
        // Get network type
        let isTestnet = networkSegmentedControl.selectedSegmentIndex == 1
        let network = isTestnet ? "testnet" : "mainnet"
        
        // Build JSON data
        let walletData: [String: Any] = [
            "network": network,
            "mnemonic": mnemonic,
            "privateKey": privateKey,
            "publicKey": publicKey,
            "addresses": [
                "legacy": legacyAddress,
                "segwit": segwitAddress,
                "taproot": taprootAddress
            ]
        ]
        
        // Convert dictionary to JSON string
        guard let jsonData = try? JSONSerialization.data(withJSONObject: walletData, options: [.prettyPrinted, .sortedKeys]),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            showToast(message: "JSON formatting failed")
            return
        }
        
        // Copy to clipboard
        UIPasteboard.general.string = jsonString
        showToast(message: "All wallet data copied")
        
        print(jsonString)
        print("===================")
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

// MARK: - UITextViewDelegate
extension ImportWalletViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderVisibility()
    }
}
