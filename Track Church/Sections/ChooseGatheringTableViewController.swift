//
//  ChooseGatheringTableViewController.swift
//  Track Church
//
//  Created by Lee Watkins on 2017/10/01.
//  Copyright © 2017 Lee Watkins. All rights reserved.
//

import UIKit
import Firebase

class ChooseGatheringTableViewController: UITableViewController {

    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        guard let userId = Auth.auth().currentUser?.uid else {
            debugPrint("Not logged in yet")
            return
        }
        ref.child("users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? [String : AnyObject] else { return }
            guard let church = value["church"] as? [String : AnyObject], let churchId = church["id"] as? String, let campus = value["campus"] as? [String : AnyObject], let campusId = campus["id"] as? String else { return }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
//    func

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    @IBAction func logOutTapped(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
}
