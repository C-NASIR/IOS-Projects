//
//  DepartmentTableViewController.swift
//  WordTable
//
//  Created by Abdinasir Muhumed on 12/7/19.
//  Copyright © 2019 Nasir. All rights reserved.
//

import UIKit
import CoreData
class DepartmentTableViewController: UITableViewController {
    private let appdelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var deptFetchedRC : NSFetchedResultsController<Department>!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    refresh()
    }

    private func refresh(){
        let request = Department.fetchRequest() as NSFetchRequest
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        deptFetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        deptFetchedRC.delegate = self
        do {
            try deptFetchedRC.performFetch()
            if deptFetchedRC.fetchedObjects?.count == 0 {
                loadInitailDepartments(nil)
                try deptFetchedRC.performFetch()
            }
        } catch  {
            let error  = error as NSError
            print("Unexpected error has happebed \(error.userInfo)")
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deptFetchedRC.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "department", for: indexPath)
        configureCell(cell, at: indexPath)
        return cell
    }
    
    private func configureCell(_ cell : UITableViewCell, at indexPath : IndexPath){
        let dept = deptFetchedRC.object(at: indexPath)
        cell.textLabel?.text = dept.name
        cell.detailTextLabel?.text = dept.deptdescription
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let dept = deptFetchedRC.object(at: indexPath)
        context.delete(dept)
        appdelegate.saveContext()
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {        
    }
    //MARK: Only for initial loading of Department
    private func loadInitailDepartments(_ exceptdep : String!){
        let departmentDic = DepartmentList().departmentsDic
        for (name,description) in departmentDic{
            if name == exceptdep {
                continue
            }
            let department = Department(entity: Department.entity(), insertInto: context)
            department.name = name
            department.deptdescription = description
            appdelegate.saveContext()
        }
    }
    
    //MARK: ~ Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailTVC = segue.destination as? DetailTableViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        detailTVC.department = deptFetchedRC.object(at: indexPath)
    }
}

extension DepartmentTableViewController : NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete :
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case . update :
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
                configureCell(cell, at: indexPath)
             }
        case .move :
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
