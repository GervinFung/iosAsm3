//
//  EmojiUIView.swift
//  asm3
//
//  Created by Guest User on 7/24/21.
//  Copyright © 2021 Guest. All rights reserved.
//

import UIKit

final class EmojiUIView : UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    public static let DEFAULT_EMOJI_TEXT = "How do you feel?"
    
    private static let CELL_IDENTIFIER: String = "cell"
    private static let IMMUTABLE_EMOTIONS_COLLECTION: Array<String> = EmojiUIView.readPropertyList()
    
    private var emojiText: String = ""
    private var filteredEmotionCollection: Array<String> = EmojiUIView.IMMUTABLE_EMOTIONS_COLLECTION;
    
    @IBOutlet weak var emojiTableView: UITableView!
    @IBOutlet weak var emojiSearchBar: UISearchBar!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var confirmEmojiBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emojiTableView.dataSource = self
        self.emojiTableView.delegate = self
        self.emojiSearchBar.delegate = self
        
        self.emojiTableView.register(UITableViewCell.self, forCellReuseIdentifier: EmojiUIView.CELL_IDENTIFIER)
        
        self.emojiLabel.text = self.emojiText
        self.emojiLabel.textAlignment = .center
        self.confirmEmojiBtn.layer.cornerRadius = 5.0;
    }
    
    
    @IBAction func confirmEmojiBtn(_ sender: UIButton) {
        let firstVC = presentingViewController as! ViewController
        
        firstVC.emojiLabel.text = self.emojiText
        
        self.dismiss(animated: true, completion: nil)
    }
    
    public func updateEmoji(emojiText: String) {
        self.emojiText = emojiText
    }
    
    private static func readPropertyList() -> Array<String> {
        if let filePath = Bundle.main.path(forResource: "emoticonsPList", ofType: "plist") {
            if let plistData = FileManager.default.contents( atPath: filePath) {
                do {
                    let plistObject = try PropertyListSerialization.propertyList(from: plistData, options: PropertyListSerialization.ReadOptions(), format: nil)
                    let emotionsInList = plistObject as? Array<String>
                    if let emotionsInList = emotionsInList {
                        return emotionsInList
                    }
                } catch {
                    print("Error serializing data from property list")
                }
            } else {
                print("Error reading data from property list file")
            }
        } else {
            print("Property list file does not exist")
        }
        return []
    }

    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredEmotionCollection.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: EmojiUIView.CELL_IDENTIFIER, for: indexPath)
        
        if cell == nil {
            let newCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: EmojiUIView.CELL_IDENTIFIER)
            newCell.textLabel!.text = self.filteredEmotionCollection[indexPath.row]
            return newCell
        }
        
        cell.textLabel?.text = self.filteredEmotionCollection[indexPath.row]
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.emojiLabel.text = "I feel \(self.filteredEmotionCollection[indexPath.row])"
        self.emojiText = self.emojiLabel.text!
    }
    
    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            let lowerCasedSearchText = searchText.lowercased()
            self.filteredEmotionCollection = EmojiUIView.IMMUTABLE_EMOTIONS_COLLECTION.filter { (emoji) -> Bool in
                String(emoji.dropFirst(2)).lowercased().contains(lowerCasedSearchText)
            }
        }
        else {
            self.filteredEmotionCollection = EmojiUIView.IMMUTABLE_EMOTIONS_COLLECTION
        }
        self.emojiTableView.reloadData()
    }
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let tuple = self.getLabelTextTuple(index: indexPath.row)
        let text = tuple.0
        let subtitle = tuple.1

        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: EmojiUIView.CELL_IDENTIFIER, for: indexPath) as UITableViewCell
        
        if cell == nil {
            let newCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: ViewController.CELL_IDENTIFIER)
            newCell.textLabel!.text = text
            newCell.detailTextLabel!.text = subtitle
            return newCell
        }
        
        cell.textLabel?.text = text
        
        return cell
    }