//
//  VerSnapViewController.swift
//  AndradeSnapchat
//
//  Created by MaryC on 21/11/23.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseDatabase
import FirebaseStorage
import AVFoundation

class VerSnapViewController: UIViewController {

    @IBOutlet weak var imagenView: UIImageView!
    @IBOutlet weak var lblMensaje: UILabel!
    @IBOutlet weak var btnAudio: UIButton!
    var snap = Snap()
    var audioPlayer: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMensaje.text = "Mensaje: " + snap.descrip
        imagenView.sd_setImage(with: URL(string: snap.imagenURL), completed: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
            Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
        
        Storage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete{(error) in
            print("Se elimino la imagen correctamente")
        }
        
    }
    
    func playAudio(from url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error reproduciendo audio: \(error.localizedDescription)")
        }
    }
    

}
