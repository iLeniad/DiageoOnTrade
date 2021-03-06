//
//  ListaEncuestas.swift
//  OnTrade2
//
//  Created by Daniel Cedeño García on 10/24/16.
//  Copyright © 2016 Go Sharp. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import MapKit
import Alamofire


class EncuestasController: UIViewController,UIScrollViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate {
    
    
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
    
    var color_letra = "ffffff"
    
    var fontFamilia = "Dosis-Regular"
    
    var offsetScroll:CGFloat = 0
    
    var tamano_letra_menu:CGFloat = 15
    
    var alto_menu:CGFloat = 0
    
    
    
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
        
        
        
        let barraTitulo:UIScrollView = UIScrollView()
        
        barraTitulo.backgroundColor = UIColor(rgba: "#c70752")
        
        barraTitulo.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        
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
        textoSubTitulo.setTitle("Encuestas", for: UIControlState())
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
        
        botoRegresar.addTarget(self, action: #selector(EncuestasController.regresar(sender:)), for: .touchDown)
        
        
        
        
        
        self.view.addSubview(barraTitulo)
        
        self.view.addSubview(barraSubTitulo)
        
        self.view.backgroundColor = UIColor(rgba: "#c70752")
        
        
        
        self.view.addSubview(botoMenu)
        self.view.addSubview(botoRegresar)
        
        
        laVista.frame = CGRect(x: 0, y: barraSubTitulo.frame.height + barraSubTitulo.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height - barraSubTitulo.frame.height - barraSubTitulo.frame.origin.y)
        
        
        

        
        self.view.addSubview(laVista)
        
        
        
        //boton finalizar encuesta
        
        
        
        let idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
        
        print(idReporteLocal as Any)
        
        if idReporteLocal == nil {
            
            
            
            
            
        }
        else{
            
            mostrar_encuestas()
            
        }
        
        
    }
    
    //fin viewdidappear
    
    
    
    
    
    
    //mostrar encuestas
    
    
    func mostrar_encuestas(){
        
        
        
        
        tamano_letra_menu = 20
        
        
        db.open_database(base)
        
       
        
        var preguntasFaltantes:Int = 99999
        
        let idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
        
        print(idReporteLocal as Any)
        
        if idReporteLocal != nil {
            
            
            
            
            let sqlPreguntasContestadas = "select count(*) as cuenta from ea_question where id not in (select idPregunta from EARespuesta where idReporteLocal = '\(idReporteLocal!)') and poll in (select id from ea_poll)"
            
            print(sqlPreguntasContestadas)
            
            let resultadoPreguntasContestadas = db.select_query_columns(sqlPreguntasContestadas)
            
            
            
            for renglonPreguntasContestadas in resultadoPreguntasContestadas {
                
                preguntasFaltantes = renglonPreguntasContestadas["cuenta"] as! Int
                
            }
            
        }
        
        let idPdv = defaults.object(forKey: "idCDC") as! Int
        let PdvCanal = defaults.object(forKey: "idCanal") as! Int
        let PdvCliente = defaults.object(forKey: "idCliente") as! Int
        let PdvRtm = defaults.object(forKey: "idRtm") as! Int
        
        let tiempo_milisegundos = String(Int64(NSDate().timeIntervalSince1970*1000))
        
        let sqlEncuestas = "select * from ea_poll where date_start < '\(tiempo_milisegundos)' AND date_end > '\(tiempo_milisegundos)' AND (instr(pdv, '@\(idPdv)@') > 0 or pdv = '') and (canal = '' or instr(canal, '@\(PdvCanal)@') > 0)  and (rtm = '' or instr(rtm, '@\(PdvRtm)@') > 0) and (client = '' or instr(client, '@\(PdvCliente)@') > 0)"
        
        print(sqlEncuestas)
        
        let resultadoEncuestas = db.select_query_columns(sqlEncuestas)
        
        
        
        offsetScroll = barraTitulo.frame.origin.y + barraTitulo.frame.height + 20
        
        let offsetx:CGFloat = 5
        
        alto_menu = laVista.frame.height/12
        
        
        
        let botonUsuario:UIButton = UIButton()
        
        botonUsuario.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonUsuario.titleLabel!.font = botonUsuario.titleLabel!.font.withSize(12)
        
        
        botonUsuario.tag = 1
        
        botonUsuario.isSelected = false
        botonUsuario.setTitleColor(UIColor(rgba: "#5b5c5d"), for: UIControlState())
        
        
        
        botonUsuario.titleLabel!.textColor = UIColor(rgba: "#5b5c5d")
        botonUsuario.titleLabel!.numberOfLines = 0
        botonUsuario.titleLabel!.textAlignment = .right
        
        
        botonUsuario.sizeToFit()
        
        botonUsuario.frame = CGRect(x: 0, y: 0, width: barraTitulo.frame.width - 10, height: barraTitulo.frame.height)
        
        
        
        botonUsuario.contentHorizontalAlignment = .right
        botonUsuario.contentVerticalAlignment = .center
        
        botonUsuario.setImage(UIImage(named:"SiluetaUsuario"), for: .normal)
        //botonListaEncuestas(UIImage(named: "MenuHome"), forState: .Normal)
        
        botonUsuario.addTarget(self, action:#selector(EncuestasController.mostrarUsuario(sender:)), for:.touchDown)
        
        barraTitulo.addSubview(botonUsuario)
        
        
        let botonFinalizarEncuesta:UIButton = UIButton()
        
        botonFinalizarEncuesta.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonFinalizarEncuesta.titleLabel!.font = botonFinalizarEncuesta.titleLabel!.font.withSize(14)
        
        
        botonFinalizarEncuesta.setAttributedTitle(nil, for: UIControlState())
        botonFinalizarEncuesta.setTitle("Finalizar Encuesta", for: UIControlState())
        botonFinalizarEncuesta.tag = 1
        
        botonFinalizarEncuesta.isSelected = false
        botonFinalizarEncuesta.setTitleColor(UIColor(rgba: "#5b5c5d"), for: UIControlState())
        
        
        
        botonFinalizarEncuesta.titleLabel!.textColor = UIColor(rgba: "#5b5c5d")
        botonFinalizarEncuesta.titleLabel!.numberOfLines = 0
        botonFinalizarEncuesta.titleLabel!.textAlignment = .right
        
        
        botonFinalizarEncuesta.sizeToFit()
        
        botonFinalizarEncuesta.frame = CGRect(x: 0, y: 0, width: barraSubTitulo.frame.width - 10, height: barraSubTitulo.frame.height)
        
        
        
        botonFinalizarEncuesta.contentHorizontalAlignment = .right
        botonFinalizarEncuesta.contentVerticalAlignment = .center
        
        
        //botonListaEncuestas(UIImage(named: "MenuHome"), forState: .Normal)
        
        botonFinalizarEncuesta.addTarget(self, action:#selector(EncuestasController.finalizarEncuesta(sender:)), for:.touchDown)
        
        barraSubTitulo.addSubview(botonFinalizarEncuesta)
        
        print("Faltan por contestar \(preguntasFaltantes)")
        
        if preguntasFaltantes > 0 {
            
            botonFinalizarEncuesta.isHidden = true
        }
        
        
        for renglonEncuesta in resultadoEncuestas {
            
            let botonEncuesta:UIButton = UIButton()
            
            botonEncuesta.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
            
            botonEncuesta.titleLabel!.font = botonEncuesta.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
            
            //let nombreUsuario = "\(renglonEncuesta["name"] as? String) \(renglonEncuesta["lastName"] as? String)"
            
            botonEncuesta.setAttributedTitle(nil, for: UIControlState())
            botonEncuesta.setTitle(renglonEncuesta["name"]! as? String, for: UIControlState())
            botonEncuesta.tag = renglonEncuesta["id"] as! Int
            
            botonEncuesta.isSelected = false
            botonEncuesta.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
            
            
            
            botonEncuesta.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
            botonEncuesta.titleLabel!.numberOfLines = 0
            botonEncuesta.titleLabel!.textAlignment = .left
            
            
            botonEncuesta.sizeToFit()
            
            botonEncuesta.frame = CGRect(x: offsetx, y: offsetScroll, width: laVista.frame.width - offsetx, height: alto_menu)
            
            
            
            botonEncuesta.contentHorizontalAlignment = .left
            botonEncuesta.contentVerticalAlignment = .center
            
            
            let idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
            
            print(idReporteLocal as Any)
            
            var preguntasFaltantesEncuesta = 0
            
            if idReporteLocal != nil {
                
                
                
                
                let sqlPreguntasContestadas = "select count(*) as cuenta from ea_question where id not in (select idPregunta from EARespuesta where idReporteLocal = '\(idReporteLocal!)') and poll = '\(botonEncuesta.tag)'"
                
                print(sqlPreguntasContestadas)
                
                let resultadoPreguntasContestadas = db.select_query_columns(sqlPreguntasContestadas)
                
                
                
                for renglonPreguntasContestadas in resultadoPreguntasContestadas {
                    
                    preguntasFaltantesEncuesta = renglonPreguntasContestadas["cuenta"] as! Int
                    
                }
                
                if preguntasFaltantesEncuesta <= 0 {
                    
                    //botonEncuesta.backgroundColor = UIColor(rgba: "#94003a")
                    
                    botonEncuesta.setImage(UIImage(named:"Check"), for: .normal)
                    
                    botonUsuario.titleEdgeInsets = UIEdgeInsetsMake(0, -botonUsuario.imageView!.frame.size.width, 0, 0)
                    
                    botonEncuesta.imageView?.contentMode = .center
                    
                }
                
            }
            
            
            
            
            //botonListaEncuestas(UIImage(named: "MenuHome"), forState: .Normal)
            let repeticiones = renglonEncuesta["repeat_ea_poll"] as! Int
            
            print("sus repeticiones son \(repeticiones)")
            
            if repeticiones < 2 {
                
                botonEncuesta.addTarget(self, action:#selector(EncuestasController.iraEncuesta(sender:)), for:.touchDown)
                
            }
            else{
                
                let idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
                
                print(idReporteLocal as Any)
                
                if idReporteLocal != nil {
                    
                    defaults.set(repeticiones, forKey: "Repeticiones")
                    
                    botonEncuesta.addTarget(self, action:#selector(EncuestasController.iraEncuestasRepeticiones(sender:)), for:.touchDown)
                    
                }
                
                
                
            }
            
            laVista.addSubview(botonEncuesta)
            
            offsetScroll += botonEncuesta.frame.height + 40
            
        }
        
        
        //laVista.contentSize = CGSizeMake(laVista.contentSize.width, offsetScroll)
        
        laVista.contentSize = CGSize(width: laVista.contentSize.width, height: offsetScroll)
        
        
    }
    
    
    
    //fin mostrar encuestas
    
    
    // MARK: - Funciones que llevan a otro modulo
    
    @objc func regresar(sender:UIButton){
        
        self.performSegue(withIdentifier: "encuestastomodulos", sender: self)
        
    }
    
    
    @objc func iraEncuestaNueva(sender:UIButton){
        
        let subviews = laVista.subviews
        
        for subvista in subviews {
            
            subvista.removeFromSuperview()
            
        }
        
        mostrar_encuestas()
    }
  
    @objc func iraEncuestasRepeticiones(sender:UIButton) {
        
        defaults.set(sender.tag, forKey: "idPoll")
        
        defaults.set(sender.titleLabel?.text!, forKey: "nombreEncuesta")
        
        self.performSegue(withIdentifier: "encuestastoencuestasrepeticiones", sender: self)
        
        
    }
    
    @objc func iraEncuesta(sender:UIButton) {
        
        defaults.set(sender.tag, forKey: "idPoll")
        
        defaults.set(sender.titleLabel?.text!, forKey: "nombreEncuesta")
        
        defaults.set(1, forKey: "numeroEncuesta")
        
        self.performSegue(withIdentifier: "encuestastoencuesta", sender: self)
        
    }
    
    
    // MARK: - Funciones que muestran en pantalla
    
    @objc func mostrarUsuario(sender:UIButton){
        
        
        let vistaUsuario:UIScrollView = UIScrollView()
        
        vistaUsuario.backgroundColor = UIColor(rgba: "#303132")
        
        vistaUsuario.frame = CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        var offsetScroll:CGFloat = 20
        
        db.open_database(base)
        
        
        let sqlInfoUser = "select * from user_info"
        
        let resultadoInfoUser = db.select_query_columns(sqlInfoUser)
        
        //var miIdUser:NSNumber = 0
        
        var miNombre = ""
        
        for rengloInfoUser in resultadoInfoUser {
            
            //miIdUser = rengloInfoUser["id"] as! NSNumber
            miNombre = rengloInfoUser["name"] as! String
            
        }
        
        let miSilueta:UIImageView = UIImageView()
        
        miSilueta.image = UIImage(named: "SiluetaUsuario")
        
        miSilueta.frame = CGRect(x: 0, y: offsetScroll, width: barraTitulo.frame.width, height: self.view.frame.height/4)
        
        miSilueta.contentMode = .top
        
        let miNombreLabel:UIButton = UIButton()
        
        miNombreLabel.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        miNombreLabel.titleLabel!.font = miNombreLabel.titleLabel!.font.withSize(CGFloat(12))
        
        
        print(miNombre)
        
        miNombreLabel.setAttributedTitle(nil, for: UIControlState())
        miNombreLabel.setTitle(miNombre, for: UIControlState())
        miNombreLabel.tag = 0
        
        miNombreLabel.isSelected = false
        miNombreLabel.setTitleColor(UIColor(rgba: "#ffffff"), for: UIControlState())
        
        
        
        miNombreLabel.titleLabel!.textColor = UIColor(rgba: "#ffffff")
        miNombreLabel.titleLabel!.numberOfLines = 0
        miNombreLabel.titleLabel!.textAlignment = .center
        
        
        miNombreLabel.sizeToFit()
        
        miNombreLabel.frame = CGRect(x: 0, y: miSilueta.frame.height, width: barraTitulo.frame.width, height: barraTitulo.frame.height/2)
        
        
        
        miNombreLabel.contentHorizontalAlignment = .center
        miNombreLabel.contentVerticalAlignment = .center
        
        vistaUsuario.addSubview(miSilueta)
        vistaUsuario.addSubview(miNombreLabel)
        
        let idUser = defaults.object(forKey: "idUser") as! Int
        
        let sqlListaUsuarios = "select * from all_users where idUser = '\(idUser)' order by name asc"
        
        print(sqlListaUsuarios)
        
        let resultadoUsuarios = db.select_query_columns(sqlListaUsuarios)
        
        let tamano_letra_menu:CGFloat = 15
        
        
        
        let offsetx:CGFloat = laVista.frame.width/15
        
        let alto_menu:CGFloat = laVista.frame.height/12
        
        offsetScroll = miNombreLabel.frame.height + miNombreLabel.frame.origin.y + 20
        
        for renglonUsuario in resultadoUsuarios {
            
            let botonUsuario:UIButton = UIButton()
            
            botonUsuario.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
            
            botonUsuario.titleLabel!.font = botonUsuario.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
            
            let nombreUsuario = "\(renglonUsuario["name"] as! String) \(renglonUsuario["lastName"] as! String)"
            
            botonUsuario.setAttributedTitle(nil, for: UIControlState())
            botonUsuario.setTitle(nombreUsuario, for: UIControlState())
            botonUsuario.tag = renglonUsuario["idUser"] as! Int
            
            botonUsuario.isSelected = false
            botonUsuario.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
            
            
            
            botonUsuario.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
            botonUsuario.titleLabel!.numberOfLines = 0
            botonUsuario.titleLabel!.textAlignment = .left
            
            
            botonUsuario.sizeToFit()
            
            botonUsuario.frame = CGRect(x: offsetx, y: offsetScroll, width: laVista.frame.width - offsetx, height: alto_menu)
            
            
            
            botonUsuario.contentHorizontalAlignment = .left
            botonUsuario.contentVerticalAlignment = .center
            
            
            botonUsuario.setImage(UIImage(named: "SiluetaUsuario"), for: .normal)
            
            botonUsuario.imageView?.contentMode = .scaleAspectFit
            
            botonUsuario.titleEdgeInsets = UIEdgeInsetsMake(0, botonUsuario.imageView!.frame.size.width, 0, 0)
            
            //botonUsuario.imageEdgeInsets = UIEdgeInsetsMake(0, -botonUsuario.imageView!.frame.size.width, 0, botonUsuario.imageView!.frame.size.width);
            //botonUsuario.titleEdgeInsets = UIEdgeInsetsMake(18, botonUsuario.titleLabel!.frame.size.width + 10, 18, -botonUsuario.titleLabel!.frame.size.width);
            
            botonUsuario.addTarget(self, action:#selector(EncuestasController.ocultarUsuario(sender:)), for:.touchDown)
            
            vistaUsuario.addSubview(botonUsuario)
            
            offsetScroll += botonUsuario.frame.height + 40
            
        }
        
        
        //laVista.contentSize = CGSizeMake(laVista.contentSize.width, offsetScroll)
        
        vistaUsuario.contentSize = CGSize(width: vistaUsuario.contentSize.width, height: offsetScroll)
        
        self.view.addSubview(vistaUsuario)
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [],animations: {
            
            vistaUsuario.frame.origin.x = 0
            
            // self.username.center.x += self.view.bounds.width
            }, completion: nil)
        
    }
    
    @objc func ocultarUsuario(sender:UIButton){
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [],animations: {
            
            sender.superview?.frame.origin.x = self.view.frame.width
            
            // self.username.center.x += self.view.bounds.width
            }, completion: {finished in
                
                sender.superview?.removeFromSuperview()
                // the code you put here will be executed when your animation finishes, therefore
                // call your function here
        } )
        
    }
    
    
    @objc func mostrar_respuestas_anteriores(sender:UIButton){
        
        defaults.set(sender.tag, forKey: "idReportAnterior")
        
        defaults.set(sender.titleLabel?.text!, forKey: "nombreRoleAnterior")
        
        self.performSegue(withIdentifier: "encuestastorespuestasanteriores", sender: self)
        
        
    }
    
    
    @objc func finalizarEncuesta (sender:UIButton){
        
        let subvistas = laVista.subviews
        
        for subvista in subvistas {
            
            subvista.isUserInteractionEnabled = false
            
        }
        
        
        
        
        let timezone = NSTimeZone.local.identifier
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"
        
        let ubicacion = obtener_ubicacion()
        
        print(ubicacion)
        
        let tiempo_milisegundos = String(Int64(NSDate().timeIntervalSince1970*1000))
        
        
        let sateliteUTC = obtener_fecha_satelite()
        
        
        let idReporteLocal = defaults.object(forKey: "idReporteLocal")
        
        let sqlCheckOut = "update report set checkOut='\(tiempo_milisegundos)',checkOutTz='\(timezone)',checkOutSateliteUTC='\(sateliteUTC)' where id = '\(idReporteLocal!)'"
        
        print(sqlCheckOut)
        
        let resultadoCheckOut = db.execute_query(sqlCheckOut)
        
        print(resultadoCheckOut)
        
        defaults.removeObject(forKey: "idReporteLocal")
        defaults.removeObject(forKey: "idUser")
        defaults.removeObject(forKey: "idRole")
        
        
        let botonEncuestaEnviar:UIButton = UIButton()
        
        botonEncuestaEnviar.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonEncuestaEnviar.titleLabel!.font = botonEncuestaEnviar.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
        
        
        botonEncuestaEnviar.setAttributedTitle(nil, for: UIControlState())
        botonEncuestaEnviar.setTitle("Enviar Encuesta", for: UIControlState())
        botonEncuestaEnviar.tag = 0
        
        botonEncuestaEnviar.isSelected = false
        botonEncuestaEnviar.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
        
        
        
        botonEncuestaEnviar.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
        botonEncuestaEnviar.titleLabel!.numberOfLines = 0
        botonEncuestaEnviar.titleLabel!.textAlignment = .center
        
        
        botonEncuestaEnviar.sizeToFit()
        
        botonEncuestaEnviar.frame = CGRect(x: 0, y: offsetScroll, width: laVista.frame.width, height: alto_menu)
        
        
        
        botonEncuestaEnviar.contentHorizontalAlignment = .center
        botonEncuestaEnviar.contentVerticalAlignment = .center
        
        //self.performSegue(withIdentifier: "listaencuestastoinicio", sender: self)
        
        botonEncuestaEnviar.addTarget(self, action: #selector(EncuestasController.enviar_encuesta(sender:)), for: .touchDown)
        
        
        laVista.addSubview(botonEncuestaEnviar)
        
    }
    
    @objc func enviar_encuesta(sender:UIButton){
        
        
        let usuario = defaults.object(forKey: "usuario") as! String
        let contrasena = defaults.object(forKey: "contrasena") as! String
        
        el_sync.servicio_seriado_enviar(usuario: usuario, contrasena: contrasena, indice: 0)
        
        
    }
    
    // MARK: - Funciones de fin de vista
    
    // view will disappear
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        
    }
    
    //view will disappear
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

