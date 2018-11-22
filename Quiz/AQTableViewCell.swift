//
//  AQTableViewCell.swift
//  Quiz
//
//  Created by Rodrigo Martín Martín on 22/11/2018.
//  Copyright © 2018 Rodri. All rights reserved.
//

import UIKit

class AQTableViewCell: UITableViewCell {

    @IBOutlet weak var quizImageView: UIImageView!
    @IBOutlet weak var autorLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var id: Int!
    
}
