import UIKit
import SDWebImage

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CollectionViewCell"
    
    let texts = ["Population:", "Area:", "Currencies:"]
    
    var didExpandButtonTapped: (() -> Void)?
    
    var isExpanded: Bool = false {
        didSet {
            updateAdditionalContentVisibility()
        }
    }
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 0.533, green: 0.533, blue: 0.533, alpha: 1)
        return label
    }()
    
    private lazy var expandButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "expand_icon"), for: .normal)
        button.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
        return button
    }()
    
     lazy var viewContainer: ViewContainer = {
        let viewContainer = ViewContainer()
        return viewContainer
    }()

    private func updateAdditionalContentVisibility() {
        viewContainer.isHidden = !isExpanded
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(with data: Country) {
        
        titleLabel.text = data.name?.common
        subTitleLabel.text = data.capital?.joined(separator: ", ")
        if let pngURL = data.flags?.png, let url = URL(string: pngURL) {
            iconImageView.sd_setImage(with: url, completed: nil)
        } else if let svgURL = data.flags?.svg, let url = URL(string: svgURL) {
            // Load SVG image if needed
        } else {
            iconImageView.image = nil
        }
        
        var textForContainer: [String] = []
        
        if let population = data.population {
            let formattedPopulation = formatPopulation(population)
            textForContainer.append(String(formattedPopulation))
        }
        if let area = data.area {
            let formattedArea = formatArea(Double(area))
            textForContainer.append(formattedArea)
        }
        if let currencies = data.currencies?.currencies, let currency = currencies.first {
            let formattedCurrency = formatCurrency(currency)
            textForContainer.append(formattedCurrency)
        }
        viewContainer.setTitlesForStackViews(titles: texts, subtitles: textForContainer)
    }
    
    private func setup() {
        setupViews()
        setupColors()
        makeConstraints()
    }
    
    private func setupViews() {
        [iconImageView, titleLabel, subTitleLabel, expandButton, viewContainer].forEach { contentView.addSubview($0) }
    }
    
    private func setupColors() {
        contentView.backgroundColor = UIColor(red: 0.969, green: 0.973, blue: 0.976, alpha: 1)
    }
    
    private func makeConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(12)
            make.height.equalTo(48)
            make.width.equalTo(82)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(48)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        expandButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(12)
            make.width.height.equalTo(24)
        }
        
        viewContainer.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(4)
            make.leading.equalTo(iconImageView)
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    @objc private func expandButtonTapped() {
        didExpandButtonTapped?()
    }
}

extension CollectionViewCell {
    func formatPopulation(_ population: Int) -> String {
        let populationInMillions = Double(population) / 1_000_000
        return String(format: "%.0f mln", populationInMillions)
    }
    
    func formatArea(_ area: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = " "
        numberFormatter.maximumFractionDigits = 0
        
        if let formattedArea = numberFormatter.string(from: NSNumber(value: area)) {
            return formattedArea + " km²"
        }
        
        return ""
    }
    
    func formatCurrency(_ currency: Currency) -> String {
        return "\(currency.name ?? "") (\(currency.symbol ?? ""))"
    }
}
