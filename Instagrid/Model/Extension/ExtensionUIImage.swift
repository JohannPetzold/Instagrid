//
//  ExtensionUIImage.swift
//  Instagrid
//
//  Created by Johann Petzold on 05/04/2021.
//

import Foundation
import UIKit

extension UIImage {
    
    /* Assemble deux images ; Prend en paramètre l'image du dessus et son emplacement */
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
    
    /* Crée le background du Layout avec la bonne couleur */
    static func createBackgroundLayout() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: GRID_SIZE, height: GRID_SIZE))
        let background = renderer.image { imageContext in
            if let color = UIColor(named: "BackgroundLayout")?.cgColor {
                imageContext.cgContext.setFillColor(color)
            } else {
                imageContext.cgContext.setFillColor(UIColor.blue.cgColor)
            }
            let rectangle = CGRect(x: 0, y: 0, width: GRID_SIZE, height: GRID_SIZE)
            imageContext.cgContext.addRect(rectangle)
            imageContext.cgContext.drawPath(using: .fill)
        }
        return background
    }
}
