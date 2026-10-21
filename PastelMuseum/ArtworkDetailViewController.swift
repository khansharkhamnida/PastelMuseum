import UIKit

class ArtworkDetailViewController: UIViewController {
    
    private let artwork: Artwork
    private let isOwnedArtwork: Bool

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let cardView = UIView()
    private let photoView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    
    private let shadesCaption = UILabel()
    private let shadesStack = UIStackView()

    private let commentsCaption = UILabel()
    private let commentsStack = UIStackView()
    private let addCommentButton = UIButton(type: .system)

    init(artwork: Artwork) {
        self.artwork = artwork
        self.isOwnedArtwork = PastelStore.shared.artworks.contains { $0 === artwork }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBrown
        title = "Work Details"
        navigationController?.navigationBar.tintColor = .white
        if isOwnedArtwork {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .edit,
                target: self,
                action: #selector(editTapped)
            )
        }

        setupElements()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshContent()
    }
    
    private func setupElements() {
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 4
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.25
        cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cardView.layer.shadowRadius = 6
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        photoView.backgroundColor = .systemGray5
        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = 4
        photoView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        photoView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.font = UIFont.systemFont(ofSize: 13)
        dateLabel.textColor = .darkGray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        shadesCaption.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        shadesCaption.textColor = .white
        
        shadesStack.axis = .vertical
        shadesStack.spacing = 10

        commentsCaption.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        commentsCaption.textColor = .white

        commentsStack.axis = .vertical
        commentsStack.spacing = 10

        addCommentButton.setTitle("+ Add Comment", for: .normal)
        addCommentButton.tintColor = .white
        addCommentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        addCommentButton.contentHorizontalAlignment = .leading
        addCommentButton.addTarget(self, action: #selector(addCommentTapped), for: .touchUpInside)

        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        cardView.addSubview(photoView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(dateLabel)

        contentStack.addArrangedSubview(cardView)
        contentStack.addArrangedSubview(shadesCaption)
        contentStack.addArrangedSubview(shadesStack)
        contentStack.addArrangedSubview(commentsCaption)
        contentStack.addArrangedSubview(addCommentButton)
        contentStack.addArrangedSubview(commentsStack)
        contentStack.setCustomSpacing(24, after: cardView)
        contentStack.setCustomSpacing(24, after: shadesStack)
        contentStack.setCustomSpacing(8, after: addCommentButton)
    }
    
    private func setupLayout() {
        let content = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: content.topAnchor, constant: 24),
            contentStack.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 30),
            contentStack.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -30),
            contentStack.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -24),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -60),
            
            photoView.topAnchor.constraint(equalTo: cardView.topAnchor),
            photoView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            photoView.heightAnchor.constraint(equalToConstant: 320),
            
            titleLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }
    
    private func refreshContent() {
        titleLabel.text = artwork.title
        dateLabel.text = "Created \(artwork.dateCreated.formatted(date: .abbreviated, time: .omitted))"
        photoView.image = artwork.image
        
        shadesCaption.attributedText = NSAttributedString(
            string: "SHADES USED (\(artwork.pastels.count))",
            attributes: [.kern: 2.0]
        )
        
        shadesStack.arrangedSubviews.forEach {
            shadesStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        if artwork.pastels.isEmpty {
            let empty = UILabel()
            empty.text = "No shades attached yet."
            empty.textColor = UIColor.white.withAlphaComponent(0.8)
            empty.font = UIFont.systemFont(ofSize: 14)
            shadesStack.addArrangedSubview(empty)
            return
        }
        
        for pastel in artwork.pastels {
            let card = ShadeCardView(pastel: pastel) { [weak self] in
                self?.navigationController?.pushViewController(PastelDetailViewController(item: pastel), animated: true)
            }
            shadesStack.addArrangedSubview(card)
        }

        commentsCaption.attributedText = NSAttributedString(
            string: "COMMENTS (\(artwork.comments.count))",
            attributes: [.kern: 2.0]
        )

        commentsStack.arrangedSubviews.forEach {
            commentsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        if artwork.comments.isEmpty {
            let empty = UILabel()
            empty.text = "No comments yet. Be the first to say something!"
            empty.textColor = UIColor.white.withAlphaComponent(0.8)
            empty.font = UIFont.systemFont(ofSize: 14)
            commentsStack.addArrangedSubview(empty)
        } else {
            for comment in artwork.comments {
                let card = CommentCardView(comment: comment) { [weak self] emoji in
                    self?.react(to: comment, with: emoji)
                }
                commentsStack.addArrangedSubview(card)
            }
        }
    }

    private func react(to comment: Comment, with emoji: String) {
        comment.toggleReaction(emoji)
        refreshContent()
    }

    @objc private func addCommentTapped() {
        let alert = UIAlertController(title: "Add Comment", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Your name" }
        alert.addTextField { $0.placeholder = "Your comment" }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Post", style: .default) { [weak self, weak alert] _ in
            guard let self, let alert else { return }
            let name = alert.textFields?[0].text?.trimmingCharacters(in: .whitespaces) ?? ""
            let text = alert.textFields?[1].text?.trimmingCharacters(in: .whitespaces) ?? ""
            guard !name.isEmpty, !text.isEmpty else { return }
            self.artwork.comments.append(Comment(name: name, text: text))
            self.refreshContent()
        })

        present(alert, animated: true)
    }

    @objc private func editTapped() {
        let form = ArtworkEditViewController(artwork: artwork) { [weak self] _ in
            self?.refreshContent()
        }
        present(UINavigationController(rootViewController: form), animated: true)
    }
}

// MARK: - A small horizontal swatch card for one shade

private final class ShadeCardView: UIView {
    private let onTap: () -> Void
    
    init(pastel: Pastel, onTap: @escaping () -> Void) {
        self.onTap = onTap
        super.init(frame: .zero)
        
        backgroundColor = .white
        layer.cornerRadius = 4
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
        let swatch = UIView()
        swatch.backgroundColor = pastel.swatchUIColor
        swatch.layer.cornerRadius = 4
        swatch.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        swatch.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = pastel.color
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0
        
        let infoLabel = UILabel()
        infoLabel.text = "No. \(pastel.id)  ·  \(pastel.brand.rawValue)"
        infoLabel.font = UIFont.systemFont(ofSize: 13)
        infoLabel.textColor = .darkGray
        infoLabel.numberOfLines = 0
        
        let textStack = UIStackView(arrangedSubviews: [nameLabel, infoLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(swatch)
        addSubview(textStack)
        
        let minHeight = heightAnchor.constraint(greaterThanOrEqualToConstant: 64)
        NSLayoutConstraint.activate([
            minHeight,
            swatch.topAnchor.constraint(equalTo: topAnchor),
            swatch.bottomAnchor.constraint(equalTo: bottomAnchor),
            swatch.leadingAnchor.constraint(equalTo: leadingAnchor),
            swatch.widthAnchor.constraint(equalToConstant: 64),
            
            textStack.leadingAnchor.constraint(equalTo: swatch.trailingAnchor, constant: 12),
            textStack.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 10),
            textStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10),
            textStack.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapped() {
        onTap()
    }
}

// MARK: - A guestbook-style comment card with emoji reactions

private final class CommentCardView: UIView {
    private let comment: Comment
    private let onReact: (String) -> Void
    private let reactionsStack = UIStackView()

    private static let availableEmoji = ["❤️", "👍", "😍", "🔥"]

    init(comment: Comment, onReact: @escaping (String) -> Void) {
        self.comment = comment
        self.onReact = onReact
        super.init(frame: .zero)

        backgroundColor = .white
        layer.cornerRadius = 4
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4

        let nameLabel = UILabel()
        nameLabel.text = comment.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        nameLabel.textColor = .black

        let dateLabel = UILabel()
        dateLabel.text = comment.date.formatted(date: .abbreviated, time: .shortened)
        dateLabel.font = UIFont.systemFont(ofSize: 11)
        dateLabel.textColor = .darkGray

        let headerStack = UIStackView(arrangedSubviews: [nameLabel, dateLabel])
        headerStack.axis = .horizontal
        headerStack.distribution = .equalSpacing

        let textLabel = UILabel()
        textLabel.text = comment.text
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.textColor = .black
        textLabel.numberOfLines = 0

        reactionsStack.axis = .horizontal
        reactionsStack.spacing = 6
        rebuildReactionButtons()

        let textStack = UIStackView(arrangedSubviews: [headerStack, textLabel, reactionsStack])
        textStack.axis = .vertical
        textStack.spacing = 6
        textStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(textStack)
        NSLayoutConstraint.activate([
            textStack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            textStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            textStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func rebuildReactionButtons() {
        reactionsStack.arrangedSubviews.forEach {
            reactionsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        for emoji in Self.availableEmoji {
            let count = comment.reactions[emoji] ?? 0
            let reacted = comment.myReactions.contains(emoji)
            let button = UIButton(type: .system)
            button.setTitle(count > 0 ? "\(emoji) \(count)" : emoji, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            button.tintColor = reacted ? .systemBlue : .darkGray
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
            button.addAction(UIAction { [weak self] _ in
                self?.onReact(emoji)
            }, for: .touchUpInside)
            reactionsStack.addArrangedSubview(button)
        }
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        reactionsStack.addArrangedSubview(spacer)
    }
}
