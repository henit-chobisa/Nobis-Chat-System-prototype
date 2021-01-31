//
//  SignupViewController.swift
//  ICLO
//
//  Created by Henit Work on 23/01/21.
//

import UIKit
import Firebase
import FirebaseFirestore

class SignupViewController: UIViewController, UINavigationControllerDelegate {
    var activity = UIActivityIndicatorView()
    let db = Firestore.firestore()
    
   
   

    
 
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var submitbutton: UIButton!
    @IBOutlet weak var namefeild: UITextField!
    @IBOutlet weak var phonefeild: UITextField!
    @IBOutlet weak var agefeild: UITextField!
    @IBOutlet weak var descriptionfeild: UITextField!
    var imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.userImage.layer.cornerRadius = self.userImage.frame.height/2
            self.userImage.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            self.userImage.layer.borderWidth = 5
            
            self.submitbutton.layer.cornerRadius = 10
            self.submitbutton.layer.borderWidth = 2
            self.submitbutton.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            self.frametextfeild(for: self.namefeild)
            self.frametextfeild(for: self.phonefeild)
            self.frametextfeild(for: self.agefeild)
            self.frametextfeild(for: self.descriptionfeild)
            
        }
        
     
        

        // Do any additional setup after loading the view.
    }
    func frametextfeild(for textfeild : UITextField ){
        
        textfeild.layer.cornerRadius = 10
        textfeild.layer.borderWidth = 1
        textfeild.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }
    
    @IBAction func buttonpicker(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker , animated: true)
    }
    
    
    @IBAction func submitpressed(_ sender: UIButton) {
        activity.startAnimating()
        let data = userImage.image?.jpegData(compressionQuality: 0.4)
        
        let imageReference = Storage.storage().reference().child((Auth.auth().currentUser?.email)!).child("\(String(describing: Auth.auth().currentUser?.email)) profile Image")
        imageReference.putData(data!, metadata: nil) { (meta, error2) in
            imageReference.downloadURL { (url, error) in
                self.handwithdatabase(k: url!.absoluteString)
              
            }
        }
        activity.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.dismiss(animated: true)
            
        }
      
        }
        
     
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    
    
    func handwithdatabase(k : String){
        self.db.collection("userList").addDocument(data: ["email" : Auth.auth().currentUser?.email! as Any , "name" : self.namefeild.text ?? "No Name" , "photo" : k])
        
        self.db.collection((Auth.auth().currentUser?.email)!).addDocument(data: [
                                                                            "Email" : Auth.auth().currentUser?.email!,
                                                                            "Name" : self.namefeild.text ?? "No Name",
                                                                            "phoneNumber" : self.phonefeild.text ?? "No phone number",
                                                                            "age" : self.agefeild.text ?? "Not mentioned",
                                                                            "description" : self.descriptionfeild.text ?? "" ,
                                                                            "photo" : k ])

    }

}

extension SignupViewController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        dismiss(animated: true)
        userImage.image = image
        
    }
   
       
        
    
}
