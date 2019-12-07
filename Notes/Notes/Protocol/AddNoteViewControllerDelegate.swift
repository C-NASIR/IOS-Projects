//
//  AddNoteViewControllerDelegate.swift
//  Notes
//
//  Created by Abdinasir Muhumed on 12/6/19.
//  Copyright © 2019 Nasir. All rights reserved.
//

import UIKit

protocol AddNoteViewControllerDelegate {
    func controller(_ controller : UIViewController, didAddNoteWithTitle title : String)
}