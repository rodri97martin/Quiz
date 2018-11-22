//
//  AutorViewController.swift
//  Quiz
//
//  Created by Rodrigo Martín Martín on 14/11/2018.
//  Copyright © 2018 Rodri. All rights reserved.
//

import UIKit

class AutorViewController: UIViewController {

    var autor: String!
    var id: Int!
    var isAdmin: Bool?
    
    @IBOutlet weak var autorLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var isAdminLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = autor
        autorLabel.text = "Username: \(autor ?? "")"
        idLabel.text = "Id: \(id!)"
        isAdminLabel.text = "Is Admin: \(isAdmin ?? false)"
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Show Quizzes Autor" {
            
            if let aqtvc = segue.destination as? AQTableViewController {
                
                aqtvc.id = self.id
                aqtvc.autor = self.autor
            }
        }

    }

}
