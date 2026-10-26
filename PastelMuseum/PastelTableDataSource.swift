//
//  PastelTableDataSource.swift
//  PastelMuseum
//
//  Created by Shofia Ghazali on 23/10/26.
//

import UIKit

nonisolated enum PastelSection: Hashable, Sendable {
    case main
}

nonisolated enum PastelTableDataSource {
    static func make(
        for tableView: UITableView,
        pastels: @escaping () -> [Pastel]
    ) -> UITableViewDiffableDataSource<PastelSection, UUID> {

        UITableViewDiffableDataSource<PastelSection, UUID>(
            tableView: tableView
        ) { tableView, indexPath, id in

            guard
                let pastel = pastels().first(where: { $0.id == id }),
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: PastelTableCell.identifier,
                    for: indexPath
                ) as? PastelTableCell
            else {
                return UITableViewCell()
            }

            cell.configure(with: pastel)
            return cell
        }
    }
}
