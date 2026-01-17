//
//  HTLCUnlockViewController.swift
//  Bitcoin
//
//  Created on 2026/1/11.
//

import UIKit
import SnapKit
import SafariServices

class HTLCUnlockViewController: UIViewController {
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
    
    // MARK: - HTLC Address Section
    private lazy var htlcAddressSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "HTLC Source Address"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var htlcAddressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter HTLC source address (P2WSH)"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    // MARK: - Redeem Script Section
    private lazy var redeemScriptSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Redeem Script"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var redeemScriptTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        textView.backgroundColor = .systemBackground
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.separator.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        return textView
    }()
    
    // MARK: - Lock Height and Secret Section
    private lazy var lockHeightSecretStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var lockHeightContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var lockHeightLabel: UILabel = {
        let label = UILabel()
        label.text = "Lock Height"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var lockHeightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Lock height"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.keyboardType = .numberPad
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var secretContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var secretLabel: UILabel = {
        let label = UILabel()
        label.text = "Secret Preimage"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var secretTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Secret preimage (HEX)"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    // MARK: - Private Key Section
    private lazy var privateKeySectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Owner Private Key"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var privateKeyTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter private key (HEX format)"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = true
        return textField
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
    
    // MARK: - Amount Section
    private lazy var amountSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Transfer Amount"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var amountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0.0"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.font = .systemFont(ofSize: 16, weight: .medium)
        textField.keyboardType = .decimalPad
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var amountUnitLabel: UILabel = {
        let label = UILabel()
        label.text = "BTC"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Fee Section
    private lazy var feeSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Fee"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var feeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.font = .systemFont(ofSize: 16, weight: .medium)
        textField.keyboardType = .numberPad
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var feeUnitLabel: UILabel = {
        let label = UILabel()
        label.text = "Sats"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        return label
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
    
    // MARK: - Unlock Button
    private lazy var unlockButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Unlock and Broadcast", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(unlockButtonTapped), for: .touchUpInside)
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
    
    private lazy var txidLabel: UILabel = {
        let label = UILabel()
        label.text = "Transaction ID (TXID):"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var txidValueLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemPurple
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
        button.setTitle("View Transaction", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(viewTxTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Data
    private var unlockResult: HTLCUnlockResult_V1?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDefaultValues()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        title = "HTLC Unlock & Transfer"
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Network Selection
        contentView.addSubview(networkSectionLabel)
        contentView.addSubview(networkSegmentedControl)
        
        // HTLC Address
        contentView.addSubview(htlcAddressSectionLabel)
        contentView.addSubview(htlcAddressTextField)
        
        // Redeem Script
        contentView.addSubview(redeemScriptSectionLabel)
        contentView.addSubview(redeemScriptTextView)
        
        // Lock Height and Secret
        contentView.addSubview(lockHeightSecretStackView)
        lockHeightSecretStackView.addArrangedSubview(lockHeightContainer)
        lockHeightSecretStackView.addArrangedSubview(secretContainer)
        
        lockHeightContainer.addSubview(lockHeightLabel)
        lockHeightContainer.addSubview(lockHeightTextField)
        
        secretContainer.addSubview(secretLabel)
        secretContainer.addSubview(secretTextField)
        
        // Private Key
        contentView.addSubview(privateKeySectionLabel)
        contentView.addSubview(privateKeyTextField)
        
        // To Address
        contentView.addSubview(toAddressSectionLabel)
        contentView.addSubview(toAddressTextField)
        
        // Amount
        contentView.addSubview(amountSectionLabel)
        contentView.addSubview(amountStackView)
        amountStackView.addArrangedSubview(amountTextField)
        amountStackView.addArrangedSubview(amountUnitLabel)
        
        // Fee
        contentView.addSubview(feeSectionLabel)
        contentView.addSubview(feeTextField)
        contentView.addSubview(feeUnitLabel)
        contentView.addSubview(estimateFeeButton)
        contentView.addSubview(estimatedFeeLabel)
        
        // Unlock Button
        contentView.addSubview(unlockButton)
        
        // Results
        contentView.addSubview(resultsSectionLabel)
        contentView.addSubview(resultsContainer)
        resultsContainer.addSubview(txidLabel)
        resultsContainer.addSubview(txidValueLabel)
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
        
        // HTLC Address
        htlcAddressSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(networkSegmentedControl.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        htlcAddressTextField.snp.makeConstraints { make in
            make.top.equalTo(htlcAddressSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // Redeem Script
        redeemScriptSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(htlcAddressTextField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        redeemScriptTextView.snp.makeConstraints { make in
            make.top.equalTo(redeemScriptSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        // Lock Height and Secret
        lockHeightSecretStackView.snp.makeConstraints { make in
            make.top.equalTo(redeemScriptTextView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        lockHeightLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        lockHeightTextField.snp.makeConstraints { make in
            make.top.equalTo(lockHeightLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        
        secretLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        secretTextField.snp.makeConstraints { make in
            make.top.equalTo(secretLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        
        // Private Key
        privateKeySectionLabel.snp.makeConstraints { make in
            make.top.equalTo(lockHeightSecretStackView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        privateKeyTextField.snp.makeConstraints { make in
            make.top.equalTo(privateKeySectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // To Address
        toAddressSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(privateKeyTextField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        toAddressTextField.snp.makeConstraints { make in
            make.top.equalTo(toAddressSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // Amount
        amountSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(toAddressTextField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        amountStackView.snp.makeConstraints { make in
            make.top.equalTo(amountSectionLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(20)
            make.trailing.lessThanOrEqualToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        amountTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        // Fee
        feeSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(amountStackView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        feeTextField.snp.makeConstraints { make in
            make.top.equalTo(feeSectionLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        feeUnitLabel.snp.makeConstraints { make in
            make.leading.equalTo(feeTextField.snp.trailing).offset(12)
            make.centerY.equalTo(feeTextField)
        }
        
        estimateFeeButton.snp.makeConstraints { make in
            make.top.equalTo(feeTextField.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(20)
        }
        
        estimatedFeeLabel.snp.makeConstraints { make in
            make.top.equalTo(estimateFeeButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Unlock Button
        unlockButton.snp.makeConstraints { make in
            make.top.equalTo(estimatedFeeLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        // Results
        resultsSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(unlockButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        resultsContainer.snp.makeConstraints { make in
            make.top.equalTo(resultsSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        txidLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        txidValueLabel.snp.makeConstraints { make in
            make.top.equalTo(txidLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        copyTxidButton.snp.makeConstraints { make in
            make.top.equalTo(txidValueLabel.snp.bottom).offset(20)
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
        // Set default values
        lockHeightTextField.text = "4811699"
        secretTextField.text = "6d79536563726574"
        feeTextField.text = "500"
    }
    
    // MARK: - Actions
    
    @objc private func unlockButtonTapped() {
        // Validate input
        guard let htlcAddress = htlcAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !htlcAddress.isEmpty else {
            showAlert(title: "Error", message: "Please enter HTLC source address")
            return
        }
        
        guard let redeemScript = redeemScriptTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !redeemScript.isEmpty else {
            showAlert(title: "Error", message: "Please enter redeem script")
            return
        }
        
        guard let lockHeightText = lockHeightTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !lockHeightText.isEmpty,
              let lockHeight = Int(lockHeightText),
              lockHeight > 0 else {
            showAlert(title: "Error", message: "Please enter a valid lock height")
            return
        }
        
        guard let secretHex = secretTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !secretHex.isEmpty else {
            showAlert(title: "Error", message: "Please enter secret preimage")
            return
        }
        
        guard let privKeyHex = privateKeyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !privKeyHex.isEmpty else {
            showAlert(title: "Error", message: "Please enter private key")
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
        unlockButton.isEnabled = false
        unlockButton.setTitle("Unlocking...", for: .normal)
        resultsContainer.isHidden = true
        unlockResult = nil
        
        let isTestnet = networkSegmentedControl.selectedSegmentIndex == 1
        let amountSats = Int64(amountBTC * 100000000)
        
        // Use async/await for concurrent execution
        Task {
            await performUnlock(htlcAddress: htlcAddress, toAddress: toAddress, amountSats: amountSats, feeSats: feeSats, privKeyHex: privKeyHex, lockHeight: lockHeight, secretHex: secretHex, redeemScript: redeemScript, isTestnet: isTestnet)
        }
    }
    
    // MARK: - Async/Await Implementation
    @available(iOS 13.0, *)
    private func performUnlock(htlcAddress: String, toAddress: String, amountSats: Int64, feeSats: Int64, privKeyHex: String, lockHeight: Int, secretHex: String, redeemScript: String, isTestnet: Bool) async {
        // Ensure Bitcoin is initialized
        if !bitcoin.isSuccess {
            await withCheckedContinuation { continuation in
                bitcoin.setup(showLog: true) { _ in
                    continuation.resume()
                }
            }
        }
        
        // Call unlock HTLC address method using async/await
        let (success, result, errorMessage) = await bitcoin.unlockHtlcAddress(
            htlcAddress: htlcAddress,
            toAddress: toAddress,
            amountSats: amountSats,
            feeSats: feeSats,
            privKeyHex: privKeyHex,
            lockHeight: lockHeight,
            secretHex: secretHex,
            redeemScript: redeemScript,
            isTestnet: isTestnet
        )
        
        // Update UI on main thread
        await MainActor.run {
            self.unlockButton.isEnabled = true
            self.unlockButton.setTitle("Unlock and Broadcast", for: .normal)
            
            if success, let result = result {
                self.updateResults(with: result)
                self.showToast(message: "HTLC unlocked and transferred successfully")
            } else {
                self.showAlert(title: "Unlock Failed", message: errorMessage ?? "Unknown error")
            }
        }
    }
    
    @objc private func copyTxidTapped() {
        guard let txid = unlockResult?.txid, !txid.isEmpty else {
            showToast(message: "No transaction ID to copy")
            return
        }
        
        UIPasteboard.general.string = txid
        showToast(message: "Transaction ID copied to clipboard")
    }
    
    @objc private func viewTxTapped() {
        guard let txid = unlockResult?.txid, !txid.isEmpty else {
            showToast(message: "No transaction to view")
            return
        }
        
        let isTestnet = networkSegmentedControl.selectedSegmentIndex == 1
        let baseURL = isTestnet ? "https://blockstream.info/testnet/tx/" : "https://blockstream.info/tx/"
        guard let url = URL(string: baseURL + txid) else {
            showToast(message: "Invalid transaction ID")
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    @objc private func estimateFeeTapped() {
        // Validate required fields for estimation
        guard let htlcAddress = htlcAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !htlcAddress.isEmpty else {
            showAlert(title: "Error", message: "Please enter HTLC source address first")
            return
        }
        
        guard let toAddress = toAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !toAddress.isEmpty else {
            showAlert(title: "Error", message: "Please enter recipient address first")
            return
        }
        
        // HTLC unlock transaction typically has:
        // - 1 input (HTLC address UTXO)
        // - 1-2 outputs (recipient address + possible change, but usually 1 for full amount transfer)
        let inputsCount = 1
        let outputsCount = 1 // HTLC unlock usually transfers full amount, so 1 output
        
        // HTLC addresses are typically P2WSH (segwit)
        let addressType = "segwit"
        
        let isTestnet = networkSegmentedControl.selectedSegmentIndex == 1
        
        // Show loading state
        estimateFeeButton.isEnabled = false
        estimateFeeButton.setTitle("Estimating...", for: .normal)
        estimatedFeeLabel.isHidden = true
        
        // Use async/await for concurrent execution
        Task {
            await performFeeEstimation(inputsCount: inputsCount, outputsCount: outputsCount, isTestnet: isTestnet, addressType: addressType)
        }
    }
    
    @available(iOS 13.0, *)
    private func performFeeEstimation(inputsCount: Int, outputsCount: Int, isTestnet: Bool, addressType: String) async {
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
            addressType: addressType
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
                """
                
                self.showAlert(title: "Fee Estimation", message: alertMessage)
            } else {
                self.showAlert(title: "Estimation Failed", message: errorMessage ?? "Unknown error")
            }
        }
    }
    
    @MainActor
    private func updateResults(with result: HTLCUnlockResult_V1) {
        unlockResult = result
        
        self.txidValueLabel.text = result.txid
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

