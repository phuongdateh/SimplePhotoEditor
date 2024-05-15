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

    func adjustBrightness(value: Double)
    func adjustContrast(value: Double)
    func adjustSaturation(value: Double)
    
    func outputImage() -> UIImage?
}

class PhotoFilter: PhotoFilterProtocol {
    var inputImage: UIImage? {
        didSet {
            guard let image = inputImage, let ciImage = CIImage(image: image) else {
                return
            }
            colorControlsFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        }
    }

    func outputImage() -> UIImage? {
        guard let ciImage = colorControlsFilter?.outputImage else {
            return inputImage
        }
        return UIImage(ciImage: ciImage)
    }

    lazy var colorControlsFilter = CIFilter(name: "CIColorControls")

    func adjustContrast(value: Double) {
        colorControlsFilter?.setValue(value, forKey: kCIInputContrastKey)
    }

    func adjustBrightness(value: Double) {
        colorControlsFilter?.setValue(value, forKey: kCIInputBrightnessKey)
    }

    func adjustSaturation(value: Double) {
        colorControlsFilter?.setValue(value, forKey: kCIInputSaturationKey)
    }
}
