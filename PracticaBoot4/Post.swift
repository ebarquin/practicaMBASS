//
//  Post.swift
//  PracticaBoot4
//
//  Created by Eugenio Barquín on 16/4/17.
//  Copyright © 2017 COM. All rights reserved.
//

import Foundation
import Firebase

class Post: NSObject {
    var title : String
    var postText: String
    var photoURL: String
    var published: Bool
    var user: String
    var email: String
    
    init(title: String, postText: String, published: Bool, user: String, email: String) {
        self.title = title
        self.postText = postText
        self.photoURL = ""
        self.published = published
        self.user = user
        self.email = email
    }
    
    init(snap: FIRDataSnapshot?) {
        
        title = (snap?.value as? [String: Any])?["title"] as! String
        postText = (snap?.value as? [String: Any])?["postText"] as! String
        photoURL = (snap?.value as? [String: Any])?["photourl"] as! String
        published = (snap?.value as? [String: Any])?["published"] as! Bool
        user = (snap?.value as? [String: Any])?["user"] as! String
        email = (snap?.value as? [String: Any])?["email"] as! String
        
    }
    
    private class func uploadImageToStorage(image: Data, completion: @escaping (String) -> ()) {
        let storage = FIRStorage.storage().reference()
        let imageStorage = storage.child("post")
        let imageUID = imageStorage.child("\(NSUUID().uuidString).png")
        imageUID.put(image, metadata: nil) { (metadata, error) in
            
            if let url = metadata?.downloadURL()?.absoluteString {
                completion(url)
            }
        }
    }
    
    class func uploadPostToFB(post: Post, image: Data) {
        uploadImageToStorage(image: image) { (photo) in
            
            
            post.photoURL = photo
            let postsRef = FIRDatabase.database().reference().child("posts")
            let key = postsRef.childByAutoId().key
            let postInFB = ["\(key)": post]
            postsRef.updateChildValues(postInFB)
            
            
        }
        
    }
    
}
