//
//  ReportesEnviadosController.swift
//  OnTrade2
//
//  Created by Daniel Cedeño García on 10/28/16.
//  Copyright © 2016 Go Sharp. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import MapKit
import Alamofire



class ReportesEnviadosController: UIViewController,UIScrollViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate {
    
    
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
    
    // MARK: - Funciones inicio de vista
    
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
        textoSubTitulo.setTitle("Reportes Enviados", for: UIControlState())
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
        botoMenu.titleLabel!.textAlignment = .left
        
        
        botoMenu.sizeToFit()
        
        botoMenu.frame = CGRect(x: 5, y: 5, width: self.view.frame.width, height: barraTitulo.frame.height)
        
        botoMenu.contentHorizontalAlignment = .left
        botoMenu.contentVerticalAlignment = .center
        
        botoMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchDown)
        
        
        
        
        
        
        
        self.view.addSubview(barraTitulo)
        
        self.view.addSubview(barraSubTitulo)
        
        self.view.backgroundColor = UIColor(rgba: "#c70752")
        
        
        
        self.view.addSubview(botoMenu)
        
        
        laVista.frame = CGRect(x: 0, y: barraSubTitulo.frame.height + barraSubTitulo.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height - barraSubTitulo.frame.height - barraSubTitulo.frame.origin.y)
        
        
        
        
        
        self.view.addSubview(laVista)
        
        
        mostrar_reportes_enviados()
        //boton finalizar encuesta
        
        
        
        
        
        
    }
    
    //fin viewdidappear
    
    
    //reportes enviados
    
    
    func mostrar_reportes_enviados(){
        
        let subvistas = laVista.subviews
        
        for subvista in subvistas {
            
            subvista.removeFromSuperview()
            
        }
        
        offsetScroll = laVista.frame.height/18
        
        db.open_database(base)
        
        let sqlReportesEnviados = "select t1.*,t2.name from report t1, pdv_pdv t2 where t1.enviado = 1 and t1.place = t2.id order by id desc"
        
        print(sqlReportesEnviados)
        
        let resultadoReportesEnviados = db.select_query_columns(sqlReportesEnviados)
        
        let tamano_letra_menu:CGFloat = 15
        
        
        
        let offsetx:CGFloat = laVista.frame.width/15
        
        let alto_menu:CGFloat = laVista.frame.height/12
        
        
        
        for renglonReportesEnviados in resultadoReportesEnviados {
            
            let botonReportesEnviados:UIButton = UIButton()
            
            botonReportesEnviados.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
            
            botonReportesEnviados.titleLabel!.font = botonReportesEnviados.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
            
            
            
            let dateFormatter = DateFormatter()
            
            //dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'hh':'mm'"
            
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"
            
            let fecha = Date(timeIntervalSince1970: renglonReportesEnviados["checkIn"] as! Double/1000)
            
            let fechaFormateada = dateFormatter.string(from: fecha)
            
            
            
            
            botonReportesEnviados.setAttributedTitle(nil, for: UIControlState())
            botonReportesEnviados.setTitle(renglonReportesEnviados["name"] as! String + " " + fechaFormateada, for: UIControlState())
            botonReportesEnviados.tag = renglonReportesEnviados["id"] as! Int
            
            botonReportesEnviados.isSelected = false
            botonReportesEnviados.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
            
            
            
            botonReportesEnviados.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
            botonReportesEnviados.titleLabel!.numberOfLines = 0
            botonReportesEnviados.titleLabel!.textAlignment = .left
            
            
            botonReportesEnviados.sizeToFit()
            
            botonReportesEnviados.frame = CGRect(x: offsetx, y: offsetScroll, width: laVista.frame.width - offsetx, height: alto_menu)
            
            
            
            botonReportesEnviados.contentHorizontalAlignment = .left
            botonReportesEnviados.contentVerticalAlignment = .center
            
            
            //botonReportesEnviados.setImage(UIImage(named: "SiluetaUsuario"), for: .normal)
            
            //botonReportesEnviados.imageView?.contentMode = .scaleAspectFit
            
            //botonReportesEnviados.titleEdgeInsets = UIEdgeInsetsMake(0, botonReportesEnviados.imageView!.frame.size.width, 0, 0)
            
            //botonUsuario.imageEdgeInsets = UIEdgeInsetsMake(0, -botonUsuario.imageView!.frame.size.width, 0, botonUsuario.imageView!.frame.size.width);
            //botonUsuario.titleEdgeInsets = UIEdgeInsetsMake(18, botonUsuario.titleLabel!.frame.size.width + 10, 18, -botonUsuario.titleLabel!.frame.size.width);
            
            //botonReportesEnviados.addTarget(self, action:#selector(ReportesEnviadosController.iraEncuestas(sender:)), for:.touchDown)
            
            laVista.addSubview(botonReportesEnviados)
            
            offsetScroll += botonReportesEnviados.frame.height + 40
            
        }
        
        
        //laVista.contentSize = CGSizeMake(laVista.contentSize.width, offsetScroll)
        
        laVista.contentSize = CGSize(width: laVista.contentSize.width, height: offsetScroll)
        
        
    }
    
    
    //fin reportes enviados
    
    
    
    // view will disappear
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        
    }
    
    //view will disappear
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

