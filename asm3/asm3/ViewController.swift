//
//  ViewController.swift
//  asm3
//
//  Created by Guest User on 7/24/21.
//  Copyright © 2021 Guest. All rights reserved.
//

import UIKit

final class ViewController: UIViewController, UITextViewDelegate {
    
    private static let DEFAULT_TEXT_VIEW_TEXT = "What is on your mind?"
    
    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var pickADate: UILabel!

    @IBOutlet weak var pickEmojiBtn: UIButton!
    @IBOutlet weak var pickDateBtn: UIButton!
    @IBOutlet weak var thoughtTextArea: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.emojiLabel.text = EmojiUIView.DEFAULT_EMOJI_TEXT

        self.pickEmojiBtn.layer.cornerRadius = 5.0
        self.pickDateBtn.layer.cornerRadius = 5.0
        self.saveBtn.layer.cornerRadius = 5.0
        
        self.thoughtTextArea.delegate = self
        self.thoughtTextArea.layer.cornerRadius = 10.0
        self.thoughtTextArea.text = ViewController.DEFAULT_TEXT_VIEW_TEXT
        self.thoughtTextArea.textColor = UIColor.lightGray
        
        
        self.pickADate.text = DateUtil.getSingletonInstance().formStringFromDate(date: Date())
        
    }
    
    private func showSavedAlertDialog() {
        let alertController = UIAlertController(title: "Journal Saved", message: "Your thoughts and emotion at date: \(self.pickADate.text!) is saved!", preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        self.thoughtTextArea.resignFirstResponder()
        self.showSavedAlertDialog()
    }
    
    internal func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    internal func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = ViewController.DEFAULT_TEXT_VIEW_TEXT
            textView.textColor = UIColor.lightGray
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "emoticonIdentifier") {
            let emojiVC = segue.destination as! EmojiUIView
            emojiVC.updateEmoji(emojiText: self.emojiLabel.text!)
            
        } else if (segue.identifier == "dataPickerIdentifier") {
            let datePickerVC = segue.destination as! DatePickerUIView
            datePickerVC.updateDate(date: self.pickADate.text!)
        }
    }
}

final class DateUtil {
    
    private static let dateUtil = DateUtil()
    
    private let dateFormatter: DateFormatter
    
    private init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
    }
    
    public func formStringFromDate(date: Date) -> String {
        return self.dateFormatter.string(from: date)
    }
    
    public func formDateFromString(string: String) -> Date {
        return self.dateFormatter.date(from: string)!
    }
    
    public static func getSingletonInstance() -> DateUtil {
        return DateUtil.dateUtil
    }
}
