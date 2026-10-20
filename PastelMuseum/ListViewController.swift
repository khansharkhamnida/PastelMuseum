//
//  ViewController.swift
//  PastelMuseum
//
//  Created by Dian Maisara on 18/10/26.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PastelFormViewControllerDelegate { // SubviewDelegate
    
    private let tableView = UITableView()
    
    // TODO: previously let but remove this comment if it works
    private var pastelsDisplay = [
        Pastel(color: "Jazzberry Jam", brand: .mungyo, id: 276, dateAcquired: Date(), colorSwatch: (198, 1, 49)),
        Pastel(color: "Viridian Green", brand: .sennelier, id: 021, dateAcquired: Date(), colorSwatch: (0, 103, 80))
    ]
    
    // function defined in the subview delegate
    func pastelSwatchAddDidSave(item: Pastel) {
        pastelsDisplay.append(item)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBrown
        title = "Pastel Museum 🎨"

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )
        navigationItem.rightBarButtonItem = addButton

        setupTableView()
    }
    
    // refresh/redraw the table (fixes the bug of stale data in table!)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
    
    // free delete swipe feature - TODO: Push the elements to fill the remaining card space instead of hiding under the view (looks cut off and weird)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            pastelsDisplay.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @objc private func addTapped(){
        let addVC = PastelFormViewController()
        addVC.delegate = self // so its not nil
        let navController = UINavigationController(rootViewController: addVC)
        present(navController, animated: true)
    }
    
}

#Preview {
    UINavigationController(rootViewController: ListViewController())
}
