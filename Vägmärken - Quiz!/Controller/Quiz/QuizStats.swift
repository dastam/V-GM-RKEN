//
//  QuizStats.swift
//  Vägmärken - Quiz!
//
//  Created by Arman Dadmand on 2017-11-22.
//  Copyright © 2017 Arman Dadmand. All rights reserved.
//

import UIKit
import UICircularProgressRing

class QuizStats: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var progressRing: UICircularProgressRingView!
    @IBOutlet weak var practiceLabel: UILabel!
    
    var totalNumberOfQuestions: Int = 0
    var score: Float = 0
    var scorePercentage: Float = 0
    var needPractice: [Question] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Resultat"
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        resultsLabel.text = "Resultat: \(Int(score)) av \(totalNumberOfQuestions) rätt"
        
        
        // Do any additional setup after loading the view.
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        progressRing.ringStyle = .ontop
        progressRing.innerCapStyle = .butt
        progressRing.setProgress(value: CGFloat(scorePercentage) * 100, animationDuration: 1.5) {
    
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        restartButton.backgroundColor = Colors.twitterBlue
        restartButton.layer.borderColor = Colors.twitterBlue.cgColor
        
        restartButton.layer.borderWidth = 2.0
        restartButton.layer.cornerRadius = restartButton.frame.size.height/2
        
        if needPractice.count <= 0 {
            practiceLabel.isEnabled = false
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return needPractice.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "signInfo", for: indexPath) as! signInfoCell
        cell.cellImage.image = UIImage(named: needPractice[indexPath.row].correctImageName)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        practiceLabel.text = needPractice[indexPath.row].text
    }
    
    
    
    @IBAction func restartButton(_ sender: UIButton) {
        
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            if vc is SelectQuizViewController {
                _ = self.navigationController?.popToViewController(vc as! SelectQuizViewController, animated: true)
            }
        }
        
    }
    
    
    
}
