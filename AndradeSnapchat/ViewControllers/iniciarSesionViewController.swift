//
//  ViewController.swift
//  AndradeSnapchat
//
//  Created by MaryC on 7/11/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FirebaseDatabase

class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func iniciargoogle(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                        let config = GIDConfiguration(clientID: clientID)
                        GIDSignIn.sharedInstance.configuration = config

                        // Inicia el flujo de inicio de sesión con Google
                        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
                            if let error = error {
                                print("Error al iniciar sesión con Google: \(error.localizedDescription)")
                            } else if let user = result?.user,
                                      let idToken = user.idToken?.tokenString {
                                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

                                // Inicia sesión en Firebase con las credenciales de Google
                                Auth.auth().signIn(with: credential) { _, firebaseError in
                                    if let firebaseError = firebaseError {
                                        print("Error al iniciar sesión en Firebase: \(firebaseError.localizedDescription)")
                                    } else {
                                        print("Inicio de sesión en Firebase exitoso")
                                        // Realiza cualquier acción adicional que necesites después del inicio de sesión.
                                    }
                                }
                            }
                        }
        
    }
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                        if let error = error as NSError? {
                            print("Error al intentar iniciar sesión: \(error.localizedDescription)")

                            if error.code == AuthErrorCode.userNotFound.rawValue {
                                // El usuario no existe, muestra la alerta para crear uno nuevo
                                print("...")
                            } else {
                                // Otro tipo de error, muestra la alerta de error
                                self.mostrarAlertaError("Error de Inicio de Sesión", mensaje: error.localizedDescription)
                            }
                        } else {
                            // Inicio de sesión exitoso
                            print("Inicio de sesión exitoso")
                            self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                        }
                    }
    }
    
    func mostrarAlertaError(_ titulo: String, mensaje: String) {
            let alerta = UIAlertController(title: "Usuario no Existente", message: "Lo sentimos. El usuario no existe. ¿Desea Registrarse?", preferredStyle: .alert)
            let btnCrear = UIAlertAction(title: "Registrarse", style: .default) { (_) in
                // Redirige a la vista para crear un nuevo usuario
                self.performSegue(withIdentifier: "CrearUsuarioViewController", sender: nil)
            }
            let btnCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            alerta.addAction(btnCrear)
            alerta.addAction(btnCancelar)
            present(alerta, animated: true, completion: nil)
        }
    
        func iniciarSesion() {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                if let error = error as NSError? {
                    print("Error al intentar iniciar sesión: \(error.localizedDescription)")
                    // Aquí puedes mostrar una alerta u otro manejo de error si es necesario
                } else {
                    // Inicio de sesión exitoso
                    print("Inicio de sesión exitoso")
                    self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                }
            }
        }
    
    


}

