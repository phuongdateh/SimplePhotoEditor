//
//  AdjustmentsUiControl.swift
//  SimplePhotoEditor
//
//  Created by James on 14/05/2024.
//

import Foundation
import UIKit

protocol AdjustmentsUiControlInterface: UICollectionViewDelegate,
                                       UICollectionViewDataSource {
    func collectionViewLayout() -> UICollectionViewLayout
}

class AdjustmentsUiControlV2: NSObject,
                              AdjustmentsUiControlInterface {
    lazy var cellDatas: [AdjustmentCellData] = AdjustmentType.allCases.map { AdjustmentCellData(type: $0) }

    enum AllSection: Int {
        case main
    }

    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 50)
        layout.scrollDirection = .horizontal
        return layout
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        self.cellDatas.count
    }

    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AdjustmentCollectionCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "\(AdjustmentCollectionCell.self)",
                                                                                 for: indexPath) as? AdjustmentCollectionCell
        cell?.setup(cellDatas[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
}
