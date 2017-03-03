//
//  NewsShowWorker.swift
//  OmnieCommerce
//
//  Created by msm72 on 09.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

class NewsShowWorker {
    // MARK: - Custom Functions. Business Logic
    func newsDidLoad() -> [News] {
        var items   =   [News]()
        
        guard arc4random_uniform(2) == 1 else {
            return items
        }
        
        for _ in 0 ..< 25 {
            let pathString = (arc4random_uniform(2) == 1) ? "http://www.nyhabitat.com/blog/wp-content/uploads/2013/08/fifth-avenue-shopping-manhattan-nyc-new-york.jpg" : nil
            
            items.append(News(title: "Сауна Акваторія", logoStringURL: pathString, activeDate: Date.init(), description: "Вже давно відомо, що читабельний зміст буде заважати зосередитись людині, яка оцінює... композицію сторінки. Сенс використання Lorem Ipsum полягає в тому, що цей текст має більш-менш нормальне розподілення літер на відміну від, наприклад, \"Тут іде текст. Тут іде текст.\" Це робить текст схожим на оповідний. Багато програм верстування та веб-дизайну використовують Lorem Ipsum як зразок і пошук за терміном \"lorem ipsum\" відкриє багато веб-сайтів, які знаходяться ще в зародковому стані. Різні версії Lorem Ipsum з'явились за минулі роки, деякі випадково, деякі було створено зумисно (зокрема, жартівливі)."))
        }

        return items
    }
}
