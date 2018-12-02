



import UIKit
import Firebase
import CoreLocation

// my data
class UserAround: NSObject {
    var petName: String
    var distanseFromUser: Double
    var lat: Double
    var long: Double
    var UID: String
    
    init(petName: String , lat : Double , long : Double , distanseFromUser : Double , UID : String ) {
        self.petName = petName
        self.lat = lat
        self.long = long
        self.UID = UID
        self.distanseFromUser = distanseFromUser
        
        super.init()
    }
    
}
