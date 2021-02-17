//
//  CalendarCell.swift
//  CalendarControl
//
//  Created by anoop on 2018-11-22.
//  Copyright © 2018 anoop. All rights reserved.
//

import UIKit
import JTAppleCalendar
class CalendarCell: JTAppleCell {
    
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var selectedView:UIView! {
        didSet {
           // selectedView.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var bgView:UIView!
}
