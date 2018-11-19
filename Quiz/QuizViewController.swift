//
//  QuizViewController.swift
//  Quiz
//
//  Created by Rodrigo Martín Martín on 19/11/2018.
//  Copyright © 2018 Rodri. All rights reserved.
//

import UIKit

struct quizChecked: Codable {
    
    let quizId: Int
    let answer: String
    let result: Bool
}

class QuizViewController: UIViewController {

    var quiz: Quiz!
    var img: UIImage?
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var quizImageView: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionLabel.text = quiz?.question
        quizImageView.image = img
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        
        let ac = AlertaCorrecta()
        let ai = AlertaIncorrecta()
        
        let URL_CHECK = "https://quiz2019.herokuapp.com/api/quizzes/\(quiz.id)/check?token=f2079b1d0cee0c8adbf2&answer=\(answerTextField.text ?? "")"
        
        guard let url = URL(string: URL_CHECK) else {
            print("Error 1")
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                
                if let quiz = try? JSONDecoder().decode(quizChecked.self, from: data) {
                    
                    DispatchQueue.main.async {
                        
                        if quiz.result == true {
                            
                            ac.showAlert()
                            self.present(ac.alert!, animated: true)
                        
                        } else {
                            
                            ai.showAlert()
                            self.present(ai.alert!, animated: true)
                            
                        }
                    }
                } else {
                    print("Error 3")
                }
            } else {
                print("Error 2")
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
