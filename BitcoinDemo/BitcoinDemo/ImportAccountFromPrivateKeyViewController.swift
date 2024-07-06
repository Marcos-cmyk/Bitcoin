//
//  ImportAccountFromPrivateKeyViewController.swift
//  BitcoinDemo
//
//  Created by Marcos-cmyk on 2024/7/4.
//

import UIKit
import Bitcoin_alpha

class ImportAccountFromPrivateKeyViewController: UIViewController {
    lazy var bitcoin: Bitcoin_V1 = {
        let btc = Bitcoin_V1()
        return btc
    }()

    lazy var importAccountFromPrivateKeyBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("import Account From PrivateKey", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(importAccountFromPrivateKeyAction), for: .touchUpInside)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        return btn
    }()
    lazy var privateKeyTextView: UITextView = {
        let textView = UITextView()
        textView.text = "L2Qh4dbHEig7W7zcrjuQ6csXSfaD22WXoifwi12Qcd9pBf3QKoip"
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.brown.cgColor
        return textView
    }()
    
    lazy var walletDetailTextView: UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.brown.cgColor
        return textView
    }()

    lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "waiting for import Account From PrivateKey"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    deinit {
        print("\(type(of: self)) release")
    }

    func setupView() {
        setupNav()
        setupContent()
    }

    func setupNav() {
        title = "import Account From PrivateKey"
    }

    func setupContent() {
        view.backgroundColor = .white
        view.addSubviews(importAccountFromPrivateKeyBtn,privateKeyTextView, walletDetailTextView, tipLabel)
        importAccountFromPrivateKeyBtn.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(-100)
            make.height.equalTo(40)
        }
        privateKeyTextView.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.top.equalTo(100)
            make.height.equalTo(100)
        }
        walletDetailTextView.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.top.equalTo(privateKeyTextView.snp.bottom).offset(20)
            make.height.equalTo(300)
        }
        tipLabel.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(importAccountFromPrivateKeyBtn.snp.top).offset(-20)
            make.height.equalTo(40)
        }
    }

    @objc func importAccountFromPrivateKeyAction() {
        importAccountFromPrivateKeyBtn.isEnabled = false
        tipLabel.text = "importing ..."
        if bitcoin.isSuccess {
            importAccountFromPrivateKey()
            
        } else {
            bitcoin.setup(showLog: true) { [weak self] _ in
                guard let self = self else { return }
                self.importAccountFromPrivateKey()
            }
        }
    }

    func importAccountFromPrivateKey() {
        guard let privateKey = privateKeyTextView.text else{return}
        bitcoin.importAccountFromPrivateKey(privateKey: privateKey){ [weak self] state, address, privateKey,error in
            guard let self = self else { return }
            self.importAccountFromPrivateKeyBtn.isEnabled = true
            tipLabel.text = "import finished."
            if state {
                let text =
                    "address: " + address + "\n\n" +
                    "privateKey: " + privateKey
                walletDetailTextView.text = text
            } else {
                walletDetailTextView.text = error
            }
        }
    }
    

}
