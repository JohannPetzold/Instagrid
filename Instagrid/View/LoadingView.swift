//
//  LoadingView.swift
//  Instagrid
//
//  Created by Johann Petzold on 07/04/2021.
//

import UIKit

class LoadingView: UIView {

    // MARK: - Outlets
    @IBOutlet var spinner: SpinnerView!
    @IBOutlet var loadingLabel: UILabel!
    
    // MARK: - Properties
    var loadingInProgress: Bool = false
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /* Démarre le chargement */
    func startLoading() {
        spinner.start()
        loadingInProgress = true
        randomLabel()
        loadingLabel.isHidden = false
        fadeIn()
    }
    
    /* Arrêt du chargement et animation de fin */
    func stopLoading() {
        spinner.stop()
        loadingInProgress = false
        self.layer.removeAllAnimations()
        loadingLabel.alpha = 1
        loadingLabel.text = "Done!"
        UIView.animate(withDuration: 2) {
            self.loadingLabel.alpha = 0
        }
    }
    
    /* Animation d'apparition */
    private func fadeIn() {
        loadingLabel.alpha = 0
        UIView.animate(withDuration: 0.6, delay: 0, options: []) {
            self.loadingLabel.alpha = 1
        } completion: { (success) in
            if self.loadingInProgress {
                self.fadeOut()
            }
        }
    }
    
    /* Animation de disparition avec changement de text */
    private func fadeOut() {
        loadingLabel.alpha = 1
        UIView.animate(withDuration: 0.6, delay: TimeInterval(Int.random(in: 1...3)), options: []) {
            self.loadingLabel.alpha = 0
        } completion: { (success) in
            if self.loadingInProgress {
                self.randomLabel()
                self.fadeIn()
            }
        }
    }
    
    /* Définition aléatoire du text de chargement */
    private func randomLabel() {
        var newText: String = loadingLabel.text!
        var state: Int
        while loadingLabel.text == newText {
            state = Int.random(in: 1...7)
            switch state {
            case 1: newText = "Merging images..."
            case 2: newText = "Image creation in progress..."
            case 3: newText = "Just few more seconds..."
            case 4: newText = "Soon ready..."
            case 5: newText = "Processing..."
            case 6: newText = "Assembling images..."
            default: newText = "Loading..."
            }
        }
        loadingLabel.text = newText
    }
}
