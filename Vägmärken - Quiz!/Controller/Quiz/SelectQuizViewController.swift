//
//  SelectQuizViewController.swift
//  Vägmärken - Quiz!
//
//  Created by Arman Dadmand on 2017-11-12.
//  Copyright © 2017 Arman Dadmand. All rights reserved.
//

import UIKit

class SelectQuizViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var quizTableView: UITableView!
    
    
//    lazy var switches : [UISwitch] = [self.switch1, self.switch2, self.switch3, self.switch4]
    
    var quizCategories = [QuestionArray]()
    var pickedCategory: Int = 0
    var categoryID: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        quizTableView.allowsMultipleSelection = true
        
        
        quizCategories = loadData()
        
//---        Setting up delegates for UITableViewController
        quizTableView.delegate = self
        quizTableView.dataSource = self
        
        quizTableView.register(UINib(nibName: "CatTableViewCell", bundle: nil), forCellReuseIdentifier: "newCatCell")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
         categoryID.removeAll()
        
        if let indexPath = quizTableView.indexPathForSelectedRow {
            quizTableView.deselectRow(at: indexPath, animated: animated)
        }
        quizTableView.reloadData()
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableViewDelegates:
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return quizCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCatCell", for: indexPath) as! CatTableViewCell
        cell.selectionStyle = .none
        
        let category = quizCategories[indexPath.row]
        
        cell.imageView?.image = category.catImage
        cell.textLabel?.text = category.category
        
        let selectedIndexPaths = quizTableView.indexPathsForSelectedRows
        let rowIsSelected = selectedIndexPaths != nil && selectedIndexPaths!.contains(indexPath)
        cell.accessoryType = rowIsSelected ? .checkmark : .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        categoryID.append(indexPath.row)
        
        let cell = quizTableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
       
        categoryID = categoryID.filter{$0 != indexPath.row}
        
        let cell = quizTableView.cellForRow(at: indexPath)!
        cell.accessoryType = .none
    }
    

    
    // MARK: - Navigation
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let secondVC = segue.destination as! ViewController
    

        let newArray = categoryID.flatMap { quizCategories[$0].questions }
        
        
        secondVC.allQuestions = newArray
        
    }
    
    
    @IBAction func startButton(_ sender: UIButton) {
        if categoryID.count > 0 {

        performSegue(withIdentifier: "startQuiz", sender: self)
        }
    }
    
    func loadData() -> [QuestionArray] {
        
//        VARNINGSFRÅGOR - 12st
        
        let question1 = Question(text: "Varning för flera farliga kurvor", optionA: "a10-1", optionB: "a2-1", optionC: "a1-1", optionD: "a5-2", correctAnswer: "2", correctImageName: "a2-1")
        
        let question2 = Question(text: "Varning för nedförslutning", optionA: "a27-1", optionB: "a3-1", optionC: "a4-1", optionD: "a40-1", correctAnswer: "2", correctImageName: "a3-1")
        
        let question3 = Question(text: "Varning för stigning", optionA: "a4-1", optionB: "a3-1", optionC: "a40-1", optionD: "a27-1", correctAnswer: "1", correctImageName: "a4-1")
        
        let question4 = Question(text: "Varning för avsmalnande väg", optionA: "a29-1", optionB: "a2-1", optionC: "a10-1", optionD: "a5-2", correctAnswer: "4", correctImageName: "a5-2")
        
        let question5 = Question(text: "Varning för ojämn väg", optionA: "a9-1", optionB: "a10-1", optionC: "a8-1", optionD: "a27-1", correctAnswer: "3", correctImageName: "a8-1")
       
        let question6 = Question(text: "Varning för järnvägskorsning med bommar", optionA: "a35-1", optionB: "a36-1", optionC: "a39-1", optionD: "a37-1", correctAnswer: "1", correctImageName: "a35-1")
        
        let question7 = Question(text: "Varning för järnvägskorsning utan bommar", optionA: "a39-1", optionB: "a37-1", optionC: "a35-1", optionD: "a36-1", correctAnswer: "4", correctImageName: "a36-1")
        
        let question8 = Question(text: "Varning för farthinder", optionA: "a40-1", optionB: "a8-1", optionC: "a28-1", optionD: "a9-1", correctAnswer: "4", correctImageName: "a9-1")
        
        let question9 = Question(text: "Varning för vägkorsning", optionA: "a28-1", optionB: "a29-1", optionC: "a40-1", optionD: "a39-1", correctAnswer: "1", correctImageName: "a28-1")
       
        let question10 = Question(text: "Varning för vägkorsning där trafikanter på anslutande väg har väjningsplikt / stopplikt", optionA: "a28-1", optionB: "a40-1", optionC: "a29-1", optionD: "a30-1", correctAnswer: "3", correctImageName: "a29-1")
        
        let question11 = Question(text: "Varning för övergångsställe", optionA: "b3-1", optionB: "a14", optionC: "a13-1", optionD: "b8-1", correctAnswer: "3", correctImageName: "a13-1")
       
        let question20 = Question(text: "Varning för farlig kurva", optionA: "a1-1" , optionB: "a5-2" , optionC: "a4-1", optionD: "a2-1" , correctAnswer: "1", correctImageName: "a1-1" )
        
    //        Väjningsplikt - 8st (12-19)
        
        let question12 = Question(text: "Väjningsplikt", optionA: "b2-1", optionB: "b4-1", optionC: "b1-1", optionD: "a40-1", correctAnswer: "3", correctImageName: "b1-1")
        
        let question13 = Question(text: "Övergångsställe", optionA: "a13-1", optionB: "b8-1", optionC: "a14", optionD: "b3-1", correctAnswer: "4", correctImageName: "b3-1")
        
        let question14 = Question(text: "Huvudled", optionA: "b4-1", optionB: "b5-1", optionC: "b1-1", optionD: "a40-1", correctAnswer: "1", correctImageName: "b4-1")
        
        let question15 = Question(text: "Huvudled upphör", optionA: "b1-1", optionB: "b2-1", optionC: "b4-1", optionD: "b5-1", correctAnswer: "4", correctImageName: "b5-1")
        
        let question16 = Question(text: "Stopplikt", optionA: "b1-1", optionB: "b2-1", optionC: "c2-1", optionD: "c1-1", correctAnswer: "2", correctImageName: "b2-1")
        
        let question17 = Question(text: "Väjningsplikt mot mötande trafik", optionA: "b7-1", optionB: "a25-1", optionC: "b6-1", optionD: "c27-1", correctAnswer: "3", correctImageName: "b6-1")
        
        let question18 = Question(text: "Mötande trafik har väjningsplikt", optionA: "b7-1", optionB: "c27-1", optionC: "b6-1", optionD: "a25-1", correctAnswer: "1", correctImageName: "b7-1")
       
        let question19 = Question(text: "Cykelöverfart", optionA: "a16-1", optionB: "c10-1", optionC: "b8-1", optionD: "d4-1", correctAnswer: "3", correctImageName: "b8-1")

    //        Förbudsfrågor - 38st (21-58)
        
        let question21 = Question(text: "Förbud mot infart med fordon", optionA: "c2-1", optionB: "c4-1", optionC: "c1-1", optionD: "c3-1", correctAnswer: "3", correctImageName: "c1-1")
        
        let question22 = Question(text: "Förbud mot trafik med fordon", optionA: "c3-1", optionB: "c2-1", optionC: "c1-1", optionD: "b2-1", correctAnswer: "2", correctImageName: "c2-1")
        
        let question23 = Question(text: "Förbud mot trafik med annat motordrivet fordon än moped klass II", optionA: "c3-1", optionB: "c4-1", optionC: "c5-1", optionD: "c1-1", correctAnswer: "1", correctImageName: "c3-1")
       
        let question24 = Question(text: "Förbud mot trafik med motordrivet fordon med fler än två hjul", optionA: "c5-1", optionB: "c3-1", optionC: "c4-1", optionD: "c2-1", correctAnswer: "3", correctImageName: "c4-1")
       
        let question25 = Question(text: "Förbud mot trafik med motorcykel och moped klass I", optionA: "c2-1", optionB: "c1-1", optionC: "c3-1", optionD: "c5-1", correctAnswer: "4", correctImageName: "c5-1")
        
        let question26 = Question(text: "Förbud mot trafik med motordrivet fordon med tillkopplad släpvagn", optionA: "c7-1", optionB: "c9-1", optionC: "c6-1", optionD: "c22-2", correctAnswer: "3", correctImageName: "c6-1")
        
        let question27 = Question(text: "Förbud mot trafik med tung lastbil", optionA: "c7-1", optionB: "c6-1", optionC: "c9-1", optionD: "c21-1", correctAnswer: "1", correctImageName: "c7-1")
        
        let question28 = Question(text: "Förbud mot trafik med fordon lastat med farligt gods", optionA: "c22-2", optionB: "c9-1", optionC: "c39-1", optionD: "c21-1", correctAnswer: "2", correctImageName: "c9-1")
        
        let question29 = Question(text: "Förbud mot trafik med cykel och moped klass II", optionA: "c11-1", optionB: "b8-1", optionC: "c10-1", optionD: "a16-1", correctAnswer: "3", correctImageName: "c10-1")
        
        let question30 = Question(text: "Förbud mot trafik med moped klass II", optionA: "b8-1", optionB: "c10-1", optionC: "c2-1", optionD: "c11-1", correctAnswer: "4", correctImageName: "c11-1")
        
        let question31 = Question(text: "Förbud mot trafik med fordon förspänt med dragdjur", optionA: "c12-1", optionB: "c14-1", optionC: "a32-1", optionD: "a31-1", correctAnswer: "1", correctImageName: "c12-1")
        
        let question32 = Question(text: "Förbud mot trafik med terrängmotorfordon och terrängsläp", optionA: "c8-1", optionB: "c44-1", optionC: "a31-1", optionD: "c13-1", correctAnswer: "4", correctImageName: "c13-1")
        
        let question33 = Question(text: "Förbud mot ridning", optionA: "a32-1", optionB: "c12-1", optionC: "c14-1", optionD: "a18-1", correctAnswer: "3", correctImageName: "c14-1")
        
        let question34 = Question(text: "Förbud mot gångtrafik", optionA: "c15-1", optionB: "a13-1", optionC: "a14", optionD: "a15-1", correctAnswer: "1", correctImageName: "c15-1")
        
        let question35 = Question(text: "Begränsad fordonsbredd", optionA: "c17-1", optionB: "c18-1", optionC: "c19-1", optionD: "c16-1", correctAnswer: "4", correctImageName: "c16-1")
        
        let question36 = Question(text: "Begränsad fordonshöjd", optionA: "c18-1", optionB: "c17-1", optionC: "c19-1", optionD: "c16-1", correctAnswer: "2", correctImageName: "c17-1")
        
        let question37 = Question(text: "Begränsad fordonslängd", optionA: "c19-1", optionB: "c18-1", optionC: "c16-1", optionD: "c17-1", correctAnswer: "2", correctImageName: "c18-1")
        
        let question38 = Question(text: "Minsta avstånd", optionA: "c16-1", optionB: "c17-1", optionC: "c19-1", optionD: "c18-1", correctAnswer: "3", correctImageName: "c19-1")
        
        let question39 = Question(text: "Begränsad bruttovikt på fordon", optionA: "c21-1", optionB: "c22-2", optionC: "c24-1", optionD: "c20-1", correctAnswer: "4", correctImageName: "c20-1")
        
        let question40 = Question(text: "Begränsad bruttovikt på fordon och fordonståg", optionA: "c24-1", optionB: "c20-1", optionC: "c21-1", optionD: "c23-1", correctAnswer: "3", correctImageName: "c21-1")
        
        let question41 = Question(text: "Bärighetsklass", optionA: "c22-2", optionB: "c24-1", optionC: "c23-1", optionD: "c21-1", correctAnswer: "1", correctImageName: "c22-2")
        
        let question42 = Question(text: "Begränsat axeltryck", optionA: "c24-1", optionB: "c22-2", optionC: "c20-1", optionD: "c23-1", correctAnswer: "4", correctImageName: "c23-1")
        
        let question43 = Question(text: "Begränsat boggitryck", optionA: "c23-1", optionB: "c24-1", optionC: "c20-1", optionD: "c21-1", correctAnswer: "2", correctImageName: "c24-1")
        
        let question44 = Question(text: "Förbud mot sväng i korsning", optionA: "c26-1", optionB: "c25-1", optionC: "a1-1", optionD: "c1-1", correctAnswer: "2", correctImageName: "c25-1")
        
        let question45 = Question(text: "Förbud mot U-sväng", optionA: "c25-1", optionB: "a1-1", optionC: "c26-1", optionD: "c2-1", correctAnswer: "3", correctImageName: "c26-1")
        
        let question46 = Question(text: "Förbud mot omkörning", optionA: "c29-1", optionB: "c28-1", optionC: "c27-1", optionD: "a34-1", correctAnswer: "3", correctImageName: "c27-1")
        
        let question47 = Question(text: "Slut på förbud mot omkörning", optionA: "c30-1", optionB: "c29-1", optionC: "c27-1", optionD: "c28-1", correctAnswer: "4", correctImageName: "c28-1")
        
        let question48 = Question(text: "Förbud mot omkörning med tung lastbil", optionA: "c29-1", optionB: "c6-1", optionC: "c30-1", optionD: "c7-1", correctAnswer: "1", correctImageName: "c29-1")
        
        let question49 = Question(text: "Slut på förbud mot omkörning med tung lastbil", optionA: "c29-1", optionB: "c30-1", optionC: "c28-1", optionD: "c27-1", correctAnswer: "2", correctImageName: "c30-1")
        
        let question50 = Question(text: "Tillfällig hastighetsbegränsning upphör", optionA: "e12-1", optionB: "e14-1", optionC: "c32-3", optionD: "c31-8", correctAnswer: "3", correctImageName: "c32-3")
        
        let question51 = Question(text: "Stopp för angivet ändamål", optionA: "c1-1", optionB: "c2-1", optionC: "b2-1", optionD: "c34-1", correctAnswer: "4", correctImageName: "c34-1")
        
        let question52 = Question(text: "Förbud mot att parkera fordon", optionA: "c35-1", optionB: "c38-1", optionC: "c39-1", optionD: "c37-1", correctAnswer: "1", correctImageName: "c35-1")
        
        let question53 = Question(text: "Förbud mot att parkera fordon på dag med udda datum", optionA: "c38-1", optionB: "c39-1", optionC: "c37-1", optionD: "c36-1", correctAnswer: "4", correctImageName: "c36-1")
        
        let question54 = Question(text: "Förbud mot att parkera fordon på dag med jämnt datum", optionA: "c39-1", optionB: "c38-1", optionC: "c37-1", optionD: "c36-1", correctAnswer: "3", correctImageName: "c37-1")
        
        let question55 = Question(text: "Datumparkering", optionA: "c39-1", optionB: "c38-1", optionC: "c37-1", optionD: "c36-1", correctAnswer: "2", correctImageName: "c38-1")
        
        let question56 = Question(text: "Förbud mot att stanna och parkera fordon", optionA: "c39-1", optionB: "c42-1", optionC: "c35-1", optionD: "c38-1", correctAnswer: "1", correctImageName: "c39-1")
        
        let question57 = Question(text: "Ändamålsplats", optionA: "c42-1", optionB: "c40-1", optionC: "c34-1", optionD: "c33-1", correctAnswer: "2", correctImageName: "c40-1")
        
        let question58 = Question(text: "Slut på ändamålsplats", optionA: "c41-1", optionB: "c28-1", optionC: "c30-1", optionD: "c43-1", correctAnswer: "1", correctImageName: "c41-1")
        
//    PÅBUDSMÄRKEN
        
        let question59 =  Question(text: "Påbjuden körriktning", optionA: "d2-1", optionB: "x1-1", optionC: "d1-1", optionD: "e16-1", correctAnswer: "3", correctImageName: "d1-1")
        
        let question60 = Question(text: "Påbjuden körbana", optionA: "d1-1", optionB: "d2-1", optionC: "e16-1", optionD: "x1-1", correctAnswer: "2", correctImageName: "d2-1")
        
        let question61 = Question(text: "Påbjuden cykelbana", optionA: "b8-1", optionB: "a16-1", optionC: "c10-1", optionD: "d4-1", correctAnswer: "4", correctImageName: "d4-1")
        
        let question62 = Question(text: "Påbjuden gångbana", optionA: "d5-1", optionB: "b3-1", optionC: "a14", optionD: "a13-1", correctAnswer: "1", correctImageName: "d5-1")
       
        let question63 = Question(text: "Påbjuden gång- och cykelbana", optionA: "e9-1", optionB: "d6-1", optionC: "c10-1", optionD: "c15-1", correctAnswer: "2", correctImageName: "d6-1")
        
        let question64 = Question(text: "Påbjuden ridväg", optionA: "a18-1", optionB: "c14-1", optionC: "a32-1", optionD: "d8-1", correctAnswer:
            "4", correctImageName: "d8-1")
        
        let question65 = Question(text: "Påbjuden led för terrängmotorfordon och terrängsläp", optionA: "d9-1", optionB: "a33-1", optionC: "a32-1", optionD: "a31-1", correctAnswer: "1", correctImageName: "d9-1")
        
        let question66 = Question(text: "Påbjudet körfält eller körbana för fordon i linjetrafik m.fl.", optionA: "e22-1", optionB: "e23-1", optionC: "d10-1", optionD: "b7-1", correctAnswer: "3", correctImageName: "d10-1")
        
        let question67 = Question(text: "Slut på påbjuden bana, körfält, väg eller led", optionA: "c28-1", optionB: "c43-1", optionC: "d11-1", optionD: "e6-1", correctAnswer: "3", correctImageName: "d11-1")
        
//        ANVISNINGSMÄRKEN
        
        let question68 = Question(text: "Motorväg", optionA: "e3-1", optionB: "f14-1", optionC: "e1-1", optionD: "b4-1", correctAnswer: "3", correctImageName: "e1-1")
        
        let question69 = Question(text: "Motorväg upphör", optionA: "e4-1", optionB: "e6-1", optionC: "f27-1", optionD: "e2-1", correctAnswer: "4", correctImageName: "e2-1")
        
        let question70 = Question(text: "Motortrafikled", optionA: "e3-1", optionB: "e5-1", optionC: "e1-1", optionD: "e18-1", correctAnswer: "1", correctImageName: "e3-1")
        
        let question71 = Question(text: "Tättbebyggt område", optionA: "e9-1", optionB: "e7-1", optionC: "f30-1", optionD: "e5-1", correctAnswer: "4", correctImageName: "e5-1")
        
        let question72 = Question(text: "Tättbebyggt område upphör", optionA: "e6-1", optionB: "e8-1", optionC: "e12-1", optionD: "e10-1", correctAnswer: "1", correctImageName: "e6-1")
        
        let question73 = Question(text: "Gågata", optionA: "e9-1", optionB: "a15-1", optionC: "a14", optionD: "e7-1", correctAnswer: "4", correctImageName: "e7-1")
        
        let question74 = Question(text: "Gågata upphör", optionA: "e10-1", optionB: "c15-1", optionC: "e8-1", optionD: "d11-3", correctAnswer: "3", correctImageName: "e8-1")
        
        let question75 = Question(text: "Gångfartsområde", optionA: "e9-1", optionB: "e7-1", optionC: "e5-1", optionD: "d5-1", correctAnswer: "1", correctImageName: "e9-1")
        
        let question76 = Question(text: "Gångfartsområde upphör", optionA: "e8-1", optionB: "e6-1", optionC: "e12-1", optionD: "e10-1", correctAnswer: "4", correctImageName: "e10-1")
        
        let question77 = Question(text: "Rekommenderad lägre hastighet", optionA: "e13-1", optionB: "e11-1", optionC: "e9-1", optionD: "c31-3", correctAnswer: "2", correctImageName: "e11-1")
        
        let question78 = Question(text: "Rekommenderad lägre hastighet upphör", optionA: "e10-1", optionB: "e14-1", optionC: "e12-1", optionD: "e8-1", correctAnswer: "3", correctImageName: "e12-1")
        
        let question79 = Question(text: "Rekommenderad högsta hastighet", optionA: "c31-8", optionB: "e11-1", optionC: "e13-1", optionD: "e9-1", correctAnswer: "3", correctImageName: "e13-1")
        
        let question80 = Question(text: "Rekommenderad högsta hastighet upphör", optionA: "e12-1", optionB: "e14-1", optionC: "e10-1", optionD: "c31-8", correctAnswer: "2", correctImageName: "e14-1")
        
        let question81 = Question(text: "Sammanvävning", optionA: "e15-1", optionB: "f17-1", optionC: "f19-1", optionD: "f25-1", correctAnswer: "1", correctImageName: "e15-1")
        
        let question82 = Question(text: "Enkelriktad trafik", optionA: "d1-1", optionB: "e16-1", optionC: "d2-1", optionD: "b7-1", correctAnswer: "2", correctImageName: "e16-1")
        
        let question83 = Question(text: "Återvändsväg", optionA: "f26-1", optionB: "c42-1", optionC: "e9-1", optionD: "e17-1", correctAnswer: "4", correctImageName: "e17-1")
        
        let question84 = Question(text: "Mötesplats", optionA: "e18-1", optionB: "b7-1", optionC: "b6-1", optionD: "f23-1", correctAnswer: "1", correctImageName: "e18-1")
       
        let question85 = Question(text: "Områdesmärke", optionA: "f30-1", optionB: "f10-1", optionC: "e20-1", optionD: "f11-1", correctAnswer: "3", correctImageName: "e20-1")
       
        let question86 = Question(text: "Slut på område", optionA: "e21-1", optionB: "e6-1", optionC: "e10-1", optionD: "e14-1", correctAnswer: "1", correctImageName: "e21-1")
        
        
        
//        FrågeKategorier
        
        let varningsFrågor = QuestionArray(category: "Varningsmärken", catImage: #imageLiteral(resourceName: "a1-1"), questions: [question1, question2, question3, question4, question5, question6, question7, question8, question9, question10, question11, question20])
        let väjningsFrågor = QuestionArray(category: "Väjningsplikt", catImage: #imageLiteral(resourceName: "b1-1"), questions: [question12, question13, question14, question15, question16, question17, question18, question19])
        let förbudsFrågor = QuestionArray(category: "Förbudsmärken", catImage: #imageLiteral(resourceName: "c1-1"), questions: [question21, question22, question23, question24, question25, question26, question27, question28, question29, question30, question31, question32, question33, question34, question35, question36, question37, question38, question39, question40, question41, question42, question43, question44, question45, question46, question47, question48, question49, question50, question51, question52, question53, question54, question55, question56, question57, question58])
        let påbudsFrågor = QuestionArray(category: "Påbudsmärken", catImage: #imageLiteral(resourceName: "d1-1"), questions: [question59, question60, question61, question62, question63, question64, question65, question66, question67])
        let anvisningsFrågor = QuestionArray(category: "Anvisningsmärken", catImage: #imageLiteral(resourceName: "e1-1"), questions: [question68, question69, question70, question71, question72, question73, question74, question75, question76, question77, question78, question79, question80, question81, question82, question83, question84, question85, question86])
       
            return [varningsFrågor, väjningsFrågor, förbudsFrågor, påbudsFrågor, anvisningsFrågor]
    }

    
    

}
