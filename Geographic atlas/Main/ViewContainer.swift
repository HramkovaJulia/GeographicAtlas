import UIKit
import SnapKit

class ViewContainer: UIView {
    
    var didMoreButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupViews()
        makeConstraints()
    }
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Learn more", for: .normal)
        button.setTitleColor(UIColor(red: 0, green: 0.478, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.contentHorizontalAlignment = .center

        return button
    }()
    
    private var stackViews: [UIStackView] = []
    
    private func setupViews() {
        for _ in 0..<3 {
            let stackView: UIStackView = {
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.spacing = 2
                return stackView
            }()
            
            let titleLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
                label.textColor = UIColor(red: 0.533, green: 0.533, blue: 0.533, alpha: 1)
                return label
            }()
            
            let subtitleLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
                label.textColor = .black
                return label
            }()
            
            stackView.addArrangedSubview(titleLabel)
            stackView.addArrangedSubview(subtitleLabel)
            addSubview(stackView)
            stackViews.append(stackView)
        }
        
        addSubview(moreButton)
    }
    
    private func makeConstraints() {
        let stackViewHeight: CGFloat = 20
        let spacing: CGFloat = 4
        let buttonHeight: CGFloat = 50
        
        for (index, stackView) in stackViews.enumerated() {
            stackView.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                if index == 0 {
                    make.top.equalToSuperview()
                } else {
                    make.top.equalTo(stackViews[index - 1].snp.bottom).offset(spacing)
                }
                make.height.equalTo(stackViewHeight)
            }
        }
        
        moreButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(12)
            if let lastStackView = stackViews.last {
                make.top.equalTo(lastStackView.snp.bottom).offset(spacing)
            } else {
                make.top.equalToSuperview()
            }
            make.height.equalTo(buttonHeight)
            make.bottom.equalToSuperview()
        }
    }
    
    func setTitlesForStackViews(titles: [String], subtitles: [String]) {
        guard stackViews.count == titles.count && stackViews.count == subtitles.count else {
            return
        }
        
        for (index, title) in titles.enumerated() {
            let stackView = stackViews[index]
            let titleLabel = stackView.arrangedSubviews.first as? UILabel
            let subtitleLabel = stackView.arrangedSubviews.last as? UILabel
            titleLabel?.text = title
            subtitleLabel?.text = subtitles[index]
        }
    }
    
    @objc func buttonTapped() {
        didMoreButtonTapped?()
    }
}
