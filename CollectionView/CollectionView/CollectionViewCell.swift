//
//  CollectionViewCell.swift
//  CollectionView
//
//  Created by Abdinasir Muhumed on 12/15/19.
//  Copyright © 2019 Nasir. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label : UILabel!
    @IBOutlet weak var selectionImage : UIImageView!
    var isEditing : Bool = false {
        didSet {
            selectionImage.isHidden = !isEditing
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isEditing {
                selectionImage.image = isSelected ? UIImage(named: "Checked") : UIImage(named: "Unchecked")
            }
        }
    }
}
