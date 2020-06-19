//
//  RouteView.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import SnapKit

class RouteView: UIView {
    
    private struct UIConstants {
        static let labelMargin = 25
    }
    
    private lazy var paddingView: UIView = {
        let result = UIView()
        result.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return result
    }()
    
    private lazy var fromLabel: SubtitleView = {
        let result = SubtitleView(subtitle: "From")
        return result
    }()
    
    private lazy var toLabel: SubtitleView = {
        let result = SubtitleView(subtitle: "To")
        return result
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        addSubview(paddingView)
        paddingView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(UIConstants.labelMargin)
            make.right.equalToSuperview().offset(-UIConstants.labelMargin)
            make.bottom.equalToSuperview()
        }
        
        paddingView.addSubview(fromLabel)
        fromLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(UIConstants.labelMargin)
            make.bottom.equalToSuperview().offset(-UIConstants.labelMargin)
            make.height.equalTo(fromLabel.titleFont.lineHeight + fromLabel.subtitleFont.lineHeight)
        }
        
        paddingView.addSubview(toLabel)
        toLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIConstants.labelMargin)
            make.right.bottom.equalToSuperview().offset(-UIConstants.labelMargin)
            make.height.equalTo(toLabel.titleFont.lineHeight + toLabel.subtitleFont.lineHeight)
        }
    }
    
    func updateText(fromLabelTxt: String, toLabelTxt: String) {
        fromLabel.updateText(titleText: fromLabelTxt)
        toLabel.updateText(titleText: toLabelTxt)
    }
    
}
