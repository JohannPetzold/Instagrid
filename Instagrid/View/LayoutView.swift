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
        //
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
    
    func addTapGestures(tapGestures: [UITapGestureRecognizer]) {
        if tapGestures.count == layoutImages.count {
            for x in 0..<tapGestures.count {
                layoutImages[x].addTapGesture(tapGesture: tapGestures[x])
            }
        }
    }
    
    func addImageToLayout(image: UIImage, tag: Int) {
        layoutImages[tag].addImage(image: image)
    }
}
