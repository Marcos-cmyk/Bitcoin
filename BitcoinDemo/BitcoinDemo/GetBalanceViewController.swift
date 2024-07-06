//
//  GetBalanceViewController.swift
//  BitcoinDemo
//
//  Created by Marcos-cmyk on 2024/7/4.
//

import UIKit

class GetBalanceViewController: UIViewController {
    lazy var bitcoin: Bitcoin_V1 = {
        let btc = Bitcoin_V1()
        return btc
    }()

    lazy var getBalanceBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("getBalance", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(getBalanceAction), for: .touchUpInside)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        return btn
    }()

    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "waiting for get balance..."
        return label
    }()

    lazy var addressField: UITextField = {
        let addressField = UITextField()
        addressField.borderStyle = .line
        addressField.placeholder = "address input"
        addressField.text = "bc1qfjz4zx04ld96ggy324cljupxr32q0clpvdp4xr"
        return addressField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    deinit {
        print("\(type(of: self)) release")
    }

    func setupView() {
        setupNav()
        setupContent()
    }

    func setupNav() {
        title = "get balance"
    }

    func setupContent() {
        view.backgroundColor = .white
        view.addSubviews(getBalanceBtn, addressField, balanceLabel)
        getBalanceBtn.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(-100)
            make.height.equalTo(40)
        }
        addressField.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.top.equalTo(150)
            make.height.equalTo(40)
        }
        balanceLabel.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(getBalanceBtn.snp.top).offset(-20)
            make.height.equalTo(40)
        }
        
    }

    func getBTCBalance(_ address: String) {
        bitcoin.getBTCBalance(address: address) { [weak self] state, balance,error in
            guard let self = self else { return }
            self.getBalanceBtn.isEnabled = true
            if state {
                let title = "BTC Balance: "
                self.balanceLabel.text = title + balance
            } else {
                self.balanceLabel.text = error
            }
        }
    }


    @objc func getBalanceAction() {
        getBalanceBtn.isEnabled = false
        balanceLabel.text = "fetching balance ..."
        guard let address = addressField.text else { return }
        if bitcoin.isSuccess {
            getBTCBalance(address)
        } else {
            bitcoin.setup(showLog: true) { [weak self] _ in
                guard let self = self else { return }
                self.getBTCBalance(address)
            }
        }
    }
}
