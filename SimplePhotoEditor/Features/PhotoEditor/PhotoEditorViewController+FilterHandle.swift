//
//  PhotoEditorViewController+FilterHandler.swift
//  SimplePhotoEditor
//
//  Created by James on 15/05/2024.
//

import Foundation
import UIKit

extension PhotoEditorViewController {
    @objc func changeBrightness(_ sender: UISlider, _ event: UIEvent) {
        photoFilter.updateBrightness(value: sender.value)
        if event.isToucheEnded() {
            photoFilter.temporarySave()
        }
        updateView()
    }

    @objc func changeContrast(_ sender: UISlider, _ event: UIEvent) {
        photoFilter.updateContrast(value: sender.value)
        if event.isToucheEnded() {
            photoFilter.temporarySave()
        }
        updateView()
    }

    @objc func changeSaturation(_ sender: UISlider, _ event: UIEvent) {
        photoFilter.updateSaturation(value: sender.value)
        if event.isToucheEnded() {
            photoFilter.temporarySave()
        }
        updateView()
    }

    internal func updateUndoRedoButtonState() {
        undoButton.isEnabled = photoFilter.undoShouldActive()
        redoButton.isEnabled = photoFilter.redoShouldActive()
    }
}

extension UIEvent {
    func isToucheEnded() -> Bool {
        guard let firstTouch = self.allTouches?.first else {
            return false
        }
        if case .ended = firstTouch.phase {
            return true
        } else {
            return false
        }
    }
}
