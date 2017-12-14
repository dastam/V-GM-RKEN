/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import BulletinBoard

/**
 * A set of tools to interact with the demo data.
 *
 * This demonstrates how to create and configure bulletin items.
 */

let neverShowAgain = UserDefaults.standard.bool(forKey: "neverLaunchAgain")

enum BulletinDataSource {
    
    // MARK: - Pages
    
    /**
     * Create the introduction page.
     *
     * This creates a `FeedbackPageBulletinItem` with: a title, an image, a description text and
     * and action button.
     *
     * The action button presents the next item (the textfield page).
     */
    
    static func makeIntroPage() -> PageBulletinItem {
        
        let page = PageBulletinItem(title: "Svep med fingret")
        page.image = #imageLiteral(resourceName: "swipeDownFInger")
        
        page.descriptionText = """
        - Dra nedåt med fingret för att stänga sidan och gå tillbaka.
        - Dra till vänster/höger för att gå tillbaka respektive till nästa trafikskylt.
        """
        page.actionButtonTitle = "Stäng"
        page.alternativeButtonTitle = "Visa inte detta mer"
        
        page.isDismissable = true
        
        page.actionHandler = { item in
            item.manager?.dismissBulletin(animated: true)
        }
        
        page.alternativeHandler = { item in
            item.manager?.dismissBulletin(animated: true)
            UserDefaults.standard.set(true, forKey: "neverLaunchAgain")
        }
        
        return page
        
    }
}
