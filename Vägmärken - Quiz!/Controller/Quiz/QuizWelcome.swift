//
//  quizWelcome.swift
//  Vägmärken - Quiz!
//
//  Created by Arman Dadmand on 2017-11-18.
//  Copyright © 2017 Arman Dadmand. All rights reserved.
//

import UIKit

class QuizWelcome: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        continueButton.layer.borderWidth = 2.0
        continueButton.layer.cornerRadius = continueButton.frame.size.height/2
        continueButton.layer.borderColor = Colors.twitterBlue.cgColor
        continueButton.backgroundColor = Colors.twitterBlue
        
        self.navigationController?.isNavigationBarHidden = true
        
        
        // Do any additional setup after loading the view.
        

        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func continueButton(_ sender: UIButton) {
        performSegue(withIdentifier: "showQuiz", sender: self)
    }
    
 
}
