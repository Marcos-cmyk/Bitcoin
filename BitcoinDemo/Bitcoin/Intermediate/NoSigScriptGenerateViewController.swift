//
//  NoSigScriptGenerateViewController.swift
//  Bitcoin
//
//  Created on 2026/1/11.
//

import UIKit
import SnapKit

class NoSigScriptGenerateViewController: UIViewController {
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
    
    // MARK: - Lock Height Input
    private lazy var lockHeightSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Lock Height"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var lockHeightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter lock height"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.keyboardType = .numberPad
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    // MARK: - Secret Hex Input
    private lazy var secretSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Secret Preimage"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var secretTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter secret preimage (HEX format)"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var secretHintLabel: UILabel = {
        let label = UILabel()
        label.text = "Tip: Secret preimage must be an even-length hexadecimal string"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Warning Label
    private lazy var warningContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.1)
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemOrange.cgColor
        return view
    }()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.text = "⚠️ Important: No-sig script means anyone who knows the preimage can spend the funds. Please ensure the preimage remains secret until unlock conditions are met."
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .systemOrange
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Generate Button
    private lazy var generateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Generate No-Sig Script Address", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Results Section
    private lazy var resultsSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Generated No-Sig Script Address"
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
    
    private lazy var addressInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "P2WSH Address:"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var addressDisplayLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemOrange
        label.numberOfLines = 0
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
    
    private lazy var redeemScriptInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Redeem Script:"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var redeemScriptTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 8
        textView.isEditable = false
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return textView
    }()
    
    private lazy var copyRedeemScriptButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Copy Redeem Script", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(copyRedeemScriptTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "💡 When unlocking, only provide preimage and redeem script, no signature required"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var copyAllDataButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Copy All JSON", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        button.addTarget(self, action: #selector(copyAllDataTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Data
    private var noSigScriptResult: HTLCAddressResult_V1?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDefaultValues()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        title = "No-Sig Script Address Generation"
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Network Selection
        contentView.addSubview(networkSectionLabel)
        contentView.addSubview(networkSegmentedControl)
        
        // Lock Height Input
        contentView.addSubview(lockHeightSectionLabel)
        contentView.addSubview(lockHeightTextField)
        
        // Secret Hex Input
        contentView.addSubview(secretSectionLabel)
        contentView.addSubview(secretTextField)
        contentView.addSubview(secretHintLabel)
        
        // Warning
        contentView.addSubview(warningContainer)
        warningContainer.addSubview(warningLabel)
        
        // Generate Button
        contentView.addSubview(generateButton)
        
        // Results Section
        contentView.addSubview(resultsSectionLabel)
        contentView.addSubview(resultsContainer)
        resultsContainer.addSubview(addressInfoLabel)
        resultsContainer.addSubview(addressDisplayLabel)
        resultsContainer.addSubview(copyAddressButton)
        resultsContainer.addSubview(redeemScriptInfoLabel)
        resultsContainer.addSubview(redeemScriptTextView)
        resultsContainer.addSubview(copyRedeemScriptButton)
        resultsContainer.addSubview(infoLabel)
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
        
        // Lock Height Input
        lockHeightSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(networkSegmentedControl.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        lockHeightTextField.snp.makeConstraints { make in
            make.top.equalTo(lockHeightSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // Secret Hex Input
        secretSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(lockHeightTextField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        secretTextField.snp.makeConstraints { make in
            make.top.equalTo(secretSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        secretHintLabel.snp.makeConstraints { make in
            make.top.equalTo(secretTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Warning
        warningContainer.snp.makeConstraints { make in
            make.top.equalTo(secretHintLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        // Generate Button
        generateButton.snp.makeConstraints { make in
            make.top.equalTo(warningContainer.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        // Results Section
        resultsSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(generateButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        resultsContainer.snp.makeConstraints { make in
            make.top.equalTo(resultsSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        addressInfoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        addressDisplayLabel.snp.makeConstraints { make in
            make.top.equalTo(addressInfoLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        copyAddressButton.snp.makeConstraints { make in
            make.top.equalTo(addressDisplayLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        redeemScriptInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(copyAddressButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        redeemScriptTextView.snp.makeConstraints { make in
            make.top.equalTo(redeemScriptInfoLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }
        
        copyRedeemScriptButton.snp.makeConstraints { make in
            make.top.equalTo(redeemScriptTextView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(copyRedeemScriptButton.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        copyAllDataButton.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setupDefaultValues() {
        // Set default values
        lockHeightTextField.text = "2542622"
        secretTextField.text = "6d79536563726574"
    }
    
    // MARK: - Actions
    
    @objc private func generateButtonTapped() {
        // Validate input
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
        
        // Show loading state
        generateButton.isEnabled = false
        generateButton.setTitle("Generating...", for: .normal)
        resultsContainer.isHidden = true
        noSigScriptResult = nil
        
        let isTestnet = networkSegmentedControl.selectedSegmentIndex == 1
        
        // Use async/await for concurrent execution
        Task {
            await performGenerateNoSigScriptAddress(lockHeight: lockHeight, secretHex: secretHex, isTestnet: isTestnet)
        }
    }
    
    // MARK: - Async/Await Implementation
    @available(iOS 13.0, *)
    private func performGenerateNoSigScriptAddress(lockHeight: Int, secretHex: String, isTestnet: Bool) async {
        // Ensure Bitcoin is initialized
        if !bitcoin.isSuccess {
            await withCheckedContinuation { continuation in
                bitcoin.setup(showLog: true) { _ in
                    continuation.resume()
                }
            }
        }
        
        // Call generate no-signature script address method using async/await
        let (success, result, errorMessage) = await bitcoin.generateNoSigScriptAddress(
            lockHeight: lockHeight,
            secretHex: secretHex,
            isTestnet: isTestnet
        )
        
        // Update UI on main thread
        await MainActor.run {
            self.generateButton.isEnabled = true
            self.generateButton.setTitle("Generate No-Sig Script Address", for: .normal)
            
            if success, let result = result {
                self.updateResults(with: result)
            } else {
                self.showAlert(title: "Generation Failed", message: errorMessage ?? "Unknown error")
            }
        }
    }
    
    @objc private func copyAddressTapped() {
        guard let address = noSigScriptResult?.address, !address.isEmpty else {
            showToast(message: "No address to copy")
            return
        }
        
        UIPasteboard.general.string = address
        showToast(message: "Address copied to clipboard")
    }
    
    @objc private func copyRedeemScriptTapped() {
        guard let redeemScript = noSigScriptResult?.redeemScript, !redeemScript.isEmpty else {
            showToast(message: "No redeem script to copy")
            return
        }
        
        UIPasteboard.general.string = redeemScript
        showToast(message: "Redeem script copied to clipboard")
    }
    
    @objc private func copyAllDataTapped() {
        guard let result = noSigScriptResult,
              let jsonString = result.toJSONString() else {
            showToast(message: "No data to copy")
            return
        }
        
        UIPasteboard.general.string = jsonString
        showToast(message: "All data copied to clipboard")
    }
    
    @MainActor
    private func updateResults(with result: HTLCAddressResult_V1) {
        noSigScriptResult = result
        
        self.addressDisplayLabel.text = result.address
        self.redeemScriptTextView.text = result.redeemScript
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

