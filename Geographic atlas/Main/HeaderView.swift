//
//  HeaderView.swift
//  Geographic atlas
//
//  Created by Julia on 17.05.2023.
//

import UIKit

class HeaderView: UICollectionReusableView {
   
    static let identifier = "HeaderView"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textColor = UIColor(red: 0.672, green: 0.702, blue: 0.732, alpha: 1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
}
