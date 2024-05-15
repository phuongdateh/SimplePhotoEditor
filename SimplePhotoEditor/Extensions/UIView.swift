//
//  UIView.swift
//  SimplePhotoEditor
//
//  Created by James on 14/05/2024.
//

import Foundation
import UIKit

extension UIView {
    func rounded(cornerRadius: CGFloat = 5,
                 color: UIColor = UIColor.gray) {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = 1.0
        layer.borderColor = color.cgColor
    }

    func hide() {
        self.isHidden = true
        self.alpha = 0
    }

    func show() {
        self.isHidden = false
        self.alpha = 1
    }

    func animateHide(duration: TimeInterval = 0.35,
                     completion: ((Bool) -> Void)? = nil) {
        if isHidden && alpha == 0 { return }
        UIView.animate(withDuration: duration,
                       animations: { [weak self] in
            self?.hide()
        }, completion: completion)
    }

    func animateShow(duration: TimeInterval = 0.35,
                     completion: ((Bool) -> Void)? = nil) {
        if !isHidden && alpha == 1 { return }
        UIView.animate(withDuration: duration,
                       animations: { [weak self] in
            self?.show()
        }, completion: completion)
    }
}
