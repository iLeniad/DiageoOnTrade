//
//  EncuestaController.swift
//  OnTrade2
//
//  Created by Daniel Cedeño García on 10/25/16.
//  Copyright © 2016 Go Sharp. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import AssetsLibrary


class EncuestaController: UIViewController,UIScrollViewDelegate,CLLocationManagerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    
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
    
    var preguntas:[[String:AnyObject]] = [[:]]
    var secciones:[[String:AnyObject]] = [[:]]
    
    //var laEncuesta:EncuestaConstructor = EncuestaConstructor()
    
    var laVista:UIScrollView = UIScrollView()
    
    var barraTitulo:UIScrollView = UIScrollView()
    
    
    
    var color_letra = "c70752"
    
    var fontFamilia = "Dosis-Regular"
    
    var foto_tag:Int = 0
    
    var imagePicker: UIImagePickerController!
    
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
        
        
        
        laVista.frame = CGRect(x: 0, y: barraTitulo.frame.height + barraTitulo.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height - barraTitulo.frame.height - barraTitulo.frame.origin.y)
        
        self.view.addSubview(laVista)
        
        self.view.addSubview(barraTitulo)
        
        
        
        
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
        
        botoRegresar.addTarget(self, action: #selector(EncuestaController.regresar(sender:)), for: .touchDown)
        
        self.view.addSubview(botoMenu)
        self.view.addSubview(botoRegresar)
        
        //self.view.addSubview(barraSubTitulo)
        
        self.view.backgroundColor = UIColor(rgba: "#ffffff")
        
        let idPoll = defaults.object(forKey: "idPoll") as! NSNumber
        
        print("Estamos en encuesta con la idPoll \(idPoll)")
        
        db.open_database(base)
        
        let sqlListaSecciones = "select * from ea_section where poll = '\(idPoll)'"
        
        var resultadoSecciones = db.select_query_columns(sqlListaSecciones)
        
        let tamano_letra_menu:CGFloat = 20
        
        var offsetScroll = barraTitulo.frame.origin.y + barraTitulo.frame.height + 20
        
        var offsetx:CGFloat = 0
        
        let alto_menu:CGFloat = 70
        
        print("tenemos \(resultadoSecciones.count) secciones")
        
        offsetScroll = 0
        
        var haySecciones = true
        
        if resultadoSecciones.count == 0 {
        
            haySecciones = false
            
            resultadoSecciones.append(["name":"" as AnyObject])
        
        }
        
        secciones.removeAll()
        preguntas.removeAll()
        
        for renglonSeccion in resultadoSecciones {
            
            
            let barraSubTitulo:UIScrollView = UIScrollView()
            
            let textoSubTitulo:UIButton = UIButton()
            
            barraSubTitulo.frame = CGRect(x: 0, y: offsetScroll, width: barraTitulo.frame.width, height: barraTitulo.frame.height/2)
            
            let fondoBarraSubTitulo = UIImage(named: "LineaGris")
            
            let vistaFondoBarraSubtitulo:UIImageView = UIImageView()
            
            vistaFondoBarraSubtitulo.image = fondoBarraSubTitulo
            
            vistaFondoBarraSubtitulo.frame = CGRect(x: 0, y: 0, width: barraSubTitulo.frame.width, height: barraSubTitulo.frame.height)
            
            vistaFondoBarraSubtitulo.contentMode = .scaleAspectFit
            
            
            
            textoSubTitulo.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
            
            textoSubTitulo.titleLabel!.font = textoSubTitulo.titleLabel!.font.withSize(CGFloat(14))
            
            
            
            textoSubTitulo.setAttributedTitle(nil, for: UIControlState())
            textoSubTitulo.setTitle(renglonSeccion["name"] as? String, for: UIControlState())
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
            barraSubTitulo.addSubview(textoSubTituloIzquierda)
            
            
            
            
            var sqlPreguntas = ""
            
            
            if haySecciones {
            
            sqlPreguntas = "select * from ea_question where poll = '\(idPoll)' and section = '\(renglonSeccion["id"]!)' order by order_by"
                
            }
            else{
            
            sqlPreguntas = "select * from ea_question where poll = '\(idPoll)' order by order_by"
            
            }
            
            //print(sqlPreguntas)
            
            let resultadoPreguntas = db.select_query_columns(sqlPreguntas)
            
            print(resultadoPreguntas)
            
            if resultadoPreguntas.count > 0 {
            
                secciones.append([String:AnyObject]())
                
                secciones[secciones.count - 1]["seccion"] = renglonSeccion["name"]
                secciones[secciones.count - 1]["barra"] = barraSubTitulo
                
                laVista.addSubview(barraSubTitulo)
                
                offsetScroll += barraSubTitulo.frame.height

                
            }
            
            let idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
            
            for renglonPregunta in resultadoPreguntas {
                
                preguntas.append([String:AnyObject]())
                
                let botonPregunta:UIButton = UIButton()
                
                botonPregunta.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
                
                botonPregunta.titleLabel!.font = botonPregunta.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
                
                
                botonPregunta.setAttributedTitle(nil, for: UIControlState())
                botonPregunta.setTitle(renglonPregunta["question"] as? String, for: UIControlState())
                botonPregunta.tag = preguntas.count - 1
                
                preguntas[preguntas.count - 1]["seccion"] = renglonSeccion["name"]
                preguntas[preguntas.count - 1]["pregunta"] = renglonPregunta["question"]
                preguntas[preguntas.count - 1]["id"] = renglonPregunta["id"]
                preguntas[preguntas.count - 1]["type_question"] = renglonPregunta["type_question"]
                preguntas[preguntas.count - 1]["parent"] = renglonPregunta["parent"]
                preguntas[preguntas.count - 1]["value_dependency"] = renglonPregunta["value_dependency"]
                preguntas[preguntas.count - 1]["operator_dependency"] = renglonPregunta["operator_dependency"]
                
                botonPregunta.isSelected = false
                botonPregunta.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
                
                
                
                botonPregunta.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
                botonPregunta.titleLabel!.numberOfLines = 0
                botonPregunta.titleLabel!.textAlignment = .left
                
                
                botonPregunta.sizeToFit()
                
                botonPregunta.frame = CGRect(x: offsetx, y: offsetScroll, width: laVista.frame.width - offsetx, height: alto_menu)
                
                //botonPregunta.titleLabel!.adjustFontSizeToFitRect(rect: botonPregunta.frame, maximo: tamano_letra_menu)
                
                botonPregunta.contentHorizontalAlignment = .left
                botonPregunta.contentVerticalAlignment = .center
                
                
                //botonListaEncuestas(UIImage(named: "MenuHome"), forState: .Normal)
                
                //botonPregunta.addTarget(self, action:#selector(EncuestaController.mostrarOpciones(sender:)), for:.touchDown)
                
                preguntas[preguntas.count - 1]["boton"] = botonPregunta
                
                laVista.addSubview(botonPregunta)
                
                offsetScroll += botonPregunta.frame.height + 80
                
                //tipo 15
                
                if renglonPregunta["type_question"] as! NSNumber == 15 {
                    
                    
                    //botonPregunta.removeFromSuperview()
                    
                    
                    
                    let aux_b_foto = UIButton()
                    
                    aux_b_foto.tag = preguntas.count - 1
                    
                    
                    
                    aux_b_foto.setImage(UIImage(named: "CamaraInactiva"), for: .normal)
                    
                    //botonfoto.addTarget(self, action: "tomar_foto:", forControlEvents:.TouchDown)
                    
                    
                    aux_b_foto.setAttributedTitle(nil, for: .normal)
                    aux_b_foto.setTitle("Tomar Foto", for: .normal)
                    
                    aux_b_foto.isSelected = false
                    //aux_b_foto.setTitleColor(UIColor(rgba: "#\(colorTexto)"), for: .normal)
                    
                    aux_b_foto.titleLabel!.font = UIFont(name: "TitilliumWeb-SemiBold", size: 4)
                    
                    aux_b_foto.titleLabel!.font = aux_b_foto.titleLabel!.font.withSize(12)
                    
                    //aux_b_foto.titleLabel!.textColor = UIColor(rgba: "#\(colorTexto)")
                    aux_b_foto.titleLabel!.numberOfLines = 0
                    aux_b_foto.titleLabel!.textAlignment = .left
                    aux_b_foto.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
                    
                    
                    aux_b_foto.frame = CGRect(x: 10, y: offsetScroll - 8, width: 44, height: 44)
                    
                    
                    
                    aux_b_foto.contentEdgeInsets = UIEdgeInsetsMake(0, 0, aux_b_foto.titleLabel!.bounds.height + 4, 0)
                    aux_b_foto.titleEdgeInsets = UIEdgeInsetsMake((aux_b_foto.imageView?.image!.size.height)! + 18, -(aux_b_foto.imageView?.image!.size.width)!, 0, 0)
                    aux_b_foto.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -aux_b_foto.titleLabel!.bounds.width)
                    
                    aux_b_foto.addTarget(self, action:#selector(EncuestaController.tomar_foto(sender:)), for:.touchDown)
                    
                    laVista.addSubview(aux_b_foto)
                    
                    preguntas[preguntas.count - 1]["aux_b_foto"] = aux_b_foto
                    
                    offsetScroll += aux_b_foto.frame.height + 50
                    
                    
                    let idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
                    
                    
                    
                    if idReporteLocal != nil {
                        
                        
                        let idPoll = defaults.object(forKey: "idPoll") as! NSNumber
                        
                        let numeroEncuesta = defaults.object(forKey: "numeroEncuesta") as! NSNumber
                        
                        let checarRespuesta = "select * from EARespuesta where idPregunta = '\(renglonPregunta["id"]!)' and idReporteLocal = '\(idReporteLocal!)' and idEncuesta = '\(idPoll)' and numeroEncuesta = '\(numeroEncuesta)'"
                        
                        print(checarRespuesta)
                        
                        let resultadoChecarRespuesta = db.select_query_columns(checarRespuesta)
                        
                        if resultadoChecarRespuesta.count > 0 {
                            
                            aux_b_foto.setImage(UIImage(named: "CamaraActiva"), for: .normal)
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                
                if renglonPregunta["type_question"] as! NSNumber == 2 {
                    
                    
                    let botonResponder:UIButton = UIButton()
                    
                    
                    botonResponder.tag = preguntas.count - 1
                    
                    botonResponder.isSelected = false
                    botonResponder.setTitleColor(UIColor(rgba: "#000000"), for: UIControlState())
                    
                    
                    
                    botonResponder.titleLabel!.textColor = UIColor(rgba: "#000000")
                    botonResponder.titleLabel!.numberOfLines = 0
                    botonResponder.titleLabel!.textAlignment = .center
                    
                    
                    botonResponder.sizeToFit()
                    
                    botonResponder.frame = CGRect(x: laVista.frame.width/2, y: offsetScroll, width: (laVista.frame.width - offsetx)/2, height: 60)
                    
                    
                    
                    botonResponder.contentHorizontalAlignment = .center
                    botonResponder.contentVerticalAlignment = .center
                    
                    botonResponder.setImage(UIImage(named:"BotonResponder"), for: .normal)
                    //botonComentar(UIImage(named: "MenuHome"), forState: .Normal)
                    
                    let idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
                    
                    
                    
                    if idReporteLocal != nil {
                        
                        
                        let idPoll = defaults.object(forKey: "idPoll") as! NSNumber
                        
                        let numeroEncuesta = defaults.object(forKey: "numeroEncuesta") as! NSNumber
                        
                        let checarRespuesta = "select * from EARespuesta where idPregunta = '\(renglonPregunta["id"]!)' and idReporteLocal = '\(idReporteLocal!)' and idEncuesta = '\(idPoll)' and numeroEncuesta = '\(numeroEncuesta)'"
                        
                        print(checarRespuesta)
                        
                        let resultadoChecarRespuesta = db.select_query_columns(checarRespuesta)
                        
                        if resultadoChecarRespuesta.count > 0 {
                            
                            botonResponder.setImage(UIImage(named:"BotonResponderRojo"), for: .normal)
                            
                            for renglonRespuesta in resultadoChecarRespuesta {
                                
                                if renglonRespuesta["campoExtra1"] as! String != "" {
                                    
                                   
                                    
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                    botonResponder.imageView!.contentMode = .scaleToFill
                    
                    
                    
                    botonResponder.addTarget(self, action:#selector(EncuestaController.mostrarOpciones(sender:)), for:.touchDown)
                    
                    laVista.addSubview(botonResponder)
                    
                    offsetScroll += 80
                    
                    
                    let sqlOpciones = "select * from ea_question_option where question = '\(renglonPregunta["id"]!)' order by id asc"
                    
                    let resultadoOpciones = db.select_query_columns(sqlOpciones)
                    
                    var aux_opciones:[[String:AnyObject]] = [[:]]
                    
                    aux_opciones.removeAll()
                    
                    for reglonOpcion in resultadoOpciones {
                        
                        
                        
                        aux_opciones.append([String:AnyObject]())
                        aux_opciones[aux_opciones.count - 1]["opcion"] = reglonOpcion["option_label"]
                        
                        var aux_valor:String = ""
                        
                        //if let _ = reglonOpcion["option_value"] as? NSNumber {
                        
                        aux_valor = reglonOpcion["option_value"] as! String
                        //}
                        
                        aux_opciones[aux_opciones.count - 1]["valor"] = aux_valor as AnyObject?
                        
                    }
                    
                    //print(aux_opciones)
                    
                    preguntas[preguntas.count - 1]["opciones"] = aux_opciones as AnyObject?
                    
                    
                    
                }
                
                
                
                
                
                
                
                //tipo 7 y 8 y 5 de preguntas
                
                if renglonPregunta["type_question"] as! NSNumber == 7 ||  renglonPregunta["type_question"] as! NSNumber == 8 ||  renglonPregunta["type_question"] as! NSNumber == 5 {
                    
                    
                    var textoComentario = "Agrega tu respuesta"
                    
                    let idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
                    
                    print(idReporteLocal as Any)
                    
                    if idReporteLocal != nil {
                        
                        
                        
                        let numeroEncuesta = defaults.object(forKey: "numeroEncuesta") as! NSNumber
                        
                        let idPoll = defaults.object(forKey: "idPoll") as! NSNumber
                        
                        
                        let checarRespuesta = "select * from EARespuesta where idPregunta = '\(renglonPregunta["id"]!)' and idReporteLocal = '\(idReporteLocal!)' and idEncuesta = '\(idPoll)' and numeroEncuesta = '\(numeroEncuesta)'"
                        
                        print(checarRespuesta)
                        
                        let resultadoChecarRespuesta = db.select_query_columns(checarRespuesta)
                        
                        if resultadoChecarRespuesta.count > 0 {
                            
                            for renglonComentario in resultadoChecarRespuesta {
                                
                                if renglonComentario["respuesta"] as! String != "" {
                                
                                textoComentario = renglonComentario["respuesta"] as! String
                                    
                                }
                                
                                preguntas[preguntas.count - 1]["respuesta"] = renglonComentario["respuesta"]
                                
                            }
                            
                        }
                        
                        
                        
                    }
                    
                    
                    let textoCampo:UIButton = UIButton()
                    
                    
                    textoCampo.titleLabel!.font = UIFont(name: "TitilliumWeb-Regular", size: CGFloat(3))
                    
                    textoCampo.titleLabel!.font = textoCampo.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
                    
                    
                    textoCampo.setAttributedTitle(nil, for: UIControlState())
                    textoCampo.setTitle(textoComentario, for: UIControlState())
                    
                    
                    textoCampo.tag = preguntas.count - 1
                    
                    textoCampo.isSelected = false
                    textoCampo.setTitleColor(UIColor(rgba: "#ffffff"), for: UIControlState())
                    
                    
                    
                    textoCampo.titleLabel!.textColor = UIColor(rgba: "#ffffff")
                    textoCampo.titleLabel!.numberOfLines = 0
                    textoCampo.titleLabel!.textAlignment = .left
                    
                    textoCampo.backgroundColor = UIColor(rgba: "#c70752")
                    
                    
                    textoCampo.sizeToFit()
                    
                    offsetScroll -= 50
                    
                    textoCampo.frame = CGRect(x: 0, y: offsetScroll, width: laVista.frame.width, height: laVista.frame.height/3)
                    
                    textoCampo.titleLabel!.adjustFontSizeToFitRect(rect: textoCampo.frame, maximo: 20)
                    
                    
                    
                    textoCampo.contentHorizontalAlignment = .left
                    textoCampo.contentVerticalAlignment = .top
                    
                    preguntas[preguntas.count - 1]["textoCampo"] = textoCampo
                    
                    laVista.addSubview(textoCampo)
                    
                    textoCampo.addTarget(self, action:#selector(EncuestaController.mostrar_campodetexto(sender:)), for:.touchDown)
                    
                    
                    botonPregunta.addTarget(self, action:#selector(EncuestaController.mostrar_campodetexto(sender:)), for:.touchDown)
                    
                    offsetScroll += textoCampo.frame.height + 50
                    
                }
                // fin tipo 7 y 8 y 5
                
                
                
                
                
                
                //tipo 17
                
                if renglonPregunta["type_question"] as! NSNumber == 17 {
                    
                    botonPregunta.frame = CGRect(x: botonPregunta.frame.origin.x, y: botonPregunta.frame.origin.y, width: laVista.frame.width - laVista.frame.width/4, height: botonPregunta.frame.height)
                    
                    let botonSwitch:UISwitch = UISwitch()
                    
                    botonSwitch.tag = preguntas.count - 1
                    
                    botonSwitch.frame = CGRect(x: laVista.frame.width - laVista.frame.width/4, y: botonPregunta.frame.origin.y + 20, width: laVista.frame.width/4, height: botonPregunta.frame.height)
                    
                    botonSwitch.contentVerticalAlignment = .bottom
                    botonSwitch.contentHorizontalAlignment = .right
                    
                    let numeroEncuesta = defaults.object(forKey: "numeroEncuesta") as! NSNumber
                    
                    let sqlRespuesta = "select * from EARespuesta where idPregunta= '\(preguntas[preguntas.count - 1]["id"]!)' and idReporteLocal='\(idReporteLocal!)' and idEncuesta = '\(idPoll)' and numeroEncuesta = '\(numeroEncuesta)'"
                    
                    let resultadoRespuesta = db.select_query_columns(sqlRespuesta)
                    
                    
                    
                    for renglon in resultadoRespuesta {
                    
                        if renglon["respuesta"] as! String == "si" {
                        
                            botonSwitch.isOn = true
                            preguntas[preguntas.count - 1]["respuesta"] = "si" as AnyObject?
                        
                        }
                        
                    }
                    
                    
                    botonSwitch.addTarget(self, action:#selector(EncuestaController.switch_cambio(sender:)), for: UIControlEvents.valueChanged)
                    
                    preguntas[preguntas.count - 1]["botonSwitch"] = botonSwitch
                    
                    laVista.addSubview(botonSwitch)
                
                }
                
                
                //fin tipo 17
                
                //tipo 3
                
                if renglonPregunta["type_question"] as! NSNumber == 3 {
                    
                    let sqlOpciones = "select * from ea_question_option where question = '\(renglonPregunta["id"]!)' order by id asc"
                    
                    let resultadoOpciones = db.select_query_columns(sqlOpciones)
                    
                    offsetx = laVista.frame.width/6
                    
                    var auxOpciones:[[String:AnyObject]] = [[:]]
                    
                    auxOpciones.removeAll()
                    
                    var auxRespuesta = ""
                    
                    for opcion in resultadoOpciones {
                    
                        let botonCheck:UIButton = UIButton()
                        
                        botonCheck.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
                        
                        botonCheck.titleLabel!.font = botonCheck.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
                        
                        
                        
                        botonCheck.setAttributedTitle(nil, for: UIControlState())
                        botonCheck.setTitle(opcion["option_value"] as? String, for: UIControlState())
                        botonCheck.tag = preguntas.count - 1
                        
                        botonCheck.isSelected = false
                        botonCheck.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
                        
                        
                        
                        botonCheck.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
                        botonCheck.titleLabel!.numberOfLines = 0
                        botonCheck.titleLabel!.textAlignment = .left
                        
                        
                        botonCheck.sizeToFit()
                        
                        botonCheck.frame = CGRect(x: offsetx, y: offsetScroll, width: laVista.frame.width - offsetx, height: alto_menu)
                        
                        
                        
                        botonCheck.contentHorizontalAlignment = .left
                        botonCheck.contentVerticalAlignment = .center
                        
                        let numeroEncuesta = defaults.object(forKey: "numeroEncuesta") as! NSNumber
                        
                        let sqlRespuesta = "select * from EARespuesta where idPregunta= '\(preguntas[preguntas.count - 1]["id"]!)' and idReporteLocal='\(idReporteLocal!)' and respuesta = '\(opcion["option_value"] as! String)' and idEncuesta = '\(idPoll)' and numeroEncuesta = '\(numeroEncuesta)'"
                        
                        let resultadoRespuesta = db.select_query_columns(sqlRespuesta)
                        
                        var seleccionado = false
                        
                        if resultadoRespuesta.count > 0 {
                        
                            auxRespuesta += " "
                            
                            auxRespuesta += opcion["option_value"] as! String
                            
                            botonCheck.setImage(UIImage(named: "checkButtonSeleccionado"), for: .normal)
                            
                            seleccionado = true
                        
                        }
                        else{
                        
                        botonCheck.setImage(UIImage(named: "checkButton"), for: .normal)
                        }
                        botonCheck.imageView?.contentMode = .scaleAspectFit
                        
                        botonCheck.titleEdgeInsets = UIEdgeInsetsMake(0, botonCheck.imageView!.frame.size.width, 0, 0)
                        
                        //botonUsuario.imageEdgeInsets = UIEdgeInsetsMake(0, -botonUsuario.imageView!.frame.size.width, 0, botonUsuario.imageView!.frame.size.width);
                        //botonUsuario.titleEdgeInsets = UIEdgeInsetsMake(18, botonUsuario.titleLabel!.frame.size.width + 10, 18, -botonUsuario.titleLabel!.frame.size.width);
                        
                        auxOpciones.append(["id":opcion["id"]!,"boton":botonCheck,"opcion":opcion["option_value"]!,"seleccionado":seleccionado as AnyObject])
                        
                        botonCheck.addTarget(self, action:#selector(EncuestaController.check_opcion(sender:)), for:.touchDown)
                        
                        laVista.addSubview(botonCheck)
                        
                        offsetScroll += botonCheck.frame.height + 40
                    
                    }
                    
                    preguntas[preguntas.count - 1]["opciones"] = auxOpciones as AnyObject?
                    
                    preguntas[preguntas.count - 1]["respuesta"] = auxRespuesta as AnyObject?
                    
                }
                
                
                //fin tipo 3
                
                
                //tipo 1
                
                if renglonPregunta["type_question"] as! NSNumber == 1 {
                    
                    let sqlOpciones = "select * from ea_question_option where question = '\(renglonPregunta["id"]!)' order by id asc"
                    
                    let resultadoOpciones = db.select_query_columns(sqlOpciones)
                    
                    offsetx = laVista.frame.width/6
                    
                    var auxOpciones:[[String:AnyObject]] = [[:]]
                    
                    auxOpciones.removeAll()
                    
                    
                    for opcion in resultadoOpciones {
                        
                        let botonRadio:UIButton = UIButton()
                        
                        botonRadio.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
                        
                        botonRadio.titleLabel!.font = botonRadio.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
                        
                        
                        
                        botonRadio.setAttributedTitle(nil, for: UIControlState())
                        botonRadio.setTitle(opcion["option_value"] as? String, for: UIControlState())
                        botonRadio.tag = preguntas.count - 1
                        
                        botonRadio.isSelected = false
                        botonRadio.setTitleColor(UIColor(rgba: "#\(color_letra)"), for: UIControlState())
                        
                        
                        
                        botonRadio.titleLabel!.textColor = UIColor(rgba: "#\(color_letra)")
                        botonRadio.titleLabel!.numberOfLines = 0
                        botonRadio.titleLabel!.textAlignment = .left
                        
                        
                        botonRadio.sizeToFit()
                        
                        botonRadio.frame = CGRect(x: offsetx, y: offsetScroll, width: laVista.frame.width - offsetx, height: alto_menu)
                        
                        
                        
                        botonRadio.contentHorizontalAlignment = .left
                        botonRadio.contentVerticalAlignment = .center
                        
                        let numeroEncuesta = defaults.object(forKey: "numeroEncuesta") as! NSNumber
                        
                        let sqlRespuesta = "select * from EARespuesta where idPregunta= '\(preguntas[preguntas.count - 1]["id"]!)' and idReporteLocal='\(idReporteLocal!)' and respuesta = '\(opcion["option_value"] as! String)' and idEncuesta = '\(idPoll)' and numeroEncuesta = '\(numeroEncuesta)'"
                        
                        let resultadoRespuesta = db.select_query_columns(sqlRespuesta)
                        
                        var seleccionado = false
                        
                        if resultadoRespuesta.count > 0 {
                            
                            preguntas[preguntas.count - 1]["respuesta"] = opcion["option_value"]
                            
                            botonRadio.setImage(UIImage(named: "RadioButtonSeleccionado"), for: .normal)
                            
                            seleccionado = true
                            
                        }
                        else{
                            
                            botonRadio.setImage(UIImage(named: "RadioButton"), for: .normal)
                        }
                        botonRadio.imageView?.contentMode = .scaleAspectFit
                        
                        botonRadio.titleEdgeInsets = UIEdgeInsetsMake(0, botonRadio.imageView!.frame.size.width, 0, 0)
                        
                        //botonUsuario.imageEdgeInsets = UIEdgeInsetsMake(0, -botonUsuario.imageView!.frame.size.width, 0, botonUsuario.imageView!.frame.size.width);
                        //botonUsuario.titleEdgeInsets = UIEdgeInsetsMake(18, botonUsuario.titleLabel!.frame.size.width + 10, 18, -botonUsuario.titleLabel!.frame.size.width);
                        
                        auxOpciones.append(["id":opcion["id"]!,"boton":botonRadio,"opcion":opcion["option_value"]!,"seleccionado":seleccionado as AnyObject])
                        
                        botonRadio.addTarget(self, action:#selector(EncuestaController.radio_opcion(sender:)), for:.touchDown)
                        
                        laVista.addSubview(botonRadio)
                        
                        offsetScroll += botonRadio.frame.height + 40
                        
                    }
                    
                    preguntas[preguntas.count - 1]["opciones"] = auxOpciones as AnyObject?
                    
                }
                
                
                //fin tipo 1
                
                
                
                //fin tipo de preguntas
                
                
            }
            
        }
        
        
        //laVista.contentSize = CGSizeMake(laVista.contentSize.width, offsetScroll)
        
        laVista.contentSize = CGSize(width: laVista.contentSize.width, height: offsetScroll)
        
        acomodar_preguntas()
        
    }
    
    //fin viewdidappear
    
    
    // MARK: - Funciones de botones
    
    @objc func switch_cambio(sender:UISwitch){
    
        let idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber

        let random = Int(arc4random_uniform(1000))
        
        let tiempo_milisegundos = String(Int64(NSDate().timeIntervalSince1970*1000))
        
        let el_hash=String(tiempo_milisegundos) + String(describing: defaults.object(forKey: "idReporteLocal")!) + String(random)
        
        let hash = el_hash.md5()
        
        var respuesta = "no"
        
        if sender.isOn {
        
            respuesta = "si"
            
        }
        
        preguntas[sender.tag]["respuesta"] = respuesta as AnyObject
        
        let idPoll = defaults.object(forKey: "idPoll") as! NSNumber
        
        let numeroEncuesta = defaults.object(forKey: "numeroEncuesta") as! NSNumber
        
        
        let sqlRespuesta = "select * from EARespuesta where idPregunta= '\(preguntas[sender.tag]["id"]!)' and idReporteLocal='\(idReporteLocal!)' and idEncuesta = '\(idPoll)' and numeroEncuesta = '\(numeroEncuesta)'"
        
        let resultadoRespuesta = db.select_query_columns(sqlRespuesta)
        
        var sqlSwitch = ""
        
        if resultadoRespuesta.count < 1 {
        
            sqlSwitch = "insert into EARespuesta (hash,idPregunta,idReporteLocal,idEncuesta,numeroEncuesta,respuesta,campoExtra1,campoExtra2) values ('\(hash)','\(preguntas[sender.tag]["id"]!)','\(idReporteLocal!)','\(idPoll)','\(numeroEncuesta)','\(respuesta.replacingOccurrences(of: "'", with: "''"))','','')"
            
        }
        else{
        
            sqlSwitch = "update EARespuesta set respuesta = '\(respuesta.replacingOccurrences(of: "'", with: "''"))' where idPregunta= '\(preguntas[sender.tag]["id"]!)' and idReporteLocal='\(idReporteLocal!)'"
        
        }
        
        _ = db.execute_query(sqlSwitch)
        
    acomodar_preguntas()
        
    }
    
    @objc func check_opcion(sender:UIButton){
    
        print("se oprimio check opcion")
        
        let idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
        
        let random = Int(arc4random_uniform(1000))
        
        let tiempo_milisegundos = String(Int64(NSDate().timeIntervalSince1970*1000))
        
        let el_hash=String(tiempo_milisegundos) + String(describing: defaults.object(forKey: "idReporteLocal")!) + String(random)
        
        let hash = el_hash.md5()
        
        
        
        
        
        let idPoll = defaults.object(forKey: "idPoll") as! NSNumber
        
        let numeroEncuesta = defaults.object(forKey: "numeroEncuesta") as! NSNumber
        
        
        var auxOpciones = preguntas[sender.tag]["opciones"] as![[String:AnyObject]]
        
        
        var q = 0
        
        preguntas[sender.tag]["respuesta"] = "" as AnyObject?
        
        var auxRespuesta = ""
        
        for opcion in auxOpciones {
        
            let auxBoton = opcion["boton"] as! UIButton
            
            
            
            if auxBoton == sender {
            
                let auxSeleccionado = auxOpciones[q]["seleccionado"] as! Bool
                
                var sqlRespuesta = ""
                
                if auxSeleccionado {
                    
                    
                
                auxOpciones[q]["seleccionado"] = false as AnyObject?
                    sender.setImage(UIImage(named: "checkButton"), for: .normal)
                    
                    sqlRespuesta = "delete from EARespuesta where idPregunta= '\(preguntas[sender.tag]["id"]!)' and idReporteLocal='\(idReporteLocal!)' and respuesta = '\(auxOpciones[q]["opcion"] as! String)' and idEncuesta = '\(idPoll)'"
                    
                }
                else{
                    auxRespuesta += " "
                    
                    auxRespuesta += auxOpciones[q]["opcion"] as! String
                
                    auxOpciones[q]["seleccionado"] = true as AnyObject?
                    sender.setImage(UIImage(named: "checkButtonSeleccionado"), for: .normal)
                    
                    sqlRespuesta = "insert into EARespuesta (hash,idPregunta,idReporteLocal,idEncuesta,numeroEncuesta,respuesta,campoExtra1,campoExtra2) values ('\(hash)','\(preguntas[sender.tag]["id"]!)','\(idReporteLocal!)','\(idPoll)','\(numeroEncuesta)','\((auxOpciones[q]["opcion"] as! String).replacingOccurrences(of: "'", with: "''"))','','')"
                
                }
                
                let resultadoCheckOpcion = db.execute_query(sqlRespuesta)
                
                print(resultadoCheckOpcion)
            
            }
            else{
            
                
                
                let auxSeleccionado = auxOpciones[q]["seleccionado"] as! Bool
                
                
                
                if auxSeleccionado {
                    
                    auxRespuesta += " "
                    
                    auxRespuesta += auxOpciones[q]["opcion"] as! String
                    
                    
                }
                
                
                
            
            }
        
            q += 1
        
        }
        
        preguntas[sender.tag]["respuesta"] = auxRespuesta as AnyObject?
        
        preguntas[sender.tag]["opciones"] = auxOpciones as AnyObject?
        
        
        
     acomodar_preguntas()
        
    }
    
    @objc func regresar(sender:UIButton){
    
        self.performSegue(withIdentifier: "encuestatolistaencuestas", sender: self)
    
    
    }
    
    @objc func radio_opcion(sender:UIButton){
        
        
        let idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
        
        let random = Int(arc4random_uniform(1000))
        
        let tiempo_milisegundos = String(Int64(NSDate().timeIntervalSince1970*1000))
        
        let el_hash=String(tiempo_milisegundos) + String(describing: defaults.object(forKey: "idReporteLocal")!) + String(random)
        
        let hash = el_hash.md5()
        
        
        
        
        
        let idPoll = defaults.object(forKey: "idPoll") as! NSNumber
        
        //let numeroEncuesta = defaults.object(forKey: "numeroEncuesta") as! NSNumber
        
        
        var auxOpciones = preguntas[sender.tag]["opciones"] as![[String:AnyObject]]
        
        
        var q = 0
        
        preguntas[sender.tag]["respuesta"] = "" as AnyObject?
        
        for opcion in auxOpciones {
            
            let auxBoton = opcion["boton"] as! UIButton
            
            
            
            var sqlInsert = ""
            
            if auxBoton == sender {
                
                let numeroEncuesta = defaults.object(forKey: "numeroEncuesta") as! NSNumber
                
                let sqlRespuesta = "select * from EARespuesta where idPregunta= '\(preguntas[sender.tag]["id"]!)' and idReporteLocal='\(idReporteLocal!)' and idEncuesta = '\(idPoll)' and numeroEncuesta = '\(numeroEncuesta)'"
                
                let resultadoRespuesta = db.select_query_columns(sqlRespuesta)
                
                
                preguntas[sender.tag]["respuesta"] = auxOpciones[q]["opcion"]
                
                if resultadoRespuesta.count > 0 {
                    
                    sqlInsert = "update EARespuesta set respuesta = '\((auxOpciones[q]["opcion"] as! String).replacingOccurrences(of: "'", with: "''"))' where idPregunta= '\(preguntas[sender.tag]["id"]!)' and idReporteLocal='\(idReporteLocal!)' and idEncuesta = '\(idPoll)'"
                    
                }
                else{
                
                    
                    
                    sqlInsert = "insert into EARespuesta (hash,idPregunta,idReporteLocal,idEncuesta,numeroEncuesta,respuesta,campoExtra1,campoExtra2) values ('\(hash)','\(preguntas[sender.tag]["id"]!)','\(idReporteLocal!)','\(idPoll)','\(numeroEncuesta)','\((auxOpciones[q]["opcion"] as! String).replacingOccurrences(of: "'", with: "''"))','','')"
                    
                }
                
                print(sqlInsert)
                auxOpciones[q]["seleccionado"] = true as AnyObject?
                sender.setImage(UIImage(named: "RadioButtonSeleccionado"), for: .normal)
                _ = db.execute_query(sqlInsert)
                
            }
            else{
            
                auxBoton.setImage(UIImage(named: "RadioButton"), for: .normal)
                auxOpciones[q]["seleccionado"] = false as AnyObject?
            
            }
            
            q += 1
            
        }
        
        preguntas[sender.tag]["opciones"] = auxOpciones as AnyObject?
        
        
        
    acomodar_preguntas()
        
    }
    
    
    @objc func seleccionar_opcion(sender:UIButton) {
        
        var idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
        
        print(idReporteLocal as Any)
        
        if idReporteLocal == nil {
            
            print("vamos por uno nuevo")
            
            
            
            idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
            
        }
        
        
        let idUser = defaults.object(forKey: "idUser") as! Int
        
        
        
        
        
        let random = Int(arc4random_uniform(1000))
        
        let tiempo_milisegundos = String(Int64(NSDate().timeIntervalSince1970*1000))
        
        let el_hash=String(tiempo_milisegundos) + String(describing: defaults.object(forKey: "idReporteLocal")!) + String(random)
        
        let hash = el_hash.md5()
        
        let indicePregunta = defaults.object(forKey: "indicePregunta") as! Int
        
        let pregunta = preguntas[indicePregunta]
        
        
        
        
        let idPoll = defaults.object(forKey: "idPoll") as! NSNumber
        
        let numeroEncuesta = defaults.object(forKey: "numeroEncuesta") as! NSNumber
        
        let respuesta = pregunta["opciones"] as! [[String:AnyObject]]
        
        preguntas[indicePregunta]["respuesta"] = respuesta[sender.tag-1]["valor"]
        
        let checarRespuesta = "select * from EARespuesta where idPregunta = '\(pregunta["id"]!)' and idReporteLocal = '\(idReporteLocal!)' and idEncuesta = '\(idPoll)' and numeroEncuesta = '\(numeroEncuesta)'"
        
        print(checarRespuesta)
        
        let resultadoChecarRespuesta = db.select_query_columns(checarRespuesta)
        
        if resultadoChecarRespuesta.count < 1 {
            
            let sqlRespuesta = "insert into EARespuesta (hash,idPregunta,idReporteLocal,idEncuesta,numeroEncuesta,respuesta,campoExtra1,campoExtra2) values ('\(hash)','\(pregunta["id"]!)','\(idReporteLocal!)','\(idPoll)','\(numeroEncuesta)','\(respuesta[sender.tag-1]["valor"]!.replacingOccurrences(of: "'", with: "''"))','','\(idUser)')"
            
            print(sqlRespuesta)
            
            let resultadoRespuesta = db.execute_query(sqlRespuesta)
            
            print(resultadoRespuesta)
            
        }
        else{
            
            let sqlRespuesta = "update EARespuesta set respuesta = '\(respuesta[sender.tag-1]["valor"]!.replacingOccurrences(of: "'", with: "''"))' where idPregunta = '\(pregunta["id"]!)' and idReporteLocal = '\(idReporteLocal!)' and idEncuesta = '\(idPoll)' and numeroEncuesta = '\(numeroEncuesta)'"
            
            print(sqlRespuesta)
            
            let resultadoRespuesta = db.execute_query(sqlRespuesta)
            
            print(resultadoRespuesta)
            
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [],animations: {
            
            sender.superview!.frame.origin.y = self.view.frame.height
            // self.username.center.x += self.view.bounds.width
        }, completion: {finished in
            
            self.laVista.isUserInteractionEnabled = true
            sender.superview?.removeFromSuperview()
            // the code you put here will be executed when your animation finishes, therefore
            // call your function here
        } )
        
        
        
    }
    
    //tomar foto
    
    @objc func tomar_foto(sender:UIButton){
        
        foto_tag = sender.tag
        
        
        
        
        
        self.imagePicker =  UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .camera
        
        //self.presentViewController(self.imagePicker, animated: true, completion: nil)
        
        self.addChildViewController(imagePicker)
        imagePicker.didMove(toParentViewController: self)
        self.view.addSubview(imagePicker.view)
        
        
        
    }
    
    
    
    // MARK: - Funciones de fin de vista
    
    // view will disappear
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        
    }
    
    //view will disappear
    
    // MARK: - Funciones que muestra en pantalla
    
    @objc func mostrar_campodetexto(sender:UIButton){
        
        defaults.set(sender.tag, forKey: "indicePregunta")
        
        //let pregunta = preguntas[sender.tag]
        
        var textoComentario = ""
        
        let idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
        
        print(idReporteLocal as Any)
        
        if idReporteLocal != nil {
            
            let indicePregunta = defaults.object(forKey: "indicePregunta") as! Int
            
            let pregunta = preguntas[indicePregunta]
            
            let idPoll = defaults.object(forKey: "idPoll") as! NSNumber
            
            let numeroEncuesta = defaults.object(forKey: "numeroEncuesta") as! NSNumber
            
            let checarRespuesta = "select * from EARespuesta where idPregunta = '\(pregunta["id"]!)' and idReporteLocal = '\(idReporteLocal!)' and idEncuesta = '\(idPoll)' and numeroEncuesta = '\(numeroEncuesta)'"
            
            print(checarRespuesta)
            
            let resultadoChecarRespuesta = db.select_query_columns(checarRespuesta)
            
            if resultadoChecarRespuesta.count > 0 {
                
                for renglonComentario in resultadoChecarRespuesta {
                    
                    textoComentario = renglonComentario["respuesta"] as! String
                    
                }
                
            }
            
            
            
        }
        
        
        
        
        
        let comentarioVista:UIScrollView = UIScrollView()
        
        
        comentarioVista.backgroundColor = UIColor(rgba: "#c70752")
        
        comentarioVista.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        
        let comentario:UITextField = UITextField()
        
        comentario.text = textoComentario
        
        comentario.borderStyle = .bezel
        
        comentario.backgroundColor = UIColor.white
        
        comentario.returnKeyType = .done
        
        comentario.delegate = self
        
        comentario.tag = sender.tag
        
        
        if preguntas[sender.tag]["type_question"] as! NSNumber == 5 {
        
            comentario.keyboardType = .numberPad
            addToolBar(comentario)
            
        }
        
        comentario.frame = CGRect(x: 10, y: 10, width: comentarioVista.frame.width - 20, height: comentarioVista.frame.height/4)
        
        comentarioVista.addSubview(comentario)
        
        self.view.addSubview(comentarioVista)
        
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [],animations: {
            
            comentarioVista.frame.origin.y = self.barraTitulo.frame.origin.y + self.barraTitulo.frame.height
            self.laVista.isUserInteractionEnabled = false
            // self.username.center.x += self.view.bounds.width
            }, completion: nil)
        
    }
    
    
    @objc func mostrarComentar(sender:UIButton){
        
        defaults.set(sender.tag, forKey: "indicePregunta")
        
        //let pregunta = preguntas[sender.tag]
        
        laVista.isUserInteractionEnabled = false
        
        var textoComentario = ""
        
        let idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
        
        print(idReporteLocal as Any)
        
        if idReporteLocal != nil {
            
            let indicePregunta = defaults.object(forKey: "indicePregunta") as! Int
            
            let pregunta = preguntas[indicePregunta]
            
            let idPoll = defaults.object(forKey: "idPoll") as! NSNumber
            
            
            let checarRespuesta = "select * from EARespuesta where idPregunta = '\(pregunta["id"]!)' and idReporteLocal = '\(idReporteLocal!)' and idEncuesta = '\(idPoll)'"
            
            print(checarRespuesta)
            
            let resultadoChecarRespuesta = db.select_query_columns(checarRespuesta)
            
            if resultadoChecarRespuesta.count > 0 {
                
                for renglonComentario in resultadoChecarRespuesta {
                    
                    if renglonComentario["campoExtra1"] as! String != "" {
                    
                    textoComentario = renglonComentario["campoExtra1"] as! String
                        
                    }
                    
                }
                
            }
            
            
            
        }
        
        
        
        
        
        let comentarioVista:UIScrollView = UIScrollView()
        
        
        comentarioVista.backgroundColor = UIColor(rgba: "#c70752")
        
        comentarioVista.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        
        let comentario:UITextField = UITextField()
        
        comentario.text = textoComentario
        
        comentario.borderStyle = .bezel
        
        comentario.backgroundColor = UIColor.white
        
        comentario.returnKeyType = .done
        
        comentario.delegate = self
        
        comentario.frame = CGRect(x: 10, y: 10, width: comentarioVista.frame.width - 20, height: comentarioVista.frame.height/4)
        
        comentario.tag = 0
        
        comentarioVista.addSubview(comentario)
        
        let botonGuardar:UIButton = UIButton()
        
        botonGuardar.tag = sender.tag
        
        botonGuardar.isSelected = false
        botonGuardar.setTitleColor(UIColor(rgba: "#ffffff"), for: UIControlState())
        
        
        
        botonGuardar.titleLabel!.textColor = UIColor(rgba: "#ffffff")
        botonGuardar.titleLabel!.numberOfLines = 0
        botonGuardar.titleLabel!.textAlignment = .right
        
        
        botonGuardar.sizeToFit()
        
        botonGuardar.frame = CGRect(x: 0, y: comentarioVista.frame.height - 30, width: comentarioVista.frame.width, height: 30)
        
        botonGuardar.setImage(UIImage(named:"BotonGuardarLargo"), for: .normal)
        botonGuardar.imageView?.contentMode = .scaleAspectFill
        
        botonGuardar.contentHorizontalAlignment = .center
        botonGuardar.contentVerticalAlignment = .center
        
        //comentarioVista.addSubview(botonGuardar)
        self.view.addSubview(comentarioVista)
        
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [],animations: {
            
            comentarioVista.frame.origin.y = self.barraTitulo.frame.origin.y + self.barraTitulo.frame.height
            // self.username.center.x += self.view.bounds.width
            sender.setImage(UIImage(named:"BotonComentarRojo"), for: .normal)
            }, completion: nil)
        
    }
    
    
    func acomodar_preguntas(){
        
        print("vamos acomodar las preguntas")
        
        let subvistas = laVista.subviews
        
        for subvista in subvistas {
            
            subvista.removeFromSuperview()
            
        }
        
        var offsetScrollNuevo:CGFloat = 0
        
        for seccion in secciones {
            
            print(seccion)
            
            let auxBarra = seccion["barra"] as! UIScrollView
            
            auxBarra.frame.origin.y = offsetScrollNuevo
            
            var barraEstatus = true
            
            for (auxIndicePregunta,pregunta) in preguntas.enumerated() where pregunta["seccion"] as! String == seccion["seccion"] as! String {
                
                let auxPregunta = pregunta["boton"] as! UIButton
                
                auxPregunta.isHidden = true
                
                if let _ = pregunta["parent"] as? Int  {
                    
                    
                    
                    for preguntaParent in preguntas where preguntaParent["id"] as! Int == pregunta["parent"] as! Int {
                        
                        print("la pregunta papa trae")
                        print(preguntaParent)
                        
                        if let respuestaActual = preguntaParent["respuesta"] as? String {
                            
                            switch pregunta["operator_dependency"] as! String {
                                
                            case "=":
                                
                                if respuestaActual.lowercased() == (pregunta["value_dependency"] as! String).lowercased() {
                                    
                                    auxPregunta.isHidden = false
                                }
                                
                            case "CONTAINS":
                                
                                let valoresDependencia = (pregunta["value_dependency"] as! String).lowercased()
                                
                                print("valor de dependencia \(valoresDependencia)")
                                print("respuesta actual \(respuestaActual.lowercased())")
                                
                                if valoresDependencia.contains("@") {
                                    
                                    let arregloValoresDependencia = valoresDependencia.components(separatedBy: "@@")
                                    
                                    for auxValor in arregloValoresDependencia {
                                        
                                        let auxValorL = auxValor.replacingOccurrences(of: "@", with: "")
                                        
                                        let auxRespuestaActual = respuestaActual.lowercased()
                                        
                                        if auxRespuestaActual.contains(auxValorL.lowercased()) {
                                            
                                            auxPregunta.isHidden = false
                                            
                                            break
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }
                                else
                                {
                                    
                                    let auxRespuestaActual = respuestaActual.lowercased()
                                    
                                    if auxRespuestaActual.contains(valoresDependencia) {
                                        
                                        auxPregunta.isHidden = false
                                        
                                    }
                                    
                                }
                                
                                
                                
                            default:
                                break
                            }
                            
                        }
                        
                    }
                    // fin for de preguntaParent
                    
                    
                }
                else{
                    
                    auxPregunta.isHidden = false
                    
                    
                    
                    
                }
                
                
                if auxPregunta.isHidden {
                    
                    preguntas[auxIndicePregunta]["respuesta"] = "" as AnyObject?
                    
                    let idReporteLocal = defaults.object(forKey: "idReporteLocal") as! NSNumber
                    
                    let sqlPreguntaBorrar = "delete from EARespuesta where idPregunta = \(pregunta["id"] as! Int) and idReporteLocal = '\(idReporteLocal)'"
                    
                    let resultadoBorrar = db.execute_query(sqlPreguntaBorrar)
                    
                    print(sqlPreguntaBorrar)
                    print("resultado borrar pregunta")
                    print(resultadoBorrar)
                    
                    switch pregunta["type_question"] as! NSNumber {
                    case 5,8,7:
                        
                        
                        let auxTextoCampo = pregunta["textoCampo"] as! UIButton
                        
                        auxTextoCampo.setTitle("Agrega tu Respuesta", for: .normal)
                        
                    case 15:
                        
                        let aux_b_foto = pregunta["aux_b_foto"] as! UIButton
                        
                        aux_b_foto.removeFromSuperview()
                        
                    case 17:
                        
                        
                        
                        let auxBotonSwitch = pregunta["botonSwitch"] as! UISwitch
                        
                        auxBotonSwitch.isOn = false
                        
                    case 1:
                        
                        
                        let auxOpciones = pregunta["opciones"] as! [[String:AnyObject]]
                        
                        for var opcion in auxOpciones {
                            
                            let auxBoton = opcion["boton"] as! UIButton
                            
                            auxBoton.setImage(UIImage(named: "RadioButton"), for: .normal)
                            
                            opcion["seleccionado"] = false as AnyObject
                            
                        }
                        
                    case 3:
                        
                        
                        let auxOpciones = pregunta["opciones"] as! [[String:AnyObject]]
                        
                        for var opcion in auxOpciones {
                            
                            let auxBoton = opcion["boton"] as! UIButton
                            
                            auxBoton.setImage(UIImage(named: "checkButton"), for: .normal)
                            
                            opcion["seleccionado"] = false as AnyObject?
                            
                        }
                        
                    default:
                        break
                    }
                    
                    
                    
                }
                
                
                
                if auxPregunta.isHidden == false {
                    
                    if barraEstatus {
                        
                        laVista.addSubview(auxBarra)
                        
                        offsetScrollNuevo += auxBarra.frame.height + 40
                        
                        barraEstatus = false
                        
                    }
                    
                    
                    auxPregunta.frame.origin.y = offsetScrollNuevo
                    
                    
                    
                    switch pregunta["type_question"] as! NSNumber {
                    case 5,8,7:
                        
                        laVista.addSubview(auxPregunta)
                        
                        offsetScrollNuevo += auxPregunta.frame.height + 40
                        
                        let auxTextoCampo = pregunta["textoCampo"] as! UIButton
                        
                        auxTextoCampo.frame.origin.y = offsetScrollNuevo
                        
                        laVista.addSubview(auxTextoCampo)
                        
                        offsetScrollNuevo += auxTextoCampo.frame.height + 60
                    case 15:
                        
                        laVista.addSubview(auxPregunta)
                        
                        offsetScrollNuevo += auxPregunta.frame.height + 40
                        
                        let aux_b_foto = pregunta["aux_b_foto"] as! UIButton
                        
                        aux_b_foto.frame.origin.y = offsetScrollNuevo
                        
                        laVista.addSubview(aux_b_foto)
                        
                        offsetScrollNuevo += aux_b_foto.frame.height + 40
                        
                        let idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
                        
                        
                        if idReporteLocal != nil {
                            
                            
                            let idPoll = defaults.object(forKey: "idPoll") as! NSNumber
                            
                            let numeroEncuesta = defaults.object(forKey: "numeroEncuesta") as! NSNumber
                            
                            let sqlRespuesta = "select * from EARespuesta where idPregunta= '\(pregunta["id"]!)' and idReporteLocal='\(idReporteLocal!)' and idEncuesta = '\(idPoll)' and numeroEncuesta = '\(numeroEncuesta)'"
                            
                            let resultadoChecarRespuesta = db.select_query_columns(sqlRespuesta)
                            
                            if resultadoChecarRespuesta.count > 0 {
                                
                                aux_b_foto.setImage(UIImage(named: "CamaraActiva"), for: .normal)
                                
                            }
                            
                            
                        }
                        
                        
                        
                    case 17:
                        
                        laVista.addSubview(auxPregunta)
                        
                        let auxBotonSwitch = pregunta["botonSwitch"] as! UISwitch
                        
                        auxBotonSwitch.frame.origin.y = offsetScrollNuevo + 10
                        
                        laVista.addSubview(auxBotonSwitch)
                        
                        offsetScrollNuevo += auxBotonSwitch.frame.height + 60
                        
                        
                        
                        
                        var respuesta = "no"
                        
                        if auxBotonSwitch.isOn {
                            
                            respuesta = "si"
                            
                        }
                        
                        let idReporteLocal = defaults.object(forKey: "idReporteLocal") as! NSNumber
                        
                        let idPoll = defaults.object(forKey: "idPoll") as! NSNumber
                        
                        let numeroEncuesta = defaults.object(forKey: "numeroEncuesta") as! NSNumber
                        
                        
                        
                        let random = Int(arc4random_uniform(1000))
                        
                        let tiempo_milisegundos = String(Int64(NSDate().timeIntervalSince1970*1000))
                        
                        let el_hash=String(tiempo_milisegundos) + String(describing: defaults.object(forKey: "idReporteLocal")!) + String(random)
                        
                        let hash = el_hash.md5()
                        
                        
                        let sqlRespuesta = "select * from EARespuesta where idPregunta= '\(pregunta["id"]!)' and idReporteLocal='\(idReporteLocal)' and idEncuesta = '\(idPoll)' and numeroEncuesta = '\(numeroEncuesta)'"
                        
                        let resultadoRespuesta = db.select_query_columns(sqlRespuesta)
                        
                        var sqlSwitch = ""
                        
                        if resultadoRespuesta.count < 1 {
                            
                            sqlSwitch = "insert into EARespuesta (hash,idPregunta,idReporteLocal,idEncuesta,numeroEncuesta,respuesta,campoExtra1,campoExtra2) values ('\(hash)','\(pregunta["id"]!)','\(idReporteLocal)','\(idPoll)','\(numeroEncuesta)','\(respuesta.replacingOccurrences(of: "'", with: "''"))','','')"
                            
                        }
                        else{
                            
                            sqlSwitch = "update EARespuesta set respuesta = '\(respuesta.replacingOccurrences(of: "'", with: "''"))' where idPregunta= '\(pregunta["id"]!)' and idReporteLocal='\(idReporteLocal)'"
                            
                        }
                        
                        _ = db.execute_query(sqlSwitch)
                        
                        
                        
                    case 1,3:
                        
                        laVista.addSubview(auxPregunta)
                        
                        offsetScrollNuevo += auxPregunta.frame.height + 40
                        
                        let auxOpciones = pregunta["opciones"] as! [[String:AnyObject]]
                        
                        for opcion in auxOpciones {
                            
                            let auxBoton = opcion["boton"] as! UIButton
                            
                            auxBoton.frame.origin.y = offsetScrollNuevo + 40
                            
                            laVista.addSubview(auxBoton)
                            
                            offsetScrollNuevo += auxBoton.frame.height + 60
                            
                        }
                        
                    default:
                        break
                    }
                    
                }
                
                
            }
            
            
        }
        
        
        laVista.contentSize = CGSize(width: laVista.contentSize.width, height: offsetScrollNuevo)
        
        
    }
    
    
    
    @objc func mostrarOpciones(sender:UIButton) {
        
        defaults.set(sender.tag, forKey: "indicePregunta")
        
        let pregunta = preguntas[sender.tag]
        
        let opcionesVista:UIScrollView = UIScrollView()
        
        
        opcionesVista.backgroundColor = UIColor(rgba: "#c70752")
        
        opcionesVista.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height/2)
        
        let textoSubTituloOpciones:UIButton = UIButton()
        
        textoSubTituloOpciones.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        textoSubTituloOpciones.titleLabel!.font = textoSubTituloOpciones.titleLabel!.font.withSize(CGFloat(12))
        
        
        
        textoSubTituloOpciones.setAttributedTitle(nil, for: UIControlState())
        textoSubTituloOpciones.setTitle("SELECCIONA UNA RESPUESTA", for: UIControlState())
        textoSubTituloOpciones.tag = 0
        
        textoSubTituloOpciones.isSelected = false
        textoSubTituloOpciones.setTitleColor(UIColor(rgba: "#ffffff"), for: UIControlState())
        
        
        
        textoSubTituloOpciones.titleLabel!.textColor = UIColor(rgba: "#ffffff")
        textoSubTituloOpciones.titleLabel!.numberOfLines = 0
        textoSubTituloOpciones.titleLabel!.textAlignment = .right
        
        
        textoSubTituloOpciones.sizeToFit()
        
        textoSubTituloOpciones.frame = CGRect(x: 0, y: 0, width: opcionesVista.frame.width - opcionesVista.frame.width/20, height: 30)
        
        
        
        textoSubTituloOpciones.contentHorizontalAlignment = .right
        textoSubTituloOpciones.contentVerticalAlignment = .center
        
        
        
        
        
        var offsetScroll:CGFloat = textoSubTituloOpciones.frame.height + 20
        
        let tamano_letra_menu:CGFloat = 20
        
        let alto_menu:CGFloat = self.view.frame.height/8
        
        
        let offsetx:CGFloat = 5
        
        //print(pregunta["opciones"])
        
        for opcion in pregunta["opciones"] as! [[String:AnyObject]] {
            
            print(opcion)
            
            let botonOpcion:UIButton = UIButton()
            
            botonOpcion.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
            
            botonOpcion.titleLabel!.font = botonOpcion.titleLabel!.font.withSize(CGFloat(tamano_letra_menu))
            
            
            
            
            botonOpcion.setAttributedTitle(nil, for: UIControlState())
            botonOpcion.setTitle(opcion["opcion"] as? String, for: UIControlState())
            botonOpcion.tag = Int(opcion["valor"] as! String)!
            
            botonOpcion.isSelected = false
            botonOpcion.setTitleColor(UIColor(rgba: "#FFFFFF"), for: UIControlState())
            
            
            
            botonOpcion.titleLabel!.textColor = UIColor(rgba: "#FFFFFF")
            botonOpcion.titleLabel!.numberOfLines = 0
            botonOpcion.titleLabel!.textAlignment = .left
            
            let idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
            
            print(idReporteLocal as Any)
            
            if idReporteLocal != nil {
                
                let numeroEncuesta = defaults.object(forKey: "numeroEncuesta") as! NSNumber
                
                let idPoll = defaults.object(forKey: "idPoll") as! NSNumber
                
                let checarRespuesta = "select * from EARespuesta where idPregunta = '\(pregunta["id"]!)' and idReporteLocal = '\(idReporteLocal!)' and idEncuesta = '\(idPoll)' and numeroEncuesta = '\(numeroEncuesta)' and respuesta = '\(botonOpcion.tag)'"
                
                print(checarRespuesta)
                
                let resultadoChecarRespuesta = db.select_query_columns(checarRespuesta)
                
                if resultadoChecarRespuesta.count > 0 {
                    
                    botonOpcion.backgroundColor = UIColor(rgba: "#94003a")
                    
                }
                
            }
            
            
            botonOpcion.sizeToFit()
            
            
            
            print(botonOpcion.titleLabel!.text!.characters.count)
            
            var lineas = Int(botonOpcion.titleLabel!.text!.characters.count/43)
            
            if lineas == 0 {
                
                lineas += 1
                
            }
            
            botonOpcion.frame = CGRect(x: offsetx, y: offsetScroll, width: self.view.frame.width - offsetx, height: alto_menu * CGFloat(lineas))
            
            botonOpcion.titleLabel!.adjustFontSizeToFitRect(rect: botonOpcion.frame, maximo: tamano_letra_menu)
            
            botonOpcion.contentHorizontalAlignment = .left
            botonOpcion.contentVerticalAlignment = .center
            
            
            //botonListaEncuestas(UIImage(named: "MenuHome"), forState: .Normal)
            
            botonOpcion.addTarget(self, action:#selector(EncuestaController.seleccionar_opcion(sender:)), for:.touchDown)
            
            opcionesVista.addSubview(botonOpcion)
            
            offsetScroll += botonOpcion.frame.height + 10
            
        }
        
        opcionesVista.contentSize = CGSize(width: opcionesVista.contentSize.width, height: offsetScroll)
        
        
        self.view.addSubview(opcionesVista)
        
        sender.setImage(UIImage(named:"BotonResponderRojo"), for: .normal)
        
        laVista.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [],animations: {
            
            opcionesVista.frame.origin.y = self.view.frame.height/2
            // self.username.center.x += self.view.bounds.width
        }, completion: nil)
        
        
    }
    
    
    // MARK: - Delegados
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        var idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
        
        print(idReporteLocal as Any)
        
        if idReporteLocal == nil {
            
            print("vamos por uno nuevo")
            
            
            
            idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
            
        }
        
        
        
        
        
        
        let random = Int(arc4random_uniform(1000))
        
        let tiempo_milisegundos = String(Int64(NSDate().timeIntervalSince1970*1000))
        
        let el_hash=String(tiempo_milisegundos) + String(describing: defaults.object(forKey: "idReporteLocal")!) + String(random)
        
        let hash = el_hash.md5()
        
        
        
        let pregunta = preguntas[textField.tag]
        
        let idPoll = defaults.object(forKey: "idPoll") as! NSNumber
        
        let numeroEncuesta = defaults.object(forKey: "numeroEncuesta") as! NSNumber
        
        
        
        
        let checarRespuesta = "select * from EARespuesta where idPregunta = '\(pregunta["id"]!)' and idReporteLocal = '\(idReporteLocal!)' and idEncuesta = '\(idPoll)' and numeroEncuesta = '\(numeroEncuesta)'"
        
        print(checarRespuesta)
        
        let resultadoChecarRespuesta = db.select_query_columns(checarRespuesta)
        
        if resultadoChecarRespuesta.count < 1 {
            
            var sqlRespuesta = ""
            
            
            
            
            
            sqlRespuesta = "insert into EARespuesta (hash,idPregunta,idReporteLocal,idEncuesta,numeroEncuesta,respuesta,campoExtra1,campoExtra2) values ('\(hash)','\(pregunta["id"]!)','\(idReporteLocal!)','\(idPoll)','\(numeroEncuesta)','\(textField.text!.replacingOccurrences(of: "'", with: "''"))','','')"
            
            (pregunta["textoCampo"] as! UIButton).setTitle(textField.text!, for: .normal)
            
            
            
            print(sqlRespuesta)
            
            let resultadoRespuesta = db.execute_query(sqlRespuesta)
            
            print(resultadoRespuesta)
            
        }
        else{
            
            var sqlRespuesta = ""
            
            
            
            
            
            
            sqlRespuesta = "update EARespuesta set respuesta = '\(textField.text!)' where idPregunta = '\(pregunta["id"]!)' and idReporteLocal = '\(idReporteLocal!)' and idEncuesta = '\(idPoll)' and numeroEncuesta = '\(numeroEncuesta)'"
            
            (pregunta["textoCampo"] as! UIButton).setTitle(textField.text!, for: .normal)
            
            
            print(sqlRespuesta)
            
            let resultadoRespuesta = db.execute_query(sqlRespuesta)
            
            print(resultadoRespuesta)
            
        }
        
        
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [],animations: {
            
            textField.superview!.frame.origin.y = self.view.frame.height
            // self.username.center.x += self.view.bounds.width
            }, completion: {finished in
                
                textField.superview?.removeFromSuperview()
                // the code you put here will be executed when your animation finishes, therefore
                // call your function here
        } )
        
        laVista.isUserInteractionEnabled = true
        
        
        
        
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        var idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
        
        print(idReporteLocal as Any)
        
        if idReporteLocal == nil {
            
            print("vamos por uno nuevo")
            
            
            
            idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
            
        }
        
        
        
        
        
        
        let random = Int(arc4random_uniform(1000))
        
        let tiempo_milisegundos = String(Int64(NSDate().timeIntervalSince1970*1000))
        
        let el_hash=String(tiempo_milisegundos) + String(describing: defaults.object(forKey: "idReporteLocal")!) + String(random)
        
        let hash = el_hash.md5()
        
        
        
        let pregunta = preguntas[textField.tag]
        
        let idPoll = defaults.object(forKey: "idPoll") as! NSNumber
        
        let numeroEncuesta = defaults.object(forKey: "numeroEncuesta") as! NSNumber
        
        
        
        
        let checarRespuesta = "select * from EARespuesta where idPregunta = '\(pregunta["id"]!)' and idReporteLocal = '\(idReporteLocal!)' and idEncuesta = '\(idPoll)' and numeroEncuesta = '\(numeroEncuesta)'"
        
        print(checarRespuesta)
        
        let resultadoChecarRespuesta = db.select_query_columns(checarRespuesta)
        
        if resultadoChecarRespuesta.count < 1 {
            
            var sqlRespuesta = ""
            
            
            
            
                
                sqlRespuesta = "insert into EARespuesta (hash,idPregunta,idReporteLocal,idEncuesta,numeroEncuesta,respuesta,campoExtra1,campoExtra2) values ('\(hash)','\(pregunta["id"]!)','\(idReporteLocal!)','\(idPoll)','\(numeroEncuesta)','\(textField.text!.replacingOccurrences(of: "'", with: "''"))','','')"
                
                (pregunta["textoCampo"] as! UIButton).setTitle(textField.text!, for: .normal)
                
            
            
            print(sqlRespuesta)
            
            let resultadoRespuesta = db.execute_query(sqlRespuesta)
            
            print(resultadoRespuesta)
            
        }
        else{
            
            var sqlRespuesta = ""
            
            
            
            
                
                
                sqlRespuesta = "update EARespuesta set respuesta = '\(textField.text!)' where idPregunta = '\(pregunta["id"]!)' and idReporteLocal = '\(idReporteLocal!)' and idEncuesta = '\(idPoll)' and numeroEncuesta = '\(numeroEncuesta)'"
                
                (pregunta["textoCampo"] as! UIButton).setTitle(textField.text!, for: .normal)
            
            
            print(sqlRespuesta)
            
            let resultadoRespuesta = db.execute_query(sqlRespuesta)
            
            print(resultadoRespuesta)
            
        }
        
        
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [],animations: {
            
            textField.superview!.frame.origin.y = self.view.frame.height
            // self.username.center.x += self.view.bounds.width
            }, completion: {finished in
                
                textField.superview?.removeFromSuperview()
                // the code you put here will be executed when your animation finishes, therefore
                // call your function here
        } )
        
        laVista.isUserInteractionEnabled = true
        textField.endEditing(true)
        
        return true
    }
    
   func imagePickerControllerDidCancel(_ picker:UIImagePickerController)
    {
        //imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        print("si cancelo")
        
        imagePicker.view.removeFromSuperview()
        imagePicker.removeFromParentViewController()
        
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        print("si tomo la foto")
        
        if(picker.sourceType == UIImagePickerControllerSourceType.camera)
        {
            
            let aux_foto: UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
            
            let tiempo_milisegundos = String(Int64(NSDate().timeIntervalSince1970*1000))
            
            let random = Int(arc4random_uniform(1000))
            
            let el_hash=tiempo_milisegundos + String(random)
            
            let hash = el_hash.md5()
            
            //Donde vamos a guardar la foto
            let nombre_foto = "\(hash).jpg"
            let foto_ruta_absoluta = ruta_absoluta(nombre_foto)
            
            
            
            let respuesta_guardar = guardar_foto(imagen: aux_foto, ruta: foto_ruta_absoluta)
            
            //print("se guarda la imagen? \(respuesta_guardar)")
            
            
            if respuesta_guardar {
                
                let aux_b_foto = preguntas[foto_tag]["aux_b_foto"] as! UIButton
                
                aux_b_foto.setImage(UIImage(named: "CamaraActiva"), for: .normal)
                
                
                let idReporteLocal = defaults.object(forKey: "idReporteLocal") as? NSNumber
                
                let random = Int(arc4random_uniform(1000))
                
                let tiempo_milisegundos = String(Int64(NSDate().timeIntervalSince1970*1000))
                
                let el_hash=String(tiempo_milisegundos) + String(describing: defaults.object(forKey: "idReporteLocal")!) + String(random)
                
                let hash = el_hash.md5()
                
                let respuesta = foto_ruta_absoluta
                    
                
                let idPoll = defaults.object(forKey: "idPoll") as! NSNumber
                
                let numeroEncuesta = defaults.object(forKey: "numeroEncuesta") as! NSNumber
                
                
                
                let sqlRespuesta = "delete from EARespuesta where idPregunta= '\(preguntas[foto_tag]["id"]!)' and idReporteLocal='\(idReporteLocal!)' and idEncuesta = '\(idPoll)' and numeroEncuesta = '\(numeroEncuesta)'"
                
                _ = db.select_query_columns(sqlRespuesta)
                
                var sqlSwitch = ""
                
                
                    
                    sqlSwitch = "insert into EARespuesta (hash,idPregunta,idReporteLocal,idEncuesta,numeroEncuesta,respuesta,campoExtra1,campoExtra2) values ('\(hash)','\(preguntas[foto_tag]["id"]!)','\(idReporteLocal!)','\(idPoll)','\(numeroEncuesta)','\(respuesta.replacingOccurrences(of: "'", with: "''"))','','')"
                
                
                //print(sql)
                
                let _ = db.execute_query(sqlSwitch)
                
                //print(resultado_foto)
                
                DispatchQueue.main.async {
                    
                    
                    
                    // Create the alert controller
                    let alertController = UIAlertController(title: "¡Alerta!", message: "Foto Guardada", preferredStyle: .alert)
                    
                    // Create the actions
                    
                    
                    
                    let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        NSLog("click ok")
                        
                        self.imagePicker.view.removeFromSuperview()
                        self.imagePicker.removeFromParentViewController()
                       // SwiftSpinner.hide()
                        
                    }
                    
                    
                    // Add the actions
                    alertController.addAction(okAction)
                    
                    
                    
                    // Present the controller
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                    
                }
                
                
                
            }
            
            
            
            
            
        }
        
    }
    
    
    
    // MARK: - Funciones de guardar archivos
    
    func guardar_foto (imagen: UIImage, ruta: String ) -> Bool{
        
        let rutaUrl = URL(fileURLWithPath: ruta)
        
        let imagen2 = imagen.resizeToWidth(800.0)
        
        //let pngImageData = UIImagePNGRepresentation(image)
        let imagen_chicha = UIImageJPEGRepresentation(imagen2, 1.0)   // if you want to save as JPEG
        //let result = pngImageData!.writeToFile(path, atomically: true)
        
        do {
            try imagen_chicha?.write(to: rutaUrl, options: .atomic)
        } catch {
            return false
        }
        
        return true
        
    }
    
    
    
    
    
    //fin tomar foto
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

