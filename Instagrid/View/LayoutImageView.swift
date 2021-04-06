//
//  LayoutImageView.swift
//  Instagrid
//
//  Created by Johann Petzold on 02/04/2021.
//

import UIKit

class LayoutImageView: UIView {

    private var layoutImage: UIImageView?
    private var plusImage: UIImageView?
    
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
        if layoutImage != nil {
            layoutImage!.contentMode = .scaleAspectFill
            layoutImage!.clipsToBounds = true
            self.addSubview(layoutImage!)
            
            layoutImage!.translatesAutoresizingMaskIntoConstraints = false
            layoutImage!.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            layoutImage!.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        }
    }
    
    /* Initialisation de l'image Plus avec ses contraintes */
    private func setupPlusImage() {
        plusImage = UIImageView()
        if plusImage != nil {
            plusImage!.image = UIImage(named: "Plus")
            self.addSubview(plusImage!)
            plusImage!.translatesAutoresizingMaskIntoConstraints = false
            plusImage!.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            plusImage!.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            plusImage!.widthAnchor.constraint(equalToConstant: 40).isActive = true
            plusImage!.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
    
    /* Ajoute le tap gesture */
    func addTapGesture(tapGesture: UITapGestureRecognizer) {
        self.addGestureRecognizer(tapGesture)
    }
    
    /* Ajoute une image à l'UIImageView et cache le plus */
    func addImage(image: UIImage) {
        if layoutImage != nil && plusImage != nil {
            layoutImage!.image = image
            plusImage!.isHidden = true
        }
    }
    
    /* Réinitialise l'imageView dans le layout */
    func resetLayout() {
        if layoutImage != nil && plusImage != nil {
            layoutImage!.image = nil
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
     La création de l'UIImage en aspect fill prend beaucoup de ressources ‼️ */
    func getLayoutImage() -> UIImage? {
        print("DEBUG: Récupération de l'image...")
        if layoutImage != nil {
            print("DEBUG: Création de l'image en aspect fill")
            let imageSize = layoutImage!.image!.size
            let imageViewSize = layoutImage!.bounds.size
            
            var scale: CGFloat = imageViewSize.width / imageSize.width
            
            if imageSize.height * scale < imageViewSize.height {
                scale = imageViewSize.height / imageSize.height
            }
            
            let croppedImageSize = CGSize(width: imageViewSize.width / scale, height: imageViewSize.height / scale)
            let croppedImageOrigin = CGPoint(x: (imageSize.width - croppedImageSize.width) / 2.0, y: (imageSize.height - croppedImageSize.height) / 2.0)
            
            let croppedImRect = CGRect(origin: croppedImageOrigin, size: croppedImageSize)
            
            let renderer = UIGraphicsImageRenderer(size: croppedImageSize)
            
            let image = renderer.image { _ in
                layoutImage!.image!.draw(at: CGPoint(x: -croppedImRect.origin.x, y: -croppedImRect.origin.y))
            }
            print("DEBUG: Image en aspect fill créée avec succès")
            return image
        }
        return nil
    }
}
