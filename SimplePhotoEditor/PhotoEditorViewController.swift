//
//  PhotoEditorViewController.swift
//  SimplePhotoEditor
//
//  Created by James on 11/05/2024.
//

import UIKit

class PhotoEditorViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var adjustContentView: UIStackView!

    private lazy var adjustView: AdjustmentsView = AdjustmentsView()
    
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
        title = "Editor"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(PhotoEditorViewController.close(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(PhotoEditorViewController.save(_:)))
    }

    @objc func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @objc func save(_ sender: UIBarButtonItem) {
        guard let uiImage else { return }
        UIImageWriteToSavedPhotosAlbum(
            uiImage,
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
        present(alert, animated: true, completion: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        imageView.image = uiImage
        imageView.contentMode = .scaleAspectFill
        setupToolbarItems()
        setupAdjustView()
    }

    fileprivate func setupToolbarItems() {
        let cropButton = UIBarButtonItem(title: "Crop",
                                         style: .plain,
                                         target: self,
                                         action: #selector(PhotoEditorViewController.crop(_:)))
        let adjustButton = UIBarButtonItem(title: "Adjust",
                                           style: .plain,
                                           target: self,
                                           action: #selector(PhotoEditorViewController.adjust(_:)))
        toolbarItems = [
            .flexibleSpace,
            cropButton,
            adjustButton,
            .flexibleSpace
        ]
        navigationController?.isToolbarHidden = false
    }

    fileprivate func setupAdjustView() {
        adjustView.animateHide()
        adjustContentView.addArrangedSubview(adjustView)
    }

    @objc func adjust(_ sender: UIBarButtonItem) {
        adjustView.animateShow()
    }

    @objc func crop(_ sender: UIBarButtonItem) {
        let controller = CropViewController()
        controller.delegate = self
        controller.image = uiImage
        let navController = UINavigationController(rootViewController: controller)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
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

        let inputImage = CIImage(image: image)
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(NSNumber(0.4), forKey: kCIInputContrastKey)
        filter?.setValue(NSNumber(0.6), forKey: kCIInputBrightnessKey)

        guard let ciImage = filter?.outputImage else { return }
        let outputImage: UIImage? = UIImage(ciImage: ciImage)
        self.uiImage = outputImage
    }
}
