//
//  ViewController.swift
//  PastelMuseum
//
//  Created by Dian Maisara on 18/10/26.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    
    private let pastelsDisplay = [
        Pastel(color: "Jazzberry Jam", brand: .mungyo, id: 276, dateAcquired: Date(), colorSwatch: (198, 1, 49)),
        Pastel(color: "Viridian Green", brand: .sennelier, id: 021, dateAcquired: Date(), colorSwatch: (0, 103, 80))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBrown
        title = "Pastel Museum 🎨"

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(PastelTableCell.self, forCellReuseIdentifier: PastelTableCell.identifier)
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .systemBrown
        // swatch float aka no divider lines
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastelsDisplay.count // since there is no more info tab
    }
    
    // retrieve all the cells
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
    
    // push up the navigation push controller...
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard indexPath.row < pastelsDisplay.count else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = PastelDetailViewController(item: pastelsDisplay[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

#Preview {
    UINavigationController(rootViewController: ListViewController())
}
