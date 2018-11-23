//
//  AQTableViewController.swift
//  Quiz
//
//  Created by Rodrigo Martín Martín on 22/11/2018.
//  Copyright © 2018 Rodri. All rights reserved.
//

import UIKit

class AQTableViewController: UITableViewController {
    
    var imagesCache = [String:UIImage]()
    var quizzes = [Quiz]()
    var statusCode = false
    var id: Int?
    var autor: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        title = "Quizzes de \(autor ?? "Unknown")"
        
        downloadAllQuizzes("https://quiz2019.herokuapp.com/api/users/\(id ?? 0)/quizzes?token=f2079b1d0cee0c8adbf2")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Quizzes Autor", for: indexPath) as! AQTableViewCell
        
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
        
        cell.id = indexPath.row
        
        if quiz.favourite == false {
            cell.favouriteButton.imageView?.image = UIImage(named: "star2")
        } else {
            cell.favouriteButton.imageView?.image = UIImage(named: "star")
        }
        
        return cell
    }
    
    @IBAction func setFavourite(_ sender: UIButton) {
        
        let cell = sender.superview?.superview as! AQTableViewCell
        let indexPath = tableView.indexPath(for: cell)
        
        if quizzes[cell.id].favourite == false {
            if pressedPUT(quizzes[cell.id].id) {
                quizzes[cell.id].favourite = true
            }
        } else {
            if pressedDELETE(quizzes[cell.id].id) {
                quizzes[cell.id].favourite = false
            }
        }
        self.statusCode = false
        self.tableView.reloadRows(at: [indexPath!], with: .fade)
    }
    
    
    func downloadAllQuizzes(_ url: String){
        guard let url2 = URL(string: url) else { return }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DispatchQueue.global().async {
            
            if let data = try? Data(contentsOf: url2) {
                
                if let quizzesInThisPage = try? JSONDecoder().decode(Quizzes_Page.self, from: data) {
                    
                    DispatchQueue.main.async {
                        
                        for i in quizzesInThisPage.quizzes {
                            self.quizzes.append(i)
                            self.tableView.reloadData()
                            
                        }
                        
                        if quizzesInThisPage.nextUrl != "" {
                            self.downloadAllQuizzes(quizzesInThisPage.nextUrl!)
                        }
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            } else {
                self.downloadAllQuizzes(url)
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
    
    func pressedPUT(_ id: Int) -> Bool {
        let urlPUT = "https://quiz2019.herokuapp.com/api/users/tokenOwner/favourites/\(id)?token=f2079b1d0cee0c8adbf2"
        guard let url = URL(string: urlPUT) else {
            print("Error 1")
            return false
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200{
                    self.statusCode = true
                }
            }
        })
        
        task.resume()
        return self.statusCode
        
    }
    
    func pressedDELETE(_ id: Int) -> Bool {
        let urlDELETE = "https://quiz2019.herokuapp.com/api/users/tokenOwner/favourites/\(id)?token=f2079b1d0cee0c8adbf2"
        
        guard let url = URL(string: urlDELETE) else {
            print("Error 1")
            return false
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.statusCode = true
                }
            }
        })
        
        task.resume()
        
        return self.statusCode
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

