//
//  QuizStats.swift
//  Vägmärken
//
//  Created by Arman Dadmand on 2017-11-22.
//  Copyright © 2017 Arman Dadmand. All rights reserved.
//

import UIKit
import UICircularProgressRing
import Cheers
import GoogleMobileAds

class QuizStats: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, GADInterstitialDelegate {
    
    var interstitial: GADInterstitial!
    
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var progressRing: UICircularProgressRingView!
    @IBOutlet weak var practiceLabel: UILabel!
    
    var totalNumberOfQuestions: Int = 0
    var score: Float = 0
    var scorePercentage: Float = 0
    var needPractice: [Question] = []
    
    let confetti = CheerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Setting up Interstitial AD
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let request = GADRequest()
        interstitial.load(request)
        interstitial = createAndLoadInterstitial()
        interstitial.delegate = self

        
//        Setting up confetti
        confetti.config.particle = .confetti
        confetti.config.colors = [UIColor.red, UIColor.cyan, UIColor.green, UIColor.yellow, UIColor.blue, UIColor.magenta, UIColor.orange]
        confetti.frame = view.frame
        
        
        navigationItem.title = "Resultat"
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        resultsLabel.text = "Resultat: \(Int(score)) av \(totalNumberOfQuestions) rätt"
        
        
        view.addSubview(confetti)
        awesomeLabel()
        
    }
    
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if interstitial.isReady && (needPractice.count > 0)  {
            interstitial.present(fromRootViewController: topMostController())
        } else {
            print("Ad wasn't ready")
            progressRing.ringStyle = .ontop
            progressRing.innerCapStyle = .butt
            progressRing.setProgress(value: CGFloat(scorePercentage) * 100, animationDuration: 1.5) {
            }
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
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        
        confetti.stop()
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
    
//    Gets called when user has 100% accuracy.
    func awesomeLabel() {
        
        if needPractice.count == 0 {

            practiceLabel.text = "Alla rätt! Snyggt jobbat!"
            confetti.start()
        }
        
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
        progressRing.ringStyle = .ontop
        progressRing.innerCapStyle = .butt
        progressRing.setProgress(value: CGFloat(scorePercentage) * 100, animationDuration: 1.5) {
        }
        interstitial = createAndLoadInterstitial()
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
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
