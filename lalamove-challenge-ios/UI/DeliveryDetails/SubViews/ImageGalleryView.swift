//
//  ImageGalleryView.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 19/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import SnapKit

class ImageGalleryView: UIView {
    
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
        result.text = "Goods to deliver"
        return result
    }()
    
    private lazy var imageView: UIImageView = {
        let result = UIImageView()
        result.layer.borderColor = UIColor.black.cgColor
        result.layer.borderWidth = 1
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
            make.right.equalToSuperview().offset(-UIConstants.labelMargin)
            make.height.equalTo(titleLabel.font.lineHeight)
        }
        
        paddingView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(UIConstants.labelMargin)
            make.left.equalToSuperview().offset(UIConstants.labelMargin)
            make.height.equalTo(imageView.snp.width)
            make.bottom.right.equalToSuperview().offset(-UIConstants.labelMargin)
        }
    }
    
    func updateImage(goodsImage: UIImage) {
        imageView.image = goodsImage
    }
    
}
