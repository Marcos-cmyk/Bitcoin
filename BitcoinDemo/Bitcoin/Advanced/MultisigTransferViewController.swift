//
//  MultisigTransferViewController.swift
//  Bitcoin
//
//  Created on 2026/1/11.
//

import UIKit
import SnapKit
import SafariServices

class MultisigTransferViewController: UIViewController {
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
    
    // MARK: - Multisig Address Section
    private lazy var multisigAddressSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Multisig Source Address (P2SH/P2WSH)"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var multisigAddressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter multisig address"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    // MARK: - All Pubkeys Section
    private lazy var allPubkeysSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "All Participant Public Keys"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var allPubkeysHintLabel: UILabel = {
        let label = UILabel()
        label.text = "Tip: One public key per line, order must be correct"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var allPubkeysTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        textView.backgroundColor = .systemBackground
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.separator.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        return textView
    }()
    
    // MARK: - Sign Private Keys Section
    private lazy var signPrivKeysSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Signing Private Keys"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var signPrivKeysHintLabel: UILabel = {
        let label = UILabel()
        label.text = "Tip: One private key per line (HEX format), must meet threshold requirement"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var signPrivKeysTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        textView.backgroundColor = .systemBackground
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.separator.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.isSecureTextEntry = true
        return textView
    }()
    
    // MARK: - To Address Section
    private lazy var toAddressSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Recipient Address"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var toAddressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter recipient address"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    // MARK: - Amount and Fee Section
    private lazy var amountFeeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var amountContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = "Amount (BTC)"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0.001"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.keyboardType = .decimalPad
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var feeContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var feeLabel: UILabel = {
        let label = UILabel()
        label.text = "Fee (Satoshi)"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var feeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "3000"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.keyboardType = .numberPad
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var estimateFeeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Estimate Fee", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(estimateFeeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var estimatedFeeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    // MARK: - Transfer Button
    private lazy var transferButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign and Send Multisig Transaction", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(transferButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Results Section
    private lazy var resultsSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Transfer Result"
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
        label.text = "🎉 Multisig transaction sent!"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .systemOrange
        return label
    }()
    
    private lazy var txidInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Transaction Hash (TXID):"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var txidLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemOrange
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var copyTxidButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Copy TXID", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(copyTxidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var viewTxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View Transaction in Browser", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(viewTxTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Data
    private var transferResult: MultisigTransferResult_V1?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDefaultValues()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        title = "Multisig Transfer"
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Network Selection
        contentView.addSubview(networkSectionLabel)
        contentView.addSubview(networkSegmentedControl)
        
        // Multisig Address
        contentView.addSubview(multisigAddressSectionLabel)
        contentView.addSubview(multisigAddressTextField)
        
        // All Pubkeys
        contentView.addSubview(allPubkeysSectionLabel)
        contentView.addSubview(allPubkeysTextView)
        contentView.addSubview(allPubkeysHintLabel)
        
        // Sign Private Keys
        contentView.addSubview(signPrivKeysSectionLabel)
        contentView.addSubview(signPrivKeysTextView)
        contentView.addSubview(signPrivKeysHintLabel)
        
        // To Address
        contentView.addSubview(toAddressSectionLabel)
        contentView.addSubview(toAddressTextField)
        
        // Amount and Fee
        contentView.addSubview(amountFeeStackView)
        amountFeeStackView.addArrangedSubview(amountContainer)
        amountFeeStackView.addArrangedSubview(feeContainer)
        amountContainer.addSubview(amountLabel)
        amountContainer.addSubview(amountTextField)
        feeContainer.addSubview(feeLabel)
        feeContainer.addSubview(feeTextField)
        contentView.addSubview(estimateFeeButton)
        contentView.addSubview(estimatedFeeLabel)
        
        // Transfer Button
        contentView.addSubview(transferButton)
        
        // Results Section
        contentView.addSubview(resultsSectionLabel)
        contentView.addSubview(resultsContainer)
        resultsContainer.addSubview(successLabel)
        resultsContainer.addSubview(txidInfoLabel)
        resultsContainer.addSubview(txidLabel)
        resultsContainer.addSubview(copyTxidButton)
        resultsContainer.addSubview(viewTxButton)
        
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
        
        // Multisig Address
        multisigAddressSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(networkSegmentedControl.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        multisigAddressTextField.snp.makeConstraints { make in
            make.top.equalTo(multisigAddressSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // All Pubkeys
        allPubkeysSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(multisigAddressTextField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        allPubkeysTextView.snp.makeConstraints { make in
            make.top.equalTo(allPubkeysSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        allPubkeysHintLabel.snp.makeConstraints { make in
            make.top.equalTo(allPubkeysTextView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Sign Private Keys
        signPrivKeysSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(allPubkeysHintLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        signPrivKeysTextView.snp.makeConstraints { make in
            make.top.equalTo(signPrivKeysSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        signPrivKeysHintLabel.snp.makeConstraints { make in
            make.top.equalTo(signPrivKeysTextView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // To Address
        toAddressSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(signPrivKeysHintLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        toAddressTextField.snp.makeConstraints { make in
            make.top.equalTo(toAddressSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // Amount and Fee
        amountFeeStackView.snp.makeConstraints { make in
            make.top.equalTo(toAddressTextField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        
        feeLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        feeTextField.snp.makeConstraints { make in
            make.top.equalTo(feeLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        
        // Ensure both containers have the same height
        amountContainer.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(72) // label(~20) + 8 spacing + textField(44) = 72
        }
        
        feeContainer.snp.makeConstraints { make in
            make.height.equalTo(amountContainer)
        }
        
        estimateFeeButton.snp.makeConstraints { make in
            make.top.equalTo(amountFeeStackView.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(20)
        }
        
        estimatedFeeLabel.snp.makeConstraints { make in
            make.top.equalTo(estimateFeeButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Transfer Button
        transferButton.snp.makeConstraints { make in
            make.top.equalTo(estimatedFeeLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        // Results
        resultsSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(transferButton.snp.bottom).offset(30)
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
        
        txidInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(successLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        txidLabel.snp.makeConstraints { make in
            make.top.equalTo(txidInfoLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        copyTxidButton.snp.makeConstraints { make in
            make.top.equalTo(txidLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        viewTxButton.snp.makeConstraints { make in
            make.top.equalTo(copyTxidButton.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setupDefaultValues() {
        feeTextField.text = "3000"
    }
    
    // MARK: - Actions
    
    @objc private func transferButtonTapped() {
        // Validate input
        guard let multisigAddress = multisigAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !multisigAddress.isEmpty else {
            showAlert(title: "Error", message: "Please enter multisig source address")
            return
        }
        
        guard let allPubkeysText = allPubkeysTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !allPubkeysText.isEmpty else {
            showAlert(title: "Error", message: "Please enter all participant public keys")
            return
        }
        
        // Parse public key list (one per line)
        let allPubkeys = allPubkeysText.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        if allPubkeys.isEmpty {
            showAlert(title: "Error", message: "At least one public key is required")
            return
        }
        
        guard let signPrivKeysText = signPrivKeysTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !signPrivKeysText.isEmpty else {
            showAlert(title: "Error", message: "Please enter signing private keys")
            return
        }
        
        // Parse private key list (one per line)
        let signPrivKeys = signPrivKeysText.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        if signPrivKeys.isEmpty {
            showAlert(title: "Error", message: "At least one private key is required")
            return
        }
        
        guard let toAddress = toAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !toAddress.isEmpty else {
            showAlert(title: "Error", message: "Please enter recipient address")
            return
        }
        
        guard let amountText = amountTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !amountText.isEmpty,
              let amountBTC = Double(amountText),
              amountBTC > 0 else {
            showAlert(title: "Error", message: "Please enter a valid transfer amount")
            return
        }
        
        guard let feeText = feeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !feeText.isEmpty,
              let feeSats = Int64(feeText),
              feeSats > 0 else {
            showAlert(title: "Error", message: "Please enter a valid fee")
            return
        }
        
        // Show loading state
        transferButton.isEnabled = false
        transferButton.setTitle("Signing...", for: .normal)
        resultsContainer.isHidden = true
        transferResult = nil
        
        let isTestnet = networkSegmentedControl.selectedSegmentIndex == 1
        let amountSats = Int64(amountBTC * 100000000)
        
        // Use async/await for concurrent execution
        Task {
            await performTransfer(multisigAddress: multisigAddress, toAddress: toAddress, amountSats: amountSats, feeSats: feeSats, allPubkeys: allPubkeys, signPrivKeys: signPrivKeys, isTestnet: isTestnet)
        }
    }
    
    // MARK: - Async/Await Implementation
    @available(iOS 13.0, *)
    private func performTransfer(multisigAddress: String, toAddress: String, amountSats: Int64, feeSats: Int64, allPubkeys: [String], signPrivKeys: [String], isTestnet: Bool) async {
        // Ensure Bitcoin is initialized
        if !bitcoin.isSuccess {
            await withCheckedContinuation { continuation in
                bitcoin.setup(showLog: true) { _ in
                    continuation.resume()
                }
            }
        }
        
        // Call multisig transfer method using async/await
        let (success, result, errorMessage) = await bitcoin.sendMultisigTransaction(
            multisigAddress: multisigAddress,
            toAddress: toAddress,
            amountSats: amountSats,
            feeSats: feeSats,
            allPubkeys: allPubkeys,
            signPrivKeys: signPrivKeys,
            isTestnet: isTestnet
        )
        
        // Update UI on main thread
        await MainActor.run {
            self.transferButton.isEnabled = true
            self.transferButton.setTitle("Sign and Send Multisig Transaction", for: .normal)
            
            if success, let result = result {
                self.updateResults(with: result)
                self.showToast(message: "Multisig transaction signed and sent successfully")
            } else {
                self.showAlert(title: "Transfer Failed", message: errorMessage ?? "Unknown error")
            }
        }
    }
    
    @objc private func copyTxidTapped() {
        guard let txid = transferResult?.txid, !txid.isEmpty else {
            showToast(message: "No TXID to copy")
            return
        }
        
        UIPasteboard.general.string = txid
        showToast(message: "TXID copied to clipboard")
    }
    
    @objc private func viewTxTapped() {
        guard let txid = transferResult?.txid, !txid.isEmpty else {
            showToast(message: "No transaction to view")
            return
        }
        
        let isTestnet = networkSegmentedControl.selectedSegmentIndex == 1
        let baseURL = isTestnet ? "https://blockstream.info/testnet/tx/" : "https://blockstream.info/tx/"
        let urlString = baseURL + txid
        
        if let url = URL(string: urlString) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        }
    }
    
    @objc private func estimateFeeTapped() {
        // Validate required fields for estimation
        guard let multisigAddress = multisigAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !multisigAddress.isEmpty else {
            showAlert(title: "Error", message: "Please enter multisig source address first")
            return
        }
        
        guard let allPubkeysText = allPubkeysTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !allPubkeysText.isEmpty else {
            showAlert(title: "Error", message: "Please enter all participant public keys first")
            return
        }
        
        guard let toAddress = toAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !toAddress.isEmpty else {
            showAlert(title: "Error", message: "Please enter recipient address first")
            return
        }
        
        // Parse public keys to calculate m (total signers)
        let allPubkeys = allPubkeysText.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        guard !allPubkeys.isEmpty else {
            showAlert(title: "Error", message: "At least one public key is required")
            return
        }
        
        let m = allPubkeys.count // Total number of signers
        
        // Parse signing private keys to estimate n (threshold)
        // Note: The actual threshold might be different, but we use the number of signing keys as an estimate
        var n = 1
        if let signPrivKeysText = signPrivKeysTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           !signPrivKeysText.isEmpty {
            let signPrivKeys = signPrivKeysText.components(separatedBy: .newlines)
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
            if !signPrivKeys.isEmpty {
                n = signPrivKeys.count // Use number of signing keys as threshold estimate
            }
        }
        
        // Ensure n <= m
        if n > m {
            n = m
        }
        
        // Multisig unlock transaction typically has:
        // - 1 input (multisig address UTXO)
        // - 1 output (recipient address, usually full amount transfer)
        let inputsCount = 1
        let outputsCount = 1 // Multisig transfer usually transfers full amount, so 1 output
        
        // Determine address type from multisig address
        // Multisig addresses can be P2SH (starts with 3 or 2) or P2WSH (starts with bc1 or tb1)
        var addressType = "multisig" // Use multisig type for accurate size calculation
        let addrLower = multisigAddress.lowercased()
        if addrLower.hasPrefix("bc1") || addrLower.hasPrefix("tb1") {
            // P2WSH multisig
            addressType = "multisig"
        } else if multisigAddress.hasPrefix("3") || multisigAddress.hasPrefix("2") {
            // P2SH multisig (legacy)
            // Note: For P2SH multisig, we still use "multisig" type as it will calculate correctly
            addressType = "multisig"
        }
        
        let isTestnet = networkSegmentedControl.selectedSegmentIndex == 1
        
        // Show loading state
        estimateFeeButton.isEnabled = false
        estimateFeeButton.setTitle("Estimating...", for: .normal)
        estimatedFeeLabel.isHidden = true
        
        // Use async/await for concurrent execution
        Task {
            await performFeeEstimation(inputsCount: inputsCount, outputsCount: outputsCount, isTestnet: isTestnet, addressType: addressType, n: n, m: m)
        }
    }
    
    @available(iOS 13.0, *)
    private func performFeeEstimation(inputsCount: Int, outputsCount: Int, isTestnet: Bool, addressType: String, n: Int, m: Int) async {
        // Ensure Bitcoin is initialized
        if !bitcoin.isSuccess {
            await withCheckedContinuation { continuation in
                bitcoin.setup(showLog: true) { _ in
                    continuation.resume()
                }
            }
        }
        
        // Estimate fee using async/await
        let (success, result, errorMessage) = await bitcoin.estimateFee(
            inputsCount: inputsCount,
            outputsCount: outputsCount,
            isTestnet: isTestnet,
            addressType: addressType,
            n: n,
            m: m
        )
        
        // Update UI on main thread
        await MainActor.run {
            self.estimateFeeButton.isEnabled = true
            self.estimateFeeButton.setTitle("Estimate Fee", for: .normal)
            
            if success, let result = result {
                // Format fee estimates
                let highBTC = Double(result.high) / 100_000_000.0
                let mediumBTC = Double(result.medium) / 100_000_000.0
                let lowBTC = Double(result.low) / 100_000_000.0
                
                let feeText = String(format: "High: %.8f BTC (%d sats)\nMedium: %.8f BTC (%d sats)\nLow: %.8f BTC (%d sats)\nSize: %d vBytes",
                                    highBTC, result.high,
                                    mediumBTC, result.medium,
                                    lowBTC, result.low,
                                    result.size)
                
                self.estimatedFeeLabel.text = feeText
                self.estimatedFeeLabel.isHidden = false
                
                // Show detailed alert
                let alertMessage = """
                Fee Estimates:
                
                High Priority: \(String(format: "%.8f", highBTC)) BTC (\(result.high) sats)
                Medium Priority: \(String(format: "%.8f", mediumBTC)) BTC (\(result.medium) sats)
                Low Priority: \(String(format: "%.8f", lowBTC)) BTC (\(result.low) sats)
                
                Estimated Transaction Size: \(result.size) vBytes
                
                Inputs: \(inputsCount), Outputs: \(outputsCount)
                Address Type: \(addressType.capitalized)
                Multisig: \(n)-of-\(m)
                """
                
                self.showAlert(title: "Fee Estimation", message: alertMessage)
            } else {
                self.showAlert(title: "Estimation Failed", message: errorMessage ?? "Unknown error")
            }
        }
    }
    
    @MainActor
    private func updateResults(with result: MultisigTransferResult_V1) {
        transferResult = result
        
        self.txidLabel.text = result.txid
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

