//
//  EmployeesController+FetchedResults.swift
//  Company-Contacts
//
//  Created by Mac Gallagher on 3/13/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit
import CoreData

extension EmployeesController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .top)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .left)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .none)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .middle)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if fetchedEmployeesController.sections?.count == 0 {
            setupEmptyTableFooter()
            tableView.tableFooterView?.alpha = 0
            UIView.animate(withDuration: 0.3, delay: 0.35, options: [], animations: {
                    self.tableView.tableFooterView?.alpha = 1
            }, completion: nil)
        } else {
            tableView.tableFooterView? = UIView()
        }
        tableView.endUpdates()
    }
}
