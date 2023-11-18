//
//  RegistrarseViewController.swift
//  AndradeSnapchat
//
//  Created by MaryC on 18/11/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegistrarseViewController: UIViewController {

    @IBOutlet weak var registrarcontraseña: UITextField!
    
    @IBOutlet weak var registrarusuario: UITextField!
    @IBOutlet weak var btnregistrar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func registrarse(_ sender: Any) {
        guard let email = registrarusuario.text, !email.isEmpty,
                  let password = registrarcontraseña.text, !password.isEmpty else {
                mostrarAlerta(titulo: "Campos Vacíos", mensaje: "Por favor, complete todos los campos", accion: "Aceptar")
                return
            }

            // Crear el usuario en Firebase Authentication
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    // Error al crear el usuario
                    print("Error al crear el usuario: \(error.localizedDescription)")
                    self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al crear el usuario. Por favor, inténtelo de nuevo.", accion: "Aceptar")
                } else {
                    Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                    // Usuario creado exitosamente
                    print("Usuario creado exitosamente.")
                    
                    // Puedes realizar cualquier acción adicional aquí, como navegar a la siguiente vista.
                    // Por ejemplo:
                    self.performSegue(withIdentifier: "registrarse", sender: nil)
                }
            }

    }
    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnAceptar = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnAceptar)
        present(alerta, animated: true, completion: nil)
    }


    

}
