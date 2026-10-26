import UIKit


class PastelListViewController: UIViewController,UITableViewDelegate, PastelEditViewControllerDelegate, PastelDetailViewControllerDelegate{

    private var dataSource:
        UITableViewDiffableDataSource<PastelSection, UUID>!
    
    private let tableView = UITableView()
    private let emptyLabel = UILabel()

    private var pastels: [Pastel] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pastels = PastelDataStore.shared.loadPastels()
        
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
        applySnapshot()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        pastels = PastelDataStore.shared.loadPastels()
        applySnapshot()
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
        
        tableView.register(
            PastelTableCell.self,
            forCellReuseIdentifier: PastelTableCell.identifier
        )

        dataSource = PastelTableDataSource.make(
            for: tableView,
            pastels: { [weak self] in
                self?.pastels ?? []
            }
        )
        
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

    private func applySnapshot() {
        var snapshot =
            NSDiffableDataSourceSnapshot<PastelSection, UUID>()

        snapshot.appendSections([.main])
        snapshot.appendItems(
            pastels.map(\.id),
            toSection: .main
        )

        dataSource.apply(snapshot, animatingDifferences: true)
        updateEmptyState()
    }
    
    private func updateEmptyState() {
        emptyLabel.isHidden = !pastels.isEmpty
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = PastelDetailViewController(item: pastels[indexPath.row], allPastels: pastels)
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - Delete
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else { return }

        let snapshot = dataSource.snapshot()
        let itemIDs = snapshot.itemIdentifiers(inSection: .main)

        guard itemIDs.indices.contains(indexPath.row) else { return }

        let id = itemIDs[indexPath.row]

        pastels.removeAll { $0.id == id }

        PastelDataStore.shared.savePastels(pastels)
        applySnapshot()
    }


    @objc private func addTapped() {
        print("Add button tapped")

        let addVC = PastelEditViewController(
            item: nil,
            allPastels: pastels
        )
        addVC.delegate = self

        let navController = UINavigationController(
            rootViewController: addVC
        )

        present(navController, animated: true) {
            print("Add form presented")
        }
    }

    private func upsertPastel(_ pastel: Pastel) {
        guard let index = pastels.firstIndex(where: { $0.id == pastel.id }) else {
            print("Could not find pastel to update: \(pastel.id)")
            return
        }

        pastels[index] = pastel
        PastelDataStore.shared.savePastels(pastels)

        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems([pastel.id])
        dataSource.apply(snapshot, animatingDifferences: true)

        updateEmptyState()
    }


    // C → A: add or edit
    func pastelSwatchEditDidSave(_ pastel: Pastel) {
        if let index = pastels.firstIndex(where: { $0.id == pastel.id }) {
            pastels[index] = pastel
        } else {
            pastels.append(pastel)
        }

        PastelDataStore.shared.savePastels(pastels)
        applySnapshot()
    }

    // B → A: edit an existing pastel
    func pastelDetailDidSave(_ pastel: Pastel) {
        upsertPastel(pastel)
    }
}

#Preview {
    UINavigationController(rootViewController: PastelListViewController())
}
