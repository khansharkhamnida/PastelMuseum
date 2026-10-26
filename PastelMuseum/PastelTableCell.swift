import UIKit

class PastelTableCell: UITableViewCell {
    
    static let identifier = "PastelTableCell"

    var item: Pastel = Pastel(color: "Default", brand: .unknownBrand, colorID: -1, dateAcquired: Date.now, colorSwatch: RGBColor(red: -1, green: -1, blue: -1))

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let swatchView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let pastelTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let pastelDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cardView)
        cardView.addSubview(swatchView)
        cardView.addSubview(pastelTitleLabel)
        cardView.addSubview(pastelDescriptionLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            swatchView.topAnchor.constraint(equalTo: cardView.topAnchor),
            swatchView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            swatchView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            swatchView.heightAnchor.constraint(equalToConstant: 64),
            
            pastelTitleLabel.topAnchor.constraint(equalTo: swatchView.bottomAnchor, constant: 10),
            pastelTitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            pastelTitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            pastelDescriptionLabel.topAnchor.constraint(equalTo: pastelTitleLabel.bottomAnchor, constant: 2),
            pastelDescriptionLabel.leadingAnchor.constraint(equalTo: pastelTitleLabel.leadingAnchor),
            pastelDescriptionLabel.trailingAnchor.constraint(equalTo: pastelTitleLabel.trailingAnchor),
            pastelDescriptionLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with item: Pastel) {
        self.item = item
        swatchView.backgroundColor = item.swatchUIColor
        pastelTitleLabel.text = item.color
        pastelDescriptionLabel.text = "No. \(item.colorID)  ·  \(item.brand.rawValue)"
    }
}
