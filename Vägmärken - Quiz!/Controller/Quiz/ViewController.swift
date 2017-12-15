//
//  ViewController.swift
//  test
//
//  Created by Arman Dadmand on 2017-10-11.
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


class ViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    lazy var buttons: [UIButton] = [self.button1, self.button2, self.button3, self.button4]
    
    var allQuestions = [Question]()
    var correctAnswer = String()
    var pickedAnswer = String()
    var score: Float = 0
    var questionNumber: Int = 0
    var correct: Int = 0
    var needPractice: [Question] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        allQuestions.shuffle()
        
        button1.imageView?.applyShadow()
        button2.imageView?.applyShadow()
        button3.imageView?.applyShadow()
        button4.imageView?.applyShadow()

        nextQuestion()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //    MARK: Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showQResult" {
       
        let qResultVC = segue.destination as! QResult
        
        qResultVC.correctAnswer = correct
            
        } else if segue.identifier == "showStats" {
            
            let qStatsVC = segue.destination as! QuizStats
            
            qStatsVC.score = score
            qStatsVC.scorePercentage = (score / Float(allQuestions.count))
            qStatsVC.needPractice = needPractice
            qStatsVC.totalNumberOfQuestions = allQuestions.count
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // This method updates UI
    func updateUI() {
        self.performSegue(withIdentifier: "showQResult", sender: self)
    }
    
    // This method checks if the user has got the right answer
    func checkAnswer() {
        
        let correctAnswer = allQuestions[questionNumber].correctAnswer
        
            if pickedAnswer == correctAnswer {
                
                score += 1
                correct = 1
                
                // Just for testing
                print("Yaay! Score is: \(score)")
    
            
            } else if pickedAnswer != correctAnswer {
                
                needPractice.append(allQuestions[questionNumber])
                correct = 2
            }
        
        delayWithSeconds(0.2){
            self.questionNumber += 1
            self.nextQuestion()
            self.navigationItem.title = "\(self.allQuestions.count - self.questionNumber) frågor kvar"
        }

        
    }
    
    // This method will update the question text/images and check if we have reached the end
    func nextQuestion() {
        
        
        if questionNumber <= allQuestions.count - 1 {
            
            navigationItem.title = "\(allQuestions.count - questionNumber) frågor kvar"
            questionLabel.text = allQuestions[questionNumber].text
            button1.setImage(UIImage(named: allQuestions[questionNumber].optionA), for: .normal)
            button2.setImage(UIImage(named: allQuestions[questionNumber].optionB), for: .normal)
            button3.setImage(UIImage(named: allQuestions[questionNumber].optionC), for: .normal)
            button4.setImage(UIImage(named: allQuestions[questionNumber].optionD), for: .normal)
        } else {
            
            for button in self.buttons {
                button.isEnabled = false
            }
            
            self.performSegue(withIdentifier: "showStats", sender: self)
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
//                self.alertStart()
//            })
       
        }
    }
    
    @IBAction func button1pressed(_ sender: UIButton) {
    }
    
    @IBAction func button2pressed(_ sender: UIButton) {
    }
    
    @IBAction func button3pressed(_ sender: UIButton) {
    }
    
    @IBAction func button4pressed(_ sender: UIButton) {
    }
    
    @IBAction func answerPressed(_ sender: UIButton) {
        
        if sender.tag == 1 {
            pickedAnswer = "1"
        }
        else if sender.tag == 2 {
            pickedAnswer = "2"
        }
        else if sender.tag == 3 {
            pickedAnswer = "3"
        }
        else if sender.tag == 4 {
            pickedAnswer = "4"
        }
        
        checkAnswer()
        updateUI()
  
        }
        
//        questionNumber += 1
        
//        nextQuestion()

    
    func startOver() {
        
        
        for button in self.buttons {
            button.isEnabled = true
        }
        
        questionNumber = 0
        score = 0
        nextQuestion()
        
        
    }
    
    func alertStart() {
        
        let alert =  UIAlertController(title: "Snyggt!", message: "Du har svarat på alla frågor, vill du börja om?", preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "Börja om", style: .default, handler: { (UIAlertAction) in
            self.startOver()
        })
        
        alert.addAction(restartAction)
        
        
        present(alert, animated: true, completion: nil)

        
        allQuestions.shuffle()
    }

    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    
    

}



extension Array {
    public mutating func shuffle() {
        for i in stride(from: count - 1, through: 1, by: -1) {
            let random = Int(arc4random_uniform(UInt32(i+1)))
            if i != random {
                self.swapAt(i, random)
            }
        }
    }
}
