//
//  CambioContrasena.swift
//  OnTrade2
//
//  Created by Daniel Cedeño García on 11/14/16.
//  Copyright © 2016 Go Sharp. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import Crashlytics
import Alamofire
import CryptoSwift

class CambioContrasenaController: UIViewController {
    
    var el_sync:Sincronizador = Sincronizador()
    
    var defaults = UserDefaults.standard
    
    fileprivate var defaultsContext = 1
    
    var usuario:UITextField! = UITextField()
    var contrasena:UITextField! = UITextField()
    var contrasenaNueva:UITextField! = UITextField()
    
    var color_letra = "ffffff"
    
    var fontFamilia = "Dosis-Regular"
    
    var base:String = ""
    
    var vistaTerminos:UIScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        base = defaults.object(forKey: "base") as! String
        crear_login()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
    }
    
    @objc func aceptar_terminos(sender:UIButton){
        
        
        sender.removeFromSuperview()
        vistaTerminos.removeFromSuperview()
        
    }
    
    @objc func cargar_terminos(sender:UIButton){
        
        
        //_ = SwiftSpinner.show("Buscando Replicas")
        
        
        /*
         let sqlInfoUser = "select * from user_info"
         
         let resultadoInfoUser = db.select_query_columns(sqlInfoUser)
         
         var miIdUser:NSNumber = 0
         
         for rengloInfoUser in resultadoInfoUser {
         
         miIdUser = rengloInfoUser["id"] as! NSNumber
         
         }
         
         */
        
        //let idUser = defaults.object(forKey: "idUser") as! Int
        
        let aux_url = "http://216.22.63.155/capabilities-rest/rest/version/data/terms"
        
        print(aux_url)
        
        
        
        //let auxJsonstring = "[{\"name\":\"idRol\",\"value\":\"1\"},{\"name\":\"usuario\",\"value\":\"\(idUser)\"},{\"name\":\"tipo\",\"value\":\"1\"}]"
        
        
        
        
        //let parameters: Parameters = ["json": auxJsonstring]
        
        //print(parameters)
        
        //let usuario = defaults.object(forKey: "usuario") as! String
        //let contrasena = defaults.object(forKey: "contrasena") as! String
        
        //let credenciales = URLCredential(user: usuario, password: contrasena, persistence: .none)
        
        Alamofire.request(aux_url, method: .get, encoding: JSONEncoding.default)
            //Alamofire.request(.GET, "\(protocolo)://\(dominio)\(servicios_json.arreglo[indice]["servicio"])",headers:headers)
            //.authenticate(usingCredential: credenciales)
            .responseJSON { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                //SwiftSpinner.hide()
                if response.result.isFailure {
                    
                    //print(response.request)
                    //SwiftSpinner.show("Error al contactar el servidor").addTapHandler({SwiftSpinner.hide()})
                    
                    
                    
                }
                if  let data = response.result.value as? NSDictionary {
                    
                    print("simon scorecard dictionary")
                    
                    let botonTerminos:UIButton = UIButton()
                    
                    botonTerminos.titleLabel!.font = UIFont(name: self.fontFamilia, size: CGFloat(3))
                    
                    botonTerminos.titleLabel!.font = botonTerminos.titleLabel!.font.withSize(CGFloat(15))
                    
                    
                    botonTerminos.setAttributedTitle(nil, for: UIControlState())
                    botonTerminos.setTitle("Aceptar Terminos y Condiciones", for: UIControlState())
                    botonTerminos.tag = 0
                    
                    botonTerminos.isSelected = false
                    botonTerminos.setTitleColor(UIColor(rgba: "#ffffff"), for: UIControlState())
                    
                    
                    
                    botonTerminos.titleLabel!.textColor = UIColor(rgba: "#ffffff")
                    botonTerminos.titleLabel!.numberOfLines = 0
                    botonTerminos.titleLabel!.textAlignment = .center
                    
                    
                    botonTerminos.sizeToFit()
                    
                    botonTerminos.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
                    
                    
                    
                    botonTerminos.contentHorizontalAlignment = .center
                    botonTerminos.contentVerticalAlignment = .center
                    
                    botonTerminos.setImage(UIImage(named:"BotonEntrar"), for: .normal)
                    
                    botonTerminos.titleEdgeInsets = UIEdgeInsetsMake(0, -botonTerminos.imageView!.frame.size.width, 0, 0)
                    
                    botonTerminos.imageEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0)
                    
                    botonTerminos.imageView?.contentMode = .scaleToFill
                    
                    botonTerminos.addTarget(self, action:#selector(LoginController.aceptar_terminos(sender:)), for:.touchDown)
                    
                    self.view.addSubview(botonTerminos)
                    
                    let terminos = data["md5"] as! String
                    
                    
                    
                    let textoterminos:UITextView = UITextView()
                    
                    textoterminos.text = terminos
                    
                    textoterminos.frame = CGRect(x: 5, y: 5, width: self.view.frame.width, height: self.view.frame.height - 30)
                    
                    self.vistaTerminos.frame = CGRect(x: 0, y: botonTerminos.frame.height, width: self.view.frame.width, height: self.view.frame.height-30)
                    
                    self.vistaTerminos.addSubview(textoterminos)
                    
                    self.view.addSubview(self.vistaTerminos)
                    
                }
                
                
                if  let data = response.result.value as? NSArray {
                    
                    print("simon scorecard")
                    
                    //self.arregloServiciosListos.append(1)
                    
                    //print(data)
                    
                    //print(data["attempts"]!)
                    
                    //let respuesta = JSON(cadena: data as! String)
                    
                    
                    
                    let aux_elementos = data as! [[String:AnyObject]]
                    
                    print(aux_elementos)
                    
                }
                
                
        }
        
        
        
    }
    
    func crear_login(){
        
        var offset:CGFloat = self.view.frame.height/2 - self.view.frame.height/4
        
        
        let logoCabecera:UIButton = UIButton()
        
        logoCabecera.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        logoCabecera.titleLabel!.font = logoCabecera.titleLabel!.font.withSize(CGFloat(15))
        
        /*
         botonEntrar.setAttributedTitle(nil, for: UIControlState())
         botonEntrar.setTitle("ENTRAR", for: UIControlState())
         */
        
        logoCabecera.tag = 0
        
        logoCabecera.isSelected = false
        logoCabecera.setTitleColor(UIColor(rgba: "#ffffff"), for: UIControlState())
        
        
        
        logoCabecera.titleLabel!.textColor = UIColor(rgba: "#ffffff")
        logoCabecera.titleLabel!.numberOfLines = 0
        logoCabecera.titleLabel!.textAlignment = .center
        
        
        logoCabecera.sizeToFit()
        
        logoCabecera.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        
        
        
        logoCabecera.contentHorizontalAlignment = .center
        logoCabecera.contentVerticalAlignment = .center
        
        logoCabecera.setImage(UIImage(named:"CabeceraLogo"), for: .normal)
        
        self.view.addSubview(logoCabecera)
        
        let usuarioLabel:UILabel = UILabel()
        let contrasenaLabel:UILabel = UILabel()
        let contrasenaNuevaLabel:UILabel = UILabel()
        
        
        let offsetx:CGFloat = self.view.frame.width/18
        
        
        usuarioLabel.text = "Usuario"
        
        usuarioLabel.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        usuarioLabel.font = usuarioLabel.font.withSize(CGFloat(15))
        
        usuarioLabel.frame = CGRect(x: offsetx, y: offset, width: self.view.frame.width/2, height: self.view.frame.height/16)
        
        usuario.frame = CGRect(x: self.view.frame.width/2 - self.view.frame.width/6, y: offset, width: self.view.frame.width/2, height: self.view.frame.height/16)
        
        usuario.borderStyle = .roundedRect
        
        usuario.keyboardAppearance = .dark
        
        usuario.autocorrectionType = .no
        
        usuario.returnKeyType = .done
        
        usuario.autocapitalizationType = .none
        
        usuario.delegate = self
        
        usuario.text = ""
        
        usuario.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        usuario.font = usuario.font?.withSize(CGFloat(15))
        
        
        
        offset += self.view.frame.height/9
        
        contrasenaLabel.text = "Contraseña Anterior"
        
        contrasenaLabel.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        contrasenaLabel.font = contrasenaLabel.font.withSize(CGFloat(12))
        
        
        
        
        contrasena.frame = CGRect(x: self.view.frame.width/2 - self.view.frame.width/6, y: offset, width: self.view.frame.width/2, height: self.view.frame.height/16)
        
        contrasenaLabel.frame = CGRect(x: offsetx, y: offset, width: contrasena.frame.origin.x - offsetx, height: self.view.frame.height/16)
        
        contrasenaLabel.numberOfLines = 2
        
        //contrasenaLabel.adjustFontSizeToFitRect(rect : contrasenaLabel.frame,maximo:12)
        
        
        contrasena.borderStyle = .roundedRect
        
        contrasena.keyboardAppearance = .dark
        
        contrasena.isSecureTextEntry = true
        
        contrasena.returnKeyType = .done
        
        contrasena.delegate = self
        
        contrasena.text = ""
        
        contrasena.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        contrasena.font = contrasena.font?.withSize(CGFloat(15))
        
        offset += self.view.frame.height/9
        
        
        contrasenaNuevaLabel.text = "Contraseña Nueva"
        
        contrasenaNuevaLabel.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        contrasenaNuevaLabel.font = contrasenaLabel.font.withSize(CGFloat(12))
        
        
        
        
        contrasenaNueva.frame = CGRect(x: self.view.frame.width/2 - self.view.frame.width/6, y: offset, width: self.view.frame.width/2, height: self.view.frame.height/16)
        
        contrasenaNuevaLabel.frame = CGRect(x: offsetx, y: offset, width: contrasenaNueva.frame.origin.x - offsetx, height: self.view.frame.height/16)
        
        contrasenaNuevaLabel.numberOfLines = 2
        
        //contrasenaNuevaLabel.adjustFontSizeToFitRect(rect : contrasenaNuevaLabel.frame,maximo:12)
        
        contrasenaNueva.borderStyle = .roundedRect
        
        contrasenaNueva.keyboardAppearance = .dark
        
        contrasenaNueva.isSecureTextEntry = true
        
        contrasenaNueva.returnKeyType = .done
        
        contrasenaNueva.delegate = self
        
        contrasenaNueva.text = ""
        
        contrasenaNueva.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        contrasenaNueva.font = contrasena.font?.withSize(CGFloat(15))
        
        offset += self.view.frame.height/9
        
        
        
        
        
        
        let botonEntrar:UIButton = UIButton()
        
        botonEntrar.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonEntrar.titleLabel!.font = botonEntrar.titleLabel!.font.withSize(CGFloat(15))
        
        
        botonEntrar.setAttributedTitle(nil, for: UIControlState())
        botonEntrar.setTitle("ENTRAR", for: UIControlState())
        botonEntrar.tag = 0
        
        botonEntrar.isSelected = false
        botonEntrar.setTitleColor(UIColor(rgba: "#ffffff"), for: UIControlState())
        
        
        
        botonEntrar.titleLabel!.textColor = UIColor(rgba: "#ffffff")
        botonEntrar.titleLabel!.numberOfLines = 0
        botonEntrar.titleLabel!.textAlignment = .center
        
        
        botonEntrar.sizeToFit()
        
        botonEntrar.frame = CGRect(x: 0, y: offset, width: self.view.frame.width, height: 50)
        
        
        
        botonEntrar.contentHorizontalAlignment = .center
        botonEntrar.contentVerticalAlignment = .center
        
        botonEntrar.setImage(UIImage(named:"BotonEntrar"), for: .normal)
        
        botonEntrar.titleEdgeInsets = UIEdgeInsetsMake(0, -botonEntrar.imageView!.frame.size.width - 10, 0, 0)
        
        botonEntrar.imageEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0)
        
        botonEntrar.imageView?.contentMode = .center
        
        botonEntrar.addTarget(self, action:#selector(CambioContrasenaController.cambiar_contrasena(sender:)), for:.touchDown)
        
        
        
        
        offset += 70
        
        let botonRegresar:UIButton = UIButton()
        
        botonRegresar.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonRegresar.titleLabel!.font = botonRegresar.titleLabel!.font.withSize(CGFloat(15))
        
        
        botonRegresar.setAttributedTitle(nil, for: UIControlState())
        botonRegresar.setTitle("REGRESAR", for: UIControlState())
        botonRegresar.tag = 0
        
        botonRegresar.isSelected = false
        botonRegresar.setTitleColor(UIColor(rgba: "#ffffff"), for: UIControlState())
        
        
        
        botonRegresar.titleLabel!.textColor = UIColor(rgba: "#ffffff")
        botonRegresar.titleLabel!.numberOfLines = 0
        botonRegresar.titleLabel!.textAlignment = .center
        
        
        botonRegresar.sizeToFit()
        
        botonRegresar.frame = CGRect(x: 8, y: offset, width: self.view.frame.width, height: 50)
        
        
        
        botonRegresar.contentHorizontalAlignment = .center
        botonRegresar.contentVerticalAlignment = .center
        
        botonRegresar.setImage(UIImage(named:"BotonEntrar"), for: .normal)
        
        botonRegresar.titleEdgeInsets = UIEdgeInsetsMake(0, -botonRegresar.imageView!.frame.size.width - 20, 0, 0)
        
        botonRegresar.imageEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0)
        
        botonRegresar.imageView?.contentMode = .center
        
        botonRegresar.addTarget(self, action:#selector(CambioContrasenaController.regresar_login(sender:)), for:.touchDown)
        
        offset += 70
        
        let botonBase:UIButton = UIButton()
        
        botonBase.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonBase.titleLabel!.font = botonBase.titleLabel!.font.withSize(CGFloat(15))
        
        
        botonBase.setAttributedTitle(nil, for: UIControlState())
        botonBase.setTitle("Enviar Base", for: UIControlState())
        botonBase.tag = 0
        
        botonBase.isSelected = false
        botonBase.setTitleColor(UIColor(rgba: "#000000"), for: UIControlState())
        
        
        
        botonBase.titleLabel!.textColor = UIColor(rgba: "#000000")
        botonBase.titleLabel!.numberOfLines = 0
        botonBase.titleLabel!.textAlignment = .center
        
        
        botonBase.sizeToFit()
        
        botonBase.frame = CGRect(x: 0, y: offset, width: self.view.frame.width, height: 50)
        
        
        
        botonBase.contentHorizontalAlignment = .center
        botonBase.contentVerticalAlignment = .center
        
        //botonEntrar.setImage(UIImage(named:"BotonEntrar"), for: .normal)
        
        //botonEntrar.titleEdgeInsets = UIEdgeInsetsMake(0, -botonEntrar.imageView!.frame.size.width, 0, 0)
        
        //botonEntrar.imageEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0)
        
        //botonEntrar.imageView?.contentMode = .center
        
        botonBase.addTarget(self, action:#selector(CambioContrasenaController.cambiar_contrasena(sender:)), for:.touchDown)
        
        offset += 70
        
        let botonContrasena:UIButton = UIButton()
        
        botonContrasena.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonContrasena.titleLabel!.font = botonContrasena.titleLabel!.font.withSize(CGFloat(15))
        
        
        botonContrasena.setAttributedTitle(nil, for: UIControlState())
        botonContrasena.setTitle("Enviar Base", for: UIControlState())
        botonContrasena.tag = 0
        
        botonContrasena.isSelected = false
        botonContrasena.setTitleColor(UIColor(rgba: "#000000"), for: UIControlState())
        
        
        
        botonContrasena.titleLabel!.textColor = UIColor(rgba: "#000000")
        botonContrasena.titleLabel!.numberOfLines = 0
        botonContrasena.titleLabel!.textAlignment = .center
        
        
        botonContrasena.sizeToFit()
        
        botonContrasena.frame = CGRect(x: 0, y: offset, width: self.view.frame.width, height: 50)
        
        
        
        botonContrasena.contentHorizontalAlignment = .center
        botonContrasena.contentVerticalAlignment = .center
        
        //botonEntrar.setImage(UIImage(named:"BotonEntrar"), for: .normal)
        
        //botonEntrar.titleEdgeInsets = UIEdgeInsetsMake(0, -botonEntrar.imageView!.frame.size.width, 0, 0)
        
        //botonEntrar.imageEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0)
        
        //botonEntrar.imageView?.contentMode = .center
        
        botonContrasena.addTarget(self, action:#selector(LoginController.cambiar_contrasena(sender:)), for:.touchDown)
        
        offset += 70
        
        let botonTerminos:UIButton = UIButton()
        
        botonTerminos.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonTerminos.titleLabel!.font = botonBase.titleLabel!.font.withSize(CGFloat(15))
        
        
        botonTerminos.setAttributedTitle(nil, for: UIControlState())
        botonTerminos.setTitle("Terminos y Condiciones", for: UIControlState())
        botonTerminos.tag = 0
        
        botonTerminos.isSelected = false
        botonTerminos.setTitleColor(UIColor(rgba: "#000000"), for: UIControlState())
        
        
        
        botonTerminos.titleLabel!.textColor = UIColor(rgba: "#000000")
        botonTerminos.titleLabel!.numberOfLines = 0
        botonTerminos.titleLabel!.textAlignment = .center
        
        
        botonTerminos.sizeToFit()
        
        botonTerminos.frame = CGRect(x: 0, y: offset, width: self.view.frame.width, height: 50)
        
        
        
        botonTerminos.contentHorizontalAlignment = .center
        botonTerminos.contentVerticalAlignment = .center
        
        //botonEntrar.setImage(UIImage(named:"BotonEntrar"), for: .normal)
        
        //botonEntrar.titleEdgeInsets = UIEdgeInsetsMake(0, -botonEntrar.imageView!.frame.size.width, 0, 0)
        
        //botonEntrar.imageEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0)
        
        //botonEntrar.imageView?.contentMode = .center
        
        botonTerminos.addTarget(self, action:#selector(LoginController.cargar_terminos(sender:)), for:.touchDown)
        
        
        if self.defaults.object(forKey: "sesion") as! NSNumber == 0 {
            
            self.view.addSubview(usuarioLabel)
            self.view.addSubview(usuario)
            self.view.addSubview(botonRegresar)
            
        }
        else{
            
            usuario.text = defaults.object(forKey: "usuario") as? String
            
        }
        
        
        self.view.addSubview(contrasenaLabel)
        
        self.view.addSubview(contrasena)
        self.view.addSubview(contrasenaNuevaLabel)
        self.view.addSubview(contrasenaNueva)
        self.view.addSubview(botonEntrar)
        //self.view.addSubview(botonTerminos)
        
        print("pantala login creada")
        
    }
    
    @objc func regresar_login(sender:UIButton){
        
        
        
        self.performSegue(withIdentifier: "cambiocontrasenatologin", sender: self)
        
    }
    
    @objc func cambiar_contrasena(sender:UIButton){
        
        
        //let dominio = "216.22.63.155"
        
        
        
        let dominio = defaults.object(forKey: "dominio") as! String
        
        
        let aux_url = "http://\(dominio)/rest/psspolicy/update"
        
        print(aux_url)
        
        
        
        //let auxJsonstring = "[{\"name\":\"idRol\",\"value\":\"\(idRole)\"},{\"name\":\"usuario\",\"value\":\"\(idUser)\"},{\"name\":\"tipo\",\"value\":\"2\"}]"
        
        var contrasenaNuevaAES = ""
        /*
         let AES = CryptoJS.AES()
         let encrypted = AES.encrypt(contrasenaNueva.text!, secretKey: "f5e0627a0b3e0d49") as! String
         
         print(encrypted)
         
         
         */
        do {
            let aes = try AES(key: "f5e0627a0b3e0d49", iv: "") // aes128
            let ciphertext = try aes.encrypt(contrasenaNueva.text!.utf8.map({$0}))
            
            //print(ciphertext)
            
            //let xmlStr:String = ciphertext.toHexString()
            
            //print(xmlStr)
            
            contrasenaNuevaAES = ciphertext.toBase64()!
            
        } catch { }
        
        
        let parameters: Parameters = ["pass": contrasenaNuevaAES]
        
        print(parameters)
        
        
        
        let credenciales = URLCredential(user: usuario.text!, password: contrasena.text!, persistence: .none)
        
        print(credenciales)
        
        Alamofire.request(aux_url, method: .post, parameters: parameters)
            //Alamofire.request(.GET, "\(protocolo)://\(dominio)\(servicios_json.arreglo[indice]["servicio"])",headers:headers)
            
            
            .authenticate(usingCredential: credenciales)
            .responseString { response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                print(response.result.value as Any)
                
                if response.result.isFailure {
                    
                    
                    //actualizar texto cargador
                    
                    let controladorActual = UIApplication.topViewController()
                    
                    DispatchQueue.main.async {
                        
                        let subvistas = controladorActual?.view!.subviews
                        
                        for subvista in subvistas! where subvista.tag == 179 {
                            
                            let subvistasCargador = subvista.subviews
                            
                            for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                                
                                (subvistaCargador as! UIButton).setTitle("Contraseña Anterior Incorrecta o Error al contactar el servidor", for: .normal)
                                
                            }
                            
                            let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.ErrorCambio(sender:)))
                            singleTap.cancelsTouchesInView = false
                            singleTap.numberOfTapsRequired = 1
                            subvista.addGestureRecognizer(singleTap)
                            
                            
                        }
                        
                    }
                    
                    //fin actualizar texto cargador
                    
                    
                    
                    //print(response.request)
                    /*
                    SwiftSpinner.show("Contraseña Anterior Incorrecta o Error al contactar el servidor").addTapHandler({
                        
                        if self.defaults.object(forKey: "sesion") as! NSNumber == 0 {
                            self.performSegue(withIdentifier: "cambiocontrasenatologin", sender: self)
                        }
                        
                        SwiftSpinner.hide()
                    })
                    */
                    
                    
                }
                    
                else {
                    
                    print("este")
                    //print(response.debugDescription)
                    //print(response.data)
                    //print(response.result.description)
                    //print(response.result.debugDescription)
                    print(response.response?.statusCode as Any)
                    
                    if response.response!.statusCode == 200  {
                        
                        print("El cambio de contraseña regreso")
                        print(response.result.value!)
                        
                        
                        //actualizar texto cargador
                        
                        let controladorActual = UIApplication.topViewController()
                        
                        DispatchQueue.main.async {
                            
                            let subvistas = controladorActual?.view!.subviews
                            
                            for subvista in subvistas! where subvista.tag == 179 {
                                
                                let subvistasCargador = subvista.subviews
                                
                                for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                                    
                                    (subvistaCargador as! UIButton).setTitle("Cambio Correcto", for: .normal)
                                    
                                }
                                
                                let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.CambioCorrecto(sender:)))
                                singleTap.cancelsTouchesInView = false
                                singleTap.numberOfTapsRequired = 1
                                subvista.addGestureRecognizer(singleTap)
                                
                                
                            }
                            
                        }
                        
                        //fin actualizar texto cargador
                        
                        
                        
                        /*
                        SwiftSpinner.show("Cambio Correcto").addTapHandler({
                            
                            if self.defaults.object(forKey: "sesion") as! NSNumber == 0 {
                                self.performSegue(withIdentifier: "cambiocontrasenatologin", sender: self)
                            }
                            
                            if self.defaults.object(forKey: "sesion") as! NSNumber == 1 {
                                
                                self.performSegue(withIdentifier: "cambiocontrasenatoinicio", sender: self)
                                
                                self.defaults.set(self.contrasenaNueva.text!, forKey: "contrasena")
                                
                            }
                            
                            
                            SwiftSpinner.hide()
                        })
                        */
                        
                        
                        
                        
                        
                    }
                    else{
                        
                        print("El cambio de contraseña regreso")
                        print(response.result.value!)
                        
                        
                        var mensaje = response.result.value!
                        
                        if response.response!.statusCode == 401 {
                            
                            mensaje = "Contraseña Anterior Incorrecta"
                            
                        }
                        
                        
                        
                        let alertController = UIAlertController(title: "Capabilities", message: mensaje, preferredStyle: .alert)
                        
                        // Create the actions
                        
                        
                        let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            NSLog("click ok")
                            
                            
                            
                            
                        }
                        
                        
                        alertController.addAction(okAction)
                        
                        
                        
                        // Present the controller
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                        
                        
                    }
                    
                    
                }
                
                
                
                
        }
        
        
        
    }
    
    @objc func ErrorCambio(sender:UITapGestureRecognizer){
        
        if self.defaults.object(forKey: "sesion") as! NSNumber == 0 {
            self.performSegue(withIdentifier: "cambiocontrasenatologin", sender: self)
        }
        
        sender.view!.removeFromSuperview()
        
    }
    
    @objc func CambioCorrecto(sender:UITapGestureRecognizer){
        
        if self.defaults.object(forKey: "sesion") as! NSNumber == 0 {
            self.performSegue(withIdentifier: "cambiocontrasenatologin", sender: self)
        }
        
        if self.defaults.object(forKey: "sesion") as! NSNumber == 1 {
            
            self.performSegue(withIdentifier: "cambiocontrasenatoinicio", sender: self)
            
            self.defaults.set(self.contrasenaNueva.text!, forKey: "contrasena")
            
        }
        
        sender.view!.removeFromSuperview()
        
    }
    
    @objc func enviar_base(sender:UIButton){
        
        print("simon enviar base")
        
        DispatchQueue.main.async {
            
            //_ = SwiftSpinner.show("Base enviada. Toque para cerrar").addTapHandler({SwiftSpinner.hide()})
            
        }
        /*
         let headers = ["Content-Type": "multipart/form-data"]
         
         let url = "http://216.22.63.155/rest/user-file"
         
         //let base = "OnTrade.db"
         
         let documents_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
         
         
         
         
         
         let path_documents = documents_path.stringByAppendingPathComponent(self.base)
         
         
         
         
         let aux_url = NSURL(fileURLWithPath: path_documents)
         */
        
        /*Alamofire.upload(
         .POST,
         url, headers: headers,
         multipartFormData: { multipartFormData in
         multipartFormData.appendBodyPart(fileURL: aux_url, name: "imagen")
         
         },
         encodingCompletion: { encodingResult in
         switch encodingResult {
         case .Success(let upload, _, _):
         upload.authenticate(user: usuario, password: contrasena)
         .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
         print("a: \(bytesWritten) b: \(totalBytesWritten) c: \(totalBytesExpectedToWrite)")
         
         }
         upload.responseJSON { response in
         
         //Spinner.hide()
         
         
         debugPrint(response)
         Spinner.show("Base Enviada").addTapHandler({
         Spinner.hide()
         })
         
         
         
         
         
         
         
         }
         case .Failure(let encodingError):
         print(encodingError)
         }
         }
         )
         
         */
        
        
        
        
    }
    
    
    
    @objc func iniciar_sesion(_ sender:UIButton){
        
        defaults.set(0, forKey: "sesion")
        defaults.removeObject(forKey: "idReporteLocal")
        
        //defaults.addObserver(self, forKeyPath: "sesion", options: NSKeyValueObservingOptions(), context: &defaultsContext)
        
        
        
        el_sync.iniciar_sesion(usuario: usuario.text!, contrasena: contrasena.text!,controlador: self)
        //ir_inicio()
        
    }
    
    
    func ir_inicio(){
        
        crashlytics_user()
        
        print("vamonos a inicio")
        self.performSegue(withIdentifier: "logintoinicio", sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        
        return true
    }
    
    func crashlytics_user() {
        // TODO: Use the current user's information
        // You can call any combination of these three methods
        Crashlytics.sharedInstance().setUserEmail("user@loreal")
        Crashlytics.sharedInstance().setUserIdentifier("12345")
        let defaults = UserDefaults.standard
        
        let usuario = defaults.object(forKey: "usuario") as! String
        
        Crashlytics.sharedInstance().setUserName(usuario)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
     
     
     
     if context == &defaultsContext{
     
     if defaults.objectForKey("sesion") as! NSNumber == 1 {
     
     
     ir_inicio()
     }
     } else {
     super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
     }
     }
     
     deinit {
     //Remove observer
     
     // self.defaults.removeObserver(self, forKeyPath: "sesion_activa", context: &self.defaultsContext)
     
     
     
     
     
     
     }
     */
    
    
    
}

