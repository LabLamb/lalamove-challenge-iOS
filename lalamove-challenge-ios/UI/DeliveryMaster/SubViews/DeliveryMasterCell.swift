//
//  DeliveryMasterCell.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import SnapKit

class DeliveryMasterCell: UITableViewCell {
    
    private struct UIConstants {
        static let goodsImageLeftOffset = 10
        static let fromToLabelOffsetFromLeft = 15
        static let fromToLabelOffsetFromTopBot = 15
        static let priceLabelOffset = 25
    }
    
    static let cellIdentifier = "deliveryMasterCell"
    
    lazy var goodsImageView: UIImageView = {
        let result = UIImageView()
        result.backgroundColor = .white
        result.layer.borderColor = UIColor.lightGray.cgColor
        result.layer.borderWidth = 1
        result.tintColor = .white
        return result
    }()
    
    lazy var favImage: UILabel = {
        let result = UILabel()
        result.text = "❤️"
        result.font = UIFont(name: "AppleColorEmoji", size: 25)
        return result
    }()
    
    let fromLabel = SubtitleView(subtitle: "From")
    let toLabel = SubtitleView(subtitle: "To")
    let priceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        goodsImageView.image = nil
        fromLabel.updateText(titleText: "N/A")
        toLabel.updateText(titleText: "N/A")
    }
    
    fileprivate func setupConstraints() {
        contentView.addSubview(goodsImageView)
        goodsImageView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.9)
            make.width.equalTo(goodsImageView.snp.height)
            make.left.equalToSuperview().offset(UIConstants.goodsImageLeftOffset)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(favImage)
        favImage.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
        }
        
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-UIConstants.priceLabelOffset)
        }
        
        contentView.addSubview(fromLabel)
        fromLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIConstants.fromToLabelOffsetFromTopBot)
            make.left.equalTo(self.goodsImageView.snp.right).offset(UIConstants.fromToLabelOffsetFromLeft)
            make.height.equalTo(fromLabel.titleFont.lineHeight + fromLabel.subtitleFont.lineHeight)
        }
        
        contentView.addSubview(toLabel)
        toLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-UIConstants.fromToLabelOffsetFromTopBot)
            make.left.equalTo(self.goodsImageView.snp.right).offset(UIConstants.fromToLabelOffsetFromLeft)
            make.height.equalTo(toLabel.titleFont.lineHeight + toLabel.subtitleFont.lineHeight)
        }
    }
    
    func configData(summary: DeliverySummary) {
        fromLabel.updateText(titleText: summary.from)
        toLabel.updateText(titleText: summary.to)
        
        if let pic = summary.goodsPic {
            goodsImageView.image = pic
        }
        
        favImage.isHidden = !summary.isFavorite
        
        priceLabel.text = {
            guard let priceString = summary.fee.toLocalCurrency(fractDigits: 2) else { return "" }
            return "$\(priceString)"
        }()
    }
}
