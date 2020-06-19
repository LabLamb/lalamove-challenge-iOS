//
//  DeliveryFeeView.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 19/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import SnapKit

class DeliveryFeeView: UIView {
    
    private struct UIConstants {
        static let labelMargin = 25
    }
    
    private lazy var paddingView: UIView = {
        let result = UIView()
        result.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return result
    }()
    
    private lazy var titleLabel: UILabel = {
        let result = UILabel()
        result.text = "Delivery Fee"
        return result
    }()
    
    private lazy var feeLabel: UILabel = {
        let result = UILabel()
        return result
    }()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        addSubview(paddingView)
        paddingView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(UIConstants.labelMargin)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-UIConstants.labelMargin)
        }
        
        paddingView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(UIConstants.labelMargin)
            make.bottom.equalToSuperview().offset(-UIConstants.labelMargin)
        }
        
        paddingView.addSubview(feeLabel)
        feeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIConstants.labelMargin)
            make.left.equalTo(titleLabel.snp.right).offset(UIConstants.labelMargin)
            make.right.equalToSuperview().offset(-UIConstants.labelMargin)
            make.bottom.equalToSuperview().offset(-UIConstants.labelMargin)
        }
    }
    
    func updateText(fee: Double) {
        let feeTxt = fee.toLocalCurrency(fractDigits: 2) ?? "0.00"
        feeLabel.text = "$\(feeTxt)"
    }
    
}
