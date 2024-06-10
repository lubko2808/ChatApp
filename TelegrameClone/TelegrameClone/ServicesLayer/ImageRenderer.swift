//
//  ImageRenderer.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 09.06.2024.
//

import UIKit

protocol ImageRendererProtocol {
    func createDefaultProfilePicture(titleLetter: Character) -> UIImage
}

final class ImageRenderer: ImageRendererProtocol {
    
    public func createDefaultProfilePicture(titleLetter: Character) -> UIImage {
        let titleLetter = titleLetter.uppercased()
        let imageSize: CGFloat = 50
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: imageSize, height: imageSize))
        let image = renderer.image { context in
            let ctx = context.cgContext
            ctx.setFillColor(UIColor.clear.cgColor)
            ctx.fill(CGRect(x: 0, y: 0, width: imageSize, height: imageSize))

            ctx.setFillColor(UIColor.randomColor().cgColor)
            ctx.fillEllipse(in: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.Roboto.bold.size(of: 25),
                .foregroundColor: UIColor.white
            ]
            let label = UILabel()
            label.attributedText = NSAttributedString(string: titleLetter, attributes: attributes)
            let textSize = label.intrinsicContentSize
            let textRect = CGRect(origin: .init(x: imageSize / 2 - textSize.width / 2, y: imageSize / 2 - textSize.height / 2), size: textSize)
            titleLetter.draw(in: textRect, withAttributes: attributes)
        }
        return image
    }
    
}
