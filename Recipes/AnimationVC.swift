//
//  AnimationVC.swift
//  Enebla
//
//  Copyright © 2020 FV iMAGINATION. All rights reserved.
//

import UIKit
import Lottie

class AnimationVC: UIViewController {

    let animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.9, execute: {
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    func playAnimation(){
        animationView.frame = self.view.frame
        let animation = Animation.named("animation")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        self.view.addSubview(animationView)
        animationView.play()
    }
}
