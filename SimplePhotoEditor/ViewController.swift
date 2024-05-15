//
//  ViewController.swift
//  SimplePhotoEditor
//
//  Created by James on 11/05/2024.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func selectImageBtn(_ sender: UIButton) {
        pickerViewController.modalPresentationStyle = .fullScreen
        present(pickerViewController, animated: true)
    }

    private lazy var pickerViewController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        return picker
    }()
}

extension ViewController: UIImagePickerControllerDelegate,
                          UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        picker.dismiss(animated: true, completion: nil)

        // Navigate EditorViewController
        let editorViewController = PhotoEditorViewController()
        editorViewController.uiImage = image

        let navigationController = UINavigationController(rootViewController: editorViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    input.rawValue
}
