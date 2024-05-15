//
//  CenteredSliderView.swift
//  SimplePhotoEditor
//
//  Created by James on 15/05/2024.
//

import UIKit

protocol ViewProtocol {

    /// The content of the UIView
    var contentView: UIView! { get }

    /// Attach a custom `Nib` to the view's content
    /// - Parameter viewName: the name of the `Nib` to attachs
    func commonInit(for viewName: String)
}

extension ViewProtocol where Self: UIView {
    func commonInit(for customViewName: String) {
        Bundle.main.loadNibNamed(customViewName, owner: self, options: nil)
        addSubview(contentView)
        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

class CenteredSliderView: UIView, ViewProtocol {
    @IBOutlet var contentView: UIView!
    @IBOutlet var uiSlider: UISlider!
    @IBOutlet var fillerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var fillerTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var fillerView: UIView!
    
    private lazy var backgroundTint: UIColor = UIColor(white: 238 / 255, alpha: 1.0)
    private lazy var fillerTint: UIColor = UIColor(red: 0/255, green: 103/255, blue: 160/255, alpha: 1.0)
    
    private lazy var startValue: Float = 0
    private lazy var endValue: Float = 100
    
    var midValue: Float {
        (startValue + endValue) / 2
    }

    /// Calculates the scale of the slider to normalize the slider's range to the slider's width
    /// By dividing the width of the slider by its total range
    var sliderScale: Float {
        let range = endValue - startValue
        return Float(uiSlider.layer.frame.width) / range
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(for: "\(CenteredSliderView.self)")
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initialize() {
        setupSlider()
        fillerView.backgroundColor = fillerTint
        fillerView.layer.cornerRadius = 4
    }
    fileprivate func setupSlider() {
        uiSlider.minimumValue = startValue
        uiSlider.maximumValue = endValue

        uiSlider.value = midValue // Start slider at the center

        uiSlider.maximumTrackTintColor = backgroundTint
        uiSlider.minimumTrackTintColor = backgroundTint
        uiSlider.thumbTintColor = fillerTint
        uiSlider.tintColor = backgroundTint

        uiSlider.addTarget(self, action: #selector(sliderValueChanged(slider:)), for: .valueChanged)
    }
    
    @objc func sliderValueChanged(slider: UISlider) {
        /// The thumb should snap to center, on reaching close to the center +-2.
        /// This is to indicate that it has been set back to starting value
        if (slider.value - midValue) > -2 && (slider.value - midValue) < 2 {
            slider.value = midValue
        }

        /// This is the distance between the slider's thumb and the center
        /// The `fillColorView`'s width should be equal to this distance multiplied by the scale of the slider
        let distanceFromCenter = slider.value - midValue
        let fillColorViewWidth = distanceFromCenter * sliderScale

        if slider.value > midValue {
            /// If the thumb is to the right of slider's center, then the leading constraint sticks to center
            /// The trailing constraint moves by a constant value of `fillColorViewWidth`
            self.fillerLeadingConstraint.constant = 0
            self.fillerTrailingConstraint.constant = CGFloat(fillColorViewWidth) - 5
        } else if slider.value < midValue {
            /// If the thumb is to the left of slider's center, then the trailing constraint sticks to center
            /// The leading constraint moves by a constant value of `fillColorViewWidth`
            self.fillerLeadingConstraint.constant = CGFloat(fillColorViewWidth) + 5
            self.fillerTrailingConstraint.constant = 0
        } else {
            self.fillerLeadingConstraint.constant = 0
            self.fillerTrailingConstraint.constant = 0
        }

        print(slider.value)
    }
}
