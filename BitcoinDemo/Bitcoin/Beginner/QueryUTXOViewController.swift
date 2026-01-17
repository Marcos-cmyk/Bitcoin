//
//  QueryUTXOViewController.swift
//  Bitcoin
//
//  Created on 2026/1/11.
//

import UIKit
import SnapKit

// MARK: - UTXO Model
struct UTXOInfo {
    let txHash: String
    let index: Int
    let value: Int64 // In satoshis
    
    var valueInBTC: Double {
        return Double(value) / 100_000_000.0
    }
}

class QueryUTXOViewController: UIViewController {
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
    
    // MARK: - Address Input Section
    private lazy var addressSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Query Address"
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
        return textField
    }()
    
    // MARK: - Query Button
    private lazy var queryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Query UTXO", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(queryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Results Section
    private lazy var resultsSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Query Result"
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
    
    private lazy var totalBalanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Total Balance: 0 BTC"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var utxoCountLabel: UILabel = {
        let label = UILabel()
        label.text = "UTXO Count: 0"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var utxoTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.register(UTXOCell.self, forCellReuseIdentifier: "UTXOCell")
        return tableView
    }()
    
    // MARK: - Data
    private var utxos: [UTXOInfo] = []
    private var totalBalance: Int64 = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        title = "UTXO Query"
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Network Selection
        contentView.addSubview(networkSectionLabel)
        contentView.addSubview(networkStackView)
        networkStackView.addArrangedSubview(networkLabel)
        networkStackView.addArrangedSubview(networkSegmentedControl)
        
        // Address Input
        contentView.addSubview(addressSectionLabel)
        contentView.addSubview(addressTextField)
        
        // Query Button
        contentView.addSubview(queryButton)
        
        // Results Section
        contentView.addSubview(resultsSectionLabel)
        contentView.addSubview(resultsContainer)
        resultsContainer.addSubview(totalBalanceLabel)
        resultsContainer.addSubview(utxoCountLabel)
        resultsContainer.addSubview(utxoTableView)
        
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
        
        networkStackView.snp.makeConstraints { make in
            make.top.equalTo(networkSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // Address Input
        addressSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(networkStackView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        addressTextField.snp.makeConstraints { make in
            make.top.equalTo(addressSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // Query Button
        queryButton.snp.makeConstraints { make in
            make.top.equalTo(addressTextField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        // Results Section
        resultsSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(queryButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        resultsContainer.snp.makeConstraints { make in
            make.top.equalTo(resultsSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        totalBalanceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        utxoCountLabel.snp.makeConstraints { make in
            make.top.equalTo(totalBalanceLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        utxoTableView.snp.makeConstraints { make in
            make.top.equalTo(utxoCountLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(100).priority(.low) // Minimum height
        }
    }
    
    // MARK: - Actions
    @objc private func networkChanged(_ sender: UISegmentedControl) {
        let isTestnet = sender.selectedSegmentIndex == 1
        print("Network changed to: \(isTestnet ? "Testnet" : "Mainnet")")
    }
    
    @objc private func queryButtonTapped() {
        guard let address = addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !address.isEmpty else {
            showAlert(title: "Error", message: "Please enter Bitcoin address")
            return
        }
        
        // Simple address format validation
        let addressLower = address.lowercased()
        let isValidAddress = addressLower.hasPrefix("bc1") || 
                            addressLower.hasPrefix("tb1") || 
                            addressLower.hasPrefix("1") || 
                            addressLower.hasPrefix("3") ||
                            addressLower.hasPrefix("m") ||
                            addressLower.hasPrefix("n") ||
                            addressLower.hasPrefix("2")
        
        if !isValidAddress {
            showAlert(title: "Error", message: "Please enter a valid Bitcoin address")
            return
        }
        
        // Validate if address matches selected network type
        let isTestnet = networkSegmentedControl.selectedSegmentIndex == 1
        let addressIsTestnet = addressLower.hasPrefix("tb1") || 
                               addressLower.hasPrefix("m") || 
                               addressLower.hasPrefix("n") || 
                               addressLower.hasPrefix("2")
        let addressIsMainnet = addressLower.hasPrefix("bc1") || 
                               addressLower.hasPrefix("1") || 
                               addressLower.hasPrefix("3")
        
        // If address clearly points to a network but user selected a different network, show error
        if addressIsTestnet && !isTestnet {
            showAlert(title: "Network Mismatch", message: "This is a testnet address (starts with tb1/m/n/2), but you selected mainnet. Please switch to testnet and try again.")
            return
        } else if addressIsMainnet && isTestnet {
            showAlert(title: "Network Mismatch", message: "This is a mainnet address (starts with bc1/1/3), but you selected testnet. Please switch to mainnet and try again.")
            return
        }
        
        // Show loading state
        queryButton.isEnabled = false
        queryButton.setTitle("Querying...", for: .normal)
        
        // Use async/await for concurrent execution
        Task {
            await queryUTXOs(address: address, isTestnet: isTestnet)
        }
    }
    
    // MARK: - Async/Await Implementation
    @available(iOS 13.0, *)
    private func queryUTXOs(address: String, isTestnet: Bool) async {
        // Ensure Bitcoin is initialized
        if !bitcoin.isSuccess {
            await withCheckedContinuation { continuation in
                bitcoin.setup(showLog: true) { _ in
                    continuation.resume()
                }
            }
        }
        
        // Query UTXO using async/await
        let (success, utxos, error) = await bitcoin.queryUTXO(address: address, isTestnet: isTestnet)
        
        // Update UI on main thread
        await MainActor.run {
            // Restore button state
            self.queryButton.isEnabled = true
            self.queryButton.setTitle("Query UTXO", for: .normal)
            
            if success, let utxos = utxos {
                // Success: Convert UTXO data to model and update UI
                let utxoInfos = utxos.compactMap { dict -> UTXOInfo? in
                    guard let txHash = dict["txHash"] as? String,
                          let indexValue = dict["index"] as? NSNumber,
                          let valueNumber = dict["value"] as? NSNumber else {
                        return nil
                    }
                    let index = indexValue.intValue
                    let value = valueNumber.int64Value
                    return UTXOInfo(txHash: txHash, index: index, value: value)
                }
                
                self.updateResults(with: utxoInfos)
                if utxoInfos.isEmpty {
                    self.showToast(message: "This address has no UTXO")
                } else {
                    self.showToast(message: "Query successful, found \(utxoInfos.count) UTXO(s)")
                }
            } else {
                // Failure: Display error message
                let errorMessage = error ?? "Unknown error"
                self.showToast(message: "Query failed: \(errorMessage)")
            }
        }
    }
    
    @MainActor
    private func updateResults(with utxos: [UTXOInfo]) {
        self.utxos = utxos
        self.totalBalance = utxos.reduce(0) { $0 + $1.value }
        
        self.totalBalanceLabel.text = String(format: "Total Balance: %.8f BTC", Double(self.totalBalance) / 100_000_000.0)
        self.utxoCountLabel.text = "UTXO Count: \(utxos.count)"
        
        self.utxoTableView.reloadData()
        
        // Use remakeConstraints to update height constraint, avoid constraint not existing issue
        let tableViewHeight = min(CGFloat(utxos.count) * 80, 400)
        self.utxoTableView.snp.remakeConstraints { make in
            make.top.equalTo(self.utxoCountLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(tableViewHeight)
        }
        
        self.resultsContainer.isHidden = false
        
        // Force layout update
        self.view.layoutIfNeeded()
        
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

// MARK: - UITableViewDataSource & UITableViewDelegate
extension QueryUTXOViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return utxos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UTXOCell", for: indexPath) as! UTXOCell
        let utxo = utxos[indexPath.row]
        cell.configure(with: utxo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let utxo = utxos[indexPath.row]
        
        // Copy transaction hash to clipboard
        UIPasteboard.general.string = utxo.txHash
        showToast(message: "Transaction hash copied")
    }
}

// MARK: - UTXOCell
class UTXOCell: UITableViewCell {
    private let txHashLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    private let indexLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .systemGreen
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(txHashLabel)
        contentView.addSubview(indexLabel)
        contentView.addSubview(valueLabel)
        
        txHashLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(valueLabel.snp.leading).offset(-16)
        }
        
        indexLabel.snp.makeConstraints { make in
            make.top.equalTo(txHashLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(16)
            make.width.greaterThanOrEqualTo(100)
        }
    }
    
    func configure(with utxo: UTXOInfo) {
        txHashLabel.text = "TxHash: \(utxo.txHash)"
        indexLabel.text = "Index: \(utxo.index)"
        valueLabel.text = String(format: "%.8f BTC", utxo.valueInBTC)
    }
}

