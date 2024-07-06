//
//  FeeEstimateViewController.swift
//  BitcoinDemo
//
//  Created by Marcos-cmyk on 2024/7/4.
//

import UIKit


class FeeEstimateViewController: UIViewController {
    lazy var bitcoin: Bitcoin_V1 = {
        let btc = Bitcoin_V1()
        return btc
    }()
    lazy var estimateBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Estimate Fee", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(estimatedAction), for: .touchUpInside)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        return btn
    }()
    
    lazy var estimatedFeetLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Waiting for estimate ..."
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.textColor = .blue
        label.backgroundColor = .lightGray
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
    }

    deinit {
        print("\(type(of: self)) release")
    }
    
    func setupContent() {
        title = "send BTC Estimate Fee"
        view.backgroundColor = .white
        view.addSubviews(estimateBtn,  estimatedFeetLabel)
        estimateBtn.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(-100)
            make.height.equalTo(40)
        }
        estimatedFeetLabel.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(estimateBtn.snp.top).offset(-20)
            make.top.equalTo(100)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func estimatedAction() {
        print("tap estimatedAction")
        if bitcoin.isSuccess {
            estimatedBTCTransferFee()
        } else {
            bitcoin.setup(showLog: true) { [weak self] _ in
                guard let self = self else { return }
                self.estimatedBTCTransferFee()
            }
        }
    }
    
    func estimatedBTCTransferFee() {
        // If you have n input addresses and m output addresses, then your inputCount is n, and your outputCount is m.
        let inputCount = 1
        let outputCount = 2
        bitcoin.estimateBtcTransferFee(inputsCount: inputCount,outputsCount: outputCount){ [weak self] state, high,medium,low,error in
            guard let self = self else { return }
            print("Estimate fee finised.")
            if (state) {
                let highFormatted = String(format: "%.2f", high)
                let mediumFormatted = String(format: "%.2f", medium)
                let lowFormatted = String(format: "%.2f", low)
                self.estimatedFeetLabel.text = "Send BTC hava three estimated fee. \n high:\(highFormatted) Satoshis. \n medium:\(mediumFormatted) Satoshis. \n low:\(lowFormatted) Satoshis"
            } else {
                self.estimatedFeetLabel.text = error
            }
        }
    }
}
