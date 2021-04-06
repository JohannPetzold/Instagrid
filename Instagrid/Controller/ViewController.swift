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
    var imageLayoutTag: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        layoutView.changeLayout(layoutType: 0)
        
        var tapGestures: [UITapGestureRecognizer] = []
        for _ in 0...3 {
            tapGestures.append(UITapGestureRecognizer(target: self, action: #selector(didTap(_:))))
        }
        layoutView.addTapGestures(tapGestures: tapGestures)
    }
    
    /* Remplace le SwipeGestureRecognizer dés que la vue change son bounds (rotation du device) */
    override func viewWillLayoutSubviews() {
        addSwipeGesture()
    }
    
    private func addSwipeGesture() {
        var direction = ""
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(shareLayout(_:)))
        if UIScreen.main.bounds.height > UIScreen.main.bounds.width {
            swipeGesture.direction = [.up]
            direction = "up"
        } else {
            swipeGesture.direction = [.left]
            direction = "left"
        }
        if let removeGesture = layoutView.gestureRecognizers?.first {
            print("DEBUG: Retrait du précédent swipe gesture")
            layoutView.removeGestureRecognizer(removeGesture)
        }
        print("DEBUG: Ajout du swipe " + direction)
        layoutView.addGestureRecognizer(swipeGesture)
    }
    
    /* Tap pour choisir l'image */
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        guard let layout = sender.view as? LayoutImageView else { return }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imageLayoutTag = layout.tag
            takePicture(source: .photoLibrary)
        } else {
            print("DEBUG: Librairie photo non disponible")
        }
    }
    
    /* Swipe pour partager le Layout */
    @objc func shareLayout(_ sender: UISwipeGestureRecognizer) {
        if layoutView.isLayoutDone() {
            animateLayoutForShare()
        } else {
            animateLayoutMissingImages()
            print("DEBUG: Des images sont manquantes")
        }
    }
    
    private func animateLayoutForShare() {
        var translationTransform: CGAffineTransform = CGAffineTransform()
        let screenHeight = UIScreen.main.bounds.height > UIScreen.main.bounds.width ? UIScreen.main.bounds.height : UIScreen.main.bounds.width
        if let imageToShare = layoutView.finalImage {
            let activity = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
            activity.completionWithItemsHandler = { activity, success, items, error in
                if success || !success || error != nil {
                    UIView.animate(withDuration: 0.5) {
                        self.layoutView.transform = .identity
                    }
                }
            }
            if let gesture = layoutView.gestureRecognizers?.first as? UISwipeGestureRecognizer {
                let x = gesture.direction == .up ? 0 : -screenHeight
                let y = gesture.direction == .up ? -screenHeight : 0
                translationTransform = CGAffineTransform(translationX: x, y: y)
                UIView.animate(withDuration: 0.5) {
                    self.layoutView.transform = translationTransform
                } completion: { (success) in
                    self.present(activity, animated: true)
                }
            }
        }
    }
    
    private func animateLayoutMissingImages() {
        layoutView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.005, options: []) {
            self.layoutView.transform = .identity
        }
    }
    
    /* Configure UIImagePickerController et l'affiche avec le SourceType souhaité */
    private func takePicture(source: UIImagePickerController.SourceType) {
        imagePicker.sourceType = source
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    /* Changement du Layout en fonction du bouton */
    @IBAction func chooseLayout(_ sender: UIButton) {
        changeButtonSelected(tag: sender.tag)
        layoutView.changeLayout(layoutType: sender.tag)
    }
    
    /* Modifie le bouton sélectionné */
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
            layoutView.addImageToLayout(image: pictureOriginal, tag: imageLayoutTag)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

