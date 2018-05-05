//
//  ViewController.swift
//  cpe190
//
//  Created by Ellis Nguyen on 2/27/18.
//  Copyright © 2018 Ellis Nguyen. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationMan : CLLocationManager!
    var arr: [String] = []
    var arrPoints: [point] = []
    var arrThresh: [Int] = []
    var arrPath: [MKPolyline] = []
    let nameOfFile = "analyzed-5"
    let smallRange = 3
    let medRange = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView?.showsUserLocation = true
        
        
        
       toArray(s: readCsv())
       toFormat()
       createPath()
       drawIt()

    }
    
    func drawIt(){
        
        for i in arrPath{
            print(i.title)
            mapView.add(i)
        }
        
    }
    
    
    func createPath(){
        
        var count = 0
        var index = 2
        var indexT = 0
        var p : [CLLocationCoordinate2D] = []
        var path = MKPolyline()
        
        for c in arrPoints{
            
            print(c)
            
            if(index == 1){
                print(index)
                p.append(c.coordinate)
                print(p.debugDescription)
                if(count == 0){
                    path = MKPolyline(coordinates: p, count: p.count)
                    if(arrThresh[indexT] < smallRange){
                        path.title = "GOOD"
                    }//GUD
                    else if(arrThresh[indexT] > smallRange && arrThresh[indexT] < medRange){
                        path.title = "MED"
                    }//MED
                    else{
                        path.title = "BAD"
                    }//BAD
                    print("HTIS IS CUR PAth\(path)")
                    arrPath.append(path)
                    p.removeAll()
                    print("THIS IS UR THRESH PATH = \(arrPath)")
                    print(" INDEX T: \(indexT)")
                    count = 1
                    indexT += 1
                }
                else{
                    p.append(c.coordinate)
                     count -= 1
                }
                index = 1
            }
            else if(index == 2){
                print(index)
                p.append(c.coordinate)
                index -= 1
            }
            
            
        }
        
        print("THIS IS UR THRESH PATH = \(arrPath)")
        
    }
    
    func to(s: String){
        var n = ""
        var checkIn = false
        var index = s.count
        var timer = 0
        
        for c in s{
            
            if(c != "\r" && c != "\n" && c != "\r\n"){
                print(c)
            }
            else if(c == "\r"){
                print("line feed")
            }
            else if(c == "\n"){
                print("line carry")
            }
            else if(c == "\r\n"){
                print("line combo")
            }
        }
    }
    
    
    func toFormat(){
        
        var index = 0
        var delta = -55
        var p1 : point
        for elements in arr{
            
            
            
            if(index == 7){
                delta = 6
            }
            if(delta == 6 || delta == 4){
                    print("\(elements) = delta = \(delta)")
                
                    if(elements == ""){
                        return
                }
                
                    var num = Double(arr[index])!
                    var top = Int(num)
                    var b = Double(top / 100)
                    var a = Double(top % 100)
                    var res = (num - Double(top)) * 100
                    var num1 = Double(arr[index + 1])!
                    var top1 = Int(num1)
                    var b1 = Double(top1 / 100)
                    var a1 = Double(top1 % 100)
                    var res1 = (num1 - Double(top1)) * 100
                    var p1 = point(title: "Test\(index)", coordinate: CLLocationCoordinate2D(latitude: (b + (a/60) + (res/3600)), longitude: -(b1 + (a1/60) + (res1/3600))))
                    arrPoints.append(p1)
                print("VLaues: b1:\(b1)\na1:\(a1)\nnum1:\(num1)\ntop1:\(Double(top1))\nres1:\(res1)")
                print("lat: \(p1.coordinate.latitude), long: \(p1.coordinate.longitude)")
                    delta -= 1
                }
            else if(delta == 2){
                    arrThresh.append(Int(arr[index])!)
                delta -= 1
                print("Thresh : \(delta)")
                print(" Thresh yeild \(elements)")
            }
                else if(delta == 1){
                print(delta)
                print("\(elements)")
                    delta = 6
                }
                    else{
                print("Refresh : \(delta)")
                        delta -= 1
                }
            
            index += 1
            
        }
        
        
    }

    
    func toArray(s: String){
       var n = ""
        var checkIn = false
        var index = s.count
        var timer = 0
        
        for c in s{
            
            if(c == "," || c == "\r" ){
                print(" ENTERED: \(c)")
                checkIn = true
            }
            
            
            if( c != "," && c != "\r" && c != "\n" && c != "\r\n" ){
                print(" READING: \(c)")
                if(checkIn){
                    print(" VALID: \(c)")
                    n.append(c)
                    
                }
            }
            else if(c == "," || c == "\n" || c == "\r" || c == "\r\n"){
                print("STORE HEY")
                arr.append(n)
                n = ""
            }
                timer += 1
            
        }
        
        print(arr)
        
    }
    
    
   func reqquestLocationAccess(){
        let status = CLLocationManager.authorizationStatus()
        
        switch status{
        case .authorizedAlways, .authorizedWhenInUse:
            return
        case .denied, .restricted:
                print("location access denied")
        default:
            locationMan.requestWhenInUseAuthorization()
        }
    }


    

    func readCsv()->String{
        guard let path = Bundle.main.path(forResource: nameOfFile, ofType: "csv") else {
            print("Found a NIL")
            return " "
        }
        do {
            let text =  try String(contentsOfFile: path)
            return text
        }
        catch{
            
        }
        
        return " "
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKCircle.self){
            let cir = MKCircleRenderer(overlay: overlay)
            cir.fillColor = UIColor.blue
            cir.alpha = 0.1
            cir.strokeColor = UIColor.blue
            cir.lineWidth = 1
            return cir
        }
        
        
        if overlay.isKind(of: MKPolyline.self){
            
            var temp1 = overlay.title!
            var temp2 = temp1!
            
            if(temp2 == "GOOD"){
            let poly = MKPolylineRenderer(overlay: overlay)
            poly.strokeColor = UIColor.blue
            poly.lineWidth = 2
            
            return poly
            }
            if(temp2 == "MED"){
                let poly = MKPolylineRenderer(overlay: overlay)
                poly.strokeColor = UIColor.orange
                poly.lineWidth = 2
                
                return poly
            }
            if(temp2 == "BAD"){
                let poly = MKPolylineRenderer(overlay: overlay)
                poly.strokeColor = UIColor.red
                poly.lineWidth = 2
                
                return poly
            }
            
            
        }
            return MKOverlayRenderer(overlay: overlay)
    }
}

