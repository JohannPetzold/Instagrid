//
//  ViewController.swift
//  Instagrid
//
//  Created by Johann Petzold on 29/03/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var layoutButtons: [LayoutButton]!
    @IBOutlet weak var layoutView: LayoutView!
    
    var imagePicker = UIImagePickerController()
    var tag: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        layoutView.changeLayout(tag: 0)
        var tapGestures: [UITapGestureRecognizer] = []
        for _ in 0...3 {
            tapGestures.append(UITapGestureRecognizer(target: self, action: #selector(didTap(_:))))
        }
        layoutView.addTapGestures(tapGestures: tapGestures)
    }
    
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        if let layout = sender.view as? LayoutImageView {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                tag = layout.tag
                takePicture(source: .photoLibrary)
            } else {
                print("DEBUG: Caméra non disponible")
            }
        }
    }
    
    private func takePicture(source: UIImagePickerController.SourceType) {
        imagePicker.sourceType = source
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func chooseLayout(_ sender: UIButton) {
        changeButtonSelected(tag: sender.tag)
        layoutView.changeLayout(tag: sender.tag)
    }
    
    private func changeButtonSelected(tag: Int) {
        for x in 0..<layoutButtons.count {
            if x == tag {
                layoutButtons[x].isSelected = true
            } else {
                layoutButtons[x].isSelected = false
            }
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pictureOriginal = info[.originalImage] as? UIImage {
            layoutView.addImageToLayout(image: pictureOriginal, tag: tag)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

