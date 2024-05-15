//
//  PhotoEditorViewController+SaveHandle.swift
//  SimplePhotoEditor
//
//  Created by James on 15/05/2024.
//

import UIKit

extension PhotoEditorViewController {
    @objc func save(_ sender: UIBarButtonItem) {
        guard let originalImage else { return }
        UIImageWriteToSavedPhotosAlbum(
            originalImage,
            self,
            #selector(PhotoEditorViewController.saveImage(_:withPotentialError:contextInfo:)), nil)
    }

    @objc func saveImage(_ image: UIImage,
                         withPotentialError error: NSErrorPointer,
                         contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(
            title: "Image Saved",
            message: "Image successfully saved to Photos library",
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "Ok",
                          style: .default,
                          handler: { [weak self] _ in
            self?.dismiss(animated: true)}))
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
