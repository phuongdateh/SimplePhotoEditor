//
//  AdjustmentsUiControl.swift
//  SimplePhotoEditor
//
//  Created by James on 14/05/2024.
//

import Foundation
import UIKit

protocol AdjustmentsUiControlProtocol: UICollectionViewDelegate,
                                       UICollectionViewDataSource {
    func collectionViewLayout() -> UICollectionViewLayout
}

class AdjustmentsUiControl: NSObject,
                            AdjustmentsUiControlProtocol {
    lazy var cellDatas: [AdjustmentCellData] = AdjustmentType.allCases.map { AdjustmentCellData(type: $0) }
    var selectedData: AdjustmentCellData!

    enum AllSection: Int {
        case main
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedData = cellDatas[indexPath.row]
        collectionView.reloadData()
    }

    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .horizontal
        return layout
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        cellDatas.count
    }

    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AdjustmentCollectionCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "\(AdjustmentCollectionCell.self)",
                                                                                  for: indexPath) as? AdjustmentCollectionCell
        let data = cellDatas[indexPath.row]
        cell?.setup(
            data,
            isSelected: selectedData != nil ? data == selectedData : false)
        return cell ?? UICollectionViewCell()
    }
}
