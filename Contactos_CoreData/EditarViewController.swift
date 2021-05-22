//
//  EditarViewController.swift
//  Contactos_CoreData
//
//  Created by Brandon Rodriguez Molina on 13/05/21.
//

import UIKit
import CoreData
import MessageUI

class EditarViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
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
    @IBOutlet weak var mensajeLabel: UILabel!
    
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var telefonoLabel: UILabel!
    @IBOutlet weak var direccionLabel: UILabel!
    @IBOutlet weak var correoLabel: UILabel!
    
    @IBOutlet weak var guardarBtn: UIButton!
    @IBOutlet weak var cancelarBtn: UIButton!
    
    
    @IBOutlet weak var iconPersona: UILabel!
    @IBOutlet weak var iconLlamada: UILabel!
    @IBOutlet weak var iconLocalizacion: UILabel!
    @IBOutlet weak var iconMail: UILabel!
    
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
        mensajeLabel.isHidden = false
        iconPersona.isHidden = false
        iconLlamada.isHidden = false
        iconLocalizacion.isHidden = false
        iconMail.isHidden = false
        
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
            contactos[recibirIndice!].setValue(correoTextField.text, forKey: "correo")
            contactos[recibirIndice!].setValue(imagenContacto.image?.pngData(), forKey: "imagen")
            try self.contexto.save()
            print("Se ha actualizado el contacto")
        } catch {
            print("Error al editar \(error.localizedDescription)")
        }
        navigationController?.popViewController(animated: true)
    }
    
    func inicializarOutlets() {
        nombreLabel.text = "\(recibirNombre!)"
        telefonoLabel.text = "📞   \(recibirTelefono!)"
        direccionLabel.text = "📍   \(recibirDireccion!)"
        correoLabel.text = "✉️   \(recibirCorreo!)"
        nombreTextField.text = "\(recibirNombre!)"
        telefonoTextField.text = "\(recibirTelefono!)"
        direccionTextField.text = "\(recibirDireccion!)"
        correoTextField.text = "\(recibirCorreo!)"
        imagenContacto.image = UIImage(data: contactos[recibirIndice!].imagen!)
        imagenContacto.layer.cornerRadius = 50
        imagenContacto.isUserInteractionEnabled = false
        
        nombreLabel.isHidden = false
        telefonoLabel.isHidden = false
        direccionLabel.isHidden = false
        correoLabel.isHidden = false
        
        nombreTextField.isHidden = true
        telefonoTextField.isHidden = true
        direccionTextField.isHidden = true
        correoTextField.isHidden = true
        mensajeLabel.isHidden = true
        
        iconPersona.isHidden = true
        iconLlamada.isHidden = true
        iconLocalizacion.isHidden = true
        iconMail.isHidden = true
        
        guardarBtn.isHidden = true
        cancelarBtn.isHidden = true
    }
    @IBAction func llamarButton(_ sender: UIButton) {
        guard let telefono = recibirTelefono else {return}
        
        if let phoneCallUrl = URL(string: "TEL://+52\(telefono)") {
            let application:UIApplication = UIApplication.shared
            if(application.canOpenURL(phoneCallUrl)) {
                application.open(phoneCallUrl, options: [:], completionHandler: nil)
            }
        }
    }
    @IBAction func mensajeButton(_ sender: UIButton) {
        let telefono = "+52\(recibirTelefono!)"
        let sms: String = "sms:\(telefono)&body=Hola \(recibirNombre!), te escribo desde la app de contactos"
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
    @IBAction func correoButton(_ sender: UIButton) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            let alert = UIAlertController(title: "Error al enviar email", message: "Necesitas iniciar sesion en la app de correo", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["\(recibirCorreo!)"])
        composeVC.setSubject("Hola \(recibirNombre!)!")
        composeVC.setMessageBody("Saludos!, te mando correo desde la app de contactos", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
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
//MARK:- delegate methods MFMailCompose
extension ViewController: MFMailComposeViewControllerDelegate {
 
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            //show error alert
            controller.dismiss(animated: true)
            return
        }
        switch result {
        case .cancelled:
            print("Cancelado")
            showAlert(msj: "Cancelled")
        case .failed:
            print("Error al enviar msj")
            showAlert(msj: "Error to send msj")
        case .saved:
            print("Guardado en borradores!")
            showAlert(msj: "Saved ind drafts")
        case .sent:
            print("Correo enviado!")
            showAlert(msj: "email sent")
        default:
            print("error desconocido")
            showAlert(msj: "uknown error")
        }
        
        controller.dismiss(animated: true)
    }
    func showAlert(msj: String) {
        let alert = UIAlertController(title: "Notificacion", message: msj, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: msj, style: .default, handler: nil))
        present(alert, animated: true)
        
    }
}
