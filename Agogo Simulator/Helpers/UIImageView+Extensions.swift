//
//  UIImageView+Extensions.swift
//  Agogo Simulator
//
//  Created by Bernardo Duarte on 07/10/18.
//  Copyright © 2018 Bernardo Duarte. All rights reserved.
//

import UIKit

extension UIImageView {
    var imageActualRect: CGRect {
        guard let imageSize = image?.size else { return CGRect.zero }

        // Figure out image aspect
        let scaleWidth = frame.size.width / imageSize.width
        let scaleHeight = frame.size.height / imageSize.height
        let aspect = fmin(scaleWidth, scaleHeight)

        var imageRect = CGRect(x: 0,
                               y: 0,
                               width: imageSize.width * aspect,
                               height: imageSize.height * aspect)

        // Center image
        imageRect.origin.x = (frame.size.width - imageRect.size.width) / 2
        imageRect.origin.y = (frame.size.height - imageRect.size.height) / 2

        // Add imageView offset
        imageRect.origin.x += frame.origin.x
        imageRect.origin.y += frame.origin.y

        return imageRect
    }
}
