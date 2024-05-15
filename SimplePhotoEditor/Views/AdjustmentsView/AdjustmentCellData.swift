//
//  AdjustmentCellData.swift
//  SimplePhotoEditor
//
//  Created by James on 14/05/2024.
//

import Foundation
import UIKit

enum AdjustmentType: String, CaseIterable, Hashable {
    case brightness
    case contrast
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
