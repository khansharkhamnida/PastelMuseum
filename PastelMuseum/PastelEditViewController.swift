import UIKit

protocol PastelEditViewControllerDelegate: AnyObject {
    func pastelSwatchEditDidSave(color: String,
                                 brand: PastelBrand,
                                 id: Int,
                                 dateAcquired: Date,
                                 colorSwatch: (Int, Int, Int))
}

class PastelEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    weak var delegate: PastelEditViewControllerDelegate?

    var item: Pastel?
    private let allPastels: [Pastel]

    private enum Section: Int, CaseIterable {
        case swatch, details

        var header: String? {
            switch self {
            case .swatch: return nil
            case .details: return "DETAILS"
            }
        }
    }
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let previewView = UIView()
    private var colorWell: UIColorWell { colorCell.colorWell }
    private var nameField: UITextField { nameCell.textField }
    private var idField: UITextField { idCell.textField }
    private var brandButton: UIButton { brandCell.brandButton }
    private var datePicker: UIDatePicker { dateCell.datePicker }

    private var selectedBrand: PastelBrand = .unknownBrand

    private lazy var previewCell = makePreviewCell()
    private lazy var colorCell: ColorWellRowCell = {
        let cell = ColorWellRowCell()
        cell.configure(title: "Swatch")
        return cell
    }()
    private lazy var nameCell: TextFieldRowCell = {
        let cell = TextFieldRowCell()
        cell.configure(title: "Name")
        return cell
    }()
    private lazy var brandCell: BrandMenuRowCell = {
        let cell = BrandMenuRowCell()
        cell.configure(title: "Brand")
        return cell
    }()
    private lazy var idCell: TextFieldRowCell = {
        let cell = TextFieldRowCell()
        cell.configure(title: "ID No.")
        return cell
    }()
    private lazy var dateCell: DatePickerRowCell = {
        let cell = DatePickerRowCell()
        cell.configure(title: "Acquired")
        return cell
    }()

    init(item: Pastel?, allPastels: [Pastel]) {
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
        title = item == nil ? "Add New Oil Pastel" : "Edit Swatch"
        
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
        
        configureControls()
        setupTableView()
    }
    
    // MARK: - Setup
    
    private func configureControls() {
        selectedBrand = item?.brand ?? .unknownBrand

        nameField.text = item?.color
        nameField.placeholder = "Color name"
        nameField.textAlignment = .right
        nameField.returnKeyType = .done
        nameField.delegate = self
        
        idField.text = String(item?.id ?? ((allPastels.map(\.id).max() ?? 0) + 1))
        idField.placeholder = "e.g. 276"
        idField.textAlignment = .right
        idField.keyboardType = .numberPad
        idField.delegate = self
        
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.baseForegroundColor = .label
        brandButton.configuration = buttonConfig
        brandButton.contentHorizontalAlignment = .trailing
        brandButton.showsMenuAsPrimaryAction = true
        updateBrandMenu()
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.date = item?.dateAcquired ?? Date()
        
        colorWell.title = "Swatch color"
        colorWell.supportsAlpha = false
        colorWell.selectedColor = item?.swatchUIColor ?? .systemGray4
        colorWell.addTarget(self, action: #selector(colorChanged), for: .valueChanged)
        colorWell.translatesAutoresizingMaskIntoConstraints = false
        colorWell.widthAnchor.constraint(equalToConstant: 44).isActive = true
        colorWell.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        previewView.backgroundColor = colorWell.selectedColor
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.backgroundColor = .systemBrown
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func makePreviewCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.selectionStyle = .none
        previewView.layer.cornerRadius = 8
        previewView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(previewView)
        
        let bottom = previewView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -12)
        bottom.priority = .defaultHigh
        NSLayoutConstraint.activate([
            previewView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 12),
            previewView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            previewView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            previewView.heightAnchor.constraint(equalToConstant: 110),
            bottom
        ])
        return cell
    }
    
    // MARK: - Table data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .swatch: return 2
        case .details: return 4
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .swatch:
            return indexPath.row == 0 ? previewCell : colorCell
        case .details:
            return [nameCell, brandCell, idCell, dateCell][indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Section(rawValue: section)?.header
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        nil
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.textColor = UIColor.white.withAlphaComponent(0.8)
    }
    
    // MARK: - Table delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    private func flag(_ field: UITextField) {
        field.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
        field.layer.cornerRadius = 6
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = .clear
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
            flag(nameField)
            return
        }
        
        guard let id = Int((idField.text ?? "").trimmingCharacters(in: .whitespaces)) else {
            flag(idField)
            return
        }
        
        if allPastels.contains(where: { $0.id == id && $0 !== item }) {
            let alert = UIAlertController(
                title: "ID already in use",
                message: "Another pastel is already numbered \(id). Pick a different number.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let swatch = rgbTuple(from: colorWell.selectedColor ?? .systemGray4)
        delegate?.pastelSwatchEditDidSave(
            color: name,
            brand: selectedBrand,
            id: id,
            dateAcquired: datePicker.date,
            colorSwatch: swatch
        )
        dismiss(animated: true)
    }
}
