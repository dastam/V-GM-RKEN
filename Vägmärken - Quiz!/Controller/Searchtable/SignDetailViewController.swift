//
//  SignDetailViewController.swift
//  Vägmärken - Quiz!
//
//  Created by Arman Dadmand on 2017-11-05.
//  Copyright © 2017 Arman Dadmand. All rights reserved.
//

import UIKit

extension UIImageView {
    
    // APPLY DROP SHADOW
    func applyShadow() {
        let layer           = self.layer
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0, height: 6)
        layer.shadowOpacity = 0.6
        layer.shadowRadius  = 2
    }
    
}

// // // // // // // // // // // // // // // // // // // // // // //

class SignDetailViewController: UIViewController {
    
    var receivedData: Int?

    var secondVCReceivedData: Int?
    
    var passedSign = Signs(text: "", correctAnswer: #imageLiteral(resourceName: "a14"), signExpl: "")
    var passedSignsArray = [Signs]()
    
    @IBOutlet weak var signHeadline: UILabel!
    @IBOutlet weak var signImage: UIImageView!
    @IBOutlet weak var signLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
    
       
        signImage.applyShadow()
        signHeadline.numberOfLines = 2
        signHeadline.adjustsFontSizeToFitWidth = true
        
        updateUI()

        // Do any additional setup after loading the view.
        
        
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
        }
            
        else if gesture.direction == UISwipeGestureRecognizerDirection.left {
            }

        else if gesture.direction == UISwipeGestureRecognizerDirection.up {
            
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.down {
             self.dismiss(animated: true, completion: nil)
        }
    }

    func updateUI() {
        
        signLabel.text = passedSign.signExpl
        signHeadline.text = passedSign.text
        signImage.image = passedSign.correctAnswer
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signLabel.setContentOffset(CGPoint.zero, animated: false)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//    @IBAction func dismissButton(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    

}
