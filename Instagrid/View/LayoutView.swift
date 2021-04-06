//
//  LayoutView.swift
//  Instagrid
//
//  Created by Johann Petzold on 02/04/2021.
//

import UIKit

class LayoutView: UIView {

    @IBOutlet private var layoutImages: [LayoutImageView]!
    var actualLayoutType: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
    }

    /* Change la disposition du Layout en fonction du tag (bouton appuyé) */
    func changeLayout(layoutType: Int) {
        if layoutType == 0 {
            layoutImages[1].isHidden = true
            layoutImages[3].isHidden = false
        } else if layoutType == 1 {
            layoutImages[1].isHidden = false
            layoutImages[3].isHidden = true
        } else if layoutType == 2 {
            layoutImages[1].isHidden = false
            layoutImages[3].isHidden = false
        }
        if actualLayoutType != layoutType {
            for x in 0..<layoutImages.count {
                layoutImages[x].resetLayout()
            }
            actualLayoutType = layoutType
        }
    }
    
    /* Ajoute l'image à la case correspondante, tag correspond au tag du LayoutImageView selectionné */
    func addImageToLayout(image: UIImage, tag: Int) {
        layoutImages[tag].addImage(image: image)
    }
    
    /* Ajoute les gestures aux LayoutImageView */
    func addTapGestures(tapGestures: [UITapGestureRecognizer]) {
        if tapGestures.count == layoutImages.count {
            for x in 0..<tapGestures.count {
                layoutImages[x].addTapGesture(tapGesture: tapGestures[x])
            }
        }
    }
    
    /* Vérifie si les LayoutImageView qui sont présentes dans le Layout possèdent une image */
    func isLayoutDone() -> Bool {
        if layoutImages.filter({ (layoutImageView) -> Bool in
            return layoutImageView.isHidden == false && !layoutImageView.isImageDefine()
        }).count == 0 {
            return true
        }
        return false
    }
    
    /* Crée le Layout final en assemblant les images présentent dans une UIImage */
    func createFinalImage() -> UIImage {
        let size: CGFloat = 1024
        var finalImage = UIImage.createBackgroundLayout(size: size)
        for x in 0..<layoutImages.count {
            if layoutImages[x].isHidden == false {
                print("DEBUG: Traitement de l'image \(x + 1) du Layout")
                if let layoutImage = layoutImages[x].getLayoutImage() {
                    print("DEBUG: Récupération de l'image réussi")
                    print("DEBUG: Définition de la zone pour placer l'image dans le Layout")
                    let area = getAreaForImage(size: size, x: x)
                    print("DEBUG: Zone récupérée")
                    print("DEBUG: Assemblage de l'image \(x + 1) avec le Layout")
                    finalImage = finalImage.mergeWith(topImage: layoutImage, topImageArea: area)
                    print("DEBUG: Image \(x + 1) assemblée avec succès\n")
                }
            }
        }
        print("DEBUG: Toutes les images ont été assemblées")
        return finalImage
    }
    
    /* Permet de récupérer le CGRect permettant l'assemblage du Layout en fonction de l'image en cours et la taille souhaitée */
    private func getAreaForImage(size: CGFloat, x: Int) -> CGRect {
        var valX: CGFloat = 0
        var valY: CGFloat = 0
        var width: CGFloat = 0
        var height: CGFloat = 0
        let margin: CGFloat = size / 20
        if x < layoutImages.count - 1 && layoutImages[x + 1].isHidden == true {
            valX = margin
            width = size - (margin * 2)
            height = (width / 2) - (margin / 2)
            if x == 0 {
                valY = margin
            } else if x == 2 {
                valY = (size / 2) + (margin / 2)
            }
        } else {
            width = (size / 2) - ((margin / 2) + margin)
            height = width
            if x == 0 || x == 2 {
                valX = margin
                valY = margin + (CGFloat(x) * ((size / 2 - (margin / 2))/2))
            } else {
                valX = (size / 2 + (margin / 2))
                if x == 1 {
                    valY = margin
                } else if x == 3 {
                    valY = (size / 2) + (margin / 2)
                }
            }
        }
        return CGRect(x: valX, y: valY, width: width, height: height)
    }
}
