import UIKit

class PastelListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PastelEditViewControllerDelegate {

    private let tableView = UITableView()
    private let emptyLabel = UILabel()

    private var pastels: [Pastel] = [
        Pastel(color: "Jazzberry Jam", brand: .mungyo, id: 276, colorSwatch: (198, 1, 49)),
        Pastel(color: "Viridian Green", brand: .sennelier, id: 21, colorSwatch: (0, 103, 80))
    ]

    // MARK: - Create (called by the Add form)
    func pastelSwatchEditDidSave(color: String, brand: PastelBrand, id: Int, dateAcquired: Date, colorSwatch: (Int, Int, Int)) {
        let pastel = Pastel(color: color, brand: brand, id: id, dateAcquired: dateAcquired, colorSwatch: colorSwatch)
        pastels.append(pastel)
        tableView.reloadData()
        updateEmptyState()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBrown
        title = "My Pastels"

        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )

        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()   // picks up edits made on the detail screen
        updateEmptyState()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PastelTableCell.self, forCellReuseIdentifier: PastelTableCell.identifier)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .systemBrown
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150

        emptyLabel.text = "No pastels yet.\nTap + to add one."
        emptyLabel.numberOfLines = 0
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }

    private func updateEmptyState() {
        emptyLabel.isHidden = !pastels.isEmpty
    }

    // MARK: - Table

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pastels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PastelTableCell.identifier,
            for: indexPath
        ) as? PastelTableCell else {
            return UITableViewCell()
        }
        cell.configure(with: pastels[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = PastelDetailViewController(item: pastels[indexPath.row], allPastels: pastels)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: - Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            pastels.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateEmptyState()
        }
    }

    @objc private func addTapped() {
        let addVC = PastelEditViewController(item: nil, allPastels: pastels)
        addVC.delegate = self
        present(UINavigationController(rootViewController: addVC), animated: true)
    }
}

#Preview {
    UINavigationController(rootViewController: PastelListViewController())
}
