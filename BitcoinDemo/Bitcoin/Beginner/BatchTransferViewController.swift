//
//  BatchTransferViewController.swift
//  Bitcoin
//
//  Created on 2026/1/11.
//

import UIKit
import SnapKit
import SafariServices
import Bitcoin_alpha
class BatchTransferViewController: UIViewController {
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
        label.text = "Sender Private Key"
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
    
    // MARK: - From Address Section
    private lazy var fromAddressSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Sender Address"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var fromAddressHintLabel: UILabel = {
        let label = UILabel()
        label.text = "If not filled, Segwit address will be automatically derived from private key"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var fromAddressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter sender address (optional)"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    // MARK: - Recipients Section
    private lazy var recipientsSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Recipients List"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var recipientsHintLabel: UILabel = {
        let label = UILabel()
        label.text = "Format: address,satoshis - one per line"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var recipientsTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        textView.backgroundColor = .systemBackground
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.separator.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.keyboardType = .default
        textView.text = "tb1q...,1000\ntb1p...,2000"
        return textView
    }()
    
    // MARK: - Fee Section
    private lazy var feeSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Fee"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var feeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var feeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0.00001"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.font = .systemFont(ofSize: 16, weight: .medium)
        textField.keyboardType = .decimalPad
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var feeUnitLabel: UILabel = {
        let label = UILabel()
        label.text = "BTC"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
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
    
    // MARK: - Create Button
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Execute Batch Transfer", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
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
        label.text = "Transaction ID:"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var txidValueLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var copyTxidButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Copy Transaction ID", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(copyTxidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var viewTxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View Transaction", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(viewTxTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Data
    private var transactionTxid: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDefaultValues()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        title = "Batch Transfer"
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Network Selection
        contentView.addSubview(networkSectionLabel)
        contentView.addSubview(networkSegmentedControl)
        
        // Private Key
        contentView.addSubview(privateKeySectionLabel)
        contentView.addSubview(privateKeyTextField)
        
        // From Address
        contentView.addSubview(fromAddressSectionLabel)
        contentView.addSubview(fromAddressHintLabel)
        contentView.addSubview(fromAddressTextField)
        
        // Recipients
        contentView.addSubview(recipientsSectionLabel)
        contentView.addSubview(recipientsHintLabel)
        contentView.addSubview(recipientsTextView)
        
        // Fee
        contentView.addSubview(feeSectionLabel)
        contentView.addSubview(feeStackView)
        feeStackView.addArrangedSubview(feeTextField)
        feeStackView.addArrangedSubview(feeUnitLabel)
        contentView.addSubview(estimateFeeButton)
        contentView.addSubview(estimatedFeeLabel)
        
        // Create Button
        contentView.addSubview(createButton)
        
        // Results Section
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
        
        // From Address
        fromAddressSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(privateKeyTextField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        fromAddressHintLabel.snp.makeConstraints { make in
            make.top.equalTo(fromAddressSectionLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        fromAddressTextField.snp.makeConstraints { make in
            make.top.equalTo(fromAddressHintLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // Recipients
        recipientsSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(fromAddressTextField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        recipientsHintLabel.snp.makeConstraints { make in
            make.top.equalTo(recipientsSectionLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        recipientsTextView.snp.makeConstraints { make in
            make.top.equalTo(recipientsHintLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }
        
        // Fee
        feeSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(recipientsTextView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        feeStackView.snp.makeConstraints { make in
            make.top.equalTo(feeSectionLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(20)
            make.trailing.lessThanOrEqualToSuperview().inset(20)
        }
        
        feeTextField.snp.makeConstraints { make in
            make.width.equalTo(200)
        }
        
        estimateFeeButton.snp.makeConstraints { make in
            make.top.equalTo(feeStackView.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(20)
        }
        
        estimatedFeeLabel.snp.makeConstraints { make in
            make.top.equalTo(estimateFeeButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Create Button
        createButton.snp.makeConstraints { make in
            make.top.equalTo(estimatedFeeLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        // Results Section
        resultsSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(createButton.snp.bottom).offset(30)
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
            make.top.equalTo(txidValueLabel.snp.bottom).offset(20)
            make.leading.equalTo(copyTxidButton.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(copyTxidButton.snp.width)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setupDefaultValues() {
        // Set default fee
        feeTextField.text = "0.00001"
    }
    
    // MARK: - Actions
    
    @objc private func createButtonTapped() {
        // Validate input
        guard let privKeyHex = privateKeyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !privKeyHex.isEmpty else {
            showAlert(title: "Error", message: "Please enter private key")
            return
        }
        
        // Validate sender address (for querying UTXO and as change address)
        guard let fromAddress = fromAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !fromAddress.isEmpty else {
            showAlert(title: "Error", message: "Please enter sender address (for UTXO query and as change address)")
            return
        }
        
        // Parse recipient list
        guard let recipientsText = recipientsTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !recipientsText.isEmpty else {
            showAlert(title: "Error", message: "Please enter recipients list")
            return
        }
        
        // Parse address and amount (format: address,satoshis - one per line)
        var validRecipients: [[String: Any]] = []
        let lines = recipientsText.components(separatedBy: .newlines)
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedLine.isEmpty { continue }
            
            let parts = trimmedLine.components(separatedBy: ",")
            guard parts.count >= 2 else { continue }
            
            let address = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let amountStr = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard !address.isEmpty, let amountSats = Int64(amountStr), amountSats > 0 else { continue }
            
            validRecipients.append([
                "address": address,
                "value": amountSats
            ])
        }
        
        guard !validRecipients.isEmpty else {
            showAlert(title: "Error", message: "Parse failed, please check format (address,satoshis - one per line)")
            return
        }
        
        guard let feeText = feeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !feeText.isEmpty,
              let feeBTC = Double(feeText),
              feeBTC > 0 else {
            showAlert(title: "Error", message: "Please enter a valid fee")
            return
        }
        
        // Convert to satoshis
        let feeSats = Int64(feeBTC * 100_000_000)
        
        // Show loading state
        createButton.isEnabled = false
        createButton.setTitle("Transferring...", for: .normal)
        resultsContainer.isHidden = true
        transactionTxid = nil
        
        let isTestnet = networkSegmentedControl.selectedSegmentIndex == 1
        
        // Use async/await for concurrent execution
        Task {
            await performBatchTransfer(privKeyHex: privKeyHex, validRecipients: validRecipients, feeSats: feeSats, isTestnet: isTestnet, fromAddress: fromAddress)
        }
    }
    
    // MARK: - Async/Await Implementation
    @available(iOS 13.0, *)
    private func performBatchTransfer(privKeyHex: String, validRecipients: [[String: Any]], feeSats: Int64, isTestnet: Bool, fromAddress: String) async {
        // Ensure Bitcoin is initialized
        if !bitcoin.isSuccess {
            await withCheckedContinuation { continuation in
                bitcoin.setup(showLog: true) { _ in
                    continuation.resume()
                }
            }
        }
        
        // Call batch transfer using async/await
        let (success, result, errorMessage) = await bitcoin.batchTransfer(
            outputs: validRecipients,
            feeSats: feeSats,
            privKeyHex: privKeyHex,
            isTestnet: isTestnet,
            fromAddress: fromAddress
        )
        
        // Update UI on main thread
        await MainActor.run {
            self.createButton.isEnabled = true
            self.createButton.setTitle("Execute Batch Transfer", for: .normal)
            
            if success, let result = result {
                self.updateResults(with: result.txid)
            } else {
                self.showAlert(title: "Batch Transfer Failed", message: errorMessage ?? "Unknown error")
            }
        }
    }
    
    @objc private func copyTxidTapped() {
        guard let txid = transactionTxid, !txid.isEmpty else {
            showToast(message: "No transaction ID to copy")
            return
        }
        
        UIPasteboard.general.string = txid
        showToast(message: "Transaction ID copied to clipboard")
    }
    
    @objc private func viewTxTapped() {
        guard let txid = transactionTxid, !txid.isEmpty else {
            showToast(message: "No transaction ID to view")
            return
        }
        
        // Select corresponding URL based on network type
        let isTestnet = networkSegmentedControl.selectedSegmentIndex == 1
        let baseURL = isTestnet ? "https://blockstream.info/testnet/tx" : "https://blockstream.info/tx"
        let urlString = "\(baseURL)/\(txid)"
        
        guard let url = URL(string: urlString) else {
            showAlert(title: "Error", message: "Invalid URL")
            return
        }
        
        // Open transaction details page using SFSafariViewController
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemBlue
        present(safariVC, animated: true)
    }
    
    @objc private func estimateFeeTapped() {
        // Parse recipient list to get outputs count
        guard let recipientsText = recipientsTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !recipientsText.isEmpty else {
            showAlert(title: "Error", message: "Please enter recipients list first")
            return
        }
        
        // Parse recipients to count valid outputs
        var outputsCount = 0
        let lines = recipientsText.components(separatedBy: .newlines)
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedLine.isEmpty { continue }
            
            let parts = trimmedLine.components(separatedBy: ",")
            guard parts.count >= 2 else { continue }
            
            let address = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let amountStr = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
            if !address.isEmpty, let amountSats = Int64(amountStr), amountSats > 0 {
                outputsCount += 1
            }
        }
        
        guard outputsCount > 0 else {
            showAlert(title: "Error", message: "No valid recipients found")
            return
        }
        
        // Add 1 for change address
        outputsCount += 1
        
        // Determine address type from fromAddress or default to segwit
        var addressType = "segwit"
        if let fromAddress = fromAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           !fromAddress.isEmpty {
            let addrLower = fromAddress.lowercased()
            if addrLower.hasPrefix("bc1p") || addrLower.hasPrefix("tb1p") {
                addressType = "taproot"
            } else if addrLower.hasPrefix("bc1q") || addrLower.hasPrefix("tb1q") {
                addressType = "segwit"
            } else if addrLower.hasPrefix("bc1") || addrLower.hasPrefix("tb1") {
                addressType = "segwit"
            } else if fromAddress.hasPrefix("1") || fromAddress.hasPrefix("3") ||
                      fromAddress.hasPrefix("m") || fromAddress.hasPrefix("n") || fromAddress.hasPrefix("2") {
                addressType = "legacy"
            }
        }
        
        // Estimate inputs count (default to 1, can be adjusted based on outputs)
        // For batch transfer, we typically need at least 1 input, but might need more
        // For simplicity, we use 1 input as default (actual UTXO count will be determined during transfer)
        let inputsCount = 1
        
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
                self.showAlert(title: "Fee Estimation Failed", message: errorMessage ?? "Unknown error")
            }
        }
    }
    
    @MainActor
    private func updateResults(with txid: String) {
        transactionTxid = txid
        
        self.txidValueLabel.text = txid
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
        print("Toast: \(message)")
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true)
        }
    }
}




