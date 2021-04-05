//
//  LayoutView.swift
//  Instagrid
//
//  Created by Johann Petzold on 02/04/2021.
//

import UIKit

class LayoutView: UIView {

    @IBOutlet private var layoutImages: [LayoutImageView]!
    var actualTag: Int = 0
    
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

    func changeLayout(tag: Int) {
        if tag == 0 {
            layoutImages[1].isHidden = true
            layoutImages[3].isHidden = false
        } else if tag == 1 {
            layoutImages[1].isHidden = false
            layoutImages[3].isHidden = true
        } else if tag == 2 {
            layoutImages[1].isHidden = false
            layoutImages[3].isHidden = false
        }
        if actualTag != tag {
            for x in 0..<layoutImages.count {
                layoutImages[x].hideLayout()
            }
            actualTag = tag
        }
    }
    
    func addImageToLayout(image: UIImage, tag: Int) {
        layoutImages[tag].addImage(image: image)
    }
    
    func addTapGestures(tapGestures: [UITapGestureRecognizer]) {
        if tapGestures.count == layoutImages.count {
            for x in 0..<tapGestures.count {
                layoutImages[x].addTapGesture(tapGesture: tapGestures[x])
            }
        }
    }
    
    func isLayoutDone() -> Bool {
        if layoutImages.filter({ (layoutImageView) -> Bool in
            return layoutImageView.isHidden == false && layoutImageView.getLayoutImage() == nil
        }).count == 0 {
            return true
        }
        return false
    }
    
    func createFinalImage() -> UIImage {
        var finalImage = UIImage.createBackgroundLayout(size: 512)
        for x in 0..<layoutImages.count {
            if layoutImages[x].isHidden == false {
                if let layoutImage = layoutImages[x].getLayoutImage() {
                    // A FAIRE
                    let area = CGRect(x: layoutImages[x].frame.minX, y: layoutImages[x].frame.minY, width: layoutImages[x].frame.width, height: layoutImages[x].frame.height)
                    finalImage = finalImage.mergeWith(topImage: layoutImage, topImageArea: area)
                }
            }
        }
        return finalImage
    }
}
