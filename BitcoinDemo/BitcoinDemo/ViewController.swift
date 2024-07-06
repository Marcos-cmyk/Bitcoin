//
//  ViewController.swift
//  BitcoinDemo
//
//  Created by Marcos-cmyk on 2024/7/4.
//

import SafariServices
import UIKit

enum OperationType: String, CaseIterable {
    case createAccount
    case importAccountFromMnemonic
    case importAccountFromPrivateKey
    case btcTransfer
    case estimateFee
    case getBTCBalance
    
}
class ViewController: UIViewController {
    lazy var operationTypes: [OperationType] = OperationType.allCases
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        setupNav()
        setupContent()
    }

    func setupNav() {
        title = "Home"
    }

    func setupContent() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let operationType = operationTypes[indexPath.row]
        switch operationType {
        case .createAccount:
            navigationController?.pushViewController(CreateAccountViewController(), animated: true)
        case .importAccountFromMnemonic:
            navigationController?.pushViewController(ImportAccountFromMnemonicViewController(), animated: true)
        case .importAccountFromPrivateKey:
            navigationController?.pushViewController(ImportAccountFromPrivateKeyViewController(), animated: true)
        case .btcTransfer:
            let vc = TransferViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .getBTCBalance:
            let vc = GetBalanceViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .estimateFee:
            let vc = FeeEstimateViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operationTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        let title = operationTypes[indexPath.row].rawValue
        cell.textLabel?.text = title
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

   
}

extension UIViewController {
    
    func showSafariVC(for url: String) {
        guard let url = URL(string: url) else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
}
