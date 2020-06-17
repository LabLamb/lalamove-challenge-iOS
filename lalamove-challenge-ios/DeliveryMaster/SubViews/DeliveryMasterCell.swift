//
//  DeliveryMasterCell.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import SnapKit

class DeliveryMasterCell: UITableViewCell {
    
    struct UIConstants {
        static let fromToLabelOffset = 25
        static let priceLabelOffset = 25
    }
    
    static let cellIdentifier = "deliveryMasterCell"
    
    let goodImage = UIImageView()
    let fromLabel = UILabel()
    let toLabel = UILabel()
    let priceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        goodImage.image = nil
        fromLabel.text = ""
        toLabel.text = ""
    }
    
    fileprivate func setupConstraints() {
        
        contentView.addSubview(goodImage)
        goodImage.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.9)
            make.width.equalTo(goodImage.snp.height)
            make.centerX.centerY.equalToSuperview()
        }
        goodImage.clipsToBounds = false
        
        contentView.addSubview(fromLabel)
        fromLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(UIConstants.fromToLabelOffset)
        }
        
        contentView.addSubview(toLabel)
        toLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-UIConstants.fromToLabelOffset)
            make.left.equalToSuperview().offset(UIConstants.fromToLabelOffset)
        }
        
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-UIConstants.priceLabelOffset)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.goodImage.layer.cornerRadius = self.goodImage.frame.height / 2
        }
    }
    
    func configData(summary: DeliverySummary) {
        fromLabel.text = summary.from
        toLabel.text = summary.to
        goodImage.image = summary.goodsPic
        priceLabel.text = {
            guard let priceString = summary.price.toLocalCurrency(fractDigits: 2) else { return "" }
            return "$\(priceString)"
        }()
    }
}
