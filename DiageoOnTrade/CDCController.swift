//
//  CDCController.swift
//  DiageoOnTrade
//
//  Created by Daniel Cedeño García on 10/9/17.
//  Copyright © 2017 Go Sharp. All rights reserved.
//

import Foundation
import GoogleMaps
import MapKit
import Alamofire



class CDCController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    
    //variables
    
    var el_sync:Sincronizador = Sincronizador()
    
    var menuButton: UIButton! =  UIButton()
    
    var el_mapa: GMSMapView = GMSMapView()
    
    var locations = [MKPointAnnotation]()
    
    var locationManager: CLLocationManager! = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    var didFindMyLocation = false
    var timezone:String!
    var accuracy:String!
    var satelliteUTC:String!
    var fechaActual:String!
    var el_hash:String?
    var tiempo_milisegundos = NSDate().timeIntervalSince1970
    
    var ultima_fecha_locacion = NSDate().timeIntervalSince1970
    
    let defaults = UserDefaults.standard
    
    var timer:Timer = Timer()
    
    var db:DB_Manager = DB_Manager()
    var base:String = ""
    
    var encuesta:[String:AnyObject] = [:]
    
    //var laEncuesta:EncuestaConstructor = EncuestaConstructor()
    
    var laVista:UIScrollView = UIScrollView()
    
    var color_letra = "ffffff"
    
    var fontFamilia = "Dosis-Regular"
    
    var offsetScroll:CGFloat = 0
    
    var campoBuscador:UITextField = UITextField()
    
    //fin variables
    
    
    //view didload
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        base = defaults.object(forKey: "base") as! String
        
        if self.revealViewController() != nil {
            
            //menuButton.target(forAction: #selector(SWRevealViewController.revealToggle(_:)), withSender: self)
            //menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchDown)
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        locationManager.delegate = self
        
    }
    
    //fin view didload
    
    //view didapper
    override func viewDidAppear(_ animated: Bool) {
        
        //checar_servicio_locacion()
        el_sync.acomodar_base()
        
        //iniciacion mapa
        
        
        let barraTitulo:UIScrollView = UIScrollView()
        
        barraTitulo.backgroundColor = UIColor(rgba: "#c70752")
        
        barraTitulo.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/12)
        
        
        
        el_mapa.frame = CGRect(x: 0, y: barraTitulo.frame.height, width: self.view.frame.width, height: self.view.frame.height/3)
        
        laVista.frame = CGRect(x: 0, y: el_mapa.frame.height + el_mapa.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height - barraTitulo.frame.height - el_mapa.frame.height)
        
        laVista.backgroundColor = UIColor(rgba: "#a42141")
        
        self.view.addSubview(barraTitulo)
        //self.view.addSubview(el_mapa)
        
        
        let logoImagen = UIImage(named: "LogoTitulo")
        
        let logoView:UIImageView = UIImageView()
        
        logoView.image = logoImagen
        
        logoView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: barraTitulo.frame.height)
        
        logoView.contentMode = .center
        
        barraTitulo.addSubview(logoView)
        
        
        
        
        //checar_servicio_locacion()
        el_sync.acomodar_base()
        
        let botoMenu:UIButton = UIButton()
        
        botoMenu.titleLabel!.font = UIFont(name: "TitilliumWeb-Regular", size: CGFloat(3))
        
        botoMenu.titleLabel!.font = botoMenu.titleLabel!.font.withSize(CGFloat(20))
        
        
        botoMenu.setAttributedTitle(nil, for: UIControlState())
        botoMenu.setTitle("Menú", for: UIControlState())
        
        botoMenu.isSelected = false
        botoMenu.setTitleColor(UIColor(rgba: "#FFFFFF"), for: UIControlState())
        
        
        
        botoMenu.titleLabel!.textColor = UIColor(rgba: "#ffffff")
        botoMenu.titleLabel!.numberOfLines = 0
        botoMenu.titleLabel!.textAlignment = .left
        
        
        botoMenu.sizeToFit()
        
        botoMenu.frame = CGRect(x: 5, y: 5, width: self.view.frame.width, height: barraTitulo.frame.height)
        
        botoMenu.contentHorizontalAlignment = .left
        botoMenu.contentVerticalAlignment = .center
        
        botoMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchDown)
        
        
        
        
        offsetScroll += barraTitulo.frame.height
        
        el_mapa.delegate=self
        
        
        
        el_mapa.settings.myLocationButton = true
        
        
        el_mapa.isMyLocationEnabled = true
        
        
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
        let miUbicacion = obtener_ubicacion()
        
        let camera = GMSCameraPosition.camera(withLatitude: miUbicacion.coordinate.latitude, longitude: miUbicacion.coordinate.longitude, zoom: 12)
        
        el_mapa.camera = camera
        
        
        campoBuscador.borderStyle = .none
        campoBuscador.keyboardType = .default
        campoBuscador.returnKeyType = .search
        
        campoBuscador.backgroundColor = UIColor(rgba: "#ffffff")
        
        campoBuscador.font = UIFont(name: fontFamilia, size: 12)
        
        campoBuscador.text = "BUSCAR CDC"
        
        campoBuscador.textColor = UIColor(rgba: "#c70752")
        
        campoBuscador.delegate = self
        
        campoBuscador.clearsOnInsertion = true
        
        campoBuscador.frame = CGRect(x: 0, y: laVista.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height/18)
        
        campoBuscador.addTarget(self, action: #selector(CDCController.cambio_busqueda(sender:)), for:  UIControlEvents.editingChanged)
        
        campoBuscador.addTarget(self, action: #selector(CDCController.limpiar_busqueda(sender:)), for:  UIControlEvents.editingDidBegin)
        
        self.view.addSubview(campoBuscador)
        
        offsetScroll = campoBuscador.frame.origin.y + campoBuscador.frame.height
        
        
        
        offsetScroll += 20
        
        
        self.view.addSubview(el_mapa)
        self.view.addSubview(barraTitulo)
        self.view.addSubview(botoMenu)
        self.view.addSubview(laVista)
        self.view.addSubview(campoBuscador)
        
        
        
        
        print("Estamos en CDC")
        
        mostrar_cdc(filtro: "")
        
        
    }
    
    
    
    //fin viewdidappear
    
    @objc func limpiar_busqueda(sender:UITextField){
        
        sender.text = ""
        
    }
    
    @objc func cambio_busqueda(sender:UITextField) {
        
        print("tecla")
        
        mostrar_cdc(filtro: campoBuscador.text!)
        
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        mostrar_cdc(filtro: textField.text!)
        
        
        textField.endEditing(true)
        
        return true
    }
    
    
    func mostrar_cdc(filtro:String){
        
        let subvistas = laVista.subviews
        
        for subvista in subvistas {
            
            subvista.removeFromSuperview()
            
        }
        
        offsetScroll = laVista.frame.height/9
        
        db.open_database(base)
        
        let sqlCDCs = "select t1.id,t1.name,t1.lat,t1.lon,t2.id as idClient,t2.value as cliente,t3.value as rtm,t3.id_canal,t3.id as idRtm from pdv_pdv t1, c_client t2, c_rtm t3 where t1.idClient = t2.id and t1.idRtm = t3.id and upper(t1.name) like '%\(filtro.uppercased())%' order by t1.name asc"
        
        print(sqlCDCs)
        
        let resultadoCDCs = db.select_query_columns(sqlCDCs)
        
        let tamano_letra_menu:CGFloat = 15
        
        
        
        var offsetx:CGFloat = laVista.frame.width/15
        
        let alto_menu:CGFloat = laVista.frame.height/12
        
        
        
        for renglonCDC in resultadoCDCs {
            
            offsetx = laVista.frame.width/15
            
            let botonCDCOjo:UIButton = UIButton()
            
            botonCDCOjo.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
            
            botonCDCOjo.titleLabel!.font = botonCDCOjo.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
            
            
            
            botonCDCOjo.setAttributedTitle(nil, for: UIControlState())
            botonCDCOjo.setTitle("", for: UIControlState())
            botonCDCOjo.tag = renglonCDC["id"] as! Int
            
            botonCDCOjo.isSelected = false
            botonCDCOjo.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
            
            
            
            botonCDCOjo.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
            botonCDCOjo.titleLabel!.numberOfLines = 0
            botonCDCOjo.titleLabel!.textAlignment = .left
            
            
            botonCDCOjo.sizeToFit()
            
            botonCDCOjo.frame = CGRect(x: offsetx, y: offsetScroll, width: laVista.frame.width/2.8, height: alto_menu*2.5)
            
            
            
            botonCDCOjo.contentHorizontalAlignment = .left
            botonCDCOjo.contentVerticalAlignment = .center
            
            
            botonCDCOjo.setImage(UIImage(named: "botonOjoBlanco"), for: .normal)
            
            botonCDCOjo.imageView?.contentMode = .scaleAspectFill
            
            botonCDCOjo.titleEdgeInsets = UIEdgeInsetsMake(0, botonCDCOjo.imageView!.frame.size.width, 0, 0)
            
            botonCDCOjo.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
            botonCDCOjo.titleEdgeInsets = UIEdgeInsetsMake(0, 0,0, 0);
            
            botonCDCOjo.addTarget(self, action:#selector(CDCController.iramodulos(sender:)), for:.touchDown)
            
            
            
            
            offsetx = (botonCDCOjo.frame.width)
            
            
            
            
            let botonCDC:UIButton = UIButton()
            
            botonCDC.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
            
            botonCDC.titleLabel!.font = botonCDC.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
            
            let nombreCDC = "\(renglonCDC["name"] as! String)"
            
            botonCDC.setAttributedTitle(nil, for: UIControlState())
            botonCDC.setTitle(nombreCDC, for: UIControlState())
            botonCDC.tag = renglonCDC["id"] as! Int
            
            botonCDC.isSelected = false
            botonCDC.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
            
            
            
            botonCDC.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
            botonCDC.titleLabel!.numberOfLines = 0
            botonCDC.titleLabel!.textAlignment = .left
            
            
            botonCDC.sizeToFit()
            
            botonCDC.frame = CGRect(x: offsetx, y: offsetScroll, width: laVista.frame.width - offsetx, height: alto_menu*2.5)
            
            
            
            botonCDC.contentHorizontalAlignment = .left
            botonCDC.contentVerticalAlignment = .center
            
            
            //botonCDC.setImage(UIImage(named: "botonOjoBlanco"), for: .normal)
            
            //botonCDC.imageView?.contentMode = .scaleAspectFill
            
            //botonCDC.titleEdgeInsets = UIEdgeInsetsMake(0, botonCDC.imageView!.frame.size.width, 0, 0)
            
            //botonCDC.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
            //botonCDC.titleEdgeInsets = UIEdgeInsetsMake(0, 0,0, 0);
            
            //botonCDC.addTarget(self, action:#selector(CDCController.iramodulos(sender:)), for:.touchDown)
            
            laVista.addSubview(botonCDC)
            laVista.addSubview(botonCDCOjo)
            
            offsetScroll += botonCDC.frame.height + 40
            
        }
        
        
        //laVista.contentSize = CGSizeMake(laVista.contentSize.width, offsetScroll)
        
        laVista.contentSize = CGSize(width: laVista.contentSize.width, height: offsetScroll)
        
        
        
    }
    
    @objc func iramodulos(sender:UIButton){
        
        defaults.set(sender.tag, forKey: "idCDC")
        
        self.performSegue(withIdentifier: "cdctomodulos", sender: self)
        
        
    }
    
    // view will disappear
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //el_mapa.removeObserver(self, forKeyPath: "myLocation")
        
    }
    
    //view will disappear
    
    //funciones backgroud
    
    
    /*func checarBackgroud(notification : NSNotification) {
     print("Estamos en backgroud")
     
     timer.invalidate()
     
     defaults.set(1, forKey: "enBackground")
     
     self.locationManager.stopUpdatingLocation()
     self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
     self.locationManager.distanceFilter = kCLDistanceFilterNone
     self.locationManager.pausesLocationUpdatesAutomatically = false
     
     self.locationManager.startUpdatingLocation()
     
     guadar_ubicacion()
     
     }
     
     */
    
    
    
    
    
    
    func guadar_ubicacion(){
        
        print("timer empezo")
        
        db.open_database("Loreal.db")
        
        var sql = "insert into locations (lon,lat,fecha) values ('1','2','1')"
        
        _ = db.execute_query(sql)
        
        sql = "select * from locations"
        
        let resultado_locations = db.select_query(sql)
        
        print(resultado_locations)
        
        ultima_fecha_locacion = NSDate().timeIntervalSince1970
        
        
    }
    
    func enviar_ubicacion(){}
    
    //fin funciones backgroud
    
    
    //funciones de localizacion
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        print("simon entro aqui")
        
        if status == CLAuthorizationStatus.authorizedAlways {
            el_mapa.isMyLocationEnabled = true
            
            let miUbicacion = obtener_ubicacion()
            
            let camera = GMSCameraPosition.camera(withLatitude: miUbicacion.coordinate.latitude, longitude: miUbicacion.coordinate.longitude, zoom: 12)
            
            el_mapa.camera = camera
            
        }
        
        
        
        
    }
    
    private func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        print("Simon actualizando ubicaion")
        // Add another annotation to the map.
        let annotation = MKPointAnnotation()
        annotation.coordinate = newLocation.coordinate
        
        // Also add to our map so we can remove old values later
        locations.append(annotation)
        
        // Remove values if the array is too big
        while locations.count > 100 {
            //let annotationToRemove = locations.first!
            locations.remove(at: 0)
            
            // Also remove from the map
            //el_mapa.removeAnnotation(annotationToRemove)
        }
        
        if UIApplication.shared.applicationState == .active {
            //el_mapa.showAnnotations(locations, animated: true)
            
            if defaults.object(forKey: "enBackground") != nil {
                
                timer.invalidate()
                
                timer = Timer.scheduledTimer(timeInterval: 1800, target: self, selector: #selector(InicioController.guadar_ubicacion), userInfo: nil, repeats: true)
                
                defaults.removeObject(forKey: "enBackground")
                
            }
            
            //print("App is fortground. New location is %@", newLocation)
            
            
            
        } else {
            //print("App is backgrounded. New location is %@", newLocation)
            
            let actual = Int64(NSDate().timeIntervalSince1970*1000)
            
            let aux = actual - Int64(ultima_fecha_locacion*1000)
            
            print(aux)
            
            if aux >= 1800000
                //if aux >= 60000
            {
                
                guadar_ubicacion()
                
            }
        }
    }
    
    
    /*
     func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutableRawPointer) {
     
     
     
     checar_servicio_locacion()
     
     
     
     if let _ = self.locationManager.location {
     
     
     
     }
     else{
     
     
     
     print("no tenemos location si es este")
     
     let aux_location = CLLocation(latitude: 0, longitude: 0)
     
     let defaults = UserDefaults.standard
     
     defaults.set("0", forKey: "satelliteUTC")
     
     defaults.set(aux_location.coordinate.latitude, forKey: "miLatitude")
     
     defaults.set(aux_location.coordinate.longitude, forKey: "miLongitude")
     
     
     
     
     didFindMyLocation = true
     
     
     
     
     
     
     
     }
     
     
     if !didFindMyLocation {
     
     /* let defaults = UserDefaults.standard
     
     
     
     
     
     let dateFormatter = DateFormatter()
     
     satelliteUTC = dateFormatter.string(from: (self.locationManager.location!.timestamp))
     
     
     
     
     dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fff'Z'"
     
     satelliteUTC = dateFormatter.string(from: self.locationManager.location!.timestamp)
     
     defaults.set(satelliteUTC, forKey: "satelliteUTC")
     
     //print("satelliteUTC es: \(satelliteUTC)", terminator: "")
     
     let myLocation: CLLocation = change?[NSKeyValueChangeNewKey] as! CLLocation
     
     //print(myLocation)
     
     defaults.set(myLocation.coordinate.latitude, forKey: "miLatitude")
     
     defaults.set(myLocation.coordinate.longitude, forKey: "miLongitude")
     
     let camera = GMSCameraPosition.camera(withLatitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude, zoom: 16)
     
     el_mapa.camera = camera
     el_mapa.settings.myLocationButton = true
     
     didFindMyLocation = true
     
     */
     }
     
     
     }
     */
    
    
    //fin funciones de localizacion
    
    
    //funcion checar servicio locacion
    
    
    func checar_servicio_locacion(){
        
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
                
                menuButton.removeTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchDown)
                self.view.removeGestureRecognizer(self.revealViewController().panGestureRecognizer())
                
                // Create the alert controller
                let alertController = UIAlertController(title: "¡¡Recuerda!!", message: "Debes tener habilitados los servicios de locacion para usar la app", preferredStyle: .alert)
                
                // Create the actions
                let cancelarAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    NSLog("click cancelar")
                    //self.confirmar_borrado(sender.tag)
                }
                
                
                // Add the actions
                
                let openAction = UIAlertAction(title: "Ajustes", style: .default) { (action) in
                    if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                        //UIApplication.shared.openURL(url as URL)
                        UIApplication.shared.open(url as URL, completionHandler: nil)
                    }
                }
                alertController.addAction(openAction)
                
                
                alertController.addAction(cancelarAction)
                
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                
                
                
                
                
            case .authorizedAlways, .authorizedWhenInUse:
                //print("Access")
                
                
                if self.revealViewController() != nil {
                    
                    menuButton.target(forAction: #selector(SWRevealViewController.revealToggle(_:)), withSender: self)
                    menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchDown)
                    
                    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                }
                
                
                
            }
        } else {
            print("Location services are not enabled")
        }
        
        
        
    }
    
    
    
    //fin funcion checar servicio locacion
    
    
}
