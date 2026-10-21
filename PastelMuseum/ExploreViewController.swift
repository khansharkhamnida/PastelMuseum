import UIKit

class ExploreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    private let store = PastelStore.shared

    private enum Section: Int, CaseIterable {
        case popularShades, otherArtists

        var header: String {
            switch self {
            case .popularShades: return "POPULAR SHADES"
            case .otherArtists: return "FROM OTHER ARTISTS"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBrown
        title = "Explore"

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white

        setupTableView()
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
        tableView.register(ArtworkTableCell.self, forCellReuseIdentifier: ArtworkTableCell.identifier)
        tableView.register(PastelTableCell.self, forCellReuseIdentifier: PastelTableCell.identifier)
        tableView.backgroundColor = .systemBrown
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 280
        tableView.showsVerticalScrollIndicator = false
    }

    // MARK: - Table

    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .popularShades: return store.explorePastels.count
        case .otherArtists: return store.exploreArtworks.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .popularShades:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PastelTableCell.identifier,
                for: indexPath
            ) as? PastelTableCell else {
                return UITableViewCell()
            }
            cell.configure(with: store.explorePastels[indexPath.row])
            return cell
        case .otherArtists:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ArtworkTableCell.identifier,
                for: indexPath
            ) as? ArtworkTableCell else {
                return UITableViewCell()
            }
            cell.configure(with: store.exploreArtworks[indexPath.row])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .systemBrown

        let label = UILabel()
        label.text = Section(rawValue: section)?.header
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            label.topAnchor.constraint(equalTo: header.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -8)
        ])

        return header
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch Section(rawValue: indexPath.section)! {
        case .popularShades:
            let detailVC = PastelDetailViewController(item: store.explorePastels[indexPath.row])
            navigationController?.pushViewController(detailVC, animated: true)
        case .otherArtists:
            let detailVC = ArtworkDetailViewController(artwork: store.exploreArtworks[indexPath.row])
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
