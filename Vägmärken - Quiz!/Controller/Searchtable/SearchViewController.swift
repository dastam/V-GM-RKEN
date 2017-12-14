//
//  SearchViewController.swift
//  
//
//  Created by Arman Dadmand on 2017-11-03.
//

import UIKit
import ViewAnimator
import BulletinBoard

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Private instance methods

    
    @IBOutlet weak var searchTable: UITableView!
    
//    var categoryArray = [String]()
//    var catImageArray = [UIImage]()
//    let allCategories = CategoryBank()
    var categories = [CatArray]()
    var signs = [CatArray]()
    var filteredCategories = [Signs]()
    var concatenatedSearchArray = [Signs]()
    let animate = AnimationType.from(direction: .right, offset: 60)
    
    let searchController = UISearchController(searchResultsController: nil)

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
        
        self.navigationController?.navigationBar.isTranslucent = true
        
        categories = loadData()
        
        

//        Returning a concatenated array of signs in all categories - when user search signs, they will be able to search all signs in all categories.
        concatenatedSearchArray = categories.flatMap { $0.signs }
        

//---        Setting up delegates for UITableViewController
        searchTable.delegate = self
        searchTable.dataSource = self
        
        searchTable.register(UINib(nibName: "CatTableViewCell", bundle: nil), forCellReuseIdentifier: "newCatCell")
        // Do any additional setup after loading the view.
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
// Setting up animations for the tableView
        searchTable.animateViews(animations: [animate], duration: 0.3, animationInterval: 0.06)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            if isFiltering() {
                return filteredCategories.count
            }
        
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        changes made
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCatCell", for: indexPath) as! CatTableViewCell
        
        
            let sign: Signs
            if isFiltering() {
                sign = filteredCategories[indexPath.row]
                cell.imageView?.image = sign.correctAnswer
                cell.textLabel?.text = sign.text
            
            } else {
                  let category = categories[indexPath.row]
                
                    cell.textLabel?.text = category.signText
                    cell.imageView?.image = category.image
        }
        
        return cell
        }
    

    
    // This function is called before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
     
        if segue.identifier == "firstSignDetail" {
            
            let indexPath = searchTable.indexPathForSelectedRow
            guard let selectedRow = indexPath?.row else { return }
            
            let secondVC = segue.destination as! DetailView
            
            secondVC.receivedData = 0
            
            secondVC.receivedData = selectedRow
            
            
            
            let selectedSign: Signs
            
                selectedSign = filteredCategories[selectedRow]
                secondVC.passedSign.correctAnswer = selectedSign.correctAnswer
                secondVC.passedSign.signExpl = selectedSign.signExpl
                secondVC.passedSign.text = selectedSign.text
            
                secondVC.indexpath = indexPath!
                secondVC.passedSignsArray = filteredCategories
            
        } else if segue.identifier == "searchSegue" {
            let indexPath = searchTable.indexPathForSelectedRow
            guard let selectedRow = indexPath?.row else { return }
            
            let selectedCategory = categories[selectedRow]
            
            let secondSVC = segue.destination as! SecondSearchViewController
            
            secondSVC.selectedCategoryName = selectedCategory.signText
            
            secondSVC.receivedData = 0
            
            secondSVC.receivedData = selectedRow
            
            secondSVC.signs = selectedCategory.signs
            
           
            
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
               
            }
            
        }

    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFiltering() == true {
            self.performSegue(withIdentifier: "firstSignDetail", sender: self)
        } else if isFiltering() == false {
        
        // Segue to the second view controller
        self.performSegue(withIdentifier: "searchSegue", sender: self)
        
        }
        
         tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    // MARK: SIGNARRAY
    
    func loadData() -> [CatArray] {
        
        //        MARK: - VARNINGSMÄRKEN 12ST
        
        let sign1 = Signs(text: "Varning för farlig kurva", correctAnswer: #imageLiteral(resourceName: "a1-1"), signExpl: "Märket anger en farlig kurva samt kurvans riktning.")
        
        let sign2 = Signs(text: "Varning för flera farliga kurvor", correctAnswer: #imageLiteral(resourceName: "a2-1"), signExpl: "Märket anger flera farliga kurvor samt den första farliga kurvans riktning.")
        
        let sign3 = Signs(text: "Varning för nedförslutning", correctAnswer: #imageLiteral(resourceName: "a3-1"), signExpl: "Märket anger brant nedförslutning. Siffran anger lutningen i procent och är anpassad till förhållandena på platsen." )
        
        let sign4 = Signs(text: "Varning för stigning", correctAnswer: #imageLiteral(resourceName: "a4-1"), signExpl: "Märket anger kraftig stigning. Siffran anger stigningen i procent och är anpassad till förhållandena på platsen." )
        
        let sign5 = Signs(text: "Varning för avsmalnande väg", correctAnswer: #imageLiteral(resourceName: "a5-1"), signExpl: "Märket anger att vägen eller banan smalnar av. Symbolen är anpassad efter förhållandena på platsen.")
        
        let sign6 = Signs(text: "Varning för ojämn väg", correctAnswer: #imageLiteral(resourceName: "a8-1"), signExpl: "Märket anger sådana ojämnheter eller skador i vägbanan som medför att det är lämpligt att färdas med lägre hastighet än som annars skulle varit fallet." )
        
        let sign7 = Signs(text: "Varning för järnvägskorsning med bommar", correctAnswer: #imageLiteral(resourceName: "a35-1"), signExpl: "Märket anger en korsning med järnväg eller spårväg där det finns bommar." )
        
        let sign8 = Signs(text: "Varning för järnvägskorsning utan bommar", correctAnswer: #imageLiteral(resourceName: "a36-1"), signExpl: "Märket anger en korsning med järnväg som saknar bommar." )
        
        let sign9 = Signs(text: "Varning för farthinder", correctAnswer: #imageLiteral(resourceName: "a9-1"), signExpl: "Märkena anger upphöjning eller grop som anlagts som fartdämpande åtgärd.")
       
        let sign10 = Signs(text: "Varning för vägkorsning", correctAnswer: #imageLiteral(resourceName: "a28-1"), signExpl: "Märket anger en vägkorsning där bestämmelserna i 3 kap. 18 § trafikförordningen (1998:1276) är tillämpliga." )
        
        let sign11 = Signs(text: "Varning för vägkorsning där trafikanter på anslutande väg har väjningsplikt / stopplikt", correctAnswer: #imageLiteral(resourceName: "a29-1"), signExpl: "Märket anger en vägkorsning där förare av fordon på anslutande vägar har väjningsplikt eller stopplikt. Symbolen är anpassad efter förhållandena på platsen.")
        
        let sign12 = Signs(text: "Varning för övergångsställe", correctAnswer: #imageLiteral(resourceName: "a13-1"), signExpl: "Vägmärket informerar om att ett övergångsställe finns lite längre fram på vägen. Observera att detta vägmärke inte alltid finns uppsatt innan övergångsställen, utan bara ibland, och då oftast på lite mer trafikerade vägar." )
        
        let sign21 = Signs(text: "Varning för bro", correctAnswer: #imageLiteral(resourceName: "a6-1"), signExpl: """
        Märket anger att du närmar dig en öppningsbar bro. Broöppningar kan ta tid och det kan därför vara lämpligt att stänga av motorn under tiden.

        Tänk på att risken för halka är större på broar och viadukter, även på de som inte är nära öppet vatten eftersom de kyls både under- och ovanifrån.
        """)
        
        let sign22 = Signs(text: "Varning för kaj", correctAnswer: #imageLiteral(resourceName: "a7-1"), signExpl: """
        Märket varnar om att vägen du kör på slutar mot vatten.
        """)
        
        let sign23 = Signs(text: "Varning för slirig väg", correctAnswer: #imageLiteral(resourceName: "a10-1"), signExpl: """
        Märket anger att vägen kan vara slirig.
        
        Vägmärket kan förekomma på olika platser men är vanligast innan vägarbetsområden där man lägger ny asfalt.
        
        Kör alltid försiktigt när du har passerat detta märke och räkna med kraftigt försämrat väggrepp.
        
        Endast om det finns särskilda skäl används märket för att varna för halka på grund av snö eller is.
        """)
        
        let sign24 = Signs(text: "Varning för stenskott", correctAnswer: #imageLiteral(resourceName: "a11-1"), signExpl: """
        Märket anger risk för stenskott.
        Märket används inte på grusvägar eller liknande vägar där stenskott är vanligt förekommande.
        """)
        
        let sign25 = Signs(text: "Varning för stenras", correctAnswer: #imageLiteral(resourceName: "a12-2"), signExpl: """
        Märket anger risk för stenras och för att stenar kan förekomma på vägen på grund av stenras.
        Symbolen är anpassad efter förhållandena på platsen.
        """)
        
        let sign26 = Signs(text: "Varning för gående", correctAnswer: #imageLiteral(resourceName: "a14"), signExpl: "Märket anger en vägsträcka där gående ofta korsar eller uppehåller sig på eller vid vägen.")
        
        let sign27 = Signs(text: "Varning för barn", correctAnswer: #imageLiteral(resourceName: "a15-1"), signExpl: "Märket anger en vägsträcka där barn ofta korsar eller uppehåller sig på eller vid vägen.")
        
        let sign28 = Signs(text: "Varning för cyklande och mopedförare", correctAnswer: #imageLiteral(resourceName: "a16-1"), signExpl: "Märket anger en vägsträcka där cyklande eller mopedförare ofta korsar eller kör in på vägen.")
        
        let sign29 = Signs(text: "Varning för skidåkare", correctAnswer: #imageLiteral(resourceName: "a17-1"), signExpl: "Märket anger en plats där skidåkare ofta korsar eller uppehåller sig på vägen.")
        
        let sign30 = Signs(text: "Varning för ridande", correctAnswer: #imageLiteral(resourceName: "a18-1"), signExpl: "Märket anger en vägsträcka där ridande ofta korsar eller uppehåller sig på vägen.")
        
        let sign31 = Signs(text: "Varning för djur - Älg", correctAnswer: #imageLiteral(resourceName: "a19-1"), signExpl: """
        Märket anger en plats eller vägsträcka där det finns särskild risk för djur på eller vid vägen. Andra symboler kan förekomma på märket.

        Transportstyrelsen får meddela föreskrifter om vilka andra symboler som får förekomma.
        """)
        
        let sign32 = Signs(text: "Varning för vägarbete", correctAnswer: #imageLiteral(resourceName: "a20-1"), signExpl: """
        Märket anger en vägsträcka där vägarbete eller liknande arbete pågår.
        
        Tänk på att visa stor hänsyn för de som arbetar vid vägen och att du passerar med lämplig hastighet och god säkerhetsmarginal i sidled.

        Räkna inte med att du syns/hörs när du passerar. Tänk på att vägen kan vara hal, att någon plötsligt kan kliva ut på vägen eller att ett vägarbetsfordon plötsligt kan börja backa.
        """)
        
        let sign33 = Signs(text: "Slut på sträcka med vägarbete", correctAnswer: #imageLiteral(resourceName: "a21-1"), signExpl: "Märket anger slut på en vägsträcka med vägarbete som märkts ut med märke A20, \"varning för vägarbete\". Märket är inte uppsatt om det ändå tydligt framgår var sträckan slutar.")
        
        let sign34 = Signs(text: "Varning för flerfärgssignal", correctAnswer: #imageLiteral(resourceName: "a22-1"), signExpl: """
        Märket anger en plats där trafiken regleras med flerfärgssignal med tre ljusöppningar. Inom tättbebyggt område är märket uppsatt endast om det finns särskilda skäl för det, det finns alltså inte uppsatt innan alla trafikljus.
        """)
        
        let sign35 = Signs(text: "Varning för lågt flygande flygplan", correctAnswer: #imageLiteral(resourceName: "a23-1"), signExpl: """
        Märket anger ett område där lågt flygande flygplan är vanligt förekommande. Symbolen är anpassad efter förhållandena på platsen.
        """)
        
        let sign36 = Signs(text: "Varning för sidvind", correctAnswer: #imageLiteral(resourceName: "a24-1"), signExpl: "Märket anger en vägsträcka där det ofta förekommer stark sidvind. Symbolen är anpassad efter förhållandena på platsen.")
        
        let sign37 = Signs(text: "Varning för mötande trafik", correctAnswer: #imageLiteral(resourceName: "a25-1"), signExpl: """
        Märket anger att en körbana med enkelriktad trafik övergår i en körbana med trafik i båda riktningarna.

        Vägmärket är vanligast där en motorväg eller 2+1-väg tar slut.
        """)
        
        let sign38 = Signs(text: "Varning för tunnel", correctAnswer: #imageLiteral(resourceName: "a26-1"), signExpl: """
        Vägmärket anger att vägen snart passerar genom en tunnel.
        """)
        
        let sign39 = Signs(text: "Varning för svag vägkant eller hög körbanekant", correctAnswer: #imageLiteral(resourceName: "a27-1"), signExpl: """
        Vägmärket anger en vägsträcka med svag vägkant eller hög körbanekant.

        En svag vägkant innebär att risken för avåkning ökar, speciellt för tunga fordon.
        """)
        
        let sign40 = Signs(text: "Varning för cirkulationsplats", correctAnswer: #imageLiteral(resourceName: "a30-1"), signExpl: "Vägmärket anger att vägen snart övergår i en cirkulationsplats.")
        
        let sign41 = Signs(text: "Varning för långsamtgående fordon", correctAnswer: #imageLiteral(resourceName: "a31-1"), signExpl: "Märket anger en plats där långsamtgående fordon ofta korsar eller kör in på vägen.")
        
        let sign42 = Signs(text: "Varning för fordon med förspänt dragdjur", correctAnswer: #imageLiteral(resourceName: "a32-1"), signExpl: """
        Märket anger en vägsträcka där fordon förspända med dragdjur ofta korsar eller uppehåller sig på vägen.

        Andra symboler kan förekomma på märket.
        Transportstyrelsen får meddela föreskrifter om vilka andra symboler som får förekomma.
        """)
        
        let sign43 = Signs(text: "Varning för terrängskotertrafik", correctAnswer: #imageLiteral(resourceName: "a33-1"), signExpl: "Märket anger en plats där terrängskotrar ofta korsar eller kör in på vägen.")
        
        let sign44 = Signs(text: "Varning för kö", correctAnswer: #imageLiteral(resourceName: "a34-1"), signExpl: "Märket anger en vägsträcka där det finns risk för köbildning.")
        
        let sign45 = Signs(text: "Varning för korsning med spårväg", correctAnswer: #imageLiteral(resourceName: "a37-1"), signExpl: "Märket anger en korsning med spårväg som saknar bommar.")
        
        let sign46 = Signs(text: "Avstånd till plankorsning", correctAnswer: #imageLiteral(resourceName: "a38-1"), signExpl: """
        Vägmärket anger att det är tre tredjedelar kvar av avståndet till en plankorsning (järnvägskorsning).

        Lite längre fram på vägen kommer du att passera ett liknande vägmärke, fast med två streck, och slutligen ett sista märke med ett streck.

        Vägmärket är, utom tättbebyggt område, uppsatt under något av märkena \"Varning för järnvägskorsning med bommar\", \"Varning för järnvägskorsning utan bommar\" eller \"Varning för korsning med spårväg\".
        """)
        
        let sign47 = Signs(text: "Kryssmärke", correctAnswer: #imageLiteral(resourceName: "a39-1"), signExpl: """
        Märket anger en korsning med järnväg eller spårväg med ett eller flera spår.
        
        Märket är uppsatt omedelbart före en plankorsning. Det behöver inte vara uppsatt vid enskild väg med lite trafik där det kan underlåtas utan fara för trafiksäkerheten.
        
        Märket kan även vara uppsatt vid en annan korsning med järnväg eller spårväg än en plankorsning.

        En stolpe som bär upp märket kan vara försedd med röd/gul stolpmarkeringsanordning.
        
        """)
        
        let sign48 = Signs(text: "Varning för annan fara", correctAnswer: #imageLiteral(resourceName: "a40-1"), signExpl: "Märket anger annan fara än sådan som kan anges med något annat varningsmärke.  Farans art anges på en tilläggstavla.")
        
        //        MARK: VÄJNINGSPLIKT *******************************
        
        let sign13 = Signs(text: "Väjningsplikt",correctAnswer: #imageLiteral(resourceName: "b1-1"), signExpl: """
        Vägmärket anger att du har väjningsplikt mot fordon på korsande väg eller led.

        I korsningar med detta märke ska du tydligt visa din avsikt att väja, genom att i god tid sänka hastigheten och om nödvändigt stanna helt. Du får köra vidare, endast om det kan ske utan fara/hinder för den övriga trafiken.

        Observera att du inte behöver stanna helt om det inte kommer någon trafik på den korsande vägen.
        """)
        
       
        let sign14 = Signs(text: "Stopplikt", correctAnswer: #imageLiteral(resourceName: "b2-1"), signExpl: """
        Märket anger att förare har stopplikt före infart på korsande väg, led eller spårområde.
        
        När du har stopplikt så måste du alltid stanna helt och lämna företräde. Detta gäller oavsett om det kommer någon trafik på den korsande vägen eller inte. Reglerna är utformade på detta sätt för att säkerställa att förare som har stopplikt verkligen tar sig tid att kontrollera trifken innan de kör ut.

        I första hand ska du stanna vid stopplinjen, saknas en sådan ska du istället stanna precis innan du kör ut på vägen, där du syns och har fri sikt, utan att köra ut på den korsande körbanan. Du får bara köra ut om det kan ske utan hinder/fara för andra.
        """)
        
        let sign15 = Signs(text: "Övergångsställe", correctAnswer: #imageLiteral(resourceName: "b3-1"), signExpl: """
        Vägmärket anger att ett övergångsställe finns lite längre fram på vägen.

        Om det är ett obevakat övergångsställe, alltså ett utan trafikljus, så har du väjningsplikt mot fotgängare som korsar eller som ska korsa vägen.
        
        Som förare har du alltid väjningsplikt mot fotgängare som korsar eller ska korsa ett obevakat övergångsställe. Genom att sakta ner i god tid och söka ögonkontakt med den gående kan du tydligt visa dina avsikter.
        """)
        
        let sign16 = Signs(text: "Huvudled", correctAnswer: #imageLiteral(resourceName: "b4-1"), signExpl: """
        Vägmärket upplyser om att vägen är en huvudled. Skylten finns uppsatt där huvudleden börjar och normalt sett efter varje korsning.
        
        Trafikanter på en huvudled ska ges företräde av alla trafikanter på anslutande och korsande vägar.
        Generellt gäller parkeringsförbud men däremot råder dock inget generellt stoppförbud. Du får alltså stanna för att låta en passagerare stiga av/på samt för att lasta av/på gods.
        """)
        
        let sign17 = Signs(text: "Huvudled Upphör", correctAnswer: #imageLiteral(resourceName: "b5-1"), signExpl: """
        Vägmärget anger att huvudleden upphör och att högerregeln gäller, så länge inget annat anges.
        """)
        
        let sign18 = Signs(text: "Väjningsplikt mot mötande trafik", correctAnswer: #imageLiteral(resourceName: "b6-1"), signExpl: "Vägmärket anger att du måste lämna företräde vid möte.")
        
        let sign19 = Signs(text: "Mötande trafik har väjningsplikt", correctAnswer: #imageLiteral(resourceName: "b7-1"), signExpl: "Vägmärket anger att du har företräde vid möte, och att mötande trafik måste väja för dig.")
        
        let sign20 = Signs(text: "Cykelöverfart", correctAnswer: #imageLiteral(resourceName: "b8-1"), signExpl: """
        Märket anger att det finns en cykelöverfart lite längre fram på vägen.

        En cykelöverfart är som ett övergångsställe fast för cykliser och mopedister (klass2). När du ska korsa en cykelöverfart har du väjningsplikt mot cyklister och mopedister (klass2) som befinner sig på, eller just ska färdas ut på, överfarten.

        Tänk på att i god tid sakta ner och inta beredskapsläge.
        """)
        
        //        MARK: FÖRBUDSMÄRKEN
        
        let sign49 = Signs(text: "Förbud mot infart med fordon", correctAnswer: #imageLiteral(resourceName: "c1-1"), signExpl: """
        Vägmärket anger förbud mot infart med fordon och gäller alla typer av fordon utan särskilt tillstånd. Skylten finns normalt på enkelriktade vägar där förbudet gäller i en riktning.
        
        Skylten kan även förekomma på väg som inte är enkelriktad, till exempel där infart på en viss plats på vägen är olämplig.
        """)
        
        let sign50 = Signs(text: "Förbud mot trafik med fordon", correctAnswer: #imageLiteral(resourceName: "c2-1"), signExpl: """
        Märket anger förbud mot trafik med fordon i båda riktningarna.
        """)
        
        let sign51 = Signs(text: "Förbud mot trafik med annat motordrivet fordon än moped klass II", correctAnswer: #imageLiteral(resourceName: "c3-1"), signExpl: """
        Denna skylt förbjuder trafik med motordrivet fordon, med undantag för moped klass II.

        Avser förbudet även moped klass II anges detta på en tilläggstavla.
        """)
        
        let sign52 = Signs(text: "Förbud mot trafik med motordrivet fordon med fler än två hjul", correctAnswer: #imageLiteral(resourceName: "c4-1"), signExpl: """
        Vägmärket förbjuder trafik med motordrivet fordon med fler än två hjul. Skylten finns normalt på vägar som är för smala för fyrhjuliga fordon.
        """)
        
        let sign53 = Signs(text: "Förbud mot trafik med motorcykel och moped klass I", correctAnswer: #imageLiteral(resourceName: "c5-1"), signExpl: """
        Denna skylt förbjuder trafik med motorcykel, övriga fordon får dock köra här. Skylten finns oftast i områden där man vill undvika buller eftersom motorcyklar bullrar mer än bilar.
        """)
        
        let sign54 = Signs(text: "Förbud mot trafik med motordrivet fordon med tillkopplad släpvagn", correctAnswer: #imageLiteral(resourceName: "c6-1"), signExpl: """

        Märket anger förbud mot trafik med motordrivet fordon med tillkopplad släpvagn av annat slag än påhängsvagn eller släpkärra.
        
        Avser förbudet även trafik med motordrivet fordon med tillkopplad påhängsvagn eller släpkärra anges det på en tilläggstavla.

        Avser förbudet endast fordonståg med släpvagn vars totalvikt överstiger visst tontal anges det på tilläggstavla T5, totalvikt.
        """)
        
        let sign55 = Signs(text: "Förbud mot trafik med tung lastbil", correctAnswer: #imageLiteral(resourceName: "c7-1"), signExpl: "Vägmärket förnjuder trafik med tung lastbil. Avser förbudet även trafik med lätt lastbil anges det på en tilläggstavla.")
        
        let sign56 = Signs(text: "Förbud mot trafik med traktor och motorredskap klass II", correctAnswer: #imageLiteral(resourceName: "c8-1"), signExpl: "Vägmärket anger förbud mot trafik med traktor och motorredskap klass II. Avser förbudet även trafik med motorredskap klass I anges det på en tilläggstavla.")
        
        let sign57 = Signs(text: "Förbud mot trafik med fordon lastat med farligt gods", correctAnswer: #imageLiteral(resourceName: "c9-1"), signExpl: """
        Märket anger förbud mot trafik med fordon med sådan last som omfattas av krav på märkning med orangefärgad skylt enligt föreskrifter som har meddelats med stöd av lagen (2006:263) om transport av farligt gods.

        Tillsammans med tilläggstavla T23, tunnelkategori, anger märket tunnelkategori.
        """)
        
        let sign58 = Signs(text: "Förbud mot trafik med cykel och moped klass II", correctAnswer: #imageLiteral(resourceName: "c10-1"), signExpl: """
        Vågmärket anger förbud mot trafik med cykel och moped klass II. Avser förbudet även trafik med moped klass I (EU-moped) anges det på en tilläggstavla.

        Det är inte förbjudet att leda en cykel på vägar med detta märke, eftersom den som leder en cykel räknas som gående.
        """)
        
        let sign59 = Signs(text: "Förbud mot trafik med moped klass II", correctAnswer: #imageLiteral(resourceName: "c11-1"), signExpl: "Avser förbudet även trafik med moped klass I anges det på en tilläggstavla.")
        
        let sign60 = Signs(text: "Förbud mot trafik med fordon förspänt med dragdjur", correctAnswer: #imageLiteral(resourceName: "c12-1"), signExpl: "Vägmärket förnjuder trafik med fordon som dras av djur, till ecempel hästar eller oxar.")
        
        let sign61 = Signs(text: "Förbud mot trafik med terrängmotorfordon och terrängsläp", correctAnswer: #imageLiteral(resourceName: "c13-1"), signExpl: """
        Skylten förbjuder trafik med terrängmotorfordon och terrängsläp, ofta innebär det till exemepel snöskoter.
        Skylten förekommer till största del i Norrland.

        Gäller förbudet inte terrängvagn anges det på en tilläggstavla.
        """)
        
        let sign62 = Signs(text: "Förbud mot ridning", correctAnswer: #imageLiteral(resourceName: "c14-1"), signExpl: """
        Skylten förbjuder ridning och finns oftast på gång-, cykel- och promenadvägar.

        Avser förbudet även ledande av riddjur anges det på en tilläggstavla.
        """)
        
        let sign63 = Signs(text: "Förbud mot gångtrafik", correctAnswer: #imageLiteral(resourceName: "c15-1"), signExpl: "Skylten förbjuder gångtrafik och finns oftast på större vägar där gångtrafik är olämplig.")
        
        let sign64 = Signs(text: "Begränsad fordonsbredd", correctAnswer: #imageLiteral(resourceName: "c16-1"), signExpl: "Märket anger förbud mot trafik med fordon över en viss bredd. Största tillåtna bredd anges på märket.")
        
        let sign65 = Signs(text: "Begränsad fordonshöjd", correctAnswer: #imageLiteral(resourceName: "c17-1"), signExpl: "Märket anger förbud mot trafik med fordon över en viss höjd om den fria höjden är lägre än 4,5 meter. Högsta tillåtna fordonshöjd anges på märket.")
        
        let sign66 = Signs(text: "Begränsad fordonslängd", correctAnswer: #imageLiteral(resourceName: "c18-1"), signExpl: "Märket anger förbud mot trafik med fordon eller fordonståg över en viss längd. Längsta tillåtna längd anges på märket.")
        
        let sign67 = Signs(text: "Minsta avstånd", correctAnswer: #imageLiteral(resourceName: "c19-1"), signExpl: "Märket anger förbud mot att hålla kortare avstånd till framförvarande motordrivna fordon i samma färdriktning än som anges på märket. Minsta tillåtna avstånd anges på märket.")
        
        let sign68 = Signs(text: "Begränsad bruttovikt på fordon", correctAnswer: #imageLiteral(resourceName: "c20-1"), signExpl: """
        Högsta tillåtna bruttovikt anges på märket. Med bruttovikt menas vad fordonet väger för tillfället.

        Skylten finns oftast på mindre vägar med begränsningar i bärighet, till exempel på svagare broar.
        """)
        
        let sign69 = Signs(text: "Begränsad bruttovikt på fordon och fordonståg", correctAnswer: #imageLiteral(resourceName: "c21-1"), signExpl: """
        Begränsad bruttovikt på fordon och fordonståg.
        Med bruttovikt menas vad fordonet väger för tillfället.
        """)
        
        let sign70 = Signs(text: "Bärighetsklass", correctAnswer: #imageLiteral(resourceName: "c22-2"), signExpl: "Skylten anger att vägen har nedsatt s.k bärighetsklass. Vägens bärighetsklass anges på märket. En väg av högsta standard har bärighetsklass 1 ,eller BK1, och skyltas inte.")
        
        let sign71 = Signs(text: "Begränsat axeltryck", correctAnswer: #imageLiteral(resourceName: "c23-1"), signExpl: "Högsta tillåtna axeltryck anges på märket. Axeltrycket är vikten som vilar på vägen för de hjul som tillhör en axel.")
        
        let sign72 = Signs(text: "Begränsat boggitryck", correctAnswer: #imageLiteral(resourceName: "c24-1"), signExpl: "Högsta tillåtna boggitryck anges på märket. Boggitrycket är summan av axeltrycket för två axlar vars centrumavstånd är mindre än 2 meter.")
        
        let sign73 = Signs(text: "Förbud mot sväng i korsning", correctAnswer: #imageLiteral(resourceName: "c25-1"), signExpl: """
        Förbudet gäller den korsning eller motsvarande som märket är placerat i eller före.
        Märket kan avse flera korsningar. Sträckans längd anges då på en tilläggstavla.

        Symbolen är anpassad efter förhållandena på platsen.
        """)
        
        let sign74 = Signs(text: "Förbud mot U-sväng", correctAnswer: #imageLiteral(resourceName: "c26-1"), signExpl: """
        Förbudet gäller den korsning eller motsvarande som märket är placerat i eller före.
        Märket kan avse flera korsningar. Sträckans längd anges då på en tilläggstavla.

        Symbolen är anpassad efter förhållandena på platsen.
        """)
        
        let sign75 = Signs(text: "Förbud mot omkörning", correctAnswer: #imageLiteral(resourceName: "c27-1"), signExpl: """
        Märket anger förbud mot att köra om andra motordrivna fordon än tvåhjuliga mopeder och tvåhjuliga motorcyklar utan sidvagn.
        Förbudet gäller på den väg märket är uppsatt och till den plats där märke C28, slut på förbud mot omkörning, är uppsatt.
        """)
        
        let sign76 = Signs(text: "Slut på förbud mot omkörning", correctAnswer: #imageLiteral(resourceName: "c28-1"), signExpl: """
        Denna skylt talar om att ett tidigare omkörningsförbud upphör.
        """)
        
        let sign77 = Signs(text: "Förbud mot omkörning med tung lastbil", correctAnswer: #imageLiteral(resourceName: "c29-1"), signExpl: """
        Märket anger förbud mot att med en tung lastbil köra om andra motordrivna fordon än tvåhjuliga mopeder och tvåhjuliga motorcyklar utan sidvagn.
        Förbudet gäller på den väg märket är uppsatt till den plats där märke C30, slut på förbud mot omkörning med tung lastbil, är uppsatt.
        """)
        
        let sign78 = Signs(text: "Slut på förbud mot omkörning med tung lastbil", correctAnswer: #imageLiteral(resourceName: "c30-1"), signExpl: "Märket talar om att ett tidigare omkörningsförbud med tung lastbil upphör att gälla.")
        
        let sign79 = Signs(text: "Hastighetsbegränsning - 30 km/h", correctAnswer: #imageLiteral(resourceName: "c31-3"), signExpl: """
        Vägmärket anger förbud mot att köra med högre hastighet än det som anges på vägmärket, i detta fall 30 km/h.

        Angivelsen gäller till den plats där en annan hastighetsbegränsning anges, eller där märke:
        
        - C32, \"Tillfällig hastighetsbegränsning upphör\",
        - E7, \"Gågata\", eller
        - E9, \"Gångfartsområde\", satts upp.

        Märket behöver inte vara upprepat efter en vägkorsning om samma högsta tillåtna hastighet gäller på den korsande vägen.
        """)
        
        let sign80 = Signs(text: "Tillfällig hastighetsbegränsning upphör", correctAnswer: #imageLiteral(resourceName: "c32-3"), signExpl: """
        Märket används endast på en väg eller vägsträcka där försöksverksamhet pågår enligt förordningen om försöksverksamhet med varierande högsta hastighet.
        Märket anger då att en tillfällig avvikelse från den varierande högsta hastigheten som märkts ut med märke C31, \"Hastighetsbegränsning\", upphör.
        """)
        
        let sign81 = Signs(text: "Stopp vid tull", correctAnswer: #imageLiteral(resourceName: "c33-1"), signExpl: """
        Märket anger skyldighet att stanna för tullklarering. Fordonet skall stannas vid en stopplinje eller, om sådan saknas, vid märket.
        Texten under det vågräta strecket anges på det språk som är lämpligt.
        """)
        
        let sign82 = Signs(text: "Stopp för angivet ändamål", correctAnswer: #imageLiteral(resourceName: "c34-1"), signExpl: """
        Märket anger skyldighet att stanna av den anledning som anges under det vågräta strecket. Om märket är uppsatt före en trafiksignal, anger det att fordon som skall passera signalen skall stanna vid rött ljus. Fordonet skall stannas vid en stopplinje eller, om sådan saknas, vid märket.
        """)
        
        let sign83 = Signs(text: "Förbud mot att parkera fordon", correctAnswer: #imageLiteral(resourceName: "c35-1"), signExpl: """
        Märket anger förbud mot att parkera fordon. Angivelsen börjar gälla där märket satts upp och gäller på den sidan av vägen där märket är uppsatt.

        Eventuella tilläggstavlor kan begränsa förbudet till att endast gälla vissa typer av fordon, vissa dagar eller vissa tider.

        Förbudet gäller fram till nästa korsning om inget annat anges.

        På platser där det gäller parkeringsförbud får du aldrig parkera, men du får stanna för att släppa av/på passagerare eller för att lasta av/på gods.
        Det är även tillåttet att stanna för att undvika fara eller om trafikförhållandena kräver det.
        """)
        
        let sign84 = Signs(text: "Förbud mot att parkera fordon på dag med udda datum", correctAnswer: #imageLiteral(resourceName: "c36-1"), signExpl: """
        De närmare föreskrifterna till märke C35, \"Förbud mot att parkera fordon\", gäller även till detta märke.
        
        Förbudet begränsas till dagar med udda datum och gäller således inte t.ex den 4:e Oktober.
        """)
        
        let sign85 = Signs(text: "Förbud mot att parkera fordon på dag med jämnt datum", correctAnswer: #imageLiteral(resourceName: "c37-1"), signExpl: """
        De närmare föreskrifterna till märke C35, \"Förbud mot att parkera fordon\", gäller även till detta märke.
        
        Förbudet begränsas till dagar med jämna datum och gäller således inte t.ex den 13:e November.
        """)
        
        let sign86 = Signs(text: "Datumparkering", correctAnswer: #imageLiteral(resourceName: "c38-1"), signExpl: """
        Märket anger förbud mot att parkera fordon på dagar med jämnt datum på den sida av vägen som har jämna adressnummer och på dagar med udda datum på den sida av vägen som har udda adressnummer.

        De närmare föreskrifterna till märke C35, \"Förbud mot att parkera fordon\", gäller även till detta märke.
        """)
        
        let sign87 = Signs(text: "Förbud mot att stanna och parkera fordon", correctAnswer: #imageLiteral(resourceName: "c39-1"), signExpl: """
        Märket anger förbud mot att stanna och parkera fordon. Angivelsen börjar gälla där märket satts upp och gäller på den sidan av vägen där märket är uppsatt.
        Förbudet gäller fram till nästa korsning om inget annat anges.

        På platser där det råder stoppförbud får du aldrig stanna, om det inte är för att undvika fara eller om trafikförhållandena kräver det.
        """)
        
        let sign88 = Signs(text: "Ändamålsplats", correctAnswer: #imageLiteral(resourceName: "c40-1"), signExpl: """
        Märket anger att det är förbjudet att stanna och parkera fordon för annat ändamål än det angivna.
        Om endast ett visst fordonsslag eller en viss trafikantgrupp får stanna och parkera anges det på en tilläggstavla.
        
        Andra ändamål kan anges på märket.

        Transportstyrelsen får meddela föreskrifter om vilka ändamål som får anges.
        """)
        
        let sign89 = Signs(text: "Slut på ändamålsplats", correctAnswer: #imageLiteral(resourceName: "c41-1"), signExpl: """
        Märket behöver inte vara uppsatt om det ändå tydligt framgår att ändamålsplatsen upphör.

        Andra ändamål kan anges på märket.

        Transportstyrelsen får meddela föreskrifter om vilka andra ändamål som får anges.
        """)
        
        let sign90 = Signs(text: "Vändplats", correctAnswer: #imageLiteral(resourceName: "c42-1"), signExpl: """
        Märket anger en plats som är avsedd för vändning av fordon och att det är förbjudet att parkera fordon.

        Om i stället märke C39, \"Förbud mot att stanna och parkera fordon\", är infogat i märket anger det att det är förbjudet att både stanna och parkera fordon.
        """)
        
        let sign91 = Signs(text: "Slut på vändplats", correctAnswer: #imageLiteral(resourceName: "c43-1"), signExpl: "Märket behöver inte vara uppsatt om det ändå tydligt framgår att vändplatsen upphör.")
        
        let sign92 = Signs(text: "Förbud mot trafik med annat motordrivet fordon med dubbdäck än moped klass II", correctAnswer: #imageLiteral(resourceName: "c44-1"), signExpl: """
        Vägmärket förbjuder trafik med dubbdäck.

        Vägmärket förekommer främst i tätbebyggda områden och infördes år 2010 för att sänka halterna av hälsofarliga partiklar i luften.
        (Dubbarna på dubbdäck sliter upp asfaltspartiklar som är hälsoskadliga)
        """)
        
        
        //        MARK: PÅBUDSMÄRKEN ------>
        
        let sign93 = Signs(text: "Påbjuden körriktning - Vänster", correctAnswer: #imageLiteral(resourceName: "d1-1"), signExpl: """
        Märket anger att fordon endast får föras i pilens riktning, i detta fall till vänster.
        
        Vägmärket används där det finns ytterligare färdriktningar som inte är tillåtna.
        """)
        
        let sign94 = Signs(text: "Påbjuden körriktning - Höger", correctAnswer: #imageLiteral(resourceName: "d1-2"), signExpl: """
        Märket anger att fordon endast får föras i pilens riktning, i detta fall till höger.
        
        Vägmärket används där det finns ytterligare färdriktningar som inte är tillåtna.
        """)
    
        let sign95 = Signs(text: "Påbjuden körriktning - Rakt fram", correctAnswer: #imageLiteral(resourceName: "d1-3"), signExpl: """
        Märket anger att fordon endast får föras i pilens riktning, i detta fall ska du köra rakt fram.
        
        Vägmärket används där det finns ytterligare färdriktningar som inte är tillåtna.
        """)
        
        let sign96 = Signs(text: "Påbjuden körriktning - Sväng vänster", correctAnswer: #imageLiteral(resourceName: "d1-4"), signExpl: """
        Märket anger att fordon endast får föras i pilens riktning, i detta fall ska du svänga vänster.
        
        Vägmärket används där det finns ytterligare färdriktningar som inte är tillåtna.
        """)
        
        let sign97 = Signs(text: "Påbjuden körriktning - Sväng höger", correctAnswer: #imageLiteral(resourceName: "d1-5"), signExpl: """
        Märket anger att fordon endast får föras i pilens riktning, i detta fall ska du svänga höger.
        
        Vägmärket används där det finns ytterligare färdriktningar som inte är tillåtna.
        """)
        
        let sign98 = Signs(text: "Påbjuden körriktning - Rakt fram eller sväng vänster", correctAnswer: #imageLiteral(resourceName: "d1-6"), signExpl: """
        Märket anger att fordon endast får föras i pilens riktning, i detta fall ska du antingen svänga till vänster eller köra rakt fram.
        
        Vägmärket används där det finns ytterligare färdriktningar som inte är tillåtna.
        """)
        
        let sign99 = Signs(text: "Påbjuden körriktning - Rakt fram eller sväng höger", correctAnswer: #imageLiteral(resourceName: "d1-7"), signExpl: """
        Märket anger att fordon endast får föras i pilens riktning, i detta fall ska du antingen svänga till höger eller köra rakt fram.
        
        Vägmärket används där det finns ytterligare färdriktningar som inte är tillåtna.
        """)
        
        let sign100 = Signs(text: "Påbjuden körriktning - Sväng vänster eller höger", correctAnswer: #imageLiteral(resourceName: "d1-8"), signExpl: """
        Märket anger att du måste svänga i någon av pilarnas riktning.
        
        Vägmärket används där det finns ytterligare färdriktningar som inte är tillåtna.
        """)
        
        let sign101 = Signs(text: "Påbjuden körbana - Höger", correctAnswer: #imageLiteral(resourceName: "d2-1"), signExpl: """
        Vägmärket anger att fordon endast får föras förbi märket där pilen visar.
        Symbolen är anpassad efter förhållandena på platsen.
        
        I detta fall ska du köra på en körbana till höger om märket.
        """)
        
        let sign102 = Signs(text: "Påbjuden körbana - Vänster", correctAnswer: #imageLiteral(resourceName: "d2-2"), signExpl: """
        Vägmärket anger att fordon endast får föras förbi märket där pilen visar.
        Symbolen är anpassad efter förhållandena på platsen.
        
        I detta fall ska du köra på en körbana till vänster om märket.
        """)
        
        let sign103 = Signs(text: "Påbjuden körbana - Höger eller vänster", correctAnswer: #imageLiteral(resourceName: "d2-3"), signExpl: """
        Vägmärket anger att fordon endast får föras förbi märket där pilen visar.
        Symbolen är anpassad efter förhållandena på platsen.
        
        I detta fall ska du köra på en körbana till höger eller vänster om märket.
        """)
        
        let sign104 = Signs(text: "Cirkulationsplats", correctAnswer: #imageLiteral(resourceName: "d3-1"), signExpl: """
        Vägmärket anger att vägen du kör på övergår i en cirkulationsplats.

        Märket är alltid uppsatt väldigt nära cirkulationsplatsen, till skillnad från märket "Varning för cirkulationsplats"
        """)
        
        let sign105 = Signs(text: "Påbjuden cykelbana", correctAnswer: #imageLiteral(resourceName: "d4-1"), signExpl: """
        Vägmärket anger att banan efter märket är en cykelbana.

        Om moped klass II inte får föras på banan anges det på en tilläggstavla.
        """)
        
        let sign106 = Signs(text: "Påbjuden gångbana", correctAnswer: #imageLiteral(resourceName: "d5-1"), signExpl: "Märket anger bana avsedd endast för gående.")
        
        let sign107 = Signs(text: "Påbjuden gång- och cykelbana", correctAnswer: #imageLiteral(resourceName: "d6-1"), signExpl: "Märket anger gemensam bana för gående och cyklande. Om moped klass II inte får föras på banan anges det på en tilläggstavla.")
        
        let sign108 = Signs(text: "Påbjudna gång- och cykelbanor", correctAnswer: #imageLiteral(resourceName: "d7-1"), signExpl: """
        Märket anger banor som är delade genom vägmarkering, skiljeremsa eller liknande i en del för gående och en del för cyklande.

        Symbolernas placering på märket anger vilken del av banan som är avsedd för gående respektive cyklande.

        Om moped klass II inte får föras på banan anges det på en tilläggstavla.
        """)
        
        let sign109 = Signs(text: "Påbjuden ridväg", correctAnswer: #imageLiteral(resourceName: "d8-1"), signExpl: """
        Märket anger att vägen efter märket är en ridväg, men även fotgängare får använda vägen.

        All motortrafik är förbjuden.
        """)
        
        let sign110 = Signs(text: "Påbjuden led för terrängmotorfordon och terrängsläp", correctAnswer: #imageLiteral(resourceName: "d9-1"), signExpl: """
        Vägmärket anger att leden efter märket är en led för terrängmotorfordon (t.ex snöskotrar) och terrängsläp.

        Även gångtrafik är tillåten.
        Fotgängare bör vara uppmärksamma på att snabba fordon kan komma körandes.
        """)
        
        let sign111 = Signs(text: "Påbjudet körfält eller körbana för fordon i linjetrafik", correctAnswer: #imageLiteral(resourceName: "d10-1"), signExpl: """
        Vägmärket talar om att körfältet eller körbanan efter märket är ett kollektivkörfält, det vill säga ett körfält eller väg för fordon i linjetrafik.
        Körfältet eller vägen markeras med texten \"BUSS\" i vitt.

        Om körfältet är beläget till höger får det även trafikeras av cykel och moped klass 2.
        
        Om andra fordon tillåts/förbjuds trafikera körfältet eller körbanan anges det på en tilläggstavla.
        """)
        
        let sign112 = Signs(text: "Slut på påbjudet körfält eller körbana för fordon i linjetrafik", correctAnswer: #imageLiteral(resourceName: "d11-1"), signExpl: """
        Märket anger att påbjudet körfält eller körbana för fordon i linjetrafik upphör.
        Skylten anger inget förbud, utan upplyser om att vägen/körbanan inte längre är förbehållet ett visst trafikantslag.

        Märket behöver inte sättas upp om det ändå tydligt framgår att påbudet upphör.

        Andra symboler för trafikantgrupper eller fordonsslag kan vara infogade i märket. Den symbol som är infogad i märket är samma som på det märke som använts för att märka ut banan, körfältet, vägen eller leden.
        """)
        
        let sign113 = Signs(text: "Slut på påbjuden cykelbana", correctAnswer: #imageLiteral(resourceName: "d11-2"), signExpl: """
        Märket anger att påbjuden cykelbana upphör.
        Skylten anger inget förbud, utan upplyser om att vägen/körbanan inte längre är förbehållet ett visst trafikantslag.

        Märket behöver inte sättas upp om det ändå tydligt framgår att påbudet upphör.

        Andra symboler för trafikantgrupper eller fordonsslag kan vara infogade i märket. Den symbol som är infogad i märket är samma som på det märke som använts för att märka ut banan, körfältet, vägen eller leden.
        """)
        
        let sign114 = Signs(text: "Slut på påbjuden gångbana", correctAnswer: #imageLiteral(resourceName: "d11-3"), signExpl: """
        Märket anger att påbjuden gångbana upphör.
        Skylten anger inget förbud, utan upplyser om att vägen/körbanan inte längre är förbehållet ett visst trafikantslag.

        Märket behöver inte sättas upp om det ändå tydligt framgår att påbudet upphör.

        Andra symboler för trafikantgrupper eller fordonsslag kan vara infogade i märket. Den symbol som är infogad i märket är samma som på det märke som använts för att märka ut banan, körfältet, vägen eller leden.
        """)
        
        let sign115 = Signs(text: "Slut på påbjuden gång- och cykelbana", correctAnswer: #imageLiteral(resourceName: "d11-4"), signExpl: """
        Märket anger att påbjuden gång- och cykelbana upphör.
        Skylten anger inget förbud, utan upplyser om att vägen/körbanan inte längre är förbehållet ett visst trafikantslag.

        Märket behöver inte sättas upp om det ändå tydligt framgår att påbudet upphör.

        Andra symboler för trafikantgrupper eller fordonsslag kan vara infogade i märket. Den symbol som är infogad i märket är samma som på det märke som använts för att märka ut banan, körfältet, vägen eller leden.
        """)
        
        let sign116 = Signs(text: "Påbjudna gång- och cykelbanor - Uppdelad", correctAnswer: #imageLiteral(resourceName: "d11-5"), signExpl: """
        Märket anger att påbjuden gång- och cykelbanor upphör.
        Skylten anger inget förbud, utan upplyser om att vägen/körbanan inte längre är förbehållet ett visst trafikantslag.

        Märket behöver inte sättas upp om det ändå tydligt framgår att påbudet upphör.

        Andra symboler för trafikantgrupper eller fordonsslag kan vara infogade i märket. Den symbol som är infogad i märket är samma som på det märke som använts för att märka ut banan, körfältet, vägen eller leden.
        """)
        
        let sign117 = Signs(text: "Slut på påbjuden ridväg", correctAnswer: #imageLiteral(resourceName: "d11-7"), signExpl: """
        Märket anger att påbjuden ridväg upphör.
        Skylten anger inget förbud, utan upplyser om att vägen/körbanan inte längre är förbehållet ett visst trafikantslag.

        Märket behöver inte sättas upp om det ändå tydligt framgår att påbudet upphör.

        Andra symboler för trafikantgrupper eller fordonsslag kan vara infogade i märket. Den symbol som är infogad i märket är samma som på det märke som använts för att märka ut banan, körfältet, vägen eller leden.
        """)
        
        let sign118 = Signs(text: "Slut på påbjuden led för terrängmotorfordon och terrängsläp", correctAnswer: #imageLiteral(resourceName: "d11-8"), signExpl: """
        Märket anger att påbjuden led för terrängmotorfordon och terrängsläp upphör.
        Skylten anger inget förbud, utan upplyser om att vägen/körbanan inte längre är förbehållet ett visst trafikantslag.

        Märket behöver inte sättas upp om det ändå tydligt framgår att påbudet upphör.

        Andra symboler för trafikantgrupper eller fordonsslag kan vara infogade i märket. Den symbol som är infogad i märket är samma som på det märke som använts för att märka ut banan, körfältet, vägen eller leden.
        """)
        
        //        MARK: ANVISNINGSMÄRKEN
        
        let sign119 = Signs(text: "Motorväg", correctAnswer: #imageLiteral(resourceName: "e1-1"), signExpl: """
        Vägmärket upplyser om att en motorväg börjar. Skylten sitter vid påfarter till motorvägar och på de ställen där en väg övergår till motorväg.

        Används märket som förberedande upplysning om att en motorväg börjar anges avståndet på en tilläggstavla.

        Märket kan även vara infogat i ett lokaliseringsmärke.
        """)
        
        let sign120 = Signs(text: "Motorväg upphör", correctAnswer: #imageLiteral(resourceName: "e2-1"), signExpl: """
        Vägmärket upplyser om att motorvägen har tagit slut och att trafikreglerna för motorväg upphör att gälla. Skylten finns oftast uppsatt på avfarter men även där en motorväg övergår till något annat.

        Används märket som förberedande upplysning om att en motorväg upphör anges avståndet på en tilläggstavla.
        """)
        
        let sign121 = Signs(text: "Motortrafikled", correctAnswer: #imageLiteral(resourceName: "e3-1"), signExpl: """
        Denna skylt upplyser om att en motortrafikled börjar och att trafikleglerna för en motortrafikled gäller.
        Vägmärket sitter vid påfarter till motortrafikleder och på de platser där en väg övergår till motortrafikled.

        Används märket som förberedande upplysning om att en motortrafikled börjar anges avståndet på en tilläggstavla.

        Märket kan även vara infogat i ett lokaliseringsmärke.
        """)
        
        let sign122 = Signs(text: "Motortrafikled upphör", correctAnswer: #imageLiteral(resourceName: "e4-1"), signExpl: """
        Vägmärket upplyser om att en motortrafikled tar slut och att trafikreglerna för motortrafikled upphör att gälla. Skylten finns oftast uppsatt på avfarter men även där en motortrafikled övergår till något annat.

        Används märket som förberedande upplysning om att en motortrafikled upphör anges avståndet på en tilläggstavla.
        """)
        
        let sign123 = Signs(text: "Tättbebyggt område", correctAnswer: #imageLiteral(resourceName: "e5-1"), signExpl: """
        Vägmärket upplyser om att ett tättbebyggt område börjar. Bashastigheten i tättbebyggda områden är 50km/h, men på många mindre gator & vägar gäller lägre hastighetsbegränsingar.

        När en annan hastighetsbegränsning gäller så finns den tydligt angiven på ett vägmärke.

        Denna skylt kombineras alltid med skyltar för gällande hastighetsbegränsning.
        """)
        
        let sign124 = Signs(text: "Tättbebyggt område upphör", correctAnswer: #imageLiteral(resourceName: "e6-1"), signExpl: """
        Vägmärket upplyser om att ett tättbebyggt område upphör.

        Denna skylt kombineras alltid med skyltar för gällande hastighetsbegränsning.
        """)
        
        let sign125 = Signs(text: "Gågata", correctAnswer: #imageLiteral(resourceName: "e7-1"), signExpl: """
        Denna skylt upplyser om att vägen efter skylten är en gågata.

        På gågator gäller särskilda regler, bl.a att fotgängare ska ges företräde.
        
        På gågator är trafik med motordrivet fordon normalt förbjudet, med undantag för exempelvis varuleveranser, sjuktransporter och transporter till och från bostäder och hotell vid gågatan.

        Det är tillåtet att korsa en gågata, om man följer vissa regler.
        Tänk på att: parkering endast är tillåtet på markerade P-platser, vid körning på gågata får du max köra i gånghastighet (5 km/h) samt att du har väjningsplikt mot de gående.
        """)
        
        let sign126 = Signs(text: "Gågata upphör", correctAnswer: #imageLiteral(resourceName: "e8-1"), signExpl: """
        Vägmärket indikerar att vägen efter märket inte längre är en gågata.

        Märket behöver inte vara uppsatt om det ändå tydligt framgår att gågatan upphör.
        """)
        
        let sign127 = Signs(text: "Gångfartsområde", correctAnswer: #imageLiteral(resourceName: "e9-1"), signExpl: """
        Vägmärket upplyser om att området bakom märket är ett gångfartsområde.
            
        På ett gångfartsområde gäller särskilda regler:

        -  Du får endast köra i gångfart!
        -  Du har väjningsplikt mot de gående!
        -  Parkering får ej ske på andra platser än markerade P-platser
        -  Du har väjningsplikt när du lämnar gångfartsområdet

        Tänk på att vara uppmärksam på din omgivning.
        """)
        
        let sign128 = Signs(text: "Gångfartsområde", correctAnswer: #imageLiteral(resourceName: "e10-1"), signExpl: """
        Vägmärket anger att ett gångfartsområde upphör.

        Märket behöver inte vara uppsatt om det ändå tydligt framgår att gångfartsområdet upphör.
        """)
        
        let sign129 = Signs(text: "Rekommenderad lägre hastighet - 30 km/h", correctAnswer: #imageLiteral(resourceName: "e11-1"), signExpl: """
        Märket anger en vägsträcka eller ett område där särskilda åtgärder vidtagits eller där förhållandena är sådana att det är lämpligt att färdas med lägre hastighet än den högsta tillåtna.
        
        Den angivna hastigheten är alltid lägre än den gällande hastighetsgränsen och det är därför lagligt att köra med en högre hastighet.
        Det anses dock olämpligt att köra fortare då skylten ofta sätts upp i områden där oskyddade trafikanter rör sig.

        Den rekommenderade lägre hastigheten anges på märket, i detta fall 30 km/h.
        """)
        
        let sign130 = Signs(text: "Rekommenderad lägre hastighet upphör - 30 km/h", correctAnswer: #imageLiteral(resourceName: "e12-1"), signExpl: """
        Vägmärket anger att den rekommenderade lägre hastigheten upphör och att den tidigare hastigheten (vanligtvis 50 km/h) nu gäller.
        
        Den rekommenderade lägre hastigheten som upphör anges på märket, i detta fall 30 km/h.

        Märket behöver inte vara uppsatt om det ändå tydligt framgår att sträckan upphör.
        """)
        
        let sign131 = Signs(text: "Rekommenderad högsta hastighet - 50 km/h", correctAnswer: #imageLiteral(resourceName: "e13-1"), signExpl: """
        Vägmärket används endast som omställbart vägmärke (digitalt) och anger att förhållandena tillfälligt är sådana att det inte är lämpligt att färdas med högre hastighet än den som anges på märket. Den angivna hastigheten är alltid lägre än den högsta tillåtna.

        Den angivna hastigheten är alltid lägre än den gällande hastighetsgränsen och det är därför lagligt att köra med en högre hastighet.
        Om hastighetsangivelsen omges av en röd ring är hastigheten dock förbjuden att överträda.

        Skylten finns på större vägar och aktiveras vanligtvis när det är mycket trafik.
        """)
        
        let sign132 = Signs(text: "Rekommenderad högsta hastighet upphör", correctAnswer: #imageLiteral(resourceName: "e14-1"), signExpl: """
        Vägmärket anger att den rekommenderade högsta hastigheten upphör och att den tidigare hastighetsgränsen gäller.

        Märket behöver inte vara uppsatt om det ändå tydligt framgår att de tillfälliga förhållandena upphört.
        """)
        
        let sign133 = Signs(text: "Sammanvävning", correctAnswer: #imageLiteral(resourceName: "e15-1"), signExpl: """
        Märket upplyser om att två körfält eller körbanor löper samman till ett och att förarna skall anpassa sig till de nya förhållandena på platsen enligt bestämmelserna i 3 kap. 44 § trafikförordningen.

        Sammanvävningen ska ske efter den så kallade \"blixtlåsprincipen\", vilket betyder att varannan förare turas om att köra in i det gemensamma körfältet.
        """)
        
        let sign134 = Signs(text: "Enkelriktad trafik", correctAnswer: #imageLiteral(resourceName: "e16-1"), signExpl: """
        Vägmärket anger att fordonstrafiken på vägen är enkelriktad i pilens riktning.
        """)
        
        let sign135 = Signs(text: "Enkelriktad trafik - Rakt fram", correctAnswer: #imageLiteral(resourceName: "E16-2"), signExpl: """
        Vägmärket anger att fordonstrafiken på vägen är enkelriktad i pilens riktning - Rakt fram.
        """)
        
        let sign136 = Signs(text: "Återvändsväg", correctAnswer: #imageLiteral(resourceName: "e17-1"), signExpl: "Märket anger att genomfart inte är möjlig. Symbolen anpassas efter förhållandena på platsen och kan vara infogad i ett lokaliseringsmärke.")
        
        let sign137 = Signs(text: "Mötesplats", correctAnswer: #imageLiteral(resourceName: "e18-1"), signExpl: """
        Märket avser en breddning av vägen där fordon kan mötas på en smal väg.

        Det är förbjudet att parkera på en mötesplats.
        """)
        
        let sign138 = Signs(text: "Parkering", correctAnswer: #imageLiteral(resourceName: "e19-1"), signExpl: """
        Vägmärket anger att parkering är tillåten på en parkeringsplats eller på en sträcka på den sida av vägen där vägmärket är uppsatt.

        Så länge inget annat anges är parkeringstiden i Sverige på vardagar, utom vardag före sön- och helgdag, är begränsad till 24 timmar.

        Tilläggstavlor med information om avgift, tidsbegränsning och klockslag då parkering är tillåten eller förbjuden är vanligtvis uppsatta under märket.
        """)
        
        let sign139 = Signs(text: "Områdesmärke - Förbud mot att parkera fordon", correctAnswer: #imageLiteral(resourceName: "e20-1"), signExpl: """
        Märket anger att ett område börjar med de förbud eller tillåtelser som anges med det infogade märket. i det här fallet, förbud mot att parkera fordon.

        Avvikelser från anvisningarna på märket kan anges genom tilläggstavlor. Tidsbegränsningar kan även infogas i märket.
        Märket är uppsatt vid infarterna till området och gäller till den plats där tavla E21, \"Slut på område\", är uppsatt eller det på annat tydligt sätt framgår att anvisningarna på märket inte gäller.

         Inom området kan det förekomma avvikelser från anvisningarna på märket. Dessa avvikelser anges genom andra vägmärken och tilläggstavlor. Anvisningarna på märket gäller även efter sådan avvikelse utan att märket upprepas.

        Andra förbud eller tillåtelser kan anges på märket.
        Transportstyrelsen får meddela föreskrifter om vilka andra förbud och tillåtelser som får anges.
        """)
        
        let sign140 = Signs(text: "Slut på område - Förbud mot att parkera fordon", correctAnswer: #imageLiteral(resourceName: "e21-1"), signExpl: """
        Märket anger att ett område med förbud eller tillåtelser som angivits på märke E20, \"Områdesmärke\", upphör.

        Andra förbud eller tillåtelser kan anges på märket.

        Transportstyrelsen får meddela föreskrifter om vilka andra förbud och tillåtelser som får anges.
        """)
        
        let sign141 = Signs(text: "Busshållplats", correctAnswer: #imageLiteral(resourceName: "e22-1"), signExpl: """
        Märket anger en hållplats för fordon i linjetrafik och skolskjuts om inte hållplatsen tydligt framgår på annat sätt.

        Klockslag kan anges på märket.
        """)
        
        let sign142 = Signs(text: "Taxi", correctAnswer: #imageLiteral(resourceName: "e23-1"), signExpl: "Märket anger den, i färdriktningen, bortre gränsen för en särskild uppställningsplats för taxibilar.")
        
        let sign143 = Signs(text: "Automatisk trafikövervakning", correctAnswer: #imageLiteral(resourceName: "e24-1"), signExpl: """
        Märket anger att automatisk övervakning med kamera eller motsvarande sker på en plats eller vägsträcka för övervakning av trafikregler, beskattning eller avgiftsbeläggning.

        Gäller anvisningen en längre vägsträcka, anges sträckans längd på tilläggstavla T1, vägsträckas längd. Märket upprepas på lämpliga avstånd.
        """)
        
        let sign144 = Signs(text: "Betalväg", correctAnswer: #imageLiteral(resourceName: "e25-1"), signExpl: """
        Märket anger att avgift eller särskild skatt skall betalas vid färd på en viss väg eller inom ett visst område.
        """)
        
        let sign145 = Signs(text: "Tunnel", correctAnswer: #imageLiteral(resourceName: "e26-1"), signExpl: """
        Märket anger tunnel. Tunnelns längd anges och tunnelns namn kan anges på märket.

        Märket är upprepat efter varje kilometer och kvarvarande tunnellängd anges då på märket.
        """)
        
        let sign146 = Signs(text: "Nöduppställningsplats", correctAnswer: #imageLiteral(resourceName: "e27-1"), signExpl: """
        Märket anger plats för uppställning av fordon vid haveri, motorstopp eller liknande.

        Symbol för nödtelefon och brandsläckare kan vara infogad i märket.

        Märket är utformat efter förhållandena på platsen. Används märket som förberedande upplysning om nöduppställningsplats anges avståndet på en tilläggstavla.
        """)
        
        let sign147 = Signs(text: "Nödutgång", correctAnswer: #imageLiteral(resourceName: "e28-1"), signExpl: "Märket anger nödutgång för gående & förekommer oftast i tunnlar.")
        
        let sign148 = Signs(text: "Utrymningsväg", correctAnswer: #imageLiteral(resourceName: "e29-1"), signExpl: """
        Vägmärket anger riktning och avstånd till nödutgång eller motsvarande för gående.

        Vägmärket förekommer främst i tunnlar & är uppsatt med högst 25 meters mellanrum.
        """)
        
        // MARK: LOKALISERINGSMÄRKEN ------>
        
        let sign149 = Signs(text: "Orienteringstavla", correctAnswer: #imageLiteral(resourceName: "f1-1"), signExpl: """
        Märket är en förberedande upplysning om korsning, cirkulationsplats eller motsvarande.
        Vägmärkets uppgift är alltså att göra det lättare för dig att planera din körning.

        Vägmärket brukar vara uppsatt ca 500 meter innan de val som skylten upplyser om.
        
        Om det finns särskilda skäl kan upplysning om två korsningar anges på märket.
        """)
        
        let sign150 = Signs(text: "Orienteringstavla", correctAnswer: #imageLiteral(resourceName: "f1-2"), signExpl: """
        Märket är en förberedande upplysning om korsning, cirkulationsplats eller motsvarande.
        Vägmärkets uppgift är alltså att göra det lättare för dig att planera din körning.

        Vägmärket brukar vara uppsatt ca 500 meter innan de val som skylten upplyser om.
        
        Om det finns särskilda skäl kan upplysning om två korsningar anges på märket.
        """)
    
        let sign151 = Signs(text: "Orienteringstavla vid förbjuden sväng i korsning", correctAnswer: #imageLiteral(resourceName: "f2-1"), signExpl: """
        Märket är en förberedande upplysning om att det är förbjudet att svänga i en korsning, men att en annan körriktning kan väljas.
        
        Det är alltså förbjudet att direkt svänga till vänster.

        Den som vill svänga till vänster ska istället köra av till höger för att sedan åka över vägen.
        Principen kallas för \"spanska svängen\" och syftet med denna pricip är att minska riskerna förknippade med vänstersvängar.

        Skylten brukar vara uppsatt ca 500 meter innan korsningen den upplyser om.
        """)
        
        let sign152 = Signs(text: "Tabellorienteringstavla", correctAnswer: #imageLiteral(resourceName: "f3-1"), signExpl: """
        Märket är en förberedande upplysning om korsning, cirkulationsplats eller motsvarande. Avståndsangivelsen på märket är anpassad till förhållandena på platsen och samtliga färdriktningar i korsningen anges.

        Längst ner på vägmärket anges ofta även avståndet till korsningen.
        """)
        
        let sign153 = Signs(text: "Avfartsorienteringstavla", correctAnswer: #imageLiteral(resourceName: "f4-1"), signExpl: "Märket är en förberedande upplysning om avfart. Avståndsangivelsen på märket är anpassad till förhållandena på platsen.")
        
        let sign154 = Signs(text: "Vägvisare", correctAnswer: #imageLiteral(resourceName: "f5-1"), signExpl: """
        Vägmärket är uppsatt i anslutning till en korsning, den blå färgen upplyser om att vägen som skylten hänvisar till är allmän väg.
        Avståndet anges i hela kilometer.
        """)
        
        let sign155 = Signs(text: "Tabellvägvisare", correctAnswer: #imageLiteral(resourceName: "f6-1"), signExpl: """
        Vägmärket visar vägen och upplyser om vägnummer til de olika alternativen som finns att välja på.
        
        Märket är uppsatt på kort avstånd före en korsning, cirkulationsplats eller i utfarten från en cirkulationsplats.
        """)
        
        let sign156 = Signs(text: "Avfartsvisare", correctAnswer: #imageLiteral(resourceName: "f7-1"), signExpl: """
        Skylten upplyser om vilken väg och riktning en avfart leder till, i detta fall kommer du till Mora (via riksväg 70) och Enköping.

        Märket är uppsatt där avfarten börjar.
        """)
        
        let sign157 = Signs(text: "Körfältsvägvisare", correctAnswer: #imageLiteral(resourceName: "f8-1"), signExpl: """
        Märket anger det eller de körfält som är lämpligt att använda för färd till målet. Märket är uppsatt över det eller de körfält det avser.
        Ska du till Boda är det lämpligast att använda det vänstra körfältet, till falun är höger körfält lämpligast.

        Körfältsvägvisare kan även användas som förberedande upplysning om avfart. I sådana fall anges avståndet till avfarten under angivelsen för avfarten.
        """)
        
        let sign158 = Signs(text: "Körfältsvägvisare", correctAnswer: #imageLiteral(resourceName: "f8-2"), signExpl: """
        Märket anger det eller de körfält som är lämpligt att använda för färd till målet. Märket är uppsatt över det eller de körfält det avser.

        Körfältsvägvisare kan även användas som förberedande upplysning om avfart. I sådana fall anges avståndet till avfarten under angivelsen för avfarten.
        I detta fall är det 500 meter kvar till avfart mot Enköping.
        """)
        
        let sign159 = Signs(text: "Samlingsmärke för vägvisning", correctAnswer: #imageLiteral(resourceName: "f9-1"), signExpl: """
        Inom klammer anges mål som nås via ett gemensamt vägval (Pajala & Övertorneå) och under klammerns spets anges det gemensamma vägvalet (Kiruna).

        Avståndet till aktuell avfart eller korsning kan anges på en tilläggstavla.
        """)
        
        let sign160 = Signs(text: "Platsmärke", correctAnswer: #imageLiteral(resourceName: "f10-1"), signExpl: "Märket anger en ort eller annan plats av betydelse för orienteringen. Kommun-, stads- eller länsvapen kan vara infogat i märket.")
        
        let sign161 = Signs(text: "Vägnamn", correctAnswer: #imageLiteral(resourceName: "f11-1"), signExpl: "Märket anger namn på en viss väg eller led.")
        
        let sign162 = Signs(text: "Vattendrag", correctAnswer: #imageLiteral(resourceName: "f12-1"), signExpl: "Vägmärket anger namn på ett visst vattendrag.")
        
        let sign163 = Signs(text: "Avståndstavla", correctAnswer: #imageLiteral(resourceName: "f13-1"), signExpl: """
        Vägmärket visar avståndet till olika platser. Avstånd anges i hela kilometer.
            
        Vägnamn eller vägnummer kan vara infogade i märket.
        """)
       
        let sign164 = Signs(text: "Vägnummer - Europaväg", correctAnswer: #imageLiteral(resourceName: "f14-1"), signExpl: """
        Vägmärket anger vägens nummer och den gröna färgen visar att det är en Europaväg.

        Europavägar är ett vägnät som förbinder Europas länder. Vägarna numreras med ett E följt av ett 1- till 3-siffrigt tal, till exempel E4, E18, E20.
        """)
        
        let sign165 = Signs(text: "Vägnummer - Europaväg", correctAnswer: #imageLiteral(resourceName: "f14-2"), signExpl: """
        Vägmärket anger att vägen leder till den Europaväg som anges på märket.
        
        Vägmärket anger vägens nummer, den gröna färgen visar att det är en Europaväg & den streckade linjen visar att det är en hänvisningsskylt.

        Europavägar är ett vägnät som förbinder Europas länder. Vägarna numreras med ett E följt av ett 1- till 3-siffrigt tal, till exempel E4, E18, E20.
        """)
        
        let sign166 = Signs(text: "Vägnummer - Riksväg eller länsväg", correctAnswer: #imageLiteral(resourceName: "f14-3"), signExpl: """
        Vägmärket upplyser om vägens nummer och den blåa bakgrunden talar om att det är en riksväg eller länsväg.

        Riksvägar är vägar som har vägnummer från 1 (i söder) till och med 99 (i norr). Vanligtvis håller riksvägarna en hög standard.
        """)
        
        
        let sign167 = Signs(text: "Vägnummer - Riksväg eller länsväg", correctAnswer: #imageLiteral(resourceName: "f14-4"), signExpl: """
        Vägmärket anger att vägen leder till den riksväg/länsväg som anges på märket.
        
        Vägmärket anger vägens nummer, den blå färgen visar att det är en riksväg eller länsväg och den streckade linjen visar att det är en hänvisningsskylt.

        Riksvägar är vägar som har vägnummer från 1 (i söder) till och med 99 (i norr). Vanligtvis håller riksvägarna en hög standard.
        """)
        
        let sign168 = Signs(text: "Omledning", correctAnswer: #imageLiteral(resourceName: "f15-1"), signExpl: """
        Vägmärket anger permanent omledningsväg för ordinarie numrerad väg.

        Vita vägnummerskyltar gäller vid omledning av trafiken och är permanent uppsatta så att de är tillgängliga vid trafikstörningar.
        Normalt har dessa vägar sämre vägstandard än de ordninarie vägarna.
        """)
        
        let sign169 = Signs(text: "Ökning av antal körfält", correctAnswer: #imageLiteral(resourceName: "f16-1") , signExpl: """
        Märket anger att antalet körfält ökar och är anpassat efter förhållandena på platsen.

        Symboler för fordonsslag eller vägnummer kan vara infogade i märket. Vägmärket används även som förberedande upplysning om att antalet körfält ökar. Avståndet anges då på en tilläggstavla.
        """)
        
        let sign170 = Signs(text: "Ökning av antal körfält", correctAnswer: #imageLiteral(resourceName: "f16-2"), signExpl: """
        Märket anger att antalet körfält ökar och är anpassat efter förhållandena på platsen. I detta fall visar märket även att ett körfält med mötande trafik förekommer.

        Symboler för fordonsslag eller vägnummer kan vara infogade i märket. Vägmärket används även som förberedande upplysning om att antalet körfält ökar. Avståndet anges då på en tilläggstavla.
        """)
        
        let sign171 = Signs(text: "Ökning av antal körfält", correctAnswer: #imageLiteral(resourceName: "f16-3"), signExpl: """
        Märket anger att antalet körfält ökar och är anpassat efter förhållandena på platsen. I detta fall visar märket även att ett avgränsat körfält med mötande trafik förekommer.

        Symboler för fordonsslag eller vägnummer kan vara infogade i märket. Vägmärket används även som förberedande upplysning om att antalet körfält ökar. Avståndet anges då på en tilläggstavla.
        """)
        
        let sign172 = Signs(text: "Ökning av antal körfält", correctAnswer: #imageLiteral(resourceName: "f16-4"), signExpl: """
        Märket anger att antalet körfält ökar och är anpassat efter förhållandena på platsen.

        Symboler för fordonsslag eller vägnummer kan vara infogade i märket. Vägmärket används även som förberedande upplysning om att antalet körfält ökar. Avståndet anges då på en tilläggstavla.
        """)
        
        let sign173 = Signs(text: "Minskning av antal körfält", correctAnswer: #imageLiteral(resourceName: "f17-1"), signExpl: """
        Vägmärket anger att antalet körfält minskar och är anpassat efter förhållandena på platsen.

        Märket används även som förberedande upplysning om att antalet körfält minskar. Avståndet anges då på en tilläggstavla.
        """)
        
        let sign174 = Signs(text: "Minskning av antal körfält", correctAnswer: #imageLiteral(resourceName: "f17-2"), signExpl: """
        Vägmärket anger att antalet körfält minskar och är anpassat efter förhållandena på platsen. I detta fall visar märket även att ett körfält med mötande trafik förekommer.

        Märket används även som förberedande upplysning om att antalet körfält minskar. Avståndet anges då på en tilläggstavla.
        """)
        
        let sign175 = Signs(text: "Minskning av antal körfält", correctAnswer: #imageLiteral(resourceName: "f17-3"), signExpl: """
        Vägmärket anger att antalet körfält minskar och är anpassat efter förhållandena på platsen.

        Märket används även som förberedande upplysning om att antalet körfält minskar. Avståndet anges då på en tilläggstavla.
        """)
        
        let sign176 = Signs(text: "Körfältsindelning på sträcka", correctAnswer: #imageLiteral(resourceName: "f18-1"), signExpl: """
        Vägmärket anger körriktning i körfält och är anpassat efter förhållandena på platsen.

        I detta fall visar märket att det finns två körfält i din riktning och ett körfält i motsatt riktning.

        Symboler för fordonsslag, vägnummer eller fysisk avgränsning mellan motriktade körfält kan vara infogade i märket.

        Märket används även som förberedande upplysning om att körfält börjar. Avståndet anges då på en tilläggstavla.

        Vid tillfällig trafikomläggning kan märket vara utfört med orange botten.
        """)
        
        let sign177 = Signs(text: "Körfältsindelning på sträcka", correctAnswer: #imageLiteral(resourceName: "f18-2"), signExpl: """
        Vägmärket anger körriktning i körfält och är anpassat efter förhållandena på platsen.

        I detta fall visar märket att det finns ett körfält i din riktning och ett avgränsat körfält i motsatt riktning.

        Symboler för fordonsslag, vägnummer eller fysisk avgränsning mellan motriktade körfält kan vara infogade i märket.

        Märket används även som förberedande upplysning om att körfält börjar. Avståndet anges då på en tilläggstavla.

        Vid tillfällig trafikomläggning kan märket vara utfört med orange botten.
        """)
        
        let sign178 = Signs(text: "Körfältsindelning på sträcka", correctAnswer: #imageLiteral(resourceName: "f18-3"), signExpl: """
        Vägmärket anger körriktning i körfält och är anpassat efter förhållandena på platsen.

        I detta fall visar märket att körbanan har två körfält i din körriktning.

        Symboler för fordonsslag, vägnummer eller fysisk avgränsning mellan motriktade körfält kan vara infogade i märket.

        Märket används även som förberedande upplysning om att körfält börjar. Avståndet anges då på en tilläggstavla.

        Vid tillfällig trafikomläggning kan märket vara utfört med orange botten.
        """)
        
        let sign179 = Signs(text: "Körfältsindelning på sträcka", correctAnswer: #imageLiteral(resourceName: "f18-4"), signExpl: """
        Vägmärket anger körriktning i körfält och är anpassat efter förhållandena på platsen.

        I detta fall visar märket att körbanan har ett körfält i din körriktning och två körfält i motsatt körriktning.

        Symboler för fordonsslag, vägnummer eller fysisk avgränsning mellan motriktade körfält kan vara infogade i märket.

        Märket används även som förberedande upplysning om att körfält börjar. Avståndet anges då på en tilläggstavla.

        Vid tillfällig trafikomläggning kan märket vara utfört med orange botten.
        """)
        
        let sign180 = Signs(text: "Körfältsindelning på sträcka", correctAnswer: #imageLiteral(resourceName: "f18-5"), signExpl: """
        Vägmärket anger körriktning i körfält och är anpassat efter förhållandena på platsen.

        I detta fall visar märket att körbanan har två körfält i din körriktning och ett avgränsat körfält i motsatt körriktning.

        Symboler för fordonsslag, vägnummer eller fysisk avgränsning mellan motriktade körfält kan vara infogade i märket.

        Märket används även som förberedande upplysning om att körfält börjar. Avståndet anges då på en tilläggstavla.

        Vid tillfällig trafikomläggning kan märket vara utfört med orange botten.
        """)

        let sign181 = Signs(text: "Körfältsindelning på sträcka", correctAnswer: #imageLiteral(resourceName: "f18-6"), signExpl: """
        Vägmärket anger körriktning i körfält och är anpassat efter förhållandena på platsen.

        I detta fall visar märket att körbanan har ett körfält i din körriktning och två avgränsade körfält i motsatt körriktning.

        Symboler för fordonsslag, vägnummer eller fysisk avgränsning mellan motriktade körfält kan vara infogade i märket.

        Märket används även som förberedande upplysning om att körfält börjar. Avståndet anges då på en tilläggstavla.

        Vid tillfällig trafikomläggning kan märket vara utfört med orange botten.
        """)
        
        let sign182 = Signs(text: "Väganslutning med accelerationsfält", correctAnswer: #imageLiteral(resourceName: "f19-1"), signExpl: """
        Vägmärket anger att ett accelerationsfält ansluter till vägen och är anpassat efter förhållandena på platsen.

        I detta fall visar märket att körbanan har två körfält i din färdriktning och att ett accelerationsfält ansluter.

        Vid tillfällig trafikomläggning kan märket vara utfört med orange botten.
        """)
        
        let sign183 = Signs(text: "Väganslutning med separat körfält", correctAnswer: #imageLiteral(resourceName: "f20-1"), signExpl: """
        Vägmärket anger att ett separat körfält ansluter till vägen och är anpassat efter förhållandena på platsen.

        I detta fall visar märket att körbanan har två körfält i din färdriktning och att ett separat körfält ansluter.

        Vid tillfällig trafikomläggning kan märket vara utfört med orange botten.
        """)
        
        let sign184 = Signs(text: "Körfältsindelning före korsning", correctAnswer: #imageLiteral(resourceName: "f21-1"), signExpl: """
        Vägmärket visar lämpligt körfält för fortsatt färd och är anpassat till förhållandena på platsen.
        """)
        
        let sign185 = Signs(text: "Riksmärke", correctAnswer: #imageLiteral(resourceName: "f22-1"), signExpl: "Märket anger gräns mot annat EU-land.")
        
        let sign186 = Signs(text: "Orienteringstavla för omledningsväg", correctAnswer: #imageLiteral(resourceName: "f23-1"), signExpl: """
        Märket anger omledningsväg när ordinarie väg tillfälligt är avstängd.

        Den streckade linjen visar den ordinarie, avstängda vägen.
        """)
        
        let sign187 = Signs(text: "Färdriktning vid omledning", correctAnswer: #imageLiteral(resourceName: "f24-1"), signExpl: "Märket anger färdriktning vid tillfällig omledning av trafik och förekommer främst vid vägarbeten inom tättbebyggda områden.")
        
        let sign188 = Signs(text: "Körfält upphör", correctAnswer: #imageLiteral(resourceName: "f25-1"), signExpl: """
        Vägmärket anger att ett körfält tillfälligt är avstängt pga ett vägarbete och att ett annat körfält kan användas i färdriktningen.

        Märket är anpassat efter förhållandena på platsen.
        """)

        let sign189 = Signs(text: "Körfält avstängt", correctAnswer: #imageLiteral(resourceName: "f26-1"), signExpl: """
        Märket anger att ett körfält tillfälligt är avstängt och att inget annat körfält i färdriktningen kan användas.

        Märket är anpassat efter förhållandena på platsen. Avvikelse från färg får inte ske.
        """)
        
        let sign190 = Signs(text: "Trafikplatsnummer", correctAnswer: #imageLiteral(resourceName: "f27-1"), signExpl: """
        Vägmärket anger numret på trafikplatsen. Trafikplatsnummer, även kallat \"avfartsnummer\", finns främst på motorvägar men även på vissa motortrafikleder.

        På vägar där trafikplatsnummer finns så är varje avfart numrerad i nummerföljd.
        """)
        
        let sign191 = Signs(text: "Parkeringshus", correctAnswer: #imageLiteral(resourceName: "f28-1"), signExpl: """
        Upplysning om att parkeringsplatsen är fullbelagd eller om att det finns lediga platser kan lämnas i anslutning till märket.

        Parkeringshusets namn får vara infogat i märket.
        Märket får infogas i ett lokaliseringsmärke för vägvisning.
        """)
        
        let sign192 = Signs(text: "Infartsparkering - Tunnelbana", correctAnswer: #imageLiteral(resourceName: "f29-1"), signExpl: """
        Märket anger parkeringsplats i anslutning till kollektivtrafik. Symbolen på märket anger vilken typ av kollektivtrafik som är tillgänglig.

        Parkeringsplatsens namn kan vara infogat i märket.
        Märket kan vara infogat i ett lokaliseringsmärke för vägvisning.
        """)
        
        let sign193 = Signs(text: "Infartsparkering - Buss", correctAnswer: #imageLiteral(resourceName: "f29-2"), signExpl: """
        Märket anger parkeringsplats i anslutning till kollektivtrafik. Symbolen på märket anger vilken typ av kollektivtrafik som är tillgänglig.

        Parkeringsplatsens namn kan vara infogat i märket.
        Märket kan vara infogat i ett lokaliseringsmärke för vägvisning.
        """)
        
        let sign194 = Signs(text: "Infartsparkering - Tåg", correctAnswer: #imageLiteral(resourceName: "f29-3"), signExpl: """
        Märket anger parkeringsplats i anslutning till kollektivtrafik. Symbolen på märket anger vilken typ av kollektivtrafik som är tillgänglig.

        Parkeringsplatsens namn kan vara infogat i märket.
        Märket kan vara infogat i ett lokaliseringsmärke för vägvisning.
        """)
        
        let sign195 = Signs(text: "Lokal slinga", correctAnswer: #imageLiteral(resourceName: "f30-1"), signExpl: """
        Vägmärket anger ringväg eller motsvarande.

        En lokal slinka är en väg som går runt en stad för att leda bort trafiken från bebyggelsen.

        Märket kan vara kompletterat med beteckning eller motsvarande.
        """)
        
        let sign196 = Signs(text: "Märke för visst fordonsslag eller trafikantgrupp", correctAnswer: #imageLiteral(resourceName: "f31-5"), signExpl: """
        Märket anger lämplig väg eller förbifart för angivet fordonsslag eller trafikantgrupp.

        Symbolen på märket anger vilken typ av fordonsslag eller trafikantgrupp som avses.
        """)
        
        let sign197 = Signs(text: "Farligt gods", correctAnswer: #imageLiteral(resourceName: "f32-1"), signExpl: "Märket anger rekommenderad färdväg för fordon med last som omfattas av krav på märkning med orangefärgad skylt enligt föreskrifter som har meddelats med stöd av lagen (2006:263) om transport av farligt gods.")
        
        let sign198 = Signs(text: "Räddningsplats", correctAnswer: #imageLiteral(resourceName: "f33-1"), signExpl: "Märket anger en räddningsplats vid vägarbeten eller motsvarande.")
        
        
        //        MARK: LOKALISERINGSMÄRKEN FÖR GÅNG- OCH CYKELTRAFIK
        
        let sign199 = Signs(text: "Vägvisare", correctAnswer: #imageLiteral(resourceName: "f34-1"), signExpl: """
        Märket anger väg till en ort, plats, anläggning eller liknande. Avstånd i kilometer kan anges.

        Märket finns uppsatt vid korsningar på cykelvägar och gäller även mopeder om inget annat anges.
        """)
        
        let sign200 = Signs(text: "Tabellvägvisare", correctAnswer: #imageLiteral(resourceName: "f35-1"), signExpl: """
        Märket anger väg till orter, platser, anläggningar eller liknande. Avståndet anges i kilometer.
        """)
        
        let sign201 = Signs(text: "Platsmärke", correctAnswer: #imageLiteral(resourceName: "f36-1"), signExpl: """
        Märket anger en ort eller annan plats av betydelse för orienteringen.
        """)
        
        let sign202 = Signs(text: "Avståndstavla", correctAnswer: #imageLiteral(resourceName: "f37-1"), signExpl: """
        Märket anger avståndet till angivna orter, platser, anläggningar eller liknande. Avståndet anges i kilometer.
        """)
        
        let sign203 = Signs(text: "Cykelled", correctAnswer: #imageLiteral(resourceName: "f38-1"), signExpl: """
        Märket anger en särskilt anordnad cykelled.
        Märkets färgsättning kan variera.
        """)
        
        //         MARK: LOKALISERINGSMÄRKEN FÖR UPPLYSNING OM ALLMÄNNA INRÄTTNINGAR
        
        let sign204 = Signs(text: "Post", correctAnswer: #imageLiteral(resourceName: "g1-1"), signExpl: "Märket anger postombud där brev och pakethantering samt frimärksförsäljning erbjuds.")
        
        let sign205 = Signs(text: "Hjälptelefon", correctAnswer: #imageLiteral(resourceName: "g2-1"), signExpl: """
        Vägmärket anger en hjälptelefon.

        Hjälptelefoner brukar finnas vid vägkanten och är direktkopplade till närmaste arlarmeringscentral.
        """)
        
        let sign206 = Signs(text: "Radiostation för vägtrafikinformation", correctAnswer: #imageLiteral(resourceName: "g3-1"), signExpl: "Märket anger att vägtrafikinformation ges regelbundet i återkommande sändningar som är avsedda att täcka ett större område.")
        
        let sign207 = Signs(text: "Akutsjukhus", correctAnswer: #imageLiteral(resourceName: "g4-1"), signExpl: "Märket anger ett sjukhus med akutmottagning.")
        
        let sign208 = Signs(text: "Industriområde", correctAnswer: #imageLiteral(resourceName: "g5-1"), signExpl: "Märket anger ett område för industri eller annan liknande verksamhet.")
        
        let sign209 = Signs(text: "Järnvägsstation", correctAnswer: #imageLiteral(resourceName: "g6-1"), signExpl: "Vägmärket anger en järnvägsstation")
        
        let sign210 = Signs(text: "Flygplats", correctAnswer: #imageLiteral(resourceName: "g8-1"), signExpl: "Märket anger en flygplats med reguljär flygtrafik.")
        
        let sign211 = Signs(text: "Brandsläckare", correctAnswer: #imageLiteral(resourceName: "g9-1"), signExpl: "Vägmärket anger att en brandsläckare finns. Märket används oftast i tunnlar.")
        
        let sign212 = Signs(text: "Handelsområde", correctAnswer: #imageLiteral(resourceName: "g10"), signExpl: "Märket anger ett område för handel.")
        
        
        //        MARK: LOKALISERINGSMÄRKEN - SERVICEANLÄGGNINGAR
        
        let sign213 = Signs(text: "Informationsplats", correctAnswer: #imageLiteral(resourceName: "h1-1"), signExpl: """
        Märket anger en plats där det går att få information.

        Uppgift om vilken typ av information som finns kan anges i anslutning till märket.
        """)
        
        let sign214 = Signs(text: "Fordonsverkstad", correctAnswer: #imageLiteral(resourceName: "h2-1"), signExpl: "Vägmärket anger en verkstad")
        
        let sign215 = Signs(text: "Drivmedel", correctAnswer: #imageLiteral(resourceName: "h3-1"), signExpl: """
        Märket anger en anläggning som tillhandahåller drivmedel.
        
        Företagsemblem kan anges i anslutning till märket.
        """)
        
        let sign216 = Signs(text: "Gas för fordonsdrift", correctAnswer: #imageLiteral(resourceName: "h4-1"), signExpl: """
        Märkena anger anläggningar som tillhandahåller olika typer av fordonsgas där typ av gas framgår av förkortningen i märket.
        """)
        
        let sign217 = Signs(text: "Servering", correctAnswer: #imageLiteral(resourceName: "h5-1"), signExpl: "Märket anger en anläggning som serverar drycker och enklare maträtter.")
        
        let sign218 = Signs(text: "Restaurang", correctAnswer: #imageLiteral(resourceName: "h6-1"), signExpl: "Vägmärket anger en restaurang som serverar mat")
        
        let sign219 = Signs(text: "Hotell", correctAnswer: #imageLiteral(resourceName: "h7-1"), signExpl: "Vägmärket anger att det finns ett hotell i närheten. Det kan vara allt ifrån enklare inrättningar till lyxhotell")
        
        let sign220 = Signs(text: "Vandrarhem", correctAnswer: #imageLiteral(resourceName: "h8-1"), signExpl: "Vägmärket anger ett vandrarhem.")
        
        let sign221 = Signs(text: "Stugby", correctAnswer: #imageLiteral(resourceName: "h9-1"), signExpl: "Märket anger en anläggning med ett större antal stugor.")
        
        let sign222 = Signs(text: "Stuga", correctAnswer: #imageLiteral(resourceName: "h10-1"), signExpl: "Märket anger en anläggning med ett fåtal stugor.")
        
        let sign223 = Signs(text: "Campingplats", correctAnswer: #imageLiteral(resourceName: "h11-1"), signExpl: "Märket anger en anläggning som tillhandahåller platser för såväl tält som husvagnar och husbilar.")
        
        let sign224 = Signs(text: "Husvagnsplats", correctAnswer: #imageLiteral(resourceName: "h12-1"), signExpl: "Märket anger en anläggning som enbart tillhandahåller platser för husvagnar och husbilar.")
        
        let sign225 = Signs(text: "Rastplats", correctAnswer: #imageLiteral(resourceName: "h13-1"), signExpl: "Märket anger en rastplats där det finns toalett som är tillgänglig även för rörelsehindrade.")
        
        let sign226 = Signs(text: "Toalett", correctAnswer: #imageLiteral(resourceName: "h14-1"), signExpl: "Märket anger en toalett som är tillgänglig även för rörelsehindrade.")
        
        let sign227 = Signs(text: "Badplats", correctAnswer: #imageLiteral(resourceName: "h15-1"), signExpl: "Märket anger utomhusbad.")
        
        let sign228 = Signs(text: "Friluftsområde", correctAnswer: #imageLiteral(resourceName: "h16-1"), signExpl: "Vägmärket anger ett friluftsområde")
        
        let sign229 = Signs(text: "Vandringsled", correctAnswer: #imageLiteral(resourceName: "h17-1"), signExpl: "Vägmärket anger en vandringsled")
        
        let sign230 = Signs(text: "Stollift", correctAnswer: #imageLiteral(resourceName: "h18-1"), signExpl: "Märket anger en liftanläggning med stolar eller liknande.")
        
        let sign231 = Signs(text: "Släplift", correctAnswer: #imageLiteral(resourceName: "h19-1"), signExpl: "Märket anger en liftanläggning där skidåkare dras fram.")
        
        let sign232 = Signs(text: "Golfbana", correctAnswer: #imageLiteral(resourceName: "h20-1"), signExpl: "Vägmärket anger en golfbana")
        
        let sign233 = Signs(text: "Försäljningsställe för fiskekort", correctAnswer: #imageLiteral(resourceName: "h21-1"), signExpl: "Vägmärket anger ett försäljningsställe för fiskekort.")

        let sign234 = Signs(text: "Sevärdhet", correctAnswer: #imageLiteral(resourceName: "h22-1"), signExpl: "Märket anger en sevärdhet av nationellt intresse. Sevärdhetens art anges i anslutning till märket.")
        
        let sign235 = Signs(text: "Förberedande upplysning om vägnära service", correctAnswer: #imageLiteral(resourceName: "h23-1"), signExpl: """
        Märket anger vägnära serviceanläggningar samt i vissa fall namn på dessa.

        Symbol för serviceanläggningarna drivmedel, restaurang och hotell kan vara kompletterade med företagsemblem eller företagsnamn.

        På märket anges avståndet till aktuell avfart eller korsning.
        """)
        
        let sign236 = Signs(text: "Rum och frukost", correctAnswer: #imageLiteral(resourceName: "h24-1"), signExpl: "Märket anger en anläggning som tillhandahåller rum för övernattning och frukost.")
        
        let sign237 = Signs(text: "Gårdsbutik", correctAnswer: #imageLiteral(resourceName: "h25"), signExpl: "Märket anger en anläggning med försäljning av lokalt tillverkade eller närodlade produkter.")
        
        let sign238 = Signs(text: "Hantverk", correctAnswer: #imageLiteral(resourceName: "h26"), signExpl: "Märket anger en anläggning med tillverkning och försäljning av hantverksprodukter.")
        
        let sign239 = Signs(text: "Laddstation", correctAnswer: #imageLiteral(resourceName: "h27"), signExpl: "Märket anger en anläggning för extern laddning med elektrisk energi för fordons framdrivning.")
        
        //        MARK: LOKALISERINGSMÄRKEN FÖR TURISTISKT INTRESSANTA MÅL
        
        let sign240 = Signs(text: "Turistväg", correctAnswer: #imageLiteral(resourceName: "i1-1"), signExpl: "Märket anger en väg eller vägsträckning av turistiskt intresse. Märket kan vara infogat i ett lokaliseringsmärke för vägvisning.")
        
        let sign241 = Signs(text: "Turistområde", correctAnswer: #imageLiteral(resourceName: "i2-1"), signExpl: """
        Vägmärket anger ett turistområde.

        Symbolen på märket är anpassad till temat för turistområdet.
        """)
        
        let sign242 = Signs(text: "Landmärke", correctAnswer: #imageLiteral(resourceName: "i3-1"), signExpl: """
        Vägmärket upplyser om ett landmärke av turistiskt intresse som kan ses från vägen.

        Symbolen på märket visar en siluett av platsen.
        """)
        
        let sign243 = Signs(text: "Världsarv", correctAnswer: #imageLiteral(resourceName: "i4-1"), signExpl: "Märket anger ett av UNESCO beslutat världsarv.")
        
        //        MARK: UPPLYSNINGSMÄRKEN
        
        let sign244 = Signs(text: "Upplysningsmärke", correctAnswer: #imageLiteral(resourceName: "j2-1"), signExpl: """
        Vägmärket ger upplysning av väsentligt intresse för framkomlighet eller säkerhet som inte kan ges på annat sätt.

        Varnings- eller förbudsmärke kan vara infogat som förberedande upplysning.
        """)
        
        let sign245 = Signs(text: "Livsfarlig ledning", correctAnswer: #imageLiteral(resourceName: "j3-1"), signExpl: "Märket anger att det finns en elektrisk ledning över vägen eller leden som kan innebära fara.")
        
        //        MARK: SYMBOLER
        
        let sign246 = Signs(text: "Tung lastbil", correctAnswer: #imageLiteral(resourceName: "s1.1"), signExpl: """
        Symboler används på lokaliseringsmärken eller tilläggstavlor för att visa att informationen gäller tung lastbil.

        Symbolen kan avbildas på olika typer av märken mot olika bakgrundsfärger.
        """)
        
        let sign247 = Signs(text: "Tung lastbil med tillkopplad släpvagn", correctAnswer: #imageLiteral(resourceName: "s2-1"), signExpl: """
        Symboler används på lokaliseringsmärken eller tilläggstavlor för att visa att informationen gäller tung lastbil med tillkopplad släpvagn.

        Symbolen kan avbildas på olika typer av märken mot olika bakgrundsfärger.
        """)
        
        let sign248 = Signs(text: "Personbil", correctAnswer: #imageLiteral(resourceName: "s3-1"), signExpl: """
        Symboler används på lokaliseringsmärken eller tilläggstavlor för att visa att informationen gäller personbil.

        Symbolen kan avbildas på olika typer av märken mot olika bakgrundsfärger.
        """)
        
        let sign249 = Signs(text: "Personbil med tillkopplad släpkärra", correctAnswer: #imageLiteral(resourceName: "s4-1"), signExpl: """
        Symboler används på lokaliseringsmärken eller tilläggstavlor för att visa att informationen gäller personbil med tillkopplad släpkärra.

        Symbolen kan avbildas på olika typer av märken mot olika bakgrundsfärger.
        """)
        
        
        //        MARK: TILLÄGGSTAVLOR
        
        let sign250 = Signs(text: "Vägsträckas längd - I meter", correctAnswer: #imageLiteral(resourceName: "T1-1"), signExpl: "Tavlan anger början och slutet på en vägsträcka.")
        
        let sign251 = Signs(text: "Vägsträckans längd - I kilometer", correctAnswer: #imageLiteral(resourceName: "T1-2"), signExpl: "Tavlan anger början och slutet på en vägsträcka.")
        
        let sign252 = Signs(text: "Avstånd", correctAnswer: #imageLiteral(resourceName: "t2-1"), signExpl: """
        Tavlan anger avståndet till det som vägmärket avser.

        Symbolen kan avbildas på olika typer av märken mot olika bakgrundsfärger.
        """)
        
        let sign253 = Signs(text: "Avstånd till stopplikt", correctAnswer: #imageLiteral(resourceName: "t3-1"), signExpl: """
        Tavlan används endast under märke B1, väjningsplikt.
        """)
        
        let sign254 = Signs(text: "Fri bredd", correctAnswer: #imageLiteral(resourceName: "t4-1"), signExpl: """
        Vägmärket anger vägens bredd vid ett tillfälligt hinder.

        Om vägen är under 5,5-5 meter så kan inte tunga fordon mötas, utan måste vänta på varandra. Om vägen är under 4 meter blir det svårt för personbilar att mötas.
        """)
        
        let sign255 = Signs(text: "Totalvikt", correctAnswer: #imageLiteral(resourceName: "t5-1"), signExpl: """
        Tavlan anger att angivelsen på märket gäller fordon med en totalvikt som överstiger det angivna värdet.

        Symbolen kan avbildas på olika typer av märken mot olika bakgrundsfärger.
        """)
        
        let sign256 = Signs(text: "Tidsangivelse", correctAnswer: #imageLiteral(resourceName: "t6-1"), signExpl: """
        Tavlan anger när angivelsen på vägmärket gäller. Används klockslag i kombination med andra villkor anger tavlan även när dessa villkor gäller.
        
        - Svarta eller vita siffror utan parentes avser vardagar utom vardag före sön- och helgdag.

        - Svarta eller vita siffror inom parentes avser vardag före sön- och helgdag.

        - Röda siffror avser sön- och helgdag.

        Om angivelsen sträcker sig över midnatt gäller tidsperioden efter midnatt påföljande dag. Anges viss dag eller viss veckodag gäller regleringen denna dag oavsett om dagen är en vardag, söndag eller helgdag.
        """)
        
        let sign257 = Signs(text: "Särskilda bestämmelser för stannande och parkering", correctAnswer: #imageLiteral(resourceName: "t7-1"), signExpl: """
        Tavlan anger en avvikelse från det märke som den är uppsatt under.

        I detta fall anger tavlan att det mellan 8-18 endast är tillåtet att parkera i 30 minuter.
        """)
        
        let sign258 = Signs(text: "Särskilda bestämmelser för stannande och parkering - Förbud mot att parkera fordon", correctAnswer: #imageLiteral(resourceName: "t7-2"), signExpl: """
        Tavlan anger en avvikelse från huvudvägmärket som tavlan är uppsatt under.

        I detta fall anger tavlan att det mellan 8-18 råder parkeringsförbud.
        """)
        
        let sign259 = Signs(text: "Särskilda bestämmelser för stannande och parkering - Förbud mot att parkera fordon på dag med udda datum.", correctAnswer: #imageLiteral(resourceName: "t7-3"), signExpl: """
        Tavlan anger en avvikelse från huvudvägmärket som tavlan är uppsatt under.

        I detta fall anger tavlan att det råder parkeringsförbud på dag med udda datum mellan kl 8-18.
        """)
        
        let sign260 = Signs(text: "Särskilda bestämmelser för stannande och parkering - Förbud mot att parkera fordon på dag med jämnt datum", correctAnswer: #imageLiteral(resourceName: "t7-4"), signExpl: """
        Tavlan anger en avvikelse från huvudvägmärket som tavlan är uppsatt under.

        I detta fall anger tavlan att det råder parkeringsförbud på dag med jämnt datum mellan kl 8-18.
        """)
        
        let sign261 = Signs(text: "Särskilda bestämmelser för stannande och parkering - Datumparkering", correctAnswer: #imageLiteral(resourceName: "t7-5"), signExpl: """
        Tavlan anger en avvikelse från huvudvägmärket som tavlan är uppsatt under.

        I detta fall anger tavlan att det mellan kl 08-18 råder datumparkering.
        """)
        
        let sign262 = Signs(text: "Särskilda bestämmelser för stannande och parkering - Förbud mot att stanna och parkera fordon", correctAnswer: #imageLiteral(resourceName: "t7-6"), signExpl: """
        Tavlan anger en avvikelse från huvudvägmärket som tavlan är uppsatt under.

        I detta fall anger tavlan att det råder stoppförbud mellan kl 08-18.
        """)
    
        let sign263 = Signs(text: "Symboltavla - Personbil", correctAnswer: #imageLiteral(resourceName: "t8-3"), signExpl: """
        Tavlan anger att det märke som tavlan är uppsatt under endast gäller för det fordonsslag eller den trafikantgrupp som anges på tavlan, i detta fall personbil.

        Andra fordonsslag eller trafikantgrupper kan anges på tavlan.
        """)
        
        let sign264 = Signs(text: "Nedsatt syn", correctAnswer: #imageLiteral(resourceName: "t9-1"), signExpl: """
        Tavlan anger att personer med nedsatt syn är vanligt förekommande.

        Tavlan har alltid gul bottenfärg.
        """)
        
        let sign265 = Signs(text: "Nedsatt hörsel", correctAnswer: #imageLiteral(resourceName: "t10-1"), signExpl: """
        Tavlan anger att personer med nedsatt hörsel är vanligt förekommande.

        Tavlan har alltid gul bottenfärg.
        """)
        
        let sign266 = Signs(text: "Utsträckning - Höger & vänster", correctAnswer: #imageLiteral(resourceName: "T11-1"), signExpl: """
        Tavlan anger hur angivelsen på huvudvägmärket sträcker sig.
        I detta fall gäller angivelsen till höger och vänster om tavlan.

        Tavlan har samma bottenfärg och samma färg på bård och tecken som det vägmärke det används under.
        """)
        
        let sign267 = Signs(text: "Utsträckning - Slutar", correctAnswer: #imageLiteral(resourceName: "T11-2"), signExpl: """
        Tavlan anger hur angivelsen på huvudvägmärket sträcker sig.
        I detta fall slutar angivelsen att gälla vid tavlan.

        Tavlan har samma bottenfärg och samma färg på bård och tecken som det vägmärke det används under.
        """)
        
        let sign268 = Signs(text: "Utsträckning av parkering - Vänster", correctAnswer: #imageLiteral(resourceName: "T11-3"), signExpl: """
        Tavlan används under skylten \"Parkering\" (vitt P mot blå bakgrund) för att visa var man får parkera.
        I detta fall får man parkera till vänster om tavlan.
        """)
        
        let sign269 = Signs(text: "Utsträckning av parkering - Höger", correctAnswer: #imageLiteral(resourceName: "T11-5"), signExpl: """
        Tavlan används under skylten \"Parkering\" (vitt P mot blå bakgrund) för att visa var man får parkera.
        I detta fall får man parkera till höger om tavlan.
        """)
        
        let sign270 = Signs(text: "Utsträckning av förbud - Höger & vänster", correctAnswer: #imageLiteral(resourceName: "T11-6"), signExpl: """
        Tavlan anger hur förbudet på huvudvägmärket sträcker sig.
        I detta fall gäller förbudet till höger och vänster om tavlan.
        """)
        
        let sign271 = Signs(text: "Utsträckning av förbud - Framför & bakom", correctAnswer: #imageLiteral(resourceName: "T11-7"), signExpl: """
        Tavlan anger hur förbudet på huvudvägmärket sträcker sig.
        I detta fall gäller förbudet framför och bakom tavlan.
        """)
        
        let sign272 = Signs(text: "Utsräckning av förbud - Slutar", correctAnswer: #imageLiteral(resourceName: "T11-8"), signExpl: """
        Tavlan anger hur förbudet på huvudvägmärket sträcker sig.
        I detta fall slutar förbudet att gälla efter tavlan.
        """)
        
        let sign273 = Signs(text: "Utsträckning av förbud - Vänster", correctAnswer: #imageLiteral(resourceName: "T11-9"), signExpl: """
        Tavlan anger hur förbudet på huvudvägmärket sträcker sig.
        I detta fall gäller förbudet till vänster om tavlan.
        """)
        
        let sign274 = Signs(text: "Utsträckning av förbud - Höger", correctAnswer: #imageLiteral(resourceName: "T11-10"), signExpl: """
        Tavlan anger hur förbudet på huvudvägmärket sträcker sig.
        I detta fall gäller förbudet till höger om tavlan.
        """)
        
        let sign275 = Signs(text: "Riktning - Sväng till höger", correctAnswer: #imageLiteral(resourceName: "t12-1"), signExpl: """
        Tavlan anger riktning till angivelsen på huvudvägmärket. I detta fall gäller angivelsen vid sväng till höger.

        Denna skylt brukar sitta under ett varnings-, förbuds- eller upplysningsmärke och visar riktningen som varningen, förbudet eller upplysningen gäller för.
        
        Skylten har olika färgkombinationer beroende på användningsområde:

        - Varningar och förbud = Gul bakgrund, röd ram, svart tecken
        - Upplysningar = Blå bakgrund, vitt tecken.
        - Upplysningar på motorväg & motortrafikled = Grön bakgrund, vitt tecken
        """)
        
        let sign276 = Signs(text: "Riktning - Rakt fram", correctAnswer: #imageLiteral(resourceName: "t12-3"), signExpl: """
        Tavlan anger riktning till angivelsen på huvudvägmärket. I detta fall gäller angivelsen vid färd rakt fram.

        Denna skylt brukar sitta under ett varnings-, förbuds- eller upplysningsmärke och visar riktningen som varningen, förbudet eller upplysningen gäller för.
        
        Skylten har olika färgkombinationer beroende på användningsområde:

        - Varningar och förbud = Gul bakgrund, röd ram, svart tecken
        - Upplysningar = Blå bakgrund, vitt tecken.
        - Upplysningar på motorväg & motortrafikled = Grön bakgrund, vitt tecken
        """)
        
        let sign277 = Signs(text: "Riktning - Sväng till höger eller vänster", correctAnswer: #imageLiteral(resourceName: "t12-8"), signExpl: """
        Tavlan anger riktning till angivelsen på huvudvägmärket. I detta fall gäller angivelsen vid sväng till höger eller vänster.

        Denna skylt brukar sitta under ett varnings-, förbuds- eller upplysningsmärke och visar riktningen som varningen, förbudet eller upplysningen gäller för.
        
        Skylten har olika färgkombinationer beroende på användningsområde:

        - Varningar och förbud = Gul bakgrund, röd ram, svart tecken
        - Upplysningar = Blå bakgrund, vitt tecken.
        - Upplysningar på motorväg & motortrafikled = Grön bakgrund, vitt tecken
        """)
        
        let sign278 = Signs(text: "Flervägsväjning", correctAnswer: #imageLiteral(resourceName: "t13-1"), signExpl: """
        Tavlan anger att förare på samtliga tillfarter i en korsning har väjningsplikt.

        Det finns ingen lag som reglerar vem som har företräde vid flervägsväjning, ömsesidig hänsyn gäller.
        """)
        
        let sign279 = Signs(text: "Flervägsstopp", correctAnswer: #imageLiteral(resourceName: "t14-1"), signExpl: """
        Tavlan anger att förare på samtliga tillfarter i en korsning har stopplikt.

        Det finns ingen lag som reglerar vem som har företräde vid flervägsstopp, ömsesidig hänsyn gäller.
        """)
        
        let sign280 = Signs(text: "Vägars fortsättning i korsning", correctAnswer: #imageLiteral(resourceName: "t15-2"), signExpl: """
        Tavlan anger en korsning där förare på en väg som anges med smalt streck har väjningsplikt mot fordon på en väg som anges med brett streck.

        Symbolen är anpassad efter förhållandena på platsen och förekommer således i olika utföranden.
        """)
        
        let sign281 = Signs(text: "Avgift", correctAnswer: #imageLiteral(resourceName: "t16-1"), signExpl: """
        Tavlan anger att avgift skall betalas för parkering enligt den taxa som anges på en parkeringsmätare, biljettautomat eller motsvarande och att övriga villkor för parkering som anges där skall iakttas.
        """)
        
        let sign282 = Signs(text: "Parkeringsskiva", correctAnswer: #imageLiteral(resourceName: "t17-1"), signExpl: """
        Tavlan anger att tiden när parkering påbörjas skall anges med en parkeringsskiva eller någon annan anordning.

        Övriga tider gäller fri parkering om inget annat anges på en annan tilläggstavla.
        """)
        
        let sign283 = Signs(text: "Tillåten tid för parkering", correctAnswer: #imageLiteral(resourceName: "t18-1"), signExpl: "Tavlan anger längsta tillåten tid för parkering.")
        
        let sign284 = Signs(text: "Boende", correctAnswer: #imageLiteral(resourceName: "t19-1"), signExpl: """
        Tavlan anger att boende i ett område, med särskilt tillstånd, får parkera enligt särskilda villkor.
        Texten kan vara kompletterad med områdesbeteckning eller motsvarande.
        """)
        
        let sign285 = Signs(text: "Parkeringsbiljett", correctAnswer: #imageLiteral(resourceName: "t20-1"), signExpl: "Tavlan anger att parkering är avgiftsfri men att parkeringsbiljett skall användas vid parkering.")
        
        let sign286 = Signs(text: "Uppställning av fordon - Vertikalt", correctAnswer: #imageLiteral(resourceName: "t21-1"), signExpl: """
        Tavlan anger hur fordon skall ställas upp på en parkeringsplats.
        I detta fall ska fordon ställas vertikalt.

        Tavlan är anpassad efter förhållandena på platsen.
        """)
        
        let sign287 = Signs(text: "Uppställning av fordon - Horisontellt", correctAnswer: #imageLiteral(resourceName: "t21-2"), signExpl: """
        Tavlan anger hur fordon skall ställas upp på en parkeringsplats.
        I detta fall ska fordon ställas horisontellt.

        Tavlan är anpassad efter förhållandena på platsen.
        """)
        
        let sign288 = Signs(text: "Uppställning av fordon - Diagonalt", correctAnswer: #imageLiteral(resourceName: "t21-3"), signExpl: """
        Tavlan anger hur fordon skall ställas upp på en parkeringsplats.
        I detta fall ska fordon ställas diagonalt (snett åt vänster).

        Tavlan är anpassad efter förhållandena på platsen.
        """)
        
        let sign289 = Signs(text: "Text", correctAnswer: #imageLiteral(resourceName: "t22-1"), signExpl: """
        Tavlan ger kompletterande anvisning som inte kan ges med någon annan tilläggstavla eller kombinationer av dessa.
        """)
        
        let sign290 = Signs(text: "Tunnelkategori - B", correctAnswer: #imageLiteral(resourceName: "t23-1"), signExpl: """
        Tavlan används under märke \"Förbud mot trafik med fordon lastat med farligt gods\".

        Bokstaven B, C, D eller E anger tunnelns kategori.
        """)
        
        let sign291 = Signs(text: "Laddplats", correctAnswer: #imageLiteral(resourceName: "t24"), signExpl: """
        Tavlan anger en plats för extern laddning av elektricitet för fordons framdrivning.

        Tavlan används under märke \"Parkering\", och anger att endast fordon med möjlighet till extern laddning av elektricitet för fordonets framdrivning får parkera.
        """)
        
        //        MARK: TRAFIKSIGNALER
        
        let sign292 = Signs(text: "Rött", correctAnswer: #imageLiteral(resourceName: "sig1-1"), signExpl: """
        Rött betyder alltid stopp.

        Fordon får inte passera stopplinjen eller, om sådan saknas, signalen.
        
        Signal med konturpil gäller endast den eller de färdriktningar som anges med pilen.
        """)
        
        let sign293 = Signs(text: "Rött och gult", correctAnswer: #imageLiteral(resourceName: "sig2-1"), signExpl: """
        Rött och gult betyder att signalen strax växlar om till grönt.

        Du ska göra dig beredd på att köra, men du får inte köra innan signalen växlat om till grönt.
        """)
        
        let sign294 = Signs(text: "Grönt", correctAnswer: #imageLiteral(resourceName: "sig3-1"), signExpl: """
        Grönt betyder att du får fortsätta framåt.

        En grön pil innebär att signalen endast gäller den färdriktning som anges med pilen. Du får alltså köra i pilens riktning även om en annan signal visas bredvid.
        """)
        
        let sign295 = Signs(text: "Gult", correctAnswer: #imageLiteral(resourceName: "sig4-1"), signExpl: """
        Gult betyder att signalen strax växlar om till rött.

        Du ska i regel stanna, men om du har hunnit så långt att du inte kan stanna utan fara för dig själv eller andra så ska du fortsätta köra.
        """)
        
        let sign296 = Signs(text: "Blinkande gult", correctAnswer: #imageLiteral(resourceName: "sig5-1"), signExpl: """
        Blinkande gult betyder att trafiksignalerna i korsningen är ur funktion.

        Särskild försiktighet skall iakttas och trafikreglerna är detsamma som om trafiksignalerna hade saknats helt.
        """)
        
        let sign297 = Signs(text: "Röd gubbe", correctAnswer: #imageLiteral(resourceName: "sig6-1"), signExpl: """
        Röd gubbe betyder att det är förbjudet att beträda en körbana, cykelbana eller järnvägs- eller spårvägskorsning.
        Signalen visas tillsammans med ett långsamt pulserande ljud.

        Gående som befinner sig på körbanan eller cykelbanan när signalen slår om till röd signalbild skall fortsätta till andra sidan. Finns en refug eller liknande anordning skall den gående dock stanna där.
        """)
        
        let sign298 = Signs(text: "Grön Gubbe", correctAnswer: #imageLiteral(resourceName: "sig7-1"), signExpl: """
        Grön gubbe betyder att det är tillåtet att beträda körbana, cykelbana, järnvägs- eller spårvägskorsning.
        Signalen visas tillsammans med ett snabbt pulserande ljud.
        """)
        
        let sign299 = Signs(text: "S (stopp)", correctAnswer: #imageLiteral(resourceName: "sig8-1"), signExpl: """
        S betyder Stopp. Fordon och spårvagn får inte passera stopplinjen, eller om sådan saknas, signalen.
        """)
        
        let sign300 = Signs(text: "S (stopp) och vågrätt streck (-)", correctAnswer: #imageLiteral(resourceName: "sig9-1"), signExpl: """
        S och vågrett streck betyder att stopp och att skylten strax växlar om till (|), som betyder kör.

        Detta är en särskild kollektivtrafiksanordning som är avsedd för fordon i linjetrafik.
        Signalerna gäller dock alla som trafikerar körfältet.
        """)
        
        let sign301 = Signs(text: "Lodrätt streck (|)", correctAnswer: #imageLiteral(resourceName: "sig10-1"), signExpl: """
        Lodrätt streck betyder kör.

        Detta är en särskild kollektivtrafiksanordning som är avsedd för fordon i linjetrafik.
        Signalen gäller dock alla som trafikerar körfältet.
        """)
        
        let sign302 = Signs(text: "Vågrätt streck (-)", correctAnswer: #imageLiteral(resourceName: "sig11-1"), signExpl: """
        Vågrätt streck betyder att signalen strax växlar om till S som betyder stopp.

        Du ska i regel stanna, men om du har hunnit så långt att du inte kan stanna utan fara för dig själv eller andra så ska du fortsätta köra.
        
        Detta är en särskild kollektivtrafiksanordning som är avsedd för fordon i linjetrafik.
        Signalen gäller dock alla som trafikerar körfältet.
        """)
        
        let sign303 = Signs(text: "Rött kryss", correctAnswer: #imageLiteral(resourceName: "sig12-1"), signExpl: """
        Rött kryss betyder att körfältet inte får användas för trafik.

        Ljussignalen är en omställningsbar (digital) skylt som förekommer på större vägar och främst på motorvägar med tät trafik.

        I normala fall är dessa skyltar släckta. När de är tända innebär det oftast att någon förändring i trafiken har skett på vägen.
        """)
        
        let sign304 = Signs(text: "Gul pil eller pilar", correctAnswer: #imageLiteral(resourceName: "sig13-1"), signExpl: """
        En/flera gula pilar betyder att du måste byta körfält i den riktningen pilen/pilarna visar.

        Ljussignalen är en omställningsbar (digital) skylt som förekommer på större vägar och främst på motorvägar med tät trafik.

        I normala fall är dessa skyltar släckta. När de är tända innebär det oftast att någon förändring i trafiken har skett på vägen.
        """)
        
        let sign305 = Signs(text: "Grön pil", correctAnswer: #imageLiteral(resourceName: "sig14-1"), signExpl: """
        Grön pil som pekar nedåt betyder att körfältet är öppet för trafik. I stället för grön pil kan ett vägmärke förekomma.

        Ljussignalen är en omställningsbar (digital) skylt som förekommer på större vägar och främst på motorvägar med tät trafik.

        I normala fall är dessa skyltar släckta. När de är tända innebär det oftast att någon förändring i trafiken har skett på vägen.
        """)
        
        let sign306 = Signs(text: "Rött blinkande ljus", correctAnswer: #imageLiteral(resourceName: "sig15-1"), signExpl: """
        Rött blinkande ljus betyder alltid stopp. Man får inte passera stopplinjen eller, om sådan saknas, signalen, även om bommarna inte är nedfällda.

        Om man blir inlåst mellan bommar i en järnvägskorsning ska man omedelbart köra fram, genom bommarna.

        Detta är en särskilt järnvägssignal som finns i vissa plankorsningar med järnväg.
        """)
        
        let sign307 = Signs(text: "Vitt blinkande ljus", correctAnswer: #imageLiteral(resourceName: "sig15-2"), signExpl: """
        Vitt blinkande ljus betyder att man får passera.
        
        Tänk på att själv kontrollera att det inte kommer något tåg innan du åker ut på plankorsningen.

        Om man blir inlåst mellan bommarna i en järnvägskorsning ska man omedelbart köra fram, genom bommarna.

        Detta är en särskilt järnvägssignal som finns i vissa plankorsningar med järnväg.
        """)
        
        let sign308 = Signs(text: "Rött blinkande ljus", correctAnswer: #imageLiteral(resourceName: "sig16-1"), signExpl: """
        Blinkande rött ljus betyder alltid stopp!

        Detta är en specialsignal som används då trafiken av andra skäl än väg- eller järnvägskorsningar måste stanna. Exempel på sådana platser är öppningsbara broar, utfarter för utryckningsfordon och flygfält.
        """)
        
        //        MARK: VÄGMARKERINGAR
        
        let sign309 = Signs(text: "Mittlinje eller körfältslinje", correctAnswer: #imageLiteral(resourceName: "m1-1") , signExpl: """
        Mittlinje anger gränsen mellan körfält avsedda för färd i motsatta färdriktningar.

        Körfältslinje anger gränsen mellan körfält för färd i samma riktning.

        Markeringen har längdförhållandet 1:3 eller 1:1 mellan dellinje och mellanrum. Mittlinje kan även ange en cykelbanas mitt och har då längdförhållandet 1:1 mellan dellinje och mellanrum.
        """)
        
        let sign310 = Signs(text: "Kantlinje", correctAnswer: #imageLiteral(resourceName: "m2-1"), signExpl: "Markeringen anger en körbanas yttre gräns. Markeringen har längdförhållandet 1:2 mellan dellinje och mellanrum.")
        
        let sign311 = Signs(text: "Varningslinje", correctAnswer: #imageLiteral(resourceName: "m3-1"), signExpl: """
        Varningslinje används för att informera om att linjen är olämplig att överskrida på grund av trafikförhållandena.
        
        Markeringen anger gränsen mellan körfält avsedda för färd i motsatta färdriktningar.

        Markeringen kan även användas för att upplysa om en kommande heldragen linje. Markeringen har längdförhållandet 3:1 mellan dellinje och mellanrum.
        """)
        
        let sign312 = Signs(text: "Ledlinje", correctAnswer: #imageLiteral(resourceName: "m4-1"), signExpl: """
        Markeringen anger lämplig färdväg för trafik i komplicerade korsningar.
        Markeringen används även i andra fall där det finns behov av ledning.

        Markeringen har längdförhållandet 1:1 mellan dellinje och mellanrum.
        """)
        
        let sign313 = Signs(text: "Cykelfältslinje", correctAnswer: #imageLiteral(resourceName: "m5-1"), signExpl: "Markeringen anger gränsen mellan ett cykelfält och ett annat körfält. Markeringen har längdförhållandet 1:1 mellan dellinje och mellanrum.")
        
        let sign314 = Signs(text: "Linje för fordon i linjetrafik med flera", correctAnswer: #imageLiteral(resourceName: "m6-1"), signExpl: """
        Markeringen anger gränsen mellan körfält för fordon i linjetrafik m.fl. och ett annat körfält.

        Markeringen har längdförhållandet 1:1 mellan dellinje och mellanrum.
        """)
        
        let sign315 = Signs(text: "Reversibelt körfält", correctAnswer: #imageLiteral(resourceName: "m7-1"), signExpl: """
        Markeringen avgränsar körfält som upplåts för trafik omväxlande i den ena och i den andra färdriktningen.

        Markeringen har längdförhållandet 1:1 mellan dellinje och mellanrum.
        """)
        
        let sign316 = Signs(text: "Heldragen linje", correctAnswer: #imageLiteral(resourceName: "m8-1"), signExpl: """
        Vägmarkeringen talar om att det är förbjudet för trafikanter att med något hjul köra över denna linje, det finns dock vissa undantag.

        Undantag: I följande fall får du med stor försiktighet korsa en heldragen linje:

        - Om det behövs för att komma till eller från en fastighet eller motsvarande.
        - Om det i din färdriktning löper en streckad linje omedelbart till höger om den heldragna linjen.
        - Om det behövs för att du ska kunna passera ett hinder på vägen.
        - Om utrymmet i en korsning annars inte är tillräckligt för din bil.
        """)
        
        let sign317 = Signs(text: "Spärrområde", correctAnswer: #imageLiteral(resourceName: "m9-1"), signExpl: """
        Vägmarkeringen anger ett spärrområde. Det är förbjudet att vistas inom det streckade området.
        
        Markeringen består av vinklade eller snedställda streck beroende på förhållandena på platsen. Oftast finns spärrområden i anslutning till refuger och mittbarriärer.

        Undantag: I följande fall får du med stor försiktighet korsa ett spärrområde:

        - Om det behövs för att komma till eller från en fastighet eller motsvarande.
        - Om det behövs för att du ska kunna passera ett hinder på vägen.
        - Om utrymmet i en korsning annars inte är tillräckligt för din bil.
        """)
        
        let sign318 = Signs(text: "Mittlinje eller körfältslinje och heldragen linje", correctAnswer: #imageLiteral(resourceName: "m10-1"), signExpl: """
        Markeringen används där det inte är tillåtet för fordon som befinner sig på samma sida som den heldragna linjen att byta körfält.

        Undantag: I följande fall får du med stor försiktighet korsa en heldragen linje:

        - Om det behövs för att komma till eller från en fastighet eller motsvarande.
        - Om det i din färdriktning löper en streckad linje omedelbart till höger om den heldragna linjen.
        - Om det behövs för att du ska kunna passera ett hinder på vägen.
        - Om utrymmet i en korsning annars inte är tillräckligt för din bil.

        För trafikanter i den andra körriktningen är det alltså tillåtet då det finns en streckad linje omdelbart till höger om den heldragna linjen.
        """)
        
        let sign319 = Signs(text: "Varningslinje och heldragen linje", correctAnswer: #imageLiteral(resourceName: "m11-1"), signExpl: """
        Markeringen används där det inte är tillåtet för fordon som befinner sig på samma sida som den heldragna linjen att byta körfält.

        Undantag: I följande fall får du med stor försiktighet korsa en heldragen linje:

        - Om det behövs för att komma till eller från en fastighet eller motsvarande.
        - Om det i din färdriktning löper en streckad linje omedelbart till höger om den heldragna linjen.
        - Om det behövs för att du ska kunna passera ett hinder på vägen.
        - Om utrymmet i en korsning annars inte är tillräckligt för din bil.

        För trafikanter i den andra körriktningen är det alltså tillåtet då det finns en streckad linje omdelbart till höger om den heldragna linjen.
        """)
        
        let sign320 = Signs(text: "Mittlinje och varningslinje", correctAnswer: #imageLiteral(resourceName: "m12-1"), signExpl: "Markeringen används där det är olämpligt att överskrida varningslinjen på grund av trafikförhållandena.")
        
        let sign321 = Signs(text: "Stopplinje", correctAnswer: #imageLiteral(resourceName: "m13-1"), signExpl: """
        Markeringen anger var ett fordon ska stannas enligt ett vägmärke eller en trafiksignal.

        Observera att du alltid måste stanna vid stopplikt, även om det inte kommer någon trafik på den korsande vägen.
        """)
        
        let sign322 = Signs(text: "Väjningslinje", correctAnswer: #imageLiteral(resourceName: "m14-1"), signExpl: """
        Markeringen anger den linje som fordon inte bör passera när föraren iakttar väjningsplikt.

        Om det kommer korsande trafik måste du stanna vid väjningslinjen och lämna företräde innan du fortsätter.
        
        Du behöver inte stanna om det inte kommer någon trafik på den korsande vägen.
        """)
        
        let sign323 = Signs(text: "Övergångsställe", correctAnswer: #imageLiteral(resourceName: "m15-1"), signExpl: "Markeringen anger ett övergångsställe och är utförd där märke \"Övergångsställe\" är uppsatt.")
        
        let sign324 = Signs(text: "Cykelpassage eller cykelöverfart", correctAnswer: #imageLiteral(resourceName: "m16-1"), signExpl: """
        Markeringen anger en cykelpassage eller en cykelöverfart där märke \"Cykelöverfart\" är uppsatt.

        Om markeringen avser en cykelöverfart ska den kombineras med markeringen \"Väjningslinje\".
        """)
        
        let sign325 = Signs(text: "Farthinder", correctAnswer: #imageLiteral(resourceName: "m17-1"), signExpl: "Markeringen anger ett farthinder i form av gupp, grop eller liknande. Farthindret finns mellan de två markeringarna.")
        
        let sign326 = Signs(text: "Förberedande upplysning om väjningsplikt eller stopplikt", correctAnswer: #imageLiteral(resourceName: "m18-1"), signExpl: "Markeringen anger att väjningsplikt eller stopplikt gäller längre fram i färdriktningen.")
        
        let sign327 = Signs(text: "Körfältspilar - Rakt fram", correctAnswer: #imageLiteral(resourceName: "m19-2"), signExpl: """
        Markeringen upplyser, för närmaste korsning, lämpligt körfält för fortsatt färd. I detta fall är det rakt fram.

        Är körfältet avgränsat med heldragen körfältslinje ska förare följa den eller de riktningar som pilen visar.

        Markeringen är anpassad efter förhållandena på platsen.
        """)
        
        let sign328 = Signs(text: "Körfältspilar - Höger eller rakt fram", correctAnswer: #imageLiteral(resourceName: "m19-3"), signExpl: """
        Markeringen upplyser, för närmaste korsning, lämpligt körfält för fortsatt färd. I detta fall är det till höger eller rakt fram.

        Är körfältet avgränsat med heldragen körfältslinje ska förare följa den eller de riktningar som pilen visar.

        Markeringen är anpassad efter förhållandena på platsen.
        """)
        
        let sign329 = Signs(text: "Körfältspilar - Höger", correctAnswer: #imageLiteral(resourceName: "m19-4"), signExpl: """
        Markeringen upplyser, för närmaste korsning, lämpligt körfält för fortsatt färd. I detta fall är det till höger.

        Är körfältet avgränsat med heldragen körfältslinje ska förare följa den eller de riktningar som pilen visar.

        Markeringen är anpassad efter förhållandena på platsen.
        """)
        
        let sign330 = Signs(text: "Körfältsbyte", correctAnswer: #imageLiteral(resourceName: "m20-1"), signExpl: "Markeringen anger att körfältsbyte snarast måste ske.")
        
        let sign331 = Signs(text: "Förbud mot att stanna och parkera", correctAnswer: #imageLiteral(resourceName: "m21-1"), signExpl: "Markeringen upplyser om förbud mot att stanna och parkera fordon och är placerad i körbanans kant.")
        
        let sign332 = Signs(text: "Förbud mot att parkera", correctAnswer: #imageLiteral(resourceName: "m22-1"), signExpl: """
        Markeringen upplyser om förbud mot att parkera fordon och är placerad i körbanans kant.
        Markeringen upplyser även om utsträckning av busshållsplats.

        Markeringen har längdförhållandet 1:1 mellan dellinje och mellanrum.
        """)
        
        let sign333 = Signs(text: "Förbud mot att stanna och parkera eller att parkera", correctAnswer: #imageLiteral(resourceName: "m23-1"), signExpl: "Markeringen används som förstärkning av markeringarna \"Förbud mot att stanna och parkera\", och \"Förbud mot att parkera\".")
        
        let sign334 = Signs(text: "Uppställningsplats", correctAnswer: #imageLiteral(resourceName: "m24-1"), signExpl: """
        Markeringen anger gränsen för uppställningsplats för fordon. Markeringen kan vara utförd med bruten linje.

        Kom ihåg att inget hjul på ditt fordon får vara utanför markeringen.
        """)
        
        let sign335 = Signs(text: "Gång- och cykelpil", correctAnswer: #imageLiteral(resourceName: "m25-1"), signExpl: "Markeringen visar lämplig färdväg för gående eller cyklande och förare av moped klass II.")
        
        let sign336 = Signs(text: "Cykel", correctAnswer: #imageLiteral(resourceName: "m26-1"), signExpl: "Markeringen visar bana eller lämplig färdväg för cyklande och förare av moped klass II.")
        
        let sign337 = Signs(text: "Gående", correctAnswer: #imageLiteral(resourceName: "m27-1"), signExpl: "Markeringen visar bana eller lämplig färdväg för gående.")
        
        let sign338 = Signs(text: "Buss", correctAnswer: #imageLiteral(resourceName: "m28-1"), signExpl: "Markeringen visar att körfältet är avsett för fordon i linjetrafik.")
        
        let sign339 = Signs(text: "Hastighet", correctAnswer: #imageLiteral(resourceName: "m29-1"), signExpl: "Markeringen upplyser om högsta tillåtna hastighet.")
        
        let sign340 = Signs(text: "Vägnummer", correctAnswer: #imageLiteral(resourceName: "m30-1"), signExpl: "Markeringen upplyser om vägnummer.")
        
        let sign341 = Signs(text: "Ändamålsplats", correctAnswer: #imageLiteral(resourceName: "m31-1"), signExpl: """
        Markeringen upplyser om en uppställningsplats som är avsedd för ett visst ändamål.

        Texten anpassas efter ändamålet.
        """)
        
        let sign342 = Signs(text: "Stopp", correctAnswer: #imageLiteral(resourceName: "m32-1"), signExpl: "Markeringen upplyser om stopplikt. Markeringen används tillsammans med märke \"Stopplikt\", för att förstärka anvisningen.")
        
        let sign343 = Signs(text: "Rörelsehindrad", correctAnswer: #imageLiteral(resourceName: "m33-1"), signExpl: "Markeringen upplyser om uppställningsplats endast för rörelsehindrade.")
        
        let sign344 = Signs(text: "Information", correctAnswer: #imageLiteral(resourceName: "m34-1"), signExpl: "Markeringen ger upplysning, varning eller vägledning av vikt för trafikanten.")
        
        
        //        MARK: TRAFIKANORDNINGAR
        
        let sign345 = Signs(text: "Markeringspil", correctAnswer: #imageLiteral(resourceName: "x1-1"), signExpl: """
        Anordningen anger att fordonsförare måste svänga kraftigt i den gula pilens eller de gula pilarnas riktning på grund av till exempel en kurva.

        Antalet pilar är anpassat till förhållandena på platsen.

        Om anordningen används vid ett vägarbete eller tillfälligt av någon annan anledning har den röd botten.
        """)
        
        let sign346 = Signs(text: "Markeringsskärm för hinder", correctAnswer: #imageLiteral(resourceName: "x2-1"), signExpl: """
        Anordningen anger att framkomligheten på vägen är inskränkt på grund av ett hinder.
        Anordningen kan även ange att en väg är helt eller delvis avstängd för trafik.

        Antalet gula fält är anpassat till hindret eller till förhållandena på platsen.

        Om anordningen används vid ett vägarbete eller tillfälligt av någon annan anledning har den röd botten.
        """)
        
        let sign347 = Signs(text: "Markeringsskärm för sidohinder, farthinder med mera", correctAnswer: #imageLiteral(resourceName: "x3-2"), signExpl: """
        Anordningen anger vägens eller körbanans kant eller skiljer trafikriktningar åt vid komplicerade passager.
        Anordningen anger även att fordon ska föras på den sida som de gula fälten lutar ned mot.

        Om anordningen används vid ett vägarbete eller tillfälligt av någon annan anledning har den röd botten.
        De gula fälten kan då vara vågräta. Fordonen får då föras på båda sidor om anordningen.
        """)
        
        let sign348 = Signs(text: "Avfartsskärm", correctAnswer: #imageLiteral(resourceName: "x4-1"), signExpl: "Anordningen anger skiljepunkten mellan en huvudkörbana och en avfart.")
        
        let sign349 = Signs(text: "Gul ljuspil eller ljuspilar", correctAnswer: #imageLiteral(resourceName: "x5-1"), signExpl: "Anordningen anger att trafikanter ska passera på den sida pilen eller pilarna visar. Pilen eller pilarna kan vara blinkande.")
        
        let sign350 = Signs(text: "Särskild varningsanordning- Olycka", correctAnswer:#imageLiteral(resourceName: "x6-1"), signExpl: """
        Anordningen anger att framkomligheten på en väg är inskränkt på grund av ett tillfälligt hinder eller liknande. I detta fall pga en olycka.

        Texten på anordningen anpassas till orsaken.
        """)
        
        let sign351 = Signs(text: "Vägbom", correctAnswer: #imageLiteral(resourceName: "x7-1"), signExpl: "Anordningen anger att en väg är helt eller delvis avstängd för trafik. En bom kan vara försedd med ytterligare anordningar för att öka synbarheten.")
        
        let sign352 = Signs(text: "Tillfällig stängning", correctAnswer: #imageLiteral(resourceName: "x8-2"), signExpl: "Anordningen anger att en anvisning genom ett vägmärke om väg till ort, plats, inrättning, anläggning eller liknande tillfälligt inte gäller. Anordningen är anpassad till vägmärket.")
        
        let sign353 = Signs(text: "Cirkulationstrafik", correctAnswer: #imageLiteral(resourceName: "x9-1"), signExpl: "Anordningen anger mittpunkten i en rondell runt vilken fordon ska föras.")
        
        let sign354 = Signs(text: "Stolpmarkeringsanordning", correctAnswer: #imageLiteral(resourceName: "x10"), signExpl: """
        Anordningen används för att det ska vara lättare att upptäcka ett vägmärke eller en annan anordning enligt denna förordning.

        Anordningen är placerad på en stolpe eller motsvarande som bär upp ett vägmärke eller en annan anordning.

        En stolpmarkeringsanordning har normalt sett samma färgsättning som det vägmärke eller den andra anordning som den sitter under.

        Anordningen är anpassad till förhållandena på platsen.
        """)
        
        let sign355 = Signs(text: "Kännetecken", correctAnswer: #imageLiteral(resourceName: "x12-1"), signExpl: "Kännetecken skall bäras både framtill och baktill.")
        
        
        //        MARK: TECKEN AV POLISMAN
        
        let sign356 = Signs(text: "Stopp - Framifrån / Bakifrån", correctAnswer: #imageLiteral(resourceName: "p1-1"), signExpl: """
        Tecknet anger stopp för den trafikant som kommer framifrån eller bakifrån.
        Tecknet används i vägkorsning och gäller så länge polismannen vänder sig åt samma håll.

        För trafikanter som kommer från sidan betyder tecknet att vägen är fri och att det är tillåtet att köra.

        Tecknet kan ges med en stoppspade.

        Av alla tecken, vägmärken & signaler som förekommer i trafiken så kommer en polismans tecken högst upp i rangordningen.
        Det betyder till exempel att om en polis vinkar fram dig i en korsning så ska du köra även om trafikljusen lyser rött.

        Andra yrkesgrupper som har rätt att dirigera trafikanter är:

        - Bilinspektörer
        - Vägtransportledare
        - Tulltjänstemän
        - Trafiknykterhetskontrollanter
        - Parkeringsvakter
        - Vägarbetare med röd flagga
        - Annan person utsedd av myndighet för att dirigera trafiken
        """)
        
        let sign357 = Signs(text: "Stopp - Handflatan vänd mot", correctAnswer: #imageLiteral(resourceName: "p2-1"), signExpl: """
        Tecknet anger stopp för den trafikant som handflatan är vänd mot.
        Tecknet kan ges med en stoppspade.

        Av alla tecken, vägmärken & signaler som förekommer i trafiken så kommer en polismans tecken högst upp i rangordningen.
        Det betyder till exempel att om en polis vinkar fram dig i en korsning så ska du köra även om trafikljusen lyser rött.

        Andra yrkesgrupper som har rätt att dirigera trafikanter är:

        - Bilinspektörer
        - Vägtransportledare
        - Tulltjänstemän
        - Trafiknykterhetskontrollanter
        - Parkeringsvakter
        - Vägarbetare med röd flagga
        - Annan person utsedd av myndighet för att dirigera trafiken
        """)
        
        let sign358 = Signs(text: "Stopp - Lykta", correctAnswer: #imageLiteral(resourceName: "p3-1"), signExpl: """
        Tecknet anger stopp för den trafikant som lyktan är vänd mot. Tecknet används under mörker och vid nedsatt sikt. Lyktan hålls i den position där den lättast uppfattas av trafikanter.

        Av alla tecken, vägmärken & signaler som förekommer i trafiken så kommer en polismans tecken högst upp i rangordningen.
        Det betyder till exempel att om en polis vinkar fram dig i en korsning så ska du köra även om trafikljusen lyser rött.

        Andra yrkesgrupper som har rätt att dirigera trafikanter är:

        - Bilinspektörer
        - Vägtransportledare
        - Tulltjänstemän
        - Trafiknykterhetskontrollanter
        - Parkeringsvakter
        - Vägarbetare med röd flagga
        - Annan person utsedd av myndighet för att dirigera trafiken
        """)
        
        let sign359 = Signs(text: "Kör fram", correctAnswer: #imageLiteral(resourceName: "p4-1"), signExpl: """
        Tecknet anger att trafikanter i den färdriktning som tecknet ges får fortsätta framåt. Tecknet ges med en vinkande rörelse i färdriktningen.

        Av alla tecken, vägmärken & signaler som förekommer i trafiken så kommer en polismans tecken högst upp i rangordningen.
        Det betyder till exempel att om en polis vinkar fram dig i en korsning så ska du köra även om trafikljusen lyser rött.

        Andra yrkesgrupper som har rätt att dirigera trafikanter är:

        - Bilinspektörer
        - Vägtransportledare
        - Tulltjänstemän
        - Trafiknykterhetskontrollanter
        - Parkeringsvakter
        - Vägarbetare med röd flagga
        - Annan person utsedd av myndighet för att dirigera trafiken
        """)
        
        let sign360 = Signs(text: "Minska hastigheten", correctAnswer: #imageLiteral(resourceName: "p5-1"), signExpl: """
        Tecknet anger att den trafikant som polismannen är vänd mot skall minska hastigheten.
        
        Under mörker och vid nedsatt sikt kan tecknet vara förtydligat med en lykta som visar vitt eller gult ljus eller en reflexanordning som återkastar vitt eller gult ljus.

        Av alla tecken, vägmärken & signaler som förekommer i trafiken så kommer en polismans tecken högst upp i rangordningen.
        Det betyder till exempel att om en polis vinkar fram dig i en korsning så ska du köra även om trafikljusen lyser rött.

        Andra yrkesgrupper som har rätt att dirigera trafikanter är:

        - Bilinspektörer
        - Vägtransportledare
        - Tulltjänstemän
        - Trafiknykterhetskontrollanter
        - Parkeringsvakter
        - Vägarbetare med röd flagga
        - Annan person utsedd av myndighet för att dirigera trafiken
        """)
        
        let sign361 = Signs(text: "Kontroll", correctAnswer: #imageLiteral(resourceName: "p6-1"), signExpl: """
        När symbolerna och texten visas skall fordonsförare köra in på kontrollplats för kontroll.

        Visas symboler med visst eller vissa slag av fordon (exempelvis lastbil) gäller skyldigheten att köra in för kontroll endast dessa fordon. Anvisningen är anpassad till förhållandena på platsen.
        """)
        
        let sign362 = Signs(text: "Förberedande upplysning om kontroll", correctAnswer: #imageLiteral(resourceName: "p7-1"), signExpl: """
        Symbolerna och texten visas som förberedande upplysning om kontroll. I detta fall gäller skyldigheten att köra in för kontroll endast för lastbilsförare.

        Det angivna avståndet är anpassat till förhållandena på platsen.
        """)
        
        let sign363 = Signs(text: "Minska hastigheten - Bakomvarande", correctAnswer: #imageLiteral(resourceName: "p8-1"), signExpl: """
        Tecknet anger att de trafikanter som befinner sig bakom polisfordonet skall minska hastigheten.

        Under mörker och vid nedsatt sikt får tecknet förtydligas med en lykta som visar vitt eller gult ljus eller en reflexanordning som återkastar vitt eller gult ljus.

        Av alla tecken, vägmärken & signaler som förekommer i trafiken så kommer en polismans tecken högst upp i rangordningen.
        Det betyder till exempel att om en polis vinkar fram dig i en korsning så ska du köra även om trafikljusen lyser rött.
        """)
        
        let sign364 = Signs(text: "Minska hastigheten - Mötande", correctAnswer: #imageLiteral(resourceName: "p9-1"), signExpl: """
        Tecknet anger att de trafikanter som möter polisfordonet skall minska hastigheten.

        Under mörker och vid nedsatt sikt får tecknet förtydligas med en lykta som visar vitt eller gult ljus eller en reflexanordning som återkastar vitt eller gult ljus.

        Av alla tecken, vägmärken & signaler som förekommer i trafiken så kommer en polismans tecken högst upp i rangordningen.
        Det betyder till exempel att om en polis vinkar fram dig i en korsning så ska du köra även om trafikljusen lyser rött.
        """)
        
        let sign365 = Signs(text: "Stanna bakom polisfordonet när det stannar", correctAnswer: #imageLiteral(resourceName: "p10-1"), signExpl: """
        Tecknet anger att föraren av det fordon som befinner sig bakom polisfordonet skall följa efter det och stanna när polisfordonet stannar.
        Tecknet ges med en utsträckt hand eller med en stoppspade med texten \"STOPP\" eller \"POLIS\".
        """)
        
        let sign366 = Signs(text: "Kör in till vägkanten och stanna framför polisfordonet", correctAnswer: #imageLiteral(resourceName: "p11-1"), signExpl: """
        Tecknet anger att föraren av det fordon som befinner sig framför polisfordonet skall köra in till vägkanten och stanna.
        Tecknet ges med växelvis blinkande blått och rött ljus.
        """)

        
        
        //        MARK: ***** KATEGORIER *****
  
        let Varningsmärken = CatArray(signText: "Varningsmärken", image: #imageLiteral(resourceName: "a1-1"), signs: [sign1, sign2, sign3, sign4, sign5, sign21, sign22, sign6, sign9, sign23, sign24, sign25, sign12, sign26, sign27, sign28, sign29, sign30, sign31, sign32, sign33, sign34, sign35, sign36, sign37, sign38, sign39, sign10, sign11, sign40, sign41, sign42, sign43, sign44, sign7, sign8, sign45, sign46, sign47, sign48])
        
        
        let Väjningsplikt = CatArray(signText: "Väjningsplikt", image: #imageLiteral(resourceName: "b1-1"), signs: [sign13, sign14, sign15, sign16, sign17, sign18, sign19, sign20])
        
        
        let Förbudsmärken = CatArray(signText: "Förbudsmärken", image: #imageLiteral(resourceName: "c1-1"), signs: [sign49, sign50, sign51, sign52, sign53, sign54, sign55, sign56, sign57, sign58, sign59, sign60, sign61, sign62, sign63, sign64, sign65, sign66, sign67, sign68, sign69, sign70, sign71, sign72, sign73, sign74, sign75, sign76, sign77, sign78, sign79, sign80, sign81, sign82, sign83, sign84, sign85, sign86, sign87, sign88, sign89, sign90, sign91, sign92])
        
        
        let Påbudsmärken = CatArray(signText: "Påbudsmärken", image: #imageLiteral(resourceName: "d1-2"), signs: [sign93, sign94, sign95, sign96, sign97, sign98, sign99, sign100, sign101, sign102, sign103, sign104, sign105, sign106, sign107, sign108, sign109, sign110, sign111, sign112, sign113, sign114, sign115, sign116, sign117, sign118])
        
        
        let Anvisningsmärken = CatArray(signText: "Anvisningsmärken", image: #imageLiteral(resourceName: "e1-1"), signs: [sign119, sign120, sign121, sign122, sign123, sign124, sign125, sign126, sign127, sign128, sign129, sign130, sign131, sign132, sign133, sign134, sign135, sign136, sign137, sign138, sign139, sign140, sign141, sign142, sign143, sign144, sign145, sign146, sign147, sign148])
        
        
        let Lokaliseringsmärken = CatArray(signText: "Lokaliseringsmärken", image: #imageLiteral(resourceName: "f14-1"), signs: [sign149, sign150, sign151, sign152, sign153, sign154, sign155, sign156, sign157, sign158, sign159, sign160, sign161, sign162, sign163, sign164, sign165, sign166, sign167, sign168, sign169, sign170, sign171, sign172, sign173, sign174, sign175, sign176, sign177, sign178, sign179, sign180, sign181, sign182, sign183, sign184, sign185, sign186, sign187, sign188, sign189, sign190, sign191, sign192, sign193, sign194, sign195, sign196, sign197, sign198])
        
       
        let Lokaliseringsmärken2 = CatArray(signText: "Lokaliseringsmärken · Gång- & cykeltrafik", image: #imageLiteral(resourceName: "f38-1") , signs: [sign199, sign200, sign201, sign202, sign203])
        
        
        let Lokaliseringsmärken3 = CatArray(signText: "Lokaliseringsmärken - Allmänna", image: #imageLiteral(resourceName: "g8-1"), signs: [sign204, sign205, sign206, sign207, sign208, sign209, sign210, sign211, sign212])
        
       
        let Lokaliseringsmärken4 = CatArray(signText: "Lokaliseringsmärken - Serviceanläggningar", image: #imageLiteral(resourceName: "h1-1"), signs: [sign213, sign214, sign215, sign216, sign217, sign218, sign219, sign220, sign221, sign222, sign223, sign224, sign225, sign226, sign227, sign228, sign229, sign230, sign231, sign232, sign233, sign234, sign235, sign236, sign237, sign238, sign239])
        
        
        let Lokaliseringsmärken5 = CatArray(signText: "Lokaliseringsmärken - Turist", image: #imageLiteral(resourceName: "i1-1"), signs: [sign240, sign241, sign242, sign243])
        
        
        let Upplysningsmärken = CatArray(signText: "Upplysningsmärken", image: #imageLiteral(resourceName: "j2-1"), signs: [sign244, sign245])
        
        
        let Symboler = CatArray(signText: "Symboler", image: #imageLiteral(resourceName: "s1.1"), signs: [sign246, sign247, sign248, sign249])
        
        
        let Tilläggstavlor = CatArray(signText: "Tilläggstavlor", image: #imageLiteral(resourceName: "t9-1"), signs: [sign250, sign251, sign252, sign253, sign254, sign255, sign256, sign257, sign258, sign259, sign260, sign261, sign262, sign263, sign264, sign265, sign266, sign267, sign268, sign269, sign270, sign271, sign272, sign273, sign274, sign275, sign276, sign277, sign278, sign279, sign280, sign281, sign282, sign283, sign284, sign285, sign286, sign287, sign288, sign289, sign290, sign291])
        
        let Trafiksignaler = CatArray(signText: "Trafiksignaler", image: #imageLiteral(resourceName: "sig1-1"), signs: [sign292, sign293, sign294, sign295, sign296, sign297, sign298, sign299, sign300, sign301, sign302, sign303, sign304, sign305, sign306, sign307, sign308])
        
        let Vägmarkeringar = CatArray(signText: "Vägmarkeringar", image: #imageLiteral(resourceName: "m3-1"), signs: [sign309, sign310, sign311, sign312, sign313, sign314, sign315, sign316, sign317, sign318, sign319, sign320, sign321, sign322, sign323, sign324, sign325, sign326, sign327, sign328, sign329, sign330, sign331, sign332, sign333, sign334, sign335, sign336, sign337, sign338, sign339, sign340, sign341, sign342, sign343, sign344])
        
        let Trafikanordningar = CatArray(signText: "Trafikanordningar", image: #imageLiteral(resourceName: "x1-1"), signs: [sign345, sign346, sign347, sign348, sign349, sign350, sign351, sign352, sign353, sign354, sign355])
        
        let PolismansTecken = CatArray(signText: "Tecken av polisman", image: #imageLiteral(resourceName: "p11-1"), signs: [sign356, sign357, sign358, sign359, sign360, sign361, sign362, sign363, sign364, sign365, sign366])
        
        
        return [
                Varningsmärken,
                Väjningsplikt,
                Förbudsmärken,
                Påbudsmärken,
                Anvisningsmärken,
                Lokaliseringsmärken,
                Lokaliseringsmärken2,
                Lokaliseringsmärken3,
                Lokaliseringsmärken4,
                Lokaliseringsmärken5,
                Upplysningsmärken,
                Symboler,
                Tilläggstavlor,
                Trafiksignaler,
                Vägmarkeringar,
                Trafikanordningar,
                PolismansTecken,
                
                ]
        
    }
  
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCategories = concatenatedSearchArray.filter({( sign : Signs) -> Bool in
            return sign.text.lowercased().contains(searchText.lowercased())
        })
        
        searchTable.reloadData()
    }
    
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
//    Last break
}

extension SearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

