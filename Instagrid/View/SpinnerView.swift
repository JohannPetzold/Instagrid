//
//  SpinnerView.swift
//  Instagrid
//
//  Created by Johann Petzold on 07/04/2021.
//

import UIKit

class SpinnerView: UIActivityIndicatorView {

    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.isHidden = false
//        if #available(iOS 13.0, *) {
//            self.style = .large
//        } else {
//            self.style = .whiteLarge
//        }
    }
    
    func start() {
        self.isHidden = false
        self.startAnimating()
    }
    
    func stop() {
        self.isHidden = true
        self.stopAnimating()
    }

}
