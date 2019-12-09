//
//  DetailViewControllerdelegate.swift
//  WordTable
//
//  Created by Abdinasir Muhumed on 12/9/19.
//  Copyright © 2019 Nasir. All rights reserved.
//

import UIKit

protocol DetailUITableViewControllerdelegate {
    func update(_ controller : UIViewController, changedField : [String])
}
