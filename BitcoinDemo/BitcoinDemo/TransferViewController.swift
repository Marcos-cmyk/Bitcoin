//
//  TransferViewController.swift
//  BitcoinDemo
//
//  Created by Marcos-cmyk on 2024/7/4.
//

import UIKit

class TransferViewController: UIViewController {
    lazy var bitcoin: Bitcoin_V1 = {
        let btc = Bitcoin_V1()
        return btc
    }()
    lazy var transferBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("transfer", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(transferAction), for: .touchUpInside)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        return btn
    }()
    lazy var privateKeyTextView: UITextView = {
        let textView = UITextView()
        let p1 = "Kz3jamEzx6GA8jSW54AkdG"
        let p2 = "b4J1rTcS8fqJZH6vqkKxweZekaB2JF"
        textView.text = p1 + p2
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.brown.cgColor
        return textView
    }()
    
    lazy var reviceAddressField: UITextField = {
        let reviceAddressField = UITextField()
        reviceAddressField.borderStyle = .line
        reviceAddressField.placeholder = "revice address input"
        reviceAddressField.text = "bc1q79t70t8fzfpdwkhk8arckruvdfmurtncjaykz7"
        return reviceAddressField
    }()
    
    lazy var amountTextField: UITextField = {
        let amountTextField = UITextField()
        amountTextField.borderStyle = .line
        amountTextField.keyboardType = .numberPad
        amountTextField.placeholder = "amount input"
        amountTextField.text = "0.00001"
        return amountTextField
    }()
    
    lazy var hashLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Signature..."
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.textColor = .blue
        label.backgroundColor = .lightGray
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    lazy var detailBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Get detail in blockchair", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(queryAction), for: .touchUpInside)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        return btn
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
        print("Support a Bitcoin address sending to multiple Bitcoin addresses simultaneously.")
        // Do any additional setup after loading the view.
    }

    deinit {
        print("\(type(of: self)) release")
    }
    
    func setupContent() {
        title = "BTC Transfer"
        view.backgroundColor = .white
        view.addSubviews(transferBtn, privateKeyTextView, reviceAddressField, amountTextField, hashLabel, detailBtn)
        transferBtn.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(-100)
            make.height.equalTo(40)
        }
        detailBtn.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(transferBtn.snp.top).offset(-20)
            make.height.equalTo(40)
        }
        hashLabel.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(detailBtn.snp.top).offset(-20)
            make.height.equalTo(60)
        }
        privateKeyTextView.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.top.equalTo(150)
            make.height.equalTo(80)
        }
        
        reviceAddressField.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.top.equalTo(privateKeyTextView.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
        
        amountTextField.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.top.equalTo(reviceAddressField.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func transferAction() {
        print("tap transfer")
        if bitcoin.isSuccess {
            sendBTC()
        } else {
            bitcoin.setup(showLog: true) { [weak self] _ in
                guard let self = self else { return }
                self.sendBTC()
            }
        }
    }
    func sendBTC() {
        guard let privateKey = privateKeyTextView.text,
              let reviceAddress1 = reviceAddressField.text,
              let amount1 = amountTextField.text else { return }
        var outputs = [[String: String]]()
        let output1: [String: String] = ["address":reviceAddress1,"amount":amount1]
        let output2: [String: String] = ["address":"bc1q0zeshwwrdd8zxv8jgz97vc66qn3nyuewaylzyg","amount":"0.00001"]
        outputs.append(output1)
        outputs.append(output2)
        let fee = 3000.0
        bitcoin.transfer(privateKey: privateKey, outputs: outputs, fee: fee){ [weak self] state, hash,error in
            guard let self = self else { return }
            print("state = \(state)")
            print("hash = \(hash)")
            if (state) {
                self.hashLabel.text = hash
            } else {
                self.hashLabel.text = error
            }
        }
    }
    
    @objc func queryAction() {
        guard let hash = hashLabel.text, hash.count > 10 else { return }
        let urlString = "https://blockchair.com/bitcoin/transaction/" + hash
        showSafariVC(for: urlString)
    }
}
