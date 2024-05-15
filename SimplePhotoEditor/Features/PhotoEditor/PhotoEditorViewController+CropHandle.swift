//
//  PhotoEditorViewController+CropHandle.swift
//  SimplePhotoEditor
//
//  Created by James on 15/05/2024.
//

import Foundation
import UIKit

extension PhotoEditorViewController: CropViewControllerDelegate {
    @objc func crop(_ sender: UIBarButtonItem) {
        let controller = CropViewController()
        controller.delegate = self
        controller.image = originalImage
        let navController = UINavigationController(rootViewController: controller)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }

    // Delegate
    func cropViewControllerDidCancel(_ controller: CropViewController) {
        controller.dismiss(animated: true)
    }

    func cropViewController(_ controller: CropViewController,
                            didFinishCroppingImage image: UIImage,
                            transform: CGAffineTransform,
                            cropRect: CGRect) {
        originalImage = image
        controller.dismiss(animated: true)
    }
}
