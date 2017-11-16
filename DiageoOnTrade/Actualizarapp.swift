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
    
    
    // MARK: - Funciones inicio de vista
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        base = defaults.object(forKey: "base") as! String
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        crear_pantalla_actualizacion()
        //el_sync.sincronizar(controlador: self)
        
    }
    
    
      func crear_pantalla_actualizacion(){
        
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
    
    // MARK: - Funciones para llevar a otro modulo
    
    @objc func actualizar_app(sender:UIButton){
        
        let url:NSURL = NSURL(string:"https://s3-us-west-1.amazonaws.com/gshpapps/Diageo/OnTradeIOS/index.html")!
        //UIApplication.shared.openURL(url as URL)
        UIApplication.shared.open(url as URL, completionHandler: nil)
        
        
    }
    
    // MARK: - Crashlytics
    
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

