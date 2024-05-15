//
//  PhotoEditorViewController.swift
//  SimplePhotoEditor
//
//  Created by James on 11/05/2024.
//

import UIKit

class PhotoEditorViewController: UIViewController {
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

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var contrastSlider: UISlider!
    @IBOutlet weak var saturationSlider: UISlider!

    internal lazy var photoFilter: PhotoFilterProtocol = PhotoFilter()

    var originalImage: UIImage? {
        didSet {
            guard let originalImage = self.originalImage else { return }
            var scaledSize = imageView.bounds.size
            // 1x, 2x, 3x(10x max)
            let scale = UIScreen.main.scale
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            scaledImage = originalImage.imageByScaling(toSize: scaledSize)
        }
    }

    var scaledImage: UIImage? {
        didSet {
            updateImage()
        }
    }

    func updateImage() {
        if let scaledImage = self.scaledImage {
            photoFilter.inputImage = scaledImage
            imageView.image = photoFilter.outputImage()
        }
    }

    @objc func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupTargetUISlider() {
        brightnessSlider.addTarget(
            self,
            action: #selector(PhotoEditorViewController.changeBrightness(_:)),
            for: .valueChanged)
        contrastSlider.addTarget(
            self,
            action: #selector(PhotoEditorViewController.changeContrast(_:)),
            for: .valueChanged)
        saturationSlider.addTarget(
            self,
            action: #selector(PhotoEditorViewController.changeSaturation(_:)),
            for: .valueChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        imageView.image = originalImage
        imageView.contentMode = .scaleAspectFill
        setupToolbarItems()
        setupTargetUISlider()
    }

    fileprivate func setupToolbarItems() {
        let cropButton = UIBarButtonItem(title: "Crop",
                                         style: .plain,
                                         target: self,
                                         action: #selector(PhotoEditorViewController.crop(_:)))
        toolbarItems = [
            .flexibleSpace,
            cropButton,
            .flexibleSpace
        ]
        navigationController?.isToolbarHidden = false
    }
}
