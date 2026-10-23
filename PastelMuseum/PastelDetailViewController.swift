import UIKit

protocol PastelDetailViewControllerDelegate: AnyObject {
    func pastelDetailDidSave(_ pastel: Pastel)
}

class PastelDetailViewController: UIViewController, PastelEditViewControllerDelegate {

    weak var delegate: PastelDetailViewControllerDelegate?

    // MARK: - Update (called by the Edit form)

    private var item: Pastel
    private var allPastels: [Pastel]

    private let scrollView = UIScrollView()
    private let cardView = UIView()
    private let swatchView = UIView()
    private let stackView = UIStackView()

    private let museumLabel = UILabel()
    private let nameLabel = UILabel()
    private let dividerView = UIView()
    private let idLabel = UILabel()
    private let brandLabel = UILabel()
    private let rgbLabel = UILabel()
    private let dateAcquiredLabel = UILabel()

    init(item: Pastel, allPastels: [Pastel]) {
        self.item = item
        self.allPastels = allPastels
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBrown
        title = "Oil Pastel Details"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(editTapped)
        )

        setupElements()
        setupLayout()
        refreshContent()
    }

    private func setupElements() {
        museumLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        museumLabel.textColor = .gray
        museumLabel.attributedText = NSAttributedString(
            string: "PASTEL MUSEUM",
            attributes: [.kern: 2.0]
        )

        nameLabel.font = UIFont.boldSystemFont(ofSize: 26)
        idLabel.font = UIFont.monospacedSystemFont(ofSize: 15, weight: .medium)
        brandLabel.font = UIFont.systemFont(ofSize: 15)
        rgbLabel.font = UIFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        dateAcquiredLabel.font = UIFont.systemFont(ofSize: 13)

        nameLabel.textColor = .black
        idLabel.textColor = .black
        brandLabel.textColor = .black
        rgbLabel.textColor = .darkGray
        dateAcquiredLabel.textColor = .darkGray

        nameLabel.numberOfLines = 0

        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 4
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.25
        cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cardView.layer.shadowRadius = 6
        cardView.translatesAutoresizingMaskIntoConstraints = false

        swatchView.layer.cornerRadius = 4
        swatchView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        swatchView.translatesAutoresizingMaskIntoConstraints = false

        dividerView.backgroundColor = .systemGray4
        dividerView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(cardView)
        cardView.addSubview(swatchView)
        cardView.addSubview(stackView)

        stackView.addArrangedSubview(museumLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(dividerView)
        stackView.addArrangedSubview(idLabel)
        stackView.addArrangedSubview(brandLabel)
        stackView.addArrangedSubview(rgbLabel)
        stackView.addArrangedSubview(dateAcquiredLabel)

        stackView.setCustomSpacing(12, after: nameLabel)
        stackView.setCustomSpacing(12, after: dividerView)
    }

    private func setupLayout() {
        let content = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            cardView.topAnchor.constraint(equalTo: content.topAnchor, constant: 24),
            cardView.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 30),
            cardView.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -30),
            cardView.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -24),
            cardView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -60),

            swatchView.topAnchor.constraint(equalTo: cardView.topAnchor),
            swatchView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            swatchView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            swatchView.heightAnchor.constraint(equalToConstant: 280),

            stackView.topAnchor.constraint(equalTo: swatchView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),

            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }

    private func refreshContent() {
        nameLabel.text = item.color
        idLabel.text = "No. \(item.colorID)"
        brandLabel.text = item.brand.rawValue
        dateAcquiredLabel.text = "Acquired \(item.dateAcquired.formatted(date: .abbreviated, time: .omitted))"
        rgbLabel.text = "RGB \(item.colorSwatch.0) · \(item.colorSwatch.1) · \(item.colorSwatch.2)"
        swatchView.backgroundColor = item.swatchUIColor
    }

    @objc private func editTapped() {
        let editVC = PastelEditViewController(item: item, allPastels: allPastels)
        editVC.delegate = self
        present(UINavigationController(rootViewController: editVC), animated: true)
    }
    
    func pastelSwatchEditDidSave(_ pastel: Pastel) {
        item = pastel

        if let index = allPastels.firstIndex(where: { $0.id == pastel.id }) {
            allPastels[index] = pastel
        } else {
            allPastels.append(pastel)
        }

        refreshContent()

        // Notify A (ListView) that the pastel changed.
        delegate?.pastelDetailDidSave(pastel)
    }
}
