//
//  AutoresTableViewController.swift
//  Quiz
//
//  Created by Rodrigo Martín Martín on 08/11/2018.
//  Copyright © 2018 Rodri. All rights reserved.
//

import UIKit

struct Usuario: Codable {
    let id: Int?
    let isAdmin: Bool?
    let username: String
}

class AutoresTableViewController: UITableViewController {
    
    let URLBASE = "https://quiz2019.herokuapp.com/api/users?token=f2079b1d0cee0c8adbf2"
    
    var items = [Usuario]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        download()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Autor Cell", for: indexPath)

        // Configure the cell...

        let author = items[indexPath.row]
        
        cell.textLabel?.text = author.username
        cell.imageView?.image = UIImage(named: "monigote")
        
        return cell
    }
    
    
    func download() {
        
        guard let url = URL(string: URLBASE) else { return }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        DispatchQueue.global().async {
            
            if let data = try? Data(contentsOf: url) {
                
                if let items = try? JSONDecoder().decode([Usuario].self, from: data) {
                    
                    DispatchQueue.main.async {
                        self.items = items
                        self.tableView.reloadData()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Autor" {
            
            if let avc = segue.destination as? AutorViewController {
                
                if let sr = tableView.indexPathForSelectedRow {
                    
                    avc.autor = items[sr.row].username
                    avc.id = items[sr.row].id
                    avc.isAdmin = items[sr.row].isAdmin
                    
                }
            }
            
        }
    }

}
