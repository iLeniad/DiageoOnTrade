//
//  InicioController.swift
//  DiageoOnTrade
//
//  Created by Daniel Cedeño García on 10/9/17.
//  Copyright © 2017 Go Sharp. All rights reserved.
//

import Foundation
import GoogleMaps
import MapKit
import Alamofire
import Crashlytics


class InicioController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate,URLSessionDelegate,URLSessionTaskDelegate {
    
    //variables
    
    var el_sync:Sincronizador = Sincronizador()
    
    @IBOutlet weak var menuButton: UIButton!
    
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
    
    var encuesta:[String:AnyObject] = [:]
    
    //var laEncuesta:EncuestaConstructor = EncuestaConstructor()
    
    var laVista:UIScrollView = UIScrollView()
    
    var color_letra = "ffffff"
    
    var fontFamilia = "Dosis-Regular"
    
    var offsetScroll:CGFloat = 0
    
    var barraSubTitulo:UIScrollView = UIScrollView()
    
    
    var textoSubTitulo:UIButton = UIButton()
    
    var barraMarkers:UIScrollView = UIScrollView()
    
    var arregloImagenesReenviar:[[String:AnyObject]] = [[:]]
    
    //fin variables
    
    
    //view didload
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
        
        borrar_imagenes()
        
        //checar ultima actualizacion
        
        let ultimaActualizacion = defaults.object(forKey: "ultimaActualizacion") as? Date
        
        if ultimaActualizacion != nil {
            
            let hoy = Date()
            
            let segundos = hoy.timeIntervalSince(ultimaActualizacion!)
            
            let dias = Int(segundos/86400)
            
            print("tiene \(dias) sin sincronizar")
            
            if dias > 0 {
                
                
                el_sync.sincronizar(controlador: self)
                
            }
            
            
        }
        
        
        //fin ultima actualizacion
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        
        
        
        let auxVersion = checar_version_guardada()
        
        print("\(String(describing: version)) y ultima guardad fue \(String(describing: auxVersion["versionGuardada"] as? String))")
        
        if version != auxVersion["versionGuardada"] as? String || auxVersion["tipo"] as! Int == 0 {
            
            defaults.set(version, forKey: "versionGuardada")
            
            // let usuario = defaults.object(forKey: "usuario") as! String
            // let contrasena = defaults.object(forKey: "contrasena") as! String
            
            //el_sync.servicio_seriado(usuario: usuario, contrasena: contrasena, indice: 0)
            
            //el_sync.servicio_seriado(usuario: usuario, contrasena: contrasena, indice: 0, controlador: self, funcion: "version")
            
            el_sync.sincronizar(controlador: self)
            
        }
        else {
            //checar version
            
            checar_version()
            
            /*
             
             
             let base = defaults.object(forKey: "base") as! String
             
             db.open_database(base)
             
             let sqlVersion = "select * from 'ios-app'"
             
             let resultadoVersion = db.select_query_columns(sqlVersion)
             
             for renglonVersion in resultadoVersion {
             
             let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
             
             let auxVersion = (renglonVersion["version"] as? String)?.replacingOccurrences(of: "ON_TRADE_IOS_", with: "")
             
             if version != auxVersion {
             
             self.performSegue(withIdentifier: "iniciotoactualizarapp", sender: self)
             
             
             }
             
             }
             
             */
            
        }
        
        
        
        //iniciacion mapa
        
        
        let barraTitulo:UIScrollView = UIScrollView()
        
        barraTitulo.backgroundColor = UIColor(rgba: "#c70752")
        
        barraTitulo.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        
        laVista.frame = CGRect(x: 0, y: barraTitulo.frame.height, width: self.view.frame.width, height: self.view.frame.height - barraTitulo.frame.height)
        
        el_mapa.frame = CGRect(x: 0, y: 30, width: self.view.frame.width, height: self.view.frame.height - 30)
        
        self.view.addSubview(barraTitulo)
        //self.view.addSubview(el_mapa)
        
        //checar_servicio_locacion()
        
        
        
        offsetScroll += barraTitulo.frame.height
        
        el_mapa.delegate=self
        
        
        
        
        barraTitulo.backgroundColor = UIColor(rgba: "#c70752")
        
        barraTitulo.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/12)
        
        
        
        let logoImagen = UIImage(named: "LogoTitulo")
        
        let logoView:UIImageView = UIImageView()
        
        logoView.image = logoImagen
        
        logoView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: barraTitulo.frame.height)
        
        logoView.contentMode = .center
        
        barraTitulo.addSubview(logoView)
        
        barraSubTitulo.frame = CGRect(x: 0, y: barraTitulo.frame.height + barraTitulo.frame.origin.y, width: barraTitulo.frame.width, height: barraTitulo.frame.height/2)
        
        let fondoBarraSubTitulo = UIImage(named: "LineaGris")
        
        let vistaFondoBarraSubtitulo:UIImageView = UIImageView()
        
        vistaFondoBarraSubtitulo.image = fondoBarraSubTitulo
        
        vistaFondoBarraSubtitulo.frame = CGRect(x: 0, y: 0, width: barraSubTitulo.frame.width, height: barraSubTitulo.frame.height)
        
        vistaFondoBarraSubtitulo.contentMode = .scaleAspectFit
        
        
        
        textoSubTitulo.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        textoSubTitulo.titleLabel!.font = textoSubTitulo.titleLabel!.font.withSize(CGFloat(14))
        
        
        
        textoSubTitulo.setAttributedTitle(nil, for: UIControlState())
        textoSubTitulo.setTitle("", for: UIControlState())
        textoSubTitulo.tag = 0
        
        textoSubTitulo.isSelected = false
        textoSubTitulo.setTitleColor(UIColor(rgba: "#c70752"), for: UIControlState())
        
        
        
        textoSubTitulo.titleLabel!.textColor = UIColor(rgba: "#c70752")
        textoSubTitulo.titleLabel!.numberOfLines = 0
        textoSubTitulo.titleLabel!.textAlignment = .right
        
        
        textoSubTitulo.sizeToFit()
        
        textoSubTitulo.frame = CGRect(x: 0, y: 0, width: barraSubTitulo.frame.width - barraSubTitulo.frame.width/20, height: barraSubTitulo.frame.height)
        
        
        
        textoSubTitulo.contentHorizontalAlignment = .right
        textoSubTitulo.contentVerticalAlignment = .center
        
        
        
        
        
        
        barraSubTitulo.addSubview(vistaFondoBarraSubtitulo)
        
        barraSubTitulo.addSubview(textoSubTitulo)
        
        el_mapa.frame = CGRect(x: 0, y: barraSubTitulo.frame.origin.y + barraSubTitulo.frame.height, width: self.view.frame.width, height: self.view.frame.height - barraSubTitulo.frame.origin.y - barraSubTitulo.frame.height)
        
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
        
        
        
        
        
        self.view.addSubview(el_mapa)
        
        self.view.addSubview(barraTitulo)
        
        self.view.addSubview(barraSubTitulo)
        
        self.view.backgroundColor = UIColor(rgba: "#c70752")
        
        
        
        self.view.addSubview(botoMenu)
        
        
        
        
        barraMarkers.frame = CGRect(x: 0, y: self.view.frame.height - self.view.frame.height/6, width: self.view.frame.width, height: self.view.frame.height/6)
        
        barraMarkers.backgroundColor = UIColor(rgba: "#000000")
        
        barraMarkers.alpha = 0.8
        
        
        let botonMarkerGris:UIButton = UIButton()
        
        botonMarkerGris.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonMarkerGris.titleLabel!.font = botonMarkerGris.titleLabel!.font.withSize(CGFloat(10))
        
        
        botonMarkerGris.setAttributedTitle(nil, for: UIControlState())
        botonMarkerGris.setTitle("VISITAS POR REALIZAR", for: UIControlState())
        botonMarkerGris.tag = 0
        
        botonMarkerGris.isSelected = false
        botonMarkerGris.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
        
        
        
        botonMarkerGris.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
        botonMarkerGris.titleLabel!.numberOfLines = 0
        botonMarkerGris.titleLabel!.textAlignment = .left
        
        
        botonMarkerGris.sizeToFit()
        
        botonMarkerGris.frame = CGRect(x: barraMarkers.frame.width/25, y: 0, width: barraMarkers.frame.width/3, height: barraMarkers.frame.height)
        
        
        
        botonMarkerGris.contentHorizontalAlignment = .left
        botonMarkerGris.contentVerticalAlignment = .center
        
        
        botonMarkerGris.setImage(UIImage(named: "MarkerGris"), for: .normal)
        
        botonMarkerGris.imageView?.contentMode = .scaleAspectFill
        
        botonMarkerGris.titleEdgeInsets = UIEdgeInsetsMake(0, botonMarkerGris.imageView!.frame.size.width, 0, 0)
        
        botonMarkerGris.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        botonMarkerGris.titleEdgeInsets = UIEdgeInsetsMake(0, 0,0, 0);
        
        //botonMarkerGris.addTarget(self, action:#selector(CDCController.iramodulos(sender:)), for:.touchDown)
        
        barraMarkers.addSubview(botonMarkerGris)
        
        
        let botonMarkerVerde:UIButton = UIButton()
        
        botonMarkerVerde.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonMarkerVerde.titleLabel!.font = botonMarkerVerde.titleLabel!.font.withSize(CGFloat(10))
        
        
        botonMarkerVerde.setAttributedTitle(nil, for: UIControlState())
        botonMarkerVerde.setTitle("VISITAS REALIZADAS", for: UIControlState())
        botonMarkerVerde.tag = 0
        
        botonMarkerVerde.isSelected = false
        botonMarkerVerde.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
        
        
        
        botonMarkerVerde.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
        botonMarkerVerde.titleLabel!.numberOfLines = 0
        botonMarkerVerde.titleLabel!.textAlignment = .left
        
        
        botonMarkerVerde.sizeToFit()
        
        botonMarkerVerde.frame = CGRect(x: botonMarkerGris.frame.origin.x + botonMarkerGris.frame.width, y: 0, width: barraMarkers.frame.width/3, height: barraMarkers.frame.height)
        
        
        
        botonMarkerVerde.contentHorizontalAlignment = .left
        botonMarkerVerde.contentVerticalAlignment = .center
        
        
        botonMarkerVerde.setImage(UIImage(named: "MarkerVerde"), for: .normal)
        
        botonMarkerVerde.imageView?.contentMode = .scaleAspectFill
        
        botonMarkerVerde.titleEdgeInsets = UIEdgeInsetsMake(0, botonMarkerVerde.imageView!.frame.size.width, 0, 0)
        
        botonMarkerVerde.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        botonMarkerVerde.titleEdgeInsets = UIEdgeInsetsMake(0, 0,0, 0);
        
        //botonMarkerGris.addTarget(self, action:#selector(CDCController.iramodulos(sender:)), for:.touchDown)
        
        barraMarkers.addSubview(botonMarkerVerde)
        
        
        let botonMarkerRojo:UIButton = UIButton()
        
        botonMarkerRojo.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonMarkerRojo.titleLabel!.font = botonMarkerRojo.titleLabel!.font.withSize(CGFloat(10))
        
        
        botonMarkerRojo.setAttributedTitle(nil, for: UIControlState())
        botonMarkerRojo.setTitle("VISITA EN PROCESO", for: UIControlState())
        botonMarkerRojo.tag = 0
        
        botonMarkerRojo.isSelected = false
        botonMarkerRojo.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
        
        
        
        botonMarkerRojo.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
        botonMarkerRojo.titleLabel!.numberOfLines = 0
        botonMarkerRojo.titleLabel!.textAlignment = .left
        
        
        botonMarkerRojo.sizeToFit()
        
        botonMarkerRojo.frame = CGRect(x: botonMarkerVerde.frame.origin.x + botonMarkerVerde.frame.width, y: 0, width: barraMarkers.frame.width/3, height: barraMarkers.frame.height)
        
        
        
        botonMarkerRojo.contentHorizontalAlignment = .left
        botonMarkerRojo.contentVerticalAlignment = .center
        
        
        botonMarkerRojo.setImage(UIImage(named: "MarkerRojo"), for: .normal)
        
        botonMarkerRojo.imageView?.contentMode = .scaleAspectFill
        
        botonMarkerRojo.titleEdgeInsets = UIEdgeInsetsMake(0, botonMarkerRojo.imageView!.frame.size.width, 0, 0)
        
        botonMarkerRojo.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        botonMarkerRojo.titleEdgeInsets = UIEdgeInsetsMake(0, 0,0, 0);
        
        //botonMarkerGris.addTarget(self, action:#selector(CDCController.iramodulos(sender:)), for:.touchDown)
        
        barraMarkers.addSubview(botonMarkerRojo)
        
        
        self.view.addSubview(barraMarkers)
        
        el_mapa.settings.myLocationButton = true
        
        
        let base = defaults.object(forKey: "base") as! String
        
        db.open_database(base)
        
        var latitud:Double = 0
        
        var longitud:Double = 0
        
        
        
        //let segundos = hoy.timeIntervalSince1970
        
        var sql = "select lat,lon,name from pdv_pdv where id not in (SELECT place FROM report where strftime('%Y-%m-%d', checkIn / 1000, 'unixepoch') == strftime('%Y-%m-%d','now') and idTipo <> '-1')"
        
        print(sql)
        
        el_mapa.clear()
        
        //visistas por realizar
        let resultadoVisitasPorRealizar = db.select_query_columns(sql)
        
        print("resultados por realizar")
        print(resultadoVisitasPorRealizar.count)
        print(resultadoVisitasPorRealizar)
        
        for renglon in resultadoVisitasPorRealizar{
            
            
            //print(renglon["lat"] as Any)
            
            if renglon["lat"] != nil {
                
                if let _ = renglon["lat"] as? [String] {
                    
                    latitud = (renglon["lat"] as! NSString).doubleValue
                    
                    longitud = (renglon["lon"] as! NSString).doubleValue
                    
                    
                    
                }
                else{
                    
                    latitud = renglon["lat"] as! Double
                    
                    longitud = renglon["lon"] as! Double
                    
                }
                
            }
            
            let position = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
            let markerGris = GMSMarker(position: position)
            markerGris.title = renglon["name"] as? String
            
            
            var imagenIconoGris = UIImage(named: "MarkerGris")!
            
            imagenIconoGris = imagenIconoGris.resize(1.0)
            
            markerGris.icon = imagenIconoGris
            
            markerGris.zIndex = -1
            
            markerGris.map = self.el_mapa
            
        }
        
        //fin visitas por realizar
        
        
        //visitas realizadas
        
        
        sql = "select lat,lon,name from pdv_pdv where id in (SELECT place FROM report where strftime('%Y-%m-%d', checkIn / 1000, 'unixepoch') == strftime('%Y-%m-%d','now') and idTipo <> '-1')"
        
        print(sql)
        
        //visistas por realizar
        let resultadoVisitasRealizadas = db.select_query_columns(sql)
        
        print("resultados realizadas")
        print(resultadoVisitasRealizadas.count)
        print(resultadoVisitasRealizadas)
        
        for renglon in resultadoVisitasRealizadas {
            
            
            
            if let _ = renglon["lat"] as? [String] {
                
                latitud = (renglon["lat"] as! NSString).doubleValue
                
                longitud = (renglon["lon"] as! NSString).doubleValue
                
                
                
            }
            else{
                
                latitud = renglon["lat"] as! Double
                
                longitud = renglon["lon"] as! Double
                
            }
            
            let position = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
            let markerVerde = GMSMarker(position: position)
            markerVerde.title = renglon["name"] as? String
            
            
            var imagenIconoVerde = UIImage(named: "MarkerVerde")!
            
            imagenIconoVerde = imagenIconoVerde.resize(1.0)
            
            markerVerde.icon = imagenIconoVerde
            
            markerVerde.zIndex = 2
            
            markerVerde.map = self.el_mapa
            
        }
        
        
        //fin visitas realizadas
        
        
        
        //visistas en proceso
        
        sql = "SELECT lon,lat,name FROM pdv_pdv where id in (select place from report where idTipo = '-1') limit 1"
        
        let resultadoVisitasEnProceso = db.select_query_columns(sql)
        
        print("resultados en proceso")
        print(resultadoVisitasEnProceso)
        
        for renglon in resultadoVisitasRealizadas{
            
            if let _ = renglon["lat"] as? [String] {
                
                latitud = (renglon["lat"] as! NSString).doubleValue
                
                longitud = (renglon["lon"] as! NSString).doubleValue
                
                
                
            }
            else{
                
                latitud = renglon["lat"] as! Double
                
                longitud = renglon["lon"] as! Double
                
            }
            
            let position = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
            let markerRojo = GMSMarker(position: position)
            markerRojo.title = renglon["name"] as? String
            
            
            var imagenIconoRojo = UIImage(named: "MarkerRojo")!
            
            imagenIconoRojo = imagenIconoRojo.resize(1.0)
            
            markerRojo.icon = imagenIconoRojo
            
            markerRojo.zIndex = 1
            
            markerRojo.map = self.el_mapa
            
        }
        
        
        //fin visitas en proceso
        
        
        
        /*let locationManager: CLLocationManager! = {
         let manager = CLLocationManager()
         manager.desiredAccuracy = kCLLocationAccuracyBest
         manager.delegate = self
         manager.requestAlwaysAuthorization()
         return manager
         }()
         
         
         //locationManager.delegate = self
         locationManager.requestAlwaysAuthorization()
         locationManager.startUpdatingLocation()
         
         locationManager.desiredAccuracy = kCLLocationAccuracyBest        //self.locationManager.distanceFilter = 500.0;
         */
        
        //el_mapa.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        
        
        el_mapa.isMyLocationEnabled = true
        
        //fin iniciacion mapa
        
        
        //iniciacion backgroud
        
        //NotificationCenter.defaultCenter.addObserver(self, selector: #selector(InicioController.checarBackgroud(_:)), name:UIApplicationDidEnterBackgroundNotification, object: nil)
        
        //fin iniciacion backgroud
        
        //timer = Timer.scheduledTimer(timeInterval: 1800, target: self, selector: #selector(InicioController.guadar_ubicacion), userInfo: nil, repeats: true)
        
        //
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        /*let miUbicacion = obtener_ubicacion(controlador: self)
         
         let camera = GMSCameraPosition.camera(withLatitude: miUbicacion.coordinate.latitude, longitude: miUbicacion.coordinate.longitude, zoom: 12)
         
         el_mapa.camera = camera
         */
        
        
        let miUbicacion = obtener_ubicacion()
        
        let camera = GMSCameraPosition.camera(withLatitude: miUbicacion.coordinate.latitude, longitude: miUbicacion.coordinate.longitude, zoom: 12)
        
        el_mapa.camera = camera
        
        
        checar_estatusContrasena()
        
        crashlytics_user()
        
        //ReenviarImagenes()
        
    }
    
    //fin viewdidappear
    
    
    // view will disappear
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //el_mapa.removeObserver(self, forKeyPath: "myLocation")
        
    }
    
    //view will disappear
    
    //checar estatus contraseña
    
    
    func checar_estatusContrasena(){
        
        print("vamos a checar el estatus de la contraseña")
        
        //let dominio = "216.22.63.155"
        
        let dominio = defaults.object(forKey: "dominio") as! String
        let protocolo = defaults.object(forKey: "protocolo") as! String
        
        
        
        let aux_url = "\(protocolo)://\(dominio)/rest/psspolicy/status"
        
        //let aux_url = "http://gshpdiageocapabilitiesclone.jelastic.servint.net/capabilities-rest/rest/psspolicy/status"
        
        print(aux_url)
        
        let todoEndpoint: String = aux_url
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        
        let configuracion:URLSessionConfiguration = URLSessionConfiguration.ephemeral
        
        
        
        let sesion = URLSession(configuration: configuracion, delegate: self, delegateQueue: nil)
        
        let tarea = sesion.dataTask(with: urlRequest) {
            (data, response, error) in
            // Errores
            guard error == nil else {
                print(" Error en la petición del servicio policy")
                print(error!)
                return
            }
            //Hay data
            guard let responseData = data else {
                print("Error: servicio viene vacio")
                return
            }
            //checar si es diccionario o arreglo
            print(data as Any)
            print("la respuesta es")
            let realResponse = response as! HTTPURLResponse
            print(realResponse)
            switch realResponse.statusCode {
                
            case 200:
                
                
                
                do {
                    
                    
                    
                    
                    guard let datos = try JSONSerialization.jsonObject(with: responseData, options: [])
                        as? [String: Any] else {
                            print("No es diccionario policy")
                            return
                    }
                    
                    print(datos.description)
                    
                    
                    print("el estatus es ")
                    
                    print(datos["status"] as Any)
                    
                    
                    if datos["status"] as! NSNumber == 2 {
                        
                        //SwiftSpinner.show("Su contraseña esta caduca es necesario actualizarla. Toque para continuar").addTapHandler({
                        
                        //SwiftSpinner.hide()
                        
                        
                        
                        
                        
                        
                        
                        //})
                        
                        
                        
                        
                        let alertController = UIAlertController(title: "¡Atención!", message: "Su contraseña esta caduca es necesario actualizarla", preferredStyle: .alert)
                        
                        
                        let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            
                            print("se presiono Aceptar")
                            
                            self.performSegue(withIdentifier: "iniciotocambiocontrasena", sender: self)
                            
                        }
                        
                        
                        alertController.addAction(okAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                    if datos["status"] as! NSNumber == 1 {
                        
                        print("todo bien con las credenciales")
                        
                        
                        
                        
                    }
                    
                    //fin checar si es diccionario o arreglo
                    
                    
                    
                } catch  {
                    print("error al parsear el json")
                    return
                }
                
            case 401:
                
                print("Credenciales incorrectas")
                
                print("si tenemos credenciales mal")
                
                
                
                
                
                let alertController = UIAlertController(title: "¡Atención!", message: "Sus credenciales estan incorrectas, favor de ingresarlas nuevamente", preferredStyle: .alert)
                
                
                let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    
                    print("se presiono Aceptar")
                    self.defaults.set(3, forKey: "sesion")
                    self.performSegue(withIdentifier: "iniciotologin", sender: self)
                    
                }
                
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                
                
                
                
                
            default:
                print("Estatus http no manejado")
            }
            
            
        }
        tarea.resume()
        
        
    }
    
    func checar_version(){
        
        //http://207.58.154.134/rest/version/data/ios-app/
        
        
        print("vamos a checar la version")
        
        //let dominio = "216.22.63.155"
        
        let dominio = defaults.object(forKey: "dominio") as! String
        let protocolo = defaults.object(forKey: "protocolo") as! String
        
        
        
        let aux_url = "\(protocolo)://\(dominio)/rest/version/data/ios-app/"
        
        //let aux_url = "http://gshpdiageocapabilitiesclone.jelastic.servint.net/capabilities-rest/rest/psspolicy/status"
        
        print(aux_url)
        
        let todoEndpoint: String = aux_url
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        
        let configuracion:URLSessionConfiguration = URLSessionConfiguration.ephemeral
        
        
        
        let sesion = URLSession(configuration: configuracion, delegate: self, delegateQueue: nil)
        
        let tarea = sesion.dataTask(with: urlRequest) {
            (data, response, error) in
            // Errores
            guard error == nil else {
                print(" Error en la petición del servicio policy")
                print(error!)
                return
            }
            //Hay data
            guard let responseData = data else {
                print("Error: servicio viene vacio")
                return
            }
            //checar si es diccionario o arreglo
            print(data as Any)
            print("la respuesta es")
            let realResponse = response as! HTTPURLResponse
            print(realResponse)
            switch realResponse.statusCode {
                
            case 200:
                
                
                
                do {
                    
                    
                    
                    
                    guard let datos = try JSONSerialization.jsonObject(with: responseData, options: [])
                        as? [String: Any] else {
                            print("No es diccionario policy")
                            return
                    }
                    
                    print(datos.description)
                    
                    
                    print("la version es ")
                    
                    print(datos["version"] as Any)
                    
                    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                    
                    let auxVersion = (datos["version"] as? String)?.replacingOccurrences(of: "ON_TRADE_IOS_", with: "")
                    
                    if version != auxVersion {
                        
                        print("la versión es diferente")
                        
                        //self.performSegue(withIdentifier: "iniciotoactualizarapp", sender: self)
                        
                        
                    }
                    
                    
                    
                    //fin checar si es diccionario o arreglo
                    
                    
                    
                } catch  {
                    print("error al parsear el json")
                    return
                }
                
            case 401:
                
                print("Credenciales incorrectas")
                
                print("si tenemos credenciales mal")
                
                
                
                
                
                let alertController = UIAlertController(title: "¡Atención!", message: "Sus credenciales estan incorrectas, favor de ingresarlas nuevamente", preferredStyle: .alert)
                
                
                let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    
                    print("se presiono Aceptar")
                    self.defaults.set(3, forKey: "sesion")
                    self.performSegue(withIdentifier: "iniciotologin", sender: self)
                    
                }
                
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                
                
                
                
                
            default:
                print("Estatus http no manejado")
            }
            
            
        }
        tarea.resume()
        
        
    }
    
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        print("tenemos challege")
        
        guard challenge.previousFailureCount == 0 else {
            challenge.sender?.cancel(challenge)
            // Inform the user that the user name and password are incorrect
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        let usuario = defaults.object(forKey: "usuario") as! String
        let contrasena = defaults.object(forKey: "contrasena") as! String
        
        let proposedCredential = URLCredential(user: usuario, password: contrasena, persistence: .none)
        completionHandler(.useCredential, proposedCredential)
    }
    
    
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void){
        
        print("tenemos challege task")
        
        
        if challenge.previousFailureCount > 0 {
            
            print("Credenciales incorrectas")
            
            DispatchQueue.main.async {
                
                //_ = SwiftSpinner.show("Credenciales incorrectas").addTapHandler({SwiftSpinner.hide()})
                
                
                print("Credenciales incorrectas")
                
                print("si tenemos credenciales mal")
                
                /*
                _ =  SwiftSpinner.show("Sus credenciales estan incorrectas, favor de ingresarlas nuevamente").addTapHandler({
                    
                    self.defaults.set(3, forKey: "sesion")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "iniciotologin", sender: self)
                    }
                })
                */
                
                
            }
            
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
        } else {
            
            let usuario = defaults.object(forKey: "usuario") as! String
            let contrasena = defaults.object(forKey: "contrasena") as! String
            
            let credential = URLCredential(user:usuario, password:contrasena, persistence: .none)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential,credential)
        }
        
        
        
    }
    
    
    @objc func guadar_ubicacion(){
        
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
    
    func crashlytics_user() {
        // TODO: Use the current user's information
        // You can call any combination of these three methods
        Crashlytics.sharedInstance().setUserEmail("user@ontrade")
        Crashlytics.sharedInstance().setUserIdentifier("12345")
        
        let defaults = UserDefaults.standard
        
        let usuario = defaults.object(forKey: "usuario") as! String
        
        Crashlytics.sharedInstance().setUserName(usuario)
        
        //Crashlytics.sharedInstance().crash()
    }
    
    //fin funcion checar servicio locacion
    
    
    
    func borrar_imagenes(){
        
        
        
        print("vamos a borrar las imagenes")
        
        
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            //print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            let imagenes = directoryContents.filter{ $0.pathExtension == "jpg" }
            //print("jpg urls:",imagenes)
            //let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
            //print("jpg list:", mp3FileNames)
            
            
            for imagen in imagenes {
                
                
                print("la url de imagen es")
                print(imagen)
                
                // Create a FileManager instance
                
                let fileManager = FileManager.default
                
                // Get attributes of 'myfile.txt' file
                
                do {
                    
                    print("la imagen a buscar es")
                    print(imagen.path)
                    
                    let attributes = try fileManager.attributesOfItem(atPath: imagen.path)
                    print(attributes[FileAttributeKey.creationDate] as! Date)
                    
                    let fecha = attributes[FileAttributeKey.creationDate] as! Date
                    
                    let auxFecha = fecha.timeIntervalSince1970 + (2*30*24*60*60)
                    
                    let fechaActual = NSDate().timeIntervalSince1970
                    
                    /*
                     let dateString = "2017-03-22"
                     let dateFormatter = DateFormatter()
                     dateFormatter.dateFormat = "yyyy-MM-dd"
                     fechaActual = (dateFormatter.date(from: dateString)?.timeIntervalSince1970)!
                     */
                    print(auxFecha)
                    print(fechaActual)
                    
                    
                    
                    if  auxFecha <= fechaActual {
                        
                        print("tiene mas de dos meses")
                        
                        let base = defaults.object(forKey: "base") as! String
                        
                        db.open_database(base)
                        
                        let sqlImagen = "select * from report_photo_distribution where path = '\(imagen.path)' and is_send = 1"
                        
                        
                        let resultadoImagen = db.select_query_columns(sqlImagen)
                        
                        if resultadoImagen.count > 0 {
                            
                            borrar_imagen(ruta: imagen.path)
                            
                        }
                        else{
                            
                            
                            let sqlImagen = "select * from report_photo_promotions where path = '\(imagen.path)' and is_send = 1"
                            
                            
                            let resultadoImagen = db.select_query_columns(sqlImagen)
                            
                            if resultadoImagen.count > 0 {
                                
                                borrar_imagen(ruta: imagen.path)
                                
                            }
                            else{
                                
                                
                                let sqlImagen = "select * from report_photo_visibility where path = '\(imagen.path)' and is_send = 1"
                                
                                
                                let resultadoImagen = db.select_query_columns(sqlImagen)
                                
                                if resultadoImagen.count > 0 {
                                    
                                    borrar_imagen(ruta: imagen.path)
                                    
                                }
                                
                                
                                
                            }
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                    }
                    else{
                        
                        print("no tiene mas de dos meses")
                        
                    }
                    
                }
                catch let error as NSError {
                    print("Ooops! Something went wrong: \(error)")
                }
                
                
                
                
            }
            
            
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
        
        
        
        
    }
    
    
    func ReenviarImagenes(){
        
        
        
        print("vamos a reenviar las imagenes")
        
        arregloImagenesReenviar.removeAll()
        
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            //print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            let imagenes = directoryContents.filter{ $0.pathExtension == "jpg" }
            //print("jpg urls:",imagenes)
            //let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
            //print("jpg list:", mp3FileNames)
            
            
            for imagen in imagenes {
                
                
                print("la url de imagen es")
                print(imagen)
                
                // Create a FileManager instance
                
                let fileManager = FileManager.default
                
                // Get attributes of 'myfile.txt' file
                
                do {
                    
                    print("la imagen a buscar es")
                    print(imagen.path)
                    
                    let attributes = try fileManager.attributesOfItem(atPath: imagen.path)
                    print(attributes[FileAttributeKey.creationDate] as! Date)
                    
                    let fecha = attributes[FileAttributeKey.creationDate] as! Date
                    
                    print(fecha.timeIntervalSince1970)
                    
                    let auxFecha = fecha.timeIntervalSince1970 //+ (2*30*24*60*60)
                    
                    let fechaActual = NSDate().timeIntervalSince1970
                    
                    /*
                     let dateString = "2017-03-22"
                     let dateFormatter = DateFormatter()
                     dateFormatter.dateFormat = "yyyy-MM-dd"
                     fechaActual = (dateFormatter.date(from: dateString)?.timeIntervalSince1970)!
                     */
                    print(auxFecha)
                    print(fechaActual)
                    
                    var k = 0
                    
                    let aux_nombre_imagen = imagen.path.components(separatedBy: "/")
                    
                    let auxNombreImagen = aux_nombre_imagen[aux_nombre_imagen.count - 1]
                    
                    let sqlImagenDistribution = "select * from report_photo_distribution where path = '\(auxNombreImagen)'"
                    
                    print(sqlImagenDistribution)
                    
                    
                    let resultadoImagenDistribution = db.select_query_columns(sqlImagenDistribution)
                    
                    if resultadoImagenDistribution.count > 0 {
                        
                        k = 1
                        
                    }
                    
                    let sqlImagenPromotions = "select * from report_photo_promotions where path = '\(auxNombreImagen)'"
                    
                    
                    let resultadoImagenPromotions = db.select_query_columns(sqlImagenPromotions)
                    
                    if resultadoImagenPromotions.count > 0 {
                        
                        k = 1
                        
                    }
                    
                    
                    
                    let sqlImagenVisibility = "select * from report_photo_visibility where path = '\(auxNombreImagen)'"
                    
                    
                    let resultadoImagenVisibility = db.select_query_columns(sqlImagenVisibility)
                    
                    if resultadoImagenVisibility.count > 0 {
                        
                        k = 1
                        
                    }
                    
                    let baseR = defaults.object(forKey: "baseR") as! String
                    
                    self.db.open_database(baseR)
                    
                    let sqlImagen = "select * from imagenesReenviar where imagen = '\(auxNombreImagen)'"
                    
                    print(sqlImagen)
                    
                    let resultadoImagen = db.select_query_columns(sqlImagen)
                    
                    if resultadoImagen.count > 0 {
                        
                        k = 1
                        
                    }
                    
                    if k == 0 {
                        
                        
                        let date = NSDate(timeIntervalSince1970: TimeInterval(auxFecha))
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                        //formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
                        print(formatter.string(from: date as Date))
                        
                        
                        let auxImagen = ["imagen":imagen.path,"fecha":formatter.string(from: date as Date)] as [String : AnyObject]
                        
                        arregloImagenesReenviar.append(auxImagen)
                        
                    }
                    
                    
                    
                    let base = defaults.object(forKey: "base") as! String
                    
                    self.db.open_database(base)
                    
                    
                    
                }
                catch let error as NSError {
                    print("Ooops! Something went wrong: \(error)")
                }
                
                
                
                
            }
            
            
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        var fotos:[[String:AnyObject]] = [[:]]
        
        fotos.removeAll()
        
        let protocolo = defaults.object(forKey: "protocolo") as! String
        
        let dominio = defaults.object(forKey: "dominio") as! String
        
        print("las imagenes a reenviar son\(arregloImagenesReenviar) ")
        
        for imagen in arregloImagenesReenviar{
            
            
            fotos.append([String:AnyObject]())
            
            
            
            let auxPath = imagen["imagen"] as! String
            
            let aux_nombre_imagen = auxPath.components(separatedBy: "/")
            
            let imagen_ruta = fileInDocumentsDirectory(filename: aux_nombre_imagen[aux_nombre_imagen.count - 1])
            
            let tiempo_milisegundos = String(Int64(NSDate().timeIntervalSince1970*1000))
            
            let random = Int(arc4random_uniform(1000))
            
            let el_hash=tiempo_milisegundos + String(random)
            
            let hash = el_hash.md5()
            
            
            fotos[fotos.count - 1]["imagen"] = aux_nombre_imagen[aux_nombre_imagen.count - 1] as AnyObject
            fotos[fotos.count - 1]["ruta"] = imagen_ruta as AnyObject?
            fotos[fotos.count - 1]["hash"] = hash as AnyObject
            fotos[fotos.count - 1]["pdv"] = "1" as AnyObject
            fotos[fotos.count - 1]["descripcion"] = "recuperada fecha \(imagen["fecha"]!)" as AnyObject
            fotos[fotos.count - 1]["tabla"] = "recuperada" as AnyObject
            fotos[fotos.count - 1]["id"] = "1" as AnyObject
            fotos[fotos.count - 1]["servicio"] = "\(protocolo)://\(dominio)/rest/multireport/image/recuperada/" as AnyObject?
            
            
            
        }
        
        if fotos.count > 0 {
            
            el_sync.mandarFotosrReenviar(indice: 0, fotos: fotos)
        }
        
        
        
    }
    
    
    
}
