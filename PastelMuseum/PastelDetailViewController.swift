//  TODO: Add another init method which supports updating the gradings
//  PastelDetailForm.swift
//  PastelMuseum
//
//  Created by Dian Maisara on 18/10/26.
//

import UIKit

//protocol SubviewDelegate : AnyObject {
//    func subviewWillClose()
//}

// attach the delegate
//    weak var delegate: SubviewDelegate?

//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        delegate?.subviewWillClose()
//    }

class PastelDetailViewController: UIViewController, PastelEditViewControllerDelegate {
    
    // MARK: Protocol-delegate - detail view creates the form to be conformed to by the edit view
    func pastelSwatchEditDidSave(color: String, brand: PastelBrand, colorSwatch: (Int, Int, Int)) {
        item.color = color
        item.brand = brand
        item.colorSwatch = colorSwatch
        
        // refresh details
        nameLabel.text = item.color
        brandLabel.text = item.brand.rawValue
        rgbLabel.text = "RGB \(colorSwatch.0) · \(colorSwatch.1) · \(colorSwatch.2)"
        swatchView.backgroundColor = item.swatchUIColor
    }
    
    var item: Pastel = Pastel(color: "Default", brand: .unknownBrand, id: -1, dateAcquired: Date.now, colorSwatch: (-1, -1, -1))
    
    // the white swatch card, like Pantone!
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
    
    init(item: Pastel) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBrown
        title = "Oil Pastel Details"
        
        let editButton = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(editTapped)
        )
        navigationItem.rightBarButtonItem = editButton
        
        setupElements()
        setupLayout()
    }
    
    private func setupElements() {
        museumLabel.text = "PASTEL MUSEUM"
        nameLabel.text = item.color
        idLabel.text = "No. \(item.id)"
        brandLabel.text = item.brand.rawValue
        dateAcquiredLabel.text = "Acquired \(item.dateAcquired.formatted(date: .abbreviated, time: .omitted))"
//        editSwatchButton.setTitle("Edit swatch details", for: .normal)
        
       
        rgbLabel.text = "RGB \(item.colorSwatch.0) · \(item.colorSwatch.1) · \(item.colorSwatch.2)"
//        } else {
//            rgbLabel.text = "RGB not recorded" // default fallback in case...
//        }
        
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
        
        // card + swatch block
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 4
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.25
        cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cardView.layer.shadowRadius = 6
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        swatchView.backgroundColor = item.swatchUIColor
        swatchView.layer.cornerRadius = 4
        swatchView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        swatchView.translatesAutoresizingMaskIntoConstraints = false
        
        dividerView.backgroundColor = .systemGray4
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cardView)
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
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            cardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            cardView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            
            swatchView.topAnchor.constraint(equalTo: cardView.topAnchor),
            swatchView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            swatchView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            swatchView.heightAnchor.constraint(equalToConstant: 280),
            
            stackView.topAnchor.constraint(equalTo: swatchView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            
            dividerView.heightAnchor.constraint(equalToConstant: 1), // so its super thin
            dividerView.widthAnchor.constraint(equalTo: stackView.widthAnchor) // cut across the whole stack
        ])
    }
    
    // Pastel(color: "Viridian Green", brand: .sennelier, id: 021, dateAcquired: Date(), colorSwatch: (0, 103, 80))
    
    // Mark: Protocol-delegate - edit view declares itself as a reporter which follows through the protocol
    @objc private func editTapped() {
        let editVC = PastelEditViewController(item: item)
        editVC.delegate = self
        let navController = UINavigationController(rootViewController: editVC)
        present(navController, animated: true)
    }
}
