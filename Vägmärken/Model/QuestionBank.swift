//
//  QuestionBank.swift
//  Vägmärken
//
//  Created by Arman Dadmand on 2017-10-22.
//  Copyright © 2017 Arman Dadmand. All rights reserved.
//

import Foundation
import UIKit

// Creates a func called shuffle, which allows the array of questions to be shuffled.
// The func is called twice in the viewController.swift file.


//class QuestionBank {
//
//
//    var list = [Question]()
//
//    init() {
//
//
//
//        // Creating a quiz item and appending it to the list
//        let item = Question(text: "Varning för farlig kurva", optionA: "a1-1" , optionB: "a5-2" , optionC: "a4-1", optionD: "a2-1" , correctAnswer: "1", correctImageName: "a1-1")
//
//        // Add the Question to the list of questions
//        list.append(item)
//
//        // skipping one step and just creating the quiz item inside the append function
//
//
////      *****  VARNINGSMÄRKEN 12 frågor *****
//
//        list.append(Question(text: "Varning för flera farliga kurvor", optionA: "a10-1", optionB: "a2-1", optionC: "a1-1", optionD: "a5-2", correctAnswer: "2", correctImageName: "a2-1"))
//        list.append(Question(text: "Varning för nedförslutning", optionA: "a27-1", optionB: "a3-1", optionC: "a4-1", optionD: "a40-1", correctAnswer: "2", correctImageName: "a3-1"))
//        list.append(Question(text: "Varning för stigning", optionA: "a4-1", optionB: "a3-1", optionC: "a40-1", optionD: "a27-1", correctAnswer: "1", correctImageName: "a4-1"))
//        list.append((Question(text: "Varning för avsmalnande väg", optionA: "a29-1", optionB: "a2-1", optionC: "a10-1", optionD: "a5-2", correctAnswer: "4", correctImageName: "a5-2")))
//        list.append((Question(text: "Varning för ojämn väg", optionA: "a9-1", optionB: "a10-1", optionC: "a8-1", optionD: "a27-1", correctAnswer: "3", correctImageName: "a8-1")))
//        list.append((Question(text: "Varning för järnvägskorsning med bommar", optionA: "a35-1", optionB: "a36-1", optionC: "a39-1", optionD: "a37-1", correctAnswer: "1", correctImageName: "a35-1")))
//        list.append((Question(text: "Varning för järnvägskorsning utan bommar", optionA: "a39-1", optionB: "a37-1", optionC: "a35-1", optionD: "a36-1", correctAnswer: "4", correctImageName: "a36-1")))
//        list.append((Question(text: "Varning för farthinder", optionA: "a40-1", optionB: "a8-1", optionC: "a28-1", optionD: "a9-1", correctAnswer: "4", correctImageName: "a9-1")))
//        list.append(Question(text: "Varning för vägkorsning", optionA: "a28-1", optionB: "a29-1", optionC: "a40-1", optionD: "a39-1", correctAnswer: "1", correctImageName: "a28-1"))
//        list.append((Question(text: "Varning för vägkorsning där trafikanter på anslutande väg har väjningsplikt / stopplikt", optionA: "a28-1", optionB: "a40-1", optionC: "a29-1", optionD: "a30-1", correctAnswer: "3", correctImageName: "a29-1")))
//        list.append(Question(text: "Varning för övergångsställe", optionA: "b3-1", optionB: "a14", optionC: "a13-1", optionD: "b8-1", correctAnswer: "3", correctImageName: "a13-1"))
////
//////       ***** VÄJNINGSPLIKT *****
////
//        list.append(Question(text: "Väjningsplikt", optionA: "b2-1", optionB: "b4-1", optionC: "b1-1", optionD: "a40-1", correctAnswer: "3", correctImageName: "b1-1"))
//        list.append(Question(text: "Övergångsställe", optionA: "a13-1", optionB: "b8-1", optionC: "a14", optionD: "b3-1", correctAnswer: "4", correctImageName: "b3-1"))
//        list.append(Question(text: "Huvudled", optionA: "b4-1", optionB: "b5-1", optionC: "b1-1", optionD: "a40-1", correctAnswer: "1", correctImageName: "b4-1"))
//        list.append(Question(text: "Huvudled upphör", optionA: "b1-1", optionB: "b2-1", optionC: "b4-1", optionD: "b5-1", correctAnswer: "4", correctImageName: "b5-1"))
//        list.append(Question(text: "Stopplikt", optionA: "b1-1", optionB: "b2-1", optionC: "c2-1", optionD: "c1-1", correctAnswer: "2", correctImageName: "b2-1"))
//        list.append(Question(text: "Väjningsplikt mot mötande trafik", optionA: "b7-1", optionB: "a25-1", optionC: "b6-1", optionD: "c27-1", correctAnswer: "3", correctImageName: "b6-1"))
//        list.append(Question(text: "Mötande trafik har väjningsplikt", optionA: "b7-1", optionB: "c27-1", optionC: "b6-1", optionD: "a25-1", correctAnswer: "1", correctImageName: "b7-1"))
//        list.append(Question(text: "Cykelöverfart", optionA: "a16-1", optionB: "c10-1", optionC: "b8-1", optionD: "d4-1", correctAnswer: "3", correctImageName: "b8-1"))
////
////       ***** FÖRBUDSMÄRKEN *****
//
//        list.append(Question(text: "Förbud mot infart med fordon", optionA: "c2-1", optionB: "c4-1", optionC: "c1-1", optionD: "c3-1", correctAnswer: "3", correctImageName: "c1-1"))
//
//        list.append(Question(text: "Förbud mot trafik med fordon", optionA: "c3-1", optionB: "c2-1", optionC: "c1-1", optionD: "b2-1", correctAnswer: "2", correctImageName: "c2-1"))
//
//        list.append(Question(text: "Förbud mot trafik med annat motordrivet fordon än moped klass II", optionA: "c3-1", optionB: "c4-1", optionC: "c5-1", optionD: "c1-1", correctAnswer: "1", correctImageName: "c3-1"))
//
//        list.append(Question(text: "Förbud mot trafik med motordrivet fordon med fler än två hjul", optionA: "c5-1", optionB: "c3-1", optionC: "c4-1", optionD: "c2-1", correctAnswer: "3", correctImageName: "c4-1"))
//
//        list.append(Question(text: "Förbud mot trafik med motorcykel och moped klass I", optionA: "c2-1", optionB: "c1-1", optionC: "c3-1", optionD: "c5-1", correctAnswer: "4", correctImageName: "c5-1"))
//
//        list.append(Question(text: "Förbud mot trafik med motordrivet fordon med tillkopplad släpvagn", optionA: "c7-1", optionB: "c9-1", optionC: "c6-1", optionD: "c22-2", correctAnswer: "3", correctImageName: "c6-1"))
//
//        list.append(Question(text: "Förbud mot trafik med tung lastbil", optionA: "c7-1", optionB: "c6-1", optionC: "c9-1", optionD: "c21-1", correctAnswer: "1", correctImageName: "c7-1"))
//
//        list.append(Question(text: "Förbud mot trafik med fordon lastat med farligt gods", optionA: "c22-2", optionB: "c9-1", optionC: "c39-1", optionD: "c21-1", correctAnswer: "2", correctImageName: "c9-1"))
//
//        list.append(Question(text: "Förbud mot trafik med cykel och moped klass II", optionA: "c11-1", optionB: "b8-1", optionC: "c10-1", optionD: "a16-1", correctAnswer: "3", correctImageName: "c10-1"))
//
//        list.append(Question(text: "Förbud mot trafik med moped klass II", optionA: "b8-1", optionB: "c10-1", optionC: "c2-1", optionD: "c11-1", correctAnswer: "4", correctImageName: "c11-1"))
//
//        list.append(Question(text: "Förbud mot trafik med fordon förspänt med dragdjur", optionA: "c12-1", optionB: "c14-1", optionC: "a32-1", optionD: "a31-1", correctAnswer: "1", correctImageName: "c12-1"))
//
//        list.append(Question(text: "Förbud mot trafik med terrängmotorfordon och terrängsläp", optionA: "c8-1", optionB: "c44-1", optionC: "a31-1", optionD: "c13-1", correctAnswer: "4", correctImageName: "c13-1"))
//
//        list.append(Question(text: "Förbud mot ridning", optionA: "a32-1", optionB: "c12-1", optionC: "c14-1", optionD: "a18-1", correctAnswer: "3", correctImageName: "c14-1"))
//
//        list.append(Question(text: "Förbud mot gångtrafik", optionA: "c15-1", optionB: "a13-1", optionC: "a14", optionD: "a15-1", correctAnswer:
//            "1", correctImageName: "c15-1"))
//
//        list.append(Question(text: "Begränsad fordonsbredd", optionA: "c17-1", optionB: "c18-1", optionC: "c19-1", optionD: "c16-1", correctAnswer: "4", correctImageName: "c16-1"))
//
//        list.append(Question(text: "Begränsad fordonshöjd", optionA: "c18-1", optionB: "c17-1", optionC: "c19-1", optionD: "c16-1", correctAnswer: "2", correctImageName: "c17-1"))
//
//        list.append(Question(text: "Begränsad fordonslängd", optionA: "c19-1", optionB: "c18-1", optionC: "c16-1", optionD: "c17-1", correctAnswer: "2", correctImageName: "c18-1"))
//
//        list.append(Question(text: "Minsta avstånd", optionA: "c16-1", optionB: "c17-1", optionC: "c19-1", optionD: "c18-1", correctAnswer: "3", correctImageName: "c19-1"))
//
//        list.append(Question(text: "Begränsad bruttovikt på fordon", optionA: "c21-1", optionB: "c22-2", optionC: "c24-1", optionD: "c20-1",
//            correctAnswer: "4", correctImageName: "c20-1"))
//
//        list.append(Question(text: "Begränsad bruttovikt på fordon och fordonståg", optionA: "c24-1", optionB: "c20-1", optionC: "c21-1", optionD: "c23-1", correctAnswer: "3", correctImageName: "c21-1"))
//
//        list.append(Question(text: "Bärighetsklass", optionA: "c22-2", optionB: "c24-1", optionC: "c23-1", optionD: "c21-1", correctAnswer: "1", correctImageName: "c22-2"))
//
//        list.append(Question(text: "Begränsat axeltryck", optionA: "c24-1", optionB: "c22-2", optionC: "c20-1", optionD: "c23-1", correctAnswer: "4", correctImageName: "c23-1"))
//
//        list.append(Question(text: "Begränsat boggitryck", optionA: "c23-1", optionB: "c24-1", optionC: "c20-1", optionD: "c21-1", correctAnswer: "2", correctImageName: "c24-1"))
//
//        list.append(Question(text: "Förbud mot sväng i korsning", optionA: "c26-1", optionB: "c25-1", optionC: "a1-1", optionD: "c1-1", correctAnswer: "2", correctImageName: "c25-1"))
//
//        list.append(Question(text: "Förbud mot U-sväng", optionA: "c25-1", optionB: "a1-1", optionC: "c26-1", optionD: "c2-1", correctAnswer: "3", correctImageName: "c26-1"))
//
//        list.append(Question(text: "Förbud mot omkörning", optionA: "c29-1", optionB: "c28-1", optionC: "c27-1", optionD: "a34-1", correctAnswer: "3", correctImageName: "c27-1"))
//
//        list.append(Question(text: "Slut på förbud mot omkörning", optionA: "c30-1", optionB: "c29-1", optionC: "c27-1", optionD: "c28-1", correctAnswer: "4", correctImageName: "c28-1"))
//
//        list.append(Question(text: "Förbud mot omkörning med tung lastbil", optionA: "c29-1", optionB: "c6-1", optionC: "c30-1", optionD: "c7-1", correctAnswer: "1", correctImageName: "c29-1"))
//
//        list.append(Question(text: "Slut på förbud mot omkörning med tung lastbil", optionA: "c29-1", optionB: "c30-1", optionC: "c28-1", optionD: "c27-1", correctAnswer: "2", correctImageName: "c30-1"))
//
//        list.append(Question(text: "Tillfällig hastighetsbegränsning upphör", optionA: "e12-1", optionB: "e14-1", optionC: "c32-3", optionD: "c31-8", correctAnswer: "3", correctImageName: "c32-3"))
//
//        list.append(Question(text: "Stopp för angivet ändamål", optionA: "c1-1", optionB: "c2-1", optionC: "b2-1", optionD: "c34-1", correctAnswer: "4", correctImageName: "c34-1"))
//
//        list.append(Question(text: "Förbud mot att parkera fordon", optionA: "c35-1", optionB: "c38-1", optionC: "c39-1", optionD: "c37-1", correctAnswer: "1", correctImageName: "c35-1"))
//
//        list.append(Question(text: "Förbud mot att parkera fordon på dag med udda datum", optionA: "c38-1", optionB: "c39-1", optionC: "c37-1", optionD: "c36-1", correctAnswer: "4", correctImageName: "c36-1"))
//
//        list.append(Question(text: "Förbud mot att parkera fordon på dag med jämnt datum", optionA: "c39-1", optionB: "c38-1", optionC: "c37-1", optionD: "c36-1", correctAnswer: "3", correctImageName: "c37-1"))
//
//
//        list.append(Question(text: "Datumparkering", optionA: "c39-1", optionB: "c38-1", optionC: "c37-1", optionD: "c36-1", correctAnswer: "2", correctImageName: "c38-1"))
//
//        list.append(Question(text: "Förbud mot att stanna och parkera fordon", optionA: "c39-1", optionB: "c42-1", optionC: "c35-1", optionD: "c38-1", correctAnswer: "1", correctImageName: "c39-1"))
//
//        list.append(Question(text: "Ändamålsplats", optionA: "c42-1", optionB: "c40-1", optionC: "c34-1", optionD: "c33-1", correctAnswer: "2", correctImageName: "c40-1"))
//
//        list.append(Question(text: "Slut på ändamålsplats", optionA: "c41-1", optionB: "c28-1", optionC: "c30-1", optionD: "c43-1", correctAnswer: "1", correctImageName: "c41-1"))
//
////        ***** PÅBUDSMÄRKEN *****
//
//        list.append(Question(text: "Påbjuden körriktning", optionA: "d2-1", optionB: "x1-1", optionC: "d1-1", optionD: "e16-1", correctAnswer: "3", correctImageName: "d1-1"))
//
//        list.append(Question(text: "Påbjuden körbana", optionA: "d1-1", optionB: "d2-1", optionC: "e16-1", optionD: "x1-1", correctAnswer: "2", correctImageName: "d2-1"))
//
//        list.append(Question(text: "Påbjuden cykelbana", optionA: "b8-1", optionB: "a16-1", optionC: "c10-1", optionD: "d4-1", correctAnswer: "4", correctImageName: "d4-1"))
//
//        list.append(Question(text: "Påbjuden gångbana", optionA: "d5-1", optionB: "b3-1", optionC: "a14", optionD: "a13-1", correctAnswer: "1", correctImageName: "d5-1"))
//
//        list.append(Question(text: "Påbjuden gång- och cykelbana", optionA: "e9-1", optionB: "d6-1", optionC: "c10-1", optionD: "c15-1", correctAnswer: "2", correctImageName: "d6-1"))
//
//        list.append(Question(text: "Påbjuden ridväg", optionA: "a18-1", optionB: "c14-1", optionC: "a32-1", optionD: "d8-1", correctAnswer: "4", correctImageName: "d8-1"))
//
//        list.append(Question(text: "Påbjuden led för terrängmotorfordon och terrängsläp", optionA: "d9-1", optionB: "a33-1", optionC: "a32-1", optionD: "a31-1", correctAnswer: "1", correctImageName: "d9-1"))
//
//        list.append(Question(text: "Påbjudet körfält eller körbana för fordon i linjetrafik m.fl.", optionA: "e22-1", optionB: "e23-1", optionC: "d10-1", optionD: "b7-1", correctAnswer: "3", correctImageName: "d10-1"))
//
//        list.append(Question(text: "Slut på påbjuden bana, körfält, väg eller led", optionA: "c28-1", optionB: "c43-1", optionC: "d11-1", optionD: "e6-1", correctAnswer: "3", correctImageName: "d-11"))
//
//        list.append(Question(text: "Motorväg", optionA: "e3-1", optionB: "f14-1", optionC: "e1-1", optionD: "b4-1", correctAnswer: "3", correctImageName: "e1-1"))
//
//        list.append(Question(text: "Motorväg upphör", optionA: "e4-1", optionB: "e6-1", optionC: "f27-1", optionD: "e2-1", correctAnswer: "4", correctImageName: "e2-1"))
//
//        list.append(Question(text: "Motortrafikled", optionA: "e3-1", optionB: "e5-1", optionC: "e1-1", optionD: "e18-1", correctAnswer: "1", correctImageName: "e3-1"))
//
//        list.append(Question(text: "Tättbebyggt område", optionA: "e9-1", optionB: "e7-1", optionC: "f30-1", optionD: "e5-1", correctAnswer: "4", correctImageName: "e5-1"))
//
//        list.append(Question(text: "Tättbebyggt område upphör", optionA: "e6-1", optionB: "e8-1", optionC: "e12-1", optionD: "e10-1", correctAnswer: "1", correctImageName: "e6-1"))
//
//        list.append(Question(text: "Gågata", optionA: "e9-1", optionB: "a15-1", optionC: "a14", optionD: "e7-1", correctAnswer: "4", correctImageName: "e7-1"))
//
//        list.append(Question(text: "Gågata upphör", optionA: "e10-1", optionB: "c15-1", optionC: "e8-1", optionD: "d11-3", correctAnswer: "3", correctImageName: "e8-1"))
//
//        list.append(Question(text: "Gångfartsområde", optionA: "e9-1", optionB: "e7-1", optionC: "e5-1", optionD: "d5-1", correctAnswer: "1", correctImageName: "e9-1"))
//
//        list.append(Question(text: "Gångfartsområde upphör", optionA: "e8-1", optionB: "e6-1", optionC: "e12-1", optionD: "e10-1", correctAnswer: "4", correctImageName: "e10-1"))
//
//        list.append(Question(text: "Rekommenderad lägre hastighet", optionA: "e13-1", optionB: "e11-1", optionC: "e9-1", optionD: "c31-3", correctAnswer: "2", correctImageName: "e11-1"))
//
//        list.append(Question(text: "Rekommenderad lägre hastighet upphör", optionA: "e10-1", optionB: "e14-1", optionC: "e12-1", optionD: "e8-1", correctAnswer: "3", correctImageName: "e12-1"))
//
//        list.append(Question(text: "Rekommenderad högsta hastighet", optionA: "c31-8", optionB: "e11-1", optionC: "e13-1", optionD: "e9-1", correctAnswer: "3", correctImageName: "e13-1"))
//
//        list.append(Question(text: "Rekommenderad högsta hastighet upphör", optionA: "e12-1", optionB: "e14-1", optionC: "e10-1", optionD: "c31-8", correctAnswer: "2", correctImageName: "e14-1"))
//
//        list.append(Question(text: "Sammanvävning", optionA: "e15-1", optionB: "f17-1", optionC: "f19-1", optionD: "f25-1", correctAnswer: "1", correctImageName: "e15-1"))
//
//    }
//
//}

