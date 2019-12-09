//
//  DetailTableViewController.swift
//  WordTable
//
//  Created by Abdinasir Muhumed on 12/7/19.
//  Copyright © 2019 Nasir. All rights reserved.
//

import UIKit
import CoreData
class DetailTableViewController: UITableViewController {
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var department : Department!
    private var fetchTermsRC : NSFetchedResultsController<Term>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = department.name
        refresh()
    }
    
    private func refresh(){
        let termsRequest = Term.fetchRequest() as NSFetchRequest<Term>
        
        let termSort = NSSortDescriptor(key: "english", ascending: true)
                
        termsRequest.sortDescriptors = [termSort]
    
        let deptPredicate = NSPredicate(format: "(department = %@)", department)

        termsRequest.predicate = deptPredicate
        
        fetchTermsRC = NSFetchedResultsController(fetchRequest: termsRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchTermsRC.delegate = self
        do {
            try fetchTermsRC.performFetch()
            if department.name == "Pediatrics" && fetchTermsRC.fetchedObjects?.count == 0{
                loadingInitialPedTerms()
                try fetchTermsRC.performFetch()
            }
        } catch let error as NSError {
            print("Couldn't fetch data \(error), \(error.userInfo)")
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchTermsRC.fetchedObjects?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailTableViewCell
       configureCell(cell, at: indexPath)
        return cell
    }
    
    func configureCell(_ cell : DetailTableViewCell, at indexPath : IndexPath){
        let item = fetchTermsRC.object(at: indexPath)
        cell.englishLabel.text = item.english
        cell.descriptionLabel.text = item.termdescription
        cell.somaliLabel.text = item.somali
        cell.hmongLabel.text = item.hmong
        cell.spanishLabel.text = item.spanish
    }
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let term = fetchTermsRC.object(at: indexPath)
            context.delete(term)
            appdelegate.saveContext()
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let term = fetchTermsRC.object(at: sourceIndexPath)
        term.priority = 1
        appdelegate.saveContext()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
            let addDetailVC = nav.viewControllers.first as? AddDetailUITableViewController {
            addDetailVC.department = department
        }
    }
    
    //MARK: Only for initial loading of PediatricTerms
    private func loadingInitialPedTerms(){
        if department.name == "Pediatrics" {
            let termsDic = wordsList().Pterms
            for (english,terms) in  termsDic {
                let term = Term(context: context)
                print(english)
                term.english = english
                term.termdescription = terms[Languages.English]
                term.spanish = terms[Languages.Spanish]
                term.somali = terms[Languages.Somali]
                term.hmong = terms[Languages.Hmong]
                term.department = department
                appdelegate.saveContext()
            }
        }
    }
}

extension DetailTableViewController : NSFetchedResultsControllerDelegate {
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
            if let indexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
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
