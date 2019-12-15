//
//  ViewController.swift
//  CollectionViews
//
//  Created by Abdinasir Muhumed on 12/14/19.
//  Copyright © 2019 Nasir. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionData = ["1🏆" , "2 🐸", "3 🍩", "4 😸", "5 🤡", "6 👾", "7 👻",
                          "8 🍖", "9 🎸", "10 🐯", "11 🐷", "12 🌋"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = (view.frame.size.width - 20) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }


}
extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        if let label = cell.viewWithTag(1000) as? UILabel {
            label.text = collectionData[indexPath.row]
        }
        return cell
    }
}

extension ViewController : UICollectionViewDelegate {
    
}

