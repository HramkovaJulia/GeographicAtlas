//
//  DetailHeaderView.swift
//  Geographic atlas
//
//  Created by Julia on 16.05.2023.
//

import UIKit
import SDWebImage
import SVGKit

class DetailHeaderView: UITableViewHeaderFooterView {

    static var identifier = "DetailHeaderView"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private func setup() {
        setupViews()
        makeConstraints()
        setupColors()
    }
    
    private func makeConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupViews() {
        contentView.addSubview(iconImageView)
    }
    
    private func setupColors() {
        contentView.backgroundColor = .white
    }
    
    func configure(with data: Country) {
        if let pngURL = data.flags?.png, let url = URL(string: pngURL) {
            iconImageView.sd_setImage(with: url, completed: nil)
        } else if let svgURL = data.flags?.svg, let url = URL(string: svgURL) {
            iconImageView.sd_setImage(with: url, completed: nil)
        } else {
            iconImageView.image = nil
        }
    }
}
