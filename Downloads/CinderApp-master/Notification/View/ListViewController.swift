//
//  ListViewController.swift
//  Struck
//
//  Created by MacBook Pro on 15/11/2018.
//  Copyright © 2018 FatemaShams. All rights reserved.


import UIKit
import Firebase
import CoreLocation


class ListViewController: UIViewController {
    
    
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userResultInformation: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    
    @IBAction func logOut(_ sender: Any) {
        
        self.appDelegate.isLogged = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        // table
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 130
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        
        self.tableView.reloadData()
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        // refresh the users lisr before lunching
        super.viewDidAppear(animated)
        if let tbc = self.tabBarController as? MyCustomTabController {
            tbc.Users.removeAll()
        }
        findUserAround()
    }
    
    
    // fetch data from database and store it as "UserAround" data model
    func findUserAround (){
        
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        
        
        self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            
            //iterate the first level
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                
                let allUserValue = child.value as! NSDictionary
                //iterate over the second level
                for i in allUserValue.allKeys {
                    // save value for a single user
                    let singleUserValue = allUserValue.value(forKey: i as! String ) as! NSDictionary
                    let UID = singleUserValue.value(forKey: "UID" ) as! String
                    let lat = singleUserValue.value(forKey: "lat" ) as! Double
                    let long = singleUserValue.value(forKey: "long" ) as! Double
                    let distanseFromUser = singleUserValue.value(forKey: "distanseFromUser" ) as! Double
                    let petName = singleUserValue.value(forKey: "petName" ) as! String
                    
                    /*  Compare between the current user and every other user in the database
                        and calcuted the number of meters
                     */
                    if let tabBarGlobalVariables = self.tabBarController as? MyCustomTabController {
                        let myLocationCoordinates = CLLocation(
                            latitude: tabBarGlobalVariables.selectedLat,
                            longitude: tabBarGlobalVariables.selectedLong )
                        
                        let userInstanceLocationCoordinates = CLLocation(latitude: lat , longitude: long)
                        let distanceInMeters = myLocationCoordinates.distance(from: userInstanceLocationCoordinates)
                        
                        // if its less than 100
                        if distanceInMeters < 100 {
                            // not equal the value of the current user (There are better approaches)
                            if(distanceInMeters != 0) {
                                tabBarGlobalVariables.Users.append( UserAround(petName: petName, lat: lat, long: long, distanseFromUser: distanceInMeters , UID: UID) )
                            }
                            self.tableView.reloadData()
                        }
                    }
                    self.tableView.reloadData()
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }

    }
    
    
}



extension ListViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        if let tbc = self.tabBarController as? MyCustomTabController {
            count = tbc.Users.count
        }
        
        if(count == 0){
            self.userResultInformation.isHidden = false
        }else{
            self.userResultInformation.isHidden = true
        }
        
        return count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath) as! ListTableViewCell
        if let tbc = self.tabBarController as? MyCustomTabController {
            cell.label1.text! = "\(tbc.Users[indexPath.row].petName) is only \(Int(tbc.Users[indexPath.row].distanseFromUser)) meters away from u! "
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
    
    
    
    // swap function
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        
        let rateAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Match" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            let rateMenu = UIAlertController(title: nil, message: "Match!", preferredStyle: .actionSheet)
            let appRateAction = UIAlertAction(title: "Send a request", style: UIAlertAction.Style.default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            rateMenu.addAction(appRateAction)
            rateMenu.addAction(cancelAction)
            
            self.present(rateMenu, animated: true, completion: nil)
        })
        
        return [rateAction]
    }
    
    
}
