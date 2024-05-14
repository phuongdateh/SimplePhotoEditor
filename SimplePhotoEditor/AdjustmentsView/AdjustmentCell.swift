//
//  AdjustmentCell.swift
//  SimplePhotoEditor
//
//  Created by James on 14/05/2024.
//

import UIKit

class AdjustmentCell: UICollectionViewCell {

    @IBOutlet weak var titleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(_ data: AdjustmentCellData) {
//        iconImage.image = data.uiImageIcon
        titleLbl.text = data.title
    }
}
