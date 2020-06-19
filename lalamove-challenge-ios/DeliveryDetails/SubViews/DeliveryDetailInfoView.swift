//
//  DeliveryDetailInfoView.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import SnapKit

class DeliveryDetailInfoView: UIView {
    
    private lazy var stackView: UIStackView = {
        let result = UIStackView()
        result.axis = .vertical
        result.alignment = .fill
        result.distribution = .fill
        return result
    }()
    
    private var routeView: RouteView?
//    private var goodsImageGallery: ImageGalleryView?
//    private var deliveryFeeView: DeliveryFeeView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        
    }
}
