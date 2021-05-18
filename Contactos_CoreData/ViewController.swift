//
//  ViewController.swift
//  Contactos_CoreData
//
//  Created by Brandon Rodriguez Molina on 13/05/21.
//

import UIKit
import CoreData
 
class ViewController: UIViewController {
    
    //Variables a enviar por segue
    var nombreEnviar: String?
    var telefonoEnviar: Int64?
    var direccionEnviar: String?
    var indice: Int?
    
    //Arreglo de contactos
    //var contactos = [MiContacto]()
    var contactos = [Contacto]()
    //Conexion al contexto de la BD
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Outlets de los elementos
    @IBOutlet weak var tablaContactos: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Leer datos de la BD de CoreData
        cargarCoreData()
        tablaContactos.reloadData()
        //Registro de la celda custom
        tablaContactos.register(UINib(nibName: "ContactoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        //Asignacion de delegado y datasource
        tablaContactos.delegate = self
        tablaContactos.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tablaContactos.reloadData()
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
            numero.keyboardType = .numberPad
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
            //Imagen temportal
            let imagenTemporal = UIImageView(image: #imageLiteral(resourceName: "Screen Shot 2021-05-13 at 20.34.36"))
            
            // Cargar el objeto para guardar en CD
            //Creacion del contact
            let nuevoContacto = Contacto(context: self.contexto)
            nuevoContacto.nombre = nombreAlerta
            nuevoContacto.telefono = telefonoAlerta
            nuevoContacto.direccion = direccionAlerta
            nuevoContacto.imagen = imagenTemporal.image?.pngData()
            //Metodo guardar
            self.guardarContacto()
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
    
    //Guardar en CD
    func guardarContacto() {
        do {
            try contexto.save()
            print("Se guardo correctamente")
        } catch let error as NSError {
            print("Error al guardar: \(error.localizedDescription)")
        }
    }
    //Leer de CD
    func cargarCoreData() {
        let fetchRequest: NSFetchRequest<Contacto> = Contacto.fetchRequest()
        do {
            contactos = try contexto.fetch(fetchRequest)
        } catch {
            print("Error al cargar datos del CoreData: \(error.localizedDescription)")
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaContactos.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactoTableViewCell
        celda.nombreLabel.text = contactos[indexPath.row].nombre
        celda.telefonoLabel.text = "☏ \(contactos[indexPath.row].telefono)"
        celda.contactoImagen.image = UIImage(data: contactos[indexPath.row].imagen!)
        return celda
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tablaContactos.deselectRow(at: indexPath, animated: true)
        nombreEnviar = contactos[indexPath.row].nombre
        telefonoEnviar = contactos[indexPath.row].telefono
        direccionEnviar = contactos[indexPath.row].direccion
        indice = indexPath.row
        performSegue(withIdentifier: "editarContacto", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editarContacto" {
            let objEditar = segue.destination as! EditarViewController
            objEditar.recibirNombre = nombreEnviar
            objEditar.recibirTelefono = telefonoEnviar
            objEditar.recibirDireccion = direccionEnviar
            objEditar.recibirIndice = indice
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionBorrar = UIContextualAction(style: .normal, title: "") { (_, _, _) in
            print("Borrar")
            //Eliminar de CD
            self.contexto.delete(self.contactos[indexPath.row])
            //Eliminar de la interfaz
            self.contactos.remove(at: indexPath.row)
            self.guardarContacto()
            self.tablaContactos.reloadData()
        }
        accionBorrar.image = UIImage(named: "borrar.png")
        accionBorrar.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [accionBorrar])
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Creacion de los actions de derecha a izquierda
        let accionLlamada = UIContextualAction(style: .normal, title: "") { (_, _, _) in
            print("realizar llamada")
        }
        let accionMensaje = UIContextualAction(style: .normal, title: "") { (_, _, _) in
            print("Mensaje")
        }
        //Asignando propiedades
        accionLlamada.image = UIImage(named: "llamada.png")
        accionLlamada.backgroundColor = .green
        accionMensaje.image = UIImage(named: "mensaje.png")
        accionMensaje.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [accionLlamada, accionMensaje])
    }
    
    
}
