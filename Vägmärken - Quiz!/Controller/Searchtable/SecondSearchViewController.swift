//
//  2ndSearchViewController.swift
//  Vägmärken - Quiz!
//
//  Created by Arman Dadmand on 2017-11-03.
//  Copyright © 2017 Arman Dadmand. All rights reserved.
//

import UIKit
import ViewAnimator

class SecondSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredSigns = signs.filter({( sign : Signs) -> Bool in
            return sign.text.lowercased().contains(searchText.lowercased())
        })
        
        secondSearchTable.reloadData()
    }
    

    @IBOutlet weak var secondSearchTable: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var receivedData: Int?
    var selectedCategoryName: String?

    var signs = [Signs]()
    var filteredSigns = [Signs]()
    
    let animate = AnimationType.from(direction: .right, offset: 40)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Sök"
        navigationItem.searchController = searchController
        //        searchTable.tableHeaderView = searchController.searchBar
        //        searchController.searchBar.barTintColor = UIColor.white
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
    
        navigationItem.title = selectedCategoryName
        
        
        secondSearchTable.delegate = self
        secondSearchTable.dataSource = self
        
//         changes made
        secondSearchTable.register(UINib(nibName: "CatTableViewCell", bundle: nil), forCellReuseIdentifier: "newCatCell")



    }
    
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        secondSearchTable.animate(animations: [animate])
    
        if !isFiltering() {
        switch receivedData {
        case 00?:
            infoLabel.text = "Varningsmärken varnar för olika typer av faror och betyder att du ska vara extra uppmärksam och försiktig."
        case 01?:
            infoLabel.text = "Under gruppen väjningspliktsmärken hittar du de märken som upplyser om stopp- eller väjningsplikt."
        case 02?:
            infoLabel.text = """
            Förbudsmärken anger att någonting är förbjudet, till exempel förbud mot att parkera fordon.
            
            Förbudet gäller från platsen där märket sitter till nästa korsning om inte annat anges.
            """
        case 03?:
            infoLabel.text = "Ett påbudsmärke innehåller en uppmaning som du är skyldig att följa, till exempel att du endast får köra i en viss riktning."
        case 04?:
            infoLabel.text = """
            Anvisningsmärken talar om vad som gäller för en viss plats, väg eller vägsträcka.
            
            Där anvisningsmärken finns uppsatta gäller oftast särskilda trafikregler som du måste följa.
            """
        case 05?:
            infoLabel.text = "Lokaliseringsmärken visar vägen till en ort, plats, inrättning, anläggning eller liknande."
        case 06?:
            infoLabel.text = "Lokaliseringsmärken visar vägen till en ort, plats, inrättning, anläggning eller liknande."
        case 07?:
            infoLabel.text = "Lokaliseringsmärken visar vägen till en ort, plats, inrättning, anläggning eller liknande."
        case 08?:
            infoLabel.text = "Lokaliseringsmärken visar vägen till en ort, plats, inrättning, anläggning eller liknande."
        case 09?:
            infoLabel.text = "Lokaliseringsmärken visar vägen till en ort, plats, inrättning, anläggning eller liknande."
        case 10?:
            infoLabel.text = "Upplysningsmärken ger dig information om framkomlighet och säkerhet."
        case 11?:
            infoLabel.text = "Symboler används på lokaliseringsmärken eller tilläggstavlor för att visa att informationen gäller för ett visst fordonsslag, en viss trafikantgrupp eller en viss verksamhet."
        case 12?:
            infoLabel.text = "Tilläggstavlor ger kompletterande anvisningar till vägmärken. Tilläggstavlorna kan till exempel ange ett avstånd, en vägsträckas längd eller en tidsangivelse."
        case 13?:
            infoLabel.text = "En trafiksignal är en ljus- eller ljudsignal som reglerar trafik. Signalens olika lägen talar om för trafikanter hur de ska bete sig i trafiken."
        case 14?:
            infoLabel.text = "Vägmarkeringar används för att reglera, varna eller vägleda trafikanter. De förekommer antingen separat eller tillsammans med vägmärken eller andra anordningar."
        case 15?:
            infoLabel.text = "Anordningarna på den här sidan är till för att ge dig anvisningar som du inte får av andra vägmärken eller trafiksignaler."
        case 16?:
            infoLabel.text = "Polis, bilinspektör, vägtransportledare eller någon annan person som har utsetts av en myndighet får ge tecken för att övervaka trafiken, ge anvisningar eller utföra punktskattekontroll. Du är skyldig att följa deras tecken."
        default:
            break
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredSigns.count
        }
        return signs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        changes made
        
        let newCell = tableView.dequeueReusableCell(withIdentifier: "newCatCell", for: indexPath) as! CatTableViewCell
        
            let sign: Signs
            if isFiltering() {
                sign = filteredSigns[indexPath.row]
                newCell.imageView?.image = sign.correctAnswer
                newCell.textLabel?.text = sign.text
            } else {
            
        let sign = signs[indexPath.row]

        newCell.imageView?.image = sign.correctAnswer
        newCell.textLabel?.text = sign.text
        }
        
        return newCell
                
    }
    
    
    
    // This function is called before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
     if segue.identifier == "signDetail" {
        
        let indexPath = secondSearchTable.indexPathForSelectedRow
        guard let selectedRow = indexPath?.row else { return }
        
            let secondVC = segue.destination as! SignDetailViewController
            
            secondVC.receivedData = 0
            
            secondVC.receivedData = selectedRow
            
            secondVC.receivedData = receivedData!
        
            let selectedSign: Signs
                if isFiltering() {
            selectedSign = filteredSigns[selectedRow]
                    secondVC.passedSign.correctAnswer = selectedSign.correctAnswer
                    secondVC.passedSign.signExpl = selectedSign.signExpl
                    secondVC.passedSign.text = selectedSign.text
                    
                    secondVC.passedSignsArray = filteredSigns
                    
                } else {
           
            let selectedSign = signs[selectedRow]
                    secondVC.passedSign.correctAnswer = selectedSign.correctAnswer
                    secondVC.passedSign.signExpl = selectedSign.signExpl
                    secondVC.passedSign.text = selectedSign.text
                    
                    secondVC.passedSignsArray = signs
        }
        
     
            
            
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
            }
        }
        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Segue to the second view controller
        self.performSegue(withIdentifier: "signDetail", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}

extension SecondSearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
