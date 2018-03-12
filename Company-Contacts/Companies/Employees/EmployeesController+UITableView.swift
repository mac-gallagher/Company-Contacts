//
//  EmployeesController+UITableView.swift
//  Company-Contacts
//
//  Created by Mac Gallagher on 3/5/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

extension EmployeesController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerTitle = employeeTypes[section]
        return HeaderCell(title: headerTitle, icon: #imageLiteral(resourceName: "people"), imageFrame: CGRect(x: 0, y: 0, width: 35, height: 22), style: .default, reuseIdentifier: "headerId")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return allEmployees[section].count == 0 ? 0 : 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EmployeeCell
        cell.selectionStyle = .none
        cell.employee = allEmployees[indexPath.section][indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: deleteHandlerFunction)
        deleteAction.backgroundColor = UIColor.lightRed
        return [deleteAction]
    }
    
    private func deleteHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        let employee = allEmployees[indexPath.section][indexPath.row]
        do {
            try CoreDataManager.shared.deleteEmployee(employee: employee) {
                allEmployees[indexPath.section].remove(at: indexPath.row)
                UIView.animate(withDuration: 0.3, delay: 0,
                                           options: [], animations: {
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }, completion: { _ in
                    self.tableView.reloadData()
                })
            }
        } catch let deleteError {
            print("Unable to delete employee from Core Data:", deleteError)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var tableIsEmpty = true
        for employeeType in allEmployees {
            if employeeType.count != 0 {
                tableIsEmpty = false
                break
            }
        }
        if tableIsEmpty && section == 0 {
            return 150
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let footer = EmptyTableFooter()
            footer.setUpperText(text: "No employees available")
            footer.setLowerText(lines: ["Create some new employees by using the Add","button at the top"])
            return footer
        }
        return nil
    }
    
    
    
    
    
    
}





