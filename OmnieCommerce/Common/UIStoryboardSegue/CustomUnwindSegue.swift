//
//  CustomUnwindSegue.swift
//  OmnieCommerce
//
//  Created by msm72 on 20.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

class CustomUnwindSegue: UIStoryboardSegue {
    override func perform() {
        let sourceView = (self.source as! SchedulerViewController).schedulerView!
        sourceView.backgroundColor = UIColor.red
        
        let destinationView = (UIStoryboard.init(name: "CalendarShow", bundle: nil).instantiateViewController(withIdentifier: "SchedulerVC") as! SchedulerViewController).schedulerView!
        destinationView.backgroundColor = UIColor.orange

        destinationView.frame = CGRect.init(origin: CGPoint.init(x: (self.identifier! == "NextUnwindSegue") ? sourceView.frame.width + 100 : -sourceView.frame.width - 100, y: sourceView.frame.minY), size: sourceView.frame.size)
        
        sourceView.addSubview(destinationView)
        
        UIView.animate(withDuration: 1.7, animations: {
            sourceView.frame = CGRect.init(origin: CGPoint.init(x: (self.identifier! == "NextUnwindSegue") ? -sourceView.frame.width - 100 : sourceView.frame.width + 100, y: sourceView.frame.minY), size: sourceView.frame.size)
            destinationView.frame = CGRect.init(origin: CGPoint.init(x: 0, y: sourceView.frame.minY), size: sourceView.frame.size)
        }, completion: nil )
    }
}
