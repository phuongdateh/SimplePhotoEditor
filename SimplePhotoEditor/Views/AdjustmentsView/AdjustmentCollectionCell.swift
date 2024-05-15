//
//  AdjustmentCollectionCell.swift
//  SimplePhotoEditor
//
//  Created by James on 14/05/2024.
//

import Foundation
import UIKit

final class AdjustmentCollectionCell: UICollectionViewCell {
    private lazy var iconImage = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        return img
    }()
    private lazy var titleLbl = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lbl.textAlignment = .center
        return lbl
    }()
    private lazy var selectedView = {
        let view = UIView()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func initialize() {
        contentView.backgroundColor = .black
        contentView.addSubview(selectedView)
        contentView.addSubview(iconImage)
        contentView.addSubview(titleLbl)

        iconImage.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        selectedView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            selectedView.topAnchor.constraint(equalTo: topAnchor),
            selectedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectedView.bottomAnchor.constraint(equalTo: bottomAnchor),

            iconImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            iconImage.heightAnchor.constraint(equalToConstant: 40),
            iconImage.widthAnchor.constraint(equalToConstant: 40),
            iconImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            titleLbl.topAnchor.constraint(equalTo: iconImage.bottomAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16)
        ])
        
    }

    func setup(_ data: AdjustmentCellData, isSelected: Bool) {
        iconImage.image = data.uiImageIcon
        titleLbl.text = data.title
        selectedView.backgroundColor = isSelected ? UIColor.darkGray : UIColor.black
        selectedView.rounded(color: isSelected ? UIColor.lightGray : UIColor.clear)
    }
}

