//
//  DetailView.swift
//  Vägmärken - Quiz!
//
//  Created by Arman Dadmand on 2017-12-09.
//  Copyright © 2017 Arman Dadmand. All rights reserved.
//

import UIKit

class DetailView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var receivedData: Int?
    var passedSign = Signs(text: "", correctAnswer: #imageLiteral(resourceName: "a14"), signExpl: "")
    var passedSignsArray = [Signs]()
    var indexpath = IndexPath()
    var initialScrollDone: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.collectionView.isPagingEnabled = true
        self.collectionView?.frame = view.frame.insetBy(dx: -20.0, dy: 0.0)
       
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customCell")
    
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !self.initialScrollDone {
            
        self.collectionView.scrollToItem(at: indexpath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
            initialScrollDone = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return passedSignsArray.count
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.up {
            self.dismiss(animated: true, completion: nil)
        }
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
