//
//  CropViewController.swift
//  SimplePhotoEditor
//
//  Created by James on 11/05/2024.
//

import UIKit

protocol CropViewControllerDelegate: AnyObject {
    func cropViewController(_ controller: CropViewController,
                            didFinishCroppingImage image: UIImage,
                            transform: CGAffineTransform,
                            cropRect: CGRect)
    func cropViewControllerDidCancel(_ controller: CropViewController)
}

class CropViewController: UIViewController {

    weak var delegate: CropViewControllerDelegate?

    var image: UIImage? {
        didSet {
            cropView?.image = image
        }
    }
    var keepAspectRatio = false {
        didSet {
            cropView?.keepAspectRatio = keepAspectRatio
        }
    }
    var cropAspectRatio: CGFloat = 0.0 {
        didSet {
            cropView?.cropAspectRatio = cropAspectRatio
        }
    }
    var cropRect = CGRect.zero {
        didSet {
            adjustCropRect()
        }
    }
    var imageCropRect = CGRect.zero {
        didSet {
            cropView?.imageCropRect = imageCropRect
        }
    }
    var toolbarHidden = false
    var rotationEnabled = false {
        didSet {
            cropView?.rotationGestureRecognizer.isEnabled = rotationEnabled
        }
    }
    var rotationTransform: CGAffineTransform {
        return cropView!.rotation
    }
    var zoomedCropRect: CGRect {
        return cropView!.zoomedCropRect()
    }

    fileprivate var cropView: CropView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override init(nibName nibNameOrNil: String?,
                  bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }

    fileprivate func initialize() {
        rotationEnabled = true
    }
    
    override func loadView() {
        super.loadView()
        let contentView = UIView()
        contentView.autoresizingMask = .flexibleWidth
        contentView.backgroundColor = UIColor.black
        view = contentView
        cropView = CropView(frame: contentView.bounds)
        contentView.addSubview(cropView!)
    }

    fileprivate func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CropViewController.cancel(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(CropViewController.done(_:)))
    }

    fileprivate func setupToolbarItems() {
        if toolbarItems == nil {
            let constrainButton = UIBarButtonItem(title: "Resolution",
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(CropViewController.constrain(_:)))
            let rotateButton = UIBarButtonItem(title: "Rotate",
                                               style: .plain, 
                                               target: self,
                                               action: #selector(CropViewController.rotate(_:)))
            toolbarItems = [
                .flexibleSpace,
                rotateButton,
                constrainButton,
                .flexibleSpace,
            ]
        }
        navigationController?.isToolbarHidden = toolbarHidden
    }

    fileprivate func setupCropView() {
        cropView?.image = image
        cropView?.rotationGestureRecognizer.isEnabled = rotationEnabled
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        setupToolbarItems()
        setupCropView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if cropAspectRatio != 0 {
            cropView?.cropAspectRatio = cropAspectRatio
        }
        
        if !cropRect.equalTo(CGRect.zero) {
            adjustCropRect()
        }
        
        if !imageCropRect.equalTo(CGRect.zero) {
            cropView?.imageCropRect = imageCropRect
        }
        
        cropView?.keepAspectRatio = keepAspectRatio
    }
    
    func resetCropRect() {
        cropView?.resetCropRect()
    }
    
    func resetCropRectAnimated(_ animated: Bool) {
        cropView?.resetCropRectAnimated(animated)
    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        delegate?.cropViewControllerDidCancel(self)
    }
    
    @objc func done(_ sender: UIBarButtonItem) {
        if let image = cropView?.croppedImage {
            guard let rotation = cropView?.rotation else {
                return
            }
            guard let rect = cropView?.zoomedCropRect() else {
                return
            }
            delegate?.cropViewController(self, didFinishCroppingImage: image, transform: rotation, cropRect: rect)
        }
    }

    var rotationAngle: CGFloat = 0
    @objc func rotate(_ sender: UIBarButtonItem) {
        self.rotationAngle -= CGFloat.pi / 2
        cropView?.rotationAngle = self.rotationAngle
    }

    @objc func constrain(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let original = UIAlertAction(title: "Original", style: .default) { [unowned self] action in
            guard let image = self.cropView?.image else {
                return
            }
            guard var cropRect = self.cropView?.cropRect else {
                return
            }
            let width = image.size.width
            let height = image.size.height
            let ratio: CGFloat
            if width < height {
                ratio = width / height
                cropRect.size = CGSize(width: cropRect.height * ratio, height: cropRect.height)
            } else {
                ratio = height / width
                cropRect.size = CGSize(width: cropRect.width, height: cropRect.width * ratio)
            }
            self.cropView?.cropRect = cropRect
        }
        actionSheet.addAction(original)
        let square = UIAlertAction(title: "Square", style: .default) { [unowned self] action in
            let ratio: CGFloat = 1.0
            if var cropRect = self.cropView?.cropRect {
                let width = cropRect.width
                cropRect.size = CGSize(width: width, height: width * ratio)
                self.cropView?.cropRect = cropRect
            }
        }
        actionSheet.addAction(square)
        let threeByTwo = UIAlertAction(title: "3 x 2", style: .default) { [unowned self] action in
            self.cropView?.cropAspectRatio = 2.0 / 3.0
        }
        actionSheet.addAction(threeByTwo)
        let threeByFive = UIAlertAction(title: "3 x 5", style: .default) { [unowned self] action in
            self.cropView?.cropAspectRatio = 3.0 / 5.0
        }
        actionSheet.addAction(threeByFive)
        let fourByThree = UIAlertAction(title: "4 x 3", style: .default) { [unowned self] action in
            let ratio: CGFloat = 3.0 / 4.0
            if var cropRect = self.cropView?.cropRect {
                let width = cropRect.width
                cropRect.size = CGSize(width: width, height: width * ratio)
                self.cropView?.cropRect = cropRect
            }
        }
        actionSheet.addAction(fourByThree)
        let fourBySix = UIAlertAction(title: "4 x 6", style: .default) { [unowned self] action in
            self.cropView?.cropAspectRatio = 4.0 / 6.0
        }
        actionSheet.addAction(fourBySix)
        let fiveBySeven = UIAlertAction(title: "5 x 7", style: .default) { [unowned self] action in
            self.cropView?.cropAspectRatio = 5.0 / 7.0
        }
        actionSheet.addAction(fiveBySeven)
        let eightByTen = UIAlertAction(title: "8 x 10", style: .default) { [unowned self] action in
            self.cropView?.cropAspectRatio = 8.0 / 10.0
        }
        actionSheet.addAction(eightByTen)
        let widescreen = UIAlertAction(title: "16 x 9", style: .default) { [unowned self] action in
            let ratio: CGFloat = 9.0 / 16.0
            if var cropRect = self.cropView?.cropRect {
                let width = cropRect.width
                cropRect.size = CGSize(width: width, height: width * ratio)
                self.cropView?.cropRect = cropRect
            }
        }
        actionSheet.addAction(widescreen)
        let cancel = UIAlertAction(title: "Cancel", style: .default) { [unowned self] action in
            self.dismiss(animated: true, completion: nil)
        }
        actionSheet.addAction(cancel)
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        
        present(actionSheet, animated: true, completion: nil)
    }

    // MARK: - Private methods
    fileprivate func adjustCropRect() {
        imageCropRect = CGRect.zero
        
        guard var cropViewCropRect = cropView?.cropRect else {
            return
        }
        cropViewCropRect.origin.x += cropRect.origin.x
        cropViewCropRect.origin.y += cropRect.origin.y
        
        let minWidth = min(cropViewCropRect.maxX - cropViewCropRect.minX, cropRect.width)
        let minHeight = min(cropViewCropRect.maxY - cropViewCropRect.minY, cropRect.height)
        let size = CGSize(width: minWidth, height: minHeight)
        cropViewCropRect.size = size
        cropView?.cropRect = cropViewCropRect
    }
}

extension UIBarButtonItem {
    static var flexibleSpace: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
}
