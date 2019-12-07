//
//  NoteViewController.swift
//  Notes
//
//  Created by Abdinasir Muhumed on 12/6/19.
//  Copyright © 2019 Nasir. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    var delegate : NoteViewControllerdelegate!
    var note : Note!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleTextField.text = note.title
        contentTextView.text = note.content
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text else { return }
        guard let content = contentTextView.text else { return }
        guard let delegate = delegate else { return }
        note.title = title
        note.content = content
        note.updatedAt = Date()
        delegate.controller(self, didUpdateNote: note)
        navigationController?.popViewController(animated: true)
    }
}
