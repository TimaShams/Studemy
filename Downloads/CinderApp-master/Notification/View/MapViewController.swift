

import UIKit
import MapKit
import Firebase



class MapViewController: UIViewController , CLLocationManagerDelegate {
    
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle?

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    // setup
    let locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    var pickedLocation  = CLLocationCoordinate2D()
    let regionRadius: CLLocationDistance = 100
    let newPin = MKPointAnnotation()

    
    @IBAction func logOut(_ sender: Any) {
        
        self.appDelegate.isLogged = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
        
    }
    
    
    @IBOutlet weak var mapView: MKMapView!
  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ref = Database.database().reference()

        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
        mapView.showsUserLocation = true
        mapView.setShadow()
        mapView.delegate = self

    
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.mapLongPress(_:))) // colon needs to pass through info
        longPress.minimumPressDuration = 0.5 // in seconds
        //add gesture recognition
        mapView.addGestureRecognizer(longPress)
        
        
    }
    
    
    
    
    // Keep the user tracking
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        currentLocation.latitude = locValue.latitude
        currentLocation.longitude = locValue.longitude
        
    }
    

    // place the map center
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    // prepration
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
      //  checkLocationAuthorizationStatus
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    
    
    
    
    
}



extension MapViewController: MKMapViewDelegate {
    
    
    
    //GeoFence
    func drawGeoFence(radius: String){

        
        let center = CLLocationCoordinate2D(latitude: pickedLocation.latitude, longitude: pickedLocation.longitude)
        let circle = MKCircle(center: center, radius: Double(radius)!)
        
        self.mapView.addOverlay(circle)
        
    }
    
    // Circle draw
    func mapView(_ mapView: MKMapView,rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
        circleRenderer.strokeColor = UIColor.blue
        circleRenderer.lineWidth = 1
        return circleRenderer
    }
    
    
    
    // for long press
    @objc func mapLongPress(_ recognizer: UIGestureRecognizer) {
        
        
        let touchedAt = recognizer.location(in: self.mapView)
        pickedLocation = mapView.convert(touchedAt, toCoordinateFrom: self.mapView)
       // let touchedAtCoordinate :  // will get coordinates
        let newPin = MKPointAnnotation()
        newPin.coordinate = pickedLocation
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(newPin)
        
        // set values in the global
        if let tabControllerGlobalVariable = self.tabBarController as? MyCustomTabController {
            tabControllerGlobalVariable.selectedLat  = newPin.coordinate.latitude
            tabControllerGlobalVariable.selectedLong  = newPin.coordinate.longitude
        }
        
        
        // update to the new lat,long
        let userID = Auth.auth().currentUser?.uid

        let update1 = Database.database().reference().root.child("users").child(userID!).child("UserInfo").updateChildValues(["lat": newPin.coordinate.latitude])
        let update2 = Database.database().reference().root.child("users").child(userID!).child("UserInfo").updateChildValues(["long": newPin.coordinate.longitude])

        
        // for geofence
        if(mapView.overlays.isEmpty)
        {
            self.drawGeoFence(radius: "100")

        }else
        {
            mapView.removeOverlay(mapView.overlays.first!)
            self.drawGeoFence(radius: "100")

        }
        
    }
    
}



