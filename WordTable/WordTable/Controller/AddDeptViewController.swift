//
//  AddDeptViewController.swift
//  WordTable
//
//  Created by Abdinasir Muhumed on 12/7/19.
//  Copyright © 2019 Nasir. All rights reserved.
//

import UIKit

class AddDeptViewController: UIViewController {
    private let appdelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButtonClicked(_ sender: UIBarButtonItem) {
        if let name = nameTextField.text, name != "",
            let desc = descriptionTextView.text, desc != "" {
            saveDept(name: name, description: desc)
            dismiss(animated: true, completion: nil)
        }
        else
        {
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func saveDept(name : String, description : String){
        let dept = Department(context: context)
        dept.name = name
        dept.deptdescription = description
        appdelegate.saveContext()
    }
}
