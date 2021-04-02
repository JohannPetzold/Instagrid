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
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        self.setBackgroundImage(UIImage(named: "Layout \(self.tag + 1)"), for: .normal)
        if self.tag == 0 {
            self.isSelected = true
        }
    }
}
