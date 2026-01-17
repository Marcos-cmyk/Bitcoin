//
//  OneClickTransferViewController.swift
//  Bitcoin
//
//  Created on 2026/1/11.
//

import UIKit
import SnapKit
import SafariServices

class OneClickTransferViewController: UIViewController {
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
        label.text = "Sender Address (Optional)"
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
        label.textColor = .label
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
    
    private lazy var feeHintLabel: UILabel = {
        let label = UILabel()
        label.text = "Suggested fee: 0.00001 - 0.0001 BTC (approximately 1000 - 10000 satoshis)"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var estimateFeeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Estimate Fee", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.addTarget(self, action: #selector(estimateFeeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var feeEstimateContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.isHidden = true
        return view
    }()
    
    private lazy var feeEstimateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Estimated Fee (select one to auto-fill)"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var feeEstimateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var lowFeeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Low Fee: - BTC", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGreen.cgColor
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        button.addTarget(self, action: #selector(selectFeeTapped(_:)), for: .touchUpInside)
        button.tag = 0
        return button
    }()
    
    private lazy var mediumFeeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Medium Fee: - BTC", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        button.addTarget(self, action: #selector(selectFeeTapped(_:)), for: .touchUpInside)
        button.tag = 1
        return button
    }()
    
    private lazy var highFeeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("High Fee: - BTC", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        button.addTarget(self, action: #selector(selectFeeTapped(_:)), for: .touchUpInside)
        button.tag = 2
        return button
    }()
    
    // MARK: - Data
    private var feeEstimateResult: FeeEstimateResult_V1?
    
    // MARK: - Transfer Button
    private lazy var transferButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Execute Transfer", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
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
    
    private lazy var txidLabel: UILabel = {
        let label = UILabel()
        label.text = "Transaction ID: -"
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
        title = "One-click Transfer"
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
        contentView.addSubview(feeStackView)
        feeStackView.addArrangedSubview(feeTextField)
        feeStackView.addArrangedSubview(feeUnitLabel)
        contentView.addSubview(feeHintLabel)
        contentView.addSubview(estimateFeeButton)
        contentView.addSubview(feeEstimateContainer)
        feeEstimateContainer.addSubview(feeEstimateTitleLabel)
        feeEstimateContainer.addSubview(feeEstimateStackView)
        feeEstimateStackView.addArrangedSubview(lowFeeButton)
        feeEstimateStackView.addArrangedSubview(mediumFeeButton)
        feeEstimateStackView.addArrangedSubview(highFeeButton)
        
        // Transfer Button
        contentView.addSubview(transferButton)
        
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
        
        // To Address
        toAddressSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(fromAddressTextField.snp.bottom).offset(30)
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
        }
        
        amountTextField.snp.makeConstraints { make in
            make.width.equalTo(200)
        }
        
        // Fee
        feeSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(amountStackView.snp.bottom).offset(30)
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
        
        feeHintLabel.snp.makeConstraints { make in
            make.top.equalTo(feeStackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        estimateFeeButton.snp.makeConstraints { make in
            make.top.equalTo(feeHintLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(20)
        }
        
        feeEstimateContainer.snp.makeConstraints { make in
            make.top.equalTo(estimateFeeButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        feeEstimateTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        feeEstimateStackView.snp.makeConstraints { make in
            make.top.equalTo(feeEstimateTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
        
        lowFeeButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        mediumFeeButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        highFeeButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        // Transfer Button
        transferButton.snp.makeConstraints { make in
            make.top.equalTo(feeEstimateContainer.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        // Results Section
        resultsSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(transferButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        resultsContainer.snp.makeConstraints { make in
            make.top.equalTo(resultsSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        txidLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        txidValueLabel.snp.makeConstraints { make in
            make.top.equalTo(txidLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        copyTxidButton.snp.makeConstraints { make in
            make.top.equalTo(txidValueLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
        
        viewTxButton.snp.makeConstraints { make in
            make.top.equalTo(copyTxidButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    private func setupDefaultValues() {
        // Set default fee (0.00001 BTC = 1000 satoshis)
        feeTextField.text = "0.00001"
    }
    
    // MARK: - Actions
    @objc private func transferButtonTapped() {
        // Validate input
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
              let feeBTC = Double(feeText),
              feeBTC > 0 else {
            showAlert(title: "Error", message: "Please enter a valid fee")
            return
        }
        
        // Convert to satoshis
        let amountSats = Int64(amountBTC * 100_000_000)
        let feeSats = Int64(feeBTC * 100_000_000)
        
        let fromAddress = fromAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let isTestnet = networkSegmentedControl.selectedSegmentIndex == 1
        
        // Show loading state
        transferButton.isEnabled = false
        transferButton.setTitle("Transferring...", for: .normal)
        resultsContainer.isHidden = true
        transactionTxid = nil
        
        // Use async/await for concurrent execution
        Task {
            await performTransfer(privKeyHex: privKeyHex, toAddress: toAddress, amountSats: amountSats, feeSats: feeSats, isTestnet: isTestnet, fromAddress: fromAddress)
        }
    }
    
    // MARK: - Async/Await Implementation
    @available(iOS 13.0, *)
    private func performTransfer(privKeyHex: String, toAddress: String, amountSats: Int64, feeSats: Int64, isTestnet: Bool, fromAddress: String?) async {
        // Ensure Bitcoin is initialized
        if !bitcoin.isSuccess {
            await withCheckedContinuation { continuation in
                bitcoin.setup(showLog: true) { _ in
                    continuation.resume()
                }
            }
        }
        
        // One-click transfer using async/await
        let (success, result, error) = await bitcoin.oneClickTransfer(
            privKeyHex: privKeyHex,
            toAddress: toAddress,
            amountSats: amountSats,
            feeSats: feeSats,
            isTestnet: isTestnet,
            fromAddress: fromAddress
        )
        
        // Update UI on main thread
        await MainActor.run {
            // Restore button state
            self.transferButton.isEnabled = true
            self.transferButton.setTitle("Execute Transfer", for: .normal)
            
            if success, let result = result {
                // Success: Update UI to display transfer result
                self.updateResults(with: result.txid)
            } else {
                // Failure: Display error message
                let errorMessage = error ?? "Unknown error"
                self.showAlert(title: "Transfer Failed", message: errorMessage)
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
        // Validate required information
        guard let toAddress = toAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !toAddress.isEmpty else {
            showAlert(title: "Tip", message: "Please enter recipient address first")
            return
        }
        
        // Get sender address (if any) to determine address type
        let fromAddress = fromAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let isTestnet = networkSegmentedControl.selectedSegmentIndex == 1
        
        // Detect address type (default segwit)
        var addressType = "segwit"
        if let fromAddr = fromAddress, !fromAddr.isEmpty {
            let addrLower = fromAddr.lowercased()
            if addrLower.hasPrefix("bc1p") || addrLower.hasPrefix("tb1p") {
                addressType = "taproot"
            } else if addrLower.hasPrefix("bc1q") || addrLower.hasPrefix("tb1q") || addrLower.hasPrefix("bc1") || addrLower.hasPrefix("tb1") {
                addressType = "segwit"
            } else if fromAddr.hasPrefix("1") || fromAddr.hasPrefix("3") || fromAddr.hasPrefix("m") || fromAddr.hasPrefix("n") || fromAddr.hasPrefix("2") {
                addressType = "legacy"
            }
        }
        
        // Show loading state
        estimateFeeButton.isEnabled = false
        estimateFeeButton.setTitle("Estimating...", for: .normal)
        feeEstimateContainer.isHidden = true
        
        // Use async/await for concurrent execution
        Task {
            await performEstimateFee(isTestnet: isTestnet, addressType: addressType)
        }
    }
    
    @available(iOS 13.0, *)
    private func performEstimateFee(isTestnet: Bool, addressType: String) async {
        // Ensure Bitcoin is initialized
        if !bitcoin.isSuccess {
            await withCheckedContinuation { continuation in
                bitcoin.setup(showLog: true) { _ in
                    continuation.resume()
                }
            }
        }
        
        // Use default values: 1 input, 2 outputs (recipient address + change address)
        let (success, result, error) = await bitcoin.estimateFee(
            inputsCount: 1,
            outputsCount: 2,
            isTestnet: isTestnet,
            addressType: addressType
        )
        
        // Update UI on main thread
        await MainActor.run {
            // Restore button state
            self.estimateFeeButton.isEnabled = true
            self.estimateFeeButton.setTitle("Estimate Fee", for: .normal)
            
            if success, let result = result {
                // Success: Update UI to display estimation result
                self.updateFeeEstimate(with: result)
            } else {
                // Failure: Display error message
                let errorMessage = error ?? "Unknown error"
                self.showAlert(title: "Estimation Failed", message: errorMessage)
            }
        }
    }
    
    @MainActor
    private func updateFeeEstimate(with result: FeeEstimateResult_V1) {
        feeEstimateResult = result
        
        // Update button title
        self.lowFeeButton.setTitle(String(format: "Low Fee: %.8f BTC (~%d satoshis)", result.lowInBTC, result.low), for: .normal)
        self.mediumFeeButton.setTitle(String(format: "Medium Fee: %.8f BTC (~%d satoshis)", result.mediumInBTC, result.medium), for: .normal)
        self.highFeeButton.setTitle(String(format: "High Fee: %.8f BTC (~%d satoshis)", result.highInBTC, result.high), for: .normal)
        
        // Show estimation container
        self.feeEstimateContainer.isHidden = false
        
        // Scroll to estimation area
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
            let rect = self.feeEstimateContainer.frame
            self.scrollView.scrollRectToVisible(rect, animated: true)
        }
    }
    
    @objc private func selectFeeTapped(_ sender: UIButton) {
        guard let result = feeEstimateResult else {
            return
        }
        
        let feeBTC: Double
        switch sender.tag {
        case 0: // Low fee rate
            feeBTC = result.lowInBTC
        case 1: // Medium fee rate
            feeBTC = result.mediumInBTC
        case 2: // High fee rate
            feeBTC = result.highInBTC
        default:
            return
        }
        
        // Auto-fill to fee input field
        feeTextField.text = String(format: "%.8f", feeBTC)
        
        // Show hint
        showToast(message: "Fee selected and filled")
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

