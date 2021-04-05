//
//  ExtensionUIImage.swift
//  Instagrid
//
//  Created by Johann Petzold on 05/04/2021.
//

import Foundation
import UIKit

extension UIImage {
    
    func mergeWith(topImage: UIImage, topImageArea: CGRect) -> UIImage {
        let bottomImage = self
        
        UIGraphicsBeginImageContext(size)
        
        let area = CGRect(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height)
        bottomImage.draw(in: area)
        topImage.draw(in: topImageArea, blendMode: .normal, alpha: 1.0)
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        print("DEBUG: MergedImage à réussi")
        return mergedImage!
    }
    
    static func createBackgroundLayout(size: CGFloat) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        let background = renderer.image { ctx in
            if let color = UIColor(named: "BackgroundLayout")?.cgColor {
                ctx.cgContext.setFillColor(color)
            } else {
                ctx.cgContext.setFillColor(UIColor.blue.cgColor)
            }
            let rectangle = CGRect(x: 0, y: 0, width: size, height: size)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fill)
        }
        return background
    }
}
