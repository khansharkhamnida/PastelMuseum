// 
//  PastelFormViewController.swift
//  PastelMuseum
//
//  Created by Dian Maisara on 18/10/26.
//

import UIKit

protocol PastelEditViewControllerDelegate: AnyObject {
    func pastelSwatchEditDidSave(color: String, brand: PastelBrand, colorSwatch: (Int, Int, Int)) // TODO: Add photo
}

class PastelEditViewController: UIViewController, UINavigationControllerDelegate {
    
    // attach the delegate
    weak var delegate: PastelEditViewControllerDelegate?
    
    var item: Pastel?
    
    private let stackView = UIStackView()
    private let previewView = UIView()
    private let nameField = UITextField()
    private let brandButton = UIButton(type: .system)
    private let colorWell = UIColorWell()
    private var selectedBrand: PastelBrand = .unknownBrand
    
    init(item: Pastel?) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBrown
        title = "Edit Swatch"
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneTapped)
        )
        
        setupElements()
        setupLayout()
    }
    
    private func setupElements() {
        // set field values from pastel being edited
        selectedBrand = item?.brand ?? .unknownBrand
        
        nameField.text = item?.color
        nameField.placeholder = "Color name"
        nameField.borderStyle = .roundedRect
        nameField.backgroundColor = .white
        nameField.textColor = .black
        nameField.font = UIFont.systemFont(ofSize: 18)
        nameField.translatesAutoresizingMaskIntoConstraints = false
        
        // brand picker opens a menu of every PastelBrand
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.baseBackgroundColor = .white
        buttonConfig.baseForegroundColor = .black
        buttonConfig.cornerStyle = .medium
        brandButton.configuration = buttonConfig
        brandButton.contentHorizontalAlignment = .leading
        brandButton.showsMenuAsPrimaryAction = true
        brandButton.translatesAutoresizingMaskIntoConstraints = false
        updateBrandMenu()
        
        // color well = color picker
        colorWell.title = "Swatch color"
        colorWell.supportsAlpha = false
        colorWell.selectedColor = item?.swatchUIColor ?? .systemGray4 // in case...
        colorWell.addTarget(self, action: #selector(colorChanged), for: .valueChanged)
        colorWell.translatesAutoresizingMaskIntoConstraints = false
        
        // live preview so you can see the color while picking
        previewView.backgroundColor = colorWell.selectedColor
        previewView.layer.cornerRadius = 4
        previewView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(previewView)
        stackView.addArrangedSubview(makeCaptionLabel("COLOR NAME"))
        stackView.addArrangedSubview(nameField)
        stackView.addArrangedSubview(makeCaptionLabel("BRAND"))
        stackView.addArrangedSubview(brandButton)
        stackView.addArrangedSubview(makeCaptionLabel("SWATCH COLOR"))
        stackView.addArrangedSubview(colorWell)
        
        stackView.setCustomSpacing(24, after: previewView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            
            previewView.heightAnchor.constraint(equalToConstant: 140),
            nameField.heightAnchor.constraint(equalToConstant: 44),
            brandButton.heightAnchor.constraint(equalToConstant: 44),
            colorWell.heightAnchor.constraint(equalToConstant: 44),
            colorWell.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Helpers
    
    private func makeCaptionLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .white
        label.attributedText = NSAttributedString(string: text, attributes: [.kern: 2.0])
        return label
    }
    
    private func updateBrandMenu() {
        let actions = PastelBrand.allCases.map { brand in
            UIAction(title: brand.rawValue, state: brand == selectedBrand ? .on : .off) { [weak self] _ in
                self?.selectedBrand = brand
                self?.updateBrandMenu()
            }
        }
        brandButton.menu = UIMenu(children: actions)
        brandButton.configuration?.title = selectedBrand.rawValue
    }
    
    // turns the picked UIColor back into the (R, G, B) tuple Pastel stores
    private func rgbTuple(from color: UIColor) -> (Int, Int, Int) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        func to255(_ value: CGFloat) -> Int {
            return min(max(Int((value * 255).rounded()), 0), 255)
        }
        return (to255(red), to255(green), to255(blue))
    }
    
    // MARK: - Actions
    
    @objc private func colorChanged() {
        previewView.backgroundColor = colorWell.selectedColor
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func doneTapped() {
        let name = nameField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        guard !name.isEmpty else {
            // no name yet, tint so its a bit obvious...
            nameField.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
            return
        }
        
        let swatch = rgbTuple(from: colorWell.selectedColor ?? .systemGray4)
        delegate?.pastelSwatchEditDidSave(color: name, brand: selectedBrand, colorSwatch: swatch)
        dismiss(animated: true)
    }
}
