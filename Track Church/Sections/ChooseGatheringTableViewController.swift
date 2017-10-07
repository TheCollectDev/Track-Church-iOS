import UIKit
import Firebase

class ChooseGatheringTableViewController: UITableViewController {
    
    var model: ChooseGatheringViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = ChooseGatheringViewModel()
        model.gatheringsRetrieved = gatheringsUpdated(_:)
    }
    
    func gatheringsUpdated(_ gatherings: [Gathering]) -> Void {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.gatherings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gatheringCell", for: indexPath)
        cell.textLabel?.text = model.gatherings[indexPath.row].name
        return cell
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
