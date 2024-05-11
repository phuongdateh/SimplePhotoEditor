//
//  PhotoEditorViewController.swift
//  SimplePhotoEditor
//
//  Created by James on 11/05/2024.
//

import UIKit

class PhotoEditorViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var uiImage: UIImage? {
        didSet {
            if self.imageView != nil {
                self.imageView.image = uiImage
            }
        }
    }

    init() {
        super.init(nibName: "\(PhotoEditorViewController.self)",
                   bundle: Bundle(for: PhotoEditorViewController.self))
        initialize()
    }

    fileprivate func initialize() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        imageView.image = uiImage
    }

    @IBAction func cropBtnTouchUpInside(_ sender: UIButton) {
        let controller = CropViewController()
        controller.delegate = self
        controller.image = uiImage
        let navController = UINavigationController(rootViewController: controller)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    @IBAction func saveBtnTouchUpInside(_ sender: UIButton) {
        guard let uiImage else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(
            uiImage,
            self,
            #selector(self.saveImage(_:withPotentialError:contextInfo:)), nil)
    }

    @objc func saveImage(_ image: UIImage,
                         withPotentialError error: NSErrorPointer,
                         contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(
            title: "Image Saved",
            message: "Image successfully saved to Photos library",
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension PhotoEditorViewController: CropViewControllerDelegate {
    func cropViewControllerDidCancel(_ controller: CropViewController) {
        controller.dismiss(animated: true)
    }

    func cropViewController(_ controller: CropViewController,
                            didFinishCroppingImage image: UIImage,
                            transform: CGAffineTransform,
                            cropRect: CGRect) {
        self.uiImage = image
        controller.dismiss(animated: true)
    }
}
