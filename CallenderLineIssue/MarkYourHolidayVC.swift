//
//  ViewController.swift
//  CalendarControl
//
//  Created by anoop on 2018-11-21.
//  Copyright © 2018 anoop. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Alamofire
import MBProgressHUD

protocol MarkYourHolidayDelegate {
    func markCallBack()
}

class MarkYourHolidayVC: UIViewController {
    
     @IBOutlet weak var saveDataBtn: UIButton!
        
        @IBOutlet weak var selectStartingDateLbl: UILabel!
        @IBOutlet weak var selectEndingDateLbl: UILabel!
        
        @IBOutlet weak var startLineViewHConst: NSLayoutConstraint!
        @IBOutlet weak var endLineViewHConst: NSLayoutConstraint!
    
    
    @IBOutlet weak var calendarWidthConstraint: NSLayoutConstraint!
    
        
        @IBOutlet weak var startLineView: UIView!
        @IBOutlet weak var endLineView: UIView!
        
        @IBOutlet var calendarView: JTAppleCalendarView!
        
        let testCalendar = Calendar(identifier: .gregorian)
        var firstDate: Date?
        var secondDate: Date?
        
         let dateFormatter = DateFormatter()
         let formatter = DateFormatter()
         
         var selectStartDate = String()
         var selectEndDate = String()
        
         var startMinDt = Date()
         var endMinDt = Date()
         var dateActive = 1
         var markYourHolidayDelegate : MarkYourHolidayDelegate!
        
        var twoDatesAlreadySelected: Bool {
            return firstDate != nil && calendarView.selectedDates.count > 1
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            calendarView.allowsMultipleSelection = true
            calendarView.isRangeSelectionUsed = true
            calendarView.minimumLineSpacing = 0
            calendarView.minimumInteritemSpacing = 0
            
            // calendarView.frame.width
            let width = calendarView.frame.width
            
            let finalW = CGFloat (  Double(width / 8).roundedByPlace(toPlaces: 2) )
            print("finalW", finalW)
           // let flVal = ceilf ( Float(CGFloat(Double(width / 7).roundedByPlace(toPlaces: 2))) )

            calendarView.cellSize = width / 8
            
//            calendarView.visibleSize = CGSize(width: finalW, height: finalW)
//            calendarView.contentSize = CGSize(width: finalW, height: finalW)
            
            
            let widtha = 413
            var cellSizwe = CGFloat(widtha / 7).rounded() // var cellSize = floor(CGFloat(width / 7))
            var newWidth = cellSizwe * 7
            calendarView.cellSize = cellSizwe
            calendarWidthConstraint.constant = newWidth
            
            
            
//            calendarView.cellSize = 59.14
//            calendarWidthConstraint.constant = 59.14 * 7
            
            
            
            calendarView.register(UINib(nibName: "CalendarSectionHeaderView", bundle: Bundle.main),
                                  forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                  withReuseIdentifier: "CalendarSectionHeaderView")
            //self.calendarView.scrollToDate(Date(),animateScroll: false)
            //self.calendarView.scrollToSegment(<#T##destination: SegmentDestination##SegmentDestination#>, triggerScrollToDateDelegate: <#T##Bool#>, animateScroll: <#T##Bool#>, extraAddedOffset: <#T##CGFloat#>, completionHandler: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
            //self.calendarView.selectDates([ Date() ])
        }
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
            
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(true)
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
        
        func configureCell(view: JTAppleCell?, cellState: CellState, date : Date) {
            guard let cell = view as? CalendarCell  else { return }
            cell.dateLabel.text = cellState.text
            handleCellTextColor(cell: cell, cellState: cellState)
            handleCellSelected(cell: cell, cellState: cellState, date: date)
        }
        
        func handleCellTextColor(cell: CalendarCell, cellState: CellState) {
            
            if cellState.dateBelongsTo == .thisMonth {
                cell.dateLabel.textColor = UIColor.black
                
            } else {
                cell.dateLabel.textColor = UIColor.gray
            }
    //        cell.dateLabel.textColor = UIColor.black
        }
        
        func handleCellSelected(cell: CalendarCell, cellState: CellState, date : Date) {
            
            let innerColor = #colorLiteral(red: 0.7569784522, green: 0.9186251163, blue: 0.6101991534, alpha: 1)
            let outerColor = #colorLiteral(red: 0.5128623247, green: 0.8335859179, blue: 0.1512163877, alpha: 1)
            
            if cellState.isSelected {
                cell.selectedView.backgroundColor = outerColor
                cell.dateLabel.textColor = .black
                
                if let fDate = firstDate {
                    
                    if let sDate = secondDate {
                        if fDate == date {
                            cell.selectedView.backgroundColor = outerColor
                        } else {
                            //cell.selectedView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
                        }
                        if sDate == date {
                            cell.selectedView.backgroundColor = outerColor
                        } else {
                            if fDate != date {
                                cell.selectedView.backgroundColor = innerColor
                            }
                        }
                    }
                }
                
            } else {
                cell.dateLabel.textColor = .black
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd"
            let currDt = formatter.string(from: cellState.date)
           
            let formatter22 = DateFormatter()
            formatter22.dateFormat = "dd"
            let dt = formatter.string(from: Date())
            
            let monthF = DateFormatter()
            monthF.dateFormat = "MM"
            let currMDt = monthF.string(from: cellState.date)
            
            let monthF2 = DateFormatter()
            monthF2.dateFormat = "MM"
            let currMDt2 = monthF2.string(from: Date())
            
            if currDt == dt &&  currMDt == currMDt2 {

                if let fDt = firstDate, let lDt = secondDate {
                    if cellState.date.isBetween(fDt, and: lDt) {
                        cell.dateLabel.textColor = .black
                    } else {
                        cell.dateLabel.textColor = #colorLiteral(red: 0.5128623247, green: 0.8335859179, blue: 0.1512163877, alpha: 1)
                    }
                } else {
                    if let _ = firstDate {
                        cell.dateLabel.textColor = .black
                    } else {
                        cell.dateLabel.textColor = #colorLiteral(red: 0.5128623247, green: 0.8335859179, blue: 0.1512163877, alpha: 1)
                    }
                    //cell.dateLabel.textColor = #colorLiteral(red: 0.5128623247, green: 0.8335859179, blue: 0.1512163877, alpha: 1)
                }
            }
            
            cell.selectedView.isHidden = !cellState.isSelected
            
            switch cellState.selectedPosition() {
                case .left:
                    cell.selectedView.layer.cornerRadius = 5
                    cell.selectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
                case .middle:
                    cell.selectedView.layer.cornerRadius = 0
                    cell.selectedView.layer.maskedCorners = []
                case .right:
                    cell.selectedView.layer.cornerRadius = 5
                    cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
                case .full:
                    cell.selectedView.layer.cornerRadius = 5
                    cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
                default: break
            }
        }
    }

    extension MarkYourHolidayVC: JTAppleCalendarViewDataSource {
       
        func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy MM dd"

            let startDate = Date()
            let endDate = formatter.date(from: "2030 01 01")!
            
    
            return ConfigurationParameters(startDate: startDate, endDate: endDate, generateInDates: .off , generateOutDates: .off )
        }
        
    }

    extension MarkYourHolidayVC: JTAppleCalendarViewDelegate {
        func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
            let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
            self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
            return cell
        }
        
        func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
            configureCell(view: cell, cellState: cellState, date: date)
        }
        
        func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateStyle = .medium
            dateFormatter1.timeStyle = .none
            dateFormatter1.dateFormat = "dd-MM-yyyy"
            
            if firstDate != nil {
                
                
                let fFormatter = DateFormatter()
                 fFormatter.dateFormat = "dd"
                 let fDt = Int(fFormatter.string(from: firstDate!))!
                
                
                 // 17
                
                 let sFormatter22 = DateFormatter()
                 sFormatter22.dateFormat = "dd"
                 let sDt = Int(sFormatter22.string(from: date))!
                // 5  10
                
                 
                 // Month --
                
                 let fMFormatter = DateFormatter()
                 fMFormatter.dateFormat = "MM"
                 let fMDt = Int(fMFormatter.string(from: firstDate!))!
                
                 let sMFormatter22 = DateFormatter()
                 sMFormatter22.dateFormat = "MM"
                 let sMDt = Int(sMFormatter22.string(from: date))!
                
                 
                // if secondDate != nil {
                    
                     if sDt < fDt && (fMDt == sMDt ) {
                         print("IFFFF ->  ")
                         let sDateTmp = secondDate
                         firstDate = date
                         startMinDt = firstDate!
                         //secondDate = firstDate
                         selectStartingDateLbl.text = dateFormatter1.string(from: firstDate!)
                         selectStartDate = dateFormatter1.string(from: firstDate!)
                         //endMinDt = firstDate!

                         


                         calendar.selectDates(from: firstDate!, to: secondDate!,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
                    }
                     else if sMDt < fMDt {
                        
                        let tmpFirstDate = firstDate!
                        firstDate = date
                                                startMinDt = firstDate!
                                                
                                                selectStartingDateLbl.text = dateFormatter1.string(from: firstDate!)
                                                selectStartDate = dateFormatter1.string(from: firstDate!)
                        
                        
                                                secondDate = tmpFirstDate
                                                endMinDt = tmpFirstDate
                        
                        
                                                selectEndingDateLbl.text = dateFormatter1.string(from: secondDate!)
                                                selectEndDate = dateFormatter1.string(from: secondDate!)

                                                


                                                calendar.selectDates(from: firstDate!, to: secondDate!,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
                     } else {
                        print("Else ->  ")
//                        let sDateTmp = secondDate
//
//                        secondDate = firstDate
//                        selectEndingDateLbl.text = dateFormatter1.string(from: firstDate!)
//                        selectEndDate = dateFormatter1.string(from: firstDate!)
//                        endMinDt = firstDate!
//
//                        firstDate = sDateTmp
//
//
//                        calendar.selectDates(from: firstDate!, to: secondDate!,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
                        
                        
//                        secondDate = date
//                        selectEndingDateLbl.text = dateFormatter1.string(from: date)
//                        selectEndDate = dateFormatter1.string(from: date)
//                        endMinDt = date
//                        calendar.selectDates(from: firstDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
                        
                        
                                secondDate = date
                                           selectEndingDateLbl.text = dateFormatter1.string(from: date)
                                           selectEndDate = dateFormatter1.string(from: date)
                                           endMinDt = date
                                           calendar.selectDates(from: firstDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
                    }
                     
//                 } else {
//
//                    secondDate = date
//                    selectEndingDateLbl.text = dateFormatter1.string(from: date)
//                    selectEndDate = dateFormatter1.string(from: date)
//                    endMinDt = date
//                    calendar.selectDates(from: firstDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
//                 }
                
            } else {
                selectStartingDateLbl.text = dateFormatter1.string(from: date)
                selectStartDate = dateFormatter1.string(from: date)
                startMinDt = date
                firstDate = date
            }
            configureCell(view: cell, cellState: cellState, date: date)
        }

        func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
            configureCell(view: cell, cellState: cellState, date: date)
        }
        
        func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
            if calendarView.selectedDates.count > 0 {
                if twoDatesAlreadySelected && cellState.selectionType != .programatic || firstDate != nil && date < calendarView.selectedDates[0] {
                    let retval = !calendarView.selectedDates.contains(date)
                    //allClear()
                    
                    //calendarView.deselectDates(from: startMinDt, to: endMinDt, triggerSelectionDelegate: false)
                    
                    return retval
                }
            }
           
            return true
        }
        
        func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
            if twoDatesAlreadySelected && cellState.selectionType != .programatic {
                //allClear()
                return false
            }
            
            return true
        }
        
        func allClear() {
           
//           calendarView.deselect(dates: [startMinDt,endMinDt], triggerSelectionDelegate: false)
            
           
           firstDate = nil
           secondDate = nil
           calendarView.deselectDates(from: startMinDt, to: endMinDt, triggerSelectionDelegate: false)
           selectStartDate = ""
           selectEndDate = ""
           startMinDt = Date()
           endMinDt = Date()
           selectStartingDateLbl.text = "Starting Date"
           selectEndingDateLbl.text = "Ending Date"
           //calendarView.deselectAllDates()
            
        }
        
    }

    extension MarkYourHolidayVC {
        func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
            let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "CalendarSectionHeaderView", for: indexPath)
            header.backgroundColor = .white
            let date = range.start
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM YYYY"
            (header as! CalendarSectionHeaderView).title.textColor = .black
            (header as! CalendarSectionHeaderView).title.text = formatter.string(from: date)
            return header
        }
        // header height (Month and year showing at top)
        func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
            return MonthSize(defaultSize: 40)
        }
    }

    extension MarkYourHolidayVC {
        @IBAction func clear( _ sender : UIButton!) {
            allClear()
        }
        @IBAction func close( _ sender : UIButton!) {
            self.navigationController?.popViewController(animated: true)
        }
        
        @IBAction func saveDataAction( _ sender : UIButton! ) {
            
        }
    }


    extension MarkYourHolidayVC {
        
        func addHoliday() {
            
            
            
        }
    }

extension Double {
    /// Rounds the double to decimal places value
    func roundedByPlace(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension Date {
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}
