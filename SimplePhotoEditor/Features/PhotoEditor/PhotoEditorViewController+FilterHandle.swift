//
//  PhotoEditorViewController+FilterHandler.swift
//  SimplePhotoEditor
//
//  Created by James on 15/05/2024.
//

import Foundation
import UIKit

extension PhotoEditorViewController {
    @objc func changeBrightness(_ sender: UISlider) {
        photoFilter.updateBrightness(value: sender.value)
        updateImage()
    }

    @objc func changeContrast(_ sender: UISlider) {
        photoFilter.updateContrast(value: sender.value)
        updateImage()
    }

    @objc func changeSaturation(_ sender: UISlider) {
        photoFilter.updateSaturation(value: sender.value)
        updateImage()
    }
}
