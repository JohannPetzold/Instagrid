//
//  LayoutImageView.swift
//  Instagrid
//
//  Created by Johann Petzold on 02/04/2021.
//

import UIKit
import AVFoundation

class LayoutImageView: UIView {

    // MARK: - Properties
    private var layoutImage: UIImageView!
    private var plusImage: UIImageView!
    private var copyImage: UIImage?
    private var copyImageSize: CGSize?
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        setupLayoutImage()
        setupPlusImage()
    }
    
    /* Initialisation de layoutImage avec ses contraintes */
    private func setupLayoutImage() {
        layoutImage = UIImageView()
        layoutImage.contentMode = .scaleAspectFill
        layoutImage.clipsToBounds = true
        self.addSubview(layoutImage)
        
        layoutImage.translatesAutoresizingMaskIntoConstraints = false
        layoutImage.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        layoutImage.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    /* Initialisation de l'image Plus avec ses contraintes */
    private func setupPlusImage() {
        plusImage = UIImageView()
        plusImage.image = UIImage(named: "Plus")
        self.addSubview(plusImage)
        
        plusImage.translatesAutoresizingMaskIntoConstraints = false
        plusImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        plusImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        plusImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        plusImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    /* Ajoute le tap gesture */
    func addTapGesture(tapGesture: UITapGestureRecognizer) {
        self.addGestureRecognizer(tapGesture)
    }
    
    /* Ajoute une image à l'UIImageView, cache le plus
      et récupère une copie de l'image et de sa CGSize dans son conteneur */
    func addImage(image: UIImage) {
        if layoutImage != nil && plusImage != nil {
            layoutImage!.image = image
            copyImage = image
            copyImageSize = layoutImage!.bounds.size
            plusImage!.isHidden = true
        }
    }
    
    /* Réinitialise l'imageView dans le layout */
    func resetLayout() {
        if layoutImage != nil && plusImage != nil {
            layoutImage!.image = nil
            copyImage = nil
            copyImageSize = nil
            plusImage!.isHidden = false
        }
    }
    
    /* Renvoi true si une image est définie */
    func isImageDefine() -> Bool {
        if layoutImage != nil && layoutImage!.image != nil {
            return true
        }
        return false
    }
    
    /* Récupère l'image telle qu'elle est affichée dans UIImageView
     copyImage et copyImageSize permettent d'utiliser cette méthode en background */
    func getLayoutImage() -> UIImage? {
        print("DEBUG: Récupération de l'image...")
        if copyImage != nil {
            print("DEBUG: Création de l'image en aspect fill")
            let imageSize = copyImage!.size
            let imageViewSize = copyImageSize!

            var scale: CGFloat = imageViewSize.width / imageSize.width

            if imageSize.height * scale < imageViewSize.height {
                scale = imageViewSize.height / imageSize.height
            }

            let croppedImageSize = CGSize(width: imageViewSize.width / scale, height: imageViewSize.height / scale)
            let croppedImageOrigin = CGPoint(x: (imageSize.width - croppedImageSize.width) / 2.0, y: (imageSize.height - croppedImageSize.height) / 2.0)
            let croppedImRect = CGRect(origin: croppedImageOrigin, size: croppedImageSize)

            let format = UIGraphicsImageRendererFormat()
            format.scale = 1
            let renderer = UIGraphicsImageRenderer(size: croppedImageSize, format: format)

            let image = renderer.image { _ in
                copyImage!.draw(at: CGPoint(x: -croppedImRect.origin.x, y: -croppedImRect.origin.y))
            }
            print("DEBUG: Image en aspect fill créée avec succès")
            
            return image
        }
        return nil
    }
}
