//
//  MapVC.swift
//  Drinks
//
//  Created by maninder on 10/4/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController,MKMapViewDelegate {

    @IBOutlet var lblLocationName: UILabel!
    @IBOutlet var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 8000
    
    
    var returningDelegate : MSSelectionCallback? = nil
    var selectedFiltered : FilterInfo = FilterInfo()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationItem.hidesBackButton = true
        let btnLeftBar:UIBarButtonItem = UIBarButtonItem.init(image:UIImage(named: "backIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(MapVC.btnCrossAction))
        
        let btnRightBar:UIBarButtonItem = UIBarButtonItem.init(title: NSLocalizedString("Save", comment: ""), style: UIBarButtonItemStyle.plain, target: self, action: #selector(MapVC.actionBtnDonePressed))
        
        self.navigationItem.rightBarButtonItem = btnRightBar
        self.navigationItem.leftBarButtonItem = btnLeftBar
        
        self.navTitle(title: "Map" as NSString, color: UIColor.black , font:  FontRegular(size: 18))

        
        mapView.delegate = self
        mapView.subviews[1].removeFromSuperview()
        mapView.showsUserLocation = true
        self.setCurrentLocationInCentre()
        
        
        
       
        //mapView.
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    @IBAction func actionBtnCurrentLocation(_ sender: UIButton) {
        
        self.setCurrentLocationInCentre()
        
    }
    
    func actionBtnDonePressed(){
        
        self.returningDelegate?.moveWithSelection!(selected: selectedFiltered)
        self.navigationController?.popViewController(animated: true)
    }
    
    func btnCrossAction()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- MapView Delegates
    //MARK:-
    
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
       // print(mapView.centerCoordinate)
        self.getlocationName(locationCordinates: mapView.centerCoordinate)
        
        
    }
    
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        
        
        
    }
    
    
    func setCurrentLocationInCentre()
    {
    
        if appDelegate().currentlocation != nil
        {
            
              self.selectedFiltered.filterLocationName = appDelegate().appLocation
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(appDelegate().currentlocation!.coordinate, self.regionRadius * 3.2, self.regionRadius * 3.2)
              self.mapView.setRegion(coordinateRegion, animated: true)
            lblLocationName.text = appDelegate().myLocationName
        }
    }
    
    
    
    
    func getlocationName(locationCordinates : CLLocationCoordinate2D){
        
        
        let location = CLLocation(latitude: locationCordinates.latitude, longitude: locationCordinates.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            var addressCurrent = String()
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                
                if let dictAddress = pm.addressDictionary as? Dictionary <String, AnyObject>{
                    let subLocatlity = dictAddress["SubLocality"] as? String
                    if subLocatlity != nil{
                        addressCurrent = subLocatlity!
                    }
                    
                    let cityName = dictAddress["City"] as? String
                    if cityName != nil{
                        addressCurrent = addressCurrent + ", " + cityName!
                    }
                }
                self.selectedFiltered.filterLocationName = GroupLocation(name: addressCurrent, lat: "\(location.coordinate.latitude)", long: "\(location.coordinate.longitude)")
                self.lblLocationName.text = addressCurrent
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })

    }
}

//    let coordinateRegion = MKCoordinateRegionMakeWithDistance(appDelegate().currentlocation!.coordinate,
//                                                              self.regionRadius * 3.2, self.regionRadius * 3.2)
//    self.mapView.setRegion(coordinateRegion, animated: true)}
