//
//  DottedLine.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import SnapKit

class SubtitleView: UIView {
    
    let titleFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    let subtitleFont = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    
    private lazy var title: UILabel = {
        let result = UILabel()
        result.font = titleFont
        return result
    }()
    
    private lazy var subtitle: UILabel = {
        let result = UILabel()
        result.font = subtitleFont
        result.textColor = .gray
        return result
    }()
    
    init(subtitle subtitleText: String) {
        super.init(frame: .zero)
        subtitle.text = subtitleText
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateText(titleText: String) {
        title.text = titleText
    }
    
    fileprivate func setupLayout() {
        addSubview(subtitle)
        subtitle.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(subtitle.font.lineHeight)
        }
        
        addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(subtitle.snp.bottom)
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(title.font.lineHeight)
        }
    }
}
