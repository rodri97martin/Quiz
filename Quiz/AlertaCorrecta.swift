//
//  File.swift
//  Quiz
//
//  Created by Rodrigo Martín Martín on 19/11/2018.
//  Copyright © 2018 Rodri. All rights reserved.
//

import UIKit

class AlertaCorrecta {
    
    var alert: UIAlertController?
    
    func showAlert() {
        
        alert = UIAlertController(title: "Respuesta correcta", message: nil, preferredStyle: .alert)
        alert?.addAction(UIAlertAction(title: "OK", style: .default))
    }
}
