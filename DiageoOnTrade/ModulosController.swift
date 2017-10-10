//
//  ModulosController.swift
//  OnTrade2
//
//  Created by Daniel Cedeño García on 10/19/16.
//  Copyright © 2016 Go Sharp. All rights reserved.
//

import Foundation
import GoogleMaps
import MapKit
import Alamofire
import CryptoSwift
import NVActivityIndicatorView

class ModulosController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {
    
    //variables
    
    var el_sync:Sincronizador = Sincronizador()
    
    let defaults = UserDefaults.standard
    
    var db:DB_Manager = DB_Manager()
    
    var laVista: UIScrollView! = UIScrollView()
    var menuButton: UIButton! = UIButton()
    
    var el_mapa: GMSMapView = GMSMapView()
    
    var offsetScroll:CGFloat = 21
    
    var aux_posicion=UIButton()
    
    var tipo = ""
    
    var tags:[AnyObject] = []
    
    var color_letra = "ffffff"
    
    var fontFamilia = "Dosis-Regular"
    
    var barraTitulo:UIScrollView = UIScrollView()
    
    var tamano_letra_menu:CGFloat = 15
    
    var skaPdv:[[String:AnyObject]] = [[:]]
    
    var botoMenu:UIButton = UIButton()
    
    var skaVista:UIScrollView = UIScrollView()
    
    var barraSubTitulo:UIScrollView = UIScrollView()
    
    
    var textoSubTitulo:UIButton = UIButton()
    
    var botonCheckin:UIButton = UIButton()
    
    var botonDistribucion:UIButton = UIButton()
    
    var botonPromocion:UIButton = UIButton()
    
    var botonVisibilidad:UIButton = UIButton()
    
    var botonEncuesta:UIButton = UIButton()
    
    var botonCheckout:UIButton = UIButton()
    
    var distribucionEstatus = false
    
    var incidenciasBotones:[UIButton] = []
    
    var tipoReporte:Int = 1
    
    var campoOtro:UITextField = UITextField()
    
    lazy var locationManager: CLLocationManager! = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    var vistaCargador:UIScrollView = UIScrollView()
    
    //fin variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            
            //menuButton.targetForAction("revealToggle:", withSender: self)
            //menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchDown)
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
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
        
        let auxidCDC = defaults.object(forKey: "idCDC") as! NSNumber
        
        let sqlNombre = "select * from pdv_pdv where id = '\(auxidCDC)'"
        
        let base = defaults.object(forKey: "base") as! String
        
        db.open_database(base)
        
        
        
        let resultadoSqlNombre = db.select_query_columns(sqlNombre)
        
        let auxNombre = resultadoSqlNombre[0]["name"] as! String
        
        textoSubTitulo.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        textoSubTitulo.titleLabel!.font = textoSubTitulo.titleLabel!.font.withSize(CGFloat(14))
        
        
        
        textoSubTitulo.setAttributedTitle(nil, for: UIControlState())
        textoSubTitulo.setTitle(auxNombre, for: UIControlState())
        textoSubTitulo.tag = 0
        
        textoSubTitulo.isSelected = false
        textoSubTitulo.setTitleColor(UIColor(rgba: "#c70752"), for: UIControlState())
        
        
        
        textoSubTitulo.titleLabel!.textColor = UIColor(rgba: "#c70752")
        textoSubTitulo.titleLabel!.numberOfLines = 0
        textoSubTitulo.titleLabel!.textAlignment = .left
        
        
        //textoSubTitulo.sizeToFit()
        
        
        
        
        
        textoSubTitulo.contentHorizontalAlignment = .left
        textoSubTitulo.contentVerticalAlignment = .center
        
        
        
        let textoSubTituloIzquierda:UIButton = UIButton()
        
        textoSubTituloIzquierda.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        textoSubTituloIzquierda.titleLabel!.font = textoSubTituloIzquierda.titleLabel!.font.withSize(CGFloat(14))
        
        
        
        textoSubTituloIzquierda.setAttributedTitle(nil, for: UIControlState())
        textoSubTituloIzquierda.setTitle("Menú Reporte", for: UIControlState())
        textoSubTituloIzquierda.tag = 0
        
        textoSubTituloIzquierda.isSelected = false
        textoSubTituloIzquierda.setTitleColor(UIColor(rgba: "#c70752"), for: UIControlState())
        
        
        
        textoSubTituloIzquierda.titleLabel!.textColor = UIColor(rgba: "#c70752")
        textoSubTituloIzquierda.titleLabel!.numberOfLines = 0
        textoSubTituloIzquierda.titleLabel!.textAlignment = .left
        
        
        //textoSubTituloIzquierda.sizeToFit()
        
        textoSubTituloIzquierda.frame = CGRect(x: 5, y: 0, width: barraSubTitulo.frame.width/4, height: barraSubTitulo.frame.height)
        
        textoSubTituloIzquierda.titleLabel!.adjustFontSizeToFitRect(rect: textoSubTituloIzquierda.frame, maximo: 14)
        
        textoSubTitulo.frame = CGRect(x: textoSubTituloIzquierda.frame.origin.x + textoSubTituloIzquierda.frame.width + 5, y: 0, width: barraSubTitulo.frame.width, height: barraSubTitulo.frame.height)
        
        textoSubTituloIzquierda.contentHorizontalAlignment = .left
        textoSubTituloIzquierda.contentVerticalAlignment = .center
        
        
        barraSubTitulo.addSubview(vistaFondoBarraSubtitulo)
        
        barraSubTitulo.addSubview(textoSubTitulo)
        barraSubTitulo.addSubview(textoSubTituloIzquierda)
        
        
        
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
        
        
        

        
        el_mapa.frame = CGRect(x: 0, y: barraSubTitulo.frame.origin.y + barraSubTitulo.frame.height, width: self.view.frame.width, height: self.view.frame.height/3)
        
       laVista.backgroundColor = UIColor(rgba: "#a42141")
        
        self.view.addSubview(barraTitulo)
      
        el_sync.acomodar_base()
        
        
        
        
      
        
        el_mapa.delegate=self
        
        
        el_mapa.settings.myLocationButton = true
        
        el_mapa.isMyLocationEnabled = true
        
        let miUbicacion = obtener_ubicacion()
        
        let camera = GMSCameraPosition.camera(withLatitude: miUbicacion.coordinate.latitude, longitude: miUbicacion.coordinate.longitude, zoom: 12)
        
        el_mapa.camera = camera
        
        
        laVista.frame = CGRect(x: 0, y: el_mapa.frame.height + el_mapa.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height - el_mapa.frame.origin.y - el_mapa.frame.height)
        
        
        
        self.view.addSubview(botoMenu)
        self.view.addSubview(laVista)
        
        
        
        print("Estamos en Modulos")

        
        crear_menu()
    }
    
    
    
   
    
    func crear_menu(){
        
        
        let subvistas = laVista.subviews
        
        for subvista in subvistas {
        
            subvista.removeFromSuperview()
        
        }
        
        
        let offsetx:CGFloat = laVista.frame.width/15
        
        let alto_menu:CGFloat = laVista.frame.height/12
        
        let idReporteLocal = defaults.object(forKey: "idReporteLocal")
        
        if idReporteLocal != nil {
        
        botonCheckin.setImage(UIImage(named: "TareaCompleta"), for: .normal)
        
        botonCheckin.imageView?.contentMode = .left
        
        botonCheckin.titleEdgeInsets = UIEdgeInsetsMake(0, botonDistribucion.imageView!.frame.size.width, 0, 0)
        
        botonCheckin.imageEdgeInsets = UIEdgeInsetsMake(0, -botonCheckin.imageView!.frame.size.width, 0, botonCheckin.imageView!.frame.size.width)
        botonCheckin.titleEdgeInsets = UIEdgeInsetsMake(18, botonCheckin.titleLabel!.frame.size.width + 10, 18, -botonCheckin.titleLabel!.frame.size.width)
            
        
            
            
            
        
        }
        
        botonCheckin.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonCheckin.titleLabel!.font = botonCheckin.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
        
        
        
        botonCheckin.setAttributedTitle(nil, for: UIControlState())
        botonCheckin.setTitle("CHECK IN", for: UIControlState())
        botonCheckin.tag = 0
        
        botonCheckin.isSelected = false
        botonCheckin.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
        
        
        
        botonCheckin.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
        botonCheckin.titleLabel!.numberOfLines = 0
        botonCheckin.titleLabel!.textAlignment = .left
        
        
        botonCheckin.sizeToFit()
        
        botonCheckin.frame = CGRect(x: offsetx, y: offsetScroll, width: laVista.frame.width - offsetx, height: alto_menu)
        
        
        
        botonCheckin.contentHorizontalAlignment = .left
        botonCheckin.contentVerticalAlignment = .center
        
        
        //botonCDC.setImage(UIImage(named: "SiluetaUsuario"), for: .normal)
        
        //botonCDC.imageView?.contentMode = .scaleAspectFit
        
        //botonUsuario.titleEdgeInsets = UIEdgeInsetsMake(0, botonUsuario.imageView!.frame.size.width, 0, 0)
        
        //botonUsuario.imageEdgeInsets = UIEdgeInsetsMake(0, -botonUsuario.imageView!.frame.size.width, 0, botonUsuario.imageView!.frame.size.width);
        //botonUsuario.titleEdgeInsets = UIEdgeInsetsMake(18, botonUsuario.titleLabel!.frame.size.width + 10, 18, -botonUsuario.titleLabel!.frame.size.width);
        
        botonCheckin.addTarget(self, action:#selector(ModulosController.hacer_checkin(sender:)), for:.touchDown)
        
        laVista.addSubview(botonCheckin)
        
        offsetScroll += botonCheckin.frame.height + 40
        
        
        
        if idReporteLocal != nil {
            
            
        let base = defaults.object(forKey: "base") as! String
        
        db.open_database(base)
            
            
            let sqlPromociones = "select t1.id,t2.value as categoria,t3.value as marca,t4.value as tipo from report_promotions t1, mpr_category t2, mpr_brand t3, mpr_type t4, report_promtions_brands t5 where t5.id_category=t2.idItemRelation and t5.id_brand=t3.idItemRelation and t1.id_type_promotion=t4.idItemRelation and t5.id_report_promotion = t1.id and t1.id_report_local = '\(idReporteLocal!)' group by t1.id"
            
            let resultadoPromociones = db.select_query_columns(sqlPromociones)
            
            if resultadoPromociones.count > 0 {
                
                botonPromocion.setImage(UIImage(named: "TareaCompleta"), for: .normal)
                
                botonPromocion.imageView?.contentMode = .left
                
                botonPromocion.titleEdgeInsets = UIEdgeInsetsMake(0, botonDistribucion.imageView!.frame.size.width, 0, 0)
                
                botonPromocion.imageEdgeInsets = UIEdgeInsetsMake(0, -botonPromocion.imageView!.frame.size.width, 0, botonPromocion.imageView!.frame.size.width)
                botonPromocion.titleEdgeInsets = UIEdgeInsetsMake(18, botonPromocion.titleLabel!.frame.size.width + 10, 18, -botonPromocion.titleLabel!.frame.size.width)
                
            }
            
            
            let sqlVisibilidad = "select t1.id,t2.value as categoria,t3.value as marca,t4.value as tipo from report_visibility t1, mv_category t2, mv_brand t3, mv_type t4, report_visibility_brands t5 where t5.id_category=t2.idItemRelation and t5.id_brand=t3.idItemRelation and t1.id_type=t4.idItemRelation and t1.id = t5.id_report_visibility and t1.id_report_local = '\(idReporteLocal!)' group by t1.id"
            
            let resultadoVisibilidad = db.select_query_columns(sqlVisibilidad)
            
            if resultadoVisibilidad.count > 0 {
                
                botonVisibilidad.setImage(UIImage(named: "TareaCompleta"), for: .normal)
                
                botonVisibilidad.imageView?.contentMode = .left
                
                botonVisibilidad.titleEdgeInsets = UIEdgeInsetsMake(0, botonDistribucion.imageView!.frame.size.width, 0, 0)
                
                botonVisibilidad.imageEdgeInsets = UIEdgeInsetsMake(0, -botonVisibilidad.imageView!.frame.size.width, 0, botonVisibilidad.imageView!.frame.size.width)
                botonVisibilidad.titleEdgeInsets = UIEdgeInsetsMake(18, botonVisibilidad.titleLabel!.frame.size.width + 10, 18, -botonVisibilidad.titleLabel!.frame.size.width)
                
            }
            
            
            let sqlEncuestas = "select * from EARespuesta where idReporteLocal = '\(idReporteLocal!)'"
            
            let resultadoEncuestas = db.select_query_columns(sqlEncuestas)
            
            if resultadoEncuestas.count > 0 {
                
                botonEncuesta.setImage(UIImage(named: "TareaCompleta"), for: .normal)
                
                botonEncuesta.imageView?.contentMode = .left
                
                botonEncuesta.titleEdgeInsets = UIEdgeInsetsMake(0, botonDistribucion.imageView!.frame.size.width, 0, 0)
                
                botonEncuesta.imageEdgeInsets = UIEdgeInsetsMake(0, -botonEncuesta.imageView!.frame.size.width, 0, botonEncuesta.imageView!.frame.size.width)
                botonEncuesta.titleEdgeInsets = UIEdgeInsetsMake(18, botonEncuesta.titleLabel!.frame.size.width + 10, 18, -botonEncuesta.titleLabel!.frame.size.width)
                
            }

            
        
        //let sqlDistribucion = "select * FROM md_item INNER JOIN md_distribution ON md_item.idMeasurement = md_distribution.id LEFT JOIN report_distribution ON report_distribution.id_item = md_item.idItemRelation where idItemRelation not in (select id_item from report_distribution where idReporteLocal = '\(idReporteLocal as! NSNumber)') GROUP BY md_item.idItemRelation"
        
        //let resultadoDistribucion = db.select_query_columns(sqlDistribucion)
            
        let auxModuloDistribucion = defaults.object(forKey: "moduloDistribucion") as! NSNumber
        
        if auxModuloDistribucion == 1 {
            
            distribucionEstatus = true
            
            botonDistribucion.setImage(UIImage(named: "TareaCompleta"), for: .normal)
            
            botonDistribucion.imageView?.contentMode = .left
            
            botonDistribucion.titleEdgeInsets = UIEdgeInsetsMake(0, botonDistribucion.imageView!.frame.size.width, 0, 0)
            
            botonDistribucion.imageEdgeInsets = UIEdgeInsetsMake(0, -botonDistribucion.imageView!.frame.size.width, 0, botonDistribucion.imageView!.frame.size.width)
            botonDistribucion.titleEdgeInsets = UIEdgeInsetsMake(18, botonDistribucion.titleLabel!.frame.size.width + 10, 18, -botonDistribucion.titleLabel!.frame.size.width)
            
        }
            
            
        }
        
        botonDistribucion.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonDistribucion.titleLabel!.font = botonDistribucion.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
        
        
        
        botonDistribucion.setAttributedTitle(nil, for: UIControlState())
        botonDistribucion.setTitle("DISTRIBUCIÓN Y PRECIOS", for: UIControlState())
        botonDistribucion.tag = 0
        
        botonDistribucion.isSelected = false
        botonDistribucion.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
        
        
        
        botonDistribucion.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
        botonDistribucion.titleLabel!.numberOfLines = 0
        botonDistribucion.titleLabel!.textAlignment = .left
        
        
        botonDistribucion.sizeToFit()
        
        botonDistribucion.frame = CGRect(x: offsetx, y: offsetScroll, width: laVista.frame.width - offsetx, height: alto_menu)
        
        
        
        botonDistribucion.contentHorizontalAlignment = .left
        botonDistribucion.contentVerticalAlignment = .center
        
        
        
        
        botonDistribucion.addTarget(self, action:#selector(ModulosController.iradistribucion(sender:)), for:.touchDown)
        
        laVista.addSubview(botonDistribucion)
        
        offsetScroll += botonDistribucion.frame.height + 40
        
        
        
        botonPromocion.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonPromocion.titleLabel!.font = botonPromocion.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
        
        
        
        botonPromocion.setAttributedTitle(nil, for: UIControlState())
        botonPromocion.setTitle("PROMOCIÓN", for: UIControlState())
        botonPromocion.tag = 0
        
        botonPromocion.isSelected = false
        botonPromocion.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
        
        
        
        botonPromocion.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
        botonPromocion.titleLabel!.numberOfLines = 0
        botonPromocion.titleLabel!.textAlignment = .left
        
        
        botonPromocion.sizeToFit()
        
        botonPromocion.frame = CGRect(x: offsetx, y: offsetScroll, width: laVista.frame.width - offsetx, height: alto_menu)
        
        
        
        botonPromocion.contentHorizontalAlignment = .left
        botonPromocion.contentVerticalAlignment = .center
        
        
        //botonCDC.setImage(UIImage(named: "SiluetaUsuario"), for: .normal)
        
        //botonCDC.imageView?.contentMode = .scaleAspectFit
        
        //botonUsuario.titleEdgeInsets = UIEdgeInsetsMake(0, botonUsuario.imageView!.frame.size.width, 0, 0)
        
        //botonUsuario.imageEdgeInsets = UIEdgeInsetsMake(0, -botonUsuario.imageView!.frame.size.width, 0, botonUsuario.imageView!.frame.size.width);
        //botonUsuario.titleEdgeInsets = UIEdgeInsetsMake(18, botonUsuario.titleLabel!.frame.size.width + 10, 18, -botonUsuario.titleLabel!.frame.size.width);
        
        botonPromocion.addTarget(self, action:#selector(ModulosController.irapromocion(sender:)), for:.touchDown)
        
        laVista.addSubview(botonPromocion)
        
        offsetScroll += botonPromocion.frame.height + 40
        
        
        
        botonVisibilidad.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonVisibilidad.titleLabel!.font = botonCheckin.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
        
        
        
        botonVisibilidad.setAttributedTitle(nil, for: UIControlState())
        botonVisibilidad.setTitle("VISIBILIDAD", for: UIControlState())
        botonVisibilidad.tag = 0
        
        botonVisibilidad.isSelected = false
        botonVisibilidad.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
        
        
        
        botonVisibilidad.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
        botonVisibilidad.titleLabel!.numberOfLines = 0
        botonVisibilidad.titleLabel!.textAlignment = .left
        
        
        botonVisibilidad.sizeToFit()
        
        botonVisibilidad.frame = CGRect(x: offsetx, y: offsetScroll, width: laVista.frame.width - offsetx, height: alto_menu)
        
        
        
        botonVisibilidad.contentHorizontalAlignment = .left
        botonVisibilidad.contentVerticalAlignment = .center
        
        
        //botonCDC.setImage(UIImage(named: "SiluetaUsuario"), for: .normal)
        
        //botonCDC.imageView?.contentMode = .scaleAspectFit
        
        //botonUsuario.titleEdgeInsets = UIEdgeInsetsMake(0, botonUsuario.imageView!.frame.size.width, 0, 0)
        
        //botonUsuario.imageEdgeInsets = UIEdgeInsetsMake(0, -botonUsuario.imageView!.frame.size.width, 0, botonUsuario.imageView!.frame.size.width);
        //botonUsuario.titleEdgeInsets = UIEdgeInsetsMake(18, botonUsuario.titleLabel!.frame.size.width + 10, 18, -botonUsuario.titleLabel!.frame.size.width);
        
        botonVisibilidad.addTarget(self, action:#selector(ModulosController.iravisibilidad(sender:)), for:.touchDown)
        
        laVista.addSubview(botonVisibilidad)
        
        offsetScroll += botonVisibilidad.frame.height + 40
        
        
        
        botonEncuesta.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonEncuesta.titleLabel!.font = botonEncuesta.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
        
        
        
        botonEncuesta.setAttributedTitle(nil, for: UIControlState())
        botonEncuesta.setTitle("ENCUESTAS", for: UIControlState())
        botonEncuesta.tag = 0
        
        botonEncuesta.isSelected = false
        botonEncuesta.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
        
        
        
        botonEncuesta.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
        botonEncuesta.titleLabel!.numberOfLines = 0
        botonEncuesta.titleLabel!.textAlignment = .left
        
        
        botonEncuesta.sizeToFit()
        
        botonEncuesta.frame = CGRect(x: offsetx, y: offsetScroll, width: laVista.frame.width - offsetx, height: alto_menu)
        
        
        
        botonEncuesta.contentHorizontalAlignment = .left
        botonEncuesta.contentVerticalAlignment = .center
        
        
        //botonCDC.setImage(UIImage(named: "SiluetaUsuario"), for: .normal)
        
        //botonCDC.imageView?.contentMode = .scaleAspectFit
        
        //botonUsuario.titleEdgeInsets = UIEdgeInsetsMake(0, botonUsuario.imageView!.frame.size.width, 0, 0)
        
        //botonUsuario.imageEdgeInsets = UIEdgeInsetsMake(0, -botonUsuario.imageView!.frame.size.width, 0, botonUsuario.imageView!.frame.size.width);
        //botonUsuario.titleEdgeInsets = UIEdgeInsetsMake(18, botonUsuario.titleLabel!.frame.size.width + 10, 18, -botonUsuario.titleLabel!.frame.size.width);
        
        botonEncuesta.addTarget(self, action:#selector(ModulosController.iraencuestas(sender:)), for:.touchDown)
        
        laVista.addSubview(botonEncuesta)
        
        offsetScroll += botonEncuesta.frame.height + 40
        
        
        
        
        botonCheckout.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        botonCheckout.titleLabel!.font = botonCheckout.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
        
        
        
        botonCheckout.setAttributedTitle(nil, for: UIControlState())
        botonCheckout.setTitle("CHECK OUT", for: UIControlState())
        botonCheckout.tag = 0
        
        botonCheckout.isSelected = false
        botonCheckout.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
        
        
        
        botonCheckout.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
        botonCheckout.titleLabel!.numberOfLines = 0
        botonCheckout.titleLabel!.textAlignment = .left
        
        
        botonCheckout.sizeToFit()
        
        botonCheckout.frame = CGRect(x: offsetx, y: offsetScroll, width: laVista.frame.width - offsetx, height: alto_menu)
        
        
        
        botonCheckout.contentHorizontalAlignment = .left
        botonCheckout.contentVerticalAlignment = .center
        
        
        //botonCDC.setImage(UIImage(named: "SiluetaUsuario"), for: .normal)
        
        //botonCDC.imageView?.contentMode = .scaleAspectFit
        
        //botonUsuario.titleEdgeInsets = UIEdgeInsetsMake(0, botonUsuario.imageView!.frame.size.width, 0, 0)
        
        //botonUsuario.imageEdgeInsets = UIEdgeInsetsMake(0, -botonUsuario.imageView!.frame.size.width, 0, botonUsuario.imageView!.frame.size.width);
        //botonUsuario.titleEdgeInsets = UIEdgeInsetsMake(18, botonUsuario.titleLabel!.frame.size.width + 10, 18, -botonUsuario.titleLabel!.frame.size.width);
        
        if distribucionEstatus {
        
        botonCheckout.addTarget(self, action:#selector(ModulosController.mostrar_ska(sender:)), for:.touchDown)
            
        }
        else{
        
            botonCheckout.addTarget(self, action:#selector(ModulosController.mostrar_incidencias(sender:)), for:.touchDown)
        
        }
        
        laVista.addSubview(botonCheckout)
        
        offsetScroll += botonCheckout.frame.height + 40
        
        
         laVista.contentSize = CGSize(width: laVista.contentSize.width, height: offsetScroll)
        
        
        
        if idReporteLocal == nil {
        
            botonCheckin.isUserInteractionEnabled = true
            botonDistribucion.isUserInteractionEnabled = false
            botonPromocion.isUserInteractionEnabled = false
            botonVisibilidad.isUserInteractionEnabled = false
            botonEncuesta.isUserInteractionEnabled = false
            botonCheckout.isUserInteractionEnabled = false
        
        }
        else{
        
            botonCheckin.isUserInteractionEnabled = false
            
            
            
            
        
        }
        
    }
    
    
    @objc func hacer_checkin(sender:UIButton){
        
        //actualizar texto cargador
        
        
        
        let controladorActual = UIApplication.topViewController()
        
        DispatchQueue.main.async {
            
            self.mostrarCargador()
            
            let subvistas = controladorActual?.view!.subviews
            
            for subvista in subvistas! where subvista.tag == 179 {
                
                let subvistasCargador = subvista.subviews
                
                for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                    
                    (subvistaCargador as! UIButton).setTitle("Haciendo Check In...", for: .normal)
                    
                }
                
                let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.ocultarCargador(sender:)))
                singleTap.cancelsTouchesInView = false
                singleTap.numberOfTapsRequired = 1
                subvista.addGestureRecognizer(singleTap)
                
                
            }
            
        }
        
        //fin actualizar texto cargador
        
        
        DispatchQueue.main.async {
        
            //_ = SwiftSpinner.show("Haciendo Check In...")
         
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                // Put your code which should be executed with a delay here
            

            
            let base = self.defaults.object(forKey: "base") as! String
            
            self.db.open_database(base)
            
            
            let timezone = NSTimeZone.local.identifier
            let accuracy=self.locationManager.desiredAccuracy.description
            
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            
            self.defaults.set(timezone, forKey: "timezone")
            
            self.defaults.set(accuracy, forKey: "accuracy")
            
            
            let hoy = NSDate()
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"
            
            _ = dateFormatter.string(from: hoy as Date)
            
            
            
            let ubicacion = obtener_ubicacion()
            
            print(ubicacion)
            
            let tiempo_milisegundos = String(Int64(NSDate().timeIntervalSince1970*1000))
            
            let place = self.defaults.object(forKey: "idCDC") as! Int
            
            let miUbicacion = obtener_ubicacion()
            
            let satelite = obtener_fecha_satelite()
            
            let sql = "insert into report (version,idTipo,place,hash,checkIn,checkInTz,checkInLat,checkInLon,checkInSateliteUTC,idReportServer) values ('\(version!)',-1,'\(place)','','\(tiempo_milisegundos)','\(timezone)','\(miUbicacion.coordinate.latitude)','\(miUbicacion.coordinate.longitude)','\(satelite)','0')"
            
            let resultado_reporte_checkin = self.db.execute_query(sql)
            
            print(sql)
            
            print(resultado_reporte_checkin)
            
            let resultado_reporte = self.db.select_query_columns("select * from report order by id desc limit 1")
            
            print(resultado_reporte)
            
            for renglon in resultado_reporte {
                
                self.defaults.set(renglon["id"], forKey: "idReporteLocal")
                
            }
            
            
            
            //print(defaults.objectForKey("idReporteLocal"))
            
            
            
            
            
            let random = Int(arc4random_uniform(1000))
            
            let el_hash=String(tiempo_milisegundos) + String(describing: self.defaults.object(forKey: "idReporteLocal")!) + String(random)
            
            self.defaults.set(el_hash.md5(), forKey: "hashReporte")
            
            let  hash = self.defaults.object(forKey: "hashReporte")
            
            let idReporteLocal = self.defaults.object(forKey: "idReporteLocal")
            
            _ = self.db.execute_query("update report set hash='\(hash!)' where id = '\(idReporteLocal!)'")
            
            //print("update report set hash='\(hash!)' where id = '\(idReporteLocal!)'")
            
            
            self.defaults.set(1, forKey: "checkin")
            
            let sqlCDC = "select * from pdv_pdv where id = '\(place)'"
            
            let resultadoCDC = self.db.select_query_columns(sqlCDC)
            
            for renglonCDC in resultadoCDC {
                
                self.defaults.set(renglonCDC["idRtm"], forKey: "idRtm")
                self.defaults.set(renglonCDC["idFormat"], forKey: "idFormat")
                self.defaults.set(renglonCDC["idClient"], forKey: "idCliente")
                
                let sqlCanal = "select * from c_rtm where id = '\(renglonCDC["idRtm"]!)'"
                
                let resultado_canal = self.db.select_query_columns(sqlCanal)
                
                for renglonCanal in resultado_canal {
                    
                    self.defaults.set(renglonCanal["id_canal"], forKey: "idCanal")
                    
                }
                
            }
            
            
            var sqlReporteDistribution = "insert into report_distribution (idReportServer,id_pdv,hash,id_measurement_item,bootle_price,value,cup_price,check_in_date,distribution,id_item,idReporteLocal,is_send) select id_report,id_pdv,hash,id_measurement_item,bootle_price,value,cup_price,check_in_date,distribution,id_measurement_item,'\(idReporteLocal!)','0' from prellenado_distribution_ss where id_pdv = '\(place)' and id_report = (select id_report from prellenado_distribution_ss where id_pdv = '\(place)' order by received  desc limit 1) order by received desc"
            
            print(sqlReporteDistribution)
            let resultadoInsertReporteDistribution = self.db.execute_query(sqlReporteDistribution)
            
            print("resultado de replicar reporte distribution")
            print(resultadoInsertReporteDistribution)
            
            
            sqlReporteDistribution = "select * from report_distribution where idReporteLocal = '\(idReporteLocal!)'"
            
            print(sqlReporteDistribution)
            
            let restultadoDistribucion = self.db.select_query_columns(sqlReporteDistribution)
            
            print(restultadoDistribucion)
            
            for renglon in restultadoDistribucion {
                
                
                let random = Int(arc4random_uniform(1000))
                
                let el_hash=String(tiempo_milisegundos) + String(describing: renglon["id"] as! Int) + String(random)
                
                let sqlUpdateDistribucion = "update report_distribution set hash = '\(el_hash.md5())' where id = \(renglon["id"] as! Int)"
                
                print(sqlUpdateDistribucion)
                
                let resultadoUpdateDistribucion = self.db.execute_query(sqlUpdateDistribucion)
                
                print(resultadoUpdateDistribucion)
                
            }
                
                
            let sqlFotosDistribucion = "select t1.filter2,t2.id from md_item t1, report_distribution t2 where t1.idItemRelation = t2.id_item and t2.idReporteLocal = '\(idReporteLocal!)' and t2.distribution = 1 GROUP BY t1.filter2"
                
                print(sqlFotosDistribucion)
                
                let restultadoFotosDistribucion = self.db.select_query_columns(sqlFotosDistribucion)
                
                print(restultadoFotosDistribucion)
                
                for renglon in restultadoFotosDistribucion {
                    
                    
                    
                    let sqlFoto = "insert into report_photo_distribution (idReporteLocal,id_report_distribution,path,hash,is_send,filter2) values ('\(idReporteLocal!)','\(renglon["id"]!)','prellenada','prellenada','1','\(renglon["filter2"]!)')"
                    
                    print(sqlFoto)
                    
                    let resultado_foto = self.db.execute_query(sqlFoto)
                    
                    print(resultado_foto)
                    
                    
                    
                }
                
                
                
                //actualizar texto cargador
                
                let controladorActual = UIApplication.topViewController()
                
                DispatchQueue.main.async {
                    
                    self.mostrarCargador()
                    
                    let subvistas = controladorActual?.view!.subviews
                    
                    for subvista in subvistas! where subvista.tag == 179 {
                        
                        let subvistasCargador = subvista.subviews
                        
                        for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                            
                            (subvistaCargador as! UIButton).setTitle("CHECKIN LISTO, Toque para cerrar", for: .normal)
                            
                        }
                        
                        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.checkListo(sender:)))
                        singleTap.cancelsTouchesInView = false
                        singleTap.numberOfTapsRequired = 1
                        subvista.addGestureRecognizer(singleTap)
                        
                        
                    }
                    
                }
                
                //fin actualizar texto cargador
                
                
                
                
            /*
            DispatchQueue.main.async {
                
                _ = SwiftSpinner.show("CHECKIN LISTO, Toque para cerrar").addTapHandler({SwiftSpinner.hide()
                    
                    
                    self.botonCheckin.isUserInteractionEnabled = false
                    self.botonDistribucion.isUserInteractionEnabled = true
                    self.botonPromocion.isUserInteractionEnabled = true
                    self.botonVisibilidad.isUserInteractionEnabled = true
                    self.botonEncuesta.isUserInteractionEnabled = true
                    self.botonCheckout.isUserInteractionEnabled = true
                    
                    self.botonCheckin.setImage(UIImage(named: "TareaCompleta"), for: .normal)
                    
                    self.botonCheckin.imageView?.contentMode = .left
                    
                    self.botonCheckin.titleEdgeInsets = UIEdgeInsetsMake(0, self.botonDistribucion.imageView!.frame.size.width, 0, 0)
                    
                    self.botonCheckin.imageEdgeInsets = UIEdgeInsetsMake(0, -self.botonCheckin.imageView!.frame.size.width, 0, self.botonCheckin.imageView!.frame.size.width)
                    //self.botonCheckin.titleEdgeInsets = UIEdgeInsetsMake(18, self.botonCheckin.titleLabel!.frame.size.width + 10, 18, -self.botonCheckin.titleLabel!.frame.size.width)
                    
                    self.defaults.set(0, forKey: "moduloDistribucion")
                    
                })
                
            }
            */
            
            
            
        })
        
            
        }
        
        
        
        
        
        
    }
    
    
    
    //incidencias
    
    
    @objc func ocultarCargador(sender:UITapGestureRecognizer){
        
        DispatchQueue.main.async {
            
            sender.view!.removeFromSuperview()
            
        }
        
    }
    
    @objc func checkOutListo(sender:UITapGestureRecognizer)
    {
    
    self.performSegue(withIdentifier: "modulostoinicio", sender: self)
        
    sender.view!.removeFromSuperview()
        
    }
    
    @objc func checkListo(sender:UITapGestureRecognizer){
        
        
        self.botonCheckin.isUserInteractionEnabled = false
        self.botonDistribucion.isUserInteractionEnabled = true
        self.botonPromocion.isUserInteractionEnabled = true
        self.botonVisibilidad.isUserInteractionEnabled = true
        self.botonEncuesta.isUserInteractionEnabled = true
        self.botonCheckout.isUserInteractionEnabled = true
        
        self.botonCheckin.setImage(UIImage(named: "TareaCompleta"), for: .normal)
        
        self.botonCheckin.imageView?.contentMode = .left
        
        self.botonCheckin.titleEdgeInsets = UIEdgeInsetsMake(0, self.botonDistribucion.imageView!.frame.size.width, 0, 0)
        
        self.botonCheckin.imageEdgeInsets = UIEdgeInsetsMake(0, -self.botonCheckin.imageView!.frame.size.width, 0, self.botonCheckin.imageView!.frame.size.width)
        //self.botonCheckin.titleEdgeInsets = UIEdgeInsetsMake(18, self.botonCheckin.titleLabel!.frame.size.width + 10, 18, -self.botonCheckin.titleLabel!.frame.size.width)
        
        self.defaults.set(0, forKey: "moduloDistribucion")
        
        sender.view!.removeFromSuperview()
        
        
    }
    
    @objc func mostrar_incidencias(sender:UIButton){
        
        
        skaPdv.removeAll()
        
        let alto_menu:CGFloat = laVista.frame.height/12
        
        skaVista.backgroundColor = UIColor(rgba: "#c70752")
        
        skaVista.frame = CGRect(x: 0, y: barraTitulo.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        
        let barraSubTitulo:UIScrollView = UIScrollView()
        
        //let textoSubTitulo:UIButton = UIButton()
        
        barraSubTitulo.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: barraTitulo.frame.height)
        
        let fondoBarraSubTitulo = UIImage(named: "LineaGris")
        
        let vistaFondoBarraSubtitulo:UIImageView = UIImageView()
        
        vistaFondoBarraSubtitulo.image = fondoBarraSubTitulo
        
        vistaFondoBarraSubtitulo.frame = CGRect(x: 0, y: 0, width: barraSubTitulo.frame.width, height: barraSubTitulo.frame.height)
        
        vistaFondoBarraSubtitulo.contentMode = .scaleToFill
        
        
        
        textoSubTitulo.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        textoSubTitulo.titleLabel!.font = textoSubTitulo.titleLabel!.font.withSize(CGFloat(14))
        
        
        
        textoSubTitulo.setAttributedTitle(nil, for: UIControlState())
        textoSubTitulo.setTitle("CHECK OUT", for: UIControlState())
        textoSubTitulo.tag = 0
        
        //textoSubTitulo.isSelected = false
        textoSubTitulo.setTitleColor(UIColor(rgba: "#c70752"), for: UIControlState())
        
        
        
        textoSubTitulo.titleLabel!.textColor = UIColor(rgba: "#c70752")
        textoSubTitulo.titleLabel!.numberOfLines = 0
        textoSubTitulo.titleLabel!.textAlignment = .right
        
        
        textoSubTitulo.sizeToFit()
        
        textoSubTitulo.frame = CGRect(x: 0, y: 0, width: barraSubTitulo.frame.width - barraSubTitulo.frame.width/20, height: barraSubTitulo.frame.height)
        
        
        
        textoSubTitulo.contentHorizontalAlignment = .right
        textoSubTitulo.contentVerticalAlignment = .center
        
        textoSubTitulo.addTarget(self, action:#selector(ModulosController.hacer_checkout(sender:)), for:.touchDown)
        
        textoSubTitulo.isUserInteractionEnabled = true
        
        textoSubTitulo.isHidden = true
        
        let textoSubTituloIzquierda:UIButton = UIButton()
        
        textoSubTituloIzquierda.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        textoSubTituloIzquierda.titleLabel!.font = textoSubTituloIzquierda.titleLabel!.font.withSize(CGFloat(14))
        
        
        
        textoSubTituloIzquierda.setAttributedTitle(nil, for: UIControlState())
        textoSubTituloIzquierda.setTitle("", for: UIControlState())
        textoSubTituloIzquierda.tag = 0
        
        textoSubTituloIzquierda.isSelected = false
        textoSubTituloIzquierda.setTitleColor(UIColor(rgba: "#c70752"), for: UIControlState())
        
        
        
        textoSubTituloIzquierda.titleLabel!.textColor = UIColor(rgba: "#c70752")
        textoSubTituloIzquierda.titleLabel!.numberOfLines = 0
        textoSubTituloIzquierda.titleLabel!.textAlignment = .left
        
        
        textoSubTituloIzquierda.sizeToFit()
        
        textoSubTituloIzquierda.frame = CGRect(x: 5, y: 0, width: barraSubTitulo.frame.width - barraSubTitulo.frame.width/20, height: barraSubTitulo.frame.height)
        
        
        
        textoSubTituloIzquierda.contentHorizontalAlignment = .left
        textoSubTituloIzquierda.contentVerticalAlignment = .center
        
        
        
        barraSubTitulo.addSubview(vistaFondoBarraSubtitulo)
        
        barraSubTitulo.addSubview(textoSubTitulo)
        //barraSubTitulo.addSubview(textoSubTituloIzquierda)
        
        self.view.addSubview(skaVista)
        
        skaVista.addSubview(barraSubTitulo)
        
        
        let textoDescriptivo:UIButton = UIButton()
        
        textoDescriptivo.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        textoDescriptivo.titleLabel!.font = textoDescriptivo.titleLabel!.font.withSize(CGFloat(16))
        
        
        
        textoDescriptivo.setAttributedTitle(nil, for: UIControlState())
        textoDescriptivo.setTitle("¿Razón por la cual no se completó el reporte?", for: UIControlState())
        textoDescriptivo.tag = 0
        
        textoDescriptivo.isSelected = false
        textoDescriptivo.setTitleColor(UIColor(rgba: "#ffffff"), for: UIControlState())
        
        
        
        textoDescriptivo.titleLabel!.textColor = UIColor(rgba: "#ffffff")
        textoDescriptivo.titleLabel!.numberOfLines = 0
        textoDescriptivo.titleLabel!.textAlignment = .left
        
        
        textoDescriptivo.sizeToFit()
        
        textoDescriptivo.frame = CGRect(x: 5, y: barraSubTitulo.frame.height + barraSubTitulo.frame.origin.y, width: barraSubTitulo.frame.width, height: barraSubTitulo.frame.height)
        
        
        
        textoDescriptivo.contentHorizontalAlignment = .center
        textoDescriptivo.contentVerticalAlignment = .center
        
        skaVista.addSubview(textoDescriptivo)
        
        
        
        let skaVistaScroll:UIScrollView = UIScrollView()
        
        skaVistaScroll.backgroundColor = UIColor(rgba: "#c70752")
        
        skaVistaScroll.frame = CGRect(x: 0, y: textoDescriptivo.frame.height + textoDescriptivo.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height - textoDescriptivo.frame.height - textoDescriptivo.frame.origin.y)
        
        skaVista.addSubview(skaVistaScroll)
        
        
        
        let offsetx = laVista.frame.width/6
        
        var offsetScrollSKA = skaVista.frame.height/8
        
        var incidencias:[[String:AnyObject]] = [[:]]
        
        
        
        incidencias.removeAll()
        
        incidencias.append(["name":"CDC Cerrado" as AnyObject,"tipo":6 as AnyObject])
        incidencias.append(["name":"Visita a cliente pospuesta" as AnyObject,"tipo":7 as AnyObject])
        incidencias.append(["name":"Visita sólo a oficinas del cliente" as AnyObject,"tipo":8 as AnyObject])
        incidencias.append(["name":"Cambio imprevisto de agenda" as AnyObject,"tipo":9 as AnyObject])
        incidencias.append(["name":"Otro" as AnyObject,"tipo":10 as AnyObject])
        
        for renglon in incidencias {
            
            
            
            let botonCheck:UIButton = UIButton()
            
            botonCheck.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
            
            botonCheck.titleLabel!.font = botonCheck.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
            
            
            
            botonCheck.setAttributedTitle(nil, for: UIControlState())
            botonCheck.setTitle(renglon["name"] as? String, for: UIControlState())
            botonCheck.tag = renglon["tipo"] as! Int
            
            
            
            botonCheck.isSelected = false
            botonCheck.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
            
            
            
            botonCheck.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
            botonCheck.titleLabel!.numberOfLines = 0
            botonCheck.titleLabel!.textAlignment = .left
            
            
            botonCheck.sizeToFit()
            
            botonCheck.frame = CGRect(x: offsetx, y: offsetScrollSKA, width: laVista.frame.width - offsetx, height: alto_menu)
            
            botonCheck.contentHorizontalAlignment = .left
            botonCheck.contentVerticalAlignment = .center
            
            
            botonCheck.setImage(UIImage(named: "RadioButton"), for: .normal)
            
            botonCheck.imageView?.contentMode = .scaleAspectFit
            
            botonCheck.titleEdgeInsets = UIEdgeInsetsMake(0, botonCheck.imageView!.frame.size.width, 0, 0)
            
            
            
            botonCheck.addTarget(self, action:#selector(ModulosController.seleccionar_incidencia(sender:)), for:.touchDown)
            
            incidenciasBotones.append(botonCheck)
            
            skaVistaScroll.addSubview(botonCheck)
            
            offsetScrollSKA += botonCheck.frame.height + 40
            
            if botonCheck.tag == 10 {
            
                offsetScrollSKA -= 20
            
                
                
                campoOtro.frame = CGRect(x: offsetx, y: offsetScrollSKA, width: laVista.frame.width - offsetx - 10, height: alto_menu)
                
                campoOtro.borderStyle = .roundedRect
                
                campoOtro.returnKeyType = .done
                
                campoOtro.delegate = self
                
                campoOtro.addTarget(self, action: #selector(ModulosController.selecciono_otro(sender:)), for: UIControlEvents.editingDidBegin)
                
                skaVistaScroll.addSubview(campoOtro)
                
                offsetScrollSKA += campoOtro.frame.height + 100
                
            
            }
            
        }
        
        offsetScrollSKA += 600
        
        skaVistaScroll.contentSize = CGSize(width: skaVistaScroll.contentSize.width, height: offsetScrollSKA)
        
        skaVista.bringSubview(toFront: textoSubTitulo)
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [],animations: {
            
            self.skaVista.frame.origin.y = self.barraTitulo.frame.origin.y + self.barraTitulo.frame.height
            //self.laVista.isUserInteractionEnabled = false
            self.botoMenu.isUserInteractionEnabled = false
            // self.username.center.x += self.view.bounds.width
            }, completion: nil)
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
            textField.resignFirstResponder()
        
        //(textField.superview! as! UIScrollView).setContentOffset(CGPoint(x:0, y:textField.center.y + 30), animated: true)
        
        return true
    }
    
    @objc func selecciono_otro(sender:UITextField){
        
        textoSubTitulo.isHidden = false
        
        (sender.superview! as! UIScrollView).setContentOffset(CGPoint(x:0, y:sender.center.y-30), animated: true)
    
        for auxBoton in incidenciasBotones {
            
            auxBoton.setImage(UIImage(named: "RadioButton"), for: .normal)
            
            if auxBoton.titleLabel?.text! == "Otro" {
            
                auxBoton.setImage(UIImage(named: "RadioButtonSeleccionado"), for: .normal)
            
            }
            
        }
        
        tipoReporte = 10
    
    }
    
    
    @objc func seleccionar_incidencia(sender:UIButton){
        
        textoSubTitulo.isHidden = false
        
        for textField in (sender.superview?.subviews)! where textField is UITextField {
            textField.resignFirstResponder()
        }
        
    
        for auxBoton in incidenciasBotones where auxBoton != sender {
        
            auxBoton.setImage(UIImage(named: "RadioButton"), for: .normal)
            
        }
        
        sender.setImage(UIImage(named: "RadioButtonSeleccionado"), for: .normal)
        
        tipoReporte = sender.tag
    
    }
    
    //fin incidencias
    
    
    
    
    
    @objc func mostrar_ska(sender:UIButton){
    
        
        
        
        let alto_menu:CGFloat = laVista.frame.height/12
        
        skaVista.backgroundColor = UIColor(rgba: "#c70752")
        
        skaVista.frame = CGRect(x: 0, y: barraTitulo.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        
        let barraSubTitulo:UIScrollView = UIScrollView()
        
        let textoSubTitulo:UIButton = UIButton()
        
        barraSubTitulo.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: barraTitulo.frame.height)
        
        let fondoBarraSubTitulo = UIImage(named: "LineaGris")
        
        let vistaFondoBarraSubtitulo:UIImageView = UIImageView()
        
        vistaFondoBarraSubtitulo.image = fondoBarraSubTitulo
        
        vistaFondoBarraSubtitulo.frame = CGRect(x: 0, y: 0, width: barraSubTitulo.frame.width, height: barraSubTitulo.frame.height)
        
        vistaFondoBarraSubtitulo.contentMode = .scaleToFill
        
        
        
        textoSubTitulo.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        textoSubTitulo.titleLabel!.font = textoSubTitulo.titleLabel!.font.withSize(CGFloat(14))
        
        
        
        textoSubTitulo.setAttributedTitle(nil, for: UIControlState())
        textoSubTitulo.setTitle("CHECK OUT", for: UIControlState())
        textoSubTitulo.tag = 0
        
        //textoSubTitulo.isSelected = false
        textoSubTitulo.setTitleColor(UIColor(rgba: "#c70752"), for: UIControlState())
        
        
        
        textoSubTitulo.titleLabel!.textColor = UIColor(rgba: "#c70752")
        textoSubTitulo.titleLabel!.numberOfLines = 0
        textoSubTitulo.titleLabel!.textAlignment = .right
        
        
        textoSubTitulo.sizeToFit()
        
        textoSubTitulo.frame = CGRect(x: 0, y: 0, width: barraSubTitulo.frame.width - barraSubTitulo.frame.width/20, height: barraSubTitulo.frame.height)
        
        
        
        textoSubTitulo.contentHorizontalAlignment = .right
        textoSubTitulo.contentVerticalAlignment = .center
        
        textoSubTitulo.addTarget(self, action:#selector(ModulosController.hacer_checkout(sender:)), for:.touchDown)
        
        textoSubTitulo.isUserInteractionEnabled = true
        
        let textoSubTituloIzquierda:UIButton = UIButton()
        
        textoSubTituloIzquierda.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        textoSubTituloIzquierda.titleLabel!.font = textoSubTituloIzquierda.titleLabel!.font.withSize(CGFloat(14))
        
        
        
        textoSubTituloIzquierda.setAttributedTitle(nil, for: UIControlState())
        textoSubTituloIzquierda.setTitle("", for: UIControlState())
        textoSubTituloIzquierda.tag = 0
        
        textoSubTituloIzquierda.isSelected = false
        textoSubTituloIzquierda.setTitleColor(UIColor(rgba: "#c70752"), for: UIControlState())
        
        
        
        textoSubTituloIzquierda.titleLabel!.textColor = UIColor(rgba: "#c70752")
        textoSubTituloIzquierda.titleLabel!.numberOfLines = 0
        textoSubTituloIzquierda.titleLabel!.textAlignment = .left
        
        
        textoSubTituloIzquierda.sizeToFit()
        
        textoSubTituloIzquierda.frame = CGRect(x: 5, y: 0, width: barraSubTitulo.frame.width - barraSubTitulo.frame.width/20, height: barraSubTitulo.frame.height)
        
        
        
        textoSubTituloIzquierda.contentHorizontalAlignment = .left
        textoSubTituloIzquierda.contentVerticalAlignment = .center
        
        
        
        barraSubTitulo.addSubview(vistaFondoBarraSubtitulo)
        
        barraSubTitulo.addSubview(textoSubTitulo)
        //barraSubTitulo.addSubview(textoSubTituloIzquierda)
        
        self.view.addSubview(skaVista)
        
        skaVista.addSubview(barraSubTitulo)
        
        
        let textoDescriptivo:UIButton = UIButton()
        
        textoDescriptivo.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        textoDescriptivo.titleLabel!.font = textoDescriptivo.titleLabel!.font.withSize(CGFloat(20))
        
        
        
        textoDescriptivo.setAttributedTitle(nil, for: UIControlState())
        textoDescriptivo.setTitle("Si desea replicas de este reporte para otros SKAs favor de seleccionarlos de la siguiente lista", for: UIControlState())
        textoDescriptivo.tag = 0
        
        textoDescriptivo.isSelected = false
        textoDescriptivo.setTitleColor(UIColor(rgba: "#ffffff"), for: UIControlState())
        
        
        
        textoDescriptivo.titleLabel!.textColor = UIColor(rgba: "#ffffff")
        textoDescriptivo.titleLabel!.numberOfLines = 0
        textoDescriptivo.titleLabel!.textAlignment = .left
        
        
        textoDescriptivo.sizeToFit()
        
        textoDescriptivo.frame = CGRect(x: 5, y: barraSubTitulo.frame.height + barraSubTitulo.frame.origin.y, width: barraSubTitulo.frame.width, height: barraSubTitulo.frame.height*2)
        
        
        
        textoDescriptivo.contentHorizontalAlignment = .center
        textoDescriptivo.contentVerticalAlignment = .center
        
        skaVista.addSubview(textoDescriptivo)
        
        
        
        let skaVistaScroll:UIScrollView = UIScrollView()
        
        skaVistaScroll.backgroundColor = UIColor(rgba: "#c70752")
        
        skaVistaScroll.frame = CGRect(x: 0, y: textoDescriptivo.frame.height + textoDescriptivo.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
        
        skaVista.addSubview(skaVistaScroll)
        
        
        let base = defaults.object(forKey: "base") as! String
        
        db.open_database(base)
        
        let place = defaults.object(forKey: "idCDC") as! Int
        
        let sqlSKA = "select * from pdv_pdv where ska = 1 and id <> '\(place)' order by name asc"
        
        let resultadoSKA = db.select_query_columns(sqlSKA)
        
        let offsetx = laVista.frame.width/6
        
        var offsetScrollSKA = skaVista.frame.height/8
        
        skaPdv.removeAll()
        
        for renglon in resultadoSKA {
        
            skaPdv.append([String:AnyObject]())
            
            let botonCheck:UIButton = UIButton()
            
            botonCheck.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
            
            botonCheck.titleLabel!.font = botonCheck.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
            
            
            
            botonCheck.setAttributedTitle(nil, for: UIControlState())
            botonCheck.setTitle(renglon["name"] as? String, for: UIControlState())
            botonCheck.tag = skaPdv.count - 1
            
            skaPdv[skaPdv.count - 1]["id"] = renglon["id"]!
            
            botonCheck.isSelected = false
            botonCheck.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
            
            
            
            botonCheck.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
            botonCheck.titleLabel!.numberOfLines = 0
            botonCheck.titleLabel!.textAlignment = .left
            
            
            botonCheck.sizeToFit()
            
            botonCheck.frame = CGRect(x: offsetx, y: offsetScrollSKA, width: laVista.frame.width - offsetx, height: alto_menu)
            
            botonCheck.contentHorizontalAlignment = .left
            botonCheck.contentVerticalAlignment = .center
            
            
            botonCheck.setImage(UIImage(named: "checkButton"), for: .normal)
            
            botonCheck.imageView?.contentMode = .scaleAspectFit
            
            botonCheck.titleEdgeInsets = UIEdgeInsetsMake(0, botonCheck.imageView!.frame.size.width, 0, 0)
            
            
            
            botonCheck.addTarget(self, action:#selector(EncuestaController.check_opcion(sender:)), for:.touchDown)
            
            skaPdv[skaPdv.count - 1]["boton"] = botonCheck
            skaPdv[skaPdv.count - 1]["seleccionado"] = false as AnyObject?
            
            skaVistaScroll.addSubview(botonCheck)
            
            offsetScrollSKA += botonCheck.frame.height + 40
            
        }
        
        skaVistaScroll.contentSize = CGSize(width: skaVistaScroll.contentSize.width, height: offsetScrollSKA + 400)
        
        skaVista.bringSubview(toFront: textoSubTitulo)
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [],animations: {
            
            self.skaVista.frame.origin.y = self.barraTitulo.frame.origin.y + self.barraTitulo.frame.height
            //self.laVista.isUserInteractionEnabled = false
            self.botoMenu.isUserInteractionEnabled = false
            // self.username.center.x += self.view.bounds.width
            }, completion: nil)
        
        
    
    }
    
    
    @objc func check_opcion(sender:UIButton){
        
        let auxBoton = skaPdv[sender.tag]["boton"] as! UIButton
        
           if auxBoton == sender {
                
                let auxSeleccionado = skaPdv[sender.tag]["seleccionado"] as! Bool
                
            
                
                if auxSeleccionado {
                    
                    skaPdv[sender.tag]["seleccionado"] = false as AnyObject?
                    sender.setImage(UIImage(named: "checkButton"), for: .normal)
                    
                    
                    
                }
                else{
                    
                    skaPdv[sender.tag]["seleccionado"] = true as AnyObject?
                    sender.setImage(UIImage(named: "checkButtonSeleccionado"), for: .normal)
                    
                    
                    
                }
                
            
                
            }
            
    
        
    }
    
    
    @objc func hacer_checkout(sender:UIButton){
        
        
        
        DispatchQueue.main.async {
            
            //actualizar texto cargador
            
            let controladorActual = UIApplication.topViewController()
            
            DispatchQueue.main.async {
                
                self.mostrarCargador()
                
                let subvistas = controladorActual?.view!.subviews
                
                for subvista in subvistas! where subvista.tag == 179 {
                    
                    let subvistasCargador = subvista.subviews
                    
                    for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                        
                        (subvistaCargador as! UIButton).setTitle("Haciendo check out", for: .normal)
                        
                    }
                    
                    let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.checkListo(sender:)))
                    singleTap.cancelsTouchesInView = false
                    singleTap.numberOfTapsRequired = 1
                    subvista.addGestureRecognizer(singleTap)
                    
                    
                }
                
            }
            
            //fin actualizar texto cargador
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {

        
        
        print("si hara checkout")
        
        let base = self.defaults.object(forKey: "base") as! String
        
        self.db.open_database(base)
        
        
        let timezone = NSTimeZone.local.identifier
        
        let ubicacion = obtener_ubicacion()
        
        print(ubicacion)
        
        let tiempo_milisegundos = String(Int64(NSDate().timeIntervalSince1970*1000))
        
        
        
        let miUbicacion = obtener_ubicacion()
        
        let satelite = obtener_fecha_satelite()
        
        
        
        
        let idReporteLocal = self.defaults.object(forKey: "idReporteLocal") as! NSNumber
        
        let sqlCheckOut = "update report set checkOut = '\(tiempo_milisegundos)',checkOutTz = '\(timezone)',checkOutLat = '\(miUbicacion.coordinate.latitude)', checkOutLon = '\(miUbicacion.coordinate.longitude)',checkOutSateliteUTC = '\(satelite)',idTipo = '\(self.tipoReporte)' where id = '\(idReporteLocal)'"
        
        print(sqlCheckOut)
        
        let resultadoCheckOut = self.db.execute_query(sqlCheckOut)
        
        print(resultadoCheckOut)
       
            var totalReplicas = 0
                
        for (indice,renglon) in self.skaPdv.enumerated() where renglon["seleccionado"] as! Bool == true {
            
            totalReplicas = indice
            
                }
               
        totalReplicas += 1
        
        for (indice,renglon) in self.skaPdv.enumerated() where renglon["seleccionado"] as! Bool == true {
            
            //print(renglon)
            
            DispatchQueue.main.async {
                
            
                
                //actualizar texto cargador
                
                let controladorActual = UIApplication.topViewController()
                
                DispatchQueue.main.async {
                    
                    self.mostrarCargador()
                    
                    let subvistas = controladorActual?.view!.subviews
                    
                    for subvista in subvistas! where subvista.tag == 179 {
                        
                        let subvistasCargador = subvista.subviews
                        
                        for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                            
                            (subvistaCargador as! UIButton).setTitle("Replicado Reporte \(indice) de \(totalReplicas)", for: .normal)
                            
                        }
                        
                        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.checkListo(sender:)))
                        singleTap.cancelsTouchesInView = false
                        singleTap.numberOfTapsRequired = 1
                        subvista.addGestureRecognizer(singleTap)
                        
                        
                    }
                    
                }
                
                //fin actualizar texto cargador
                
                
            
            
            //_ = SwiftSpinner.show("Replicado Reporte \(indice) de \(totalReplicas)")
                
            
            
            //DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            
            
        
            if renglon["seleccionado"] as! Bool {
                
                let random = Int(arc4random_uniform(1000))
                
                let el_hash=String(tiempo_milisegundos) + String(describing: renglon["id"] as! NSNumber) + String(random)
                
                let sqlSKA = "insert into rskarep (idReporteLocal,idPdv,hash) values ('\(idReporteLocal)','\(renglon["id"] as! NSNumber)','\(el_hash.md5())')"
                
                print(sqlSKA)
                
                let resultadoInsertSKA = self.db.execute_query(sqlSKA)
                
                print("resultado de replicar SKA")
                print(resultadoInsertSKA)
                
                /*
            
                let sqlReporte = "insert into report (idSchedule,version,idTipo,place,hash,checkIn,checkInTz,checkInLat,checkInLon,checkInImei,checkInAccuracy,checkInSateliteUTC,checkOut,checkOutTz,checkOutLat,checkOutLon,checkOutImei,checkOutAccuracy,checkOutSateliteUTC,idReportServer,enviado) select idSchedule,version,'11','\(renglon["id"] as! NSNumber)',hash,checkIn,checkInTz,checkInLat,checkInLon,checkInImei,checkInAccuracy,checkInSateliteUTC,checkOut,checkOutTz,checkOutLat,checkOutLon,checkOutImei,checkOutAccuracy,checkOutSateliteUTC,idReportServer,enviado from report where id = '\(idReporteLocal)'"
                
                print(sqlReporte)
                
                let resultadoInsertReporte = self.db.execute_query(sqlReporte)
                
                print("resultado de replicar reporte")
                print(resultadoInsertReporte)
                
                
                let resultado_reporte = self.db.select_query_columns("select * from report order by id desc limit 1")
                
                print(resultado_reporte)
                
                var idReporteLocal2 = 0
                
                for renglon in resultado_reporte {
                    
                    idReporteLocal2 = renglon["id"] as! Int
                    
                    
                    
                }
                
                
                random = Int(arc4random_uniform(1000))
                
                el_hash=String(tiempo_milisegundos) + String(describing: idReporteLocal2) + String(random)
                
                let sqlHashReporte2 = "update report set hash = '\(el_hash.md5())' where id = '\(idReporteLocal2)'"
                
                _ = self.db.execute_query(sqlHashReporte2)
                
                 */
                
                /*
                
                //reporte distribution
                
                
                var sqlReporteDistribution = "insert into report_distribution (idReportServer,id_pdv,hash,id_measurement_item,bootle_price,value,cup_price,check_in_date,distribution,id_item,idReporteLocal,is_send) select idReportServer,'\(renglon["id"] as! NSNumber)',hash,id_measurement_item,bootle_price,value,cup_price,check_in_date,distribution,id_item,'\(idReporteLocal2)',is_send from report_distribution where idReporteLocal = '\(idReporteLocal)'"
                
                print(sqlReporteDistribution)
                let resultadoInsertReporteDistribution = self.db.execute_query(sqlReporteDistribution)
                
                print("resultado de replicar reporte distribution")
                print(resultadoInsertReporteDistribution)
                
                
                sqlReporteDistribution = "select * from report_distribution where idReporteLocal = '\(idReporteLocal2)'"
                
                print(sqlReporteDistribution)
                
                let restultadoDistribucion = self.db.select_query_columns(sqlReporteDistribution)
                
                print(restultadoDistribucion)
                
                for renglon in restultadoDistribucion {
                
                    
                    let random = Int(arc4random_uniform(1000))
                    
                    let el_hash=String(tiempo_milisegundos) + String(describing: renglon["id"] as! Int) + String(random)
                    
                    let sqlUpdateDistribucion = "update report_distribution set hash = '\(el_hash.md5())' where id = \(renglon["id"] as! Int)"
                    
                    print(sqlUpdateDistribucion)
                    
                    let resultadoUpdateDistribucion = self.db.execute_query(sqlUpdateDistribucion)
                    
                    print(resultadoUpdateDistribucion)
                
                }
                
                
                //reporte distribution
                
                */
                
                /*
                
                //reporte promocion
                
                let sqlPromociones = "select * from report_promotions where id_report_local = '\(idReporteLocal)'"
                
                let resultadoPromociones = self.db.select_query_columns(sqlPromociones)
                
                
                for renglonPromociones in resultadoPromociones {
                
                
                
                var sqlReportePromocion = "insert into report_promotions (idReportServer,id_category,id_brand,id_type_promotion,hash,is_send,id_report_local) select idReportServer,id_category,id_brand,id_type_promotion,hash,is_send,'\(idReporteLocal2)' from report_promotions where id_report_local = '\(idReporteLocal)' and id = '\(renglonPromociones["id"]!)'"
                
                print(sqlReportePromocion)
                let resultadoInsertReportePromocion = self.db.execute_query(sqlReportePromocion)
                
                print("resultado de replicar reporte promocion")
                print(resultadoInsertReportePromocion)
                
                
                sqlReportePromocion = "select * from report_promotions where id_report_local = '\(idReporteLocal2)' order by id desc limit 1"
                
                print(sqlReportePromocion)
                
                let restultadoPromocion = self.db.select_query_columns(sqlReportePromocion)
                
                print(restultadoPromocion)
                
                for renglon in restultadoPromocion {
                    
                    
                    let random = Int(arc4random_uniform(1000))
                    
                    let el_hash=String(tiempo_milisegundos) + String(describing: renglon["id"] as! Int) + String(random)
                    
                    let sqlUpdate = "update report_promotions set hash = '\(el_hash.md5())' where id = \(renglon["id"] as! Int)"
                    
                    print(sqlUpdate)
                    
                    let resultadoUpdate = self.db.execute_query(sqlUpdate)
                    
                    print(resultadoUpdate)
                    
                    
                    
                    //fotos y marcas
                    /*
                    var sqlFotos = "insert into report_photo_promotions (id_report_local,id_report_promotion,path,hash,is_send,idReportServer) select '\(idReporteLocal2)','\(renglon["id"]!)',path,hash,is_send,idReportServer from report_photo_promotions where id_report_promotion in (select id from report_promotions where id_report_local = '\(idReporteLocal)' and id = '\(renglonPromociones["id"]!)')"
                    
                    let resultadoPromocionFotos = self.db.execute_query(sqlFotos)
                    
                    print("resultado promocion fotos")
                    print(resultadoPromocionFotos)
                    
                    
                    sqlFotos = "select * from report_photo_promotions where id_report_promotion = '\(renglon["id"]!)'"
                    
                    let resultadoFotos = self.db.select_query_columns(sqlFotos)
                    
                    for foto in resultadoFotos {
                    
                        let random = Int(arc4random_uniform(1000))
                        
                        let el_hash=String(tiempo_milisegundos) + String(describing: renglon["id"] as! Int) + String(random)
                        
                        let sqlUpdate = "update report_photo_promotions set hash = '\(el_hash.md5())' where id = \(foto["id"] as! Int)"
                        
                        print(sqlUpdate)
                        
                        let resultadoUpdate = self.db.execute_query(sqlUpdate)
                        
                        print(resultadoUpdate)
                        
                    
                    }
                    
                    */
                    
                    
                    var sqlMarcas = "insert into report_promtions_brands (id_brand,id_category,id_report_promotion,hash,is_send,id_report_local,idReportServer) select id_brand,id_category,'\(renglon["id"]!)',hash,is_send,'\(idReporteLocal2)',idReportServer from report_promtions_brands where id_report_promotion in (select id from report_promotions where id_report_local = '\(idReporteLocal)' and id = \(renglonPromociones["id"]!))"
                    
                    let resultadoPromocionMarcas = self.db.execute_query(sqlMarcas)
                    
                    print("resultado promocion fotos")
                    print(resultadoPromocionMarcas)
                    
                    
                    sqlMarcas = "select * from report_promtions_brands where id_report_promotion = '\(renglon["id"]!)'"
                    
                    let resultadoMarcas = self.db.select_query_columns(sqlMarcas)
                    
                    for marca in resultadoMarcas {
                        
                        let random = Int(arc4random_uniform(1000))
                        
                        let el_hash=String(tiempo_milisegundos) + String(describing: renglon["id"] as! Int) + String(random)
                        
                        let sqlUpdate = "update report_promtions_brands set hash = '\(el_hash.md5())' where id = \(marca["id"] as! Int)"
                        
                        print(sqlUpdate)
                        
                        let resultadoUpdate = self.db.execute_query(sqlUpdate)
                        
                        print(resultadoUpdate)
                        
                        
                    }
                    
                    
                    
                    //fotos y marcas
                    
                    
                    
                }
                
                
                
                }
                
                
                //fin reporte promocion
                
                
                */
                
                /*
                
                //reporte visibilidad
                
                let sqlVisibilidad = "select * from report_visibility where id_report_local = '\(idReporteLocal)'"
                
                let resultadoVisibilidades = self.db.select_query_columns(sqlVisibilidad)
                
                
                for renglonVisibilidades in resultadoVisibilidades {
                    
                    
                    
                    var sqlReporteVisibilidad = "insert into report_visibility (idReportServer,id_category,id_brand,id_type,hash,is_send,id_report_local) select idReportServer,id_category,id_brand,id_type,hash,is_send,'\(idReporteLocal2)' from report_visibility where id_report_local = '\(idReporteLocal)' and id = '\(renglonVisibilidades["id"]!)'"
                    
                    print(sqlReporteVisibilidad)
                    let resultadoInsertReporteVisibilidad = self.db.execute_query(sqlReporteVisibilidad)
                    
                    print("resultado de replicar reporte promocion")
                    print(resultadoInsertReporteVisibilidad)
                    
                    
                    sqlReporteVisibilidad = "select * from report_visibility where id_report_local = '\(idReporteLocal2)' order by id desc limit 1"
                    
                    print(sqlReporteVisibilidad)
                    
                    let restultadoVisibilidad = self.db.select_query_columns(sqlReporteVisibilidad)
                    
                    print(restultadoVisibilidad)
                    
                    for renglon in restultadoVisibilidad {
                        
                        
                        let random = Int(arc4random_uniform(1000))
                        
                        let el_hash=String(tiempo_milisegundos) + String(describing: renglon["id"] as! Int) + String(random)
                        
                        let sqlUpdate = "update report_visibility set hash = '\(el_hash.md5())' where id = \(renglon["id"] as! Int)"
                        
                        print(sqlUpdate)
                        
                        let resultadoUpdate = self.db.execute_query(sqlUpdate)
                        
                        print(resultadoUpdate)
                        
                        
                        
                        //fotos y marcas
                        
                        /*
                        
                        var sqlFotos = "insert into report_photo_visibility (id_report_local,id_report_visibility,path,hash,is_send,idReportServer) select '\(idReporteLocal2)','\(renglon["id"]!)',path,hash,is_send,idReportServer from report_photo_visibility where id_report_visibility in (select id from report_visibility where id_report_local = '\(idReporteLocal)' and id = '\(renglonVisibilidades["id"]!)')"
                        
                        let resultadoPromocionFotos = self.db.execute_query(sqlFotos)
                        
                        print("resultado visibilidad fotos")
                        print(resultadoPromocionFotos)
                        
                        
                        sqlFotos = "select * from report_photo_visibility where id_report_visibility = '\(renglon["id"]!)'"
                        
                        let resultadoFotos = self.db.select_query_columns(sqlFotos)
                        
                        for foto in resultadoFotos {
                            
                            let random = Int(arc4random_uniform(1000))
                            
                            let el_hash=String(tiempo_milisegundos) + String(describing: renglon["id"] as! Int) + String(random)
                            
                            let sqlUpdate = "update report_photo_visibility set hash = '\(el_hash.md5())' where id = \(foto["id"] as! Int)"
                            
                            print(sqlUpdate)
                            
                            let resultadoUpdate = self.db.execute_query(sqlUpdate)
                            
                            print(resultadoUpdate)
                            
                            
                        }
                        
                        */
                        
                        
                        var sqlMarcas = "insert into report_visibility_brands (id_brand,id_category,id_report_visibility,hash,is_send,id_report_local,idReportServer) select id_brand,id_category,'\(renglon["id"]!)',hash,is_send,'\(idReporteLocal2)',idReportServer from report_visibility_brands where id_report_visibility in (select id from report_visibility where id_report_local = '\(idReporteLocal)' and id = \(renglonVisibilidades["id"]!))"
                        
                        let resultadoPromocionMarcas = self.db.execute_query(sqlMarcas)
                        
                        print("resultado visibilidad Marcas")
                        print(resultadoPromocionMarcas)
                        
                        
                        sqlMarcas = "select * from report_visibility_brands where id_report_visibility = '\(renglon["id"]!)'"
                        
                        let resultadoMarcas = self.db.select_query_columns(sqlMarcas)
                        
                        for marca in resultadoMarcas {
                            
                            let random = Int(arc4random_uniform(1000))
                            
                            let el_hash=String(tiempo_milisegundos) + String(describing: renglon["id"] as! Int) + String(random)
                            
                            let sqlUpdate = "update report_visibility_brands set hash = '\(el_hash.md5())' where id = \(marca["id"] as! Int)"
                            
                            print(sqlUpdate)
                            
                            let resultadoUpdate = self.db.execute_query(sqlUpdate)
                            
                            print(resultadoUpdate)
                            
                            
                        }
                        
                        
                        
                        //fotos y marcas
                        
                        
                        
                    }
                    
                    
                    
                }
                
                
                //fin reporte visibilidad
                
                
                
                
                */
                /*
                
                
                //reporte encuesta
                
                //let sqlEncuesta = "select * from EARespuesta where idReporteLocal = '\(idReporteLocal)'"
                
                //let resultadoEncuestas = self.db.select_query_columns(sqlEncuesta)
                
                
                //for renglonEncuestas in resultadoEncuestas {
                    
                    
                    
                    var sqlReporteEncuesta = "insert into EARespuesta (idReportServer,hash,idPregunta,idReporteLocal,idEncuesta,numeroEncuesta,respuesta,campoExtra1,campoExtra2) select idReportServer,hash,idPregunta,\(idReporteLocal2),idEncuesta,numeroEncuesta,respuesta,campoExtra1,campoExtra2 from EARespuesta where idReporteLocal = '\(idReporteLocal)'"
                    
                    print(sqlReporteEncuesta)
                    let resultadoInsertReporteEncuesta = self.db.execute_query(sqlReporteEncuesta)
                    
                    print("resultado de replicar reporte encuesta")
                    print(resultadoInsertReporteEncuesta)
                    
                    
                    sqlReporteEncuesta = "select * from EARespuesta where idReporteLocal = '\(idReporteLocal2)' order by id desc"
                    
                    print(sqlReporteEncuesta)
                    
                    let restultadoEncuesta = self.db.select_query_columns(sqlReporteEncuesta)
                    
                    print(restultadoEncuesta)
                    
                    for renglon in restultadoEncuesta {
                        
                        
                        let random = Int(arc4random_uniform(1000))
                        
                        let el_hash=String(tiempo_milisegundos) + String(describing: renglon["id"] as! Int) + String(random)
                        
                        let sqlUpdate = "update EARespuesta set hash = '\(el_hash.md5())' where id = \(renglon["id"] as! Int)"
                        
                        print(sqlUpdate)
                        
                        let resultadoUpdate = self.db.execute_query(sqlUpdate)
                        
                        print(resultadoUpdate)
                        
                        
                        
                        //fotos y marcas
                       
                        
                        /*
                        var sqlFotos = "insert into report_photo_visibility (id_report_local,id_report_visibility,path,hash,is_send,idReportServer) select '\(idReporteLocal2)','\(renglon["id"]!)',path,hash,is_send,idReportServer from report_photo_visibility where id_report_visibility in (select id from report_visibility where id_report_local = '\(idReporteLocal)' and id = '\(renglonVisibilidades["id"]!)')"
                        
                        let resultadoPromocionFotos = self.db.execute_query(sqlFotos)
                        
                        print("resultado visibilidad fotos")
                        print(resultadoPromocionFotos)
                        
                        
                        sqlFotos = "select * from report_photo_visibility where id_report_visibility = '\(renglon["id"]!)'"
                        
                        let resultadoFotos = self.db.select_query_columns(sqlFotos)
                        
                        for foto in resultadoFotos {
                            
                            let random = Int(arc4random_uniform(1000))
                            
                            let el_hash=String(tiempo_milisegundos) + String(describing: renglon["id"] as! Int) + String(random)
                            
                            let sqlUpdate = "update report_photo_visibility set hash = '\(el_hash.md5())' where id = \(foto["id"] as! Int)"
                            
                            print(sqlUpdate)
                            
                            let resultadoUpdate = self.db.execute_query(sqlUpdate)
                            
                            print(resultadoUpdate)
                            
                            
                        }
                        
                        
                        
                        */
                        
                        //fotos y marcas
                        
                        
                        
                    }
                    
                    
                    
                //}
                
                
                //fin reporte encuesta
                
                
                */
                
                
                
                
            }
            
            }
            
        //})
            
        }
        
                
         self.defaults.removeObject(forKey: "idReporteLocal")
        
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [],animations: {
            
            self.skaVista.frame.origin.y = self.view.frame.height
            // self.username.center.x += self.view.bounds.width
            }, completion: {finished in
                
                self.skaVista.removeFromSuperview()
                // the code you put here will be executed when your animation finishes, therefore
                // call your function here
        } )
                
                
                //actualizar texto cargador
                
                let controladorActual = UIApplication.topViewController()
                
                DispatchQueue.main.async {
                    
                    self.mostrarCargador()
                    
                    let subvistas = controladorActual?.view!.subviews
                    
                    for subvista in subvistas! where subvista.tag == 179 {
                        
                        let subvistasCargador = subvista.subviews
                        
                        for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                            
                            (subvistaCargador as! UIButton).setTitle("CHECKOUT LISTO, Toque para cerrar", for: .normal)
                            
                        }
                        
                        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.checkOutListo(sender:)))
                        singleTap.cancelsTouchesInView = false
                        singleTap.numberOfTapsRequired = 1
                        subvista.addGestureRecognizer(singleTap)
                        
                        
                    }
                    
                }
                
                //fin actualizar texto cargador
                
        /*
        DispatchQueue.main.async {
        
        SwiftSpinner.show("CHECKOUT LISTO, Toque para cerrar").addTapHandler({SwiftSpinner.hide()
        
        
            self.performSegue(withIdentifier: "modulostoinicio", sender: self)
        
        })
            
          
            
            
            
        }
        */
            
            
            
        
            
            
            })
        
        }
        
    }
    
    func mostrarCargador(){
        
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
        
        
    }
    
    @objc func iradistribucion(sender:UIButton){
    
        defaults.set("distribucion", forKey: "moduloTipo")
        
        self.performSegue(withIdentifier: "modulostomodulo", sender: self)
        
    }
    
    @objc func irapromocion(sender:UIButton){
        
        defaults.set("promocion", forKey: "moduloTipo")
        
        self.performSegue(withIdentifier: "modulostopromociones", sender: self)
        
    }
    
    @objc func iravisibilidad(sender:UIButton){
    
        defaults.set("visibilidad",forKey:"moduloTipo")
        
        self.performSegue(withIdentifier: "modulostovisibilidadlista", sender: self)
    
    }
    
    @objc func iraencuestas(sender:UIButton){
        
        defaults.set("encuestas",forKey:"moduloTipo")
        
        self.performSegue(withIdentifier: "modulostoencuestas", sender: self)
        
    }
    
    
    @objc func ir_modulo(sender:UIButton){
        
        tipo = tags[sender.tag] as! String
        
        
        self.performSegue(withIdentifier: "modulostomodulo", sender: self)
        
    }
    
   /*func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "modulostomodulo" {
            
            let modulo = segue.destinationViewController as! ModuloController
            
            modulo.tipo = tipo
            
        }
        
    }
    */
    
}
