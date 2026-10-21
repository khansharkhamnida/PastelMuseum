import UIKit

class PastelDetailViewController: UIViewController, PastelEditViewControllerDelegate {
    
    // MARK: Protocol-delegate - detail view creates the form to be conformed to by the edit view
    func pastelSwatchEditDidSave(color: String, brand: PastelBrand, id: Int, dateAcquired: Date, colorSwatch: (Int, Int, Int)) {
        item.color = color
        item.brand = brand
        item.id = id
        item.dateAcquired = dateAcquired
        item.colorSwatch = colorSwatch
        refreshContent()
    }
    
    var item: Pastel = Pastel(color: "Default", brand: .unknownBrand, id: -1, dateAcquired: Date.now, colorSwatch: (-1, -1, -1))
    private let isOwnedPastel: Bool
    private let store = PastelStore.shared

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
    
    private let galleryCaption = UILabel()
    private let galleryScroll = UIScrollView()
    private let galleryStack = UIStackView()
    
    init(item: Pastel) {
        self.item = item
        self.isOwnedPastel = PastelStore.shared.pastels.contains { $0 === item }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBrown
        title = "Oil Pastel Details"

        if isOwnedPastel {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .edit,
                target: self,
                action: #selector(editTapped)
            )
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(addToMyPastelsTapped)
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
        museumLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        museumLabel.textColor = .gray
        museumLabel.attributedText = NSAttributedString(
            string: "PASTEL MUSEUM",
            attributes: [.kern: 2.0]
        )
        
        galleryCaption.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        galleryCaption.textColor = .gray
        galleryCaption.attributedText = NSAttributedString(
            string: "WORKS WITH THIS SHADE",
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
        
        galleryStack.axis = .horizontal
        galleryStack.spacing = 8
        galleryStack.translatesAutoresizingMaskIntoConstraints = false
        galleryScroll.showsHorizontalScrollIndicator = false
        galleryScroll.translatesAutoresizingMaskIntoConstraints = false
        galleryScroll.addSubview(galleryStack)
        
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
        stackView.addArrangedSubview(galleryCaption)
        stackView.addArrangedSubview(galleryScroll)
        
        stackView.setCustomSpacing(12, after: nameLabel)
        stackView.setCustomSpacing(12, after: dividerView)
        stackView.setCustomSpacing(20, after: dateAcquiredLabel)
        
        refreshContent()
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
            dividerView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            
            galleryScroll.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            galleryScroll.heightAnchor.constraint(equalToConstant: 96),
            galleryStack.topAnchor.constraint(equalTo: galleryScroll.contentLayoutGuide.topAnchor),
            galleryStack.bottomAnchor.constraint(equalTo: galleryScroll.contentLayoutGuide.bottomAnchor),
            galleryStack.leadingAnchor.constraint(equalTo: galleryScroll.contentLayoutGuide.leadingAnchor),
            galleryStack.trailingAnchor.constraint(equalTo: galleryScroll.contentLayoutGuide.trailingAnchor),
            galleryStack.heightAnchor.constraint(equalTo: galleryScroll.frameLayoutGuide.heightAnchor)
        ])
    }
    
    private var galleryImages: [UIImage] {
        PastelStore.shared.artworks(using: item).compactMap { $0.image }
    }

    private func refreshContent() {
        nameLabel.text = item.color
        idLabel.text = "No. \(item.id)"
        brandLabel.text = item.brand.rawValue
        dateAcquiredLabel.text = "Acquired \(item.dateAcquired.formatted(date: .abbreviated, time: .omitted))"
        rgbLabel.text = "RGB \(item.colorSwatch.0) · \(item.colorSwatch.1) · \(item.colorSwatch.2)"
        swatchView.backgroundColor = item.swatchUIColor
        
        galleryStack.arrangedSubviews.forEach {
            galleryStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        let images = galleryImages
        for image in images {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 4
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 96).isActive = true
            galleryStack.addArrangedSubview(imageView)
        }
        galleryCaption.isHidden = images.isEmpty
        galleryScroll.isHidden = images.isEmpty
    }
    
    // MARK: Protocol-delegate - edit view declares itself as a reporter which follows through the protocol
    @objc private func editTapped() {
        let editVC = PastelEditViewController(item: item)
        editVC.delegate = self
        let navController = UINavigationController(rootViewController: editVC)
        present(navController, animated: true)
    }

    @objc private func addToMyPastelsTapped() {
        guard !store.pastels.contains(where: { $0.id == item.id }) else {
            let alert = UIAlertController(title: "Already Added", message: "\"\(item.color)\" is already in My Pastels.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let copy = Pastel(
            color: item.color,
            brand: item.brand,
            id: item.id,
            dateAcquired: Date(),
            colorSwatch: item.colorSwatch
        )
        store.pastels.append(copy)

        let alert = UIAlertController(title: "Added", message: "\"\(item.color)\" was added to My Pastels.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
