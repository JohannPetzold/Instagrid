//
//  ViewController.swift
//  Instagrid
//
//  Created by Johann Petzold on 29/03/2021.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private var layoutButtons: [LayoutButton]!
    @IBOutlet private weak var gridView: GridView!
    @IBOutlet weak var loadingView: LoadingView!
    
    // MARK: - Properties
    var imagePicker = UIImagePickerController()
    private var imageLayoutTag: Int = 0
    
    // MARK: - Actions
    /* Changement du Layout en fonction du bouton */
    @IBAction func chooseLayout(_ sender: UIButton) {
        if !loadingView.loadingInProgress {
            changeButtonSelected(tag: sender.tag)
            gridView.changeLayout(layoutType: sender.tag)
        }
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        gridView.changeLayout(layoutType: 0)
        
        var tapGestures: [UITapGestureRecognizer] = []
        for _ in 0...3 {
            tapGestures.append(UITapGestureRecognizer(target: self, action: #selector(didTap(_:))))
        }
        gridView.addTapGestures(tapGestures: tapGestures)
        addSwipeGesture()
    }
    
    /* Remplace le SwipeGestureRecognizer dés que la vue change d'orientation */
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        addSwipeGesture(transition: true)
    }
    
    /* Permet l'ajout du SwipeGesture ; Le paramètre permet son utilisation dans le viewDidLoad et dans viewWillTransition */
    private func addSwipeGesture(transition: Bool = false) {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(shareLayout(_:)))
        if !transition {
            swipeGesture.direction = UIScreen.main.bounds.height > UIScreen.main.bounds.width ? [.up] : [.left]
        } else {
            swipeGesture.direction = UIDevice.current.orientation.isLandscape ? [.left] : [.up]
        }
        if let removeGesture = gridView.gestureRecognizers?.first {
            print("DEBUG: Retrait du précédent swipe gesture")
            gridView.removeGestureRecognizer(removeGesture)
        }
        print("DEBUG: Ajout du swipe")
        gridView.addGestureRecognizer(swipeGesture)
    }
    
    /* Tap pour choisir l'image ; Contrôle si photoLibrary est disponible comme source */
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        guard let layout = sender.view as? LayoutImageView else { return }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imageLayoutTag = layout.tag
            takePicture(source: .photoLibrary)
        } else {
            print("DEBUG: Librairie photo non disponible")
        }
    }
    
    /* Configure UIImagePickerController et l'affiche avec le SourceType souhaité */
    private func takePicture(source: UIImagePickerController.SourceType) {
        imagePicker.sourceType = source
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    /* Swipe pour partager le Layout */
    @objc func shareLayout(_ sender: UISwipeGestureRecognizer) {
        if gridView.isLayoutDone() {
            animateLayoutForShare()
        } else {
            animateLayoutMissingImages()
            print("DEBUG: Des images sont manquantes")
        }
    }
    
    /* Animation de partage ; Attend le retour de l'image final pour présenter ActivityViewController */
    private func animateLayoutForShare() {
        var translationTransform: CGAffineTransform = CGAffineTransform()
        let screenHeight = UIScreen.main.bounds.height > UIScreen.main.bounds.width ? UIScreen.main.bounds.height : UIScreen.main.bounds.width
        
        if let gesture = gridView.gestureRecognizers?.first as? UISwipeGestureRecognizer {
            let x = gesture.direction == .up ? 0 : -screenHeight
            let y = gesture.direction == .up ? -screenHeight : 0
            translationTransform = CGAffineTransform(translationX: x, y: y)
            loadingView.startLoading()
            UIView.animate(withDuration: 0.5) {
                self.gridView.transform = translationTransform
            } completion: { (success) in
                self.gridView.createFinalImage { image in
                    if image != nil {
                        let activity = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
                        activity.completionWithItemsHandler = { activity, success, items, error in
                            UIView.animate(withDuration: 0.5) {
                                self.gridView.transform = .identity
                            }
                        }
                        DispatchQueue.main.async {
                            self.loadingView.stopLoading()
                            self.present(activity, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    /* Animation en cas d'images manquantes */
    private func animateLayoutMissingImages() {
        gridView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.005, options: []) {
            self.gridView.transform = .identity
        }
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
            gridView.addImageToLayout(image: pictureOriginal, tag: imageLayoutTag)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

