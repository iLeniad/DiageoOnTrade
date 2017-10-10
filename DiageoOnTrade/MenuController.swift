//
//  MenuController.swift
//  DiageoOnTrade
//
//  Created by Daniel Cedeño García on 10/9/17.
//  Copyright © 2017 Go Sharp. All rights reserved.
//

import Foundation
import Crashlytics
import NVActivityIndicatorView


class MenuController: UIViewController {
    
    var el_sync:Sincronizador = Sincronizador()
    
    let defaults = UserDefaults.standard
    
    var offset:CGFloat = 0
    var offsetx:CGFloat = 0
    
    var color_letra = "ffffff"
    
    var fontFamilia = "Dosis-Regular"
    
    var base:String = ""
    
    var db:DB_Manager = DB_Manager()
    
    var vistaCargador:UIScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        base = defaults.object(forKey: "base") as! String
        
        self.view.backgroundColor = UIColor(rgba: "#2a2a2a")
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        crear_menu(self.view)
    }
    
    
    func crear_menu(_ vista:UIView) {
        
        
        let subvistas = vista.subviews
        
        for subvista in subvistas {
            
            subvista.removeFromSuperview()
            
        }
        
        
        let alto_menu:CGFloat = 50
        
        let tamano_letra_menu = 20
        
        offsetx = self.view.frame.width/8
        
        
        offset = alto_menu
        
        let botonHome:UIButton = UIButton()
        
        botonHome.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonHome.titleLabel!.font = botonHome.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
        
        
        botonHome.setAttributedTitle(nil, for: UIControlState())
        botonHome.setTitle("Home", for: UIControlState())
        
        botonHome.isSelected = false
        botonHome.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
        
        
        
        botonHome.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
        botonHome.titleLabel!.numberOfLines = 0
        botonHome.titleLabel!.textAlignment = .left
        
        
        botonHome.sizeToFit()
        
        botonHome.frame = CGRect(x: offsetx, y: offset, width: vista.frame.width - offsetx, height: alto_menu)
        
        botonHome.contentHorizontalAlignment = .left
        botonHome.contentVerticalAlignment = .center
        
        
        //botonHome.setImage(UIImage(named: "MenuHome"), forState: .Normal)
        
        botonHome.frame = CGRect(x: offsetx, y: offset, width: self.view.frame.width, height: alto_menu)
        
        botonHome.addTarget(self, action:#selector(MenuController.iraInicio(_:)), for:.touchDown)
        
        
        offset += alto_menu
        
        
        let botonMenu1:UIButton = UIButton()
        
        botonMenu1.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonMenu1.titleLabel!.font = botonMenu1.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
        
        var CDCTitulo = "CDC"
        
        let idReporteLocal = defaults.object(forKey: "idReporteLocal")
        
        if idReporteLocal != nil {
            
            CDCTitulo = "CDC (abierto)"
            
        }
        
        botonMenu1.setAttributedTitle(nil, for: UIControlState())
        botonMenu1.setTitle(CDCTitulo, for: UIControlState())
        
        botonMenu1.isSelected = false
        botonMenu1.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
        
        
        
        botonMenu1.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
        botonMenu1.titleLabel!.numberOfLines = 0
        botonMenu1.titleLabel!.textAlignment = .left
        
        
        botonMenu1.sizeToFit()
        
        botonMenu1.frame = CGRect(x: offsetx, y: offset, width: vista.frame.width - offsetx, height: alto_menu)
        
        botonMenu1.contentHorizontalAlignment = .left
        botonMenu1.contentVerticalAlignment = .center
        
        
        //botonListaEncuestas(UIImage(named: "MenuHome"), forState: .Normal)
        
        botonMenu1.frame = CGRect(x: offsetx, y: offset, width: self.view.frame.width, height: alto_menu)
        
        botonMenu1.addTarget(self, action:#selector(MenuController.iraCDC(_:)), for:.touchDown)
        
        
        offset += alto_menu
        
        let botonMenu2:UIButton = UIButton()
        
        botonMenu2.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonMenu2.titleLabel!.font = botonMenu2.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
        
        
        botonMenu2.setAttributedTitle(nil, for: UIControlState())
        botonMenu2.setTitle("Reportes Enviados", for: UIControlState())
        
        botonMenu2.isSelected = false
        botonMenu2.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
        
        
        
        botonMenu2.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
        botonMenu2.titleLabel!.numberOfLines = 0
        botonMenu2.titleLabel!.textAlignment = .left
        
        
        botonMenu2.sizeToFit()
        
        botonMenu2.frame = CGRect(x: offsetx, y: offset, width: vista.frame.width - offsetx, height: alto_menu)
        
        botonMenu2.contentHorizontalAlignment = .left
        botonMenu2.contentVerticalAlignment = .center
        
        
        //botonListaEncuestas(UIImage(named: "MenuHome"), forState: .Normal)
        
        botonMenu2.frame = CGRect(x: offsetx, y: offset, width: self.view.frame.width, height: alto_menu)
        
        botonMenu2.addTarget(self, action:#selector(MenuController.iraReportesEnviados(_:)), for:.touchDown)
        
        
        offset += alto_menu
        
        
        
        
        
        let botonMenu3:UIButton = UIButton()
        
        botonMenu3.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonMenu3.titleLabel!.font = botonMenu3.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
        
        
        botonMenu3.setAttributedTitle(nil, for: UIControlState())
        botonMenu3.setTitle("Reportes No Enviados", for: UIControlState())
        
        botonMenu3.isSelected = false
        botonMenu3.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
        
        
        
        botonMenu3.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
        botonMenu3.titleLabel!.numberOfLines = 0
        botonMenu3.titleLabel!.textAlignment = .left
        
        
        botonMenu3.sizeToFit()
        
        botonMenu3.frame = CGRect(x: offsetx, y: offset, width: vista.frame.width - offsetx, height: alto_menu)
        
        botonMenu3.contentHorizontalAlignment = .left
        botonMenu3.contentVerticalAlignment = .center
        
        
        //botonListaEncuestas(UIImage(named: "MenuHome"), forState: .Normal)
        
        botonMenu3.frame = CGRect(x: offsetx, y: offset, width: self.view.frame.width, height: alto_menu)
        
        botonMenu3.addTarget(self, action:#selector(MenuController.iraReportesNoEnviados(_:)), for:.touchDown)
        
        
        offset += alto_menu
        
        
        let botonMenu4:UIButton = UIButton()
        
        botonMenu4.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonMenu4.titleLabel!.font = botonMenu3.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
        
        
        botonMenu4.setAttributedTitle(nil, for: UIControlState())
        botonMenu4.setTitle("Enviar Reportes", for: UIControlState())
        
        botonMenu4.isSelected = false
        botonMenu4.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
        
        
        
        botonMenu4.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
        botonMenu4.titleLabel!.numberOfLines = 0
        botonMenu4.titleLabel!.textAlignment = .left
        
        
        botonMenu4.sizeToFit()
        
        botonMenu4.frame = CGRect(x: offsetx, y: offset, width: vista.frame.width - offsetx, height: alto_menu)
        
        botonMenu4.contentHorizontalAlignment = .left
        botonMenu4.contentVerticalAlignment = .center
        
        
        //botonListaEncuestas(UIImage(named: "MenuHome"), forState: .Normal)
        
        botonMenu4.frame = CGRect(x: offsetx, y: offset, width: self.view.frame.width, height: alto_menu)
        
        botonMenu4.addTarget(self, action:#selector(MenuController.enviarReportes(_:)), for:.touchDown)
        
        
        offset += alto_menu
        
        
        
        
        
        let botonSoporte:UIButton = UIButton()
        
        botonSoporte.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonSoporte.titleLabel!.font = botonSoporte.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
        
        
        botonSoporte.setAttributedTitle(nil, for: UIControlState())
        botonSoporte.setTitle("Soporte Técnico", for: UIControlState())
        
        botonSoporte.isSelected = false
        botonSoporte.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
        
        
        
        botonSoporte.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
        botonSoporte.titleLabel!.numberOfLines = 0
        botonSoporte.titleLabel!.textAlignment = .left
        
        
        botonSoporte.sizeToFit()
        
        botonSoporte.frame = CGRect(x: offsetx, y: offset, width: vista.frame.width - offsetx, height: alto_menu)
        
        botonSoporte.contentHorizontalAlignment = .left
        botonSoporte.contentVerticalAlignment = .center
        
        
        //botonListaEncuestas(UIImage(named: "MenuHome"), forState: .Normal)
        
        botonSoporte.frame = CGRect(x: offsetx, y: offset, width: self.view.frame.width, height: alto_menu)
        
        botonSoporte.addTarget(self, action:#selector(MenuController.soporte(sender:)), for:.touchDown)
        
        
        offset += alto_menu
        
        
        
        let botonSincronizar:UIButton = UIButton()
        
        botonSincronizar.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonSincronizar.titleLabel!.font = botonSincronizar.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
        
        
        botonSincronizar.setAttributedTitle(nil, for: UIControlState())
        botonSincronizar.setTitle("Sincronizar", for: UIControlState())
        
        botonSincronizar.isSelected = false
        botonSincronizar.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
        
        
        
        botonSincronizar.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
        botonSincronizar.titleLabel!.numberOfLines = 0
        botonSincronizar.titleLabel!.textAlignment = .left
        
        
        botonSincronizar.sizeToFit()
        
        botonSincronizar.frame = CGRect(x: offsetx, y: offset, width: vista.frame.width - offsetx, height: alto_menu)
        
        botonSincronizar.contentHorizontalAlignment = .left
        botonSincronizar.contentVerticalAlignment = .center
        
        
        //botonListaEncuestas(UIImage(named: "MenuHome"), forState: .Normal)
        
        botonSincronizar.frame = CGRect(x: offsetx, y: offset, width: self.view.frame.width, height: alto_menu)
        
        botonSincronizar.addTarget(self, action:#selector(MenuController.sincronizar(sender:)), for:.touchDown)
        
        
        offset += alto_menu
        
        
        
        let cerrar_sesion:UIButton = UIButton()
        
        cerrar_sesion.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        cerrar_sesion.titleLabel!.font = botonHome.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
        
        
        cerrar_sesion.setAttributedTitle(nil, for: UIControlState())
        cerrar_sesion.setTitle("Cerrar Sesion", for: UIControlState())
        
        cerrar_sesion.isSelected = false
        cerrar_sesion.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
        
        
        
        cerrar_sesion.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
        cerrar_sesion.titleLabel!.numberOfLines = 0
        cerrar_sesion.titleLabel!.textAlignment = .left
        
        
        cerrar_sesion.sizeToFit()
        
        cerrar_sesion.contentHorizontalAlignment = .left
        cerrar_sesion.contentVerticalAlignment = .center
        
        //cerrar_sesion.setImage(UIImage(named: "MenuCerrarSesion"), forState: .Normal)
        
        cerrar_sesion.frame = CGRect(x: offsetx, y: self.view.frame.height - alto_menu, width: self.view.frame.width, height: alto_menu)
        
        cerrar_sesion.addTarget(self, action:#selector(MenuController.cerrar_sesion(_:)), for:.touchDown)
        
        
        
        vista.addSubview(botonHome)
        vista.addSubview(botonMenu1)
        vista.addSubview(botonMenu2)
        vista.addSubview(botonMenu3)
        vista.addSubview(botonMenu4)
        
        vista.addSubview(botonSoporte)
        vista.addSubview(botonSincronizar)
        vista.addSubview(cerrar_sesion)
        
        
        
        
    }
    
    @objc func soporte(sender:UIButton){
        
        var version_label = ""
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            version_label = "Versión: \(version)"
        }
        
        // Create the alert controller
        let alertController = UIAlertController(title: "\(version_label)", message: "¿Deseas contactar a soporte? Llamadas de 09:00 hrs a 18:00 hrs de Lunes a Viernes", preferredStyle: .alert)
        
        // Create the actions
        
        var miNombre = ""
        
        let okAction = UIAlertAction(title: "CDMX", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("click ok")
            //self.confirmar_borrado(sender.tag)
            
            
            self.db.open_database(self.base)
            
            let sqlInfoUser = "select * from support_phone"
            
            let resultadoInfoUser = self.db.select_query_columns(sqlInfoUser)
            
            //var miIdUser:NSNumber = 0
            
            
            
            for rengloInfoUser in resultadoInfoUser {
                
                //miIdUser = rengloInfoUser["id"] as! NSNumber
                miNombre = rengloInfoUser["value"] as! String
                
            }
            
            
            
            let phone = "tel://\(miNombre)"
            let url:NSURL = NSURL(string:phone)!
            //UIApplication.shared.openURL(url as URL)
            UIApplication.shared.open(url as URL, completionHandler: nil)
            
            
            
            
            
        }
        
        var auxCorreo = "soporteapp@go-sharp.net"
        
        
        
        let botonCorreo = UIAlertAction(title: "Correo de Soporte 24/7", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("click ok")
            //self.confirmar_borrado(sender.tag)
            
            
            self.db.open_database(self.base)
            
            let sqlInfoUser = "select * from app_property"
            
            let resultadoInfoUser = self.db.select_query_columns(sqlInfoUser)
            
            //var miIdUser:NSNumber = 0
            
            
            
            for rengloInfoUser in resultadoInfoUser {
                
                //miIdUser = rengloInfoUser["id"] as! NSNumber
                auxCorreo = rengloInfoUser["value"] as! String
                
            }
            
            
            
            let subject = "Soporte OnTrade"
            let body = ""
            let coded = "mailto:\(auxCorreo)?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            if let emailURL: NSURL = NSURL(string: coded!) {
                if UIApplication.shared.canOpenURL(emailURL as URL) {
                    UIApplication.shared.open(emailURL as URL, options: [:],
                                              completionHandler: {
                                                (success) in
                                                print("Abriendo Correo")
                    })
                }
            }
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        let areaMetro = UIAlertAction(title: "Resto de la República", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("click republica")
            //self.confirmar_borrado(sender.tag)
            
            self.db.open_database(self.base)
            
            miNombre = "018008904130"
            
            let phone2 = "tel://\(miNombre)"
            let url2:NSURL = NSURL(string:phone2)!
            //UIApplication.shared.openURL(url as URL)
            UIApplication.shared.open(url2 as URL, completionHandler: nil)
            
        }
        
        
        
        let cancelarAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("click cancelar")
            //self.confirmar_borrado(sender.tag)
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(areaMetro)
        alertController.addAction(botonCorreo)
        alertController.addAction(cancelarAction)
        
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    @objc func sincronizar(sender:UIButton){
        /*
         let usuario = defaults.object(forKey: "usuario") as! String
         let contrasena = defaults.object(forKey: "contrasena") as! String
         
         el_sync.servicio_seriado(usuario: usuario, contrasena: contrasena, indice: 0)
         
         */
        
        let controladorActual = UIApplication.topViewController()
        
        print(controladorActual as Any)
        
        self.vistaCargador.tag = 179
        
        self.vistaCargador.frame = (controladorActual?.view!.frame)!
        
        self.vistaCargador.backgroundColor = UIColor.white
        
        let auxColor:UIColor = UIColor(rgba: "#ba243d")
        
        let vistaLoading = NVActivityIndicatorView(frame: CGRect(x: self.vistaCargador.frame.width/4, y: self.vistaCargador.frame.height/4, width: self.vistaCargador.frame.width/2, height: self.vistaCargador.frame.height/2),color:auxColor)
        
        vistaLoading.type = .ballScaleMultiple
        
        self.vistaCargador.addSubview(vistaLoading)
        
        controladorActual?.view!.addSubview(self.vistaCargador)
        
        vistaLoading.startAnimating()
        
        let textoCargador:UIButton = UIButton()
        
        textoCargador.frame = CGRect(x: 0, y: vistaCargador.frame.height*0.70, width: vistaCargador.frame.width, height: vistaCargador.frame.height*0.1)
        
        textoCargador.setTitle("Sincronizando...", for: .normal)
        textoCargador.setTitleColor(auxColor, for: .normal)
        
        textoCargador.setAttributedTitle(nil, for: UIControlState())
        
        textoCargador.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        textoCargador.titleLabel!.font = textoCargador.titleLabel!.font.withSize(CGFloat(20))
       
        
        textoCargador.isSelected = false
        
        //textoCargador.backgroundColor = auxColor
        
        
        textoCargador.titleLabel!.textColor = auxColor
        textoCargador.titleLabel!.numberOfLines = 0
        textoCargador.titleLabel!.textAlignment = .center
        
        vistaCargador.addSubview(textoCargador)
        
        sender.isUserInteractionEnabled = false
        
        
        DispatchQueue.main.async {
            
            //_ = SwiftSpinner.show("Iniciando sincronización...")
            
            sender.isUserInteractionEnabled = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                
                self.el_sync.sincronizar(controlador: self)
                
                
            })
        }
        
        
    }
    
    
    @objc func enviarReportes(_ sender:UIButton){
        
        let usuario = defaults.object(forKey: "usuario") as! String
        let contrasena = defaults.object(forKey: "contrasena") as! String
        
        el_sync.servicio_seriado_enviar(usuario: usuario, contrasena: contrasena, indice: 0)
        
    }
    
    @objc func cerrar_sesion(_ sender:UIButton){
        
        
        
        // Create the alert controller
        let alertController = UIAlertController(title: "¡¡Atención!!", message: "Al cerrar sesión todos los datos e imagenes se borraran por completo", preferredStyle: .alert)
        
        // Create the actions
        let aceptarAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("click aceptar")
            //self.confirmar_borrado(sender.tag)
            
            print("vamos a cerrar sesion")
            
            self.defaults.removeObject(forKey: "usuario")
            self.defaults.removeObject(forKey: "contrasena")
            
            self.defaults.set(0, forKey: "sesion")
            
            //self.borrar_todas_las_imagenes()
            
            self.performSegue(withIdentifier: "menutologin", sender: self)
            
            
        }
        
        
        let cancelarAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("click aceptar")
            //self.confirmar_borrado(sender.tag)
            
            
            
            
        }
        
        
        
        alertController.addAction(aceptarAction)
        alertController.addAction(cancelarAction)
        
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
        
        
        
        
        
        
        
        
        
    }
    
    @IBAction func probar_crash(){
        
        
        Crashlytics.sharedInstance().crash()
        
        
        
    }
    
    @IBAction func modulos(){
        
        
        self.performSegue(withIdentifier: "menutomodulos", sender: self)
        
    }
    
    @objc func iraInicio(_ sender:UIButton){
        
        self.performSegue(withIdentifier: "menutoinicio", sender: self)
        
    }
    
    @objc func iraCDC(_ sender:UIButton){
        
        let idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
        
        print(idReporteLocal as Any)
        
        let espacioLibre = deviceRemainingFreeSpaceInBytes()
        
        print(espacioLibre!)
        
        
        
        if espacioLibre! < 1000000000 && espacioLibre! > 49000000 {
            
            
            
            // Create the alert controller
            let alertController = UIAlertController(title: "¡¡Atención!!", message: "Tienes menos de 1 GB de espacio libre", preferredStyle: .alert)
            
            // Create the actions
            let aceptarAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                UIAlertAction in
                NSLog("click aceptar")
                //self.confirmar_borrado(sender.tag)
            }
            
            
            
            alertController.addAction(aceptarAction)
            
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            
            
            
            
        }
        
        
        
        
        
        if espacioLibre! > 49000000 {
            
            if idReporteLocal == nil {
                
                self.performSegue(withIdentifier: "menutocdc", sender: self)
                
            }
            else{
                
                self.performSegue(withIdentifier: "menutomodulos", sender: self)
                
            }
            
        }
        else {
            
            
            
            
            // Create the alert controller
            let alertController = UIAlertController(title: "¡¡Atención!!", message: "No hay espacio suficiente para hacer un reporte", preferredStyle: .alert)
            
            // Create the actions
            let aceptarAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                UIAlertAction in
                NSLog("click aceptar")
                //self.confirmar_borrado(sender.tag)
            }
            
            
            
            alertController.addAction(aceptarAction)
            
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            
            
            
            
            
            
            
            
        }
        
        
    }
    
    
    func borrar_todas_las_imagenes(){
        
        
        
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
                
                //let fileManager = FileManager.default
                
                // Get attributes of 'myfile.txt' file
                
                //do {
                
                print("la imagen a buscar es")
                print(imagen.path)
                
                borrar_imagen(ruta: imagen.path)
                
                //}
                //catch let error as NSError {
                //    print("Ooops! Something went wrong: \(error)")
                //}
                
                
                
                
            }
            
            
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
        
        
        
        
    }
    
    
    @objc func iraReportesEnviados(_ sender:UIButton){
        
        
        
        self.performSegue(withIdentifier: "menutoreportesenviados", sender: self)
        
        
        
        
    }
    
    @objc func iraReportesNoEnviados(_ sender:UIButton){
        
        
        
        self.performSegue(withIdentifier: "menutoreportesnoenviados", sender: self)
        
        
        
        
    }
    
    
    func iraScoreCard(_ sender:UIButton){
        
        self.performSegue(withIdentifier: "menutoscorecard", sender: self)
        
    }
    
    func iraEvaluacion(_ sender:UIButton){
        
        self.performSegue(withIdentifier: "menutoevaluacion", sender: self)
        
    }
    
    func iraReplicas(_ sender:UIButton){
        
        self.performSegue(withIdentifier: "menutoreplicas", sender: self)
        
    }
    
    
    func iraScanalert(_ sender:UIButton){
        
        self.performSegue(withIdentifier: "menutoscanalert", sender: self)
        
    }
    
    func iraDisponibilidad(_ sender:UIButton){
        
        self.performSegue(withIdentifier: "menutodisponibilidad", sender: self)
        
    }
    
    func iraDisponibilidadFiltros(_ sender:UIButton){
        
        self.performSegue(withIdentifier: "menutodisponibilidadfiltros", sender: self)
        
    }
    
    func iraEjecutables(_ sender:UIButton){
        
        self.performSegue(withIdentifier: "menutoejecutables", sender: self)
        
    }
    
    func iraExhibiciones(_ sender:UIButton){
        
        self.performSegue(withIdentifier: "menutoexhibiciones", sender: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
