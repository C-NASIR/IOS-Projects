//
//  NoteViewControllerdelegate.swift
//  Notes
//
//  Created by Abdinasir Muhumed on 12/6/19.
//  Copyright © 2019 Nasir. All rights reserved.
//

import UIKit

protocol NoteViewControllerdelegate {
    func controller(_ controller : UIViewController, didUpdateNote note : Note)
}
