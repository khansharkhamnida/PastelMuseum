import UIKit

class PastelListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PastelEditViewControllerDelegate {
    
    private let tableView = UITableView()
    private let store = PastelStore.shared
    private var pastelsDisplay: [Pastel] { store.pastels }

    func pastelSwatchEditDidSave(color: String, brand: PastelBrand, id: Int, dateAcquired: Date, colorSwatch: (Int, Int, Int)) {
        let pastel = Pastel(color: color, brand: brand, id: id, dateAcquired: dateAcquired, colorSwatch: colorSwatch)
        store.pastels.append(pastel)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBrown
        title = "My Pastels"

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )

        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastelsDisplay.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PastelTableCell.identifier,
            for: indexPath
        ) as? PastelTableCell else {
            return UITableViewCell()
        }

        cell.configure(with: pastelsDisplay[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < pastelsDisplay.count else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = PastelDetailViewController(item: pastelsDisplay[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            store.removePastel(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    @objc private func addTapped() {
        let addVC = PastelEditViewController(item: nil)
        addVC.delegate = self
        present(UINavigationController(rootViewController: addVC), animated: true)
    }
}
