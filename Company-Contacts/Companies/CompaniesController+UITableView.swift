//
//  CompaniesController+UITableViewDelegate.swift
//  Company-Contacts
//
//  Created by Mac Gallagher on 3/2/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

extension CompaniesController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let company = fetchedResultsController.object(at: indexPath)
        let employeesController = EmployeesController()
        employeesController.company = company
        navigationController?.pushViewController(employeesController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: deleteHandlerFunction)
        deleteAction.backgroundColor = UIColor.lightRed
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction)
        editAction.backgroundColor = UIColor.darkBlue
        return [deleteAction, editAction]
    }
    
    private func deleteHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        let company = fetchedResultsController.object(at: indexPath)
        do {
            try CoreDataManager.shared.deleteCompany(company: company)
        } catch let deleteError {
            print("Unable to delete company from persistent store:", deleteError)
        }
    }
    
    private func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        let company = fetchedResultsController.object(at: indexPath)
        let editCompanyController = CreateCompanyController()
        editCompanyController.company = company
        let navController = CustomNavigationController(rootViewController: editCompanyController)
        present(navController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return HeaderCell(title: "Names", icon: #imageLiteral(resourceName: "user"), imageFrame: CGRect(x: 0, y: 0, width: 22, height: 22), style: .default, reuseIdentifier: "headerId")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CompanyCell
        let company = fetchedResultsController.object(at: indexPath)
        cell.company = company
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = EmptyTableFooter()
        footer.setUpperText(text: "No companies available")
        footer.setLowerText(lines: ["Create some new companies by using the Add","button at the top"])
        return footer
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return fetchedResultsController.fetchedObjects?.count == 0 ? 150 : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

}






