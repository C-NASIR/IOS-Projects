//
//  AddNoteViewController.swift
//  Notes
//
//  Created by Abdinasir Muhumed on 12/6/19.
//  Copyright © 2019 Nasir. All rights reserved.
//

import UIKit

class AddNoteViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    var delegate : AddNoteViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text else { return }
        guard let delegate = delegate else { return }
        delegate.controller(self, didAddNoteWithTitle: title)
        print("I am save, This is fun")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        print("I am cancell and I am called")
        dismiss(animated: true, completion: nil)
    }
}
