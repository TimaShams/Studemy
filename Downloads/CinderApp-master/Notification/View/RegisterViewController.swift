//
//  WelcomeViewController.swift
//  Struck
//
//  Created by MacBook Pro on 15/11/2018.
//  Copyright © 2018 FatemaShams. All rights reserved.
//  This file created for the fisrt view in this demo application


import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle?
    var isAnonymous = Bool()
    var uid = String()
    
    static var FirebaseToken : String? {
        return Messaging.messaging().fcmToken
    }
    
    @IBOutlet weak var goToMap: CustomButton!
    @IBOutlet weak var setPetName: UITextField!
    @IBOutlet weak var savePetName: UIButton!
    @IBOutlet weak var registerYourNAme: UILabel!
    //@IBOutlet weak var testFunction: UIButton!
    lazy var functions = Functions.functions()
    
    

    
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.ref.child("Notifications")
        self.hideKeyboardWhenTappedAround()
        goToMap.isHidden = true
    }
    

    
    // Save the pet name in the database
    @IBAction func performSave(_ sender: Any) {
        
        
        Auth.auth().signInAnonymously() { (user, error) in
            if let aUser = user {
                
                // empty field hundelling
                if(self.setPetName.text?.isEmpty == true)
                {
                    let alert = UIAlertController(title: "-_-", message: "Did u forgot ur pet's name!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
                
                
                let userID = Auth.auth().currentUser?.uid
                let insertData : [String : Any ] = [ "UID"              : userID! ,
                                                     "petName"           : self.setPetName.text ,
                                                     "distanseFromUser"  : 0 ,
                                                     "lat"               : 0 ,
                                                     "long"              : 0 ]
                
                // data insertion
                self.ref.child("users").child(userID!).child("UserInfo").setValue(insertData )
                
                



            }
        }
        
        
     
        self.goToMap.isHidden = false
        self.registerYourNAme.isHidden = true
        self.setPetName.isHidden = true
        self.savePetName.isHidden = true
        self.appDelegate.isLogged = true
        
    }
    
    
}
