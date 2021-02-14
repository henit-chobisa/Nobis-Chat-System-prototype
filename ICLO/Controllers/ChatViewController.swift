//
//  ChatViewController.swift
//  ICLO
//
//  Created by Henit Work on 25/01/21.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import Kingfisher



class ChatViewController: UIViewController {
    var identity = ""
    var subtitle = ""
	var sendimage : UIImage = #imageLiteral(resourceName: "2189")
	
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
 
    

    @IBOutlet weak var gobutton: UIImageView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var topBarProfileImage: UIImageView!
    @IBOutlet weak var lowerBarCamera: UIImageView!
    @IBOutlet weak var lowerbar: UIView!
    @IBOutlet weak var mailspace: UILabel!
    let db = Firestore.firestore()
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var textfeild: UITextView!
    @IBOutlet weak var tableview: UITableView!
    
    var messages : [MessageContent] = []
	var messagesbysender : [MessageContent] = []
    
	override func viewWillAppear(_ animated: Bool) {
        indicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.indicator.stopAnimating()
            self.indicator.alpha = 0
        }
	}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
      
        
        
        DispatchQueue.main.async {
            self.topBarView.layer.cornerRadius = 15
            self.topBarProfileImage.layer.cornerRadius = self.topBarProfileImage.frame.height/2
            self.lowerBarCamera.layer.cornerRadius = self.lowerBarCamera.frame.height/2
            self.lowerbar.layer.cornerRadius = 20
            
        }
        tableview.register(UINib(nibName: "MessageCellTableViewCell", bundle: nil), forCellReuseIdentifier: "messageBubble")
		tableview.register(UINib(nibName: "senderTableViewCell", bundle: nil), forCellReuseIdentifier: "senderbubble")
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.loadMessages()
		}
        
        self.name.text = identity
        self.mailspace.text = subtitle
        
        DispatchQueue.main.async {
            self.db.collection(self.subtitle).getDocuments { (querysnapshot, error) in
                let data = querysnapshot!.documents
                for doc in data {
                    let imageurl = doc["photo"]
                    let url = URL.init(string: imageurl as! String)
                    let imageresourse = ImageResource.init(downloadURL: url!)
                    self.topBarProfileImage.kf.setImage(with: imageresourse) { (result) in
                       print("Success")
                    }
					
            }
        }
        }
        tableview.rowHeight = 52
        
        
        
        
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backbutton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
	
	//MARK: - loading messages
	
    func loadMessages() {
        
        db.collection((Auth.auth().currentUser?.email!)!).document("chatterlist").collection("chatters").document(subtitle).collection("messages")
            .order(by: "time")
            .addSnapshotListener { (querySnapshot, error) in
            
                self.messages = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data["sender"] as? String, let messageBody = data["message"] as? String {
                            let newMessage = MessageContent(sender: messageSender, message: messageBody)
                            self.messages.append(newMessage)
                            
                         
                        }
                    }
                }
            }
				self.db.collection(self.subtitle).document("chatterlist").collection("chatters").document((Auth.auth().currentUser?.email!)!).collection("messages")
					.order(by: "time")
					.addSnapshotListener { (querySnapshot, error) in
					
						self.messages = []
					
					if let e = error {
						print("There was an issue retrieving data from Firestore. \(e)")
					} else {
						if let snapshotDocuments = querySnapshot?.documents {
							for doc in snapshotDocuments {
								let data = doc.data()
								if let messageSender = data["sender"] as? String, let messageBody = data["message"] as? String {
									let newMessage = MessageContent(sender: messageSender, message: messageBody)
									self.messages.append(newMessage)
									
									DispatchQueue.main.async {
										   self.tableview.reloadData()
										let indexPath = IndexPath(row:  self.messages.count - 1, section: 0)
										self.tableview.scrollToRow(at: indexPath, at: .top, animated: false)
									}
								}
							}
						}
					}
				}
        }
		
	
		
		
    }
    
	//MARK: - sending messages
    
    @IBAction func videoCall(_ sender: UIButton) {
    }
    
    
    
    @IBAction func audioCall(_ sender: UIButton) {
    }
    
    
    
    
    
	
    @IBAction func gobuttonpressed(_ sender: UIButton) {
	
        if let messageBody = textfeild.text, let messageSender = Auth.auth().currentUser?.email {
			self.db.collection((Auth.auth().currentUser?.email!)!).document("chatterlist").collection("chatters").document(subtitle).collection("messages").addDocument(data: [
                "sender": messageSender,
                "message": messageBody,
                "time": Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                    
                    DispatchQueue.main.async {
                         self.textfeild.text = ""
                    }
                }
            }
			
			
			self.db.collection(subtitle).document("chatterlist").collection("chatters").document((Auth.auth().currentUser?.email!)!).collection("messages").addDocument(data: [
				"sender": messageSender,
				"message": messageBody,
				"time": Date().timeIntervalSince1970
			]) { (error) in
				if let e = error {
					print("There was an issue saving data to firestore, \(e)")
				} else {
					print("Successfully saved data.")
					
					DispatchQueue.main.async {
						 self.textfeild.text = ""
					}
				}
			}
        }

    }
    
    
 

}
extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return messages.count + messagesbysender.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
		
        
        //This is a message from the current user.
        if message.sender == Auth.auth().currentUser?.email {
			let cell = tableview.dequeueReusableCell(withIdentifier: "senderbubble", for: indexPath) as! senderTableViewCell
			let p = ""
			_ = ""
			cell.message.text = "\(p)  \(message.message)   "
			
            
            cell.senderImage.isHidden = false
            cell.mainview.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
			
            cell.message.textAlignment = .right
			cell.message.sizeToFit()
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
				
				cell.message.frame.size = CGSize.init(width: cell.message.frame.width + 40, height: cell.message.frame.height + 30 )
			}
			
			
//			cell.message.clipsToBounds = true
			cell.message.layer.cornerRadius = cell.message.frame.width/14
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
				cell.senderImage.image = self.topBarProfileImage.image
			}
			
			return cell
			
			
            
        }
        //This is a message from another sender.
        else {
			let cell = tableview.dequeueReusableCell(withIdentifier: "messageBubble", for: indexPath) as! MessageCellTableViewCell
			cell.message.text = "\(message.message)    "
			
			
            cell.userImage.isHidden = false
            
            cell.mainview.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            cell.message.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.message.textAlignment = .natural
            cell.message.sizeToFit()
//			cell.mainview.sizeToFit()
			cell.mainview.frame.size = CGSize.init(width: cell.message.frame.width + 30, height: cell.message.frame.height + 20 )
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
				cell.userImage.image = self.sendimage
			}
			
			return cell
			
            
            
        }
	
      
      
        
    }
}


