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
    
    private func setupLayoutImage() {
        layoutImage = UIImageView()
        if layoutImage != nil {
            layoutImage!.isHidden = true
            layoutImage!.contentMode = .scaleAspectFill
            layoutImage!.clipsToBounds = true
            self.addSubview(layoutImage!)
            
            layoutImage!.translatesAutoresizingMaskIntoConstraints = false
            layoutImage!.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            layoutImage!.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        }
    }
    
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
    
    func addTapGesture(tapGesture: UITapGestureRecognizer) {
        self.addGestureRecognizer(tapGesture)
    }
    
    func addImage(image: UIImage) {
        if layoutImage != nil && plusImage != nil {
            layoutImage!.image = image
            layoutImage!.isHidden = false
            plusImage!.isHidden = true
        }
    }
    
    func hideLayout() {
        if layoutImage != nil && plusImage != nil {
            layoutImage!.image = nil
            plusImage!.isHidden = false
        }
    }
    
    func getLayoutImage() -> UIImage? {
        return layoutImage?.image
    }
}
