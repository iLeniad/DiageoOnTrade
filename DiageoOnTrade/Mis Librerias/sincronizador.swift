//
//  sincronizador.swift
//  DiageoOnTrade
//
//  Created by Daniel Cedeño García on 10/9/17.
//  Copyright © 2017 Go Sharp. All rights reserved.
//

import Foundation
import CryptoSwift
import Alamofire
import NVActivityIndicatorView
import Zip


class Sincronizador: NSObject,URLSessionDelegate,URLSessionTaskDelegate {
    
    
    //variables
    
    var dominio = "207.58.154.100"
    
    var protocolo = "http"
    
    var db:DB_Manager = DB_Manager()
    
    var servicios:[AnyObject] = []
    var etiquetas:[AnyObject] = []
    
    var servicios_enviar:[AnyObject] = []
    var etiquetas_enviar:[AnyObject] = []
    
    var tablas:[AnyObject] = []
    
    var datos_servicio:[AnyObject]=[]
    
    var defaults = UserDefaults.standard
    
    var servicios_json:JSON
    
    var servicios_json_enviar:JSON
    
    var indiceReporte = 0
    
    var arregloFotosMandar:[[AnyObject]] = []
    
    var reporteAEnviar = 0
    
    
    
    //fin variables
    
    
    
    //inicializacion
    
    override init() {
        
        
        defaults.set("OnTrade2.sqlite", forKey: "base")
        defaults.set("OnTradeB.sqlite", forKey: "baseB")
        defaults.set("OnTradeR.sqlite", forKey: "baseR")
        
        //defaults.set("OnTradeD.sqlite", forKey: "base")
        
        
        
        
        let base = defaults.object(forKey: "base") as! String
        
        
        db.open_database(base)
        
        //dominio = "10.0.4.12:8080"  //prueba servicio catalogos
        
        //dominio = "207.58.154.134"
        
        dominio = "ontrade.gshp-apps.com"
        
        protocolo = "http"
        
        //dominio = "gshpdiageoontradeclone.jelastic.servint.net"
        
        defaults.set(dominio, forKey:"dominio")
        defaults.set(protocolo, forKey:"protocolo")
        
        
        
        
        
        var json_servicio = "[{\"id\": \"99\",\"servicio\": \"/rest/psspolicy/status\",\"tipo\": \"policy\",\"tabla\": \"policy\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"1\",\"servicio\": \"/rest/multireport/catalog/ea_poll\",\"tipo\": \"get\",\"tabla\": \"ea_poll\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"2\",\"servicio\": \"/rest/multireport/catalog/ea_question\",\"tipo\": \"get\",\"tabla\": \"ea_question\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"3\",\"servicio\": \"/rest/multireport/catalog/ea_question_type_cat\",\"tipo\": \"get\",\"tabla\": \"ea_question_type_cat\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"4\",\"servicio\": \"/rest/multireport/catalog/ea_question_option\",\"tipo\": \"get\",\"tabla\": \"ea_question_option\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"5\",\"servicio\": \"/rest/multireport/catalog/ea_section\",\"tipo\": \"get\",\"tabla\": \"ea_section\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"6\",\"servicio\": \"/rest/multireport/catalog/md_item\",\"tipo\": \"get\",\"tabla\": \"md_item\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"7\",\"servicio\": \"/rest/multireport/catalog/md_distribution\",\"tipo\": \"get\",\"tabla\": \"md_distribution\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"8\",\"servicio\": \"/rest/multireport/catalog/mv_manufacturer\",\"tipo\": \"get\",\"tabla\": \"mv_manufacturer\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"9\",\"servicio\": \"/rest/multireport/catalog/mv_category\",\"tipo\": \"get\",\"tabla\": \"mv_category\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"10\",\"servicio\": \"/rest/multireport/catalog/mv_brand\",\"tipo\": \"get\",\"tabla\": \"mv_brand\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"11\",\"servicio\": \"/rest/multireport/catalog/mv_type\",\"tipo\": \"get\",\"tabla\": \"mv_type\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"12\",\"servicio\": \"/rest/multireport/catalog/mv_visibility\",\"tipo\": \"get\",\"tabla\": \"mv_visibility\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"13\",\"servicio\": \"/rest/multireport/catalog/mpr_category\",\"tipo\": \"get\",\"tabla\": \"mpr_category\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"14\",\"servicio\": \"/rest/multireport/catalog/mpr_brand\",\"tipo\": \"get\",\"tabla\": \"mpr_brand\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"15\",\"servicio\": \"/rest/multireport/catalog/mpr_type\",\"tipo\": \"get\",\"tabla\": \"mpr_type\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"16\",\"servicio\": \"/rest/multireport/catalog/mpr_promo\",\"tipo\": \"get\",\"tabla\": \"mpr_promo\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"17\",\"servicio\": \"/rest/multireport/catalog/pdv_pdv\",\"tipo\": \"get\",\"tabla\": \"pdv_pdv\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"18\",\"servicio\": \"/rest/multireport/catalog/c_client\",\"tipo\": \"get\",\"tabla\": \"c_client\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"19\",\"servicio\": \"/rest/multireport/catalog/c_rtm\",\"tipo\": \"get\",\"tabla\": \"c_rtm\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"20\",\"servicio\": \"/rest/multireport/catalog/c_canal\",\"tipo\": \"get\",\"tabla\": \"c_canal\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"21\",\"servicio\": \"/rest/multireport/catalog/c_category\",\"tipo\": \"get\",\"tabla\": \"c_category\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"22\",\"servicio\": \"/rest/multireport/catalog/c_subcategory\",\"tipo\": \"get\",\"tabla\": \"c_subcategory\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"23\",\"servicio\": \"/rest/schedule\",\"tipo\": \"get\",\"tabla\": \"schedule\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"24\",\"servicio\": \"/rest/multireport/catalog/c_type_report\",\"tipo\": \"get\",\"tabla\": \"c_type_report\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"25\",\"servicio\": \"/rest/multireport/catalog/contacts\",\"tipo\": \"get\",\"tabla\": \"contacts\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"26\",\"servicio\": \"/rest/multireport/catalog/pdv_type\",\"tipo\": \"get\",\"tabla\": \"pdv_type\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"27\",\"servicio\": \"/rest/multireport/catalog/pdv_type_module\",\"tipo\": \"get\",\"tabla\": \"pdv_type_module\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"28\",\"servicio\": \"/rest/multireport/catalog/md_expiry_dates\",\"tipo\": \"get\",\"tabla\": \"md_expiry_dates\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"29\",\"servicio\": \"/rest/multireport/catalog/c_brand\",\"tipo\": \"get\",\"tabla\": \"c_brand\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"30\",\"servicio\": \"/rest/version/data/ios-app\",\"tipo\": \"get\",\"tabla\": \"ios-app\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"31\",\"servicio\": \"/rest/multireport/catalog/md_expiry_daterange\",\"tipo\": \"get\",\"tabla\": \"md_expiry_daterange\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"32\",\"servicio\": \"/rest/multireport/catalog/prellenado_distribution_ss\",\"tipo\": \"post\",\"parametros\": {\"name\": \"last_update\",\"value\": \"fecha\"},\"tabla\": \"prellenado_distribution_ss\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"34\",\"servicio\": \"/rest/multireport/catalog/mpr_manufacturer\",\"tipo\": \"get\",\"tabla\": \"mpr_manufacturer\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"35\",\"servicio\": \"/rest/multireport/catalog/support_phone\",\"tipo\": \"get\",\"tabla\": \"support_phone\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"36\",\"servicio\": \"/rest/multireport/catalog/app_property\",\"tipo\": \"post\",\"parametros\": {\"name\": \"key\",\"value\": \"email_support\"},\"tabla\": \"app_property\",\"etiqueta\": \"Descargando...\"}]"
        
        
            json_servicio = "[{\"id\": \"99\",\"servicio\": \"/rest/psspolicy/status\",\"tipo\": \"policy\",\"tabla\": \"policy\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"1\",\"servicio\": \"https://pruebas-e24c5.firebaseapp.com/OnTrade2.zip\",\"tipo\": \"zip\",\"tabla\": \"base\",\"etiqueta\": \"Descargando...\"}]"
        
        
        let json_servicio_enviar = "[{\"id\": \"1\",\"servicio\": \"/rest/report\",\"tipo\": \"post\",\"tabla\": \"report\",\"etiqueta\": \"Faltan por enviar\"}, {\"id\": \"2\",\"servicio\": \"/rest/multireport/insertnt/rdistribution/1\",\"tipo\": \"post\",\"tabla\": \"report_distribution\",\"etiqueta\": \"Faltan por enviar\"}, {\"id\": \"3\",\"servicio\": \"/rest/multireport/insertnt/rpromo/2\",\"tipo\": \"post\",\"tabla\": \"report_promotions\",\"etiqueta\": \"Faltan por enviar\"}, {\"id\": \"4\",\"servicio\": \"/rest/multireport/insertnt/rpromobrand/1\",\"tipo\": \"post\",\"tabla\": \"report_promtions_brands\",\"etiqueta\": \"Faltan por enviar\"}, {\"id\": \"5\",\"servicio\": \"/rest/multireport/insertnt/rvisibility/2\",\"tipo\": \"post\",\"tabla\": \"report_visibility\",\"etiqueta\": \"Faltan por enviar\"}, {\"id\": \"6\",\"servicio\": \"/rest/multireport/insertnt/rvisibilitybrand/1\",\"tipo\": \"post\",\"tabla\": \"report_visibility_brands\",\"etiqueta\": \"Faltan por enviar\"}, {\"id\": \"7\",\"servicio\": \"/rest/multireport/insertnt/poll/1\",\"tipo\": \"post\",\"tabla\": \"EARespuesta\",\"etiqueta\": \"Faltan por enviar\"}, {\"id\": \"8\",\"servicio\": \"/rest/multireport/insertnt/poll/1\",\"tipo\": \"post\",\"tabla\": \"EARespuesta\",\"etiqueta\": \"Faltan por enviar\"}, {\"id\": \"9\",\"servicio\": \"/rest/multireport/insertnt/rskarep/1\",\"tipo\": \"post\",\"tabla\": \"rskarep\",\"etiqueta\": \"Faltan por enviar\"}, {\"id\": \"11\",\"servicio\": \"/rest/multireport/insertnt/poll/1\",\"tipo\": \"foto\",\"tablas\": [{\"id\": \"id\",\"tabla\": \"report_photo_distribution\",\"ruta\": \"path\",\"query\": \"select t1.*,t2.hash as hash_report from report_photo_distribution t1,report_distribution t2 where t1.idReporteLocal='@idReporteLocal' and t1.id_report_distribution=t2.id\",\"servicio\": \"/rest/multireport/image/rdistribution/1\"}, {\"id\": \"id\",\"tabla\": \"report_photo_promotions\",\"ruta\": \"path\",\"query\": \"select t1.*,t2.hash as hash_report from report_photo_promotions t1,report_promotions t2 where t1.id_report_local='@idReporteLocal' and t1.id_report_promotion=t2.id\",\"servicio\": \"/rest/multireport/image/rpromo/2\"}, {\"id\": \"id\",\"tabla\": \"report_photo_visibility\",\"ruta\": \"path\",\"query\": \"select t1.*,t2.hash as hash_report from report_photo_visibility t1,report_visibility t2 where t1.id_report_local='@idReporteLocal' and t1.id_report_visibility=t2.id\",\"servicio\": \"/rest/multireport/image/rvisibility/2\"}, {\"id\": \"id\",\"tabla\": \"EARespuesta\",\"ruta\": \"respuesta\",\"query\": \"select t1.*,t1.hash as hash_report from EARespuesta t1,ea_question t2 where t1.idReporteLocal='@idReporteLocal' and t1.idPregunta=t2.id and t2.type_question=15\",\"servicio\": \"/rest/multireport/image/poll/1\"}],\"etiqueta\": \"Subiendo Fotos\"}, {\"id\": \"3\",\"servicio\": \"/diageo-capabilities-rest/rest/report/update/@idReportServer\",\"tipo\": \"update\",\"tabla\": \"report\",\"columna\": \"idReportServer\",\"variable\": \"idReportServer\",\"etiqueta\": \"Actualizando...\"}]"
        
        //let dataFromString = json_servicio.data(using: String.Encoding.utf8, allowLossyConversion: false)
        servicios_json = JSON(cadena: json_servicio)
        
        servicios_json_enviar = JSON(cadena: json_servicio_enviar)
        
        
        
        
        
        super.init()
        
    }
    
    //fin inicializacion
    
    
    // MARK: - Funciones de servicios
    
    //nueva forma de servicio
    
    func peticion(👾:String,metodo:String,parametros:AnyObject?=nil,credenciales:URLCredential?=nil,controlador:AnyObject?=nil,indice:Int?=nil,ids:[NSNumber]?=nil)-> Void{
        
        print("vamos en el servicio \(indice!) de \(servicios_json.arreglo.count) y el servicio es \(👾)")
        
        var aux_elementos:[[String:AnyObject]] = []
        
        var servicios_indices:[NSNumber] = []
        
        
        
        if ids == nil {
            
            for q in 0 ..< servicios_json.arreglo.count {
                
                //print(servicios_json.arreglo[q])
                
                let aux_id = servicios_json.arreglo[q]["id"] as! NSString
                
                let aux_idNumber = NSNumber.init( value: aux_id.integerValue)
                
                servicios_indices.append(aux_idNumber)
                
            }
            
        }
        else {
            
            for renglon in ids!{
                
                servicios_indices.append(renglon)
                
            }
        }
        
        let todoEndpoint: String = 👾
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        
        
        
        
        
        
        let configuracion:URLSessionConfiguration = URLSessionConfiguration.ephemeral
        
        
        
        let sesion = URLSession(configuration: configuracion, delegate: self, delegateQueue: nil)
        
        
        
        
        switch metodo {
            
        case "zip":
            
            guard let url = URL(string: "https://pruebas-e24c5.firebaseapp.com/OnTrade2.zip") else {
                print("Error: cannot create URL")
                return
            }
            
            urlRequest = URLRequest(url: url)
            
            let tarea = sesion.downloadTask(with: urlRequest) {
                (data, response, error) in
                // Errores
                guard error == nil else {
                    print(" Error en la petición del servicio policy")
                    print(error!)
                    return
                }
                //Hay data
                guard let responseData = data else {
                    print("Error: servicio viene vacio")
                    return
                }
                //checar si es diccionario o arreglo
                //print(data as Any)
                print("la respuesta es")
                let realResponse = response as! HTTPURLResponse
                //print(realResponse)
                switch realResponse.statusCode {
                    
                case 200:
                    
                    //actualizar texto cargador
                    
                    let controladorActual = UIApplication.topViewController()
                    
                    DispatchQueue.main.async {
                        
                        let subvistas = controladorActual?.view!.subviews
                        
                        for subvista in subvistas! where subvista.tag == 179 {
                            
                            let subvistasCargador = subvista.subviews
                            
                            for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                                
                                
                                
                                let auxTexto = "\(String(describing: self.servicios_json.arreglo[indice!]["etiqueta"] as! String)) \(Int(((indice! + 1)*100)/self.servicios_json.arreglo.count))%"
                                
                                //let auxTexto = "\(String(describing: self.servicios_json.arreglo[indice!]["etiqueta"] as! String))"
                                
                                (subvistaCargador as! UIButton).setTitle(auxTexto, for: .normal)
                                
                            }
                            
                            subvista.gestureRecognizers?.removeAll()
                            
                        }
                        
                    }
                    
                    //fin actualizar texto cargador
                    
                    
                    //vamos a copiar el archivo
                    
                    let archivoZip = "OnTrade.zip"
                    
                    let documents_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                    
                    let documents = Bundle.main.resourcePath
                    
                    let path = documents!.stringByAppendingPathComponent(archivoZip)
                    
                    let path_documents = documents_path.stringByAppendingPathComponent(archivoZip)
                    
                    let checkValidation = FileManager.default
                    
                    if (checkValidation.fileExists(atPath: path_documents))
                    {
                        // print("FILE AVAILABLE");
                        
                        do {
                            try checkValidation.removeItem(atPath: path_documents)
                            print("se borro el archivo zip \(path_documents)")
                        } catch let error as NSError {
                            print(error.debugDescription)
                        }
                        
                    }
                    
                    
                        //  print("FILE NOT AVAILABLE");
                        
                        do {
                            try checkValidation.copyItem(at: data!, to: URL(fileURLWithPath: path_documents))
                            
                            //aqui ya tenemos el zip
                            
                            do {
                                //let filePath = Bundle.main.url(forResource: "file", withExtension: "zip")!
                                let documentsDirectory = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0]
                                try Zip.unzipFile(URL(fileURLWithPath: path_documents), destination: documentsDirectory, overwrite: true, password: "password", progress: { (progress) -> () in
                                    print(progress)
                                }) // Unzip
                                
                                
                                ///para movernos de aqui
                                
                                
                                let hoy = Date()
                                
                                self.defaults.set(hoy, forKey: "ultimaActualizacion")
                                
                                print("mi controlador es")
                                print(controlador as Any)
                                
                                let funcion = "inicio"
                                
                                if let aux_controlador = controlador as? LoginController {
                                    
                                    print("si entramos al controlador")
                                    
                                    switch funcion {
                                        
                                    case "inicio":
                                        //SwiftSpinner.hide()
                                        aux_controlador.ir_inicio()
                                    default:
                                        break
                                        
                                    }
                                    
                                    
                                }
                                
                                
                                
                                
                                
                                
                                //actualizar texto cargador
                                
                                let controladorActual = UIApplication.topViewController()
                                
                                DispatchQueue.main.async {
                                    
                                    let subvistas = controladorActual?.view!.subviews
                                    
                                    for subvista in subvistas! where subvista.tag == 179 {
                                        
                                        let subvistasCargador = subvista.subviews
                                        
                                        for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                                            
                                            (subvistaCargador as! UIButton).setTitle("Sincronización Completa. Toque para cerrar", for: .normal)
                                            
                                        }
                                        
                                        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.ocultarCargador(sender:)))
                                        singleTap.cancelsTouchesInView = false
                                        singleTap.numberOfTapsRequired = 1
                                        subvista.addGestureRecognizer(singleTap)
                                        
                                    }
                                    
                                }
                                
                                //fin actualizar texto cargador
                                
                                
                                //fin para movernos de aqui
                               
                                
                            }
                            catch {
                                print("Something went wrong")
                            }
                            
                            
                        } catch (let writeError) {
                            print("error writing file \(path_documents) : \(writeError)")
                        }
                        
                    
                    
                    
                    
                    
                    //fin de copiar el archivo
                    
                    
                    
                case 401:
                    
                    print("Credenciales incorrectas")
                    
                case 402:
                    
                    let alertController = UIAlertController(title: "¡Atención!", message: "Su contraseña esta caduca es necesario actualizarla", preferredStyle: .alert)
                    
                    
                    let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        
                        print("se presiono Aceptar")
                        
                        if let aux_controlador = controlador as? LoginController {
                            
                            aux_controlador.performSegue(withIdentifier: "logintocambiocontrasena", sender: aux_controlador)
                            
                        }
                        else{
                            
                            if let aux_controlador = controlador as? MenuController {
                                
                                aux_controlador.performSegue(withIdentifier: "menutocambiodecontrasena", sender: aux_controlador)
                                
                            }
                            else{
                                
                                if let aux_controlador = controlador as? InicioController {
                                    
                                    aux_controlador.performSegue(withIdentifier: "iniciotocambiocontrasena", sender: aux_controlador)
                                    
                                }
                                
                            }
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                    alertController.addAction(okAction)
                    
                    let controladorActual = UIApplication.topViewController()
                    
                    controladorActual?.present(alertController, animated: true, completion: nil)
                    
                case 420:
                    
                    DispatchQueue.main.async {
                        
                        let controladorActual = UIApplication.topViewController()
                        
                        let subvistas = controladorActual?.view!.subviews
                        
                        for subvista in subvistas! where subvista.tag == 179 {
                            
                            let subvistasCargador = subvista.subviews
                            
                            for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                                
                                (subvistaCargador as! UIButton).setTitle("Demasiados intentos incorrectos, espere unos minutos y vuelva intentar. Toque para cerrar", for: .normal)
                                
                            }
                            
                            
                            let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.ocultarCargador(sender:)))
                            singleTap.cancelsTouchesInView = false
                            singleTap.numberOfTapsRequired = 1
                            subvista.addGestureRecognizer(singleTap)
                            
                            
                        }
                        
                    }
                    
                default:
                    print("Estatus http no manejado \(realResponse.statusCode)")
                    
                    
                    let aux = indice! + 1
                    
                    guard aux < self.servicios_json.arreglo.count else {
                        let hoy = Date()
                        
                        self.defaults.set(hoy, forKey: "ultimaActualizacion")
                        
                        
                        
                        self.llenar_tablas(ids: servicios_indices,controlador: controlador,funcion: "inicio")
                        
                        return
                    }
                    
                    
                    
                    
                    let 🤖 = "\(self.protocolo)://\(self.dominio)\(self.servicios_json.arreglo[aux]["servicio"] as! String)"
                    
                    let tipo = self.servicios_json.arreglo[aux]["tipo"] as! String
                    
                    self.peticion(👾: 🤖, metodo: tipo, controlador: controlador, indice: aux)
                    
                    
                }
                
                
            }
            tarea.resume()
            
        case "policy":
            
            
            let tarea = sesion.dataTask(with: urlRequest) {
                (data, response, error) in
                // Errores
                guard error == nil else {
                    print(" Error en la petición del servicio policy")
                    print(error!)
                    return
                }
                //Hay data
                guard let responseData = data else {
                    print("Error: servicio viene vacio")
                    return
                }
                //checar si es diccionario o arreglo
                //print(data as Any)
                print("la respuesta es")
                let realResponse = response as! HTTPURLResponse
                //print(realResponse)
                switch realResponse.statusCode {
                    
                case 200:
                    
                    //actualizar texto cargador
                    
                    let controladorActual = UIApplication.topViewController()
                    
                    DispatchQueue.main.async {
                        
                        let subvistas = controladorActual?.view!.subviews
                        
                        for subvista in subvistas! where subvista.tag == 179 {
                            
                            let subvistasCargador = subvista.subviews
                            
                            for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                                
                                
                                
                                let auxTexto = "\(String(describing: self.servicios_json.arreglo[indice!]["etiqueta"] as! String)) \(Int(((indice! + 1)*100)/self.servicios_json.arreglo.count))%"
                                
                                //let auxTexto = "\(String(describing: self.servicios_json.arreglo[indice!]["etiqueta"] as! String))"
                                
                                (subvistaCargador as! UIButton).setTitle(auxTexto, for: .normal)
                                
                            }
                            
                            subvista.gestureRecognizers?.removeAll()
                            
                        }
                        
                    }
                    
                    //fin actualizar texto cargador
                    
                    
                    
                    
                    do {
                        
                        
                        
                        
                        guard let datos = try JSONSerialization.jsonObject(with: responseData, options: [])
                            as? [String: Any] else {
                                print("No es diccionario policy")
                                return
                        }
                        
                        //print(datos.description)
                        
                        
                        print("el estatus es (👾) ")
                        
                        //print(datos["status"] as Any)
                        
                        
                        
                        
                        
                        let aux = indice! + 1
                        
                        guard aux < self.servicios_json.arreglo.count else {
                            let hoy = Date()
                            
                            self.defaults.set(hoy, forKey: "ultimaActualizacion")
                            
                            
                            
                            
                            self.llenar_tablas(ids: servicios_indices,controlador: controlador,funcion: "inicio")
                            
                            return
                        }
                        
                        
                        
                        
                        let 🤖 = "\(self.protocolo)://\(self.dominio)\(self.servicios_json.arreglo[aux]["servicio"] as! String)"
                        
                        let tipo = self.servicios_json.arreglo[aux]["tipo"] as! String
                        
                        self.peticion(👾: 🤖, metodo: tipo, controlador: controlador, indice: aux)
                        
                        
                        
                        //fin checar si es diccionario o arreglo
                        
                        
                        
                    } catch  {
                        print("error al parsear el json")
                        return
                    }
                    
                case 401:
                    
                    print("Credenciales incorrectas")
                    
                case 402:
                    
                    let alertController = UIAlertController(title: "¡Atención!", message: "Su contraseña esta caduca es necesario actualizarla", preferredStyle: .alert)
                    
                    
                    let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        
                        print("se presiono Aceptar")
                        
                        if let aux_controlador = controlador as? LoginController {
                            
                            aux_controlador.performSegue(withIdentifier: "logintocambiocontrasena", sender: aux_controlador)
                            
                        }
                        else{
                            
                            if let aux_controlador = controlador as? MenuController {
                                
                                aux_controlador.performSegue(withIdentifier: "menutocambiodecontrasena", sender: aux_controlador)
                                
                            }
                            else{
                                
                                if let aux_controlador = controlador as? InicioController {
                                    
                                    aux_controlador.performSegue(withIdentifier: "iniciotocambiocontrasena", sender: aux_controlador)
                                    
                                }
                                
                            }
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                    alertController.addAction(okAction)
                    
                    let controladorActual = UIApplication.topViewController()
                    
                    controladorActual?.present(alertController, animated: true, completion: nil)
                    
                case 420:
                    
                    DispatchQueue.main.async {
                        
                        let controladorActual = UIApplication.topViewController()
                        
                        let subvistas = controladorActual?.view!.subviews
                        
                        for subvista in subvistas! where subvista.tag == 179 {
                            
                            let subvistasCargador = subvista.subviews
                            
                            for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                                
                                (subvistaCargador as! UIButton).setTitle("Demasiados intentos incorrectos, espere unos minutos y vuelva intentar. Toque para cerrar", for: .normal)
                                
                            }
                            
                            
                            let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.ocultarCargador(sender:)))
                            singleTap.cancelsTouchesInView = false
                            singleTap.numberOfTapsRequired = 1
                            subvista.addGestureRecognizer(singleTap)
                            
                            
                        }
                        
                    }
                    
                default:
                    print("Estatus http no manejado \(realResponse.statusCode)")
                    
                    
                    let aux = indice! + 1
                    
                    guard aux < self.servicios_json.arreglo.count else {
                        let hoy = Date()
                        
                        self.defaults.set(hoy, forKey: "ultimaActualizacion")
                        
                        
                        
                        self.llenar_tablas(ids: servicios_indices,controlador: controlador,funcion: "inicio")
                        
                        return
                    }
                    
                    
                    
                    
                    let 🤖 = "\(self.protocolo)://\(self.dominio)\(self.servicios_json.arreglo[aux]["servicio"] as! String)"
                    
                    let tipo = self.servicios_json.arreglo[aux]["tipo"] as! String
                    
                    self.peticion(👾: 🤖, metodo: tipo, controlador: controlador, indice: aux)
                    
                    
                }
                
                
            }
            tarea.resume()
            
        case "get":
            
            
            let tarea = sesion.dataTask(with: urlRequest) {
                (data, response, error) in
                // Errores
                guard error == nil else {
                    print(" Error en la petición del servicio get")
                    print(error!)
                    
                    
                    
                    
                    
                    return
                }
                //Hay data
                guard let responseData = data else {
                    print("Error: servicio viene vacio")
                    return
                }
                //checar si es diccionario o arreglo
                //print(data as Any)
                print("la respuesta es")
                print("respuesta del servicio \(indice!) de \(self.servicios_json.arreglo.count) y el servicio es \(👾)")
                let realResponse = response as! HTTPURLResponse
                //print(realResponse)
                switch realResponse.statusCode {
                    
                case 200:
                    
                    let controladorActual = UIApplication.topViewController()
                    
                    DispatchQueue.main.async {
                        
                        let subvistas = controladorActual?.view!.subviews
                        
                        for subvista in subvistas! where subvista.tag == 179 {
                            
                            let subvistasCargador = subvista.subviews
                            
                            for subvistaCargador in subvistasCargador where subvistaCargador is UIButton
                            {
                                
                                
                                
                                let auxTexto = "\(String(describing: self.servicios_json.arreglo[indice!]["etiqueta"] as! String)) \(Int(((indice! + 1)*100)/self.servicios_json.arreglo.count))%"
                                
                                //let auxTexto = "\(String(describing: self.servicios_json.arreglo[indice!]["etiqueta"] as! String))"
                                
                                (subvistaCargador as! UIButton).setTitle(auxTexto, for: .normal)
                                
                            }
                            
                        }
                        
                    }
                    
                    
                    
                    do {
                        
                        
                        
                        
                        guard let datos = try JSONSerialization.jsonObject(with: responseData, options: [])
                            as? [String: AnyObject] else {
                                print("No es diccionario")
                                
                                
                                guard let datos = try JSONSerialization.jsonObject(with: responseData, options: [])
                                    as? [[String: AnyObject]] else {
                                        print("No es Arreglo")
                                        return
                                }
                                
                                print("es arreglo")
                                
                                //print(datos.description)
                                
                                aux_elementos = datos
                                
                                
                                self.datos_servicio.append(aux_elementos as AnyObject)
                                
                                self.servicios_json.arreglo[indice!]["datos"] = aux_elementos as AnyObject?
                                
                                
                                let aux = indice! + 1
                                
                                guard aux < self.servicios_json.arreglo.count else {
                                    let hoy = Date()
                                    
                                    self.defaults.set(hoy, forKey: "ultimaActualizacion")
                                    
                                    
                                    
                                    
                                    
                                    
                                    //actualizar texto cargador
                                    
                                    let controladorActual = UIApplication.topViewController()
                                    
                                    DispatchQueue.main.async {
                                        
                                        let subvistas = controladorActual?.view!.subviews
                                        
                                        for subvista in subvistas! where subvista.tag == 179 {
                                            
                                            let subvistasCargador = subvista.subviews
                                            
                                            for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                                                
                                                (subvistaCargador as! UIButton).setTitle("Actualizando Base de Datos...", for: .normal)
                                                
                                            }
                                            
                                            subvista.gestureRecognizers?.removeAll()
                                            
                                        }
                                        
                                    }
                                    
                                    //fin actualizar texto cargador
                                    
                                    
                                    
                                    
                                    
                                    
                                    self.llenar_tablas(ids: servicios_indices,controlador: controlador,funcion: "inicio")
                                    
                                    return
                                }
                                
                                
                                
                                
                                let 🤖 = "\(self.protocolo)://\(self.dominio)\(self.servicios_json.arreglo[aux]["servicio"] as! String)"
                                
                                let tipo = self.servicios_json.arreglo[aux]["tipo"] as! String
                                
                                self.peticion(👾: 🤖, metodo: tipo, controlador: controlador, indice: aux)
                                
                                
                                
                                return
                        }
                        
                        print("es diccionario")
                        
                        //print(datos.description)
                        
                        
                        aux_elementos.append(datos)
                        
                        self.datos_servicio.append(aux_elementos as AnyObject)
                        
                        self.servicios_json.arreglo[indice!]["datos"] = aux_elementos as AnyObject?
                        
                        let aux = indice! + 1
                        
                        guard aux < self.servicios_json.arreglo.count else {
                            let hoy = Date()
                            
                            self.defaults.set(hoy, forKey: "ultimaActualizacion")
                            
                            
                            
                            //actualizar texto cargador
                            
                            let controladorActual = UIApplication.topViewController()
                            
                            DispatchQueue.main.async {
                                
                                let subvistas = controladorActual?.view!.subviews
                                
                                for subvista in subvistas! where subvista.tag == 179 {
                                    
                                    let subvistasCargador = subvista.subviews
                                    
                                    for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                                        
                                        (subvistaCargador as! UIButton).setTitle("Actualizando Base de Datos...", for: .normal)
                                        
                                    }
                                    
                                    subvista.gestureRecognizers?.removeAll()
                                    
                                }
                                
                            }
                            
                            //fin actualizar texto cargador
                            
                            
                            
                            
                            self.llenar_tablas(ids: servicios_indices,controlador: controlador,funcion: "inicio")
                            
                            return
                        }
                        
                        
                        
                        
                        let 🤖 = "\(self.protocolo)://\(self.dominio)\(self.servicios_json.arreglo[aux]["servicio"] as! String)"
                        
                        let tipo = self.servicios_json.arreglo[aux]["tipo"] as! String
                        
                        self.peticion(👾: 🤖, metodo: tipo, controlador: controlador, indice: aux)
                        
                        
                        //fin checar si es diccionario o arreglo
                        
                        
                        
                    } catch  {
                        print("error al parsear el json")
                        return
                    }
                    
                case 401:
                    
                    print("Credenciales incorrectas")
                    
                case 402:
                    
                    let alertController = UIAlertController(title: "¡Atención!", message: "Su contraseña esta caduca es necesario actualizarla", preferredStyle: .alert)
                    
                    
                    let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        
                        print("se presiono Aceptar")
                        
                        if let aux_controlador = controlador as? LoginController {
                            
                            aux_controlador.performSegue(withIdentifier: "logintocambiocontrasena", sender: aux_controlador)
                            
                        }
                        else{
                            
                            if let aux_controlador = controlador as? MenuController {
                                
                                aux_controlador.performSegue(withIdentifier: "menutocambiodecontrasena", sender: aux_controlador)
                                
                            }
                            else{
                                
                                if let aux_controlador = controlador as? InicioController {
                                    
                                    aux_controlador.performSegue(withIdentifier: "iniciotocambiocontrasena", sender: aux_controlador)
                                    
                                }
                                
                            }
                            
                            
                        }
                        
                        
                    }
                    
                    
                    alertController.addAction(okAction)
                    
                    let controladorActual = UIApplication.topViewController()
                    
                    controladorActual?.present(alertController, animated: true, completion: nil)
                    
                case 420:
                    
                    DispatchQueue.main.async {
                        
                        let controladorActual = UIApplication.topViewController()
                        
                        let subvistas = controladorActual?.view!.subviews
                        
                        for subvista in subvistas! where subvista.tag == 179 {
                            
                            let subvistasCargador = subvista.subviews
                            
                            for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                                
                                (subvistaCargador as! UIButton).setTitle("Demasiados intentos incorrectos, espere unos minutos y vuelva intentar. Toque para cerrar", for: .normal)
                                
                            }
                            
                            
                            let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.ocultarCargador(sender:)))
                            singleTap.cancelsTouchesInView = false
                            singleTap.numberOfTapsRequired = 1
                            subvista.addGestureRecognizer(singleTap)
                            
                            
                        }
                        
                    }
                    
                default:
                    print("Estatus http no manejado \(realResponse.statusCode)")
                    
                    let aux = indice! + 1
                    
                    guard aux < self.servicios_json.arreglo.count else {
                        let hoy = Date()
                        
                        self.defaults.set(hoy, forKey: "ultimaActualizacion")
                        
                        
                        //actualizar texto cargador
                        
                        let controladorActual = UIApplication.topViewController()
                        
                        DispatchQueue.main.async {
                            
                            let subvistas = controladorActual?.view!.subviews
                            
                            for subvista in subvistas! where subvista.tag == 179 {
                                
                                let subvistasCargador = subvista.subviews
                                
                                for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                                    
                                    (subvistaCargador as! UIButton).setTitle("Actualizando Base de Datos...", for: .normal)
                                    
                                }
                                
                                subvista.gestureRecognizers?.removeAll()
                                
                            }
                            
                        }
                        
                        //fin actualizar texto cargador
                        
                        
                        
                        
                        self.llenar_tablas(ids: servicios_indices,controlador: controlador,funcion: "inicio")
                        
                        return
                    }
                    
                    
                    
                    
                    let 🤖 = "\(self.protocolo)://\(self.dominio)\(self.servicios_json.arreglo[aux]["servicio"] as! String)"
                    
                    let tipo = self.servicios_json.arreglo[aux]["tipo"] as! String
                    
                    self.peticion(👾: 🤖, metodo: tipo, controlador: controlador, indice: aux)
                    
                    
                }
                
                
                
                
                
                
            }
            tarea.resume()
            
        case "post","sync":
            
            
            let auxParametros = servicios_json.arreglo[indice!]["parametros"] as! [String:AnyObject]
            
            var auxValor = ""
            
            if auxParametros["value"] as! String == "fecha" {
                
                
                
                let fechaSincronizacion = defaults.object(forKey: "fechaSincronizacion") as? String
                
                
                if fechaSincronizacion == nil {
                    
                    auxValor = "0"
                    
                    let tiempo_milisegundos = String(Int64(NSDate().timeIntervalSince1970*1000))
                    
                    defaults.set(tiempo_milisegundos, forKey: "fechaSincronizacion")
                }
                else{
                    
                    auxValor = defaults.object(forKey: "fechaSincronizacion") as! String
                    
                    let tiempo_milisegundos = String(Int64(NSDate().timeIntervalSince1970*1000))
                    
                    defaults.set(tiempo_milisegundos, forKey: "fechaSincronizacion")
                    
                }
                
                
            }
            
            
            if auxParametros["value"] as! String == "email_support" {
                
                auxValor = "email_support"
                
            }
            
            
            var parametros:[[String : AnyObject]] = []
            
            let parametro_udid = [
                "name": "\(auxParametros["name"] as! String)",
                "value": auxValor
            ]
            
            parametros.append(parametro_udid as [String : AnyObject])
            
            
            let auxJsonstring = parametros.toJsonString()
            
            urlRequest.httpMethod = "POST"
            
            let preParametros = "json=\(auxJsonstring)"
            
            //print(preParametros)
            
            urlRequest.httpBody = preParametros.data(using: .utf8)
            
            
            let tarea = sesion.dataTask(with: urlRequest) {
                (data, response, error) in
                // Errores
                guard error == nil else {
                    print(" Error en la petición del servicio")
                    print(error!)
                    return
                }
                //Hay data
                guard let responseData = data else {
                    print("Error: servicio viene vacio")
                    return
                }
                
                
                //checar si es diccionario o arreglo
                //print(data as Any)
                print("la respuesta es")
                print("respuesta del servicio \(indice!) de \(self.servicios_json.arreglo.count) y el servicio es \(👾)")
                let realResponse = response as! HTTPURLResponse
                //print(realResponse)
                switch realResponse.statusCode {
                    
                    
                case 200:
                    
                    do {
                        
                        
                        guard let datos = try JSONSerialization.jsonObject(with: responseData, options: [])
                            as? [String: AnyObject] else {
                                print("No es diccionario")
                                
                                
                                
                                guard let datos = try JSONSerialization.jsonObject(with: responseData, options: [])
                                    as? [[String: AnyObject]] else {
                                        print("No es Arreglo")
                                        return
                                }
                                
                                print("es arreglo")
                                
                                
                                let aux_elementos = datos
                                
                                
                                self.datos_servicio.append(aux_elementos as AnyObject)
                                
                                self.servicios_json.arreglo[indice!]["datos"] = aux_elementos as AnyObject?
                                
                                
                                let aux = indice! + 1
                                
                                guard aux < self.servicios_json.arreglo.count else {
                                    let hoy = Date()
                                    
                                    self.defaults.set(hoy, forKey: "ultimaActualizacion")
                                    
                                    
                                    //actualizar texto cargador
                                    
                                    let controladorActual = UIApplication.topViewController()
                                    
                                    DispatchQueue.main.async {
                                        
                                        let subvistas = controladorActual?.view!.subviews
                                        
                                        for subvista in subvistas! where subvista.tag == 179 {
                                            
                                            let subvistasCargador = subvista.subviews
                                            
                                            for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                                                
                                                (subvistaCargador as! UIButton).setTitle("Actualizando Base de Datos...", for: .normal)
                                                
                                            }
                                            
                                            subvista.gestureRecognizers?.removeAll()
                                            
                                        }
                                        
                                    }
                                    
                                    //fin actualizar texto cargador
                                    
                                    
                                    
                                    self.llenar_tablas(ids: servicios_indices,controlador: controlador,funcion: "inicio")
                                    
                                    return
                                }
                                
                                
                                
                                
                                let 🤖 = "\(self.protocolo)://\(self.dominio)\(self.servicios_json.arreglo[aux]["servicio"] as! String)"
                                
                                let tipo = self.servicios_json.arreglo[aux]["tipo"] as! String
                                
                                self.peticion(👾: 🤖, metodo: tipo, controlador: controlador, indice: aux)
                                
                                
                                
                                return
                        }
                        
                        print("es diccionario")
                        
                        
                        var aux_elementos:[[String:AnyObject]] = []
                        
                        aux_elementos.append(datos)
                        
                        self.datos_servicio.append(aux_elementos as AnyObject)
                        
                        self.servicios_json.arreglo[indice!]["datos"] = aux_elementos as AnyObject?
                        
                        
                        let aux = indice! + 1
                        
                        guard aux < self.servicios_json.arreglo.count else {
                            let hoy = Date()
                            
                            self.defaults.set(hoy, forKey: "ultimaActualizacion")
                            
                            
                            //actualizar texto cargador
                            
                            let controladorActual = UIApplication.topViewController()
                            
                            DispatchQueue.main.async {
                                
                                let subvistas = controladorActual?.view!.subviews
                                
                                for subvista in subvistas! where subvista.tag == 179 {
                                    
                                    let subvistasCargador = subvista.subviews
                                    
                                    for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                                        
                                        (subvistaCargador as! UIButton).setTitle("Actualizando Base de Datos...", for: .normal)
                                        
                                    }
                                    
                                    subvista.gestureRecognizers?.removeAll()
                                    
                                }
                                
                            }
                            
                            //fin actualizar texto cargador
                            
                            
                           
                            self.llenar_tablas(ids: servicios_indices,controlador: controlador,funcion: "inicio")
                            
                            return
                        }
                        
                        
                        
                        
                        let 🤖 = "\(self.protocolo)://\(self.dominio)\(self.servicios_json.arreglo[aux]["servicio"] as! String)"
                        
                        let tipo = self.servicios_json.arreglo[aux]["tipo"] as! String
                        
                        self.peticion(👾: 🤖, metodo: tipo, controlador: controlador, indice: aux)
                        
                    } catch  {
                        print("error al parsear el json")
                        return
                    }
                    
                case 401:
                    
                    print("Credenciales incorrectas")
                case 402:
                    
                    let alertController = UIAlertController(title: "¡Atención!", message: "Su contraseña esta caduca es necesario actualizarla", preferredStyle: .alert)
                    
                    
                    let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        
                        print("se presiono Aceptar")
                        
                        if let aux_controlador = controlador as? LoginController {
                            
                            aux_controlador.performSegue(withIdentifier: "logintocambiocontrasena", sender: aux_controlador)
                            
                        }
                        else{
                            
                            if let aux_controlador = controlador as? MenuController {
                                
                                aux_controlador.performSegue(withIdentifier: "menutocambiodecontrasena", sender: aux_controlador)
                                
                            }
                            else{
                                
                                if let aux_controlador = controlador as? InicioController {
                                    
                                    aux_controlador.performSegue(withIdentifier: "iniciotocambiocontrasena", sender: aux_controlador)
                                    
                                }
                                
                            }
                            
                            
                        }
                        
                        
                    }
                    
                    
                    alertController.addAction(okAction)
                    
                    let controladorActual = UIApplication.topViewController()
                    
                    controladorActual?.present(alertController, animated: true, completion: nil)
                    
                case 420:
                    
                    DispatchQueue.main.async {
                        
                        let controladorActual = UIApplication.topViewController()
                        
                        let subvistas = controladorActual?.view!.subviews
                        
                        for subvista in subvistas! where subvista.tag == 179 {
                            
                            let subvistasCargador = subvista.subviews
                            
                            for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                                
                                (subvistaCargador as! UIButton).setTitle("Demasiados intentos incorrectos, espere unos minutos y vuelva intentar. Toque para cerrar", for: .normal)
                                
                            }
                            
                            
                            let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.ocultarCargador(sender:)))
                            singleTap.cancelsTouchesInView = false
                            singleTap.numberOfTapsRequired = 1
                            subvista.addGestureRecognizer(singleTap)
                            
                            
                        }
                        
                    }
                    
                    
                default:
                    print("Estatus http no manejado \(realResponse.statusCode)")
                }
                
                
                
                
                
                
            }
            tarea.resume()
            
            
            
        default:
            print("metodo de protocolo no manejado")
            
            
            let aux = indice! + 1
            
            guard aux < self.servicios_json.arreglo.count else {
                let hoy = Date()
                
                self.defaults.set(hoy, forKey: "ultimaActualizacion")
                
                
                //actualizar texto cargador
                
                let controladorActual = UIApplication.topViewController()
                
                DispatchQueue.main.async {
                    
                    let subvistas = controladorActual?.view!.subviews
                    
                    for subvista in subvistas! where subvista.tag == 179 {
                        
                        let subvistasCargador = subvista.subviews
                        
                        for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                            
                            (subvistaCargador as! UIButton).setTitle("Actualizando Base de Datos...", for: .normal)
                            
                        }
                        
                        subvista.gestureRecognizers?.removeAll()
                        
                    }
                    
                }
                
                //fin actualizar texto cargador
                
                
                
                
                self.llenar_tablas(ids: servicios_indices,controlador: controlador,funcion: "inicio")
                
                return
            }
            
            
            
            
            let 🤖 = "\(self.protocolo)://\(self.dominio)\(self.servicios_json.arreglo[aux]["servicio"] as! String)"
            
            let tipo = self.servicios_json.arreglo[aux]["tipo"] as! String
            
            self.peticion(👾: 🤖, metodo: tipo, controlador: controlador, indice: aux)
            
            
        }
        
        
    }
    
    
    
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        print("tenemos challege")
        
        guard challenge.previousFailureCount == 0 else {
            challenge.sender?.cancel(challenge)
            // Inform the user that the user name and password are incorrect
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        let usuario = defaults.object(forKey: "usuario") as! String
        let contrasena = defaults.object(forKey: "contrasena") as! String
        
        defaults.set(usuario, forKey: "ultimoUsuario")
        defaults.set(contrasena, forKey: "ultimaContrasena")
        
        let proposedCredential = URLCredential(user: usuario, password: contrasena, persistence: .none)
        completionHandler(.useCredential, proposedCredential)
    }
    
    
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void){
        
        print("tenemos challege task")
        
        
        if challenge.previousFailureCount > 0 {
            
            print("Credenciales incorrectas")
            
            //actualizar texto cargador
            
            let controladorActual = UIApplication.topViewController()
            
            DispatchQueue.main.async {
                
                let subvistas = controladorActual?.view!.subviews
                
                for subvista in subvistas! where subvista.tag == 179 {
                    
                    let subvistasCargador = subvista.subviews
                    
                    for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                        
                        (subvistaCargador as! UIButton).setTitle("Credenciales incorrectas. Toque para volver intentar", for: .normal)
                        
                    }
                    
                    
                    let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.ocultarCargador(sender:)))
                    singleTap.cancelsTouchesInView = false
                    singleTap.numberOfTapsRequired = 1
                    subvista.addGestureRecognizer(singleTap)
                    
                    
                }
                
            }
            
            //fin actualizar texto cargador
            
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
        } else {
            
            let usuario = defaults.object(forKey: "usuario") as! String
            let contrasena = defaults.object(forKey: "contrasena") as! String
            
            defaults.set(usuario, forKey: "ultimoUsuario")
            defaults.set(contrasena, forKey: "ultimaContrasena")
            
            
            
            let credential = URLCredential(user:usuario, password:contrasena, persistence: .none)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential,credential)
        }
        
        
        
    }
    
    //fin nuevo forma de servicios
    
    //funcion iniciar_sesion
    
    func iniciar_sesion(usuario:String,contrasena:String,controlador:AnyObject?=nil){
        
        
        
        defaults.set(usuario, forKey: "usuario")
        
        defaults.set(contrasena, forKey: "contrasena")
        
        if Reachability.isConnectedToNetwork() {
            
            let auxSesion = defaults.object(forKey: "sesion")
            
            if auxSesion != nil {
                
                if auxSesion as! NSNumber == 1 || auxSesion as! NSNumber == 3 {
                    
                    print("ya hay sesion")
                }
                if auxSesion as! NSNumber == 0 {
                    
                    //limpiar_base()
                    
                    defaults.removeObject(forKey: "fechaSincronizacion")
                    
                }
                
            }
            else{
                defaults.removeObject(forKey: "fechaSincronizacion")
                //limpiar_base()
                
            }
            
            acomodar_base()
            
            //servicio_seriado(usuario: usuario, contrasena: contrasena, indice: 0,controlador:controlador,funcion:"inicio")
            
            let 🤖 = "\(self.protocolo)://\(self.dominio)\(self.servicios_json.arreglo[0]["servicio"] as! String)"
            
            let tipo = self.servicios_json.arreglo[0]["tipo"] as! String
            
            self.peticion(👾: 🤖, metodo: tipo, controlador: controlador, indice: 0)
            
            
        }
        else{
            
            
            //actualizar texto cargador
            
            let controladorActual = UIApplication.topViewController()
            
            DispatchQueue.main.async {
                
                let subvistas = controladorActual?.view!.subviews
                
                for subvista in subvistas! where subvista.tag == 179 {
                    
                    let subvistasCargador = subvista.subviews
                    
                    for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                        
                        (subvistaCargador as! UIButton).setTitle("Necesitas tener una conexión a internet", for: .normal)
                        
                    }
                    
                    let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.ocultarCargador(sender:)))
                    singleTap.cancelsTouchesInView = false
                    singleTap.numberOfTapsRequired = 1
                    subvista.addGestureRecognizer(singleTap)
                    
                }
                
            }
            
            //fin actualizar texto cargador
            
            
            //SwiftSpinner.show("Necesitas tener una conexión a internet").addTapHandler({SwiftSpinner.hide()})
            
        }
        
    }
    
    func sincronizar(controlador:AnyObject,acomodar:Int?=nil){
        
        
        if acomodar == nil {
            
            acomodar_base()
            
        }
        
        let 🤖 = "\(self.protocolo)://\(self.dominio)\(self.servicios_json.arreglo[0]["servicio"] as! String)"
        
        let tipo = self.servicios_json.arreglo[0]["tipo"] as! String
        
        self.peticion(👾: 🤖, metodo: tipo, controlador: controlador, indice: 0)
        
    }
    
    //fin iniciar_sesion
    
    
    
    
    
    
    
    //servicio seriados enviar
    
    func servicio_seriado_enviar (usuario:String,contrasena:String,indice:Int,ids:[NSNumber]?=nil,controlador:AnyObject?=nil,funcion:String?=nil,code:Int?=nil){
        
        //print("mi controlador es \(controlador) y la funcion es \(funcion)")
        
        print("voy en el indice \(indice)")
        
        //print(ids as Any)
        
        var servicios_indices_enviar:[NSNumber] = []
        
        
        
        if ids == nil {
            
            for q in 0 ..< servicios_json_enviar.arreglo.count {
                
                print(servicios_json_enviar.arreglo[q])
                
                let aux_id = servicios_json_enviar.arreglo[q]["id"] as! NSString
                
                let aux_idNumber = NSNumber.init( value: aux_id.integerValue)
                
                servicios_indices_enviar.append(aux_idNumber)
                
            }
            
        }
        else {
            
            for renglon in ids!{
                
                servicios_indices_enviar.append(renglon)
                
            }
        }
        
        //print(servicios_indices_enviar)
        
        if indice < servicios_json_enviar.arreglo.count {
            
            //DispatchQueue.as
            
            DispatchQueue.main.async {
                
                
                if indice  == 0 {
                    
                    let sqlTotal = "select id,idSchedule,version,idTipo,place,hash,checkIn,checkInTz,checkInLat,checkInLon,checkInImei,checkInAccuracy,checkInSateliteUTC,checkOut,checkOutTz,checkOutLat,checkOutLon,checkOutImei,checkOutAccuracy,checkOutSateliteUTC from report where enviado = 0 and checkOut <> '' and idTipo <> '-1'"
                    
                    print(sqlTotal)
                    
                    
                    
                    let resultadoTotal = self.db.select_query_columns_string(sqlTotal)
                    
                    self.reporteAEnviar = resultadoTotal.count
                    
                }
                
                
                //actualizar texto cargador
                
                let controladorActual = UIApplication.topViewController()
                
                DispatchQueue.main.async {
                    
                    let subvistas = controladorActual?.view!.subviews
                    
                    for subvista in subvistas! where subvista.tag == 179 {
                        
                        let subvistasCargador = subvista.subviews
                        
                        for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                            
                            if self.reporteAEnviar > 0 {
                                
                                (subvistaCargador as! UIButton).setTitle("\(self.servicios_json_enviar.arreglo[indice]["etiqueta"] as! String) \(self.reporteAEnviar) Reportes", for: .normal)
                                
                            }else{
                                
                                (subvistaCargador as! UIButton).setTitle("Todo Enviado. Toque para Cerrar", for: .normal)
                                
                                let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.ocultarCargador(sender:)))
                                singleTap.cancelsTouchesInView = false
                                singleTap.numberOfTapsRequired = 1
                                subvista.addGestureRecognizer(singleTap)
                                
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                //fin actualizar texto cargador
                
                
                
                //_ =  SwiftSpinner.show("\(self.servicios_json_enviar.arreglo[indice]["etiqueta"] as! String) \(self.reporteAEnviar) Reportes")
                
                //self.reporteAEnviar -= 1
            }
            
            
            
            
            _ = ["Content-Encoding": "gzip"]
            
            //let aux_idString = servicios_json_enviar.arreglo[indice]["id"] as! NSString
            
            //let aux_id = NSNumber.init( value: aux_idString.integerValue)
            
            
            
            switch servicios_json_enviar.arreglo[indice]["tipo"] as! String {
                
            case "post":
                
                let aux_url = "\(protocolo)://\(dominio)\(servicios_json_enviar.arreglo[indice]["servicio"] as! String)"
                
                print(aux_url)
                
                var resultado:[[String:String]] = []
                
                var auxJsonstring = ""
                
                
                
                if servicios_json_enviar.arreglo[indice]["tabla"] as! String == "report" {
                    
                    
                    let sql = "select id,idSchedule,version,idTipo,place,hash,checkIn,checkInTz,checkInLat,checkInLon,checkInImei,checkInAccuracy,checkInSateliteUTC,checkOut,checkOutTz,checkOutLat,checkOutLon,checkOutImei,checkOutAccuracy,checkOutSateliteUTC from report where enviado = 0 and checkOut <> '' and idTipo <> '-1' limit 1"
                    
                    print(sql)
                    
                    resultado = db.select_query_columns_string(sql)
                    
                    //print(resultado)
                    
                    for renglon in resultado {
                        
                        let idReportLocal = renglon["id"]!
                        let idPDV = renglon["place"]!
                        
                        defaults.set(idReportLocal, forKey: "idReportEnviando")
                        defaults.set(idPDV, forKey: "idPDVEnviando")
                        
                        auxJsonstring = renglon.toJsonString()
                    }
                    
                    
                    
                }
                
                
                if servicios_json_enviar.arreglo[indice]["tabla"] as! String == "report_distribution" {
                    
                    let idReportServerEnviando = defaults.object(forKey: "idReportServerEnviando") as! String
                    
                    let idReporteLocal = defaults.object(forKey: "idReportEnviando") as! String
                    
                    _ = db.execute_query("update report_distribution set idReportServer = '\(idReportServerEnviando)' where idReporteLocal = '\(idReporteLocal)'")
                    
                    
                    _ = db.execute_query("update report set idReportServer = '\(idReportServerEnviando)' where id = '\(idReporteLocal)'")
                    
                    let sql = "select idReportServer as idReport,t1.id_item as idMeasurementItem,t1.distribution as idDistribution,t1.bootle_price as priceBottle,t1.cup_price as priceCup,t1.hash from report_distribution t1, md_item t2 where t1.id_item = t2.idItemRelation and t1.idReporteLocal='\(idReporteLocal)' and t1.is_send = 0"
                    
                    
                    
                    
                    print(sql)
                    
                    resultado = db.select_query_columns_string(sql)
                    
                    auxJsonstring = resultado.toJsonString()
                    
                    
                    
                }
                
                
                if servicios_json_enviar.arreglo[indice]["tabla"] as! String == "report_promotions" {
                    
                    let idReportServerEnviando = defaults.object(forKey: "idReportServerEnviando") as! String
                    
                    let idReporteLocal = defaults.object(forKey: "idReportEnviando") as! String
                    
                    _ = db.execute_query("update report_promotions set idReportServer = '\(idReportServerEnviando)' where id_report_local = '\(idReporteLocal)'")
                    
                    //_ = db.execute_query("update report set idReportServer = '\(idReportServerEnviando)' where id = '\(idReportLocal)'")
                    
                    let sql = "select idReportServer as idReport,id_type_promotion,hash,other as otro from report_promotions where id_report_local='\(idReporteLocal)'  and is_send = 0"
                    
                    
                    
                    print(sql)
                    
                    resultado = db.select_query_columns_string(sql)
                    
                    auxJsonstring = resultado.toJsonString()
                    
                    
                    
                }
                
                
                if servicios_json_enviar.arreglo[indice]["tabla"] as! String == "report_promtions_brands" {
                    
                    let idReportServerEnviando = defaults.object(forKey: "idReportServerEnviando") as! String
                    
                    let idReporteLocal = defaults.object(forKey: "idReportEnviando") as! String
                    
                    _ = db.execute_query("update report_promtions_brands set idReportServer = '\(idReportServerEnviando)' where id_report_local = '\(idReporteLocal)'")
                    
                    //_ = db.execute_query("update report set idReportServer = '\(idReportServerEnviando)' where id = '\(idReportLocal)'")
                    
                    let sql = "select t1.idReportServer as idReport,t1.id_brand,t1.id_category,t1.hash,t2.hash as hash_promo from report_promtions_brands t1,report_promotions t2, report t3   where t1.id_report_promotion = t2.id and t2.id_report_local = '\(idReporteLocal)' and t2.id_report_local=t3.id and t1.is_send = 0"
                    
                    
                    print(sql)
                    
                    resultado = db.select_query_columns_string(sql)
                    
                    auxJsonstring = resultado.toJsonString()
                    
                    
                    
                }
                
                
                if servicios_json_enviar.arreglo[indice]["tabla"] as! String == "report_visibility" {
                    
                    let idReportServerEnviando = defaults.object(forKey: "idReportServerEnviando") as! String
                    
                    let idReporteLocal = defaults.object(forKey: "idReportEnviando") as! String
                    
                    _ = db.execute_query("update report_visibility set idReportServer = '\(idReportServerEnviando)' where id_report_local = '\(idReporteLocal)'")
                    
                    //_ = db.execute_query("update report set idReportServer = '\(idReportServerEnviando)' where id = '\(idReportLocal)'")
                    
                    let sql = "select idReportServer as idReport,hash,id_manufacturer,id_type,other from report_visibility where id_report_local='\(idReporteLocal)' and is_send = 0"
                    
                    
                    print(sql)
                    
                    resultado = db.select_query_columns_string(sql)
                    
                    auxJsonstring = resultado.toJsonString()
                    
                    
                    
                }
                
                
                
                if servicios_json_enviar.arreglo[indice]["tabla"] as! String == "report_visibility_brands" {
                    
                    let idReportServerEnviando = defaults.object(forKey: "idReportServerEnviando") as! String
                    
                    let idReporteLocal = defaults.object(forKey: "idReportEnviando") as! String
                    
                    _ = db.execute_query("update report_visibility_brands set idReportServer = '\(idReportServerEnviando)' where id_report_local = '\(idReporteLocal)'")
                    
                    //_ = db.execute_query("update report set idReportServer = '\(idReportServerEnviando)' where id = '\(idReportLocal)'")
                    
                    let sql = "select t1.idReportServer as idReport,t1.id_brand,t1.id_category,t1.hash,t2.hash as hash_visibility,t1.id_manufacturer from report_visibility_brands t1,report_visibility t2, report t3   where t1.id_report_visibility = t2.id and t2.id_report_local = '\(idReporteLocal)' and t2.id_report_local=t3.id and t1.is_send = 0"
                    
                    
                    print(sql)
                    
                    resultado = db.select_query_columns_string(sql)
                    
                    auxJsonstring = resultado.toJsonString()
                    
                    
                    
                }
                
                
                
                if servicios_json_enviar.arreglo[indice]["tabla"] as! String == "EARespuesta" {
                    
                    let idReportServerEnviando = defaults.object(forKey: "idReportServerEnviando") as! String
                    
                    let idReporteLocal = defaults.object(forKey: "idReportEnviando") as! String
                    
                    _ = db.execute_query("update EARespuesta set idReportServer = '\(idReportServerEnviando)' where idReporteLocal = '\(idReporteLocal)'")
                    
                    //_ = db.execute_query("update report set idReportServer = '\(idReportServerEnviando)' where id = '\(idReportLocal)'")
                    
                    let sql = "select hash,idPregunta,idEncuesta,idReportServer as idReport,numeroEncuesta,respuesta,campoExtra1,campoExtra2 from EARespuesta where idReporteLocal='\(idReporteLocal)' and enviado=0"
                    
                    
                    print(sql)
                    
                    resultado = db.select_query_columns_string(sql)
                    
                    auxJsonstring = resultado.toJsonString()
                    
                    
                    
                }
                
                
                if servicios_json_enviar.arreglo[indice]["tabla"] as! String == "rskarep" {
                    
                    let idReportServerEnviando = defaults.object(forKey: "idReportServerEnviando") as! String
                    
                    let idReporteLocal = defaults.object(forKey: "idReportEnviando") as! String
                    
                    _ = db.execute_query("update rskarep set idReportServer = '\(idReportServerEnviando)' where idReporteLocal = '\(idReporteLocal)'")
                    
                    
                    
                    let sql = "select hash,idReportServer as idReport,idPdv from rskarep where idReporteLocal='\(idReporteLocal)' and enviado=0"
                    
                    
                    print(sql)
                    
                    resultado = db.select_query_columns_string(sql)
                    
                    auxJsonstring = resultado.toJsonString()
                    
                    
                    
                }
                
                
                // Alamofire.request(aux_url, method: .get, encoding: JSONEncoding.default)
                
                
                
                
                
                if auxJsonstring != "" {
                    
                    
                    
                    let todoEndpoint: String = aux_url
                    guard let url = URL(string: todoEndpoint) else {
                        print("Error: cannot create URL")
                        return
                    }
                    var urlRequest = URLRequest(url: url)
                    
                    urlRequest.httpMethod = "POST"
                    
                    let escapeJsonstring = auxJsonstring.escapeStr()
                    
                    let preParametros = "json=\(escapeJsonstring)"
                    
                    //print(auxJsonstring)
                    
                    urlRequest.httpBody = preParametros.data(using: .utf8)
                    
                    let configuracion:URLSessionConfiguration = URLSessionConfiguration.ephemeral
                    
                    
                    let sesion = URLSession(configuration: configuracion, delegate: self, delegateQueue: nil)
                    
                    
                    let tarea = sesion.dataTask(with: urlRequest) {
                        (data, response, error) in
                        // Errores
                        guard error == nil else {
                            print(" Error en la petición del servicio")
                            print(error!)
                            return
                        }
                        //Hay data
                        guard let responseData = data else {
                            print("Error: servicio viene vacio")
                            return
                        }
                        //checar si es diccionario o arreglo
                        //print(data as Any)
                        print("la respuesta es")
                        let realResponse = response as! HTTPURLResponse
                        //print(realResponse)
                        switch realResponse.statusCode {
                            
                        case 200:
                            
                            switch self.servicios_json_enviar.arreglo[indice]["tabla"] as! String {
                                
                            case "report":
                                
                                print("bien pero no creo nada")
                                
                            case "ea_answers":
                                
                                
                                
                                let idReportServerEnviando = self.defaults.object(forKey: "idReportServerEnviando") as! String
                                self.completar_envio(idReportServer: idReportServerEnviando,code:code)
                                
                                
                                
                                
                            default:
                                print("no se que hacer con esta tabla")
                                
                            }
                            
                            let aux = indice + 1
                            
                            self.servicio_seriado_enviar(usuario: usuario,contrasena: contrasena,indice: aux,ids: servicios_indices_enviar,controlador: controlador,funcion: funcion,code:code)
                            
                        case 400:
                            
                            switch self.servicios_json_enviar.arreglo[indice]["tabla"] as! String {
                                
                            case "report":
                                
                                print("bien pero no creo nada")
                                
                            case "ea_answers":
                                
                                
                                
                                let idReportServerEnviando = self.defaults.object(forKey: "idReportServerEnviando") as! String
                                self.completar_envio(idReportServer: idReportServerEnviando,code:400)
                                
                                
                                
                                
                            default:
                                print("no se que hacer con esta tabla")
                                
                            }
                            
                            let aux = indice + 1
                            
                            
                            self.servicio_seriado_enviar(usuario: usuario,contrasena: contrasena,indice: aux,ids: servicios_indices_enviar,controlador: controlador,funcion: funcion,code:400)
                            
                            
                        case 201:
                            
                            
                            
                            if self.servicios_json_enviar.arreglo[indice]["tabla"] as! String == "report" {
                                
                                
                                
                                self.defaults.set(responseData.stringValue, forKey: "idReportServerEnviando")
                            }
                            
                            
                            
                            let aux = indice + 1
                            
                            self.servicio_seriado_enviar(usuario: usuario,contrasena: contrasena,indice: aux,ids: servicios_indices_enviar,controlador: controlador,funcion: funcion)
                            
                            
                        case 401:
                            
                            print("Credenciales incorrectas")
                        case 402:
                            
                            let alertController = UIAlertController(title: "¡Atención!", message: "Su contraseña esta caduca es necesario actualizarla", preferredStyle: .alert)
                            
                            
                            let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                                
                                print("se presiono Aceptar")
                                
                                if let aux_controlador = controlador as? LoginController {
                                    
                                    aux_controlador.performSegue(withIdentifier: "logintocambiocontrasena", sender: aux_controlador)
                                    
                                }
                                else{
                                    
                                    if let aux_controlador = controlador as? MenuController {
                                        
                                        aux_controlador.performSegue(withIdentifier: "menutocambiodecontrasena", sender: aux_controlador)
                                        
                                    }
                                    else{
                                        
                                        if let aux_controlador = controlador as? InicioController {
                                            
                                            aux_controlador.performSegue(withIdentifier: "iniciotocambiocontrasena", sender: aux_controlador)
                                            
                                        }
                                        
                                    }
                                    
                                    
                                }
                                
                                
                            }
                            
                            
                            alertController.addAction(okAction)
                            
                            let controladorActual = UIApplication.topViewController()
                            
                            controladorActual?.present(alertController, animated: true, completion: nil)
                            
                        case 420:
                            
                            DispatchQueue.main.async {
                                
                                let controladorActual = UIApplication.topViewController()
                                
                                let subvistas = controladorActual?.view!.subviews
                                
                                for subvista in subvistas! where subvista.tag == 179 {
                                    
                                    let subvistasCargador = subvista.subviews
                                    
                                    for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                                        
                                        (subvistaCargador as! UIButton).setTitle("Demasiados intentos incorrectos, espere unos minutos y vuelva intentar. Toque para cerrar", for: .normal)
                                        
                                    }
                                    
                                    
                                    let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.ocultarCargador(sender:)))
                                    singleTap.cancelsTouchesInView = false
                                    singleTap.numberOfTapsRequired = 1
                                    subvista.addGestureRecognizer(singleTap)
                                    
                                    
                                }
                                
                            }
                            
                        default:
                            print("Estatus http no manejado \(realResponse.statusCode)")
                        }
                        
                        
                    }
                    tarea.resume()
                    
                    
                    
                    
                    
                    
                }
                else{
                    print("todo enviado")
                    
                    //actualizar texto cargador
                    
                    let controladorActual = UIApplication.topViewController()
                    
                    DispatchQueue.main.async {
                        
                        let subvistas = controladorActual?.view!.subviews
                        
                        for subvista in subvistas! where subvista.tag == 179 {
                            
                            let subvistasCargador = subvista.subviews
                            
                            for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                                
                                (subvistaCargador as! UIButton).setTitle("Todo enviado toque para cerrar", for: .normal)
                                
                            }
                            
                            let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.ocultarCargador(sender:)))
                            singleTap.cancelsTouchesInView = false
                            singleTap.numberOfTapsRequired = 1
                            subvista.addGestureRecognizer(singleTap)
                            
                        }
                        
                        
                        
                        
                    }
                    
                    //fin actualizar texto cargador
                    
                }
                
            case "foto":
                
                
                let tablas = servicios_json_enviar.arreglo[indice]["tablas"] as! [[String:AnyObject]]
                
                var fotos:[[String:AnyObject]] = [[:]]
                
                fotos.removeAll()
                
                for tabla in tablas {
                    
                    
                    let idReporteLocal = defaults.object(forKey: "idReportEnviando") as! String
                    
                    let idPDV = defaults.object(forKey: "idPDVEnviando") as! String
                    
                    let sqlFotos = (tabla["query"] as! String).replacingOccurrences(of: "@idReporteLocal", with: idReporteLocal)
                    
                    print(sqlFotos)
                    
                    let resultadoFotos = db.select_query_columns(sqlFotos)
                    
                    for renglon in resultadoFotos {
                        
                        fotos.append([String:AnyObject]())
                        
                        
                        
                        let auxPath = renglon["\(tabla["ruta"] as! String)"] as! String
                        
                        let aux_nombre_imagen = auxPath.components(separatedBy: "/")
                        
                        let imagen_ruta = fileInDocumentsDirectory(filename: aux_nombre_imagen[aux_nombre_imagen.count - 1])
                        
                        fotos[fotos.count - 1]["imagen"] = renglon["path"]
                        fotos[fotos.count - 1]["ruta"] = imagen_ruta as AnyObject?
                        fotos[fotos.count - 1]["hash"] = renglon["hash_report"]
                        fotos[fotos.count - 1]["pdv"] = idPDV as AnyObject?
                        fotos[fotos.count - 1]["descripcion"] = tabla["tabla"]
                        fotos[fotos.count - 1]["tabla"] = tabla["tabla"]
                        fotos[fotos.count - 1]["id"] = String(describing: renglon["\(tabla["id"] as! String)"] as! NSNumber) as AnyObject?
                        fotos[fotos.count - 1]["servicio"] = "\(protocolo)://\(dominio)\(tabla["servicio"] as! String)" as AnyObject?
                        
                        
                        
                    }
                    
                    
                    
                    
                }
                
                mandar_fotos(indice: 0, fotos: fotos)
                
            default:
                
                print("tipo  no manejado")
                
                let aux = indice + 1
                
                self.servicio_seriado_enviar(usuario: usuario,contrasena: contrasena,indice: aux,ids: servicios_indices_enviar,controlador: controlador,funcion: funcion)
                
            }
            
        }
        
        
        
        
        
    }
    
    
    func completar_envio(idReportServer:String,code:Int?=nil){
        
        
        let aux_url = "\(protocolo)://\(dominio)/rest/report/update/\(idReportServer)"
        
        print(aux_url)
        
        let usuario = defaults.object(forKey: "usuario") as! String
        let contrasena = defaults.object(forKey: "contrasena") as! String
        
        
        //let auxJsonstring = "[{\"name\":\"idRol\",\"value\":\"1\"},{\"name\":\"usuario\",\"value\":\"\(idUser)\"},{\"name\":\"tipo\",\"value\":\"1\"}]"
        
        
        
        
        //let parameters: Parameters = ["json": auxJsonstring]
        
        //print(parameters)
        
        let credenciales = URLCredential(user: usuario, password: contrasena, persistence: .none)
        
        Alamofire.request(aux_url, method: .post, encoding: JSONEncoding.default)
            //Alamofire.request(.GET, "\(protocolo)://\(dominio)\(servicios_json.arreglo[indice]["servicio"])",headers:headers)
            .authenticate(usingCredential: credenciales)
            .responseJSON { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                let sqlEnviado = "update report set enviado = 1 where idReportServer = '\(idReportServer)'"
                
                print(sqlEnviado)
                
                if code == nil {
                    
                    _ = self.db.execute_query(sqlEnviado)
                    _ = self.db.execute_query("update report_distribution set is_send = 1 where idReportServer = '\(idReportServer)'")
                    _ = self.db.execute_query("update report_photo_distribution set is_send = 1 where idReportServer = '\(idReportServer)'")
                    _ = self.db.execute_query("update report_photo_promotions set is_send = 1 where idReportServer = '\(idReportServer)'")
                    _ = self.db.execute_query("update report_photo_visibility set is_send = 1 where idReportServer = '\(idReportServer)'")
                    _ = self.db.execute_query("update report_promotions set is_send = 1 where idReportServer = '\(idReportServer)'")
                    _ = self.db.execute_query("update report_promtions_brands set is_send = 1 where idReportServer = '\(idReportServer)'")
                    _ = self.db.execute_query("update report_visibility set is_send = 1 where idReportServer = '\(idReportServer)'")
                    _ = self.db.execute_query("update report_visibility_brands set is_send = 1 where idReportServer = '\(idReportServer)'")
                    _ = self.db.execute_query("update EARespuesta set enviado = 1 where idReportServer = '\(idReportServer)'")
                    
                }
                
                
                self.servicio_seriado_enviar(usuario: usuario, contrasena: contrasena, indice: 0)
                
                if response.result.isFailure {
                    
                    //print(response.request)
                    //SwiftSpinner.show("Error al contactar el servidor").addTapHandler({SwiftSpinner.hide()})
                    
                    
                    
                }
                else{
                    
                    
                    
                }
                
                
                
                
                
        }
        
        
        
    }
    
    //nuevo mandar imagenes
    
    func mandar_fotos(indice:Int,fotos:[[String:AnyObject]]){
        
        
        if indice >= fotos.count {
            
            let idReportServerEnviando = self.defaults.object(forKey: "idReportServerEnviando") as! String
            self.completar_envio(idReportServer: idReportServerEnviando)
            
        }
        else{
            
            
            //actualizar texto cargador
            
            let controladorActual = UIApplication.topViewController()
            
            DispatchQueue.main.async {
                
                let subvistas = controladorActual?.view!.subviews
                
                for subvista in subvistas! where subvista.tag == 179 {
                    
                    let subvistasCargador = subvista.subviews
                    
                    for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                        
                        (subvistaCargador as! UIButton).setTitle("Mandando Fotos \(indice + 1) de \(fotos.count)", for: .normal)
                        
                    }
                    
                    subvista.gestureRecognizers?.removeAll()
                    
                }
                
            }
            
            //fin actualizar texto cargador
            
            
            
            
            
            guard let _ = NSData(contentsOfFile: fotos[indice]["ruta"] as! String) else {
                print("no hay foto")
                
                let sql = "update \(fotos[indice]["tabla"] as! String) set is_send=1 where id='\(fotos[indice]["id"] as! String)'"
                
                
                
                let resultado_update = self.db.execute_query(sql)
                
                
                print(sql)
                print("puso el uno es \(resultado_update)")
                
                let indiceNuevo = indice + 1
                
                self.mandar_fotos(indice: indiceNuevo, fotos: fotos)
                
                return
            }
            
            print("si hay foto")
            
            let data2 = NSData(contentsOfFile: fotos[indice]["ruta"] as! String)!
            
            let datos = Data(referencing: data2)
            
            
            let auxMD5 = datos.md5()
            
            var md5Archivo = ""
            
            for dato in auxMD5 {
                
                md5Archivo +=  String(format: "%02X", dato)
            }
            
            let hash = fotos[indice]["hash"] as! String
            let pdv = fotos[indice]["pdv"] as! String
            let descripcion = fotos[indice]["descripcion"] as! String
            
            
            
            
            let usuario = defaults.object(forKey: "usuario") as? String
            let contrasena = defaults.object(forKey: "contrasena") as? String
            
            let credenciales = URLCredential(user: usuario!, password: contrasena!, persistence: .none)
            
            let fileUrl = URL(fileURLWithPath: fotos[indice]["ruta"] as! String)
            
            let aux_url = fotos[indice]["servicio"] as! String
            
            print(md5Archivo)
            print(hash)
            print(pdv)
            print(descripcion)
            
            md5Archivo = md5Archivo.lowercased()
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(fileUrl, withName: "imagen")
                    multipartFormData.append(md5Archivo.data(using: String.Encoding.utf8, allowLossyConversion: false)! ,withName: "md5")
                    multipartFormData.append(hash.data(using: String.Encoding.utf8, allowLossyConversion: false)! ,withName: "hash")
                    multipartFormData.append(pdv.data(using: String.Encoding.utf8, allowLossyConversion: false)! ,withName: "pdv")
                    multipartFormData.append(descripcion.data(using: String.Encoding.utf8, allowLossyConversion: false)! ,withName: "description")
            },
                to: aux_url,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.authenticate(usingCredential: credenciales)
                            .uploadProgress { progress in // main queue by default
                                print("Upload Progress: \(progress.fractionCompleted)")
                        }
                        upload.responseString { response in
                            debugPrint(response)
                            
                            
                            //actualizar texto cargador
                            
                            let controladorActual = UIApplication.topViewController()
                            
                            DispatchQueue.main.async {
                                
                                let subvistas = controladorActual?.view!.subviews
                                
                                for subvista in subvistas! where subvista.tag == 179 {
                                    
                                    let subvistasCargador = subvista.subviews
                                    
                                    for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                                        
                                        (subvistaCargador as! UIButton).setTitle("Base enviada. Toque para cerrar", for: .normal)
                                        
                                    }
                                    
                                    let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.ocultarCargador(sender:)))
                                    singleTap.cancelsTouchesInView = false
                                    singleTap.numberOfTapsRequired = 1
                                    subvista.addGestureRecognizer(singleTap)
                                    
                                    
                                }
                                
                            }
                            
                            
                        }
                        upload.responseJSON { response in
                            
                            //Spinner.hide()
                            
                            print("Response Foto \(fotos[indice]["tabla"] as! String)")
                            debugPrint(response)
                            
                            
                            
                            let sql = "update \(fotos[indice]["tabla"] as! String) set is_send=1 where id='\(fotos[indice]["id"] as! String)'"
                            
                            
                            
                            let resultado_update = self.db.execute_query(sql)
                            
                            
                            
                            
                            let base = self.defaults.object(forKey: "base") as! String
                            
                            self.db.open_database(base)
                            
                            let indiceNuevo = indice + 1
                            
                            self.mandar_fotos(indice: indiceNuevo, fotos: fotos)
                            
                            
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                    }
            }
            )
            
            
            
            
            
            
        }
        
    }
    
    
    //fin nuevo mandar imagenes
    
    
    
    // MARK: - Funciones de base de datos
    //limpiar base
    
    func limpiar_base()  {
        
        
        //print("vamos abrir la base \(base!)")
        
        
        let base = defaults.object(forKey: "base") as! String
        
        
        
        let documents_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let documents = Bundle.main.resourcePath
        
        _ = documents!.stringByAppendingPathComponent(base)
        
        let path_documents = documents_path.stringByAppendingPathComponent(base)
        
        
        let fileManager = FileManager.default
        
        let filePath = path_documents
        do {
            try fileManager.removeItem(atPath: filePath)
            print("se borro el archivo de la base \(filePath)")
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
        
        
        
        self.db.open_database(base)
        
        var sql = ""
        
        sql = "delete from report"
        
        _ = self.db.execute_query(sql)
        
        sql = "delete from report_distribution"
        
        _ = self.db.execute_query(sql)
        
        sql = "delete from report_photo_distribution"
        
        _ = self.db.execute_query(sql)
        
        sql = "delete from report_photo_promotions"
        
        _ = self.db.execute_query(sql)
        
        sql = "delete from report_photo_visibility"
        
        _ = self.db.execute_query(sql)
        
        sql = "delete from report_promotions"
        
        _ = self.db.execute_query(sql)
        
        sql = "delete from report_promtions_brands"
        
        _ = self.db.execute_query(sql)
        
        sql = "delete from report_visibility"
        
        _ = self.db.execute_query(sql)
        
        sql = "delete from report_visibility_brands"
        
        _ = self.db.execute_query(sql)
        
        
        for q in 0 ..< servicios_json.arreglo.count {
            
            sql = "delete from \(String(describing: servicios_json.arreglo[q]["tabla"]))"
            
            _ = self.db.execute_query(sql)
            
        }
        
    }
    
    //fin limpiar base
    
    // MARK: - Funciones que muestran en pantalla
    
    func mostrarCargador(){
        
        let controladorActual = UIApplication.topViewController()
        
        //print(controladorActual as Any)
        
        let vistaCargador:UIScrollView = UIScrollView()
        
        let subvistas = vistaCargador.subviews
        
        for subvista in subvistas {
            
            subvista.removeFromSuperview()
            
        }
        
        vistaCargador.tag = 179
        
        vistaCargador.frame = (controladorActual?.view!.frame)!
        
        vistaCargador.backgroundColor = UIColor.white
        
        let auxColor:UIColor = UIColor(rgba: "#ba243d")
        
        let vistaLoading = NVActivityIndicatorView(frame: CGRect(x: vistaCargador.frame.width/4, y: vistaCargador.frame.height/4, width: vistaCargador.frame.width/2, height: vistaCargador.frame.height/2),color:auxColor)
        
        vistaLoading.type = .ballScaleMultiple
        
        vistaCargador.addSubview(vistaLoading)
        
        controladorActual?.view!.addSubview(vistaCargador)
        
        vistaLoading.startAnimating()
        
        let textoCargador:UIButton = UIButton()
        
        textoCargador.frame = CGRect(x: 0, y: vistaCargador.frame.height*0.70, width: vistaCargador.frame.width, height: vistaCargador.frame.height*0.1)
        
        textoCargador.setTitle("Contactando al servidor...", for: .normal)
        textoCargador.setTitleColor(auxColor, for: .normal)
        
        textoCargador.setAttributedTitle(nil, for: UIControlState())
        
        //textoCargador.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        textoCargador.titleLabel!.font = textoCargador.titleLabel!.font.withSize(CGFloat(20))
        
        
        textoCargador.isSelected = false
        
        //textoCargador.backgroundColor = auxColor
        
        
        textoCargador.titleLabel!.textColor = auxColor
        textoCargador.titleLabel!.numberOfLines = 0
        textoCargador.titleLabel!.textAlignment = .center
        
        vistaCargador.addSubview(textoCargador)
        
        
    }
    
    
    //acomodar base
    
    func acomodar_base(){
        
        print("Acomodando base.....")
        
        let base = defaults.object(forKey: "base") as! String
        
        let baseB = defaults.object(forKey: "baseB") as! String
        
        self.db.open_database(base)
        
        var sql = ""
        
        sql = "pragma integrity_check"
        
        let resultadoPragma = self.db.execute_query(sql)
        
        print(resultadoPragma)
        
        guard resultadoPragma.0 else {
            
            print("vamos a reparar la base")
            
            //reportes
            
            sql = "select * from report"
            
            var resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(base)
            
            
            
            self.db.open_database(baseB)
            
            sql = "delete from report"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("report", datos: resultatoReportes)
            
            sql = "select * from report"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            //fin reportes
            
            
            //reporte distribucion
            
            self.db.close_database(baseB)
            
            self.db.open_database(base)
            
            sql = "select * from report_distribution"
            
            resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(base)
            
            self.db.open_database(baseB)
            
            sql = "delete from report_distribution"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("report_distribution", datos: resultatoReportes)
            
            sql = "select * from report_distribution"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            
            
            //fin reporte distribucion
            
            
            // reporte foto distribucion
            
            self.db.close_database(baseB)
            
            self.db.open_database(base)
            
            sql = "select * from report_photo_distribution"
            
            resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(base)
            
            self.db.open_database(baseB)
            
            sql = "delete from report_photo_distribution"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("report_photo_distribution", datos: resultatoReportes)
            
            sql = "select * from report_photo_distribution"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            
            //fin reporte foto distribucion
            
            
            
            //reporte foto promocion
            
            
            self.db.close_database(baseB)
            
            self.db.open_database(base)
            
            sql = "select * from report_photo_promotions"
            
            resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(base)
            
            self.db.open_database(baseB)
            
            sql = "delete from report_photo_promotions"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("report_photo_promotions", datos: resultatoReportes)
            
            sql = "select * from report_photo_promotions"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            
            //fin reporte foto promocion
            
            
            //reporte foto visibilidad
            
            
            self.db.close_database(baseB)
            
            self.db.open_database(base)
            
            sql = "select * from report_photo_visibility"
            
            resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(base)
            
            self.db.open_database(baseB)
            
            sql = "delete from report_photo_visibility"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("report_photo_visibility", datos: resultatoReportes)
            
            sql = "select * from report_photo_visibility"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            
            //fin reporte foto visibilidad
            
            
            
            //reporte promociones
            
            
            self.db.close_database(baseB)
            
            self.db.open_database(base)
            
            sql = "select * from report_promotions"
            
            resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(base)
            
            self.db.open_database(baseB)
            
            sql = "delete from report_promotions"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("report_promotions", datos: resultatoReportes)
            
            sql = "select * from report_promotions"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            
            //fin reporte promociones
            
            
            //reporte promociones marcas
            
            self.db.close_database(baseB)
            
            self.db.open_database(base)
            
            sql = "select * from report_promtions_brands"
            
            resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(base)
            
            self.db.open_database(baseB)
            
            sql = "delete from report_promtions_brands"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("report_promtions_brands", datos: resultatoReportes)
            
            sql = "select * from report_promtions_brands"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            //reportes promociones marcas
            
            
            //reporte visibilidad
            
            
            self.db.close_database(baseB)
            
            self.db.open_database(base)
            
            sql = "select * from report_visibility"
            
            resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(base)
            
            self.db.open_database(baseB)
            
            sql = "delete from report_visibility"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("report_visibility", datos: resultatoReportes)
            
            sql = "select * from report_visibility"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            
            // fin reporte visibilidad
            
            
            //reporte marcas visibilidad
            
            self.db.close_database(baseB)
            
            self.db.open_database(base)
            
            sql = "select * from report_visibility_brands"
            
            resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(base)
            
            self.db.open_database(baseB)
            
            sql = "delete from report_visibility_brands"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("report_visibility_brands", datos: resultatoReportes)
            
            sql = "select * from report_visibility_brands"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            //fin reporte marcas visibilidad
            
            
            //enucestas
            
            self.db.close_database(baseB)
            
            self.db.open_database(base)
            
            sql = "select * from EARespuesta"
            
            resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(base)
            
            self.db.open_database(baseB)
            
            sql = "delete from EARespuesta"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("EARespuesta", datos: resultatoReportes)
            
            sql = "select * from EARespuesta"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            //fin encuestas
            
            //reporte ska
            
            self.db.close_database(baseB)
            
            self.db.open_database(base)
            
            sql = "select * from rskarep"
            
            resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(base)
            
            self.db.open_database(baseB)
            
            sql = "delete from rskarep"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("rskarep", datos: resultatoReportes)
            
            sql = "select * from rskarep"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            //fin reporte ska
            
            
            
            let base = defaults.object(forKey: "base") as! String
            
            
            
            let documents_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            
            let documents = Bundle.main.resourcePath
            
            _ = documents!.stringByAppendingPathComponent(base)
            
            let path_documents = documents_path.stringByAppendingPathComponent(base)
            
            
            let fileManager = FileManager.default
            
            let filePath = path_documents
            do {
                try fileManager.removeItem(atPath: filePath)
                print("se borro el archivo de la base \(filePath)")
            } catch let error as NSError {
                print(error.debugDescription)
            }
            
            
            
            
            print("vamos a regresar los datos a la base")
            
            //reportes
            
            
            
            self.db.close_database(baseB)
            
            self.db.open_database(baseB)
            
            sql = "select * from report"
            
            resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(baseB)
            
            
            self.db.open_database(base)
            
            sql = "delete from report"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("report", datos: resultatoReportes)
            
            sql = "select * from report"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            //fin reportes
            
            
            //reporte distribucion
            
            self.db.close_database(base)
            
            self.db.open_database(baseB)
            
            sql = "select * from report_distribution"
            
            resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(baseB)
            
            self.db.open_database(base)
            
            sql = "delete from report_distribution"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("report_distribution", datos: resultatoReportes)
            
            sql = "select * from report_distribution"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            
            
            //fin reporte distribucion
            
            
            // reporte foto distribucion
            
            self.db.close_database(base)
            
            self.db.open_database(baseB)
            
            sql = "select * from report_photo_distribution"
            
            resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(baseB)
            
            self.db.open_database(base)
            
            sql = "delete from report_photo_distribution"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("report_photo_distribution", datos: resultatoReportes)
            
            sql = "select * from report_photo_distribution"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            
            //fin reporte foto distribucion
            
            
            
            //reporte foto promocion
            
            
            self.db.close_database(base)
            
            self.db.open_database(baseB)
            
            sql = "select * from report_photo_promotions"
            
            resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(baseB)
            
            self.db.open_database(base)
            
            sql = "delete from report_photo_promotions"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("report_photo_promotions", datos: resultatoReportes)
            
            sql = "select * from report_photo_promotions"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            
            //fin reporte foto promocion
            
            
            //reporte foto visibilidad
            
            
            self.db.close_database(base)
            
            self.db.open_database(baseB)
            
            sql = "select * from report_photo_visibility"
            
            resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(baseB)
            
            self.db.open_database(base)
            
            sql = "delete from report_photo_visibility"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("report_photo_visibility", datos: resultatoReportes)
            
            sql = "select * from report_photo_visibility"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            
            //fin reporte foto visibilidad
            
            
            
            //reporte promociones
            
            
            self.db.close_database(base)
            
            self.db.open_database(baseB)
            
            sql = "select * from report_promotions"
            
            resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(baseB)
            
            self.db.open_database(base)
            
            sql = "delete from report_promotions"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("report_promotions", datos: resultatoReportes)
            
            sql = "select * from report_promotions"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            
            //fin reporte promociones
            
            
            //reporte promociones marcas
            
            self.db.close_database(base)
            
            self.db.open_database(baseB)
            
            sql = "select * from report_promtions_brands"
            
            resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(baseB)
            
            self.db.open_database(base)
            
            sql = "delete from report_promtions_brands"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("report_promtions_brands", datos: resultatoReportes)
            
            sql = "select * from report_promtions_brands"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            //reportes promociones marcas
            
            
            //reporte visibilidad
            
            
            self.db.close_database(base)
            
            self.db.open_database(baseB)
            
            sql = "select * from report_visibility"
            
            resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(baseB)
            
            self.db.open_database(base)
            
            sql = "delete from report_visibility"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("report_visibility", datos: resultatoReportes)
            
            sql = "select * from report_visibility"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            
            // fin reporte visibilidad
            
            
            //reporte marcas visibilidad
            
            self.db.close_database(base)
            
            self.db.open_database(baseB)
            
            sql = "select * from report_visibility_brands"
            
            resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(baseB)
            
            self.db.open_database(base)
            
            sql = "delete from report_visibility_brands"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("report_visibility_brands", datos: resultatoReportes)
            
            sql = "select * from report_visibility_brands"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            //fin reporte marcas visibilidad
            
            //reporte encuestas
            
            self.db.close_database(base)
            
            self.db.open_database(baseB)
            
            sql = "select * from EARespuesta"
            
            resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(baseB)
            
            self.db.open_database(base)
            
            sql = "delete from EARespuesta"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("EARespuesta", datos: resultatoReportes)
            
            sql = "select * from EARespuesta"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            //fin reporte encuestas
            
            
            //reporte ska
            
            self.db.close_database(base)
            
            self.db.open_database(baseB)
            
            sql = "select * from rskarep"
            
            resultatoReportes = db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            self.db.close_database(baseB)
            
            self.db.open_database(base)
            
            sql = "delete from rskarep"
            
            _ = self.db.execute_query(sql)
            
            _ = self.db.insert_bulk("rskarep", datos: resultatoReportes)
            
            sql = "select * from rskarep"
            
            resultatoReportes = self.db.select_query_columns(sql)
            
            //print(resultatoReportes)
            
            
            //fin reporte ska
            
            mostrarCargador()
            
            let controladorActual = UIApplication.topViewController()
            
            sincronizar(controlador:controladorActual!,acomodar:0)
            
            return
        }
        
        
        
        sql = "ALTER TABLE md_item ADD COLUMN order_by INTEGER"
        
        _ = self.db.execute_query(sql)
        
        
        sql = "CREATE TABLE IF NOT EXISTS 'support_phone' ('value' TEXT)"
        
        _ = self.db.execute_query(sql)
        
        
        sql = "CREATE TABLE IF NOT EXISTS 'app_property' ('value' TEXT)"
        
        _ = self.db.execute_query(sql)
        
        sql = "update report set checkInSateliteUTC = '0' where checkInSateliteUTC = ''"
        
        _ = self.db.execute_query(sql)
        
        
        sql = "update report set checkOutSateliteUTC = '0' where checkOutSateliteUTC = ''"
        
        _ = self.db.execute_query(sql)
        
        
        
        sql = "CREATE TABLE IF NOT EXISTS 'rskarep' ('idReportServer' integer,'idReporteLocal' integer,'idPdv' integer,'hash' TEXT,'enviado' integer default 0)"
        
        _ = self.db.execute_query(sql)
        
        //sql = "update report set enviado = 1 where id = '181'"
        
        //_ = self.db.execute_query(sql)
        
        
        
        
       
        let sqlReportesRepetidos = "SELECT y.id,y.checkIn,y.idReportServer FROM report y INNER JOIN (SELECT idReportServer, COUNT(*) AS CountOf FROM report GROUP BY idReportServer HAVING COUNT(*)>1) dt ON y.idReportServer=dt.idReportServer order  by y.id ASC"
        
        let resultadoReportesRepetidos = self.db.select_query_columns(sqlReportesRepetidos)
        
        for (indice,renglonReporte) in resultadoReportesRepetidos.enumerated() {
            
            
            if indice > 0 {
                
                var sqlReporteRepetido = "update report set idReportServer = '',enviado = 0 where id = \(renglonReporte["id"] as! Int)"
                
                _ = self.db.execute_query(sqlReporteRepetido)
                
                
                
                
                sqlReporteRepetido = "update report_distribution set idReportServer = '',is_send = 0 where idReporteLocal = \(renglonReporte["id"] as! Int)"
                
                _ =  self.db.execute_query(sqlReporteRepetido)
                
                
                sqlReporteRepetido = "update report_promotions set idReportServer = '',is_send = 0 where idReporteLocal = \(renglonReporte["id"] as! Int)"
                
                
                
                _ =  self.db.execute_query(sqlReporteRepetido)
                
                sqlReporteRepetido = "update report_promotions_brands set idReportServer = '',is_send = 0 where idReporteLocal = \(renglonReporte["id"] as! Int)"
                
                
                
                _ =  self.db.execute_query(sqlReporteRepetido)
                
                sqlReporteRepetido = "update report_visibility set idReportServer = '',is_send = 0 where idReporteLocal = \(renglonReporte["id"] as! Int)"
                
                
                
                _ =  self.db.execute_query(sqlReporteRepetido)
                
                sqlReporteRepetido = "update report_visibility_brands set idReportServer = '',is_send = 0 where idReporteLocal = \(renglonReporte["id"] as! Int)"
                
                _ =  self.db.execute_query(sqlReporteRepetido)
                
                sqlReporteRepetido = "update report_photo_distribution set is_send = 0 where idReporteLocal = '\(renglonReporte["id"] as! Int)'"
                
                _ = self.db.execute_query(sqlReporteRepetido)
                
                sqlReporteRepetido = "update report_photo_promotions set is_send = 0 where id_report_local = '\(renglonReporte["id"] as! Int)'"
                
                _ = self.db.execute_query(sqlReporteRepetido)
                
                sqlReporteRepetido = "update report_photo_visibility set is_send = 0 where id_report_local = '\(renglonReporte["id"] as! Int)'"
                
                _ = self.db.execute_query(sqlReporteRepetido)
                
                
                
                
            }
            
        }
        
        
        
        
        
    }
    
    //fin acomodar base
    
    
    
    //fin servicio seriado enviar
    
    @objc func ocultarCargador(sender:UITapGestureRecognizer){
        
        let subvistas = sender.view!.superview!.subviews
        
        for subvista in subvistas where subvista.tag == 179 {
            
            DispatchQueue.main.async {
                
                subvista.removeFromSuperview()
                
            }
            
        }
        
        
        
        
        
        
        
    }
    
    
    
   
    
    
    //llenar tablas
    
    func llenar_tablas(ids:[NSNumber]?=nil,controlador:AnyObject?=nil,funcion:String?=nil){
        
        print("mi controlador es \(String(describing: controlador)) y la funcion es \(String(describing: funcion))")
        
        var hoy = Date()
        
        let ayer = Calendar.current.date(byAdding: .day, value: -2, to: hoy)
        
        self.defaults.set(ayer, forKey: "ultimaActualizacion")
        
        var servicios_indices:[NSNumber] = []
        
        if ids == nil {
            
            for q in 0 ..< servicios_json.arreglo.count {
                
                
                
                let aux_idString = servicios_json.arreglo[q]["id"] as! NSString
                
                let aux_id = NSNumber.init( value: aux_idString.integerValue)
                
                servicios_indices.append(aux_id)
                
            }
            
        }
        else {
            
            for renglon in ids!{
                
                servicios_indices.append(renglon)
                
            }
        }
        
        print(servicios_indices)
        
        let base = defaults.object(forKey: "base") as! String
        
        self.db.open_database(base)
        
        for q in 0 ..< servicios_json.arreglo.count {
            
            
            
            let aux_idString = servicios_json.arreglo[q]["id"] as! NSString
            
            let aux_id = NSNumber.init( value: aux_idString.integerValue)
            
            switch servicios_json.arreglo[q]["tipo"] as! String {
                
            case "get" where servicios_indices.contains(aux_id):
                
                let tabla = servicios_json.arreglo[q]["tabla"] as! String
                
                print("la tabla es \(tabla)")
                
                let sql_delete = "delete from '\(tabla)'"
                
                print(sql_delete)
                
                let resultado_delete = db.execute_query(sql_delete)
                
                print(resultado_delete)
                
                print("los datos a insertar")
                //print(self.servicios_json.arreglo[q]["datos"] as! [[String : AnyObject]])
                
                let resultado_insert = db.insert_bulk(tabla, datos: self.servicios_json.arreglo[q]["datos"] as! [[String : AnyObject]])
                
                print(resultado_insert)
            case "post":
                
                let tabla = servicios_json.arreglo[q]["tabla"] as! String
                
                print("la tabla es \(tabla)")
                
                //let sql_delete = "delete from \(tabla)"
                
                //let resultado_delete = db.execute_query(sql_delete)
                
                //print(resultado_delete)
                
                
                let resultado_insert = db.insert_bulk(tabla, datos: self.servicios_json.arreglo[q]["datos"] as! [[String : AnyObject]])
                
                print(resultado_insert)
                
            case "sync":
                
                
                
                
                
                let aux_datos = self.servicios_json.arreglo[q]["datos"]
                
                if (aux_datos?.count)! > 0 {
                    
                    
                    let tabla = "\(String(describing: servicios_json.arreglo[q]["tabla"]))"
                    
                    print(self.servicios_json.arreglo[q]["datos"] as Any as Any)
                    
                    //let resultado_insert = db.insert_sync(tabla, datos: self.servicios_json[q]["datos"])
                    
                    //print(resultado_insert)
                    
                    let fecha_sync = String(Int64(NSDate().timeIntervalSince1970*1000))
                    
                    
                    let sql_fecha_sync = "update \(tabla) set \(String(describing: servicios_json.arreglo[q]["columna"])) = '\(fecha_sync)'"
                    
                    print(sql_fecha_sync)
                    
                    let resultado_fecha_sync = db.execute_query(sql_fecha_sync)
                    
                    print(resultado_fecha_sync)
                }
                
                
            default:
                print("tipo no manejado al insertar")
            }
            
            
            
            
            
            
            
        }
        
        let sqlExpiryDate = "select max(end) as date from md_expiry_daterange"
        
        let resultadosqlExpiryDates = db.select_query_columns(sqlExpiryDate)
        
        let fechaExpiry = resultadosqlExpiryDates[0]["date"] as! NSNumber
        
        let sqlBorrarExpiry = "delete from prellenado_distribution_ss where check_in_date < '\(fechaExpiry)'"
        
        print("vamos a borrar prellenados antiguos")
        
        let resultadoBorrar = db.execute_query(sqlBorrarExpiry)
        
        print(sqlBorrarExpiry)
        print(resultadoBorrar)
        
        self.defaults.set(1, forKey: "sesion")
        
        self.db.close_database(base)
        
        print("tablas llenadas")
        
        hoy = Date()
        
        self.defaults.set(hoy, forKey: "ultimaActualizacion")
        
        print("mi controlador es")
        print(controlador as Any)
        
        
        
        if let aux_controlador = controlador as? LoginController {
            
            print("si entramos al controlador")
            
            switch funcion! {
                
            case "inicio":
                //SwiftSpinner.hide()
                aux_controlador.ir_inicio()
            default:
                break
                
            }
            
            
        }
        
        
        if let aux_controlador = controlador as? InicioController {
            
            //SwiftSpinner.hide()
            
            print("si entramos al controlador Inicio")
            
            switch funcion! {
                
            case "version":
                
                let base = self.defaults.object(forKey: "base") as! String
                
                self.db.open_database(base)
                
                let sqlVersion = "select * from 'ios-app'"
                
                let resultadoVersion = self.db.select_query_columns(sqlVersion)
                
                for renglonVersion in resultadoVersion {
                    
                    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                    
                    let auxVersion = (renglonVersion["version"] as? String)?.replacingOccurrences(of: "ON_TRADE_IOS_", with: "")
                    
                    print("\(String(describing: auxVersion)) y el servidor tiene la version \(String(describing: (renglonVersion["version"] as? String)?.replacingOccurrences(of: "ON_TRADE_IOS_", with: "")))")
                    
                    if version != auxVersion {
                        
                        aux_controlador.performSegue(withIdentifier: "iniciotoactualizarapp", sender: self)
                        
                        
                    }
                    
                }
                
            default:
                break
                
            }
            
            
        }
        
        
        
        //actualizar texto cargador
        
        let controladorActual = UIApplication.topViewController()
        
        DispatchQueue.main.async {
            
            let subvistas = controladorActual?.view!.subviews
            
            for subvista in subvistas! where subvista.tag == 179 {
                
                let subvistasCargador = subvista.subviews
                
                for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                    
                    (subvistaCargador as! UIButton).setTitle("Sincronización Completa. Toque para cerrar", for: .normal)
                    
                }
                
                let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.ocultarCargador(sender:)))
                singleTap.cancelsTouchesInView = false
                singleTap.numberOfTapsRequired = 1
                subvista.addGestureRecognizer(singleTap)
                
            }
            
        }
        
        //fin actualizar texto cargador
        
    }
    
    //fin llenar tablas
    
    
    
    
}

