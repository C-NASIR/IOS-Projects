//
//  AddDetailViewController.swift
//  WordTable
//
//  Created by Abdinasir Muhumed on 12/7/19.
//  Copyright © 2019 Nasir. All rights reserved.
//

import UIKit

class AddDetailUITableViewController: UITableViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var department : Department!
    //Text Fields
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var spanishTextField: UITextField!
    @IBOutlet weak var somaliTextField: UITextField!
    @IBOutlet weak var hmongTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add to \(department.name!)"
    }
    
    //MARK: - Actions
    @IBAction func cancelButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        guard let dept = department else { return }
        callAppropriateSaveTerms(dept: dept)
    }
    
    private func callAppropriateSaveTerms(dept : Department){
        guard let name = nameTextField.text else { return }
        guard let spanish = spanishTextField.text else { return }
        guard let somali = somaliTextField.text else { return }
        guard let desc = descriptionTextField.text else { return }
        guard let hmong = hmongTextField.text else { return }
        saveTerm(name : name, description : desc, spanish : spanish, somali : somali, hmong : hmong,department : dept)
    }
    
    private func saveTerm(name : String, description desc : String,spanish : String, somali: String, hmong : String, department dept : Department){
        let term = Term(context: context)
        term.english = name
        term.termdescription = desc
        term.spanish = spanish
        term.somali = somali
        term.hmong = hmong
        term.department = dept
        appDelegate.saveContext()
    }
}
