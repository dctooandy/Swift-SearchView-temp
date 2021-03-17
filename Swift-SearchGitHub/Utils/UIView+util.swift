//
//  UIView+util.swift
//  Swift-SearchGitHub
//
//  Created by AndyChen on 2021/3/17.
//

import Foundation
import UIKit

extension UIView {
    func applyCornerRadius(radius:CGFloat = 5) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }
}
