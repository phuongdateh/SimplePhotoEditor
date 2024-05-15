//
//  AdjustmentsView.swift
//  SimplePhotoEditor
//
//  Created by James on 13/05/2024.
//

import Foundation
import UIKit

final class AdjustmentsView: UIView {
    private lazy var uiControl: AdjustmentsUiControlProtocol = AdjustmentsUiControl()
    private lazy var uiSlider: UISlider = {
        makeUISlider()
    }()
    private lazy var uiCollectionView: UICollectionView = {
        UICollectionView(frame: .zero,
                         collectionViewLayout: uiControl.collectionViewLayout())
    }()

    private func makeUISlider() -> UISlider {
        let slider = UISlider()
        slider.minimumValue = -1
        slider.maximumValue = 1
        slider.value = 0
        return slider
    }

    init() {
        super.init(frame: .zero)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func initialize() {
        setupUIs()
        setupUIControl()
    }

    fileprivate func setupUIs() {
        backgroundColor = .black
        addSubview(uiSlider)
        addSubview(uiCollectionView)
        uiSlider.translatesAutoresizingMaskIntoConstraints = false
        uiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            uiSlider.topAnchor.constraint(equalTo: topAnchor),
            uiSlider.leadingAnchor.constraint(equalTo: leadingAnchor),
            uiSlider.trailingAnchor.constraint(equalTo: trailingAnchor),
            uiSlider.bottomAnchor.constraint(equalTo: uiCollectionView.topAnchor),
            
            uiCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            uiCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            uiCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            uiCollectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    fileprivate func setupUIControl() {
        uiCollectionView.showsHorizontalScrollIndicator = false
        uiCollectionView.backgroundColor = .black
        uiCollectionView.register(AdjustmentCollectionCell.self,
                                  forCellWithReuseIdentifier: "\(AdjustmentCollectionCell.self)")
        uiCollectionView.dataSource = uiControl
        uiCollectionView.delegate = uiControl
        uiCollectionView.reloadData()
    }
}
