//
//  EditarViewController.swift
//  Contactos_CoreData
//
//  Created by Brandon Rodriguez Molina on 13/05/21.
//

import UIKit
import CoreData

class EditarViewController: UIViewController {
    
    //Arreglo de contactos
    //var contactos = [MiContacto]()
    var contactos = [Contacto]()
    //Conexion al contexto de la BD
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Variables del segue
    var recibirNombre: String?
    var recibirTelefono: Int64?
    var recibirDireccion: String?
    var recibirIndice: Int?
    
    //Outlets
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var telefonoTextField: UITextField!
    @IBOutlet weak var direccionTextField: UITextField!
    @IBOutlet weak var imagenContacto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cargarCoreData()
        nombreTextField.text = recibirNombre
        telefonoTextField.text = "\(recibirTelefono!)"
        direccionTextField.text = recibirDireccion
        imagenContacto.image = UIImage(data: contactos[recibirIndice!].imagen!)
        imagenContacto.layer.cornerRadius = 50
        
        //MARK.-Agregar gestura a la imagen
        let gestura = UITapGestureRecognizer(target: self, action: #selector(clickImagen))
        gestura.numberOfTapsRequired = 1
        gestura.numberOfTouchesRequired = 1
        
        //Agregar gestura a la imagen
        imagenContacto.addGestureRecognizer(gestura)
        imagenContacto.isUserInteractionEnabled = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func clickImagen(gestura: UITapGestureRecognizer) {
        print("cambiar imagen")
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
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


    @IBAction func tomarFoto(_ sender: UIBarButtonItem) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    @IBAction func calcelarBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func guardarBtn(_ sender: UIButton) {
        do {
            contactos[recibirIndice!].setValue(nombreTextField.text, forKey: "nombre")
            contactos[recibirIndice!].setValue(Int64(telefonoTextField.text!), forKey: "telefono")
            contactos[recibirIndice!].setValue(direccionTextField.text, forKey: "direccion")
            contactos[recibirIndice!].setValue(imagenContacto.image?.pngData(), forKey: "imagen")
            try self.contexto.save()
            print("Se ha actualizado el contacto")
        } catch {
            print("Error al editar \(error.localizedDescription)")
        }
        navigationController?.popViewController(animated: true)
    }
}

//MARK.- Protocolo para la gestura de la imagen y seleccion de imagen
extension EditarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //Que se hara cuando el usuario selecciona alguna imagen
        if let imagenSeleccionada = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imagenContacto.image = imagenSeleccionada
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
