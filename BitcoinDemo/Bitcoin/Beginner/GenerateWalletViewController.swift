//
//  GenerateWalletViewController.swift
//  Bitcoin
//
//  Created on 2026/1/10.
//

import UIKit
import SnapKit
import Bitcoin_alpha
class GenerateWalletViewController: UIViewController {
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
    
    // MARK: - Mnemonic Length Selection
    private lazy var mnemonicLengthSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Mnemonic Length"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var mnemonicLengthStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var mnemonicLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "Length:"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var mnemonicLengthTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Select mnemonic length"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.inputView = mnemonicLengthPicker
        textField.text = mnemonicLengthOptions[0].title
        textField.tintColor = .clear // Hide cursor
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePickerTapped))
        toolbar.setItems([doneButton], animated: false)
        textField.inputAccessoryView = toolbar
        
        return textField
    }()
    
    private lazy var mnemonicLengthPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .systemBackground
        picker.tag = 1000 // Mnemonic length picker tag
        return picker
    }()
    
    // MARK: - Mnemonic Language Selection
    private lazy var mnemonicLanguageSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Mnemonic Language"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var mnemonicLanguageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var mnemonicLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = "Language:"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var mnemonicLanguageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Select mnemonic language"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.inputView = mnemonicLanguagePicker
        textField.text = mnemonicLanguageOptions[0].title
        textField.tintColor = .clear // Hide cursor
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePickerTapped))
        toolbar.setItems([doneButton], animated: false)
        textField.inputAccessoryView = toolbar
        
        return textField
    }()
    
    private lazy var mnemonicLanguagePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .systemBackground
        picker.tag = 2000 // Mnemonic language picker tag
        return picker
    }()
    
    // MARK: - Generate Button
    private lazy var generateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Generate Wallet", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(generateWalletTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Wallet Info Display Section
    private lazy var walletInfoHeaderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var walletInfoSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Wallet Information"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
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
    private let mnemonicLengthOptions = [
        (value: 128, title: "12 words (128-bit)"),
        (value: 160, title: "15 words (160-bit)"),
        (value: 192, title: "18 words (192-bit)"),
        (value: 224, title: "21 words (224-bit)"),
        (value: 256, title: "24 words (256-bit)")
    ]
    
    private let mnemonicLanguageOptions = [
        (value: "english", title: "English"),
        (value: "chinese_simplified", title: "中文 (Simplified Chinese)"),
        (value: "chinese_traditional", title: "中文 (Traditional Chinese)"),
        (value: "korean", title: "한국어 (Korean)"),
        (value: "japanese", title: "日本語 (Japanese)"),
        (value: "french", title: "Français (French)"),
        (value: "italian", title: "Italiano (Italian)"),
        (value: "spanish", title: "Español (Spanish)"),
        (value: "czech", title: "Čeština (Czech)"),
        (value: "portuguese", title: "Português (Portuguese)")
    ]
    
    private var selectedMnemonicLength: Int = 128
    private var selectedMnemonicLanguage: String = "english"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        title = "Generate Wallet"
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Network Selection
        contentView.addSubview(networkSectionLabel)
        contentView.addSubview(networkStackView)
        networkStackView.addArrangedSubview(networkLabel)
        networkStackView.addArrangedSubview(networkSegmentedControl)
        
        // Mnemonic Length Selection
        contentView.addSubview(mnemonicLengthSectionLabel)
        contentView.addSubview(mnemonicLengthStackView)
        mnemonicLengthStackView.addArrangedSubview(mnemonicLengthLabel)
        mnemonicLengthStackView.addArrangedSubview(mnemonicLengthTextField)
        
        // Mnemonic Language Selection
        contentView.addSubview(mnemonicLanguageSectionLabel)
        contentView.addSubview(mnemonicLanguageStackView)
        mnemonicLanguageStackView.addArrangedSubview(mnemonicLanguageLabel)
        mnemonicLanguageStackView.addArrangedSubview(mnemonicLanguageTextField)
        
        // Generate Button
        contentView.addSubview(generateButton)
        
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
        
        // Mnemonic Length Selection
        mnemonicLengthSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(networkStackView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        mnemonicLengthStackView.snp.makeConstraints { make in
            make.top.equalTo(mnemonicLengthSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        mnemonicLengthTextField.snp.makeConstraints { make in
            make.width.equalTo(220)
        }
        
        // Mnemonic Language Selection
        mnemonicLanguageSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(mnemonicLengthStackView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        mnemonicLanguageStackView.snp.makeConstraints { make in
            make.top.equalTo(mnemonicLanguageSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        mnemonicLanguageTextField.snp.makeConstraints { make in
            make.width.equalTo(220)
        }
        
        // Generate Button
        generateButton.snp.makeConstraints { make in
            make.top.equalTo(mnemonicLanguageStackView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        // Wallet Info Section
        walletInfoHeaderStackView.snp.makeConstraints { make in
            make.top.equalTo(generateButton.snp.bottom).offset(40)
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
        addressLabel.tag = tag + 100 // Address label tag = container tag + 100
        
        let copyButton = UIButton(type: .system)
        copyButton.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        copyButton.tintColor = .systemBlue
        copyButton.tag = tag + 200 // Copy button tag = container tag + 200
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
    
    @objc private func generateWalletTapped() {
        print("Generate wallet tapped")
        print("Selected mnemonic length: \(selectedMnemonicLength) bits")
        print("Selected mnemonic language: \(selectedMnemonicLanguage)")
        
        // Get network type
        let isTestnet = networkSegmentedControl.selectedSegmentIndex == 1
        
        // Show loading state
        generateButton.isEnabled = false
        generateButton.setTitle("Generating...", for: .normal)
        
        // Use async/await for concurrent execution
        Task {
            await createAccount(mnemonicLength: selectedMnemonicLength, isTestnet: isTestnet, language: selectedMnemonicLanguage)
        }
    }
    
    // MARK: - Async/Await Implementation
    @available(iOS 13.0, *)
    private func createAccount(mnemonicLength: Int, isTestnet: Bool, language: String) async {
        // Ensure Bitcoin is initialized
        if !bitcoin.isSuccess {
            await withCheckedContinuation { continuation in
                bitcoin.setup(showLog: true) { _ in
                    continuation.resume()
                }
            }
        }
        
        // Create account using async/await
        let (success, wallet, error) = await bitcoin.createAccount(mnemonicLength: mnemonicLength, isTestnet: isTestnet, language: language)
        
        // Update UI on main thread
        await MainActor.run {
            // Restore button state
            self.generateButton.isEnabled = true
            self.generateButton.setTitle("Generate Wallet", for: .normal)
            
            if success, let wallet = wallet {
                // Success: Fill wallet data into UI controls
                self.updateWalletUI(with: wallet)
                self.showToast(message: "Wallet generated successfully")
            } else {
                // Failure: Display error message
                let errorMessage = error ?? "Unknown error"
                self.showToast(message: "Generation failed: \(errorMessage)")
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
        
        // Optional: Print wallet information for debugging
        print("=== Wallet Generated Successfully ===")
        print("Network: \(wallet.network)")
        print("Mnemonic Length: \(wallet.mnemonicLength ?? 0) bits")
        print("Mnemonic: \(wallet.mnemonic ?? "N/A")")
        print("Private Key: \(wallet.privateKey)")
        print("Public Key: \(wallet.publicKey)")
        print("Legacy Address: \(wallet.addresses.legacy)")
        print("Segwit Address: \(wallet.addresses.segwit)")
        print("Taproot Address: \(wallet.addresses.taproot)")
        print("===================")
    }
    
    @objc private func donePickerTapped() {
        view.endEditing(true)
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
        // Find corresponding address label based on button tag
        // Button tag = container tag + 200, address label tag = container tag + 100
        // So: addressLabelTag = sender.tag - 100
        let addressLabelTag = sender.tag - 100
        // Find address label from button's parent container view
        if let containerView = sender.superview,
           let addressLabel = containerView.viewWithTag(addressLabelTag) as? UILabel,
           let address = addressLabel.text, address != "-" {
            UIPasteboard.general.string = address
            showToast(message: "Address copied")
        }
    }
    
    @objc private func copyAllWalletDataTapped() {
        // Check if wallet data exists
        guard let mnemonic = mnemonicDisplayLabel.text, mnemonic != "-",
              let privateKey = privateKeyDisplayLabel.text, privateKey != "-",
              let publicKey = publicKeyDisplayLabel.text, publicKey != "-" else {
            showToast(message: "Please generate wallet first")
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
            "mnemonicLength": selectedMnemonicLength,
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
        
        // Print JSON string (for debugging)
        print(jsonString)
        print("===================")
    }
    
    private func showToast(message: String) {
        // TODO: Implement Toast notification
        print("Toast: \(message)")
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true)
        }
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource
extension GenerateWalletViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // Distinguish between length picker and language picker based on pickerView tag
        if pickerView.tag == 1000 {
            return mnemonicLengthOptions.count
        } else if pickerView.tag == 2000 {
            return mnemonicLanguageOptions.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Distinguish between length picker and language picker based on pickerView tag
        if pickerView.tag == 1000 {
            return mnemonicLengthOptions[row].title
        } else if pickerView.tag == 2000 {
            return mnemonicLanguageOptions[row].title
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Distinguish between length picker and language picker based on pickerView tag
        if pickerView.tag == 1000 {
            let selected = mnemonicLengthOptions[row]
            selectedMnemonicLength = selected.value
            mnemonicLengthTextField.text = selected.title
            print("Selected mnemonic length: \(selected.value) bits (\(selected.title))")
        } else if pickerView.tag == 2000 {
            let selected = mnemonicLanguageOptions[row]
            selectedMnemonicLanguage = selected.value
            mnemonicLanguageTextField.text = selected.title
            print("Selected mnemonic language: \(selected.value) (\(selected.title))")
        }
    }
}

