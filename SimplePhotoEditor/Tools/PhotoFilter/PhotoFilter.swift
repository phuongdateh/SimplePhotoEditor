//
//  PhotoFilter.swift
//  SimplePhotoEditor
//
//  Created by James on 15/05/2024.
//

import UIKit
import CoreImage

protocol PhotoFilterProtocol {
    var inputImage: UIImage? { get set }

    func updateBrightness(value: Float)
    func updateContrast(value: Float)
    func updateSaturation(value: Float)
    
    func outputImage() -> UIImage?
    func temporarySave()
    func doUndoStack() -> UIImage?
    func doRedoStack() -> UIImage?
    func undoShouldActive() -> Bool
    func redoShouldActive() -> Bool
}

class PhotoFilter: PhotoFilterProtocol {
    var inputImage: UIImage? {
        didSet {
            guard let image = inputImage,
                  let ciImage = CIImage(image: image) else {
                return
            }
            colorControlsFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        }
    }

    lazy var context = CIContext(options: nil)
    lazy var colorControlsFilter = CIFilter(name: "CIColorControls")

    func outputImage() -> UIImage? {
        guard let outputCIImage = colorControlsFilter?.outputImage else {
            return inputImage
        }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
            return inputImage
        }
        return UIImage(cgImage: outputCGImage)
    }

    func updateContrast(value: Float) {
        colorControlsFilter?.setValue(NSNumber(value: value), forKey: kCIInputContrastKey)
    }

    func updateBrightness(value: Float) {
        colorControlsFilter?.setValue(NSNumber(value: value), forKey: kCIInputBrightnessKey)
    }

    func updateSaturation(value: Float) {
        colorControlsFilter?.setValue(NSNumber(value: value), forKey: kCIInputSaturationKey)
    }
    
    lazy var undoStack: [UIImage?] = {
        return [inputImage] // Original Image
    }()
    lazy var redoStack: [UIImage?] = []

    func temporarySave() {
        undoStack.append(outputImage())
    }

    func doRedoStack() -> UIImage? {
        let data = undoStack.popLast() ?? inputImage
        undoStack.append(data)
        return data
    }

    func doUndoStack() -> UIImage? {
        let data = redoStack.popLast() ?? inputImage
        redoStack.append(data)
        return data
    }

    func redoShouldActive() -> Bool {
        !redoStack.isEmpty
    }

    func undoShouldActive() -> Bool {
        undoStack.count > 1
    }
}
