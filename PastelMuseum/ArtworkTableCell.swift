import UIKit

class ArtworkTableCell: UITableViewCell {
    static let identifier = "ArtworkTableCell"

    private let cardView = UIView()
    private let photoView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let dotsStack = UIStackView()

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

        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 4
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        cardView.translatesAutoresizingMaskIntoConstraints = false

        photoView.backgroundColor = .systemGray4
        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = 4
        photoView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        photoView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.font = UIFont.systemFont(ofSize: 13)
        subtitleLabel.textColor = .darkGray
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        dotsStack.axis = .horizontal
        dotsStack.spacing = 4
        dotsStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(cardView)
        cardView.addSubview(photoView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)
        cardView.addSubview(dotsStack)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            photoView.topAnchor.constraint(equalTo: cardView.topAnchor),
            photoView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            photoView.heightAnchor.constraint(equalToConstant: 180),

            titleLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            dotsStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            dotsStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dotsStack.heightAnchor.constraint(equalToConstant: 14),
            dotsStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with artwork: Artwork) {
        titleLabel.text = artwork.title
        let count = artwork.pastels.count
        let date = artwork.dateCreated.formatted(date: .abbreviated, time: .omitted)
        subtitleLabel.text = "\(date)  ·  \(count) shade\(count == 1 ? "" : "s")"
        photoView.image = artwork.image

        dotsStack.arrangedSubviews.forEach {
            dotsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        for pastel in artwork.pastels.prefix(12) {
            let dot = UIView()
            dot.backgroundColor = pastel.swatchUIColor
            dot.layer.cornerRadius = 7
            dot.layer.borderWidth = 0.5
            dot.layer.borderColor = UIColor.systemGray3.cgColor
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.widthAnchor.constraint(equalToConstant: 14).isActive = true
            dotsStack.addArrangedSubview(dot)
        }
    }
}
