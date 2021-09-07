//
//  DatePickerUIView.swift
//  asm3
//
//  Created by Guest User on 7/24/21.
//  Copyright © 2021 Guest. All rights reserved.
//

import UIKit

final class DatePickerUIView : UIViewController {
    
    private static let DATE_CHOSEN = "Date Chosen: "
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var confirmDateBtn: UIButton!
    @IBOutlet weak var chosenDateLabel: UILabel!

    private var date: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dates = DateUtil.getSingletonInstance().formDateFromString(string: self.date)
        self.datePicker.setDate(dates, animated:true)
        self.chosenDateLabel.text = DatePickerUIView.DATE_CHOSEN + self.date
        self.chosenDateLabel.textAlignment = .center
        self.confirmDateBtn.layer.cornerRadius = 5.0;
    }

    @IBAction func chooseDate(_ sender: UIDatePicker) {
        let dateTxt = DatePickerUIView.DATE_CHOSEN + DateUtil.getSingletonInstance().formStringFromDate(date: datePicker.date)
        self.chosenDateLabel.text = dateTxt
    }
    
    @IBAction func confirmDateBtn(_ sender: UIButton) {

        let firstVC = presentingViewController as! ViewController

        firstVC.pickADate.text = DateUtil.getSingletonInstance().formStringFromDate(date: datePicker.date)

        self.dismiss(animated: true, completion: nil)
    }
    
    public func updateDate(date: String) -> Void {
        self.date = date
    }
}
