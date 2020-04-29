//
//  ViewController.swift
//  Personel
//
//  Created by Alper Altınkaynak on 28.04.2020.
//  Copyright © 2020 Alper Altınkaynak. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    

    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    var filteredArray:[Person] = []
    var db:DBHelper = DBHelper()
    var person:[Person] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        search.delegate = self
        
        person = db.read()
        filteredArray = person
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let oneCell = tableView.dequeueReusableCell(withIdentifier: "toDetail", for: indexPath) as! tableCell
        oneCell.wordLabel.text = filteredArray[indexPath.row].name as? String
        oneCell.ageLabel.text = filteredArray[indexPath.row].age as? String
        
        return oneCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let toVC = self.storyboard?.instantiateViewController(withIdentifier: "toDetail") as! detailVC
        self.present(toVC, animated:true, completion: nil)
        
        toVC.word.text = filteredArray[indexPath.row].name as! String
        toVC.age.text = filteredArray[indexPath.row].age as! String
              
        
        
        //performSegue(withIdentifier: "toDetay", sender: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        if searchText == "" || searchText.isEmpty {
            filteredArray = person
            table.reloadData()
            return
        }
        filteredArray = person.filter{($0.name as AnyObject).contains(searchText)}
        
        table.reloadData()
    }
    
}

