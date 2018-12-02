//
//  MyCustomTabController.swift
//  Notification
//
//  Created by MacBook Pro on 17/11/2018.
//  Copyright © 2018 FatemaShams. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Firebase



class MyCustomTabController: UITabBarController {
    
    var myInformation: [String: AnyObject]?
    var Users = [UserAround]()
    var selectedLat = Double()
    var selectedLong = Double()
}
