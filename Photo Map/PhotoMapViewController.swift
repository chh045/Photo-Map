//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

@available(iOS 10.0, *)
class PhotoMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, LocationsViewControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cameraButton: UIButton!
    var locationManager : CLLocationManager!
    var lastLocation : CLLocationCoordinate2D!
    var thumbnailImageByAnnotation = [NSValue : UIImage]()
    var pickedImage: UIImage!
    

    override func viewDidLoad() {
        super.viewDidLoad()


        
        // Do any additional setup after loading the view.
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        // One degree of latitude is approximately 111 kilometers (69 miles) at all times.
        // San Francisco Lat, Long = latitude: 37.783333, longitude: -122.416667
        //let mapCenter = CLLocationCoordinate2D(latitude: 37.783333, longitude: -122.416667)
        //let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        //let region = MKCoordinateRegion(center: mapCenter, span: mapSpan)
        // Set animated property to true to animate the transition to the region
        //mapView.setRegion(region, animated: false)
        
        //addPin()

    }

    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {

        let annotation = MKPointAnnotation()
        let lat = CLLocationDegrees(latitude)
        let lag = CLLocationDegrees(longitude)
        let locationCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lag)
        annotation.coordinate = locationCoordinate
        //annotation.title = "Geisel Library"
        annotation.title = String(describing: "\(lat)")
        mapView.addAnnotation(annotation)
    }
    
    func addPin() {
        let annotation = MKPointAnnotation()
        let locationCoordinate = CLLocationCoordinate2D(latitude: 32.880916, longitude: -117.237305)
        annotation.coordinate = locationCoordinate
        //annotation.title = "Geisel Library"
        annotation.title = String(describing: "\(locationCoordinate.latitude)")
        mapView.addAnnotation(annotation)
    }
    
    func addAnnotationWithThumbnailImage(thumbnail: UIImage) {
        let annotation = MKPointAnnotation()
        var locationCoordinate = CLLocationCoordinate2DMake(32.880916, -117.237305)
        annotation.coordinate = locationCoordinate
        
        thumbnailImageByAnnotation[NSValue(nonretainedObject: annotation)] = thumbnail
        mapView.addAnnotation(annotation)
    }
    
    func getOurThumbnailForAnnotation(annotation : MKAnnotation) -> UIImage?{
        return thumbnailImageByAnnotation[NSValue(nonretainedObject: annotation)]
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.first as? CLLocation
        lastLocation = location?.coordinate
    }
    
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        let annotations = [mapView.userLocation, view.annotation] as! [MKAnnotation]
        mapView.showAnnotations(annotations, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let annotations = [mapView.userLocation]
        mapView.showAnnotations(annotations, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            if let title = annotation.title! {
                print("Tapped \(title) pin")
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        // Add the image you stored from the image picker
        imageView.image = pickedImage
        
        return annotationView
    }
    
    /*
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        let reuseID = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            /// show the callout "bubble" when annotation view is selected
            annotationView?.canShowCallout = true
        }
        
        
        
        /// Set the "pin" image of the annotation view
        let pinImage = UIImage(named: "test")
        let resizeRenderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        resizeRenderImageView.layer.borderColor = UIColor.white.cgColor
        resizeRenderImageView.layer.borderWidth = 3.0
        resizeRenderImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeRenderImageView.image = pinImage
        UIGraphicsBeginImageContextWithOptions(resizeRenderImageView.frame.size, false, 0.0)
        resizeRenderImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        annotationView?.image = thumbnail
        
        /// Add an info button to the callout "bubble" of the annotation view
        let rightCalloutButton = UIButton(type: .detailDisclosure)
        annotationView?.rightCalloutAccessoryView = rightCalloutButton
        
        /// Add image to the callout "bubble" of the annotation view
        //let image = UIImage(named: "founders_den")
        let leftCalloutImageView = UIImageView(image: thumbnail)
        annotationView?.leftCalloutAccessoryView = leftCalloutImageView
        
        return annotationView
        
        //---------------------------------------------------------------
        //annotationView.image = getOurThumbnailForAnnotation(annotation)
        //return annotationView
    }
 */
    
    
//    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
//        let lattitude = view.annotation?.coordinate.latitude
//        let longitude = view.annotation?.coordinate.longitude
//        guard let appleMapsURL = URL(string: "http://maps.apple.com/?q=\(lattitude),\(longitude)") else { return }
//        UIApplication.shared.open(appleMapsURL, options: [:], completionHandler: nil)
//    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        pickedImage = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "tagSegue", sender: nil)
    }
    
    
    @IBAction func onTapCameraButton(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.camera
//        
        self.present(vc, animated: true, completion: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let locationsViewController = segue.destination as! LocationsViewController
        locationsViewController.delegate = self
    }
    

}
