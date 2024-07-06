//
//  CreateAccountViewController.swift
//  BitcoinDemo
//
//  Created by Marcos-cmyk on 2024/7/4.
//
import SnapKit
import UIKit

let margin: CGFloat = 20.0
class CreateAccountViewController: UIViewController {
    lazy var bitcoin: Bitcoin_V1 = {
        let btc = Bitcoin_V1()
        return btc
    }()

    lazy var createAccountBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("createAccount", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(createAccountAction), for: .touchUpInside)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        return btn
    }()

    lazy var accountDetailTextView: UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.brown.cgColor
        return textView
    }()

    lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "wait for create Account"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    func setupView() {
        setupNav()
        setupContent()
    }

    func setupNav() {
        title = "Create Account"
    }

    func setupContent() {
        view.backgroundColor = .white
        view.addSubviews(createAccountBtn, accountDetailTextView, tipLabel)
        createAccountBtn.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(-100)
            make.height.equalTo(40)
        }
        accountDetailTextView.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.top.equalTo(150)
            make.height.equalTo(300)
        }
        tipLabel.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(createAccountBtn.snp.top).offset(-20)
            make.height.equalTo(40)
        }
    }

    @objc func createAccountAction() {
        createAccountBtn.isEnabled = false
        tipLabel.text = "creating ..."
        
        if bitcoin.isSuccess {
            createAccount()
            
        } else {
            bitcoin.setup(showLog: true) { [weak self] _ in
                guard let self = self else { return }
                self.createAccount()
            }
        }
    }

    func createAccount() {
        bitcoin.createAccount() { [weak self] state, address, privateKey, mnemonic,error in
            guard let self = self else { return }
            self.createAccountBtn.isEnabled = true
            tipLabel.text = "create finished."
            if state {
                let text =
                    "address: " + address + "\n\n" +
                    "mnemonic: " + mnemonic + "\n\n" +
                    "privateKey: " + privateKey
                accountDetailTextView.text = text
            } else {
                accountDetailTextView.text = error
            }
        }
    }
    
    deinit {
        print("\(type(of: self)) release")
    }
}

public extension UIView {
    func addSubviews(_ subviews: UIView...) {
        for index in subviews {
            addSubview(index)
        }
    }
}
