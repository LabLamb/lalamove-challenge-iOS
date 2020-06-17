//
//  DeliveryMasterCell.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import SnapKit

class DeliveryMasterCell: UITableViewCell {
    
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
            make.width.equalToSuperview().dividedBy(3)
            make.centerX.centerY.equalToSuperview()
        }
        
        contentView.addSubview(fromLabel)
        fromLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        contentView.addSubview(toLabel)
        toLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.goodImage.clipsToBounds = false
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
