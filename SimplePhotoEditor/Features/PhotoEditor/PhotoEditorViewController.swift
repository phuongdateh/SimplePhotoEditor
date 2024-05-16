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

    @IBOutlet weak internal var imageView: UIImageView!
    @IBOutlet weak internal var brightnessSlider: UISlider!
    @IBOutlet weak internal var contrastSlider: UISlider!
    @IBOutlet weak internal var saturationSlider: UISlider!
    @IBOutlet weak internal var undoButton: UIButton!
    @IBOutlet weak internal var redoButton: UIButton!

    internal lazy var photoFilter: PhotoFilterProtocol = PhotoFilter()

    var originalImage: UIImage? {
        didSet {
            guard let originalImage = self.originalImage else { return }
            var scaledSize = imageView.bounds.size
            let scale = UIScreen.main.scale
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            scaledImage = originalImage.imageByScaling(toSize: scaledSize)
        }
    }

    internal var scaledImage: UIImage? {
        didSet {
            updateView()
        }
    }

    internal func updateView() {
        if let scaledImage = self.scaledImage {
            photoFilter.inputImage = scaledImage
            imageView.image = photoFilter.outputImage()
        }
        updateUndoRedoButtonState()
    }

    @objc func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupTargetUISlider() {
        brightnessSlider.addTarget(
            self,
            action: #selector(PhotoEditorViewController.changeBrightness(_:_:)),
            for: .valueChanged)
        contrastSlider.addTarget(
            self,
            action: #selector(PhotoEditorViewController.changeContrast(_:_:)),
            for: .valueChanged)
        saturationSlider.addTarget(
            self,
            action: #selector(PhotoEditorViewController.changeSaturation(_:_:)),
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

    @IBAction func undoTouchUpInside(_ sender: UIButton) {
        imageView.image = photoFilter.doUndoStack()
        updateUndoRedoButtonState()
    }

    @IBAction func redoTouchUpInside(_ sender: UIButton) {
        imageView.image = photoFilter.doRedoStack()
        updateUndoRedoButtonState()
    }
}
