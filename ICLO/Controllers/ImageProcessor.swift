//
//  ImageProcessor.swift
//  ICLO
//
//  Created by Henit Work on 23/01/21.
//

import Foundation
import UIKit
import FirebaseStorage
import Firebase


struct ImageProcessor {
    
    
    
    mutating func IconvertToURL1child (imageview : UIImageView, ImageName : String , compression : CGFloat , child1 : String , child2 : String)  {
        
        let image = imageview.image
        let data = image?.jpegData(compressionQuality: compression )
        let imageReference = Storage.storage().reference().child(child1).child(ImageName)
        imageReference.putData( data!, metadata: nil) { (meta, error) in
            if error == nil {
                imageReference.downloadURL { (url, error) in
                    if error == nil {
                        if let url = url {
                            
                          
                            
                        }else {
                            print(error?.localizedDescription as Any)
                            
                        }
                        
                    }
                }
            }
            else{
                print(error!)
            }
        }
    
     
        
    }
    
    func urlstringfetcher(for url : URL) -> String {
        return url.absoluteString
    }
    
}
