//
//  Actualizarapp.swift
//  OnTrade2
//
//  Created by Daniel Cedeño García on 1/4/17.
//  Copyright © 2017 Go Sharp. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import Crashlytics
import Alamofire

class ActualizarAppController: UIViewController {
    
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
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        crear_menu()
        //el_sync.sincronizar(controlador: self)
        
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
        let protocolo = defaults.object(forKey: "protocolo") as! String
        
        let aux_url = "\(protocolo)://\(dominio)/capabilities-rest/rest/version/data/terms"
        
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
    
    func crear_menu(){
        
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
        
        
        let botonBase:UIButton = UIButton()
        
        botonBase.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonBase.titleLabel!.font = botonBase.titleLabel!.font.withSize(CGFloat(15))
        
        
        botonBase.setAttributedTitle(nil, for: UIControlState())
        botonBase.setTitle("Actualizar app", for: UIControlState())
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
        
        botonBase.addTarget(self, action:#selector(ActualizarAppController.actualizar_app(sender:)), for:.touchDown)
        
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
        
        
        
        
        
        self.view.addSubview(botonBase)
        //self.view.addSubview(botonContrasena)
        //self.view.addSubview(botonTerminos)
        
        print("pantala login creada")
        
    }
    
    @objc func actualizar_app(sender:UIButton){
        
        let url:NSURL = NSURL(string:"https://s3-us-west-1.amazonaws.com/gshpapps/Diageo/OnTradeIOS/index.html")!
        //UIApplication.shared.openURL(url as URL)
        UIApplication.shared.open(url as URL, completionHandler: nil)
        
        
    }
    
    
    @objc func enviar_base(sender:UIButton){
        
        print("simon enviar base")
        
        /*DispatchQueue.main.async {
            
            _ = SwiftSpinner.show("Base enviada. Toque para cerrar").addTapHandler({SwiftSpinner.hide()})
            
        }
 */
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

