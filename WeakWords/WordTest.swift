//
//  WordTest.swift
//  WeakWords
//
//  Created by Alisdair Little on 17/08/2018.
//  Copyright © 2018 ThinkCulture. All rights reserved.
//

import UIKit

enum TestMode {
    case translate
    case guess
}

class WordTestViewController : UIViewController {
    var mode: TestMode = .guess
    var path: String?
    var strings = [String]()
    var index = 0
    var correct = 0
    @IBOutlet weak var clueLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshData()
        
        let gr = UITapGestureRecognizer(target: self, action: #selector(showAnswer))
        
        gr.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(gr)
    }
    
    @objc func showAnswer() {
        let strings = self.strings[self.index].components(separatedBy: ",")
        
        if strings.count == 2 {
            if self.mode == .guess {
                self.answerLabel.text = strings[1]
            } else {
                self.answerLabel.text = strings[0]
            }
        }
    }
    
    @IBAction func wrongTouched(_ sender: Any) {
        self.index += 1
        showClue()
    }
    
    @IBAction func rightTapped(_ sender: Any) {
        self.correct += 1
        self.index += 1
        showClue()
    }
    
    func showClue() {
        if self.index == self.strings.count {
            let alertView = UIAlertController(title: "Finished", message: "\(self.correct) out of \(self.strings.count)", preferredStyle: .alert)
            
            alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alertView, animated: true, completion: nil)
        } else {
            let strings = self.strings[self.index].components(separatedBy: ",")
            
            self.clueLabel.text = ""
            self.answerLabel.text = ""
            
            if strings.count == 2 {
                if self.mode == .guess {
                    self.clueLabel.text = strings[0]
                } else {
                    self.clueLabel.text = strings[1]
                }
            }
        }
    }
    
    func refreshData() {
        // Read the data into strings
        do {
            let data = try String(contentsOfFile: self.path!, encoding: .utf8)
            
            self.strings.append(contentsOf: data.components(separatedBy: .newlines))
            showClue()
        } catch {
            self.clueLabel.text = "Unable to open test file"
        }
    }
}
