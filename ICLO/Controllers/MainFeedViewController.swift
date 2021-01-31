//
//  MainFeedViewController.swift
//  ICLO
//
//  Created by Henit Work on 23/01/21.
//

import UIKit
import Firebase
import FirebaseStorage
import Kingfisher
import FirebaseFirestore
import SearchTextField


class MainFeedViewController: UIViewController {
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var chattersTableView: UITableView!
    var images : [UIImage] = []
    
   

    let db = Firestore.firestore()

    @IBOutlet weak var topbarview: UIView!
    @IBOutlet weak var chatterstableview: UITableView!
    @IBOutlet weak var Profilesearchfeild: SearchTextField!
    var profilelist : [SearchTextFieldItem] = []
    var examplerImage : UIImageView? = nil
    var rootcount = 1
    var chatterlist : [Chatters] = []
    var neo = ""
    var neomail = ""
    var neoimage : UIImage = #imageLiteral(resourceName: "2189")

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.loaddata()
            
        }
    
        
        topbarview.layer.cornerRadius = 20
        Profilesearchfeild.attributedPlaceholder = NSAttributedString(string: "            Enter Number to Search",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        chatterstableview.layer.cornerRadius = 20
        Profilesearchfeild.theme = SearchTextFieldTheme.darkTheme()

        // Modify current theme properties
        Profilesearchfeild.theme.font = UIFont.systemFont(ofSize: 15)
        Profilesearchfeild.theme.bgColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        Profilesearchfeild.theme.borderColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        Profilesearchfeild.theme.separatorColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        Profilesearchfeild.theme.cellHeight = 60
        Profilesearchfeild.theme.fontColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        Profilesearchfeild.theme.subtitleFontColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        
        Profilesearchfeild.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            let item = filteredResults[itemPosition]
            print("Item at position \(itemPosition): \(item.title)")
            let p = Chatters.init(email: item.title, name: item.subtitle ?? "No name")
            self.chatterlist.append(p)
            self.db.collection((Auth.auth().currentUser?.email)!).document("chatterlist").collection("chatters").addDocument(data: ["email" : item.title , "name" : item.subtitle!])
            self.db.collection(item.title).document("chatterlist").collection("chatters").addDocument(data: ["email" : (Auth.auth().currentUser?.email)! , "name" : item.subtitle!])
            
            
            // Do whatever you want with the picked item
            DispatchQueue.main.async {
                self.chatterstableview.reloadData()
            }
        }
        chatterstableview.dataSource = self
        chatterstableview.register(UINib.init(nibName: "ChatterRows", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        chatterstableview.rowHeight = 90
        chatterstableview.allowsSelection = true
        chatterstableview.delegate = self
        
       
       
        
        
        
       
     
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.db.collection("userList").getDocuments { (query, error) in
                if error == nil {
                    let Userlist = query?.documents
                    for doc in Userlist! {
                        let p = doc["email"] as! String
                        let q = doc["name"] as! String
                        
                        let item = SearchTextFieldItem.init(title: p, subtitle: q)
                        self.profilelist.append(item)
                        
                    }
                    self.Profilesearchfeild.filterItems(self.profilelist)
                    
                            
            }
           
                
            }
            
            
            
            self.db.collection((Auth.auth().currentUser?.email)!).getDocuments { (querysnapshot, error) in
                self.userimage.layer.cornerRadius = self.userimage.frame.height/2
                self.userimage.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                self.userimage.layer.borderWidth = 0.5
                let data = querysnapshot!.documents
                for doc in data {
                    let imageurl = doc["photo"]
                    let url = URL.init(string: imageurl as! String)
                    let imageresourse = ImageResource.init(downloadURL: url!)
                    self.userimage.kf.setImage(with: imageresourse) { (result) in
                       print("Success")
                    }
                    
                    
                }
            }
            
            
        }
        

        // Do any additional setup after loading the view.
    }
    
//    @IBAction func logoutpressed(_ sender: UIButton) {
//        do {
//            try Auth.auth().signOut()
//            print("signedout")
//            performSegue(withIdentifier: "gotostart", sender: self)
//
//        } catch let signOutError as NSError {
//          print ("Error signing out: %@", signOutError)
//        }
//
//    }
    
    
    
    
    func loaddata(){
        
        self.db.collection((Auth.auth().currentUser?.email)!).document("chatterlist").collection("chatters").addSnapshotListener { (query, error) in
            self.chatterlist = []
            if error == nil {
                if let snapshotDocuments = query?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let mail = data["email"] as? String, let chatter = data["name"] as? String {
                            let newchatter = Chatters.init(email: mail, name: chatter)
                            self.chatterlist.append(newchatter)
                            
                            DispatchQueue.main.async {
                                self.chatterstableview.reloadData()
                            }
                            
            }
        }
        
    }

    
    
    
    }
        }
    }
    
    
}
extension MainFeedViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatterlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ChatterRows
        rootcount = rootcount + 1
        cell.titleLable.text = chatterlist[indexPath.row].name
        cell.subtitle.text = chatterlist[indexPath.row].email
        self.db.collection(chatterlist[indexPath.row].email).getDocuments { (querysnapshot, error) in
            
            let data = querysnapshot!.documents
            for doc in data {
                let imageurl = doc["photo"]
                let url = URL.init(string: imageurl as! String)
                let imageresourse = ImageResource.init(downloadURL: url!)
                cell.profileImage.kf.setImage(with: imageresourse)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.images.append(cell.profileImage.image ?? #imageLiteral(resourceName: "2189"))
                }
                
            }
        }
        
        
        
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ChatViewController{
            vc.identity = neo
            vc.subtitle = neomail
            vc.sendimage = neoimage
            
        }
        
    }
    
}
    
            
        
    extension MainFeedViewController : UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            neo = chatterlist[indexPath.row].name
            neomail = chatterlist[indexPath.row].email
            neoimage = images[indexPath.row]
            
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "tothechat",sender: self)
                
            }
            
            
            
        }
        
        
    }
    

   
    

   

    

