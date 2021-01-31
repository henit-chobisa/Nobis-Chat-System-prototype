//
//  ViewController.swift
//  ICLO
//
//  Created by Henit Work on 22/01/21.
//

import UIKit
import Canvas
import Firebase
import FirebaseFirestore


class ViewController: UIViewController {
    @IBOutlet weak var loginView: CSAnimationView!
    @IBOutlet weak var loginButoon: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var passwordTextFeild: UITextField!
    let db = Firestore.firestore()
 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginView.layer.cornerRadius = 20
        loginView.layer.borderWidth = 1
        loginView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        loginButoon.layer.cornerRadius = 15
        registerButton.layer.cornerRadius = 15
    }
    
    
    @IBAction func loginHit(_ sender: UIButton) {
        
        
        Auth.auth().signIn(withEmail: emailTextFeild.text!, password: passwordTextFeild.text!) { [weak self] authResult, error in
            guard self != nil else { return }
            if error == nil {
                
                self?.performSegue(withIdentifier: "mainfeedwithlog", sender: self)
                
                
               
            }
            else {
                print(error?.localizedDescription ?? "error")
            }
          // ...
        }
        
        
        
    }
    
    @IBAction func registerhit(_ sender: UIButton) {
        
        Auth.auth().createUser(withEmail: emailTextFeild.text!, password: passwordTextFeild.text!) { authResult, error in
            if error == nil {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "profileSetUpSegue", sender: self)
                }
            }
            else{
                print(error?.localizedDescription as Any)
            }
           
        }
    }
    
}

