//
//  UICollectionView+ScrollDirectionInit.swift
//  MyHabits
//
//  Created by Тарас Андреев on 06.03.2021.
//

import UIKit

extension UICollectionView {
    convenience init(scrollDirection: UICollectionView.ScrollDirection) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        self.init(frame: .zero, collectionViewLayout: layout)
    }
}
