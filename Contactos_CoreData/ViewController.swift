//
//  ViewController.swift
//  Contactos_CoreData
//
//  Created by Brandon Rodriguez Molina on 13/05/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tablaContactos: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaContactos.register(UINib(nibName: "ContactoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tablaContactos.delegate = self
        tablaContactos.dataSource = self
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaContactos.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactoTableViewCell
        celda.nombreLabel.text = "Nombre contacto"
        celda.telefonoLabel.text = "459108453"
        return celda
    }
    
    
}
