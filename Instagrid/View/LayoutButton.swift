//
//  LayoutButton.swift
//  Instagrid
//
//  Created by Johann Petzold on 02/04/2021.
//

import UIKit

class LayoutButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    /* Initialise le bouton avec l'image correspondante à son tag */
    private func setup() {
        self.setBackgroundImage(UIImage(named: "Layout \(self.tag + 1)"), for: .normal)
        if self.tag == 0 {
            self.isSelected = true
        }
    }
}
