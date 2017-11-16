//
//  EncuestasRepeticiones.swift
//  OnTrade2
//
//  Created by Daniel Cedeño García on 10/25/16.
//  Copyright © 2016 Go Sharp. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import MapKit



class EncuestasRepeticiones: UIViewController,UIScrollViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate {
    
    
    var db:DB_Manager = DB_Manager()
    var base:String = ""
    
    
    var el_sync:Sincronizador = Sincronizador()
    
    
    var timezone:String!
    var accuracy:String!
    var satelliteUTC:String!
    var fechaActual:String!
    var el_hash:String?
    var tiempo_milisegundos = Date().timeIntervalSince1970
    
    var ultima_fecha_locacion = Date().timeIntervalSince1970
    
    let defaults = UserDefaults.standard
    
    var timer:Timer = Timer()
    
    var encuesta:[String:AnyObject] = [:]
    
    //var laEncuesta:EncuestaConstructor = EncuestaConstructor()
    
    var laVista:UIScrollView = UIScrollView()
    
    var barraTitulo:UIScrollView = UIScrollView()
    
    var barraSubTitulo:UIScrollView = UIScrollView()
    
    var color_letra = "c70752"
    
    var fontFamilia = "Dosis-Regular"
    
    var textoSubTitulo:UIButton = UIButton()
    
    // MARK: - Funciones de inicio de vista
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        base = defaults.object(forKey: "base") as! String
        
        
        if self.revealViewController() != nil {
            
            //botonLogo.targetForAction(#selector(SWRevealViewController.revealToggle(_:)), withSender: self)
            //botonLogo.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchDown)
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        
        
    }
    
    
    
    //view didapper
    override func viewDidAppear(_ animated: Bool) {
        
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
        
        let nombreEncuesta = defaults.object(forKey: "nombreEncuesta") as! String
        
        textoSubTitulo.setAttributedTitle(nil, for: UIControlState())
        textoSubTitulo.setTitle(nombreEncuesta, for: UIControlState())
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
        
        laVista.frame = CGRect(x: 0, y: barraSubTitulo.frame.height + barraSubTitulo.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height - barraSubTitulo.frame.height - barraSubTitulo.frame.origin.y)
        
        self.view.addSubview(laVista)
        
        self.view.addSubview(barraTitulo)
        
        self.view.addSubview(barraSubTitulo)
        
        
        let botoMenu:UIButton = UIButton()
        
        botoMenu.titleLabel!.font = UIFont(name: "TitilliumWeb-Regular", size: CGFloat(3))
        
        botoMenu.titleLabel!.font = botoMenu.titleLabel!.font.withSize(CGFloat(20))
        
        
        botoMenu.setAttributedTitle(nil, for: UIControlState())
        botoMenu.setTitle("Menú", for: UIControlState())
        
        botoMenu.isSelected = false
        botoMenu.setTitleColor(UIColor(rgba: "#FFFFFF"), for: UIControlState())
        
        
        
        botoMenu.titleLabel!.textColor = UIColor(rgba: "#ffffff")
        botoMenu.titleLabel!.numberOfLines = 0
        botoMenu.titleLabel!.textAlignment = .right
        
        
        botoMenu.sizeToFit()
        
        botoMenu.frame = CGRect(x: self.view.frame.width/2, y: 5, width: self.view.frame.width/2, height: barraTitulo.frame.height)
        
        botoMenu.contentHorizontalAlignment = .right
        botoMenu.contentVerticalAlignment = .center
        
        botoMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchDown)
        
        
        
        let botoRegresar:UIButton = UIButton()
        
        botoRegresar.titleLabel!.font = UIFont(name: "TitilliumWeb-Regular", size: CGFloat(3))
        
        botoRegresar.titleLabel!.font = botoMenu.titleLabel!.font.withSize(CGFloat(20))
        
        
        botoRegresar.setAttributedTitle(nil, for: UIControlState())
        botoRegresar.setTitle("Regresar", for: UIControlState())
        
        botoRegresar.isSelected = false
        botoRegresar.setTitleColor(UIColor(rgba: "#FFFFFF"), for: UIControlState())
        
        
        
        botoRegresar.titleLabel!.textColor = UIColor(rgba: "#ffffff")
        botoRegresar.titleLabel!.numberOfLines = 0
        botoRegresar.titleLabel!.textAlignment = .left
        
        
        botoRegresar.sizeToFit()
        
        botoRegresar.frame = CGRect(x: 5, y: 5, width: self.view.frame.width/2 - 10, height: barraTitulo.frame.height)
        
        botoRegresar.contentHorizontalAlignment = .left
        botoRegresar.contentVerticalAlignment = .center
        
        botoRegresar.addTarget(self, action: #selector(EncuestasRepeticiones.regresar(sender:)), for: .touchDown)
        
        self.view.addSubview(botoMenu)
        self.view.addSubview(botoRegresar)
        
        
        
        self.view.backgroundColor = UIColor(rgba: "#c70752")
        
        db.open_database(base)
        
        let idReporteLocal = defaults.object(forKey: "idReporteLocal") as! NSNumber
        
        
        let idPoll = defaults.object(forKey: "idPoll") as! NSNumber
        
        
        let sqlEncuestas = "select distinct(EARespuesta.numeroEncuesta) as numero from EARespuesta where idReporteLocal = '\(idReporteLocal)' and idEncuesta = '\(idPoll)' order by numeroEncuesta ASC"
        
        let resultadoEncuestas = db.select_query_columns(sqlEncuestas)
        
        let tamano_letra_menu:CGFloat = 15
        
        var offsetScroll = barraTitulo.frame.origin.y + barraTitulo.frame.height + 20
        
        let offsetx:CGFloat = 0
        
        let alto_menu:CGFloat = 30
        
        
        let botonAgregar:UIButton = UIButton()
        
        botonAgregar.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonAgregar.titleLabel!.font = botonAgregar.titleLabel!.font.withSize(CGFloat(14))
        
        
        botonAgregar.setAttributedTitle(nil, for: UIControlState())
        botonAgregar.setTitle("Agregar +", for: UIControlState())
        botonAgregar.tag = 0
        
        botonAgregar.isSelected = false
        botonAgregar.setTitleColor(UIColor(rgba: "#c70752"), for: UIControlState())
        
        
        
        botonAgregar.titleLabel!.textColor = UIColor(rgba: "#c70752")
        botonAgregar.titleLabel!.numberOfLines = 0
        botonAgregar.titleLabel!.textAlignment = .center
        
        
        botonAgregar.sizeToFit()
        
        botonAgregar.frame = CGRect(x: 5, y: 0, width: barraSubTitulo.frame.width, height: barraSubTitulo.frame.height)
        
        
        
        botonAgregar.contentHorizontalAlignment = .left
        botonAgregar.contentVerticalAlignment = .center
        
        botonAgregar.addTarget(self, action:#selector(EncuestasRepeticiones.agregar_encuesta(sender:)), for:.touchDown)
        
        barraSubTitulo.addSubview(botonAgregar)
        
        offsetScroll += 20
        
        defaults.set(resultadoEncuestas.count + 1, forKey: "siguienteEncuesta")
        
        let repeticiones = defaults.object(forKey: "Repeticiones") as! Int
        
        if resultadoEncuestas.count >= repeticiones {
            
            botonAgregar.isHidden = true
        }
        
        for renglonEncuesta in resultadoEncuestas {
            
            let botonEncuesta:UIButton = UIButton()
            
            botonEncuesta.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
            
            botonEncuesta.titleLabel!.font = botonEncuesta.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
            
            
            botonEncuesta.setAttributedTitle(nil, for: UIControlState())
            botonEncuesta.setTitle("Encuesta \(renglonEncuesta["numero"]!)", for: UIControlState())
            botonEncuesta.tag = renglonEncuesta["numero"] as! Int
            
            botonEncuesta.isSelected = false
            botonEncuesta.setTitleColor(UIColor(rgba: "#ffffff"), for: UIControlState())
            
            
            
            botonEncuesta.titleLabel!.textColor = UIColor(rgba: "#ffffff")
            botonEncuesta.titleLabel!.numberOfLines = 0
            botonEncuesta.titleLabel!.textAlignment = .left
            
            
            botonEncuesta.sizeToFit()
            
            botonEncuesta.frame = CGRect(x: offsetx, y: offsetScroll, width: laVista.frame.width - offsetx, height: alto_menu)
            
            
            
            botonEncuesta.contentHorizontalAlignment = .left
            botonEncuesta.contentVerticalAlignment = .center
            
            
            //botonListaEncuestas(UIImage(named: "MenuHome"), forState: .Normal)
            
            
            botonEncuesta.addTarget(self, action:#selector(EncuestasRepeticiones.iraEncuesta(sender:)), for:.touchDown)
            
            
            
            laVista.addSubview(botonEncuesta)
            
            offsetScroll += botonEncuesta.frame.height + 40
            
        }
        
        
        //laVista.contentSize = CGSizeMake(laVista.contentSize.width, offsetScroll)
        
        laVista.contentSize = CGSize(width: laVista.contentSize.width, height: offsetScroll)
    }
    
    //fin viewdidappear
    
    
    // MARK: - Funciones de fin de vista
    
    // view will disappear
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        
    }
    
    // MARK: - Funciones que llevan a otro modulo
    
    @objc func regresar(sender:UIButton){
    
        self.performSegue(withIdentifier: "encuestastolistaencuestas", sender: self)
    
    }
    
    
   
    
    @objc func agregar_encuesta(sender:UIButton) {
        
        let siguienteEncuesta = defaults.object(forKey: "siguienteEncuesta") as!NSNumber
        
        defaults.set(siguienteEncuesta, forKey: "numeroEncuesta")
        
        self.performSegue(withIdentifier: "encuestasrepeticionestoencuesta", sender: self)
        
    }
    
    @objc func iraEncuesta(sender:UIButton) {
        
        
        
        defaults.set(sender.tag, forKey: "numeroEncuesta")
        
        self.performSegue(withIdentifier: "encuestasrepeticionestoencuesta", sender: self)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

