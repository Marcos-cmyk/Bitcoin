//
//  ViewController.swift
//  Bitcoin
//
//  Created by mac on 2026/1/10.
//

import UIKit
import SnapKit
import SafariServices

// MARK: - Feature Model
struct Feature {
    let id: Int
    let title: String
    let subtitle: String
}

// MARK: - ViewController
class ViewController: UIViewController {
    
    // MARK: - Data Model
    private let sections = [
        "🔗 Bitcoin Testnet Faucet",
        "📚 Primary Features",
        "🔧 Intermediate Features",
        "🚀 Advanced Features"
    ]
    
    private let features: [[Feature]] = [
        // Bitcoin Testnet Faucet
        [
            Feature(id: 100, title: "Bitcoin Testnet Faucet", subtitle: "Get Testnet BTC")
        ],
        // Primary Features
        [
            Feature(id: 1, title: "Generate Wallet", subtitle: "Generate New Wallet"),
            Feature(id: 2, title: "Import Wallet", subtitle: "Import Wallet"),
            Feature(id: 3, title: "UTXO Query", subtitle: "UTXO Check"),
            Feature(id: 4, title: "Address Validator", subtitle: "Address Validator"),
            Feature(id: 5, title: "One-click Transfer", subtitle: "One-click Transfer"),
            Feature(id: 12, title: "Batch Transfer", subtitle: "Batch Transfer"),
            Feature(id: 21, title: "Sign Message", subtitle: "BIP322 Sign Message"),
            Feature(id: 22, title: "Verify Message", subtitle: "BIP322 Verify Message")
        ],
        // Intermediate Features
        [
            Feature(id: 7, title: "HTLC: Address Generation", subtitle: "HTLC Address Generation"),
            Feature(id: 8, title: "HTLC: Unlock & Transfer", subtitle: "HTLC Unlock & Transfer"),
            Feature(id: 9, title: "No-Sig Script: Generation", subtitle: "No-Signature Script Generation"),
            Feature(id: 10, title: "No-Sig Script: Unlock", subtitle: "No-Signature Script Unlock")
        ],
        // Advanced Features
        [
            Feature(id: 13, title: "Multisig: Address Generation", subtitle: "N-of-M Multisig Address"),
            Feature(id: 14, title: "Multisig: Transfer", subtitle: "Multisig Transfer")
        ]
    ]
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGroupedBackground
        // No need to register, we manually create in cellForRowAt
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Bitcoin Features"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Use subtitle style to support subtitle display
        let identifier = "FeatureCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        }
        
        guard let cell = cell else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        }
        
        let feature = features[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = feature.title
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        cell.detailTextLabel?.text = feature.subtitle
        cell.detailTextLabel?.font = .systemFont(ofSize: 13, weight: .regular)
        cell.detailTextLabel?.textColor = .secondaryLabel
        
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .default
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let feature = features[indexPath.section][indexPath.row]
        print("Selected: \(feature.title) (ID: \(feature.id))")
        
        // 根据功能 ID 跳转到对应页面
        switch feature.id {
        case 100:
            // Bitcoin Testnet Faucet - 打开测试网水龙头网站
            if let url = URL(string: "https://coinfaucet.eu/en/btc-testnet/") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true)
            }
            
        case 1:
            // WebViewController
            // GenerateWalletViewController
            // 生成钱包 - 跳转到生成钱包页面
            let generateWalletVC = GenerateWalletViewController()
            if let navController = navigationController {
                navController.pushViewController(generateWalletVC, animated: true)
            } else {
                // 如果没有导航控制器，使用 present 方式
                let navController = UINavigationController(rootViewController: generateWalletVC)
                present(navController, animated: true)
            }
            
        case 2:
            // 导入钱包 - 跳转到导入钱包页面
            let importWalletVC = ImportWalletViewController()
            if let navController = navigationController {
                navController.pushViewController(importWalletVC, animated: true)
            } else {
                // 如果没有导航控制器，使用 present 方式
                let navController = UINavigationController(rootViewController: importWalletVC)
                present(navController, animated: true)
            }
            
        case 3:
            // UTXO 资产查询 - 跳转到 UTXO 查询页面
            let queryUTXOVC = QueryUTXOViewController()
            if let navController = navigationController {
                navController.pushViewController(queryUTXOVC, animated: true)
            } else {
                // 如果没有导航控制器，使用 present 方式
                let navController = UINavigationController(rootViewController: queryUTXOVC)
                present(navController, animated: true)
            }
            
        case 4:
            // 地址验证工具 - 跳转到地址验证页面
            let addressValidatorVC = AddressValidatorViewController()
            if let navController = navigationController {
                navController.pushViewController(addressValidatorVC, animated: true)
            } else {
                // 如果没有导航控制器，使用 present 方式
                let navController = UINavigationController(rootViewController: addressValidatorVC)
                present(navController, animated: true)
            }
            
        case 5:
            // 全自动转账 - 跳转到转账页面
            let transferVC = OneClickTransferViewController()
            if let navController = navigationController {
                navController.pushViewController(transferVC, animated: true)
            } else {
                // 如果没有导航控制器，使用 present 方式
                let navController = UINavigationController(rootViewController: transferVC)
                present(navController, animated: true)
            }
            
        case 12:
            // 批量转账 - 跳转到批量转账页面
            let batchTransferVC = BatchTransferViewController()
            if let navController = navigationController {
                navController.pushViewController(batchTransferVC, animated: true)
            } else {
                // 如果没有导航控制器，使用 present 方式
                let navController = UINavigationController(rootViewController: batchTransferVC)
                present(navController, animated: true)
            }
            
        case 7:
            // HTLC 智能合约：地址生成 - 跳转到 HTLC 地址生成页面
            let htlcGenerateVC = HTLCGenerateViewController()
            if let navController = navigationController {
                navController.pushViewController(htlcGenerateVC, animated: true)
            } else {
                let navController = UINavigationController(rootViewController: htlcGenerateVC)
                present(navController, animated: true)
            }
            
        case 8:
            // HTLC 智能合约：解锁与转账 - 跳转到 HTLC 解锁页面
            let htlcUnlockVC = HTLCUnlockViewController()
            if let navController = navigationController {
                navController.pushViewController(htlcUnlockVC, animated: true)
            } else {
                let navController = UINavigationController(rootViewController: htlcUnlockVC)
                present(navController, animated: true)
            }
            
        case 9:
            // 无签名脚本地址生成 - 跳转到无签名脚本地址生成页面
            let noSigScriptGenerateVC = NoSigScriptGenerateViewController()
            if let navController = navigationController {
                navController.pushViewController(noSigScriptGenerateVC, animated: true)
            } else {
                let navController = UINavigationController(rootViewController: noSigScriptGenerateVC)
                present(navController, animated: true)
            }
            
        case 10:
            // 无签名脚本：解锁与转账 - 跳转到无签名脚本解锁页面
            let noSigScriptUnlockVC = NoSigScriptUnlockViewController()
            if let navController = navigationController {
                navController.pushViewController(noSigScriptUnlockVC, animated: true)
            } else {
                let navController = UINavigationController(rootViewController: noSigScriptUnlockVC)
                present(navController, animated: true)
            }
            
        case 13:
            // 多签地址生成 - 跳转到多签地址生成页面
            let multisigGenerateVC = MultisigGenerateViewController()
            if let navController = navigationController {
                navController.pushViewController(multisigGenerateVC, animated: true)
            } else {
                let navController = UINavigationController(rootViewController: multisigGenerateVC)
                present(navController, animated: true)
            }
            
        case 14:
            // 多签转账 - 跳转到多签转账页面
            let multisigTransferVC = MultisigTransferViewController()
            if let navController = navigationController {
                navController.pushViewController(multisigTransferVC, animated: true)
            } else {
                let navController = UINavigationController(rootViewController: multisigTransferVC)
                present(navController, animated: true)
            }
            
        case 21:
            // 消息签名 - 跳转到消息签名页面
            let messageSignVC = MessageSignViewController()
            if let navController = navigationController {
                navController.pushViewController(messageSignVC, animated: true)
            } else {
                let navController = UINavigationController(rootViewController: messageSignVC)
                present(navController, animated: true)
            }
            
        case 22:
            // 消息验证 - 跳转到消息验证页面
            let messageVerifyVC = MessageVerifyViewController()
            if let navController = navigationController {
                navController.pushViewController(messageVerifyVC, animated: true)
            } else {
                let navController = UINavigationController(rootViewController: messageVerifyVC)
                present(navController, animated: true)
            }
            
        default:
            // 其他功能暂时不实现，只打印日志
            print("功能 ID \(feature.id) 暂未实现")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

