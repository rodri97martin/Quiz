//
//  QuizzesTableViewController.swift
//  Quiz
//
//  Created by Rodrigo Martín Martín on 14/11/2018.
//  Copyright © 2018 Rodri. All rights reserved.
//

import UIKit

struct Attachment: Codable {
    let filename: String
    let mime: String
    let url: String
}

struct Quiz: Codable {
    let id: Int
    let question: String
    let author: Usuario?
    let attachment: Attachment?
    let favourite: Bool
    let tips: [String]?
}

struct Quizzes_Page: Codable {
    let quizzes: [Quiz]
    let pageno: Int
    let nextUrl: String?
}

class QuizzesTableViewController: UITableViewController {

    let URLBASE = "https://quiz2019.herokuapp.com/api/quizzes?token=f2079b1d0cee0c8adbf2"
    var imagesCache = [String:UIImage]()
    var quizzes = [Quiz]()
    
    @IBOutlet weak var refresh: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        downloadAllQuizzes(URLBASE)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return quizzes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Show Quizzes", for: indexPath) as! QuizTableViewCell

        // Configure the cell...
        
        let quiz = quizzes[indexPath.row]
        
        cell.questionLabel.text = quiz.question
        cell.autorLabel.text = quiz.author?.username ?? "Unknown"
        
        if let img = imagesCache[quiz.attachment?.url ?? ""] {

            cell.quizImageView.image = img
        } else {
            
            cell.quizImageView.image = UIImage(named: "noImage")
            download(quiz.attachment?.url ?? "", index: indexPath)
        }
        
        return cell
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        
        imagesCache.removeAll()
        quizzes.removeAll()
        downloadAllQuizzes(URLBASE)
    }
    
    
    func downloadAllQuizzes(_ url: String){
        guard let url = URL(string: url) else { return }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DispatchQueue.global().async {
            
            if let data = try? Data(contentsOf: url) {
                
                if let quizzesInThisPage = try? JSONDecoder().decode(Quizzes_Page.self, from: data) {
                    
                    DispatchQueue.main.async {
                        
                        for i in quizzesInThisPage.quizzes {
                            self.quizzes.append(i)
                            self.tableView.reloadData()
                        }
                        
                        if quizzesInThisPage.nextUrl != "" {
                            print("Going to next URL")
                            self.downloadAllQuizzes(quizzesInThisPage.nextUrl!)
                        }
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            }
        }
    }
    
    func download(_ urls: String, index indexpath: IndexPath) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DispatchQueue.global().async {
            
            if let url = URL(string: urls),
                let data = try? Data(contentsOf: url),
                let img = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    
                    self.imagesCache[urls] = img
                    self.tableView.reloadRows(at: [indexpath], with: .fade)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
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

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Show Quiz" {
            if let qvc = segue.destination as? QuizViewController {
                
                let quiz = quizzes[(tableView.indexPathForSelectedRow?.row)!]
                
                qvc.quiz = quiz
                qvc.img = imagesCache[quiz.attachment?.url ?? ""]
            }
        }
    }
    

}
