//
//  AdjustmentsView.swift
//  SimplePhotoEditor
//
//  Created by James on 13/05/2024.
//

import Foundation
import UIKit

final class AdjustmentsView: UIView {
    fileprivate lazy var uiSlider: UISlider = {
        makeUISlider()
    }()
    fileprivate lazy var uiCollectionView: UICollectionView = {
        UICollectionView(frame: .zero,
                         collectionViewLayout: uiControl.collectionViewLayout())
    }()

    fileprivate lazy var uiControl: AdjustmentsUiControlInterface = AdjustmentsUiControlV2()
    
    fileprivate func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        UICollectionViewFlowLayout()
    }

    fileprivate func makeUISlider() -> UISlider {
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

//        observation = uiCollectionView.observe(\.contentSize,
//                                                options: [.new],
//                                                changeHandler: { collectionView, value in
//            print(value.newValue?.height)
//        })

        NSLayoutConstraint.activate([
            uiSlider.topAnchor.constraint(equalTo: topAnchor),
            uiSlider.leadingAnchor.constraint(equalTo: leadingAnchor),
            uiSlider.trailingAnchor.constraint(equalTo: trailingAnchor),
            uiSlider.bottomAnchor.constraint(equalTo: uiCollectionView.topAnchor),
            
            uiCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            uiCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            uiCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            uiCollectionView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    var observation: NSKeyValueObservation?

    deinit {
        observation?.invalidate()
    }

    fileprivate func setupUIControl() {
        uiCollectionView.collectionViewLayout = uiControl.collectionViewLayout()
        uiCollectionView.backgroundColor = .blue
        uiCollectionView.register(AdjustmentCollectionCell.self,
                                  forCellWithReuseIdentifier: "\(AdjustmentCollectionCell.self)")
        uiCollectionView.dataSource = uiControl
        uiCollectionView.delegate = uiControl
    }
}

protocol AdjustmentsUiControlProtocol: UICollectionViewDelegate {
    typealias DataSource = UICollectionViewDiffableDataSource<AdjustmentsUiControl.AllSection, AdjustmentCellData>

    func createDataSource(for uiCollectionView: UICollectionView) -> DataSource
    func updateData()
}

class AdjustmentsUiControl: NSObject,
                            AdjustmentsUiControlProtocol {
    lazy var cellDatas: [AdjustmentCellData] = AdjustmentType.allCases.map { AdjustmentCellData(type: $0) }

    enum AllSection: Int {
        case main
    }

    var dataSource: DataSource!

    func createDataSource(for uiCollectionView: UICollectionView) -> DataSource {
        dataSource = UICollectionViewDiffableDataSource(collectionView: uiCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell: AdjustmentCollectionCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "\(AdjustmentCollectionCell.self)",
                                                                                     for: indexPath) as? AdjustmentCollectionCell
//            let cell: AdjustmentCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "\(AdjustmentCell.self)", for: indexPath) as? AdjustmentCell
            cell?.setup(itemIdentifier)
            return cell ?? UICollectionViewCell()
        }
        return dataSource
    }

    fileprivate func makeCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            self?.makeListLayoutSection()
        }
    }

    fileprivate func makeListLayoutSection() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
               widthDimension: .estimated(200),
               heightDimension: .absolute(50)
           )
           
           let item = NSCollectionLayoutItem(layoutSize: layoutSize)
           item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
           
           let group = NSCollectionLayoutGroup.horizontal(
               layoutSize: NSCollectionLayoutSize(
                widthDimension: layoutSize.widthDimension,
                   heightDimension: layoutSize.heightDimension),
               subitems: [item]
           )
           
           let section = NSCollectionLayoutSection(group: group)
           section.orthogonalScrollingBehavior = .continuous

           return section
    }

    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<AllSection, AdjustmentCellData>()
        snapshot.appendSections([.main])
        snapshot.appendItems(cellDatas)
        dataSource.apply(snapshot)
    }
}

extension AdjustmentsUiControl {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
    }
}

enum AdjustmentType: String, CaseIterable, Hashable {
    case brightness
    case contrast
    case highlight
    case saturation
}

struct AdjustmentCellData: Hashable {
    let type: AdjustmentType
    var value: Double = 0

    init(type: AdjustmentType) {
        self.type = type
    }

    var uiImageIcon: UIImage? {
        UIImage(named: type.rawValue + "-ic")
    }

    var title: String {
        type.rawValue.capitalized
    }

    mutating func update(_ value: Double) {
        self.value = value
    }
}

extension AdjustmentCellData {
    static func == (lhs: AdjustmentCellData, rhs: AdjustmentCellData) -> Bool {
        return lhs.type == rhs.type
    }
}

final class AdjustmentCollectionCell: UICollectionViewCell {
    private lazy var iconImage = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        return img
    }()
    private lazy var titleLbl = {
        let lbl = UILabel()
        lbl.textColor = .white
        return lbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func initialize() {
        contentView.backgroundColor = .red
        contentView.addSubview(iconImage)
        contentView.addSubview(titleLbl)

        iconImage.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconImage.heightAnchor.constraint(equalToConstant: 40),
            iconImage.widthAnchor.constraint(equalToConstant: 40),
            iconImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            iconImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            titleLbl.topAnchor.constraint(equalTo: iconImage.bottomAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16)
        ])
    }

    func setup(_ data: AdjustmentCellData) {
        iconImage.image = data.uiImageIcon
        titleLbl.text = data.title
    }
}
