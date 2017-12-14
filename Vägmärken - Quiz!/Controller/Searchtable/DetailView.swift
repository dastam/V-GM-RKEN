//
//  DetailView.swift
//  Vägmärken - Quiz!
//
//  Created by Arman Dadmand on 2017-12-09.
//  Copyright © 2017 Arman Dadmand. All rights reserved.
//

import UIKit
import BulletinBoard

class DetailView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var receivedData: Int?
    var passedSign = Signs(text: "", correctAnswer: #imageLiteral(resourceName: "a14"), signExpl: "")
    var passedSignsArray = [Signs]()
    var indexpath = IndexPath()
    var initialScrollDone: Bool = false
   
    let numberOfLaunches = UserDefaults.standard.integer(forKey: "numberOfLaunches")
    
    
    public var minimumVelocityToHide = 1500 as CGFloat
    public var minimumScreenRatioToHide = 0.5 as CGFloat
    public var animationDuration = 0.2 as TimeInterval
    
    
    lazy var bulletinManager: BulletinManager = {
        let introPage = BulletinDataSource.makeIntroPage()
        return BulletinManager(rootItem: introPage)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.collectionView.isPagingEnabled = true
        self.collectionView?.frame = view.frame.insetBy(dx: -20.0, dy: 0.0)
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customCell")
    
        // Do any additional setup after loading the view.
        
        // Listen for pan gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        self.view.addGestureRecognizer(panGesture)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    }
    
    func slideViewVerticallyTo(_ y: CGFloat) {
        self.view.frame.origin = CGPoint(x: 0, y: y)
    }
    
    @objc func onPan(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began, .changed:
            // If pan started or is ongoing then
            // slide the view to follow the finger
            let translation = panGesture.translation(in: view)
            let y = max(0, translation.y)
            self.slideViewVerticallyTo(y)
            break
        case .ended:
            // If pan ended, decide it we should close or reset the view
            // based on the final position and the speed of the gesture
            let translation = panGesture.translation(in: view)
            let velocity = panGesture.velocity(in: view)
            let closing = (translation.y > self.view.frame.size.height * (minimumScreenRatioToHide * 0.25)) ||
                (velocity.y > minimumVelocityToHide)
            
            if closing {
                UIView.animate(withDuration: animationDuration, animations: {
                    // If closing, animate to the bottom of the view
                    self.slideViewVerticallyTo(self.view.frame.size.height)
                }, completion: { (isCompleted) in
                    if isCompleted {
                        // Dismiss the view when it dissapeared
                        self.dismiss(animated: false, completion: nil)
                    }
                })
            } else {
                // If not closing, reset the view to the top
                UIView.animate(withDuration: animationDuration, animations: {
                    self.slideViewVerticallyTo(0)
                })
            }
            break
        default:
            // If gesture state is undefined, reset the view to the top
            UIView.animate(withDuration: animationDuration, animations: {
                self.slideViewVerticallyTo(0)
            })
            break
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen;
        self.modalTransitionStyle = .coverVertical;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.modalPresentationStyle = .overFullScreen;
        self.modalTransitionStyle = .coverVertical;
    }
    
    //    ********************************
    //    MARK: LAYOUT SUBVIEWS
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !self.initialScrollDone {
            
        self.collectionView.scrollToItem(at: indexpath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        initialScrollDone = true
 
            if !neverShowAgain && (numberOfLaunches < 1){
            bulletinManager.prepare()
            bulletinManager.presentBulletin(above: self)
               
                UserDefaults.standard.set(numberOfLaunches+1, forKey: "numberOfLaunches")
                print("number of launches \(numberOfLaunches)")
            }

        }
  }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return passedSignsArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.frame.size.width
        let itemHeight = collectionView.frame.size.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CollectionViewCell
        cell.signImage.image = passedSignsArray[indexPath.row].correctAnswer
        cell.signLabel.text = passedSignsArray[indexPath.row].signExpl
        cell.signHeadline.text = passedSignsArray[indexPath.row].text
        cell.signImage.applyShadow()
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 //set return 0 for no spacing you can check to change the return value
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

    
}
