//
//  ViewController.swift
//  Contactos_CoreData
//
//  Created by Brandon Rodriguez Molina on 13/05/21.
//

import UIKit

class ViewController: UIViewController {
    
    //Variables a enviar por segue
    var nombreEnviar: String?
    
    //Arreglo de contactos
    var contactos = [MiContacto]()
    
    //Outlets de los elementos
    @IBOutlet weak var tablaContactos: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Registro de la celda custom
        tablaContactos.register(UINib(nibName: "ContactoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        //Asignacion de delegado y datasource
        tablaContactos.delegate = self
        tablaContactos.dataSource = self
    }
    
    // Agregar un nuevo contacto
    @IBAction func agregarContacto(_ sender: Any) {
        //Creacion de la alerta
        let alerta = UIAlertController(title: "Nuevo contacto", message: "Llena los datos", preferredStyle: .alert)
        //Agregar los textFields para los datos del contacto
        alerta.addTextField { (nombre) in
            nombre.placeholder = "Nombre"
        }
        alerta.addTextField { (numero) in
            numero.placeholder = "Telefono"
        }
        alerta.addTextField { (direccion) in
            direccion.placeholder = "Direccion "
        }
        
        //Creacion de las acciones
        let accionAceptar = UIAlertAction(title: "Agregar", style: .default) { (_) in
            //Obtencion de los textfields de la alerta para ser usados al crear contacto
            guard let nombreAlerta = alerta.textFields?.first?.text else { return }
            guard let telefonoAlerta = Int64(alerta.textFields?[1].text ?? "0000000000") else { return }
            guard let direccionAlerta = alerta.textFields?.last?.text else { return }
            //Creacion del contact
            let nuevoContacto = MiContacto(nombre: nombreAlerta, telefono: telefonoAlerta, direccion: direccionAlerta)
            //Agregarlo al arreglo
            self.contactos.append(nuevoContacto)
            //Recargar la tabla
            self.tablaContactos.reloadData()
        }
        let accionCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        //Implementar las acciones
        alerta.addAction(accionAceptar)
        alerta.addAction(accionCancelar)
        
        //Mostrar la alerta
        present(alerta, animated: true)
        
    }
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaContactos.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactoTableViewCell
        celda.nombreLabel.text = contactos[indexPath.row].nombre
        celda.telefonoLabel.text = "☏ \(contactos[indexPath.row].telefono!)"
        return celda
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tablaContactos.deselectRow(at: indexPath, animated: true)
        nombreEnviar = contactos[indexPath.row].nombre
        performSegue(withIdentifier: "editarContacto", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editarContacto" {
            let objEditar = segue.destination as! EditarViewController
            objEditar.recibirNombre = nombreEnviar
        }
    }
    
    
}
