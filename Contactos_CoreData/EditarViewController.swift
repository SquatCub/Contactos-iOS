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
    var recibirCorreo: String?
    var recibirIndice: Int?
    
    //Outlets
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var telefonoTextField: UITextField!
    @IBOutlet weak var direccionTextField: UITextField!
    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var imagenContacto: UIImageView!
    
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var telefonoLabel: UILabel!
    @IBOutlet weak var direccionLabel: UILabel!
    @IBOutlet weak var correoLabel: UILabel!
    
    @IBOutlet weak var guardarBtn: UIButton!
    @IBOutlet weak var cancelarBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cargarCoreData()
        inicializarOutlets()
        
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
    @IBAction func editarBtn(_ sender: Any) {
        guardarBtn.isHidden = false
        cancelarBtn.isHidden = false
        
        nombreTextField.isHidden = false
        telefonoTextField.isHidden = false
        direccionTextField.isHidden = false
        correoTextField.isHidden = false
        
        nombreLabel.isHidden = true
        telefonoLabel.isHidden = true
        direccionLabel.isHidden = true
        correoLabel.isHidden = true
        
        //MARK.-Agregar gestura a la imagen
        let gestura = UITapGestureRecognizer(target: self, action: #selector(clickImagen))
        gestura.numberOfTapsRequired = 1
        gestura.numberOfTouchesRequired = 1
        
        //Agregar gestura a la imagen
        imagenContacto.addGestureRecognizer(gestura)
        imagenContacto.isUserInteractionEnabled = true
    }
    
    @IBAction func calcelarBtn(_ sender: UIButton) {
        inicializarOutlets()
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
    
    func inicializarOutlets() {
        nombreLabel.text = "Nombre: \(recibirNombre!)"
        telefonoLabel.text = "Telefono: \(recibirTelefono!)"
        direccionLabel.text = "Direccion: \(recibirDireccion!)"
        correoLabel.text = "Correo: \(recibirCorreo!)"
        nombreTextField.text = "\(recibirNombre!)"
        telefonoTextField.text = "\(recibirTelefono!)"
        direccionTextField.text = "\(recibirDireccion!)"
        correoTextField.text = "\(recibirCorreo!)"
        imagenContacto.image = UIImage(data: contactos[recibirIndice!].imagen!)
        imagenContacto.layer.cornerRadius = 50
        
        nombreLabel.isHidden = false
        telefonoLabel.isHidden = false
        direccionLabel.isHidden = false
        correoLabel.isHidden = false
        
        nombreTextField.isHidden = true
        telefonoTextField.isHidden = true
        direccionTextField.isHidden = true
        correoTextField.isHidden = true
        
        guardarBtn.isHidden = true
        cancelarBtn.isHidden = true
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
