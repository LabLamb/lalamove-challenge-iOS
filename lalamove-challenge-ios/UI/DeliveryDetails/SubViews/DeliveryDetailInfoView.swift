//
//  DeliveryDetailInfoView.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import SnapKit

struct DeliveryDetailInfoViewConfiguration {
    let fromAddress: String
    let toAddress: String
    let goodsImage: UIImage
    let deliveryFee: Double
}

class DeliveryDetailInfoView: UIView {
    
    private lazy var stackView: UIStackView = {
        let result = UIStackView()
        result.axis = .vertical
        result.alignment = .fill
        result.distribution = .fill
        return result
    }()
    
    private lazy var routeView: RouteView = {
        let result = RouteView()
        return result
    }()
    
    private lazy var goodsImageGallery: ImageGalleryView = {
        let result = ImageGalleryView()
        return result
    }()
    private lazy var deliveryFeeView: DeliveryFeeView = {
        let result = DeliveryFeeView()
        return result
    }()
    
    init(config: DeliveryDetailInfoViewConfiguration) {
        super.init(frame: .zero)
        setupData(config: config)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(config: DeliveryDetailInfoViewConfiguration) {
        routeView.updateText(fromLabelTxt: config.fromAddress, toLabelTxt: config.toAddress)
        goodsImageGallery.updateImage(goodsImage: config.goodsImage)
        deliveryFeeView.updateText(fee: config.deliveryFee)
    }
    
    fileprivate func setupLayout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        stackView.addArrangedSubview(routeView)
        stackView.addArrangedSubview(goodsImageGallery)
        stackView.addArrangedSubview(deliveryFeeView)
    }
}
