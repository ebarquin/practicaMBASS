//
//  MainTimeLine.swift
//  PracticaBoot4
//
//  Created by Juan Antonio Martin Noguera on 23/03/2017.
//  Copyright © 2017 COM. All rights reserved.
//

import UIKit
import Firebase

class MainTimeLine: UITableViewController {

    var model : [Post] = []
    let cellIdentifier = "POSTSCELL"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllPublishedPostsFromFB()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        FIRAnalytics.setScreenName("MainTimeLine", screenClass: "Main")
        
        self.refreshControl?.addTarget(self, action: #selector(hadleRefresh(_:)), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func handleLogout(_ sender: Any) {
        
        do{
            
            try FIRAuth.auth()?.signOut()
            
        } catch let error {
            print(error)
            
            
        }
        
    }

    func hadleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return model.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        cell.textLabel?.text = model[indexPath.row].title

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ShowRatingPost", sender: indexPath)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowRatingPost" {
            let vc = segue.destination as! PostReview
            // aqui pasamos el item selecionado
        }
    }

    func getAllPublishedPostsFromFB() {
        var posts: [Post] = []
        
        let rootRef = FIRDatabase.database().reference().child("posts")
        rootRef.observe(FIRDataEventType.value, with: { ( snap ) in
            
            for postFB in snap.children {
                
                let post = Post(snap: (postFB as! FIRDataSnapshot))
                posts.append(post)
                
            }
            
            self.model = posts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        }) { (error) in
            print(error)
        }
        
    }
    

    
    

}
