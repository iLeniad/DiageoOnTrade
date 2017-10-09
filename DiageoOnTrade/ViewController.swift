//
//  ViewController.swift
//  DiageoOnTrade
//
//  Created by Daniel Cedeño García on 10/9/17.
//  Copyright © 2017 Go Sharp. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import Crashlytics
import Alamofire

class LoginController: UIViewController {
    
    var el_sync:Sincronizador = Sincronizador()
    
    var defaults = UserDefaults.standard
    
    fileprivate var defaultsContext = 1
    
    var usuario:UITextField! = UITextField()
    var contrasena:UITextField! = UITextField()
    
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
        
        if defaults.object(forKey: "sesion") == nil {
            
            defaults.set(0, forKey: "sesion")
            
        }
        else{
            
            if defaults.object(forKey: "sesion") as! NSNumber == 1 {
                
                
                ir_inicio()
            }
            
            
        }
        
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
        
        let dominio = defaults.object(forKey: "dominio") as! String
        
        
        let aux_url = "http://\(dominio)/capabilities-rest/rest/version/data/terms"
        
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
        
        
        
        
        
        usuarioLabel.text = "Usuario"
        
        usuarioLabel.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        usuarioLabel.font = usuarioLabel.font.withSize(CGFloat(15))
        
        usuarioLabel.frame = CGRect(x: self.view.frame.width/2 - 150, y: offset, width: 100, height: 30)
        
        usuario.frame = CGRect(x: self.view.frame.width/2 - 50, y: offset, width: self.view.frame.width/2, height: 30)
        
        usuario.borderStyle = .roundedRect
        
        usuario.keyboardAppearance = .dark
        
        usuario.autocorrectionType = .no
        
        usuario.returnKeyType = .done
        
        usuario.autocapitalizationType = .none
        
        usuario.delegate = self
        
        usuario.text = ""
        
        usuario.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        usuario.font = usuario.font?.withSize(CGFloat(15))
        
        
        
        offset += 50
        
        contrasenaLabel.text = "Contrasena"
        
        contrasenaLabel.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        contrasenaLabel.font = contrasenaLabel.font.withSize(CGFloat(15))
        
        
        contrasenaLabel.frame = CGRect(x: self.view.frame.width/2 - 150, y: offset, width: 100, height: 30)
        
        contrasena.frame = CGRect(x: self.view.frame.width/2 - 50, y: offset, width: self.view.frame.width/2, height: 30)
        
        contrasena.borderStyle = .roundedRect
        
        contrasena.keyboardAppearance = .dark
        
        contrasena.isSecureTextEntry = true
        
        contrasena.returnKeyType = .done
        
        contrasena.delegate = self
        
        contrasena.text = ""
        
        contrasena.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        contrasena.font = contrasena.font?.withSize(CGFloat(15))
        
        offset += 50
        
        
        
        
        
        
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
        
        botonEntrar.addTarget(self, action:#selector(LoginController.iniciar_sesion(_:)), for:.touchDown)
        
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
        
        botonBase.addTarget(self, action:#selector(LoginController.enviar_base(sender:)), for:.touchDown)
        
        offset += 70
        
        let botonContrasena:UIButton = UIButton()
        
        botonContrasena.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonContrasena.titleLabel!.font = botonContrasena.titleLabel!.font.withSize(CGFloat(15))
        
        
        botonContrasena.setAttributedTitle(nil, for: UIControlState())
        botonContrasena.setTitle("Cambiar Contraseña", for: UIControlState())
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
        
        
        
        
        self.view.addSubview(usuarioLabel)
        self.view.addSubview(contrasenaLabel)
        self.view.addSubview(usuario)
        self.view.addSubview(contrasena)
        self.view.addSubview(botonEntrar)
        self.view.addSubview(botonBase)
        self.view.addSubview(botonContrasena)
        self.view.addSubview(botonTerminos)
        
        print("pantala login creada")
        
    }
    
    @objc func enviar_base(sender:UIButton){
        
        DispatchQueue.main.async {
            
            //_ = SwiftSpinner.show("Enviando...").addTapHandler({SwiftSpinner.hide()})
            
        }
        
        
        print("simon enviar base")
        
        let documents_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        
        
        
        let aux_fileURL = documents_path.stringByAppendingPathComponent(base)
        
        let fileUrl = URL(fileURLWithPath: aux_fileURL)
        
        
        
        //let fleURL = Bundle.main.url(forResource: "Capabilities2", withExtension: ".sqlite")
        
        //let fileURL = Bundle.main.url(forResource: "video", withExtension: "mov")
        
        let dominio = defaults.object(forKey: "dominio") as! String
        
        let aux_url = "http://\(dominio)/rest/user-file"
        
        let usuario = defaults.object(forKey: "ultimoUsuario") as? String
        let contrasena = defaults.object(forKey: "ultimaContrasena") as? String
        
        if usuario != nil {
            
            let credenciales = URLCredential(user: usuario!, password: contrasena!, persistence: .none)
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(fileUrl, withName: "imagen")
                    //multipartFormData.append(rainbowImageURL, withName: "rainbow")
            },
                to: aux_url,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.authenticate(usingCredential: credenciales)
                        upload.responseString { response in
                            debugPrint(response)
                            
                            DispatchQueue.main.async {
                                
                                //_ = SwiftSpinner.show("Base enviada. Toque para cerrar").addTapHandler({SwiftSpinner.hide()})
                                
                            }
                            
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                    }
            }
            )
            //.authenticate(usingCredential: credenciales)
            
            
            
            
            
            
        }
        else{
            
            DispatchQueue.main.async {
                
                //_ = SwiftSpinner.show("Aun no hay base para enviar. Toque para cerrar").addTapHandler({SwiftSpinner.hide()})
                
            }
            
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
    
    @objc func cambiar_contrasena(sender:UIButton){
        
        print("simon cambiar contraseña")
        self.performSegue(withIdentifier: "logintocambiocontrasena", sender: self)
        
    }
    
    @objc func iniciar_sesion(_ sender:UIButton){
        
        defaults.set(0, forKey: "sesion")
        defaults.removeObject(forKey: "idReporteLocal")
        
        //defaults.addObserver(self, forKeyPath: "sesion", options: NSKeyValueObservingOptions(), context: &defaultsContext)
        
        if usuario.text! != "" && contrasena.text! != "" {
            
            
            DispatchQueue.main.async {
                
                //_ = SwiftSpinner.show("Conectando con servidor")
                
            }
            
            
            el_sync.iniciar_sesion(usuario: usuario.text!, contrasena: contrasena.text!,controlador: self)
            //ir_inicio()
            
        }
        else{
            
            
            let alertController = UIAlertController(title: "On Trade", message: "Es necesario ingresar tus credenciales", preferredStyle: .alert)
            
            // Create the actions
            
            
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                UIAlertAction in
                NSLog("click ok")
                //self.confirmar_borrado(sender.tag)
                
                
            }
            
            
            
            
            
            
            
            
            // Add the actions
            alertController.addAction(okAction)
            
            
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            
            
        }
        
    }
    
    
    
    func ir_inicio(){
        
        crashlytics_user()
        
        print("vamonos a inicio")
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "logintoinicio", sender: self)
            
        }
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
    
    
    
    
    
}



