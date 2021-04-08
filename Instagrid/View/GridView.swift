//
//  LayoutView.swift
//  Instagrid
//
//  Created by Johann Petzold on 02/04/2021.
//

import UIKit

class GridView: UIView {

    // MARK: - Outlets
    @IBOutlet private var layoutImages: [LayoutImageView]!
    
    // MARK: - Properties
    var actualLayoutType: Int = 0
    var layoutDone: Bool = false
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
    func createFinalImage(completionHandler: @escaping (UIImage?) -> Void) {
        // Pour pouvoir DispatchQueue en background
        var isImageHidden: [Bool] = []
        var imagesArea: [CGRect?] = []
        for x in 0..<layoutImages.count {
            isImageHidden.append(layoutImages[x].isHidden)
            if layoutImages[x].isHidden == false {
                imagesArea.append(getAreaForImage(x: x))
            } else {
                imagesArea.append(nil)
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            var finalImage = UIImage.createBackgroundLayout()
            for x in 0..<self.layoutImages.count {
                if isImageHidden[x] == false {
                    print("DEBUG: Traitement de l'image \(x + 1) du Layout")
                    if let layoutImage = self.layoutImages[x].getLayoutImage() {
                        print("DEBUG: Récupération de l'image réussi")
                        print("DEBUG: Assemblage de l'image \(x + 1) avec le Layout")
                        finalImage = finalImage.mergeWith(topImage: layoutImage, topImageArea: imagesArea[x]!)
                        print("DEBUG: Image \(x + 1) assemblée avec succès\n")
                    }
                }
            }
            print("DEBUG: Toutes les images ont été assemblées")
            completionHandler(finalImage)
        }
    }
    
    /* Permet de récupérer le CGRect permettant l'assemblage du Layout en fonction de l'image en cours */
    private func getAreaForImage(x: Int) -> CGRect {
        let margin: CGFloat = GRID_SIZE / 20
        let coordinate = layoutImages[x].convert(layoutImages[x].bounds.origin, to: self)
        let height = (GRID_SIZE / 2) - ((margin / 2) + margin)
        let valX = GRID_SIZE * (coordinate.x * 100 / self.frame.width) / 100
        let valY = GRID_SIZE * (coordinate.y * 100 / self.frame.height) / 100
        let width = layoutImages[x].frame.width > self.frame.width / 2 ? height * 2 + margin : height

        return CGRect(x: valX, y: valY, width: width, height: height)
    }
}
