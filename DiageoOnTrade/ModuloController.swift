//
//  ModuloController.swift
//  DiageoOnTrade
//
//  Created by Daniel Cedeño García on 10/9/17.
//  Copyright © 2017 Go Sharp. All rights reserved.
//

import Foundation
import AssetsLibrary
import NVActivityIndicatorView


class ModuloController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    //variables
    
    var el_sync:Sincronizador = Sincronizador()
    
    var el_constructor:Constructor = Constructor()
    
    let defaults = UserDefaults.standard
    
    var db:DB_Manager = DB_Manager()
    
    var laVista: UIScrollView! = UIScrollView()
    var menuButton: UIButton! = UIButton()
    
    //var offset = 21
    
    var aux_posicion=UIButton()
    
    var tipo = ""
    
    var elementos:[String:AnyObject] = [:]
    
    var elementos_lista:[[String:AnyObject]]=[]
    
    var elementos_lista_grupos:[[String:AnyObject]]=[]
    
    var indice = 0
    
    var grupos = 0
    
    //var aux_elemento:AnyObject?
    
    var offset_lista = 0
    
    //var estructura_y = 0
    
    var idReporteLocal = 0
    
    var imagePicker: UIImagePickerController!
    
    var foto_tag = 0
    
    var renglones = 0
    
    var select_menu:UIScrollView!
    
    var subestructura:UIScrollView!
    
    var barraSubTitulo:UIScrollView = UIScrollView()
    
    var color_letra = "c70752"
    
    var fontFamilia = "Dosis-Regular"
    
    var textoSubTitulo:UIButton = UIButton()
    
    var indice_cabecera_original = 0
    
    var vistaCargador:UIScrollView = UIScrollView()
    
    var colorTexto:String = ""
    
    
    //fin variables
    
    //estructura
    
    var aux_string = "[{\"id_elemento\": \"1\",\"tipo\": \"CABECERA\",\"query\": \"select * FROM md_item INNER JOIN md_distribution ON md_item.idMeasurement = md_distribution.id LEFT JOIN report_distribution ON report_distribution.id_item = md_item.idItemRelation GROUP BY md_item.idItemRelation order by md_item.order_by asc\",\"color_renglon\": \"FFFFFF\",\"color_texto0\": \"000000\",\"color_texto1\": \"000000\",\"columna_filtro1\": \"filter1\",\"columna_filtro2\": \"filter2\",\"columna_filtro3\": \"filter3\"}, {\"id_elemento\": \"12\",\"tipo\": \"FILTRO\",\"opciones\": [{\"columna_filtro\": \"filter1\",\"texto\": \"Fabricante\",\"query\": \"select DISTINCT(filter1) FROM md_item INNER JOIN md_distribution ON md_item.idMeasurement = md_distribution.id LEFT JOIN report_distribution ON report_distribution.id_item = md_item.idItemRelation GROUP BY md_item.idItemRelation\"}, {\"columna_filtro\": \"filter2\",\"texto\": \"Categoria\",\"query\": \"select DISTINCT(filter2) FROM md_item INNER JOIN md_distribution ON md_item.idMeasurement = md_distribution.id LEFT JOIN report_distribution ON report_distribution.id_item = md_item.idItemRelation GROUP BY md_item.idItemRelation\"}, {\"columna_filtro\": \"filter3\",\"texto\": \"Clasificación\",\"query\": \"select DISTINCT(filter3) FROM md_item INNER JOIN md_distribution ON md_item.idMeasurement = md_distribution.id LEFT JOIN report_distribution ON report_distribution.id_item = md_item.idItemRelation GROUP BY md_item.idItemRelation\"}]}, {\"id_elemento\": \"2\",\"tipo\": \"LABEL\",\"texto\": \"Esta es la label\",\"cuadro\": \"1\",\"ancho\": \"3\",\"linea\": \"2.5\",\"tamano\": \"20\",\"columna\": \"value\"}, {\"id_elemento\": \"3\",\"tipo\": \"FOTO\",\"cuadro\": \"7\",\"ancho\": \"1\",\"linea\": \"0\",\"columna\": \"idItemRelation\",\"tabla\": \"report_photo_distribution\",\"total\": \"4\",\"id_padre_fk\": \"id_report_distribution\",\"tabla_padre\": \"report_distribution\",\"id_padre\": \"id_item\"}, {\"id_elemento\": \"4\",\"tipo\": \"SELECT_ONE_RADIO\",\"texto\": \"Distribucion\",\"cuadro\": \"1\",\"ancho\": \"1\",\"linea\": \"1\",\"opcion_hijo\": \"1\",\"elementos_hijos\": [{\"id_elemento\": \"3\"}, {\"id_elemento\": \"5\"}, {\"id_elemento\": \"6\"}],\"columna\": \"idItemRelation\",\"opciones\": [{\"texto\": \"Si\",\"cuadro\": \"2\",\"ancho\": \"1\",\"grupo\": \"1\",\"linea\": \"0\",\"valor\": \"1\"}, {\"texto\": \"No\",\"cuadro\": \"4\",\"ancho\": \"1\",\"grupo\": \"1\",\"linea\": \"2\",\"valor\": \"2\"}]}, {\"id_elemento\": \"5\",\"tipo\": \"REAL\",\"texto\": \"Precio Botella\",\"cuadro\": \"5\",\"ancho\": \"1\",\"linea\": \"-2\",\"columna\": \"idItemRelation\",\"valor\": \"bootle_price\",\"tabla\": \"report_distribution\"}, {\"id_elemento\": \"6\",\"tipo\": \"REAL\",\"texto\": \"Precio Copa\",\"cuadro\": \"1\",\"ancho\": \"1\",\"linea\": \"3\",\"columna\": \"idItemRelation\",\"valor\": \"cup_price\",\"tabla\": \"report_distribution\"}]"
    
    
    
    var estructura:JSON!
    
    
    
    //fin estructura
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        el_constructor.cuadros.removeAll()
        
        
        let tamano_cuadro = Int(self.view.frame.width/9)
        
        el_constructor.cuadros.append(0)
        el_constructor.cuadros.append(0)
        el_constructor.cuadros.append(tamano_cuadro)
        el_constructor.cuadros.append(tamano_cuadro*2)
        el_constructor.cuadros.append(tamano_cuadro*3)
        el_constructor.cuadros.append(tamano_cuadro*4)
        el_constructor.cuadros.append(tamano_cuadro*5)
        el_constructor.cuadros.append(tamano_cuadro*6)
        el_constructor.cuadros.append(tamano_cuadro*7)
        
        estructura = JSON(cadena: aux_string)
        
        idReporteLocal = defaults.object(forKey: "idReporteLocal") as! Int
        
        /*let dataFromString = aux_string.data(using: String.Encoding.utf8, allowLossyConversion: false)
         estructura = JSON(cadena: dataFromString!)
         */
        //print(aux_string)
        
        
        //print(estructura)
        
        
        if self.revealViewController() != nil {
            
            //menuButton.targetForAction("revealToggle:", withSender: self)
            //menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchDown)
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        //actualizar texto cargador
        
        
        
        let controladorActual = UIApplication.topViewController()
        
        DispatchQueue.main.async {
            
            self.mostrarCargador()
            
            let subvistas = controladorActual?.view!.subviews
            
            for subvista in subvistas! where subvista.tag == 179 {
                
                let subvistasCargador = subvista.subviews
                
                for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                    
                    (subvistaCargador as! UIButton).setTitle("Cargando...", for: .normal)
                    
                }
                
                let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.ocultarCargador(sender:)))
                singleTap.cancelsTouchesInView = false
                singleTap.numberOfTapsRequired = 1
                subvista.addGestureRecognizer(singleTap)
                
                
            }
            
        }
        
        //fin actualizar texto cargador
        
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
    
    
    @objc func ocultarCargador(sender:UITapGestureRecognizer){
        
        DispatchQueue.main.async {
            
            sender.view!.removeFromSuperview()
            
        }
        
    }
    
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
        textoSubTitulo.setTitle("Distribución y Precios", for: UIControlState())
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
        
        botoRegresar.addTarget(self, action: #selector(ModuloController.regresar(sender:)), for: .touchDown)
        
        
        
        
        self.view.addSubview(barraTitulo)
        
        self.view.addSubview(barraSubTitulo)
        
        //self.view.backgroundColor = UIColor(rgba: "#c70752")
        self.view.backgroundColor = UIColor(rgba: "#ffffff")
        
        
        
        //self.view.addSubview(botoMenu)
        self.view.addSubview(botoRegresar)
        
        
        laVista.frame = CGRect(x: 0, y: barraSubTitulo.frame.height + barraSubTitulo.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height - barraSubTitulo.frame.height - barraSubTitulo.frame.origin.y)
        
        
        
        self.view.addSubview(laVista)
        
        
        
        print("Estamos en Modulo")
        
        
        select_menu = UIScrollView()
        
        subestructura = UIScrollView()
        
        //print("el tipo es \(tipo)")
        
        
        
        tipo = defaults.object(forKey: "moduloTipo") as! String
        
        
        switch tipo {
        case "distribucion":
            
            
            
            let respuesta_estructura = self.crear_estructura(estructura: self.estructura,offset_y: 0,offset: 21)
            
            self.elementos = respuesta_estructura
            
            //elementos = respuesta_estructura["estructura"] as! [[String:AnyObject]]
            
            print(self.elementos)
            
            //estructura_y = respuesta_estructura["estructura_y"] as! Int
            
            _ =  self.llenar_estructura(aux_vista_scroll: self.laVista,elementos_estructura: self.elementos["estructura"] as! [[String:AnyObject]],estructura_y: self.elementos["estructura_y"] as! Int,indice_subestructura: -1)
            
            for elemento in self.elementos_lista where elemento["tipo"] as! String == "SELECT_ONE_RADIO" {
                
                //print("elementos radios")
                //print(elemento)
                
                self.buscar_hijos(elemento: elemento)
                
            }
            
            self.quitar_filtro()
            
            
            
        case "PRECIO":
            
            break
            
        default:
            break
        }
        
        
        if !animated {
            
            //SwiftSpinner.hide()
            
        }
        
        
        
        
    }
    
    @objc func regresar(sender:UIButton){
        
        
        let sql = "select * from  report_distribution where  idReporteLocal = '\(idReporteLocal)'"
        
        print(sql)
        
        let resultadoDistribucion = db.select_query_columns(sql)
        
        
        DispatchQueue.main.async {
            
            //_ = SwiftSpinner.show("Revisando...")
            
            
            //actualizar texto cargador
            
            
            
            let controladorActual = UIApplication.topViewController()
            
            DispatchQueue.main.async {
                
                self.mostrarCargador()
                
                let subvistas = controladorActual?.view!.subviews
                
                for subvista in subvistas! where subvista.tag == 179 {
                    
                    let subvistasCargador = subvista.subviews
                    
                    for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                        
                        (subvistaCargador as! UIButton).setTitle("Revisando...", for: .normal)
                        
                    }
                    
                    let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.ocultarCargador(sender:)))
                    singleTap.cancelsTouchesInView = false
                    singleTap.numberOfTapsRequired = 1
                    subvista.addGestureRecognizer(singleTap)
                    
                    
                }
                
            }
            
            //fin actualizar texto cargador
            
            
            sender.isUserInteractionEnabled = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                
                if resultadoDistribucion.count > 0 {
                    
                    self.quitar_filtro()
                    
                }
                else{
                    
                    self.defaults.set(0, forKey: "moduloDistribucion")
                    
                }
                
                //SwiftSpinner.hide()
                self.vistaCargador.removeFromSuperview()
                
                let auxModuloDistribucion = self.defaults.object(forKey: "moduloDistribucion") as! NSNumber
                
                if auxModuloDistribucion == 0 {
                    
                    
                    
                    // Create the alert controller
                    let alertController = UIAlertController(title: "¡¡Atención!!", message: "Tienes campos sin contestar, recuerda que debes de llenar los campos de precio de botella, copa y fotos", preferredStyle: .alert)
                    
                    // Create the actions
                    let aceptarAction = UIAlertAction(title: "Regresar", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        NSLog("click aceptar")
                        //self.confirmar_borrado(sender.tag)
                        
                        
                        self.performSegue(withIdentifier: "modulotomodulos", sender: self)
                        
                        
                    }
                    
                    
                    let cancelarAction = UIAlertAction(title: "Continuar", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        NSLog("click aceptar")
                        //self.confirmar_borrado(sender.tag)
                        
                        
                        
                        
                    }
                    
                    
                    
                    alertController.addAction(aceptarAction)
                    alertController.addAction(cancelarAction)
                    
                    
                    // Present the controller
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                    
                }
                else{
                    
                    
                    self.performSegue(withIdentifier: "modulotomodulos", sender: self)
                    
                }
                
                
            })
        }
        
        
        
        
        
        
    }
    
    
    func llenar_estructura(aux_vista_scroll:UIScrollView,elementos_estructura:[[String:AnyObject]],estructura_y:Int,indice_subestructura:Int)->[String:AnyObject]{
        
        offset_lista = 0
        
        renglones = 0
        
        let inicio = elementos_lista.count - 1
        
        DispatchQueue.main.async {
            
            let subViews = aux_vista_scroll.subviews
            for subview in subViews{
                subview.removeFromSuperview()
            }
            
        }
        
        var indice_cabecera = 0
        
        for renglon in elementos_estructura {
            
            if renglon["tipo"] as! String != "CABECERA" {
                
                indice_cabecera += 1
            }
            else{
                
                break
                
            }
            
        }
        
        let base = defaults.object(forKey: "base") as! String
        
        db.open_database(base)
        
        
        //let sql = "select t2.idItemRelation,t2.value,t2.idMeasurement,t1.description,t1.startDate,t1.endDate,t1.extra1 from ma_sku t2 left join ma_availability t1 where t1.id = t2.idMeasurement"
        
        let sql = elementos_estructura[indice_cabecera]["query"] as! String
        let color_renglon = elementos_estructura[indice_cabecera]["color_renglon"] as! String
        let color_texto0 = elementos_estructura[indice_cabecera]["color_texto0"] as! String
        let color_texto1 = elementos_estructura[indice_cabecera]["color_texto1"] as! String
        
        el_constructor.colorTexto = color_texto0
        colorTexto = color_texto0
        
        //print("el sql de lenar es")
        //print(sql)
        
        
        let lista = db.select_query_columns(sql)
        
        //print(lista)
        
        //offset = 21
        
        
        
        
        for renglon in lista {
            
            var aux_elementos_grupo = [Int]()
            
            var indice_grupo = 0
            
            for elemento_lista in elementos_estructura {
                
                
                
                switch elemento_lista["tipo"] as! String{
                case "CABECERA":
                    
                    if indice_subestructura == -1 {
                        
                        elementos_lista_grupos.append([String:AnyObject]())
                        
                        var auxFiltro = " "
                        
                        
                        
                        
                        indice_grupo = elementos_lista_grupos.count - 1
                        
                        if let columna_filtro1 = elementos_estructura[indice_cabecera]["columna_filtro1"] as? String {
                            
                            print(columna_filtro1)
                            
                            elementos_lista_grupos[elementos_lista_grupos.count - 1][columna_filtro1] = renglon[columna_filtro1]
                            
                            
                            
                            auxFiltro = renglon[columna_filtro1] as! String + " "
                            
                        }
                        
                        if let columna_filtro2 = elementos_estructura[indice_cabecera]["columna_filtro2"] as? String {
                            
                            
                            elementos_lista_grupos[elementos_lista_grupos.count - 1][columna_filtro2] = renglon[columna_filtro2]
                            
                            auxFiltro += renglon[columna_filtro2] as! String + " "
                            
                        }
                        
                        if let columna_filtro3 = elementos_estructura[indice_cabecera]["columna_filtro3"] as? String {
                            
                            
                            elementos_lista_grupos[elementos_lista_grupos.count - 1][columna_filtro3] = renglon[columna_filtro3]
                            
                            auxFiltro += renglon[columna_filtro3] as! String
                            
                        }
                        
                        elementos_lista_grupos[elementos_lista_grupos.count - 1]["filtro"] = auxFiltro as AnyObject
                        
                        elementos_lista_grupos[elementos_lista_grupos.count - 1]["categoria"] = renglon["categoria"]
                        elementos_lista_grupos[elementos_lista_grupos.count - 1]["origen"] = offset_lista as AnyObject
                        
                    }
                    
                case "LABEL":
                    
                    
                    
                    let aux_label = elemento_lista["elemento"] as! UILabel
                    
                    
                    if elemento_lista["columna"] != nil {
                        
                        aux_label.text = renglon[elemento_lista["columna"] as! String] as? String
                        
                    }
                    
                    
                    
                    self.crear_acomodar_elemento(VistaScroll: aux_vista_scroll, offset_lista: self.offset_lista, tipo: elemento_lista["tipo"] as! String, elemento: aux_label, indice: self.elementos_lista.count,id:0,estructura_y: estructura_y)
                    
                    
                    
                    //self.elementos_lista.append(respuesta_nuevo_elemento["elemento"] as! [String:AnyObject])
                    
                    self.elementos_lista[self.elementos_lista.count - 1]["indice_grupo"] = indice_grupo as AnyObject?
                    self.elementos_lista[self.elementos_lista.count - 1]["indice"] = self.elementos_lista.count as AnyObject?
                    
                    
                    
                    
                    
                    if indice_subestructura == -1 {
                        
                        aux_elementos_grupo.append(elementos_lista.count - 1)
                        
                    }
                    
                    //offset_lista = respuesta_nuevo_elemento["offset_lista"] as! Int
                    
                case "SELECT_ONE_RADIO":
                    
                    let aux_radio = elemento_lista
                    
                    let id = renglon[elemento_lista["columna"] as! String] as! NSNumber
                    
                    
                    
                    self.crear_acomodar_elemento(VistaScroll: aux_vista_scroll, offset_lista: self.offset_lista, tipo: "SELECT_ONE_RADIO", elemento: aux_radio as AnyObject, indice: self.elementos_lista.count,id:id,estructura_y: estructura_y)
                    
                    let respuesta_nuevo_elemento = elementos_lista[elementos_lista.count - 1]
                    
                    print(respuesta_nuevo_elemento)
                    
                    for boton in respuesta_nuevo_elemento["botones"] as! [[String:AnyObject]] {
                        
                        let aux_boton = boton["elemento"] as! UIButton
                        
                        aux_boton.addTarget(self, action:#selector(ModuloController.b_radio_opcion(sender:)), for:.touchDown)
                        
                    }
                    
                    //self.elementos_lista.append(respuesta_nuevo_elemento["elemento"] as! [String:AnyObject])
                    
                    //print(elementos_lista[elementos_lista.count - 1])
                    
                    self.elementos_lista[self.elementos_lista.count - 1]["indice_grupo"] = indice_grupo as AnyObject?
                    self.elementos_lista[self.elementos_lista.count - 1]["indice"] = self.elementos_lista.count as AnyObject?
                    
                    
                    
                    if indice_subestructura == -1 {
                        
                        aux_elementos_grupo.append(elementos_lista.count - 1)
                        
                    }
                    //print(elementos_lista[elementos_lista.count-1])
                    
                case "REAL", "NUMERIC":
                    let aux_elemento = elemento_lista
                    
                    let id = renglon[elemento_lista["columna"] as! String] as! NSNumber
                    
                    
                    
                    self.crear_acomodar_elemento(VistaScroll: aux_vista_scroll, offset_lista: self.offset_lista, tipo: elemento_lista["tipo"] as! String, elemento: aux_elemento as AnyObject, indice: self.elementos_lista.count,id:id,estructura_y: estructura_y)
                    
                    
                    
                    //print(respuesta_nuevo_elemento)
                    
                    //self.elementos_lista.append(respuesta_nuevo_elemento["elemento"] as! [String:AnyObject])
                    
                    self.elementos_lista[self.elementos_lista.count - 1]["indice_grupo"] = indice_grupo as AnyObject?
                    self.elementos_lista[self.elementos_lista.count - 1]["indice"] = self.elementos_lista.count as AnyObject?
                    
                    
                    
                    let aux_campo = self.elementos_lista[self.elementos_lista.count - 1]["elemento"] as! UITextField
                    
                    aux_campo.delegate = self
                    
                    aux_campo.addTarget(self, action: #selector(ModuloController.checar_sies_numero(sender:)), for:  UIControlEvents.editingChanged)
                    
                    aux_campo.addTarget(self, action: #selector(ModuloController.limpiar_cero(sender:)), for:  UIControlEvents.editingDidBegin)
                    
                    if indice_subestructura == -1 {
                        
                        aux_elementos_grupo.append(self.elementos_lista.count - 1)
                        
                    }
                    
                    
                case "FOTO":
                    
                    let aux_elemento = elemento_lista
                    
                    //print(aux_elemento)
                    
                    let id = renglon[elemento_lista["columna"] as! String] as! NSNumber
                    
                    
                    
                    let filter2 = elementos_lista_grupos[indice_grupo]["filter2"] as! String
                    
                    
                    
                    self.crear_acomodar_elemento(VistaScroll: aux_vista_scroll, offset_lista: self.offset_lista, tipo: elemento_lista["tipo"] as! String, elemento: aux_elemento as AnyObject, indice: self.elementos_lista.count,id:id,estructura_y: estructura_y,categoria_foto:filter2)
                    
                    
                    
                    //self.elementos_lista.append(respuesta_nuevo_elemento["elemento"] as! [String:AnyObject])
                    
                    self.elementos_lista[self.elementos_lista.count - 1]["indice_grupo"] = indice_grupo as AnyObject?
                    self.elementos_lista[self.elementos_lista.count - 1]["indice"] = self.elementos_lista.count as AnyObject?
                    
                    
                    
                    if indice_subestructura == -1 {
                        
                        aux_elementos_grupo.append(self.elementos_lista.count - 1)
                        
                    }
                    
                    let aux_b_foto = self.elementos_lista[self.elementos_lista.count - 1]["elemento"] as! UIButton
                    
                    aux_b_foto.addTarget(self, action:#selector(ModuloController.tomar_foto(sender:)), for:.touchDown)
                    
                    
                    /*
                     case "SELECT_ONE_SPINNER":
                     
                     
                     let aux_elemento = elemento_lista
                     
                     let id = renglon[elemento_lista["id_padre"] as! String] as! NSNumber
                     
                     let respuesta_nuevo_elemento = el_constructor.crear_acomodar_elemento(VistaScroll: aux_vista_scroll, offset_lista: offset_lista, tipo: elemento_lista["tipo"] as! String, elemento: aux_elemento as AnyObject, indice: elementos_lista.count,id:id,estructura_y: estructura_y)
                     
                     elementos_lista.append(respuesta_nuevo_elemento["elemento"] as! [String:AnyObject])
                     
                     elementos_lista[elementos_lista.count - 1]["indice_grupo"] = indice_grupo as AnyObject?
                     
                     if indice_subestructura == -1 {
                     
                     aux_elementos_grupo.append(elementos_lista.count - 1)
                     
                     }
                     
                     let aux_b_select_menu = elementos_lista[elementos_lista.count - 1]["elemento"] as! UIButton
                     
                     aux_b_select_menu.addTarget(self, action:#selector(ModuloController.mostrar_select_menu(sender:)), for:.touchDown)
                     
                     if indice_subestructura != -1 {
                     
                     elementos_lista[elementos_lista.count - 1]["indice_subestructura"] = indice_subestructura as AnyObject?
                     
                     }
                     
                     case "SUBESTRUCTURA":
                     
                     let aux_elemento = elemento_lista
                     
                     //print(aux_elemento)
                     
                     let id = renglon[elemento_lista["id_padre"] as! String] as! NSNumber
                     
                     let respuesta_nuevo_elemento = el_constructor.crear_acomodar_elemento(VistaScroll: aux_vista_scroll, offset_lista: offset_lista, tipo: elemento_lista["tipo"] as! String, elemento: aux_elemento as AnyObject, indice: elementos_lista.count,id:id,estructura_y: estructura_y)
                     
                     elementos_lista.append(respuesta_nuevo_elemento["elemento"] as! [String:AnyObject])
                     
                     elementos_lista[elementos_lista.count - 1]["indice_grupo"] = indice_grupo as AnyObject?
                     
                     if indice_subestructura == -1 {
                     
                     aux_elementos_grupo.append(elementos_lista.count - 1)
                     
                     }
                     
                     let aux_boton = elementos_lista[elementos_lista.count - 1]["elemento"] as! UIButton
                     
                     aux_boton.addTarget(self, action:#selector(ModuloController.mostrar_subestructura(sender:)), for:.touchDown)
                     
                     let aux_boton_ojo = elementos_lista[elementos_lista.count - 1]["elemento_ojo"] as! UIButton
                     
                     aux_boton_ojo.isUserInteractionEnabled = false
                     
                     aux_boton_ojo.addTarget(self, action:#selector(ModuloController.mostrar_elementos_subestructura(sender:)), for:.touchDown)
                     
                     
                     
                     //traer sus elementos_nuevos
                     
                     let aux_estructura = elementos_lista[elementos_lista.count - 1]["estructura"] as! [[String:AnyObject]]
                     
                     
                     for aux_elemento in aux_estructura {
                     
                     
                     if let valor_final  = aux_elemento["valor_final"] as? String{
                     
                     
                     
                     if valor_final == "si" {
                     
                     var id_padre = 0
                     
                     //print(aux_elemento)
                     
                     var sql = "select id from \(aux_elemento["tabla_padre"] as! String) where \(aux_elemento["id_padre_reporte"] as! String) = '\(elementos_lista[elementos_lista.count - 1]["id"]!)' and id_report_local = '\(idReporteLocal)'"
                     
                     //print(sql)
                     
                     let resultado_distribution = db.select_query_columns(sql)
                     
                     
                     if resultado_distribution.count > 0 {
                     
                     for renglon in resultado_distribution {
                     
                     id_padre = renglon["id"] as! Int
                     
                     }
                     
                     }
                     
                     
                     sql = "select \(aux_elemento["columna"]!),\(aux_elemento["valor"]!) from \(aux_elemento["tabla"]!) where \(aux_elemento["columna"]!) in (select \(aux_elemento["columna_guardar"]!) from \(aux_elemento["tabla_guardar"]!) where id_reporte_local = '\(idReporteLocal)' and \(aux_elemento["columna_guardar_padre"]!) = '\(id_padre)')"
                     
                     
                     //print(sql)
                     
                     let resultado_nuevos_elementos = db.select_query_columns(sql)
                     
                     
                     if resultado_nuevos_elementos.count > 0 {
                     
                     var aux_nuevos_elememtos:[[String:AnyObject]]=[]
                     
                     for aux_nuevo_elemento in resultado_nuevos_elementos {
                     
                     aux_nuevos_elememtos.append([String:AnyObject]())
                     
                     //print(opcion)
                     
                     
                     aux_nuevos_elememtos[aux_nuevos_elememtos.count - 1]["id"] = aux_nuevo_elemento[aux_elemento["columna"] as! String]
                     aux_nuevos_elememtos[aux_nuevos_elememtos.count - 1]["opcion"] = aux_nuevo_elemento[aux_elemento["valor"] as! String]
                     
                     }
                     
                     elementos_lista[elementos_lista.count - 1]["elementos_nuevos"] = aux_nuevos_elememtos as AnyObject?
                     
                     let aux_ojo = elementos_lista[elementos_lista.count - 1]["elemento_ojo"] as! UIButton
                     
                     aux_ojo.isUserInteractionEnabled = true
                     
                     }
                     
                     }
                     
                     }
                     
                     }
                     
                     
                     
                     //fin traer sus elementos_nuevos
                     
                     
                     
                     */
                default:
                    print("tipo no manejado al llenar \(String(describing: elemento_lista["tipo"]))")
                }
                
                
            }
            
            
            if renglones % 2 == 0 {
                
                DispatchQueue.main.async {
                    
                    self.el_constructor.colorTexto = color_texto1
                    
                    let cuadro = dibujar_cuadro(CGSize(width: aux_vista_scroll.frame.width, height: CGFloat(estructura_y)),color:color_renglon)
                    
                    let aux_cuadro = UIImageView()
                    
                    
                    aux_cuadro.frame = CGRect(x: 0, y: CGFloat(self.offset_lista), width: aux_vista_scroll.frame.width, height: CGFloat(estructura_y))
                    
                    aux_cuadro.image = cuadro
                    
                    aux_vista_scroll.addSubview(aux_cuadro)
                    
                    aux_vista_scroll.sendSubview(toBack: aux_cuadro)
                    
                }
                
            }
            else{
                
                el_constructor.colorTexto = color_texto0
                
            }
            
            renglones += 1
            
            offset_lista += estructura_y
            
            if indice_subestructura == -1 {
                
                elementos_lista_grupos[elementos_lista_grupos.count - 1]["elementos"] = aux_elementos_grupo as AnyObject?
                
            }
            
            //print(elementos_lista_grupos[elementos_lista_grupos.count - 1])
            
        }
        
        
        print("Los renglones que fueron son \(renglones)")
        
        self.aux_posicion.frame = CGRect(x: 10, y: offset_lista, width: 50, height: 50)
        
        aux_vista_scroll.contentSize = CGSize(width: aux_vista_scroll.contentSize.width, height: aux_posicion.frame.origin.y +  aux_posicion.frame.size.height+300)
        
        
        let fin = elementos_lista.count - 1
        
        let indices = ["inicio":inicio,"fin":fin,"color_texto0":color_texto0,"color_texto1":color_texto0] as [String : Any]
        
        return indices as [String : AnyObject]
        
    }
    
    @objc func limpiar_cero(sender:UITextField){
        
        if sender.text! == "0" {
            sender.text = ""
        }
        
    }
    
    @objc func checar_sies_numero(sender:UITextField){
        
        
        if NumberFormatter().number(from: sender.text!) == nil {
            
            if sender.text! != "" {
                
                sender.text = sender.text?.substring(to: (sender.text?.index(before: (sender.text?.endIndex)!))!)
            }
        }
        
        
    }
    
    
    //crear estructura
    
    func crear_estructura(estructura:JSON,offset_y:Int,offset:Int) -> [String:AnyObject]{
        
        var estructura_elementos:[[String:AnyObject]] = []
        
        var offset = offset
        
        var offset_y = offset_y
        
        var aux_elemento:[String:AnyObject]
        
        el_constructor.colorTexto = "000000"
        
        //laVista.frame = CGRect(x: 0, y: 60, width: self.view.frame.width+10, height: self.view.frame.height)
        
        //print(estructura.arreglo)
        
        for k in 0 ..< estructura.arreglo.count {
            
            // print(estructura[k])
            
            switch estructura.arreglo[k]["tipo"] as! String{
            case "CABECERA":
                indice = estructura_elementos.count
                indice_cabecera_original = estructura_elementos.count
                
                estructura_elementos.append([String:AnyObject]())
                estructura_elementos[estructura_elementos.count - 1]["id_elemento"]=estructura.arreglo[k]["id_elemento"]
                estructura_elementos[estructura_elementos.count - 1]["tipo"] = estructura.arreglo[k]["tipo"]
                estructura_elementos[estructura_elementos.count - 1]["query"] = estructura.arreglo[k]["query"]
                estructura_elementos[estructura_elementos.count - 1]["color_renglon"] = estructura.arreglo[k]["color_renglon"]
                estructura_elementos[estructura_elementos.count - 1]["color_texto0"] = estructura.arreglo[k]["color_texto0"]
                estructura_elementos[estructura_elementos.count - 1]["color_texto1"] = estructura.arreglo[k]["color_texto1"]
                
                if estructura.arreglo[k]["columna_filtro1"] != nil {
                    
                    
                    estructura_elementos[estructura_elementos.count - 1]["columna_filtro1"] = estructura.arreglo[k]["columna_filtro1"]
                    
                }
                
                
                if estructura.arreglo[k]["columna_filtro2"] != nil {
                    
                    
                    estructura_elementos[estructura_elementos.count - 1]["columna_filtro2"] = estructura.arreglo[k]["columna_filtro2"]
                    
                }
                
                
                if estructura.arreglo[k]["columna_filtro3"] != nil {
                    
                    
                    estructura_elementos[estructura_elementos.count - 1]["columna_filtro3"] = estructura.arreglo[k]["columna_filtro3"]
                    
                }
                
            case "REAL",
                 "NUMERIC":
                
                indice = estructura_elementos.count
                
                
                
                aux_elemento = el_constructor.agregar_campotexto(VistaScroll: laVista, offset: offset, indice: indice, etiqueta: estructura.arreglo[k]["texto"] as! String, controlador: self,tipo: estructura.arreglo[k]["tipo"] as! String,ancho: Int(estructura.arreglo[k]["ancho"] as! String)!,cuadro: Int(estructura.arreglo[k]["cuadro"] as! String)!,linea: Int(estructura.arreglo[k]["linea"] as! String)!)
                
                offset = aux_elemento["offset"] as! Int
                
                estructura_elementos.append([String:AnyObject]())
                estructura_elementos[estructura_elementos.count - 1]["id_elemento"]=estructura.arreglo[k]["id_elemento"]
                estructura_elementos[estructura_elementos.count - 1]["tipo"]=aux_elemento["tipo"]
                estructura_elementos[estructura_elementos.count - 1]["elemento"]=aux_elemento["elemento"]
                estructura_elementos[estructura_elementos.count - 1]["label"]=aux_elemento["label"]
                estructura_elementos[estructura_elementos.count - 1]["columna"]=estructura.arreglo[k]["columna"]
                estructura_elementos[estructura_elementos.count - 1]["valor"]=estructura.arreglo[k]["valor"]
                estructura_elementos[estructura_elementos.count - 1]["tabla"]=estructura.arreglo[k]["tabla"]
                
                
                
                
                
                
                if estructura.arreglo[k]["opcional"] != nil {
                    
                    let auxOpcional = estructura.arreglo[k]["opcional"] as! [[String:AnyObject]]
                    
                    
                    for qk in 0 ..< auxOpcional.count {
                        
                        estructura_elementos[estructura_elementos.count - 1]["opcional"] = 1 as AnyObject?
                        estructura_elementos[estructura_elementos.count - 1]["sql_opcional"] = auxOpcional[qk]["query"]
                    }
                    
                    
                }
                
                
                
            case "LABEL":
                
                indice = estructura_elementos.count
                
                aux_elemento = el_constructor.agregar_label(VistaScroll: laVista, offset: offset, indice: indice, etiqueta: estructura.arreglo[k]["texto"] as! String, controlador: self, tipo: estructura.arreglo[k]["tipo"] as! String, ancho: Int(estructura.arreglo[k]["ancho"] as! String)!, cuadro: Int(estructura.arreglo[k]["cuadro"] as! String)!, tamano: Int(estructura.arreglo[k]["tamano"] as! String)!, linea: Float(estructura.arreglo[k]["linea"] as! String)!, columna: estructura.arreglo[k]["columna"] as! String)
                
                
                //aux_elemento = el_constructor.agregar_label(VistaScroll: laVista, offset: offset, indice: indice, etiqueta: "\(estructura.arreglo[k]["texto"])", controlador: self, tipo: "\(estructura.arreglo[k]["tipo"])",ancho: estructura.arreglo[k]["ancho"] as! Int,cuadro: estructura.arreglo[k]["cuadro"] as! Int,tamano: estructura.arreglo[k]["tamano"] as! Int,linea: estructura.arreglo[k]["linea"] as! Int,columna:estructura.arreglo[k]["columna"] as! String) as [String:AnyObject]
                
                offset = aux_elemento["offset"] as! Int
                
                estructura_elementos.append([String:AnyObject]())
                estructura_elementos[estructura_elementos.count - 1]["id_elemento"]=estructura.arreglo[k]["id_elemento"]
                estructura_elementos[estructura_elementos.count - 1]["tipo"]=aux_elemento["tipo"]
                estructura_elementos[estructura_elementos.count - 1]["elemento"]=aux_elemento["elemento"]
                estructura_elementos[estructura_elementos.count - 1]["label"]=aux_elemento["label"]
                estructura_elementos[estructura_elementos.count - 1]["columna"]=estructura.arreglo[k]["columna"]
                
                
            case "SELECT_ONE_RADIO":
                
                indice = estructura_elementos.count
                
                
                var opciones = [[String:AnyObject]]()
                
                var aux_grupo = 0
                
                let auxOpciones = estructura.arreglo[k]["opciones"] as! [[String:AnyObject]]
                
                for qk in 0 ..< auxOpciones.count {
                    
                    opciones.append([String:AnyObject]())
                    
                    opciones[opciones.count - 1]["opcion"] = auxOpciones[qk]["texto"]
                    opciones[opciones.count - 1]["seleccionado"] = false as AnyObject?
                    opciones[opciones.count - 1]["linea"] = auxOpciones[qk]["linea"]
                    opciones[opciones.count - 1]["cuadro"] = auxOpciones[qk]["cuadro"]
                    opciones[opciones.count - 1]["valor"] = auxOpciones[qk]["valor"]
                    
                    aux_grupo = Int(auxOpciones[qk]["grupo"] as! String)!
                    
                }
                
                
                aux_elemento = el_constructor.agregar_radio(VistaScroll: laVista, offset: offset, indice: indice, etiqueta: estructura.arreglo[k]["texto"] as! String, controlador: self, tipo: estructura.arreglo[k]["tipo"] as! String, ancho: Int(estructura.arreglo[k]["ancho"] as! String)!, opciones: opciones,grupo: aux_grupo,cuadro: Int(estructura.arreglo[k]["cuadro"] as! String)!,linea: Int(estructura.arreglo[k]["linea"] as! String)!)
                
                //print(aux_elemento)
                
                estructura_elementos.append([String:AnyObject]())
                estructura_elementos[estructura_elementos.count - 1]["id_elemento"]=estructura.arreglo[k]["id_elemento"]
                estructura_elementos[estructura_elementos.count - 1]["tipo"]=aux_elemento["tipo"]
                estructura_elementos[estructura_elementos.count - 1]["grupo"]=aux_elemento["grupo"]
                estructura_elementos[estructura_elementos.count - 1]["label"]=aux_elemento["label"]
                
                let auxTotal = (aux_elemento["botones"] as! [UIButton]).count
                
                estructura_elementos[estructura_elementos.count - 1]["total"] =  auxTotal as AnyObject?
                estructura_elementos[estructura_elementos.count - 1]["columna"]=estructura.arreglo[k]["columna"]
                
                
                //print(estructura.arreglo[k]["elementos_hijos"])
                
                estructura_elementos[estructura_elementos.count - 1]["elementos_hijos"]=estructura.arreglo[k]["elementos_hijos"]
                estructura_elementos[estructura_elementos.count - 1]["opcion_hijo"]=estructura.arreglo[k]["opcion_hijo"]
                
                //estructura_elementos[estructura_elementos.count - 1]["botones"] = [[String:AnyObject]]()
                
                var q = 0
                
                var aux_botones = [[String:AnyObject]]()
                
                for boton in aux_elemento["botones"] as! [UIButton] {
                    
                    
                    
                    boton.addTarget(self, action:#selector(ModuloController.b_radio_opcion(sender:)), for:.touchDown)
                    boton.tag = estructura_elementos.count
                    
                    aux_botones.append([String:AnyObject]())
                    aux_botones[aux_botones.count - 1]["elemento"]=boton
                    aux_botones[aux_botones.count - 1]["posicion"]=q as AnyObject?
                    
                    
                    
                    aux_botones[aux_botones.count - 1]["opcion"]=(aux_elemento["opciones"] as! [UILabel])[q]
                    
                    if (aux_elemento["opciones"] as! [UILabel])[q].text! == "Si" {
                        
                        aux_botones[aux_botones.count - 1]["valor"] = "1" as AnyObject?
                        
                    }
                    
                    if (aux_elemento["opciones"] as! [UILabel])[q].text! == "No" {
                        
                        aux_botones[aux_botones.count - 1]["valor"] = "2" as AnyObject?
                        
                    }
                    
                    var seleccionado = false
                    
                    if boton.imageView?.image == UIImage(named: "RadioButtonSeleccionado") {
                        
                        seleccionado = true
                        boton.isUserInteractionEnabled = false
                    }
                    
                    aux_botones[aux_botones.count - 1]["seleccionado"] = seleccionado as AnyObject?
                    
                    q += 1
                    
                }
                
                estructura_elementos[estructura_elementos.count - 1]["botones"] = aux_botones as AnyObject?
                
                offset = aux_elemento["offset"] as! Int
                
            case "FOTO":
                
                indice = estructura_elementos.count
                
                
                
                aux_elemento = el_constructor.agregar_foto(VistaScroll: laVista, offset: offset, indice: indice, controlador: self, tipo: estructura.arreglo[k]["tipo"] as! String, ancho: Int(estructura.arreglo[k]["ancho"] as! String)!, cuadro: Int(estructura.arreglo[k]["cuadro"] as! String)!, linea: Int(estructura.arreglo[k]["linea"] as! String)!)
                
                offset = aux_elemento["offset"] as! Int
                
                estructura_elementos.append([String:AnyObject]())
                estructura_elementos[estructura_elementos.count - 1]["id_elemento"]=estructura.arreglo[k]["id_elemento"]
                estructura_elementos[estructura_elementos.count - 1]["tipo"]=aux_elemento["tipo"]
                estructura_elementos[estructura_elementos.count - 1]["elemento"]=aux_elemento["elemento"]
                estructura_elementos[estructura_elementos.count - 1]["columna"]=estructura.arreglo[k]["columna"]
                estructura_elementos[estructura_elementos.count - 1]["tabla"]=estructura.arreglo[k]["tabla"]
                estructura_elementos[estructura_elementos.count - 1]["total"]=estructura.arreglo[k]["total"]
                estructura_elementos[estructura_elementos.count - 1]["id_padre_fk"]=estructura.arreglo[k]["id_padre_fk"]
                estructura_elementos[estructura_elementos.count - 1]["id_padre"]=estructura.arreglo[k]["id_padre"]
                estructura_elementos[estructura_elementos.count - 1]["tabla_padre"]=estructura.arreglo[k]["tabla_padre"]
                /*
                 case "SELECT_ONE_SPINNER":
                 
                 indice = estructura_elementos.count
                 
                 aux_elemento = el_constructor.agregar_select(VistaScroll, offset: offset, indice: indice, etiqueta: "\(estructura[k]["texto"])", controlador: self, tipo: "\(estructura[k]["tipo"])", ancho: Int("\(estructura[k]["ancho"])")!, cuadro: Int("\(estructura[k]["cuadro"])")!, linea: Int("\(estructura[k]["linea"])")!)
                 
                 offset = aux_elemento!["offset"] as! Int
                 
                 estructura_elementos.append([String:AnyObject]())
                 estructura_elementos[estructura_elementos.count - 1]["tipo"]=aux_elemento!["tipo"] as! String
                 estructura_elementos[estructura_elementos.count - 1]["elemento"]=aux_elemento!["elemento"]
                 estructura_elementos[estructura_elementos.count - 1]["columna"]="\(estructura[k]["columna"])"
                 estructura_elementos[estructura_elementos.count - 1]["tabla"]="\(estructura[k]["tabla"])"
                 estructura_elementos[estructura_elementos.count - 1]["valor"]="\(estructura[k]["valor"])"
                 estructura_elementos[estructura_elementos.count - 1]["color_menu"]="\(estructura[k]["color_menu"])"
                 estructura_elementos[estructura_elementos.count - 1]["color_texto"]="\(estructura[k]["color_texto"])"
                 estructura_elementos[estructura_elementos.count - 1]["id_padre"]="\(estructura[k]["id_padre"])"
                 estructura_elementos[estructura_elementos.count - 1]["id_elemento"]="\(estructura[k]["id_elemento"])"
                 estructura_elementos[estructura_elementos.count - 1]["texto"]="\(estructura[k]["texto"])"
                 
                 if estructura[k]["elemento_padre"] != nil {
                 
                 estructura_elementos[estructura_elementos.count - 1]["elemento_padre"]="\(estructura[k]["elemento_padre"])"
                 estructura_elementos[estructura_elementos.count - 1]["query"]="\(estructura[k]["query"])"
                 
                 }
                 
                 if estructura[k]["elemento_hijo"] != nil {
                 
                 estructura_elementos[estructura_elementos.count - 1]["elemento_hijo"]="\(estructura[k]["elemento_hijo"])"
                 
                 }
                 
                 if estructura[k]["valor_final"] != nil {
                 
                 estructura_elementos[estructura_elementos.count - 1]["valor_final"]="\(estructura[k]["valor_final"])"
                 
                 }
                 
                 if estructura[k]["tabla_guardar"] != nil {
                 
                 estructura_elementos[estructura_elementos.count - 1]["tabla_guardar"]="\(estructura[k]["tabla_guardar"])"
                 estructura_elementos[estructura_elementos.count - 1]["columna_guardar"]="\(estructura[k]["columna_guardar"])"
                 estructura_elementos[estructura_elementos.count - 1]["columna_guardar_padre"]="\(estructura[k]["columna_guardar_padre"])"
                 estructura_elementos[estructura_elementos.count - 1]["tabla_padre"]="\(estructura[k]["tabla_padre"])"
                 estructura_elementos[estructura_elementos.count - 1]["id_padre_reporte"]="\(estructura[k]["id_padre_reporte"])"
                 
                 }
                 
                 case "SUBESTRUCTURA":
                 
                 indice = estructura_elementos.count
                 
                 //print("texto subsestructura \(estructura[k]["texto"])")
                 
                 aux_elemento = el_constructor.agregar_boton_subestructura(VistaScroll, offset: offset, indice: indice, etiqueta: "\(estructura[k]["texto"])", controlador: self, tipo: "\(estructura[k]["tipo"])", ancho: 0, cuadro: Int("\(estructura[k]["cuadro"])")!, linea: Int("\(estructura[k]["linea"])")!)
                 
                 offset = aux_elemento!["offset"] as! Int
                 
                 let respuesta_estructura = crear_estructura(estructura[k]["estructura"], offset_y: 0, offset: 21)
                 
                 estructura_elementos.append([String:AnyObject]())
                 estructura_elementos[estructura_elementos.count - 1]["tipo"]="\(estructura[k]["tipo"])"
                 estructura_elementos[estructura_elementos.count - 1]["id_padre"]="\(estructura[k]["id_padre"])"
                 estructura_elementos[estructura_elementos.count - 1]["elemento"]=aux_elemento!["elemento"]
                 estructura_elementos[estructura_elementos.count - 1]["elemento_ojo"]=aux_elemento!["elemento_ojo"]
                 estructura_elementos[estructura_elementos.count - 1]["estructura"]=respuesta_estructura["estructura"] as! [[String:AnyObject]]
                 estructura_elementos[estructura_elementos.count - 1]["estructura_y"]=respuesta_estructura["estructura_y"] as! Int
                 */
                
            case "FILTRO":
                
                indice = estructura_elementos.count
                
                
                var opciones = [[String:AnyObject]]()
                
                let auxOpciones = estructura.arreglo[k]["opciones"] as! [[String:AnyObject]]
                
                for qk in 0 ..< auxOpciones.count {
                    
                    print("si entro a las opciones")
                    
                    opciones.append([String:AnyObject]())
                    
                    opciones[opciones.count - 1]["columna_filtro"] = auxOpciones[qk]["columna_filtro"]
                    opciones[opciones.count - 1]["texto"] = auxOpciones[qk]["texto"]
                    opciones[opciones.count - 1]["query"] = auxOpciones[qk]["query"]
                    
                    
                }
                
                aux_elemento = el_constructor.agregar_boton_filtro(VistaScroll: laVista, offset: offset, indice: indice, etiqueta: "Filtro", controlador: self, tipo: estructura.arreglo[k]["tipo"] as! String,opciones: opciones)
                
                estructura_elementos.append([String:AnyObject]())
                estructura_elementos[estructura_elementos.count - 1]["tipo"]=aux_elemento["tipo"]
                estructura_elementos[estructura_elementos.count - 1]["elemento"]=aux_elemento["elemento"]
                estructura_elementos[estructura_elementos.count - 1]["opciones"]=opciones as AnyObject?
                
                let aux_boton_filtro = estructura_elementos[estructura_elementos.count - 1]["elemento"] as! UIButton
                
                aux_boton_filtro.addTarget(self, action:#selector(ModuloController.mostrar_filtro(sender:)), for:.touchDown)
                
                
                
            default:
                print("tipo no manejado al crear")
            }
            
        }
        
        
        offset_y = offset
        
        let respuesta_estructura = ["estructura":estructura_elementos,"estructura_y":offset_y] as [String : Any]
        
        return respuesta_estructura as [String : AnyObject]
        
    }
    
    
    //fin crear estructura
    
    //TextDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        //print("simon empezo a editar")
        
        
        
        
        if elementos_lista[textField.tag]["tipo"] as! String == "NUMERIC" || elementos_lista[textField.tag]["tipo"] as! String == "REAL"{
            
            addToolBar(textField)
            
            
            
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text! == "" {
            
            textField.text = "0"
            
        }
        
        let id = elementos_lista[textField.tag]["id"] as! Int
        
        var sql = "select \(elementos_lista[textField.tag]["valor"] as! String) from \(elementos_lista[textField.tag]["tabla"] as! String) where id_item = '\(id)' and idReporteLocal = '\(idReporteLocal)'"
        
        
        let resultado_distribution = db.select_query_columns(sql)
        
        
        
        if resultado_distribution.count > 0 {
            
            sql = "update \(elementos_lista[textField.tag]["tabla"] as! String) set \(elementos_lista[textField.tag]["valor"] as! String) = '\(textField.text!)' where id_item='\(id)' and idReporteLocal = '\(idReporteLocal)'"
            
            print(sql)
            
            let resultado_update_campo = db.execute_query(sql)
            
            print(resultado_update_campo)
            
        }
        else{
            
            let tiempo_milisegundos = String(Int64(NSDate().timeIntervalSince1970*1000))
            
            let random = Int(arc4random_uniform(1000))
            
            let el_hash=String(tiempo_milisegundos) + String(describing: defaults.object(forKey: "idReporteLocal")!) + String(random)
            
            sql = "insert into report_distribution ('idReporteLocal','id_item','\(elementos_lista[textField.tag]["valor"] as! String)','hash','distribution') values ('\(idReporteLocal)','\(id)','\(textField.text!)','\(el_hash.md5())','2')"
            
            print(sql)
            
            let resultado_insert_distribution = db.execute_query(sql)
            
            print(resultado_insert_distribution)
            
        }
        
        let indice_grupo = elementos_lista[textField.tag]["indice_grupo"] as! Int
        
        let indices = elementos_lista_grupos[indice_grupo]["elementos"] as! [Int]
        
        acomodar_objetosColor(indices: indices)
        
        
    }
    
    
    
    //Fin TextDelegate
    
    
    //funcion radio button
    
    @objc func b_radio_opcion(sender:UIButton){
        
        
        
        let indice = sender.tag
        
        //print(elementos_lista[indice]["id"])
        
        var valor = 0
        
        var miIndiceGrupo = 0
        
        var kq = 0
        
        for var boton in elementos_lista[indice]["botones"] as! [[String:AnyObject]] {
            
            if (boton["elemento"] as! UIButton) == sender {
                
                miIndiceGrupo = elementos_lista[indice]["indice_grupo"] as! Int
                
                switch (boton["opcion"] as! UILabel).text! {
                case "Si":
                    valor = 1
                case "No":
                    valor = 2
                default:
                    valor = 0
                }
                
            }
            
            
            (boton["elemento"] as! UIButton).setImage(UIImage(named: "RadioButton"), for: .normal)
            
            
            var auxBotones = elementos_lista[indice]["botones"] as! [[String:AnyObject]]
            
            auxBotones[kq]["seleccionado"] = false as AnyObject?
            auxBotones[kq]["valor"] = String(describing: valor) as AnyObject?
            
            (boton["elemento"] as! UIButton).isUserInteractionEnabled = true
            
            if (boton["elemento"] as! UIButton) == sender {
                
                boton["seleccionado"] = true as AnyObject?
                auxBotones[kq]["seleccionado"] = true as AnyObject?
                
            }
            
            elementos_lista[indice]["botones"] = auxBotones as AnyObject?
            
            kq += 1
        }
        
        sender.setImage(UIImage(named: "RadioButtonSeleccionado"), for: .normal)
        
        
        
        sender.isUserInteractionEnabled = false
        
        
        var sql = "select id_item from report_distribution where id_item = '\(elementos_lista[indice]["id"]!)' and idReporteLocal = '\(idReporteLocal)'"
        
        //print(sql)
        
        let resultado_distribution = db.select_query_columns(sql)
        
        if resultado_distribution.count > 0 {
            
            if valor == 1 {
                
                sql = "update report_distribution set distribution = \(valor) where id_item = \(elementos_lista[indice]["id"]!) and idReporteLocal = '\(idReporteLocal)'"
                
            }
            
            if valor == 2 {
                
                sql = "update report_distribution set distribution = \(valor),cup_price = '0.0',bootle_price = '0.0' where id_item = \(elementos_lista[indice]["id"]!) and idReporteLocal = '\(idReporteLocal)'"
                
            }
            //print(sql)
            
            let resultado_radio_opcion = db.execute_query(sql)
            
            print(resultado_radio_opcion)
            
        }
        else{
            
            let tiempo_milisegundos = String(Int64(NSDate().timeIntervalSince1970*1000))
            
            let random = Int(arc4random_uniform(1000))
            
            let el_hash=String(tiempo_milisegundos) + String(describing: defaults.object(forKey: "idReporteLocal")!) + String(random)
            
            sql = "insert into report_distribution (idReporteLocal,id_item,bootle_price,cup_price,hash,distribution,is_send) values ('\(idReporteLocal)','\(elementos_lista[indice]["id"]!)','0.0','0.0','\(el_hash.md5())','\(valor)','0')"
            
            //print(sql)
            
            _ = db.execute_query(sql)
            
            //print(resultado_insert_distribution)
            
        }
        
        for elemento in elementos_lista where elemento["tipo"] as! String == "SELECT_ONE_RADIO" && elemento["indice_grupo"] as! Int == miIndiceGrupo {
            
            //print("elementos radios")
            //print(elemento)
            
            buscar_hijos(elemento: elemento)
            
            
        }
        
        
        
        let indice_grupo = elementos_lista[sender.tag]["indice_grupo"] as! Int
        
        let indices = elementos_lista_grupos[indice_grupo]["elementos"] as! [Int]
        
        acomodar_objetosColor(indices: indices)
        
        
        
        
        
    }
    
    //fin funciones radio button
    
    
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
            let nombre_foto = "\(tipo)\(hash).jpg"
            let foto_ruta_absoluta = ruta_absoluta(nombre_foto)
            
            
            
            let respuesta_guardar = guardar_foto(imagen: aux_foto, ruta: foto_ruta_absoluta)
            
            //print("se guarda la imagen? \(respuesta_guardar)")
            
            
            if respuesta_guardar {
                
                
                if elementos_lista[foto_tag]["fotos"] == nil{
                    
                    let fotos:[[String:AnyObject]] = []
                    //fotos.append([String : AnyObject]())
                    
                    elementos_lista[foto_tag]["fotos"] = fotos as AnyObject?
                }
                
                
                
                var aux_fotos = elementos_lista[foto_tag]["fotos"] as! [[String:AnyObject]]
                
                aux_fotos.append([String : AnyObject]())
                
                
                for (indice,auxFotoPre) in aux_fotos.enumerated() where auxFotoPre["hash"] != nil {
                    
                    if auxFotoPre["hash"] as! String == "prellenada" {
                        
                        
                        aux_fotos.remove(at: indice)
                        
                    }
                    
                }
                
                aux_fotos[aux_fotos.count - 1]["nombre"] = nombre_foto as AnyObject?
                
                
                let aux_b_foto = elementos_lista[foto_tag]["elemento"] as! UIButton
                
                aux_b_foto.setTitle("Tomar Foto \(aux_fotos.count)/\(elementos_lista[foto_tag]["total"]!)", for: .normal)
                
                aux_b_foto.setImage(UIImage(named: "CamaraActiva"), for: .normal)
                
                elementos_lista[foto_tag]["fotos"] = aux_fotos as AnyObject?
                
                let total = Int(elementos_lista[foto_tag]["total"] as! String)
                
                if total! <= aux_fotos.count {
                    
                    aux_b_foto.isUserInteractionEnabled = false
                }
                
                
                
                let indice_grupo = elementos_lista[foto_tag]["indice_grupo"] as! Int
                
                let filter2 = elementos_lista_grupos[indice_grupo]["filter2"] as! String
                
                
                for aux_grupo in elementos_lista_grupos where aux_grupo["filter2"] as! String == filter2 {
                    
                    for auxIndice in aux_grupo["elementos"] as! [Int] {
                        
                        if elementos_lista[auxIndice]["tipo"] as! String == "FOTO" {
                            
                            print(elementos_lista[auxIndice])
                            
                            
                            if elementos_lista[auxIndice]["fotos"] == nil{
                                
                                let fotos:[[String:AnyObject]] = []
                                //fotos.append([String : AnyObject]())
                                
                                elementos_lista[auxIndice]["fotos"] = fotos as AnyObject?
                            }
                            
                            
                            
                            
                            let aux_b_foto2 = elementos_lista[auxIndice]["elemento"] as! UIButton
                            
                            aux_b_foto2.setTitle("Tomar Foto \(aux_fotos.count)/\(elementos_lista[auxIndice]["total"]!)", for: .normal)
                            
                            aux_b_foto2.setImage(UIImage(named: "CamaraActiva"), for: .normal)
                            
                            elementos_lista[auxIndice]["fotos"] = aux_fotos as AnyObject?
                            
                            let total2 = total!
                            
                            if total2 <= aux_fotos.count {
                                
                                aux_b_foto2.isUserInteractionEnabled = false
                            }
                            
                        }
                    }
                    
                    
                    
                    let indices = aux_grupo["elementos"] as! [Int]
                    
                    acomodar_objetosColor(indices: indices)
                    
                }
                
                
                
                var sql = "select id from \(elementos_lista[foto_tag]["tabla_padre"] as! String) where \(elementos_lista[foto_tag]["id_padre"] as! String) = '\(elementos_lista[foto_tag]["id"]!)' and idReporteLocal = '\(idReporteLocal)'"
                
                //print(sql)
                
                let resultado_distribution = db.select_query_columns(sql)
                
                var id_padre = 0
                
                if resultado_distribution.count > 0 {
                    
                    for renglon in resultado_distribution {
                        
                        id_padre = renglon["id"] as! Int
                        
                    }
                    
                }
                else{
                    
                    
                    let tiempo_milisegundos = String(Int64(NSDate().timeIntervalSince1970*1000))
                    
                    let random = Int(arc4random_uniform(1000))
                    
                    let el_hash=String(tiempo_milisegundos) + String(describing: defaults.object(forKey: "idReporteLocal")!) + String(random)
                    
                    
                    sql = "insert into report_distribution ('idReporteLocal','id_item','cup_price','bootle_price','hash','distribution') values ('\(idReporteLocal)','\(elementos_lista[foto_tag]["id"]!)','0.0','0.0','\(el_hash.md5())','2')"
                    
                    print(sql)
                    
                    _ = db.execute_query(sql)
                    
                    sql = "select id from \(elementos_lista[foto_tag]["tabla_padre"] as! String) where \(elementos_lista[foto_tag]["id_padre"] as! String) = '\(elementos_lista[foto_tag]["id"]!)' and idReporteLocal = '\(idReporteLocal)'"
                    
                    let resultado_distribution = db.select_query_columns(sql)
                    
                    for renglon in resultado_distribution {
                        
                        id_padre = renglon["id"] as! Int
                        
                    }
                    
                    
                }
                
                
                
                sql = "delete from \(elementos_lista[foto_tag]["tabla"] as! String) where idReporteLocal = \(idReporteLocal) and hash = 'prellenada' and filter2 = '\(filter2)'"
                
                _ = db.execute_query(sql)
                
                
                
                sql = "insert into \(elementos_lista[foto_tag]["tabla"] as! String) (idReporteLocal,\(elementos_lista[foto_tag]["id_padre_fk"] as! String),path,hash,is_send,filter2) values ('\(idReporteLocal)','\(id_padre)','\(nombre_foto)','\(hash)','0','\(filter2)')"
                
                print(sql)
                
                let resultado_foto = db.execute_query(sql)
                
                print(resultado_foto)
                
                DispatchQueue.main.async {
                    
                    
                    /*
                     SwiftSpinner.show("Foto Guardada, Toque para cerrar").addTapHandler({
                     
                     self.imagePicker.view.removeFromSuperview()
                     self.imagePicker.removeFromParentViewController()
                     SwiftSpinner.hide()
                     
                     })
                     */
                    
                    
                    
                    // Create the alert controller
                    let alertController = UIAlertController(title: "¡Alerta!", message: "Foto Guardada", preferredStyle: .alert)
                    
                    // Create the actions
                    
                    
                    
                    let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        NSLog("click ok")
                        
                        self.imagePicker.view.removeFromSuperview()
                        self.imagePicker.removeFromParentViewController()
                        //SwiftSpinner.hide()
                        
                    }
                    
                    
                    // Add the actions
                    alertController.addAction(okAction)
                    
                    
                    
                    // Present the controller
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                    
                    
                    
                }
                
                
                
                
                
                
            }
            else{
                
                DispatchQueue.main.async {
                 /*
                    SwiftSpinner.show("Hubo problema al guardar la foto intentalo nuevamente por favor").addTapHandler({
                        
                        self.imagePicker.view.removeFromSuperview()
                        self.imagePicker.removeFromParentViewController()
                        SwiftSpinner.hide()
                        
                    })
                   */
                }
                
                
            }
            
            
            //self.arregloFotos[self.foto_tag].append(imagePath)
            
            
            //let idReporteLocal = self.defaults.objectForKey("idReporteLocal")
            
            
            
            //let sql = "insert into report_photo_distribution (id_report_local,id_report_distribution,path,hash,is_send,filter2) values ('\(idReporteLocal!)','\(self.arregloDistributionId[self.foto_tag][0])','\(self.arregloFotos[self.foto_tag][self.arregloFotos[self.foto_tag].count - 1] as! String)','\(el_hash.md5)','0','\(arregloFotosCategoria[self.foto_tag][0])')"
            
            //print(sql)
            
            // let resultado_query = self.db.execute_query(sql)
            
            
            // print(resultado_query)
            
            
            
            
            /*let sql_fotos = "select * from report_photo_distribution where id_report_local = '\(idReporteLocal!)' and filter2='\(self.arregloFotosCategoria[self.foto_tag][0])'"
             
             //print(sql)
             
             let resultadoFotos = self.db.select_query(sql_fotos)
             
             self.arregloMarcas[self.foto_tag][3].setTitle("\(resultadoFotos.count)/4", forState: .Normal)
             
             if resultadoFotos.count == 4 {
             
             (self.arregloMarcas[self.foto_tag][3] as! UIButton).userInteractionEnabled = false
             
             
             }
             else{
             
             (self.arregloMarcas[self.foto_tag][3] as! UIButton).userInteractionEnabled = true
             
             }
             
             
             var kq = 0
             
             for renglon_categoria in arregloFotosCategoria {
             
             if renglon_categoria[0] as! String == self.arregloFotosCategoria[self.foto_tag][0] as! String {
             
             
             var imagen_camara = ""
             
             if resultadoFotos.count == 0 {
             
             imagen_camara = "CamaraGris"
             (self.arregloMarcas[kq][3] as! UIButton).userInteractionEnabled = true
             
             }
             else{
             
             imagen_camara = "CamaraRoja"
             
             }
             
             self.arregloMarcas[kq][3].setTitle("\(resultadoFotos.count)/4", forState: .Normal)
             
             self.arregloMarcas[kq][3].setImage(UIImage(named: imagen_camara), forState: .Normal)
             
             
             if resultadoFotos.count == 4 {
             
             (self.arregloMarcas[kq][3] as! UIButton).userInteractionEnabled = false
             
             
             }
             else{
             
             (self.arregloMarcas[kq][3] as! UIButton).userInteractionEnabled = true
             
             }
             
             }
             
             
             
             
             kq += 1
             
             }
             
             */
            
            
            
            
            
            
            
            
        }
        
    }
    
    
    
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
    
    
    
    // select_menu
    
    
    //mostrar select menu
    /*
     func mostrar_select_menu(sender:UIButton){
     
     let aux_vista_scroll = sender.superview as! UIScrollView
     
     aux_vista_scroll.frame = CGRect(x: aux_vista_scroll.frame.origin.x, y: aux_vista_scroll.frame.origin.y, width: self.view.frame.width+10, height: aux_vista_scroll.frame.height)
     
     
     
     aux_vista_scroll.contentSize = CGSize(width: VistaScroll.contentSize.width, height: sender.superview!.frame.height)
     
     sender.setImage(UIImage(named: "FlechaSelectAbajo"), for: .normal)
     
     let elemento = elementos_lista[sender.tag]["elemento"] as! UIButton
     
     let colorTexto = elementos_lista[sender.tag]["color_texto"] as! String
     let colorMenu = elementos_lista[sender.tag]["color_menu"] as! String
     
     var indice_subestructura = 0
     
     if let _ = elementos_lista[sender.tag]["indice_subestructura"] as? Int {
     
     indice_subestructura = elementos_lista[sender.tag]["indice_subestructura"] as! Int
     }
     
     aux_vista_scroll.setContentOffset(CGPointMake(0, sender.center.y-50), animated: true)
     
     let posicion_y = elemento.frame.origin.y + elemento.frame.height
     
     select_menu.frame = CGRect(x: 0, y: posicion_y + aux_vista_scroll.frame.height, width: aux_vista_scroll.frame.width, height: 500)
     
     aux_vista_scroll.addSubview(select_menu)
     
     aux_vista_scroll.bringSubview(toFront: select_menu)
     
     let subViews = self.select_menu.subviews
     for subview in subViews{
     subview.removeFromSuperview()
     }
     
     select_menu.setContentOffset(CGPointMake(0, 0), animated: false)
     
     var offset = 40
     
     let aux_opciones = elementos_lista[sender.tag]["opciones"] as! [[String:AnyObject]]
     
     var existente = true
     
     for opcion in aux_opciones {
     
     if let valor_final = elementos_lista[sender.tag]["valor_final"] as? String {
     
     if valor_final == "si" {
     
     if let aux_elemento_nuevos = elementos_lista[indice_subestructura]["elementos_nuevos"] as? [[String:AnyObject]] {
     
     for aux_nuevo_elemento in aux_elemento_nuevos {
     
     if opcion["opcion"] as! String == aux_nuevo_elemento["opcion"] as! String {
     
     existente = false
     break
     }
     
     }
     
     }
     
     
     }
     
     }
     
     //print(opcion)
     
     if existente {
     
     let boton = UIButton()
     
     
     
     boton.setAttributedTitle(nil, for: .normal)
     boton.setTitle("\(opcion["opcion"]!)", for: .normal)
     
     boton.isSelected = false
     boton.setTitleColor(UIColor(rgba: "#\(colorTexto)"), for: .normal)
     
     
     boton.titleLabel!.font = boton.titleLabel?.font
     boton.titleLabel!.textColor = UIColor(rgba: "#\(colorTexto)")
     boton.titleLabel!.numberOfLines = 0
     boton.titleLabel!.textAlignment = .center
     
     boton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
     
     boton.titleLabel!.sizeToFit()
     
     boton.tag = sender.tag
     
     //print(Int(self.VistaScroll.frame.width))
     
     boton.frame = CGRect(x: 0, y: offset, width: Int(aux_vista_scroll.frame.width), height: 50)
     
     select_menu.addSubview(boton)
     
     boton.addTarget(self, action:#selector(ModuloController.opcion_select_menu(_:)), for:.TouchDown)
     
     offset += Int(boton.titleLabel!.frame.height) + 40
     
     }
     
     existente = true
     
     
     }
     
     select_menu.contentSize = CGSizeMake(select_menu.contentSize.width, CGFloat(offset) + 300)
     
     let cuadro = dibujar_cuadro(CGSize(width: aux_vista_scroll.frame.width,height: CGFloat(offset) + 300), color: colorMenu)
     
     let aux_cuadro = UIImageView()
     
     
     aux_cuadro.frame = CGRect(x: 0, y: 0, width: Int(aux_vista_scroll.frame.width), height: offset+300)
     
     aux_cuadro.image = cuadro
     
     
     select_menu.addSubview(aux_cuadro)
     
     select_menu.sendSubview(toBack: aux_cuadro)
     
     UIView.animate(withDuration: 0.5, delay: 0.1, options: [],animations: {
     
     self.select_menu.frame.origin.y = posicion_y
     // self.username.center.x += self.view.bounds.width
     }, completion: nil)
     
     
     }
     */
    //mostrar_select menu
    
    //opcion select_menu
    /*
     func opcion_select_menu(sender:UIButton){
     
     let aux_vista_scroll = sender.superview?.superview as! UIScrollView
     
     let elemento = elementos_lista[sender.tag]["elemento"] as! UIButton
     
     var aux_opciones = elementos_lista[sender.tag]["opciones"] as! [[String:AnyObject]]
     
     var indice_subestructura = -1
     
     if let _ = elementos_lista[sender.tag]["indice_subestructura"] as? Int {
     
     indice_subestructura = elementos_lista[sender.tag]["indice_subestructura"] as! Int
     }
     
     
     var q = 0
     
     var id_seleccion = 0
     
     for opcion in aux_opciones {
     
     aux_opciones[q]["seleccionado"] = false as AnyObject?
     
     
     
     if sender.titleLabel!.text! == opcion["opcion"] as! String {
     
     aux_opciones[q]["seleccionado"] = true as AnyObject?
     id_seleccion = opcion["id"] as! Int
     
     }
     
     q += 1
     
     }
     
     elementos_lista[sender.tag]["opciones"] = aux_opciones as AnyObject?
     
     buscar_hijo(indice_padre: sender.tag,id_seleccion: id_seleccion,segundo_hijo: 0)
     
     elemento.setTitle(sender.titleLabel?.text!, for: .normal)
     elemento.setImage(UIImage(named: "FlechaSelectDerecha"), for: .normal)
     
     elemento.titleEdgeInsets = UIEdgeInsetsMake(0, -elemento.imageView!.frame.size.width, 0, elemento.imageView!.frame.size.width);
     elemento.imageEdgeInsets = UIEdgeInsetsMake(18, elemento.titleLabel!.frame.size.width + 10, 18, -elemento.titleLabel!.frame.size.width);
     
     //print("simon opcion")
     select_menu.removeFromSuperview()
     
     self.aux_posicion.frame = CGRect(x: 10, y: -40, width: 50, height: 50)
     
     let subViews = aux_vista_scroll.subviews
     for subview in subViews{
     
     if subview.frame.origin.y > aux_posicion.frame.origin.y {
     
     self.aux_posicion.frame = subview.frame
     
     }
     
     aux_vista_scroll.contentSize = CGSizeMake(aux_vista_scroll.contentSize.width, aux_posicion.frame.origin.y +  aux_posicion.frame.size.height+300)
     
     }
     
     //print("el y que quedo fue de \(aux_posicion.frame.origin.y)")
     
     
     if let valor_final = elementos_lista[sender.tag]["valor_final"] as? String {
     
     let aux_b_agregar = elementos_lista[indice_subestructura]["b_agregar"] as! UIButton
     
     if valor_final == "si" {
     
     
     
     aux_b_agregar.isHidden = false
     
     
     }
     else{
     
     aux_b_agregar.isHidden = true
     
     }
     
     }
     
     
     
     
     
     }
     */
    //fin opcion selct_menu
    
    
    //buscar hijos
    
    func buscar_hijos(elemento:[String:AnyObject]) {
        
        //print("vamos a ver los hijos")
        print(elemento)
        //var indice_hijos:[Int] = []
        
        if elemento["elementos_hijos"] != nil {
            
            let idsHijos = elemento["elementos_hijos"] as! [[String:AnyObject]]
            
            print("si tiene hijos")
            print(idsHijos)
            
            var oculto = true
            
            let auxOpcionHijo = elemento["opcion_hijo"] as! String
            
            let auxOpciones = elemento["botones"] as! [[String:AnyObject]]
            
            for opcion in auxOpciones where opcion["seleccionado"] as! Bool == true {
                
                print(opcion)
                
                if opcion["valor"] as! String == auxOpcionHijo {
                    
                    oculto = false
                }
                
            }
            
            for auxElemento in elementos_lista where auxElemento["indice_grupo"] as! Int == elemento["indice_grupo"] as! Int {
                
                print("los elementos de grpos con hijos son")
                print(auxElemento)
                
                
                
                if let auxView = auxElemento["elemento"] as? UIView {
                    
                    
                    
                    if let _ = auxElemento["id_elemento"] as? String {
                        
                        for hijo in idsHijos where hijo["id_elemento"] as! String == auxElemento["id_elemento"] as! String {
                            
                            if oculto {
                                
                                auxView.isHidden = true
                                
                                if let auxLabel = auxElemento["label"] as? UIView {
                                    
                                    auxLabel.isHidden = true
                                    
                                }
                                
                            }
                            else{
                                
                                auxView.isHidden = false
                                
                                if let auxLabel = auxElemento["label"] as? UIView {
                                    
                                    auxLabel.isHidden = false
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    
                }
                
                
                
                
            }
            
            
        }
        
        
        
        
    }
    
    
    //fin buscar hijos
    
    
    //fin select_menu
    
    
    //mostrar substructura
    
    /*
     func mostrar_subestructura(sender:UIButton)  {
     
     idReporteLocal = defaults.object(forKey: "idReporteLocal") as! Int
     
     //print("simon subestructura")
     
     let aux_vista_scroll = sender.superview as! UIScrollView
     
     
     
     aux_vista_scroll.frame = CGRect(x: 0, y: 0, width: self.view.frame.width+10, height: self.view.frame.height)
     
     
     
     aux_vista_scroll.contentSize = CGSizeMake(aux_vista_scroll.contentSize.width, aux_vista_scroll.frame.height)
     
     
     let aux_estructura = elementos_lista[sender.tag]["estructura"] as! [[String:AnyObject]]
     
     let elemento = elementos_lista[sender.tag]["elemento"] as! UIButton
     
     elemento.isUserInteractionEnabled = false
     
     let elemento_ojo = elementos_lista[sender.tag]["elemento_ojo"] as! UIButton
     
     elemento_ojo.isUserInteractionEnabled = false
     
     let estructura_y = elementos_lista[sender.tag]["estructura_y"] as! Int
     
     
     aux_vista_scroll.setContentOffset(CGPointMake(0, sender.center.y-50), animated: true)
     
     
     //let posicion_x = elemento.frame.origin.x + elemento.frame.width
     
     let posicion_y = elemento.frame.origin.y + elemento.frame.height
     
     subestructura.frame = CGRect(x: aux_vista_scroll.bounds.maxX, y: posicion_y, width: aux_vista_scroll.frame.width, height: aux_vista_scroll.frame.height)
     
     aux_vista_scroll.addSubview(subestructura)
     
     aux_vista_scroll.bringSubview(toFront: subestructura)
     
     
     
     let subViews = self.subestructura.subviews
     for subview in subViews{
     subview.removeFromSuperview()
     }
     
     subestructura.setContentOffset(CGPointMake(0, 0), animated: false)
     
     let resultado_llenado = llenar_estructura(aux_vista_scroll: subestructura, elementos_estructura: aux_estructura,estructura_y: estructura_y,indice_subestructura: sender.tag)
     
     let colorTexto = resultado_llenado["color_texto0"] as! String
     
     //let inicio = resultado_llenado["inicio"] as! Int
     
     //let fin = resultado_llenado["fin"] as! Int
     
     
     let offset = estructura_y - 60
     
     //print("nuestro offset es de \(offset)")
     
     let b_agregar = UIButton()
     
     b_agregar.setTitle("\(sender.titleLabel!.text!) +  ", for: .normal)
     
     //print("el ancho de la subestructura es \(subestructura.frame.width)")
     
     b_agregar.frame = CGRect(x: Int(subestructura.frame.width/2), y: offset, width: Int(subestructura.frame.width/2) - 10, height: 50)
     
     
     
     b_agregar.setTitleColor(UIColor(rgba: "#\(colorTexto)"), for: .normal)
     
     
     b_agregar.titleLabel!.font = b_agregar.titleLabel?.font
     b_agregar.titleLabel!.textColor = UIColor(rgba: "#\(colorTexto)")
     b_agregar.titleLabel!.numberOfLines = 0
     b_agregar.titleLabel!.textAlignment = .right
     
     b_agregar.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
     
     b_agregar.titleLabel!.sizeToFit()
     
     b_agregar.tag = sender.tag
     
     b_agregar.addTarget(self, action:#selector(ModuloController.agregar_subestructura(_:)), for:.TouchDown)
     
     subestructura.addSubview(b_agregar)
     
     subestructura.bringSubview(toFront: b_agregar)
     
     
     elementos_lista[sender.tag]["b_agregar"] = b_agregar
     
     
     
     b_agregar.isHidden = true
     
     
     let b_cerrar = UIButton()
     
     b_cerrar.setTitle("  Cerrar ", for: .normal)
     
     //print("el ancho de la subestructura es \(subestructura.frame.width)")
     
     b_cerrar.frame = CGRect(x: 0, y: offset, width: Int(subestructura.frame.width/2) - 10, height: 50)
     
     
     
     b_cerrar.setTitleColor(UIColor(rgba: "#\(colorTexto)"), for: .normal)
     
     
     b_cerrar.titleLabel!.font = b_agregar.titleLabel?.font
     b_cerrar.titleLabel!.textColor = UIColor(rgba: "#\(colorTexto)")
     b_cerrar.titleLabel!.numberOfLines = 0
     b_cerrar.titleLabel!.textAlignment = .left
     
     b_cerrar.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
     
     b_cerrar.titleLabel!.sizeToFit()
     
     b_cerrar.tag = sender.tag
     
     b_cerrar.addTarget(self, action:#selector(ModuloController.cerrar_subestructura(_:)), for:.TouchDown)
     
     subestructura.addSubview(b_cerrar)
     
     subestructura.bringSubview(toFront: b_cerrar)
     
     
     //subestructura.contentSize = CGSizeMake(subestructura.contentSize.width, CGFloat(offset) + 300)
     
     /*let cuadro = dibujar_cuadro(CGSize(width: aux_vista_scroll.frame.width,height: CGFloat(offset) + 300), color: "FFFFFF")
     
     let aux_cuadro = UIImageView()
     
     
     aux_cuadro.frame = CGRect(x: 0, y: 0, width: Int(aux_vista_scroll.frame.width), height: offset+300 + Int(aux_vista_scroll.frame.height))
     
     aux_cuadro.image = cuadro
     
     
     subestructura.addSubview(aux_cuadro)
     
     subestructura.sendSubviewToBack(aux_cuadro)
     */
     
     
     UIView.animate(withDuration: 0.5, delay: 0.1, options: [],animations: {
     
     self.subestructura.frame.origin.x = 0
     // self.username.center.x += self.view.bounds.width
     }, completion: nil)
     
     
     
     
     
     }
     
     */
    //cerrar subestructura
    
    /*
     func agregar_subestructura(sender:UIButton){
     
     idReporteLocal = defaults.object(forKey: "idReporteLocal") as! Int
     
     let aux_subestructura = sender.superview as! UIScrollView
     
     let aux_vista_scroll = aux_subestructura.superview as! UIScrollView
     
     let id = elementos_lista[sender.tag]["id"] as! Int
     
     let aux_elemento = elementos_lista[sender.tag]["elemento"] as! UIButton
     
     aux_elemento.isUserInteractionEnabled = true
     
     var subViews = aux_subestructura.subviews
     for subview in subViews{
     
     
     for q in 0 ..< elementos_lista.count {
     
     if let _ = elementos_lista[q]["elemento"] as? UIView {
     
     if subview ==  elementos_lista[q]["elemento"] as? UIView{
     
     
     
     //print(elementos_lista[q])
     
     if elementos_lista[q]["valor_final"] as! String == "si" {
     
     let aux_opciones = elementos_lista[q]["opciones"] as! [[String:AnyObject]]
     
     for opcion in aux_opciones {
     
     if let seleccionado = opcion["seleccionado"] as? Bool {
     
     if seleccionado {
     
     var aux_elementos_nuevos:[[String:AnyObject]] = []
     
     if elementos_lista[sender.tag]["elementos_nuevos"] != nil {
     
     aux_elementos_nuevos = elementos_lista[sender.tag]["elementos_nuevos"] as! [[String:AnyObject]]
     
     }
     
     aux_elementos_nuevos.append(opcion)
     
     elementos_lista[sender.tag]["elementos_nuevos"] = aux_elementos_nuevos as AnyObject?
     
     
     //obtener o crear id reporte padre
     
     //print(elementos_lista[q])
     
     var sql = "select id from \(elementos_lista[q]["tabla_padre"] as! String) where \(elementos_lista[q]["id_padre_reporte"] as! String) = '\(elementos_lista[q]["id"]!)' and id_report_local = '\(idReporteLocal)'"
     
     //print(sql)
     
     let resultado_distribution = db.select_query_columns(sql)
     
     var id_padre = 0
     
     if resultado_distribution.count > 0 {
     
     for renglon in resultado_distribution {
     
     id_padre = renglon["id"] as! Int
     
     }
     
     }
     else{
     
     
     let tiempo_milisegundos = String(Int64(NSDate().timeIntervalSince1970*1000))
     
     let random = Int(arc4random_uniform(1000))
     
     let el_hash=String(tiempo_milisegundos) + String(describing: defaults.object(forKey: "idReporteLocal")!) + String(random)
     
     sql = "insert into report_distribution ('id_report_local','id_item','idMeasurement','precio','hash','is_send','distribution') values ('\(idReporteLocal)','\(elementos_lista[q]["id"]!)','idMeasurement','0','\(el_hash.md5())','0','0')"
     
     //print(sql)
     
     _ = db.execute_query(sql)
     
     sql = "select id from \(elementos_lista[q]["tabla_padre"] as! String) where \(elementos_lista[q]["id_padre"] as! String) = '\(elementos_lista[q]["id"]!)' and id_report_local = '\(idReporteLocal)'"
     
     let resultado_distribution = db.select_query_columns(sql)
     
     for renglon in resultado_distribution {
     
     id_padre = renglon["id"] as! Int
     
     }
     
     
     }
     
     
     //fin obtener o crear id reporte padre
     
     sql = "insert into \(elementos_lista[q]["tabla_guardar"]!) (\(elementos_lista[q]["columna_guardar"]!),\(elementos_lista[q]["columna_guardar_padre"]!),id_reporte_local) values ('\(opcion["id"]!)','\(id_padre)','\(idReporteLocal)')"
     
     //print(sql)
     
     let _ = db.execute_query(sql)
     
     //print(resultado_agregar_subestructura)
     
     }
     
     }
     
     }
     
     }
     
     elementos_lista.remove(at: q)
     
     break
     }
     }
     
     }
     
     
     
     
     }
     
     aux_subestructura.removeFromSuperview()
     
     self.aux_posicion.frame = CGRect(x: 10, y: 0, width: 50, height: 50)
     
     subViews = aux_vista_scroll.subviews
     for subview in subViews{
     
     if subview.frame.origin.y > aux_posicion.frame.origin.y {
     
     self.aux_posicion.frame = subview.frame
     
     }
     
     }
     
     
     
     aux_vista_scroll.contentSize = CGSizeMake(aux_vista_scroll.contentSize.width, aux_posicion.frame.origin.y +  aux_posicion.frame.size.height+300)
     
     let aux_boton_ojo = elementos_lista[sender.tag]["elemento_ojo"] as! UIButton
     
     aux_boton_ojo.isUserInteractionEnabled = true
     
     print("simon finalizo substructura de la id \(id)")
     
     
     }
     
     
     */
    //fin cerrar subestructura
    
    
    /*
     func cerrar_subestructura(sender:UIButton){
     
     idReporteLocal = defaults.object(forKey: "idReporteLocal") as! Int
     
     let aux_subestructura = sender.superview as! UIScrollView
     
     let aux_vista_scroll = aux_subestructura.superview as! UIScrollView
     
     let id = elementos_lista[sender.tag]["id"] as! Int
     
     let aux_elemento = elementos_lista[sender.tag]["elemento"] as! UIButton
     
     aux_elemento.isUserInteractionEnabled = true
     
     var subViews = aux_subestructura.subviews
     for subview in subViews{
     
     
     for q in 0 ..< elementos_lista.count {
     
     if let _ = elementos_lista[q]["elemento"] as? UIView {
     
     if subview ==  elementos_lista[q]["elemento"] as? UIView{
     
     
     elementos_lista.remove(at: q)
     
     break
     }
     }
     
     }
     
     
     
     
     }
     
     aux_subestructura.removeFromSuperview()
     
     self.aux_posicion.frame = CGRect(x: 10, y: 0, width: 50, height: 50)
     
     subViews = aux_vista_scroll.subviews
     for subview in subViews{
     
     if subview.frame.origin.y > aux_posicion.frame.origin.y {
     
     self.aux_posicion.frame = subview.frame
     
     }
     
     }
     
     
     
     aux_vista_scroll.contentSize = CGSizeMake(aux_vista_scroll.contentSize.width, aux_posicion.frame.origin.y +  aux_posicion.frame.size.height+300)
     
     if let _ = elementos_lista[sender.tag]["elementos_nuevos"] as? [[String:AnyObject]] {
     
     let aux_boton_ojo = elementos_lista[sender.tag]["elemento_ojo"] as! UIButton
     
     aux_boton_ojo.isUserInteractionEnabled = true
     
     }
     
     print("simon cerro substructura de la id \(id)")
     
     
     }
     */
    /*
     func mostrar_elementos_subestructura(sender:UIButton){
     
     
     //print("simon subestructura")
     
     let aux_vista_scroll = sender.superview as! UIScrollView
     
     
     
     aux_vista_scroll.frame = CGRect(x: 0, y: 0, width: self.view.frame.width+10, height: self.view.frame.height)
     
     
     
     aux_vista_scroll.contentSize = CGSizeMake(aux_vista_scroll.contentSize.width, aux_vista_scroll.frame.height)
     
     //print(elementos_lista[sender.tag])
     
     
     let aux_elementos = elementos_lista[sender.tag]["elementos_nuevos"] as! [[String:AnyObject]]
     
     let elemento = elementos_lista[sender.tag]["elemento"] as! UIButton
     
     elemento.isUserInteractionEnabled = false
     
     let elemento_ojo = elementos_lista[sender.tag]["elemento_ojo"] as! UIButton
     
     elemento_ojo.isUserInteractionEnabled = false
     
     //let estructura_y = elementos_lista[sender.tag]["estructura_y"] as! Int
     
     
     aux_vista_scroll.setContentOffset(CGPointMake(0, sender.center.y-50), animated: true)
     
     
     //let posicion_x = elemento.frame.origin.x + elemento.frame.width
     
     let posicion_y = elemento.frame.origin.y + elemento.frame.height
     
     subestructura.frame = CGRect(x: aux_vista_scroll.bounds.maxX, y: posicion_y, width: aux_vista_scroll.frame.width, height: aux_vista_scroll.frame.height)
     
     aux_vista_scroll.addSubview(subestructura)
     
     aux_vista_scroll.bringSubview(toFront: subestructura)
     
     
     
     let subViews = self.subestructura.subviews
     for subview in subViews{
     subview.removeFromSuperview()
     }
     
     subestructura.setContentOffset(CGPointMake(0, 0), animated: false)
     
     //let resultado_llenado = llenar_estructura(subestructura, elementos_estructura: aux_estructura,estructura_y: estructura_y)
     
     var offset:CGFloat = 21
     
     for elemento in aux_elementos {
     
     let nuevo_label = UILabel()
     
     nuevo_label.text = elemento["opcion"] as? String
     
     
     //nuevo_label.textColor = UIColor(rgba: "#\(colorTexto)")
     nuevo_label.numberOfLines = 0
     nuevo_label.textAlignment = .center
     
     nuevo_label.frame = CGRect(x: 0, y: offset, width: subestructura.frame.width, height: 50)
     
     offset += 60
     
     subestructura.addSubview(nuevo_label)
     
     }
     
     
     let cuadro = dibujar_cuadro(CGSize(width: aux_vista_scroll.frame.width,height: offset + 60), color: "FFFFFF")
     
     let aux_cuadro = UIImageView()
     
     
     aux_cuadro.frame = CGRect(x: 0, y: 0, width: subestructura.frame.width, height: offset + 60)
     
     aux_cuadro.image = cuadro
     
     
     subestructura.addSubview(aux_cuadro)
     
     subestructura.sendSubview(toBack: aux_cuadro)
     
     
     
     //let colorTexto = resultado_llenado["color_texto0"] as! String
     
     //let inicio = resultado_llenado["inicio"] as! Int
     
     //let fin = resultado_llenado["fin"] as! Int
     
     
     
     
     //print("nuestro offset es de \(offset)")
     
     let b_cerrar = UIButton()
     
     b_cerrar.setTitle("Cerrar", for: .normal)
     
     //print("el ancho de la subestructura es \(subestructura.frame.width) y el offset es \(offset)")
     
     b_cerrar.frame = CGRect(x: 0, y: offset, width: subestructura.frame.width - 10, height: 50)
     
     
     
     b_cerrar.setTitleColor(UIColor(rgba: "#000000"), for: .normal)
     
     
     b_cerrar.titleLabel!.font = b_cerrar.titleLabel?.font
     b_cerrar.titleLabel!.textColor = UIColor(rgba: "#000000")
     b_cerrar.titleLabel!.numberOfLines = 0
     b_cerrar.titleLabel!.textAlignment = .right
     
     b_cerrar.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
     
     b_cerrar.titleLabel!.sizeToFit()
     
     b_cerrar.tag = sender.tag
     
     b_cerrar.addTarget(self, action:#selector(ModuloController.ocultar_subestructura(_:)), for:.TouchDown)
     
     subestructura.addSubview(b_cerrar)
     
     subestructura.bringSubview(toFront: b_cerrar)
     
     subestructura.contentSize = CGSizeMake(subestructura.contentSize.width, offset+300)
     
     
     UIView.animate(withDuration: 0.5, delay: 0.1, options: [],animations: {
     
     self.subestructura.frame.origin.x = 0
     // self.username.center.x += self.view.bounds.width
     }, completion: nil)
     
     
     
     
     }
     
     */
    /*
     func ocultar_subestructura(sender:UIButton){
     
     
     let aux_subestructura = sender.superview as! UIScrollView
     
     let aux_vista_scroll = aux_subestructura.superview as! UIScrollView
     
     let id = elementos_lista[sender.tag]["id"] as! Int
     
     let aux_elemento = elementos_lista[sender.tag]["elemento"] as! UIButton
     
     aux_elemento.isUserInteractionEnabled = true
     
     
     aux_subestructura.removeFromSuperview()
     
     aux_vista_scroll.contentSize = CGSizeMake(aux_vista_scroll.contentSize.width, aux_posicion.frame.origin.y +  aux_posicion.frame.size.height+300)
     
     let aux_boton_ojo = elementos_lista[sender.tag]["elemento_ojo"] as! UIButton
     
     aux_boton_ojo.isUserInteractionEnabled = true
     
     print("simon finalizo substructura de la id \(id)")
     
     
     }
     */
    //fin mostrar subestructura
    
    
    //mostrar filtro
    
    
    @objc func mostrar_filtro(sender:UIButton){
        
        print("mostrar filtro")
        
        
        
        
        let aux_vista_scroll = sender.superview
        /*
         
         
         aux_vista_scroll.frame = CGRect(x: 0, y: 0, width: self.view.frame.width+10, height: self.view.frame.height)
         
         
         
         aux_vista_scroll.contentSize = CGSizeMake(aux_vista_scroll.contentSize.width, aux_vista_scroll.frame.height)
         
         //print(elementos_lista[sender.tag])
         */
        
        let elementos_estructura = elementos["estructura"] as! [[String:AnyObject]]
        
        let aux_opciones = elementos_estructura[sender.tag]["opciones"] as! [[String:AnyObject]]
        
        //let elemento = elementos_lista[sender.tag]["elemento"] as! UIButton
        
        //elemento.userInteractionEnabled = false
        
        
        
        
        subestructura.frame = CGRect(x: aux_vista_scroll!.bounds.maxX, y: sender.frame.origin.y + sender.frame.height, width: aux_vista_scroll!.frame.width, height: aux_vista_scroll!.frame.height)
        
        aux_vista_scroll!.addSubview(subestructura)
        
        aux_vista_scroll!.bringSubview(toFront: subestructura)
        
        
        
        let subViews = self.subestructura.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        
        // subestructura.setContentOffset(CGPointMake(0, 0), animated: false)
        
        //let resultado_llenado = llenar_estructura(subestructura, elementos_estructura: aux_estructura,estructura_y: estructura_y)
        
        var offset:CGFloat = 21
        
        for opcion in aux_opciones {
            
            let nuevo_boton = UIButton()
            
            
            nuevo_boton.setAttributedTitle(nil, for: .normal)
            nuevo_boton.setTitle(opcion["texto"] as? String, for: .normal)
            
            nuevo_boton.isSelected = false
            nuevo_boton.setTitleColor(UIColor(rgba: "#000000"), for: .normal)
            
            
            
            nuevo_boton.titleLabel!.font = UIFont(name: "TitilliumWeb-SemiBold", size: 4)
            
            nuevo_boton.titleLabel!.font = nuevo_boton.titleLabel!.font.withSize(16)
            
            nuevo_boton.titleLabel!.textColor = UIColor(rgba: "#000000")
            nuevo_boton.titleLabel!.numberOfLines = 0
            nuevo_boton.titleLabel!.textAlignment = .center
            nuevo_boton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
            
            nuevo_boton.tag = sender.tag
            
            
            //nuevo_label.textColor = UIColor(rgba: "#\(colorTexto)")
            
            
            nuevo_boton.frame = CGRect(x: 0, y: offset, width: subestructura.frame.width, height: 50)
            
            nuevo_boton.addTarget(self, action:#selector(ModuloController.mostrar_opciones_filtro(sender:)), for:.touchDown)
            
            offset += 60
            
            subestructura.addSubview(nuevo_boton)
            
        }
        
        
        
        
        
        
        //let colorTexto = resultado_llenado["color_texto0"] as! String
        
        //let inicio = resultado_llenado["inicio"] as! Int
        
        //let fin = resultado_llenado["fin"] as! Int
        
        
        
        
        //print("nuestro offset es de \(offset)")
        
        
        let b_sin_filtro = UIButton()
        
        b_sin_filtro.setTitle("Quitar Filtro", for: .normal)
        
        //print("el ancho de la subestructura es \(subestructura.frame.width) y el offset es \(offset)")
        
        b_sin_filtro.frame = CGRect(x: 0, y: offset, width: subestructura.frame.width - 10, height: 50)
        
        
        
        b_sin_filtro.setTitleColor(UIColor(rgba: "#000000"), for: .normal)
        
        
        b_sin_filtro.titleLabel!.font = b_sin_filtro.titleLabel?.font
        b_sin_filtro.titleLabel!.textColor = UIColor(rgba: "#000000")
        b_sin_filtro.titleLabel!.numberOfLines = 0
        b_sin_filtro.titleLabel!.textAlignment = .center
        
        b_sin_filtro.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        
        b_sin_filtro.titleLabel!.sizeToFit()
        
        b_sin_filtro.tag = sender.tag
        
        b_sin_filtro.addTarget(self, action:#selector(ModuloController.quitar_filtro(sender:)), for:.touchDown)
        
        subestructura.addSubview(b_sin_filtro)
        
        subestructura.bringSubview(toFront: b_sin_filtro)
        
        offset += 60
        
        
        
        let b_cerrar = UIButton()
        
        b_cerrar.setTitle("Cerrar", for: .normal)
        
        //print("el ancho de la subestructura es \(subestructura.frame.width) y el offset es \(offset)")
        
        b_cerrar.frame = CGRect(x: 0, y: offset, width: subestructura.frame.width - 10, height: 50)
        
        
        
        b_cerrar.setTitleColor(UIColor(rgba: "#000000"), for: .normal)
        
        
        b_cerrar.titleLabel!.font = b_cerrar.titleLabel?.font
        b_cerrar.titleLabel!.textColor = UIColor(rgba: "#000000")
        b_cerrar.titleLabel!.numberOfLines = 0
        b_cerrar.titleLabel!.textAlignment = .center
        
        b_cerrar.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        
        b_cerrar.titleLabel!.sizeToFit()
        
        b_cerrar.tag = sender.tag
        
        b_cerrar.addTarget(self, action:#selector(ModuloController.ocultar_filtro(sender:)), for:.touchDown)
        
        subestructura.addSubview(b_cerrar)
        
        subestructura.bringSubview(toFront: b_cerrar)
        
        subestructura.contentSize = CGSize(width: subestructura.contentSize.width, height: offset+300)
        
        
        
        let cuadro = dibujar_cuadro(CGSize(width: aux_vista_scroll!.frame.width,height: offset + 60), color: "FFFFFF")
        
        let aux_cuadro = UIImageView()
        
        
        aux_cuadro.frame = CGRect(x: 0, y: 0, width: subestructura.frame.width, height: offset + 60)
        
        aux_cuadro.image = cuadro
        
        
        subestructura.addSubview(aux_cuadro)
        
        subestructura.sendSubview(toBack: aux_cuadro)
        
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [],animations: {
            
            self.subestructura.frame.origin.x = 0
            // self.username.center.x += self.view.bounds.width
        }, completion: nil)
        
        
    }
    
    //fin mostrar filtro
    
    //quitar filtro
    
    
    @objc func quitar_filtro(sender:UIButton?=nil){
        
        
        subestructura.removeFromSuperview()
        
        let subViews = self.laVista.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        
        var renglones = 0
        
        var offset_lista:CGFloat = 0
        
        defaults.set(1, forKey: "moduloDistribucion")
        for aux_grupo in elementos_lista_grupos{
            
            
            
            let datos = acomodar_objetos(indices: aux_grupo["elementos"] as! [Int], offset_lista: offset_lista,renglones: renglones)
            
            renglones += 1
            
            offset_lista = datos["offset_lista"] as! CGFloat
            
            
            
        }
        
        let controladorActual = UIApplication.topViewController()
        
        let subvistas = controladorActual?.view!.subviews
        
        for subvista in subvistas! where subvista.tag == 179 {
        
        subvista.removeFromSuperview()
            
        }
    }
    
    
    //fin quitar filtro
    
    
    //ocultar filtro
    
    
    @objc func ocultar_filtro(sender:UIButton){
        
        
        sender.superview?.removeFromSuperview()
        
        
    }
    
    //fin ocultar filtro
    
    
    //mostrar opciones filtro
    
    
    @objc func mostrar_opciones_filtro(sender:UIButton){
        
        print("mostrando opciones filtro")
        
        let aux_vista_scroll = sender.superview
        /*
         
         
         aux_vista_scroll.frame = CGRect(x: 0, y: 0, width: self.view.frame.width+10, height: self.view.frame.height)
         
         
         
         aux_vista_scroll.contentSize = CGSizeMake(aux_vista_scroll.contentSize.width, aux_vista_scroll.frame.height)
         
         //print(elementos_lista[sender.tag])
         */
        
        let elementos_estructura = elementos["estructura"] as! [[String:AnyObject]]
        
        let aux_opciones = elementos_estructura[sender.tag]["opciones"] as! [[String:AnyObject]]
        
        //let elemento = elementos_lista[sender.tag]["elemento"] as! UIButton
        
        //elemento.userInteractionEnabled = false
        
        
        
        
        //subestructura.frame = CGRect(x: aux_vista_scroll!.bounds.maxX, y: sender.frame.origin.y + sender.frame.height, width: aux_vista_scroll!.frame.width, height: aux_vista_scroll!.frame.height)
        
        //aux_vista_scroll!.addSubview(subestructura)
        
        //aux_vista_scroll!.bringSubviewToFront(subestructura)
        
        
        
        let subViews = self.subestructura.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        
        //subestructura.setContentOffset(CGPointMake(0, 0), animated: false)
        
        //let resultado_llenado = llenar_estructura(subestructura, elementos_estructura: aux_estructura,estructura_y: estructura_y)
        
        var k = 0
        
        for opcion in aux_opciones{
            
            
            if opcion["texto"] as? String == sender.titleLabel?.text! {
                
                break
            }
            
            k += 1
            
        }
        
        
        let sql = aux_opciones[k]["query"] as! String
        
        //print(sql)
        
        let resultado_opciones_filtro = db.select_query_columns(sql)
        
        var offset:CGFloat = 21
        
        for filtro in resultado_opciones_filtro {
            
            let nuevo_boton = filtroButton()
            
            
            nuevo_boton.setAttributedTitle(nil, for: .normal)
            nuevo_boton.setTitle(filtro[aux_opciones[k]["columna_filtro"] as! String] as? String, for: .normal)
            
            nuevo_boton.isSelected = false
            nuevo_boton.setTitleColor(UIColor(rgba: "#000000"), for: .normal)
            
            
            
            nuevo_boton.titleLabel!.font = UIFont(name: "TitilliumWeb-SemiBold", size: 4)
            
            nuevo_boton.titleLabel!.font = nuevo_boton.titleLabel!.font.withSize(16)
            
            nuevo_boton.titleLabel!.textColor = UIColor(rgba: "#000000")
            nuevo_boton.titleLabel!.numberOfLines = 0
            nuevo_boton.titleLabel!.textAlignment = .center
            nuevo_boton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
            
            
            
            
            //nuevo_label.textColor = UIColor(rgba: "#\(colorTexto)")
            
            
            nuevo_boton.frame = CGRect(x: 0, y: offset, width: subestructura.frame.width, height: 50)
            
            nuevo_boton.columna = aux_opciones[k]["columna_filtro"] as? String
            
            nuevo_boton.id = filtro["id"] as? Int
            
            nuevo_boton.addTarget(self, action:#selector(ModuloController.ejecutar_filtro(sender:)), for:.touchDown)
            
            offset += 60
            
            subestructura.addSubview(nuevo_boton)
            
        }
        
        
        let cuadro = dibujar_cuadro(CGSize(width: aux_vista_scroll!.frame.width,height: offset + 60), color: "FFFFFF")
        
        let aux_cuadro = UIImageView()
        
        
        aux_cuadro.frame = CGRect(x: 0, y: 0, width: subestructura.frame.width, height: offset + 60)
        
        aux_cuadro.image = cuadro
        
        
        subestructura.addSubview(aux_cuadro)
        
        subestructura.sendSubview(toBack: aux_cuadro)
        
        
        
        //let colorTexto = resultado_llenado["color_texto0"] as! String
        
        //let inicio = resultado_llenado["inicio"] as! Int
        
        //let fin = resultado_llenado["fin"] as! Int
        
        
        
        
        //print("nuestro offset es de \(offset)")
        
        let b_cerrar = UIButton()
        
        b_cerrar.setTitle("Cerrar", for: .normal)
        
        //print("el ancho de la subestructura es \(subestructura.frame.width) y el offset es \(offset)")
        
        b_cerrar.frame = CGRect(x: 0, y: offset, width: subestructura.frame.width - 10, height: 50)
        
        
        
        b_cerrar.setTitleColor(UIColor(rgba: "#000000"), for: .normal)
        
        
        b_cerrar.titleLabel!.font = b_cerrar.titleLabel?.font
        b_cerrar.titleLabel!.textColor = UIColor(rgba: "#000000")
        b_cerrar.titleLabel!.numberOfLines = 0
        b_cerrar.titleLabel!.textAlignment = .center
        
        b_cerrar.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        
        b_cerrar.titleLabel!.sizeToFit()
        
        b_cerrar.tag = sender.tag
        
        b_cerrar.addTarget(self, action:#selector(ModuloController.ocultar_filtro(sender:)), for:.touchDown)
        
        subestructura.addSubview(b_cerrar)
        
        subestructura.bringSubview(toFront: b_cerrar)
        
        subestructura.contentSize = CGSize(width:subestructura.contentSize.width, height: offset+300)
        
        
    }
    
    //fin mostrar opciones filtro
    
    
    //ejecutar filtro
    
    
    @objc func ejecutar_filtro(sender:filtroButton){
        
        subestructura.removeFromSuperview()
        
        let subViews = self.laVista.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        
        var renglones = 0
        
        var offset_lista:CGFloat = 0
        
        print(elementos_lista_grupos)
        
        defaults.set(1, forKey: "moduloDistribucion")
        for aux_grupo in elementos_lista_grupos where (aux_grupo["filtro"] as! String).contains(sender.titleLabel!.text!) {
            
            print("este es el grupo")
            print(aux_grupo)
            print("esta es la columna")
            print(sender.columna!)
            
            
            
            /*for aux_indice in aux_grupo["elementos"] as! [Int] {
             
             print(elementos_lista[aux_indice])
             
             if let aux_elemento_lista = elementos_lista[aux_indice]["elemento"] as? UIView {
             
             VistaScroll.addSubview(aux_elemento_lista)
             
             }
             
             }
             */
            
            let datos = acomodar_objetos(indices: aux_grupo["elementos"] as! [Int], offset_lista: offset_lista,renglones: renglones)
            
            renglones += 1
            
            offset_lista = datos["offset_lista"] as! CGFloat
            
            
            
        }
        
    }
    
    //fin ejecutar filtro
    
    
    
    
    
    
    //acomodar objetos
    
    
    func acomodar_objetos(indices:[Int],offset_lista:CGFloat,renglones:Int)->[String:AnyObject]{
        
        
        
        var offset_lista = offset_lista
        
        var indice_cabecera = 0
        
        let elementos_estructura = elementos["estructura"] as! [[String:AnyObject]]
        
        let estructura_y = elementos["estructura_y"] as! Int
        
        let aux_vista_scroll = laVista
        
        for renglon in elementos_estructura {
            
            if renglon["tipo"] as! String != "CABECERA" {
                
                indice_cabecera += 1
            }
            else{
                
                break
                
            }
            
        }
        
        //let base = defaults.object(forKey: "base") as! String
        
        //db.open_database(base)
        
        
        //let sql = "select t2.idItemRelation,t2.value,t2.idMeasurement,t1.description,t1.startDate,t1.endDate,t1.extra1 from ma_sku t2 left join ma_availability t1 where t1.id = t2.idMeasurement"
        
        
        let color_renglon = elementos_estructura[indice_cabecera]["color_renglon"] as! String
        let color_texto0 = elementos_estructura[indice_cabecera]["color_texto0"] as! String
        let color_texto1 = elementos_estructura[indice_cabecera]["color_texto1"] as! String
        
        //print(renglones)
        
        var color_texto = ""
        
        if renglones % 2 == 0 {
            
            el_constructor.colorTexto = color_texto1
            
            color_texto = color_texto0
            
            let cuadro = dibujar_cuadro(CGSize(width: (aux_vista_scroll?.frame.width)!, height: CGFloat(estructura_y)),color:color_renglon)
            
            let aux_cuadro = UIImageView()
            
            
            aux_cuadro.frame = CGRect(x: 0, y: CGFloat(offset_lista), width: (aux_vista_scroll?.frame.width)!, height: CGFloat(estructura_y))
            
            aux_cuadro.image = cuadro
            
            //aux_vista_scroll?.addSubview(aux_cuadro)
            
            //aux_vista_scroll?.sendSubview(toBack: aux_cuadro)
            
        }
        else{
            
            el_constructor.colorTexto = color_texto0
            
            color_texto = color_texto1
            
        }
        
        
        let indice_grupo = elementos_lista[indices[0]]["indice_grupo"] as! Int
        
        
        //cambio de color de renglon
        
        var auxRadioNo = 0
        
        var auxRadioSi = 0
        
        var precios = 0
        
        var fotos = 0
        
        var aux_b_foto:UIButton = UIButton()
        
        for aux_indice in indices where elementos_lista[aux_indice]["tipo"] as! String == "SELECT_ONE_RADIO" || elementos_lista[aux_indice]["tipo"] as! String == "REAL" || elementos_lista[aux_indice]["tipo"] as! String == "NUMERIC" || elementos_lista[aux_indice]["tipo"] as! String == "FOTO" {
            
            let aux_elemento = elementos_lista[aux_indice]
            
            //print(aux_elemento)
            
            switch aux_elemento["tipo"] as! String{
                
            case "FOTO":
                
                if aux_elemento["fotos"] != nil {
                    
                    fotos = (aux_elemento["fotos"] as! [[String:AnyObject]]).count
                    
                }
                
                aux_b_foto = aux_elemento["elemento"] as! UIButton
                
            case "REAL","NUMERIC":
                
                
                let aux_campo_texto = aux_elemento["elemento"] as! UITextField
                
                if aux_campo_texto.text == "0" {
                    
                    precios += 1
                    
                }
                
            case "SELECT_ONE_RADIO":
                
                //print(aux_elemento)
                
                
                
                
                let aux_botontes = aux_elemento["botones"] as! [[String:AnyObject]]
                
                
                
                for boton in aux_botontes {
                    
                    print(boton)
                    
                    switch (boton["opcion"] as! UILabel).text! {
                        
                    case "No" :
                        if boton["seleccionado"] as! NSNumber == 1 {
                            
                            auxRadioNo = 1
                        }
                    case "Si" :
                        if boton["seleccionado"] as! NSNumber == 1 {
                            
                            auxRadioSi = 1
                        }
                    default:
                        break
                    }
                    
                    
                    
                    
                    
                }
                
                
                
                
                
            default:
                print("tipo no manejado al llenar acomodar \(String(describing: aux_elemento["tipo"]))")
            }
            
            
        }
        
        if auxRadioNo == 1{
            
            aux_b_foto.isHidden = true
            
        }
        if auxRadioSi == 1 {
            
            aux_b_foto.isHidden = false
            
        }
        
        
        if (auxRadioSi == 1 && precios == 2) || (auxRadioNo == 0 && auxRadioSi == 0) || (auxRadioSi == 1 && fotos == 0) {
            
            defaults.set(0, forKey: "moduloDistribucion")
            
            el_constructor.colorTexto = "FFFFFF"
            
            color_texto = "FFFFFF"
            
            let cuadro = dibujar_cuadro(CGSize(width: (aux_vista_scroll?.frame.width)!, height: CGFloat(estructura_y)),color:"c70752")
            
            let aux_cuadro = UIImageView()
            
            
            
            aux_cuadro.frame = CGRect(x: 0, y: CGFloat(offset_lista), width: (aux_vista_scroll?.frame.width)!, height: CGFloat(estructura_y))
            
            aux_cuadro.image = cuadro
            
            aux_vista_scroll?.addSubview(aux_cuadro)
            
            aux_vista_scroll?.sendSubview(toBack: aux_cuadro)
            
            elementos_lista_grupos[indice_grupo]["cuadro"] = aux_cuadro as AnyObject
            
        }
        else{
            
            
            let cuadro = dibujar_cuadro(CGSize(width: (aux_vista_scroll?.frame.width)!, height: CGFloat(estructura_y)),color:"FFFFFF")
            
            let aux_cuadro = UIImageView()
            
            
            
            aux_cuadro.frame = CGRect(x: 0, y: CGFloat(offset_lista), width: (aux_vista_scroll?.frame.width)!, height: CGFloat(estructura_y))
            
            aux_cuadro.image = cuadro
            
            aux_vista_scroll?.addSubview(aux_cuadro)
            
            aux_vista_scroll?.sendSubview(toBack: aux_cuadro)
            
            elementos_lista_grupos[indice_grupo]["cuadro"] = aux_cuadro as AnyObject
            
        }
        
        
        
        
        //fin cambio de color de renglon
        
        
        elementos_lista_grupos[indice_grupo]["origen"] = offset_lista as AnyObject
        
        for aux_indice in indices {
            
            let aux_elemento = elementos_lista[aux_indice]
            
            //print(aux_elemento)
            
            switch aux_elemento["tipo"] as! String{
                
            case "LABEL":
                
                let aux_elemento_lista = aux_elemento["elemento"] as! UILabel
                
                aux_elemento_lista.textColor = UIColor(rgba: "#\(color_texto)")
                
                aux_elemento_lista.frame.origin.y = aux_elemento["y_original"] as! CGFloat + CGFloat(offset_lista)
                
                laVista.addSubview(aux_elemento_lista)
                
            case "SELECT_ONE_RADIO":
                
                //print(aux_elemento)
                
                let aux_label = aux_elemento["label"] as! UILabel
                
                aux_label.textColor = UIColor(rgba: "#\(color_texto)")
                
                aux_label.frame.origin.y = aux_elemento["label_y_original"] as! CGFloat + CGFloat(offset_lista)
                
                laVista.addSubview(aux_label)
                
                
                let aux_botontes = aux_elemento["botones"] as! [[String:AnyObject]]
                
                var auxRadio = 0
                
                for boton in aux_botontes {
                    
                    //print(boton)
                    
                    if boton["seleccionado"] as! NSNumber == 0 {
                        
                        auxRadio += 1
                        
                        
                        
                        
                    }
                    
                    let aux_boton = boton["elemento"] as! UIButton
                    
                    aux_boton.frame.origin.y = boton["y_original"] as! CGFloat + CGFloat(offset_lista)
                    
                    let aux_opcion = boton["opcion"] as! UILabel
                    
                    aux_opcion.textColor = UIColor(rgba: "#\(color_texto)")
                    
                    aux_opcion.frame.origin.y = boton["opcion_y_original"] as! CGFloat + CGFloat(offset_lista)
                    
                    laVista.addSubview(aux_boton)
                    laVista.addSubview(aux_opcion)
                    
                }
                
                if auxRadio > 1 {
                    
                    el_constructor.colorTexto = color_texto1
                    
                    color_texto = color_texto0
                    
                    let cuadro = dibujar_cuadro(CGSize(width: (aux_vista_scroll?.frame.width)!, height: CGFloat(estructura_y)),color:"c70752")
                    
                    let aux_cuadro = UIImageView()
                    
                    
                    aux_cuadro.frame = CGRect(x: 0, y: CGFloat(offset_lista), width: (aux_vista_scroll?.frame.width)!, height: CGFloat(estructura_y))
                    
                    aux_cuadro.image = cuadro
                    
                    aux_vista_scroll?.addSubview(aux_cuadro)
                    
                    aux_vista_scroll?.sendSubview(toBack: aux_cuadro)
                    
                }
                
            case "REAL", "NUMERIC":
                
                let aux_campo_texto = aux_elemento["elemento"] as! UITextField
                
                aux_campo_texto.frame.origin.y = aux_elemento["y_original"] as! CGFloat + CGFloat(offset_lista)
                
                let aux_label = aux_elemento["label"] as! UILabel
                
                aux_label.textColor = UIColor(rgba: "#\(color_texto)")
                
                aux_label.frame.origin.y = aux_elemento["label_y_original"] as! CGFloat + CGFloat(offset_lista)
                
                laVista.addSubview(aux_campo_texto)
                laVista.addSubview(aux_label)
                
            case "FOTO":
                
                let aux_elemento_lista = aux_elemento["elemento"] as! UIButton
                
                aux_elemento_lista.titleLabel!.textColor = UIColor(rgba: "#\(color_texto)")
                
                aux_elemento_lista.frame.origin.y = aux_elemento["y_original"] as! CGFloat + CGFloat(offset_lista)
                
                laVista.addSubview(aux_elemento_lista)
                
            case "SELECT_ONE_SPINNER":
                
                
                let aux_elemento_lista = aux_elemento["elemento"] as! UIButton
                
                aux_elemento_lista.setTitleColor(UIColor(rgba: "#\(color_texto)"), for: .normal)
                
                aux_elemento_lista.titleLabel!.textColor = UIColor(rgba: "#\(color_texto)")
                
                aux_elemento_lista.frame.origin.y = aux_elemento["y_original"] as! CGFloat + CGFloat(offset_lista)
                
                laVista.addSubview(aux_elemento_lista)
                
            case "SUBESTRUCTURA":
                
                let aux_elemento_lista = aux_elemento["elemento"] as! UIButton
                
                aux_elemento_lista.titleLabel!.textColor = UIColor(rgba: "#\(color_texto)")
                
                aux_elemento_lista.frame.origin.y = aux_elemento["y_original"] as! CGFloat + CGFloat(offset_lista)
                
                let aux_elemento_lista_ojo = aux_elemento["elemento_ojo"] as! UIButton
                
                aux_elemento_lista_ojo.frame.origin.y = aux_elemento["y_original"] as! CGFloat + CGFloat(offset_lista)
                
                laVista.addSubview(aux_elemento_lista)
                laVista.addSubview(aux_elemento_lista_ojo)
                
                
            default:
                print("tipo no manejado al llenar acomodar \(String(describing: aux_elemento["tipo"]))")
            }
            
            
        }
        
        
        offset_lista += CGFloat(estructura_y)
        
        
        
        
        
        self.aux_posicion.frame = CGRect(x: 10, y: offset_lista, width: 50, height: 50)
        
        aux_vista_scroll?.contentSize = CGSize(width: (aux_vista_scroll?.contentSize.width)!, height: aux_posicion.frame.origin.y +  aux_posicion.frame.size.height+300)
        
        
        let datos = ["offset_lista":offset_lista,"renglones":renglones] as [String : Any]
        
        return datos as [String : AnyObject]
    }
    
    
    //fin acomodar objetos
    
    
    
    
    
    //acomodar objetos color
    
    
    func acomodar_objetosColor(indices:[Int]){
        
        
        
        var indice_cabecera = 0
        
        let elementos_estructura = elementos["estructura"] as! [[String:AnyObject]]
        
        let estructura_y = elementos["estructura_y"] as! Int
        
        let aux_vista_scroll = laVista
        
        for renglon in elementos_estructura {
            
            if renglon["tipo"] as! String != "CABECERA" {
                
                indice_cabecera += 1
            }
            else{
                
                break
                
            }
            
        }
        
        //let base = defaults.object(forKey: "base") as! String
        
        //db.open_database(base)
        
        
        //let sql = "select t2.idItemRelation,t2.value,t2.idMeasurement,t1.description,t1.startDate,t1.endDate,t1.extra1 from ma_sku t2 left join ma_availability t1 where t1.id = t2.idMeasurement"
        
        
        var color_renglon = "FFFFFF"
        
        //print(renglones)
        
        var color_texto = ""
        
        
        
        
        
        var cuadro = dibujar_cuadro(CGSize(width: (aux_vista_scroll?.frame.width)!, height: CGFloat(estructura_y)),color:color_renglon)
        
        
        
        let indice_grupo = elementos_lista[indices[0]]["indice_grupo"] as! Int
        
        
        
        var auxRadioNo = 0
        
        var auxRadioSi = 0
        
        var precios = 0
        
        var fotos = 0
        
        var aux_b_foto:UIButton = UIButton()
        
        var campos:[UITextField] = []
        
        for aux_indice in indices where elementos_lista[aux_indice]["tipo"] as! String == "SELECT_ONE_RADIO" || elementos_lista[aux_indice]["tipo"] as! String == "REAL" || elementos_lista[aux_indice]["tipo"] as! String == "NUMERIC" || elementos_lista[aux_indice]["tipo"] as! String == "FOTO" {
            
            let aux_elemento = elementos_lista[aux_indice]
            
            //print(aux_elemento)
            
            switch aux_elemento["tipo"] as! String{
                
                
            case "FOTO":
                
                if aux_elemento["fotos"] != nil {
                    
                    fotos = (aux_elemento["fotos"] as! [[String:AnyObject]]).count
                    
                }
                
                
                aux_b_foto = aux_elemento["elemento"] as! UIButton
                
            case "REAL","NUMERIC":
                
                
                let aux_campo_texto = aux_elemento["elemento"] as! UITextField
                
                if aux_campo_texto.text == "0" {
                    
                    precios += 1
                    
                }
                
                campos.append(aux_campo_texto)
                
            case "SELECT_ONE_RADIO":
                
                //print(aux_elemento)
                
                
                
                
                let aux_botontes = aux_elemento["botones"] as! [[String:AnyObject]]
                
                
                
                for boton in aux_botontes {
                    
                    print(boton)
                    
                    switch (boton["opcion"] as! UILabel).text! {
                        
                    case "No" :
                        if boton["seleccionado"] as! NSNumber == 1 {
                            
                            auxRadioNo = 1
                        }
                    case "Si" :
                        if boton["seleccionado"] as! NSNumber == 1 {
                            
                            auxRadioSi = 1
                        }
                    default:
                        break
                    }
                    
                    
                    
                    
                    
                }
                
                
                
                
                
            default:
                print("tipo no manejado al llenar acomodar \(String(describing: aux_elemento["tipo"]))")
            }
            
            
        }
        
        
        if auxRadioNo == 1 {
            
            aux_b_foto.isHidden = true
            
            for campo in campos {
                
                campo.text = "0"
                
            }
            
        }
        
        if auxRadioSi == 1 {
            
            aux_b_foto.isHidden = false
            
        }
        
        
        if (auxRadioSi == 1 && precios == 2) || (auxRadioNo == 0 && auxRadioSi == 0) || (auxRadioSi == 1 && fotos == 0) {
            
            defaults.set(0, forKey: "moduloDistribucion")
            
            color_renglon = "c70752"
            cuadro = dibujar_cuadro(CGSize(width: (aux_vista_scroll?.frame.width)!, height: CGFloat(estructura_y)),color:color_renglon)
            color_texto = "FFFFFF"
            
            
        }
        else{
            
            
            
            color_renglon = "FFFFFF"
            cuadro = dibujar_cuadro(CGSize(width: (aux_vista_scroll?.frame.width)!, height: CGFloat(estructura_y)),color:color_renglon)
            color_texto = elementos_estructura[indice_cabecera]["color_texto0"] as! String
            
            
            
        }
        
        
        
        if elementos_lista_grupos[indice_grupo]["cuadro"] != nil {
            
            let aux_cuadro = elementos_lista_grupos[indice_grupo]["cuadro"] as! UIImageView
            
            aux_cuadro.image = cuadro
            
        }
        
        for aux_indice in indices {
            
            let aux_elemento = elementos_lista[aux_indice]
            
            //print(aux_elemento)
            
            switch aux_elemento["tipo"] as! String{
                
            case "LABEL":
                
                let aux_elemento_lista = aux_elemento["elemento"] as! UILabel
                
                aux_elemento_lista.textColor = UIColor(rgba: "#\(color_texto)")
                
                //aux_elemento_lista.frame.origin.y = aux_elemento["y_original"] as! CGFloat + CGFloat(offset_lista)
                
                //laVista.addSubview(aux_elemento_lista)
                
            case "SELECT_ONE_RADIO":
                
                //print(aux_elemento)
                
                let aux_label = aux_elemento["label"] as! UILabel
                
                aux_label.textColor = UIColor(rgba: "#\(color_texto)")
                
                //aux_label.frame.origin.y = aux_elemento["label_y_original"] as! CGFloat + CGFloat(offset_lista)
                
                //laVista.addSubview(aux_label)
                
                
                let aux_botontes = aux_elemento["botones"] as! [[String:AnyObject]]
                
                
                
                for boton in aux_botontes {
                    
                    //print(boton)
                    
                    
                    
                    _ = boton["elemento"] as! UIButton
                    
                    //aux_boton.frame.origin.y = boton["y_original"] as! CGFloat + CGFloat(offset_lista)
                    
                    let aux_opcion = boton["opcion"] as! UILabel
                    
                    aux_opcion.textColor = UIColor(rgba: "#\(color_texto)")
                    
                    //aux_opcion.frame.origin.y = boton["opcion_y_original"] as! CGFloat + CGFloat(offset_lista)
                    
                    //laVista.addSubview(aux_boton)
                    //laVista.addSubview(aux_opcion)
                    
                }
                
                
                
            case "REAL", "NUMERIC":
                
                //let aux_campo_texto = aux_elemento["elemento"] as! UITextField
                
                //aux_campo_texto.frame.origin.y = aux_elemento["y_original"] as! CGFloat + CGFloat(offset_lista)
                
                let aux_label = aux_elemento["label"] as! UILabel
                
                aux_label.textColor = UIColor(rgba: "#\(color_texto)")
                
                //aux_label.frame.origin.y = aux_elemento["label_y_original"] as! CGFloat + CGFloat(offset_lista)
                
                //laVista.addSubview(aux_campo_texto)
                //laVista.addSubview(aux_label)
                
            case "FOTO":
                
                let aux_elemento_lista = aux_elemento["elemento"] as! UIButton
                
                aux_elemento_lista.titleLabel!.textColor = UIColor(rgba: "#\(color_texto)")
                
                //aux_elemento_lista.frame.origin.y = aux_elemento["y_original"] as! CGFloat + CGFloat(offset_lista)
                
                //laVista.addSubview(aux_elemento_lista)
                
            case "SELECT_ONE_SPINNER":
                
                
                let aux_elemento_lista = aux_elemento["elemento"] as! UIButton
                
                aux_elemento_lista.setTitleColor(UIColor(rgba: "#\(color_texto)"), for: .normal)
                
                aux_elemento_lista.titleLabel!.textColor = UIColor(rgba: "#\(color_texto)")
                
                //aux_elemento_lista.frame.origin.y = aux_elemento["y_original"] as! CGFloat + CGFloat(offset_lista)
                
                //laVista.addSubview(aux_elemento_lista)
                
            case "SUBESTRUCTURA":
                
                let aux_elemento_lista = aux_elemento["elemento"] as! UIButton
                
                aux_elemento_lista.titleLabel!.textColor = UIColor(rgba: "#\(color_texto)")
                
                //aux_elemento_lista.frame.origin.y = aux_elemento["y_original"] as! CGFloat + CGFloat(offset_lista)
                
                //let aux_elemento_lista_ojo = aux_elemento["elemento_ojo"] as! UIButton
                
                //aux_elemento_lista_ojo.frame.origin.y = aux_elemento["y_original"] as! CGFloat + CGFloat(offset_lista)
                
                //laVista.addSubview(aux_elemento_lista)
                //laVista.addSubview(aux_elemento_lista_ojo)
                
                
            default:
                print("tipo no manejado al llenar acomodar \(String(describing: aux_elemento["tipo"]))")
            }
            
            
        }
        
        
        
    }
    
    
    //fin acomodar objetos color
    
    
    
    
    
    /*
     override func didReceiveMemoryWarning() {
     super.didReceiveMemoryWarning()
     
     print("sin memoria")
     
     // Dispose of any resources that can be recreated.
     let sharedURLCache:NSURLCache = NSURLCache()
     
     sharedURLCache.removeAllCachedResponses()
     
     }
     */
    
    ///la parte de acomodar
    
    
    
    func crear_acomodar_elemento(VistaScroll:UIScrollView,offset_lista:Int,tipo:String,elemento:AnyObject,indice:Int,id:NSNumber,estructura_y:Int,categoria_foto:String?=nil,auxElemento:AnyObject?=nil){
        
        //var offset_lista = offset_lista
        
        //print(tipo)
        
        
        
        switch tipo {
        case "LABEL":
            
            //print("si va a acomodar el label")
            
            let nuevo_elemento = UILabel()
            
            let aux_elemento = elemento as! UILabel
            
            nuevo_elemento.frame = aux_elemento.frame
            
            if auxElemento?["prefijo"] == nil {
                
                nuevo_elemento.text = aux_elemento.text
                
                nuevo_elemento.font = aux_elemento.font
                
                nuevo_elemento.textColor = UIColor(rgba: "#\(self.colorTexto)")
                
            }
            else{
                
                print(auxElemento as Any)
                
                var auxString = auxElemento?["prefijo"] as! String + aux_elemento.text!
                
                if auxElemento?["mayuscula"] != nil {
                    
                    if auxElemento?["mayuscula"] as! String == "1" {
                        
                        auxString = auxString.uppercased()
                    }
                    
                }
                
                let myMutableString = NSMutableAttributedString(
                    string: auxString,
                    attributes: [:])
                
                print("#\(auxElemento?["color_prefijo"] as! String)")
                
                myMutableString.addAttribute(
                    NSAttributedStringKey.foregroundColor,
                    value: UIColor.init(rgba: "#\(auxElemento?["color_prefijo"] as! String)"),
                    range: NSRange(
                        location:0,
                        length:(auxElemento?["prefijo"] as! String).characters.count))
                
                nuevo_elemento.attributedText = myMutableString
                
            }
            
            
            
            nuevo_elemento.numberOfLines = 0
            nuevo_elemento.textAlignment = .left
            //nuevo_elemento.sizeToFit()
            
            nuevo_elemento.frame.origin.y = aux_elemento.frame.origin.y + CGFloat(offset_lista)
            
            nuevo_elemento.adjustFontSizeToFitRect(rect: nuevo_elemento.frame, maximo: 25)
            
            
            VistaScroll.addSubview(nuevo_elemento)
            
            self.aux_posicion.frame = CGRect(x: 10, y: offset_lista, width: 50, height: 50)
            
            VistaScroll.contentSize = CGSize(width: VistaScroll.contentSize.width, height: self.aux_posicion.frame.origin.y +  self.aux_posicion.frame.size.height+300)
            
            var resultado_elemento = [String:AnyObject]()
            
            
            resultado_elemento["elemento"] = nuevo_elemento
            resultado_elemento["tipo"] = tipo as AnyObject?
            
            resultado_elemento["y_original"] = aux_elemento.frame.origin.y as AnyObject?
            
            
            let elementos = ["offset_lista":offset_lista,"elemento":resultado_elemento] as [String : AnyObject]
            
            
            
            self.elementos_lista.append(elementos["elemento"] as! [String : AnyObject])
            
        case "SELECT_ONE_RADIO":
            
            let aux_elemento = elemento as! [String:AnyObject]
            
            print(aux_elemento)
            
            let nueva_label = UILabel()
            
            
            let aux_label = aux_elemento["label"] as! UILabel
            
            nueva_label.frame = aux_label.frame
            
            nueva_label.text = aux_label.text
            
            nueva_label.font = aux_label.font
            
            nueva_label.textColor = UIColor(rgba: "#\(self.colorTexto)")
            
            nueva_label.numberOfLines = 0
            nueva_label.textAlignment = .left
            nueva_label.sizeToFit()
            
            nueva_label.tag = indice
            
            nueva_label.frame.origin.y = aux_label.frame.origin.y + CGFloat(offset_lista)
            
            VistaScroll.addSubview(nueva_label)
            
            var nuevo_elemento = [String:AnyObject]()
            
            nuevo_elemento["tipo"]=aux_elemento["tipo"] as! String as AnyObject?
            nuevo_elemento["grupo"]=aux_elemento["grupo"] as! NSNumber
            nuevo_elemento["label"]=nueva_label
            nuevo_elemento["id"]=id
            nuevo_elemento["id_elemento"]=aux_elemento["id_elemento"] as! String as AnyObject?
            //print(aux_elemento["elementos_hijos"])
            
            nuevo_elemento["elementos_hijos"]=aux_elemento["elementos_hijos"]
            nuevo_elemento["opcion_hijo"]=aux_elemento["opcion_hijo"]
            nuevo_elemento["total"]=(aux_elemento["botones"] as! [UIButton]).count as AnyObject?
            
            nuevo_elemento["botones"] = [[String:AnyObject]]() as AnyObject?
            
            nuevo_elemento["label_y_original"] = aux_label.frame.origin.y as AnyObject?
            
            self.idReporteLocal = self.defaults.object(forKey: "idReporteLocal") as! Int
            
            //let base = defaults.object(forKey: "base") as! String
            
            //db.open_database(base)
            
            let sql = "select distribution from report_distribution where id_item = '\(id)' and idReporteLocal = '\(self.idReporteLocal)'"
            
            //print(sql)
            
            let resultado_distribution = self.db.select_query_columns(sql)
            
            //print("el resultado previo de distribucion es")
            //print(resultado_distribution)
            
            var valor = 3
            
            if resultado_distribution.count > 0 {
                
                for renglon in resultado_distribution {
                    
                    
                    
                    valor = renglon["distribution"] as! Int
                    
                    
                    
                }
                
            }
            
            var aux_botones = [[String:AnyObject]]()
            
            let botones = aux_elemento["botones"] as! [[String:AnyObject]]
            
            for aux_boton in botones {
                
                let boton = aux_boton["elemento"] as! UIButton
                
                print(aux_boton)
                
                let nuevo_boton = UIButton()
                
                nuevo_boton.setImage(boton.imageView?.image, for: .normal)
                
                var seleccionado = false
                
                var valorV = "0"
                
                switch valor {
                case 0:
                    
                    if (aux_boton["opcion"] as! UILabel).text! == "N/C" {
                        
                        nuevo_boton.setImage(UIImage(named: "RadioButtonSeleccionado"), for: .normal)
                        seleccionado = true
                        
                    }
                case 2:
                    
                    if (aux_boton["opcion"] as! UILabel).text! == "No" {
                        
                        nuevo_boton.setImage(UIImage(named: "RadioButtonSeleccionado"), for: .normal)
                        seleccionado = true
                        
                        valorV = "2"
                        
                    }
                case 1:
                    
                    if (aux_boton["opcion"] as! UILabel).text! == "Si" {
                        
                        nuevo_boton.setImage(UIImage(named: "RadioButtonSeleccionado"), for: .normal)
                        seleccionado = true
                        valorV = "1"
                        
                    }
                    
                default:
                    break
                }
                
                nuevo_boton.frame = boton.frame
                
                nuevo_boton.frame.origin.y = nuevo_boton.frame.origin.y + CGFloat(offset_lista)
                
                
                nuevo_boton.tag = indice
                
                aux_botones.append([String:AnyObject]())
                aux_botones[aux_botones.count - 1]["elemento"]=nuevo_boton
                aux_botones[aux_botones.count - 1]["seleccionado"]=seleccionado as AnyObject?
                aux_botones[aux_botones.count - 1]["y_original"]=boton.frame.origin.y as AnyObject?
                aux_botones[aux_botones.count - 1]["valor"]=valorV as AnyObject?
                //aux_botones[aux_botones.count - 1]["posicion"]=q
                
                
                VistaScroll.addSubview(nuevo_boton)
                
                let nueva_opcion_label = UILabel()
                
                let opcion_label = aux_boton["opcion"] as! UILabel
                
                nueva_opcion_label.frame = opcion_label.frame
                
                nueva_opcion_label.text = opcion_label.text
                
                nueva_opcion_label.font = opcion_label.font
                
                nueva_opcion_label.textColor = UIColor(rgba: "#\(self.colorTexto)")
                
                nueva_opcion_label.numberOfLines = 0
                nueva_opcion_label.textAlignment = .left
                nueva_opcion_label.sizeToFit()
                
                nueva_opcion_label.frame.origin.y = opcion_label.frame.origin.y + CGFloat(offset_lista)
                
                aux_botones[aux_botones.count - 1]["opcion"]=nueva_opcion_label
                aux_botones[aux_botones.count - 1]["opcion_y_original"]=opcion_label.frame.origin.y as AnyObject?
                
                
                VistaScroll.addSubview(nueva_opcion_label)
                
                
            }
            
            nuevo_elemento["botones"] = aux_botones as AnyObject?
            
            let elementos = ["offset_lista":offset_lista,"elemento":nuevo_elemento] as [String : AnyObject]
            
            
            
            self.elementos_lista.append(elementos["elemento"] as! [String : AnyObject])
            
        case "REAL","NUMERIC":
            
            let aux_elemento = elemento as! [String:AnyObject]
            
            //print(aux_elemento)
            
            let nueva_label = UILabel()
            
            
            let aux_label = aux_elemento["label"] as! UILabel
            
            nueva_label.frame = aux_label.frame
            
            nueva_label.text = aux_label.text
            
            nueva_label.font = aux_label.font
            
            nueva_label.textColor = UIColor(rgba: "#\(self.colorTexto)")
            
            nueva_label.numberOfLines = 0
            nueva_label.textAlignment = .left
            nueva_label.sizeToFit()
            
            nueva_label.tag = indice
            
            nueva_label.frame.origin.y = aux_label.frame.origin.y + CGFloat(offset_lista)
            
            var opcional = 0
            
            if aux_elemento["opcional"] != nil {
                
                opcional = 2
                
                var sql_opcional = aux_elemento["sql_opcional"] as! String
                
                
                
                sql_opcional = sql_opcional.replacingOccurrences(of: "$columna$", with: id.stringValue)
                
                let resultado_opcional = self.db.select_query(sql_opcional)
                
                if resultado_opcional.count > 0 {
                    
                    opcional = 1
                }
                
            }
            
            
            
            
            
            
            
            
            let campo_texto = aux_elemento["elemento"] as! UITextField
            
            let nuevo_campo_texto = UITextField()
            
            nuevo_campo_texto.frame = campo_texto.frame
            nuevo_campo_texto.borderStyle = campo_texto.borderStyle
            nuevo_campo_texto.keyboardType = campo_texto.keyboardType
            nuevo_campo_texto.returnKeyType = campo_texto.returnKeyType
            nuevo_campo_texto.delegate = campo_texto.delegate
            
            nuevo_campo_texto.tag = indice
            
            nuevo_campo_texto.frame.origin.y = campo_texto.frame.origin.y + CGFloat(offset_lista)
            
            
            self.idReporteLocal = self.defaults.object(forKey: "idReporteLocal") as! Int
            
            //let base = defaults.object(forKey: "base") as! String
            
            //db.open_database(base)
            
            let sql = "select \(aux_elemento["valor"] as! String) from \(aux_elemento["tabla"] as! String) where id_item = '\(id)' and idReporteLocal = '\(self.idReporteLocal)'"
            
            print(sql)
            
            let resultado_distribution = self.db.select_query_columns(sql)
            
            var valor:NSNumber = 0
            
            if resultado_distribution.count > 0 {
                
                for renglon in resultado_distribution {
                    
                    if let _ = renglon[aux_elemento["valor"] as! String] as? NSNumber {
                        
                        valor = renglon[aux_elemento["valor"] as! String] as! NSNumber
                    }
                    else{
                        
                        valor = 0
                    }
                    
                }
                
            }
            
            nuevo_campo_texto.text = String(describing: valor)
            
            
            if opcional == 1 || opcional == 0 {
                VistaScroll.addSubview(nueva_label)
                VistaScroll.addSubview(nuevo_campo_texto)
            }
            
            
            
            var nuevo_elemento = [String:AnyObject]()
            
            nuevo_elemento["tipo"]=aux_elemento["tipo"] as! String as AnyObject?
            nuevo_elemento["label"]=nueva_label
            nuevo_elemento["id"]=id
            nuevo_elemento["id_elemento"]=aux_elemento["id_elemento"] as! String as AnyObject?
            nuevo_elemento["valor"]=aux_elemento["valor"] as! String as AnyObject?
            nuevo_elemento["tabla"]=aux_elemento["tabla"] as! String as AnyObject?
            nuevo_elemento["elemento"] = nuevo_campo_texto
            nuevo_elemento["y_original"] = campo_texto.frame.origin.y as AnyObject?
            
            nuevo_elemento["label_y_original"] = aux_label.frame.origin.y as AnyObject?
            
            
            
            let elementos = ["offset_lista":offset_lista,"elemento":nuevo_elemento] as [String : AnyObject]
            
            
            
            self.elementos_lista.append(elementos["elemento"] as! [String : AnyObject])
            
        case "FOTO":
            
            self.idReporteLocal = self.defaults.object(forKey: "idReporteLocal") as! Int
            
            let aux_elemento = elemento as! [String:AnyObject]
            
            let nuevo_b_foto = UIButton()
            
            let aux_b_foto = aux_elemento["elemento"] as! UIButton
            
            nuevo_b_foto.tag = indice
            
            
            
            nuevo_b_foto.setImage(aux_b_foto.imageView?.image!, for: .normal)
            
            
            
            nuevo_b_foto.setAttributedTitle(nil, for: .normal)
            nuevo_b_foto.setTitle("Tomar Foto 0/\(aux_elemento["total"]!)", for: .normal)
            
            nuevo_b_foto.isSelected = false
            nuevo_b_foto.setTitleColor(UIColor(rgba: "#\(self.colorTexto)"), for: .normal)
            
            nuevo_b_foto.titleLabel!.font = aux_b_foto.titleLabel?.font
            nuevo_b_foto.titleLabel!.textColor = UIColor(rgba: "#\(self.colorTexto)")
            nuevo_b_foto.titleLabel!.numberOfLines = aux_b_foto.titleLabel!.numberOfLines
            nuevo_b_foto.titleLabel!.textAlignment = aux_b_foto.titleLabel!.textAlignment
            
            nuevo_b_foto.contentHorizontalAlignment = aux_b_foto.contentHorizontalAlignment
            
            nuevo_b_foto.frame = aux_b_foto.frame
            
            nuevo_b_foto.frame.origin.y = aux_b_foto.frame.origin.y + CGFloat(offset_lista)
            
            nuevo_b_foto.contentEdgeInsets = aux_b_foto.contentEdgeInsets
            nuevo_b_foto.titleEdgeInsets = aux_b_foto.titleEdgeInsets
            nuevo_b_foto.imageEdgeInsets = aux_b_foto.imageEdgeInsets
            
            
            
            var nuevo_elemento = [String:AnyObject]()
            
            nuevo_elemento["tipo"]=aux_elemento["tipo"] as! String as AnyObject?
            nuevo_elemento["id"]=id
            //nuevo_elemento["id_elemento"]=aux_elemento["id_elemento"] as! String as AnyObject?
            nuevo_elemento["tabla"]=aux_elemento["tabla"] as! String as AnyObject?
            
            nuevo_elemento["columna"]=aux_elemento["columna"] as! String as AnyObject?
            nuevo_elemento["total"]=aux_elemento["total"] as! String as AnyObject?
            nuevo_elemento["id_padre"]=aux_elemento["id_padre"] as! String as AnyObject?
            nuevo_elemento["id_padre_fk"]=aux_elemento["id_padre_fk"] as! String as AnyObject?
            nuevo_elemento["tabla_padre"]=aux_elemento["tabla_padre"] as! String as AnyObject?
            nuevo_elemento["y_original"]=aux_b_foto.frame.origin.y as AnyObject?
            
            //let base = defaults.object(forKey: "base") as! String
            
            //db.open_database(base)
            
            
            
            
            //var sql = "select id,id_item from \(nuevo_elemento["tabla_padre"] as! String) where \(nuevo_elemento["id_padre"] as! String) = '\(nuevo_elemento["id"]!)' and idReporteLocal = '\(idReporteLocal)' and filter2 = '\(categoria_foto)'"
            
            var sql = "select id,id_item from \(nuevo_elemento["tabla_padre"] as! String) where \(nuevo_elemento["id_padre"] as! String) = '\(nuevo_elemento["id"]!)' and idReporteLocal = '\(self.idReporteLocal)'"
            
            print(sql)
            
            let resultado_distribution = self.db.select_query_columns(sql)
            
            var id_padre = 0
            
            if resultado_distribution.count > 0 {
                
                for renglon in resultado_distribution {
                    
                    id_padre = renglon["id"] as! Int
                    
                }
                
                print(id_padre)
                
                sql = "select id,path,hash from \(nuevo_elemento["tabla"] as! String) where idReporteLocal = '\(self.idReporteLocal)' and filter2 = '\(categoria_foto!)'"
                
                print(sql)
                
                let fotos = self.db.select_query_columns(sql)
                
                print(fotos)
                
                let total = Int(nuevo_elemento["total"] as! String)
                
                nuevo_b_foto.setTitle("Tomar Foto \(fotos.count)/\(nuevo_elemento["total"]!)", for: .normal)
                
                
                
                var aux_fotos:[[String:AnyObject]] = []
                
                for foto in fotos {
                    
                    nuevo_b_foto.setImage(UIImage(named: "CamaraActiva"), for: .normal)
                    
                    aux_fotos.append([String : AnyObject]())
                    
                    aux_fotos[aux_fotos.count - 1]["nombre"] = foto["path"]
                    aux_fotos[aux_fotos.count - 1]["hash"] = foto["hash"]
                }
                
                nuevo_elemento["fotos"] = aux_fotos as AnyObject?
                
                if total! <= aux_fotos.count {
                    
                    nuevo_b_foto.isUserInteractionEnabled = false
                }
                
            }
            
            nuevo_elemento["elemento"] = nuevo_b_foto
            
            VistaScroll.addSubview(nuevo_b_foto)
            
            let elementos = ["offset_lista":offset_lista,"elemento":nuevo_elemento] as [String : AnyObject]
            
            
            
            self.elementos_lista.append(elementos["elemento"] as! [String : AnyObject])
            
            
        case "GUARDAR":
            
            self.idReporteLocal = self.defaults.object(forKey: "idReporteLocal") as! Int
            
            let aux_elemento = elemento as! [String:AnyObject]
            
            let nuevo_b_guardar = UIButton()
            
            let aux_b_guardar = aux_elemento["elemento"] as! UIButton
            
            nuevo_b_guardar.tag = indice
            
            
            
            //nuevo_b_guardar.setImage(aux_b_guardar.imageView?.image!, for: .normal)
            
            
            
            nuevo_b_guardar.setAttributedTitle(nil, for: .normal)
            nuevo_b_guardar.setTitle(aux_b_guardar.titleLabel?.text!, for: .normal)
            
            nuevo_b_guardar.isSelected = false
            nuevo_b_guardar.setTitleColor(UIColor(rgba: "#\(self.colorTexto)"), for: .normal)
            
            nuevo_b_guardar.titleLabel!.font = aux_b_guardar.titleLabel?.font
            nuevo_b_guardar.titleLabel!.textColor = UIColor(rgba: "#\(self.colorTexto)")
            nuevo_b_guardar.titleLabel!.numberOfLines = aux_b_guardar.titleLabel!.numberOfLines
            nuevo_b_guardar.titleLabel!.textAlignment = aux_b_guardar.titleLabel!.textAlignment
            
            nuevo_b_guardar.contentHorizontalAlignment = aux_b_guardar.contentHorizontalAlignment
            
            nuevo_b_guardar.frame = aux_b_guardar.frame
            
            nuevo_b_guardar.frame.origin.y = aux_b_guardar.frame.origin.y + CGFloat(offset_lista)
            /*
             nuevo_b_guardar.contentEdgeInsets = aux_b_foto.contentEdgeInsets
             nuevo_b_guardar.titleEdgeInsets = aux_b_foto.titleEdgeInsets
             nuevo_b_guardar.imageEdgeInsets = aux_b_foto.imageEdgeInsets
             */
            
            
            var nuevo_elemento = [String:AnyObject]()
            
            nuevo_elemento["tipo"]=aux_elemento["tipo"] as! String as AnyObject?
            nuevo_elemento["id"]=id
            //nuevo_elemento["id_elemento"]=aux_elemento["id_elemento"] as! String as AnyObject?
            nuevo_elemento["tabla"]=aux_elemento["tabla"] as! String as AnyObject?
            
            nuevo_elemento["columna"]=aux_elemento["columna"] as! String as AnyObject?
            
            nuevo_elemento["y_original"]=nuevo_b_guardar.frame.origin.y as AnyObject?
            
            //let base = defaults.object(forKey: "base") as! String
            
            //db.open_database(base)
            
            
            
            nuevo_elemento["elemento"] = nuevo_b_guardar
            
            //VistaScroll.addSubview(nuevo_b_guardar)
            
            let elementos = ["offset_lista":offset_lista,"elemento":nuevo_elemento] as [String : AnyObject]
            
            
            
            self.elementos_lista.append(elementos["elemento"] as! [String : AnyObject])
            
            
        case "AGREGAR":
            
            self.idReporteLocal = self.defaults.object(forKey: "idReporteLocal") as! Int
            
            let aux_elemento = elemento as! [String:AnyObject]
            
            let nuevo_b_guardar = UIButton()
            
            let aux_b_guardar = aux_elemento["elemento"] as! UIButton
            
            nuevo_b_guardar.tag = indice
            
            
            
            //nuevo_b_guardar.setImage(aux_b_guardar.imageView?.image!, for: .normal)
            
            
            
            nuevo_b_guardar.setAttributedTitle(nil, for: .normal)
            nuevo_b_guardar.setTitle(aux_b_guardar.titleLabel?.text!, for: .normal)
            
            nuevo_b_guardar.isSelected = false
            nuevo_b_guardar.setTitleColor(UIColor(rgba: "#\(self.colorTexto)"), for: .normal)
            
            nuevo_b_guardar.titleLabel!.font = aux_b_guardar.titleLabel?.font
            nuevo_b_guardar.titleLabel!.textColor = UIColor(rgba: "#\(self.colorTexto)")
            nuevo_b_guardar.titleLabel!.numberOfLines = aux_b_guardar.titleLabel!.numberOfLines
            nuevo_b_guardar.titleLabel!.textAlignment = aux_b_guardar.titleLabel!.textAlignment
            
            nuevo_b_guardar.contentHorizontalAlignment = aux_b_guardar.contentHorizontalAlignment
            
            nuevo_b_guardar.frame = aux_b_guardar.frame
            
            nuevo_b_guardar.frame.origin.y = aux_b_guardar.frame.origin.y + CGFloat(offset_lista)
            /*
             nuevo_b_guardar.contentEdgeInsets = aux_b_foto.contentEdgeInsets
             nuevo_b_guardar.titleEdgeInsets = aux_b_foto.titleEdgeInsets
             nuevo_b_guardar.imageEdgeInsets = aux_b_foto.imageEdgeInsets
             */
            
            
            var nuevo_elemento = [String:AnyObject]()
            
            nuevo_elemento["tipo"]=aux_elemento["tipo"] as! String as AnyObject?
            nuevo_elemento["id"]=id
            nuevo_elemento["id_elemento"]=aux_elemento["id_elemento"] as! String as AnyObject?
            
            nuevo_elemento["columna"]=aux_elemento["columna"] as! String as AnyObject?
            
            nuevo_elemento["y_original"]=nuevo_b_guardar.frame.origin.y as AnyObject?
            
            //let base = defaults.object(forKey: "base") as! String
            
            //db.open_database(base)
            
            
            
            nuevo_elemento["elemento"] = nuevo_b_guardar
            
            VistaScroll.addSubview(nuevo_b_guardar)
            
            let elementos = ["offset_lista":offset_lista,"elemento":nuevo_elemento] as [String : AnyObject]
            
            
            
            self.elementos_lista.append(elementos["elemento"] as! [String : AnyObject])
            
        case "SELECT_ONE_SPINNER":
            
            self.idReporteLocal = self.defaults.object(forKey: "idReporteLocal") as! Int
            
            let aux_elemento = elemento as! [String:AnyObject]
            
            //print(aux_elemento)
            
            let nuevo_b_select_menu = UIButton()
            
            let aux_b_select_menu = aux_elemento["elemento"] as! UIButton
            
            nuevo_b_select_menu.tag = indice
            
            
            
            
            
            
            
            nuevo_b_select_menu.setAttributedTitle(nil, for: .normal)
            nuevo_b_select_menu.setTitle(aux_b_select_menu.titleLabel?.text!, for: .normal)
            
            nuevo_b_select_menu.isSelected = false
            nuevo_b_select_menu.setTitleColor(UIColor(rgba: "#\(self.colorTexto)"), for: .normal)
            
            nuevo_b_select_menu.titleLabel!.font = aux_b_select_menu.titleLabel?.font
            nuevo_b_select_menu.titleLabel!.textColor = UIColor(rgba: "#\(self.colorTexto)")
            nuevo_b_select_menu.titleLabel!.numberOfLines = aux_b_select_menu.titleLabel!.numberOfLines
            nuevo_b_select_menu.titleLabel!.textAlignment = aux_b_select_menu.titleLabel!.textAlignment
            
            nuevo_b_select_menu.contentHorizontalAlignment = aux_b_select_menu.contentHorizontalAlignment
            
            nuevo_b_select_menu.frame = aux_b_select_menu.frame
            
            nuevo_b_select_menu.frame.origin.y = aux_b_select_menu.frame.origin.y + CGFloat(offset_lista)
            
            
            print(aux_elemento["fondo"] as Any)
            
            
            if aux_elemento["fondo"] == nil {
                
                nuevo_b_select_menu.setImage(aux_b_select_menu.imageView?.image!, for: .normal)
                
                nuevo_b_select_menu.contentEdgeInsets = aux_b_select_menu.contentEdgeInsets
                nuevo_b_select_menu.titleEdgeInsets = aux_b_select_menu.titleEdgeInsets
                nuevo_b_select_menu.imageEdgeInsets = aux_b_select_menu.imageEdgeInsets
                
            }
            else{
                
                nuevo_b_select_menu.setBackgroundImage(aux_b_select_menu.imageView?.image!, for: .normal)
                
                //nuevo_b_select_menu.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
                //nuevo_b_select_menu.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
                //nuevo_b_select_menu.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
                
            }
            
            
            var nuevo_elemento = [String:AnyObject]()
            
            nuevo_elemento["tipo"]=aux_elemento["tipo"] as! String as AnyObject?
            nuevo_elemento["id"]=id
            nuevo_elemento["tabla"]=aux_elemento["tabla"] as! String as AnyObject?
            nuevo_elemento["texto"]=aux_elemento["texto"] as! String as AnyObject?
            
            nuevo_elemento["columna"]=aux_elemento["columna"] as! String as AnyObject?
            nuevo_elemento["valor"]=aux_elemento["valor"] as! String as AnyObject?
            nuevo_elemento["color_menu"]=aux_elemento["color_menu"] as! String as AnyObject?
            nuevo_elemento["color_texto"]=aux_elemento["color_texto"] as! String as AnyObject?
            nuevo_elemento["id_elemento"]=aux_elemento["id_elemento"] as! String as AnyObject?
            nuevo_elemento["id_padre"]=aux_elemento["id_padre"] as! String as AnyObject?
            
            nuevo_elemento["y_original"]=aux_b_select_menu.frame.origin.y as AnyObject?
            
            
            //let base = defaults.object(forKey: "base") as! String
            
            //db.open_database(base)
            
            var aux_opciones = [[String:AnyObject]]()
            
            var sql = ""
            
            
            
            
            
            if  aux_elemento["elemento_padre"] == nil{
                
                sql = "select \(aux_elemento["columna"] as! String),\(aux_elemento["valor"] as! String) from \(aux_elemento["tabla"] as! String)"
                
            }
            else{
                
                nuevo_elemento["elemento_padre"]=aux_elemento["elemento_padre"] as! String as AnyObject?
                nuevo_elemento["query"]=aux_elemento["query"] as! String as AnyObject?
                
                let aux_query = aux_elemento["query"] as! String
                
                sql = aux_query.replacingOccurrences(of: "$padre$", with: "1")
                
                nuevo_b_select_menu.isHidden = true
            }
            
            if  aux_elemento["elemento_hijo"] != nil{
                
                nuevo_elemento["elemento_hijo"]=aux_elemento["elemento_hijo"] as! String as AnyObject?
                
            }
            
            if  aux_elemento["valor_final"] != nil{
                
                nuevo_elemento["valor_final"]=aux_elemento["valor_final"] as! String as AnyObject?
                
            }
            
            if  aux_elemento["tabla_guardar"] != nil{
                
                nuevo_elemento["tabla_guardar"]=aux_elemento["tabla_guardar"] as! String as AnyObject?
                nuevo_elemento["columna_guardar"]=aux_elemento["columna_guardar"] as! String as AnyObject?
                nuevo_elemento["columna_guardar_padre"]=aux_elemento["columna_guardar_padre"] as! String as AnyObject?
                nuevo_elemento["tabla_padre"]=aux_elemento["tabla_padre"] as! String as AnyObject?
                nuevo_elemento["id_padre_reporte"]=aux_elemento["id_padre_reporte"] as! String as AnyObject?
                
            }
            
            nuevo_elemento["elemento"] = nuevo_b_select_menu
            
            //print(sql)
            
            let resultado_opciones = self.db.select_query_columns(sql)
            
            for opcion in resultado_opciones {
                
                aux_opciones.append([String:AnyObject]())
                
                //print(opcion)
                
                
                aux_opciones[aux_opciones.count - 1]["id"] = opcion[aux_elemento["columna"] as! String]
                aux_opciones[aux_opciones.count - 1]["opcion"] = opcion[aux_elemento["valor"] as! String]
                
            }
            
            nuevo_elemento["opciones"] = aux_opciones as AnyObject?
            
            VistaScroll.addSubview(nuevo_b_select_menu)
            
            let elementos = ["offset_lista":offset_lista,"elemento":nuevo_elemento] as [String : AnyObject]
            
            
            
            self.elementos_lista.append(elementos["elemento"] as! [String : AnyObject])
            
            
        case "LISTA_DOBLE":
            
            self.idReporteLocal = self.defaults.object(forKey: "idReporteLocal") as! Int
            
            let aux_elemento = elemento as! [String:AnyObject]
            
            //print(aux_elemento)
            
            //let nuevo_b_select_menu = UIButton()
            
            
            let aux_vistaLista:UIScrollView = aux_elemento["elemento"] as! UIScrollView
            
            let nuevo_vistaLista:UIScrollView = UIScrollView()
            
            nuevo_vistaLista.frame = aux_vistaLista.frame
            
            
            
            nuevo_vistaLista.frame = CGRect(x: nuevo_vistaLista.frame.origin.x, y: nuevo_vistaLista.frame.origin.y + 200, width: nuevo_vistaLista.frame.width, height: nuevo_vistaLista.frame.height)
            
            let lista1Titulo = UIButton()
            
            
            
            lista1Titulo.setAttributedTitle(nil, for: .normal)
            lista1Titulo.setTitle("AGREGAR MARCA", for: .normal)
            
            lista1Titulo.isSelected = false
            lista1Titulo.setTitleColor(UIColor(rgba: "#aaaaaa"), for: .normal)
            
            
            lista1Titulo.titleLabel!.font = lista1Titulo.titleLabel?.font
            lista1Titulo.titleLabel!.textColor = UIColor(rgba: "#aaaaaa")
            lista1Titulo.titleLabel!.numberOfLines = 0
            lista1Titulo.titleLabel!.textAlignment = .justified
            
            
            
            lista1Titulo.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
            
            lista1Titulo.titleLabel!.sizeToFit()
            
            
            
            let offsetX = nuevo_vistaLista.frame.origin.x
            
            lista1Titulo.frame = CGRect(x: offsetX, y: nuevo_vistaLista.frame.origin.y - 100, width: nuevo_vistaLista.frame.width/2, height: 50)
            
            lista1Titulo.titleLabel!.adjustFontSizeToFitRect(rect: lista1Titulo.frame, maximo: 18)
            
            
            
            VistaScroll.addSubview(lista1Titulo)
            
            
            
            
            
            
            
            
            
            nuevo_vistaLista.backgroundColor = UIColor.init(rgba: "#eeeeee")
            
            nuevo_vistaLista.frame.origin.y = aux_vistaLista.frame.origin.y + CGFloat(offset_lista)
            
            let aux_offset_lista =  Int(nuevo_vistaLista.frame.height) + offset_lista + Int(nuevo_vistaLista.frame.height/3)
            
            
            
            let nuevo_vistaLista2:UIScrollView = UIScrollView()
            
            nuevo_vistaLista2.frame = nuevo_vistaLista.frame
            
            nuevo_vistaLista2.backgroundColor = UIColor.init(rgba: "#eeeeee")
            
            nuevo_vistaLista2.frame.origin.y = nuevo_vistaLista.frame.origin.y + CGFloat(aux_offset_lista)
            
            
            
            let lista2Titulo = UIButton()
            
            
            
            lista2Titulo.setAttributedTitle(nil, for: .normal)
            lista2Titulo.setTitle("MARCAS AGREGADAS", for: .normal)
            
            lista2Titulo.isSelected = false
            lista2Titulo.setTitleColor(UIColor(rgba: "#aaaaaa"), for: .normal)
            
            
            lista2Titulo.titleLabel!.font = lista2Titulo.titleLabel?.font
            lista2Titulo.titleLabel!.textColor = UIColor(rgba: "#aaaaaa")
            lista2Titulo.titleLabel!.numberOfLines = 0
            lista2Titulo.titleLabel!.textAlignment = .justified
            
            
            
            lista2Titulo.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
            
            lista2Titulo.titleLabel!.sizeToFit()
            
            
            
            lista2Titulo.frame = CGRect(x: offsetX, y: nuevo_vistaLista2.frame.origin.y - 100, width: nuevo_vistaLista2.frame.width, height: 50)
            
            lista2Titulo.titleLabel!.adjustFontSizeToFitRect(rect: lista2Titulo.frame, maximo: 20)
            
            
            
            VistaScroll.addSubview(lista2Titulo)
            
            
            
            let subvistas = nuevo_vistaLista.subviews
            
            for subvista in subvistas {
                
                subvista.removeFromSuperview()
                
            }
            
            
            /*
             
             let aux_b_select_menu = aux_elemento["elemento"] as! UIButton
             
             nuevo_b_select_menu.tag = indice
             
             
             
             nuevo_b_select_menu.setImage(aux_b_select_menu.imageView?.image!, for: .normal)
             
             
             
             nuevo_b_select_menu.setAttributedTitle(nil, for: .normal)
             nuevo_b_select_menu.setTitle(aux_b_select_menu.titleLabel?.text!, for: .normal)
             
             nuevo_b_select_menu.isSelected = false
             nuevo_b_select_menu.setTitleColor(UIColor(rgba: "#\(colorTexto)"), for: .normal)
             
             nuevo_b_select_menu.titleLabel!.font = aux_b_select_menu.titleLabel?.font
             nuevo_b_select_menu.titleLabel!.textColor = UIColor(rgba: "#\(colorTexto)")
             nuevo_b_select_menu.titleLabel!.numberOfLines = aux_b_select_menu.titleLabel!.numberOfLines
             nuevo_b_select_menu.titleLabel!.textAlignment = aux_b_select_menu.titleLabel!.textAlignment
             
             nuevo_b_select_menu.contentHorizontalAlignment = aux_b_select_menu.contentHorizontalAlignment
             
             nuevo_b_select_menu.frame = aux_b_select_menu.frame
             
             nuevo_b_select_menu.frame.origin.y = aux_b_select_menu.frame.origin.y + CGFloat(offset_lista)
             
             nuevo_b_select_menu.contentEdgeInsets = aux_b_select_menu.contentEdgeInsets
             nuevo_b_select_menu.titleEdgeInsets = aux_b_select_menu.titleEdgeInsets
             nuevo_b_select_menu.imageEdgeInsets = aux_b_select_menu.imageEdgeInsets
             
             */
            
            
            var nuevo_elemento = [String:AnyObject]()
            
            nuevo_elemento["tipo"]=aux_elemento["tipo"] as! String as AnyObject?
            nuevo_elemento["id"]=id
            nuevo_elemento["tabla"]=aux_elemento["tabla"] as! String as AnyObject?
            nuevo_elemento["texto"]=aux_elemento["texto"] as! String as AnyObject?
            
            nuevo_elemento["columna"]=aux_elemento["columna"] as! String as AnyObject?
            nuevo_elemento["valor"]=aux_elemento["valor"] as! String as AnyObject?
            nuevo_elemento["color_menu"]=aux_elemento["color_menu"] as! String as AnyObject?
            nuevo_elemento["color_texto"]=aux_elemento["color_texto"] as! String as AnyObject?
            nuevo_elemento["id_elemento"]=aux_elemento["id_elemento"] as! String as AnyObject?
            nuevo_elemento["id_padre"]=aux_elemento["id_padre"] as! String as AnyObject?
            
            nuevo_elemento["y_original"]=aux_vistaLista.frame.origin.y as AnyObject?
            
            
            //let base = defaults.object(forKey: "base") as! String
            
            //db.open_database(base)
            
            var aux_opciones = [[String:AnyObject]]()
            
            var sql = ""
            
            
            
            
            
            if  aux_elemento["elemento_padre"] == nil{
                
                sql = "select \(aux_elemento["columna"] as! String),\(aux_elemento["valor"] as! String) from \(aux_elemento["tabla"] as! String)"
                
            }
            else{
                
                nuevo_elemento["elemento_padre"]=aux_elemento["elemento_padre"] as! String as AnyObject?
                nuevo_elemento["query"]=aux_elemento["query"] as! String as AnyObject?
                
                let aux_query = aux_elemento["query"] as! String
                
                sql = aux_query.replacingOccurrences(of: "$padre$", with: "1")
                
                //nuevo_b_select_menu.isHidden = true
            }
            
            if  aux_elemento["elemento_hijo"] != nil{
                
                nuevo_elemento["elemento_hijo"]=aux_elemento["elemento_hijo"] as! String as AnyObject?
                
            }
            
            if  aux_elemento["valor_final"] != nil{
                
                nuevo_elemento["valor_final"]=aux_elemento["valor_final"] as! String as AnyObject?
                
            }
            
            if  aux_elemento["tabla_guardar"] != nil{
                
                nuevo_elemento["tabla_guardar"]=aux_elemento["tabla_guardar"] as! String as AnyObject?
                nuevo_elemento["columna_guardar"]=aux_elemento["columna_guardar"] as! String as AnyObject?
                nuevo_elemento["columna_guardar_padre"]=aux_elemento["columna_guardar_padre"] as! String as AnyObject?
                nuevo_elemento["tabla_padre"]=aux_elemento["tabla_padre"] as! String as AnyObject?
                nuevo_elemento["id_padre_reporte"]=aux_elemento["id_padre_reporte"] as! String as AnyObject?
                
            }
            
            nuevo_elemento["elemento"] = nuevo_vistaLista
            nuevo_elemento["elemento_lista2"] = nuevo_vistaLista2
            
            nuevo_elemento["lista1Titulo"] = lista1Titulo
            nuevo_elemento["lista2Titulo"] = lista2Titulo
            
            //print(sql)
            
            let resultado_opciones = self.db.select_query_columns(sql)
            
            for opcion in resultado_opciones {
                
                aux_opciones.append([String:AnyObject]())
                
                //print(opcion)
                
                
                aux_opciones[aux_opciones.count - 1]["id"] = opcion[aux_elemento["columna"] as! String]
                aux_opciones[aux_opciones.count - 1]["opcion"] = opcion[aux_elemento["valor"] as! String]
                
            }
            
            nuevo_elemento["opciones"] = aux_opciones as AnyObject?
            
            VistaScroll.addSubview(nuevo_vistaLista)
            VistaScroll.addSubview(nuevo_vistaLista2)
            
            let elementos = ["offset_lista":offset_lista,"elemento":nuevo_elemento] as [String : AnyObject]
            
            
            
            self.elementos_lista.append(elementos["elemento"] as! [String : AnyObject])
            
            
        case "SUBESTRUCTURA":
            
            
            self.idReporteLocal = self.defaults.object(forKey: "idReporteLocal") as! Int
            
            let aux_elemento = elemento as! [String:AnyObject]
            
            //print(aux_elemento)
            
            let nuevo_boton = UIButton()
            
            let nuevo_boton_ojo = UIButton()
            
            let aux_boton = aux_elemento["elemento"] as! UIButton
            
            let aux_boton_ojo = aux_elemento["elemento_ojo"] as! UIButton
            
            nuevo_boton.tag = indice
            
            
            nuevo_boton.setAttributedTitle(nil, for: .normal)
            nuevo_boton.setTitle(aux_boton.titleLabel?.text!, for: .normal)
            
            nuevo_boton.isSelected = false
            nuevo_boton.setTitleColor(UIColor(rgba: "#\(self.colorTexto)"), for: .normal)
            
            nuevo_boton.titleLabel!.font = aux_boton.titleLabel?.font
            nuevo_boton.titleLabel!.textColor = UIColor(rgba: "#\(self.colorTexto)")
            nuevo_boton.titleLabel!.numberOfLines = aux_boton.titleLabel!.numberOfLines
            nuevo_boton.titleLabel!.textAlignment = aux_boton.titleLabel!.textAlignment
            
            nuevo_boton.contentHorizontalAlignment = aux_boton.contentHorizontalAlignment
            
            nuevo_boton.frame = aux_boton.frame
            
            nuevo_boton.frame.origin.y = aux_boton.frame.origin.y + CGFloat(offset_lista)
            
            
            nuevo_boton_ojo.setImage(aux_boton_ojo.imageView?.image!, for: .normal)
            nuevo_boton_ojo.frame = aux_boton_ojo.frame
            
            nuevo_boton_ojo.frame.origin.y = aux_boton_ojo.frame.origin.y + CGFloat(offset_lista)
            
            nuevo_boton_ojo.tag = indice
            
            var nuevo_elemento = [String:AnyObject]()
            
            nuevo_elemento["tipo"]=aux_elemento["tipo"] as! String as AnyObject?
            nuevo_elemento["id"]=id
            nuevo_elemento["elemento"] = nuevo_boton
            nuevo_elemento["elemento_ojo"] = nuevo_boton_ojo
            nuevo_elemento["estructura"] = aux_elemento["estructura"]
            nuevo_elemento["estructura_y"] = aux_elemento["estructura_y"]
            
            nuevo_elemento["y_original"] = aux_boton_ojo.frame.origin.y as AnyObject?
            
            
            //let base = defaults.objectForKey("base") as! String
            
            //db.open_database(base)
            
            
            
            VistaScroll.addSubview(nuevo_boton)
            VistaScroll.addSubview(nuevo_boton_ojo)
            
            let elementos = ["offset_lista":offset_lista,"elemento":nuevo_elemento] as [String : AnyObject]
            
            
            
            self.elementos_lista.append(elementos["elemento"] as! [String : AnyObject])
            
            
        default:
            print("tipo no manejado acomodar")
        }
        
        
        
        
        //let elementos = ["offset_lista":offset_lista]
        
        //self.elementos_lista.append(elementos as [String : AnyObject])
        
        self.offset_lista = offset_lista
        
        
        
    }
    
    //fin acomodar elementos
    
    
    
    
    ///fin de la parte de acomodar
    
    
}
