//
//  ViewController.swift
//  WeakWords
//
//  Created by Alisdair Little on 16/08/2018.
//  Copyright © 2018 ThinkCulture. All rights reserved.
//

import UIKit

class ChooseATestViewController : UITableViewController {
    var paths = [String]()
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    var mode: TestMode = .guess
    var fileName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        let refresh = UIRefreshControl()
        
        refresh.addTarget(self, action: #selector(refreshData), for: UIControlEvents.valueChanged)
        refresh.tintColor = UIColor.red
        
        self.tableView.refreshControl = refresh

        self.refreshData()
        
    }
    
    @objc func refreshData() {
        do {
            try self.paths = FileManager.default.contentsOfDirectory(atPath:self.documentsDirectory.path)
            
            if paths.count == 0 {
                let frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height);
                let view = UIView(frame: frame)
                let label = UILabel(frame: frame)
                
                label.textAlignment = .center
                label.text = "No tests. Use iTunes to add some."
                view.addSubview(label)
                
                self.tableView.tableFooterView = view
            }
        } catch {
             print("Error while enumerating files \(self.documentsDirectory.path)")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testCell") as! TestCell
        let file = paths[indexPath.row]
        
        cell.testFilenameLabel.text = file
        cell.guessButton.tag = indexPath.row
        cell.translateButton.tag = indexPath.row
        cell.guessButton.addTarget(self, action: #selector(guessAction(sender:)), for: .touchUpInside)
        cell.translateButton.addTarget(self, action: #selector(translateAction(sender:)), for: .touchUpInside)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paths.count
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // set the chosen file
        let wordTest = segue.destination as! WordTestViewController
        
        wordTest.mode = self.mode
        wordTest.path = self.fileName
    }

    @objc func translateAction(sender: UIButton) {
        self.mode = .translate
        self.fileName = self.documentsDirectory.appendingPathComponent(self.paths[sender.tag]).path
        self.performSegue(withIdentifier: "testSeque", sender: self)
    }

    @objc func guessAction(sender: UIButton) {
        self.mode = .guess
        self.fileName = self.documentsDirectory.appendingPathComponent(self.paths[sender.tag]).path
        self.performSegue(withIdentifier: "testSeque", sender: self)
    }
}
