//
//  UIImage+Extensions.swift
//  CardFortress
//
//  Created by Roberto Corrales on 5/6/23.
//

import UIKit

extension UIImage {
    /// Given a required height, returns a (rasterised) copy
        /// of the image, aspect-fitted to that height.
        func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage
        {
            let scale = newHeight / self.size.height
            let newWidth = self.size.width * scale
            let newSize = CGSize(width: newWidth, height: newHeight)
            let renderer = UIGraphicsImageRenderer(size: newSize)

            return renderer.image { _ in
                self.draw(in: CGRect(origin: .zero, size: newSize))
            }
        }
}
