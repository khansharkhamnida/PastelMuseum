import UIKit

class ArtworkEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private enum Section: Int, CaseIterable {
        case photo, details, shades
        
        var header: String? {
            switch self {
            case .photo: return nil
            case .details: return "DETAILS"
            case .shades: return "SHADES USED"
            }
        }
    }
    
    private let artwork: Artwork?
    private let onSave: (Artwork) -> Void
    private let store = PastelStore.shared
    
    private var image: UIImage?
    private var selected: [Pastel]

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private var titleField: UITextField { titleCell.textField }
    private var datePicker: UIDatePicker { dateCell.datePicker }

    private lazy var titleCell: TextFieldRowCell = {
        let cell = TextFieldRowCell()
        cell.configure(title: "Title")
        return cell
    }()
    private lazy var dateCell: DatePickerRowCell = {
        let cell = DatePickerRowCell()
        cell.configure(title: "Created")
        return cell
    }()
    
    init(artwork: Artwork?, onSave: @escaping (Artwork) -> Void) {
        self.artwork = artwork
        self.onSave = onSave
        self.image = artwork?.image
        self.selected = artwork?.pastels ?? []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBrown
        title = artwork == nil ? "Add New Work" : "Edit Work"
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        
        titleField.text = artwork?.title
        titleField.placeholder = "Title of the work"
        titleField.textAlignment = .right
        titleField.returnKeyType = .done
        titleField.delegate = self
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.date = artwork?.dateCreated ?? Date()
        
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
    
    // MARK: - Data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .photo: return 1
        case .details: return 2
        case .shades: return max(store.pastels.count, 1)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .photo:
            return makePhotoCell()
        case .details:
            return indexPath.row == 0 ? titleCell : dateCell
        case .shades:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            var content = cell.defaultContentConfiguration()
            guard !store.pastels.isEmpty else {
                content.text = "No shades yet. Add some in the Swatches tab first."
                content.textProperties.color = .secondaryLabel
                cell.contentConfiguration = content
                cell.selectionStyle = .none
                return cell
            }
            let pastel = store.pastels[indexPath.row]
            content.text = pastel.color
            content.secondaryText = "No. \(pastel.id)  ·  \(pastel.brand.rawValue)"
            content.image = UIImage.swatchCircle(color: pastel.swatchUIColor)
            cell.contentConfiguration = content
            cell.accessoryType = isSelected(pastel) ? .checkmark : .none
            return cell
        }
    }
    
    private func makePhotoCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        if let image {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(imageView)
            let height = imageView.heightAnchor.constraint(equalToConstant: 220)
            height.priority = .defaultHigh
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                height
            ])
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
        } else {
            var content = cell.defaultContentConfiguration()
            content.text = "Add Photo of the Work"
            content.image = UIImage(systemName: "photo.badge.plus")
            content.textProperties.color = .systemBlue
            content.imageProperties.tintColor = .systemBlue
            cell.contentConfiguration = content
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Section(rawValue: section)?.header
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .photo: return image == nil ? nil : "Tap the photo to replace it."
        case .shades: return "Tap a shade to attach or detach it."
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.textColor = UIColor.white.withAlphaComponent(0.8)
    }
    
    // MARK: - Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch Section(rawValue: indexPath.section)! {
        case .photo:
            presentImagePicker()
        case .details:
            break
        case .shades:
            guard !store.pastels.isEmpty else { return }
            let pastel = store.pastels[indexPath.row]
            if let index = selected.firstIndex(where: { $0 === pastel }) {
                selected.remove(at: index)
            } else {
                selected.append(pastel)
            }
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    // MARK: - Helpers
    
    private func isSelected(_ pastel: Pastel) -> Bool {
        selected.contains { $0 === pastel }
    }
    
    // MARK: - Photo picking
    
    private func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        present(picker, animated: true)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let picked = info[.originalImage] as? UIImage else { return }
        image = picked
        tableView.reloadSections(IndexSet(integer: Section.photo.rawValue), with: .automatic)
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = .clear
    }
    
    // MARK: - Actions
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func doneTapped() {
        let name = titleField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        guard !name.isEmpty else {
            titleField.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
            titleField.layer.cornerRadius = 6
            return
        }
        
        let target = artwork ?? Artwork()
        target.title = name
        target.dateCreated = datePicker.date
        target.image = image
        target.pastels = selected
        
        onSave(target)
        dismiss(animated: true)
    }
}
