//
//  DetailTableViewCell.swift
//  Geographic atlas
//
//  Created by Julia on 16.05.2023.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    static var identifier = "DetailTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 0.533, green: 0.533, blue: 0.533, alpha: 1)
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private lazy var roundButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private func setup() {
        setupViews()
        makeConstraints()
        setupColors()
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(roundButton)
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(roundButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
        }
        
        roundButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(10)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
        }
    }
    
    private func setupColors() {
        contentView.backgroundColor = .white
    }
    
    func configure(with data: String, title: String) {
        titleLabel.text = title
        subTitleLabel.text = data
    }
}
