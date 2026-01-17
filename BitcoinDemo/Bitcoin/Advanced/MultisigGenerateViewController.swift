//
//  MultisigGenerateViewController.swift
//  Bitcoin
//
//  Created on 2026/1/11.
//

import UIKit
import SnapKit

class MultisigGenerateViewController: UIViewController {
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
    
    // MARK: - Public Keys Input Section
    private lazy var pubkeysSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Participant Public Keys"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var pubkeysTextView: UITextView = {
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
    
    private lazy var pubkeysHintLabel: UILabel = {
        let label = UILabel()
        label.text = "Tip: One public key per line (33-byte compressed key starting with 02 or 03)"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Threshold Input Section
    private lazy var thresholdSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Required Signatures (Threshold N)"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var thresholdTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter threshold number"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.keyboardType = .numberPad
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    // MARK: - Generate Button
    private lazy var generateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Generate Multisig Address", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Results Section
    private lazy var resultsSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Generation Result"
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
    
    private lazy var modeInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Mode: N-of-M"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemPink
        return label
    }()
    
    private lazy var scriptInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Multisig Script:"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var scriptTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 8
        textView.isEditable = false
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return textView
    }()
    
    private lazy var copyScriptButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Copy Script", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(copyScriptTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var p2shInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "P2SH Address (Legacy):"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var p2shAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemPink
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var copyP2shButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Copy P2SH Address", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(copyP2shTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var p2wshInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "P2WSH Address (Segwit):"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var p2wshAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemPink
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var copyP2wshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Copy P2WSH Address", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(copyP2wshTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var copyAllDataButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Copy All Info (JSON)", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(copyAllDataTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Data
    private var multisigResult: MultisigAddressResult_V1?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDefaultValues()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        title = "Multisig Address Generation"
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Network Selection
        contentView.addSubview(networkSectionLabel)
        contentView.addSubview(networkSegmentedControl)
        
        // Public Keys Input
        contentView.addSubview(pubkeysSectionLabel)
        contentView.addSubview(pubkeysTextView)
        contentView.addSubview(pubkeysHintLabel)
        
        // Threshold Input
        contentView.addSubview(thresholdSectionLabel)
        contentView.addSubview(thresholdTextField)
        
        // Generate Button
        contentView.addSubview(generateButton)
        
        // Results Section
        contentView.addSubview(resultsSectionLabel)
        contentView.addSubview(resultsContainer)
        resultsContainer.addSubview(modeInfoLabel)
        resultsContainer.addSubview(scriptInfoLabel)
        resultsContainer.addSubview(scriptTextView)
        resultsContainer.addSubview(copyScriptButton)
        resultsContainer.addSubview(p2shInfoLabel)
        resultsContainer.addSubview(p2shAddressLabel)
        resultsContainer.addSubview(copyP2shButton)
        resultsContainer.addSubview(p2wshInfoLabel)
        resultsContainer.addSubview(p2wshAddressLabel)
        resultsContainer.addSubview(copyP2wshButton)
        resultsContainer.addSubview(copyAllDataButton)
        
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
        
        // Public Keys Input
        pubkeysSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(networkSegmentedControl.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        pubkeysTextView.snp.makeConstraints { make in
            make.top.equalTo(pubkeysSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(120)
        }
        
        pubkeysHintLabel.snp.makeConstraints { make in
            make.top.equalTo(pubkeysTextView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Threshold Input
        thresholdSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(pubkeysHintLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        thresholdTextField.snp.makeConstraints { make in
            make.top.equalTo(thresholdSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // Generate Button
        generateButton.snp.makeConstraints { make in
            make.top.equalTo(thresholdTextField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        // Results
        resultsSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(generateButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        resultsContainer.snp.makeConstraints { make in
            make.top.equalTo(resultsSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        modeInfoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        scriptInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(modeInfoLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        scriptTextView.snp.makeConstraints { make in
            make.top.equalTo(scriptInfoLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        copyScriptButton.snp.makeConstraints { make in
            make.top.equalTo(scriptTextView.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        p2shInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(copyScriptButton.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        p2shAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(p2shInfoLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        copyP2shButton.snp.makeConstraints { make in
            make.top.equalTo(p2shAddressLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        p2wshInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(copyP2shButton.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        p2wshAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(p2wshInfoLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        copyP2wshButton.snp.makeConstraints { make in
            make.top.equalTo(p2wshAddressLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        copyAllDataButton.snp.makeConstraints { make in
            make.top.equalTo(copyP2wshButton.snp.bottom).offset(25)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setupDefaultValues() {
        thresholdTextField.text = "2"
    }
    
    // MARK: - Actions
    
    @objc private func generateButtonTapped() {
        // Validate input
        guard let pubkeysText = pubkeysTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !pubkeysText.isEmpty else {
            showAlert(title: "Error", message: "Please enter public key list")
            return
        }
        
        // Parse public key list (one per line)
        let pubkeys = pubkeysText.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        if pubkeys.isEmpty {
            showAlert(title: "Error", message: "At least one public key is required")
            return
        }
        
        guard let thresholdText = thresholdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !thresholdText.isEmpty,
              let threshold = Int(thresholdText),
              threshold > 0 else {
            showAlert(title: "Error", message: "Please enter a valid threshold number")
            return
        }
        
        if threshold > pubkeys.count {
            showAlert(title: "Error", message: "Threshold cannot be greater than the number of public keys")
            return
        }
        
        // Show loading state
        generateButton.isEnabled = false
        generateButton.setTitle("Generating...", for: .normal)
        resultsContainer.isHidden = true
        multisigResult = nil
        
        let isTestnet = networkSegmentedControl.selectedSegmentIndex == 1
        
        // Use async/await for concurrent execution
        Task {
            await performGenerate(threshold: threshold, pubkeys: pubkeys, isTestnet: isTestnet)
        }
    }
    
    // MARK: - Async/Await Implementation
    @available(iOS 13.0, *)
    private func performGenerate(threshold: Int, pubkeys: [String], isTestnet: Bool) async {
        // Ensure Bitcoin is initialized
        if !bitcoin.isSuccess {
            await withCheckedContinuation { continuation in
                bitcoin.setup(showLog: true) { _ in
                    continuation.resume()
                }
            }
        }
        
        // Call generate multisig address method using async/await
        let (success, result, errorMessage) = await bitcoin.generateMultisigAddress(
            threshold: threshold,
            pubkeys: pubkeys,
            isTestnet: isTestnet
        )
        
        // Update UI on main thread
        await MainActor.run {
            self.generateButton.isEnabled = true
            self.generateButton.setTitle("Generate Multisig Address", for: .normal)
            
            if success, let result = result {
                self.updateResults(with: result)
                self.showToast(message: "Multisig address generated successfully")
            } else {
                self.showAlert(title: "Generation Failed", message: errorMessage ?? "Unknown error")
            }
        }
    }
    
    @objc private func copyScriptTapped() {
        guard let script = multisigResult?.script, !script.isEmpty else {
            showToast(message: "No script to copy")
            return
        }
        
        UIPasteboard.general.string = script
        showToast(message: "Script copied to clipboard")
    }
    
    @objc private func copyP2shTapped() {
        guard let address = multisigResult?.p2shAddress, !address.isEmpty else {
            showToast(message: "No address to copy")
            return
        }
        
        UIPasteboard.general.string = address
        showToast(message: "P2SH address copied to clipboard")
    }
    
    @objc private func copyP2wshTapped() {
        guard let address = multisigResult?.p2wshAddress, !address.isEmpty else {
            showToast(message: "No address to copy")
            return
        }
        
        UIPasteboard.general.string = address
        showToast(message: "P2WSH address copied to clipboard")
    }
    
    @objc private func copyAllDataTapped() {
        guard let result = multisigResult,
              let jsonString = result.toJSONString() else {
            showToast(message: "No data to copy")
            return
        }
        
        UIPasteboard.general.string = jsonString
        showToast(message: "All info copied to clipboard")
    }
    
    @MainActor
    private func updateResults(with result: MultisigAddressResult_V1) {
        multisigResult = result
        
        self.modeInfoLabel.text = "Mode: \(result.threshold)-of-\(result.totalSigners)"
        self.scriptTextView.text = result.script
        self.p2shAddressLabel.text = result.p2shAddress
        self.p2wshAddressLabel.text = result.p2wshAddress
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

