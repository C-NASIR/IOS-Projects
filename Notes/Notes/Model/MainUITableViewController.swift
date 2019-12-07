//
//  ViewController.swift
//  Notes
//
//  Created by Abdinasir Muhumed on 12/6/19.
//  Copyright © 2019 Nasir. All rights reserved.
//

import UIKit
import CoreData
class MainUITableViewController: UITableViewController {
    private let AppDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedRC : NSFetchedResultsController<Note>!
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        showEditButton()
    }
    
    func refresh(){
        let noteFetchRequest = Note.fetchRequest() as NSFetchRequest
        let noteSort = NSSortDescriptor(key: "updatedAt", ascending: true)
        noteFetchRequest.sortDescriptors = [noteSort]
        fetchedRC = NSFetchedResultsController(fetchRequest: noteFetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedRC.delegate  = self
        
        do {
            try fetchedRC.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Save Note")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    //MARK: Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedRC.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        configureCell(cell, at: indexPath)
        return cell
    }
    
    func configureCell(_ cell : UITableViewCell, at indexPath : IndexPath){
        let note = fetchedRC.object(at: indexPath)
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.content
    }
    
    //MARK: UITableview delegate
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let note = fetchedRC.object(at: indexPath)
        context.delete(note)
        AppDelegate.saveContext()
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "segueAddViewController":
            guard let navVC = segue.destination as? UINavigationController else { return }
            guard let addVC = navVC.viewControllers.first as? AddNoteViewController else { return }
            addVC.delegate = self
        case "segueNoteViewController":
            guard let noteVC = segue.destination as? NoteViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let note = fetchedRC.object(at: indexPath)
            noteVC.note = note
            noteVC.delegate = self
        default:
            print("unknown segue ")
        }
    }
    
    private func showEditButton() {
        guard fetchedRC.fetchedObjects != nil else { return }
        navigationItem.leftBarButtonItem = editButtonItem
    }
}

extension MainUITableViewController : AddNoteViewControllerDelegate {
    func controller(_ controller: UIViewController, didAddNoteWithTitle title: String) {
        let note = Note(context: context)
        note.title = title
        note.content = ""
        note.updatedAt = Date()
        note.createdAt = Date()
        AppDelegate.saveContext()
    }
}

extension MainUITableViewController : NoteViewControllerdelegate {
    func controller(_ controller: UIViewController, didUpdateNote note: Note) {
        AppDelegate.saveContext()
    }
}

extension MainUITableViewController : NSFetchedResultsControllerDelegate {
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
        case .update :
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
               configureCell(cell, at: indexPath)
            }
        case .move :
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.deleteRows(at: [newIndexPath], with: .automatic)
            }
        @unknown default:
                break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
