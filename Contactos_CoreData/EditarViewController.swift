//
//  EditarViewController.swift
//  Contactos_CoreData
//
//  Created by Brandon Rodriguez Molina on 13/05/21.
//

import UIKit

class EditarViewController: UIViewController {
    var recibirNombre: String?
    @IBOutlet weak var nombreTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        nombreTextField.text = recibirNombre
    }
    

}
