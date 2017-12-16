//
//  QResult.swift
//  Vägmärken
//
//  Created by Arman Dadmand on 2017-11-22.
//  Copyright © 2017 Arman Dadmand. All rights reserved.
//

import UIKit

class QResult: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultBackground: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    
    var correctAnswer: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        self.navigationController?.isNavigationBarHidden = true
        
        delayWithSeconds(0.6) {
            self.dismiss(animated: true, completion: nil);
        }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
   
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    
    func updateUI() {
        
        if correctAnswer == 1 {
            resultLabel.text = "RÄTT SVAR"
            resultBackground.image = #imageLiteral(resourceName: "background_3")
            iconImage.image = #imageLiteral(resourceName: "check-mark-button")
        } else if correctAnswer == 2 {
            resultLabel.text = "FEL SVAR"
            resultBackground.image = #imageLiteral(resourceName: "background_2")
            iconImage.image = #imageLiteral(resourceName: "error")
        }
    }
    
//    LAST
}

