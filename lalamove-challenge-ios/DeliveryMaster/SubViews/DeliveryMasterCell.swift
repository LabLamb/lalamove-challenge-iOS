//
//  DeliveryMasterCell.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import SnapKit

protocol DeliveryMasterCellImageUpdatable {
    func updateImage(image: UIImage)
}

class DeliveryMasterCell: UITableViewCell {
    
    struct UIConstants {
        static let goodsImageLeftOffset = 15
        static let fromToLabelOffsetFromLeft = 15
        static let fromToLabelOffsetFromTopBot = 15
        static let priceLabelOffset = 25
    }
    
    static let cellIdentifier = "deliveryMasterCell"
    private let favImagePlaceholder = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
    
    lazy var goodImage: UIImageView = {
        let result = UIImageView()
        result.backgroundColor = .white
        result.layer.borderColor = UIColor.lightGray.cgColor
        result.layer.borderWidth = 1
        result.tintColor = .white
        return result
    }()
    
    lazy var favImage: UIImageView = {
        let result = UIImageView()
        result.image = self.favImagePlaceholder
        result.tintColor = .systemYellow
        return result
    }()
    
    let fromLabel = SubtitleView()
    let toLabel = SubtitleView()
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
        fromLabel.updateText(titleText: "N/A", subtitleText: "From")
        toLabel.updateText(titleText: "N/A", subtitleText: "To")
    }
    
    fileprivate func setupConstraints() {
        selectionStyle = .none
        
        contentView.addSubview(goodImage)
        goodImage.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.75)
            make.width.equalTo(goodImage.snp.height)
            make.left.equalToSuperview().offset(UIConstants.goodsImageLeftOffset)
            make.centerY.equalToSuperview()
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.goodImage.clipsToBounds = true
            self.goodImage.layer.cornerRadius = self.goodImage.frame.width / 2
        }
        
        contentView.addSubview(favImage)
        favImage.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(4)
            make.width.equalTo(favImage.snp.height)
            make.right.equalTo(goodImage.snp.right)
            make.bottom.equalTo(goodImage.snp.bottom)
        }
        
        
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-UIConstants.priceLabelOffset)
        }
        
        contentView.addSubview(fromLabel)
        fromLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIConstants.fromToLabelOffsetFromTopBot)
            make.left.equalTo(self.goodImage.snp.right).offset(UIConstants.fromToLabelOffsetFromLeft)
            make.right.equalTo(self.priceLabel.snp.left)
            make.height.equalTo(fromLabel.titleFont.lineHeight + fromLabel.subtitleFont.lineHeight)
        }
        
        contentView.addSubview(toLabel)
        toLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-UIConstants.fromToLabelOffsetFromTopBot)
            make.left.equalTo(self.goodImage.snp.right).offset(UIConstants.fromToLabelOffsetFromLeft)
            make.right.equalTo(self.priceLabel.snp.left)
            make.height.equalTo(toLabel.titleFont.lineHeight + toLabel.subtitleFont.lineHeight)
        }
    }
    
    func configData(summary: DeliverySummary) {
        fromLabel.updateText(titleText: summary.from, subtitleText: "From")
        toLabel.updateText(titleText: summary.to, subtitleText: "To")
        
        if let pic = summary.goodsPic {
            goodImage.image = pic
        }
        
        favImage.image = favImagePlaceholder
        favImage.isHidden = !summary.isFav
        
        priceLabel.text = {
            guard let priceString = summary.price.toLocalCurrency(fractDigits: 2) else { return "" }
            return "$\(priceString)"
        }()
    }
}

extension DeliveryMasterCell: DeliveryMasterCellImageUpdatable {
    func updateImage(image: UIImage) {
        goodImage.image = image
    }
    
}
