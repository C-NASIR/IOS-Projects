//
//  AddDeptViewController.swift
//  WordTable
//
//  Created by Abdinasir Muhumed on 12/7/19.
//  Copyright © 2019 Nasir. All rights reserved.
//

import UIKit
import CoreData
class AddDeptViewController: UIViewController {
     var appdelegate : AppDelegate!
     var persistentContainer : NSPersistentContainer!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButtonClicked(_ sender: UIBarButtonItem) {
        if IsvalidValuesEntered() {
            let (name,desc) = returnValidValues()
            saveDept(name: name, description: desc)
            dismiss(animated: true, completion: nil)
        }else{
            tellUserToEnterValidDescriotion()
        }
    }
    
    //MARK: - Private functions
    private func IsvalidValuesEntered() -> Bool {
        if nameTextField.text != nil && !nameTextField.text!.isEmpty,
            descriptionTextView.text != nil && !descriptionTextView.text.isEmpty {
            return true
        }
        return false
    }
    
    private func returnValidValues() -> (String,String) {
       let name = nameTextField.text ?? "Nothing"
        let desc = descriptionTextView.text ?? "Nothing"
        return (name,desc)
    }
    
    private func tellUserToEnterValidDescriotion(){
        title = "Enter description"
    }
    
    private func saveDept(name : String, description : String){
        let dept = Department(context: persistentContainer.viewContext)
        dept.name = name
        dept.deptdescription = description
        appdelegate.saveContext()
    }
}
