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
        defaults.set("OnTradeR.sqlite", forKey: "baseR")
        
        
        
        
        
        
        
        let base = defaults.object(forKey: "base") as! String
        
        
        db.open_database(base)
        
        //dominio = "10.0.4.12:8080"  //prueba servicio catalogos
        
        //dominio = "207.58.154.134"
        
        dominio = "ontrade.gshp-apps.com"
        
        protocolo = "http"
        
        //dominio = "gshpdiageoontradeclone.jelastic.servint.net"
        
        defaults.set(dominio, forKey:"dominio")
        defaults.set(protocolo, forKey:"protocolo")
        
        
        var json_servicio = "[{\"servicio\": \"/rest/multireport/catalog/ea_poll\",\"tipo\": \"get\",\"tabla\": \"ea_poll\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/ea_question\",\"tipo\": \"get\",\"tabla\": \"ea_question\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/ea_question_type_cat\",\"tipo\": \"get\",\"tabla\": \"ea_question_type_cat\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/ea_question_option\",\"tipo\": \"get\",\"tabla\": \"ea_question_option\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/ea_section\",\"tipo\": \"get\",\"tabla\": \"ea_section\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/md_item\",\"tipo\": \"get\",\"tabla\": \"md_item\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/md_distribution\",\"tipo\": \"get\",\"tabla\": \"md_distribution\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/mv_manufacturer\",\"tipo\": \"get\",\"tabla\": \"mv_manufacturer\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/mv_category\",\"tipo\": \"get\",\"tabla\": \"mv_category\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/mv_brand\",\"tipo\": \"get\",\"tabla\": \"mv_brand\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/mv_type\",\"tipo\": \"get\",\"tabla\": \"mv_type\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/mv_visibility\",\"tipo\": \"get\",\"tabla\": \"mv_visibility\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/mpr_category\",\"tipo\": \"get\",\"tabla\": \"mpr_category\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/mpr_brand\",\"tipo\": \"get\",\"tabla\": \"mpr_brand\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/mpr_type\",\"tipo\": \"get\",\"tabla\": \"mpr_type\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/mpr_promo\",\"tipo\": \"get\",\"tabla\": \"mpr_promo\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/pdv_pdv\",\"tipo\": \"get\",\"tabla\": \"pdv_pdv\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/c_client\",\"tipo\": \"get\",\"tabla\": \"c_client\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/c_rtm\",\"tipo\": \"get\",\"tabla\": \"c_rtm\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/c_canal\",\"tipo\": \"get\",\"tabla\": \"c_canal\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/c_category\",\"tipo\": \"get\",\"tabla\": \"c_category\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/c_subcategory\",\"tipo\": \"get\",\"tabla\": \"c_subcategory\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/c_type_report\",\"tipo\": \"get\",\"tabla\": \"c_type_report\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/contacts\",\"tipo\": \"get\",\"tabla\": \"contacts\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/pdv_type\",\"tipo\": \"get\",\"tabla\": \"pdv_type\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/pdv_type_module\",\"tipo\": \"get\",\"tabla\": \"pdv_type_module\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/md_expiry_dates\",\"tipo\": \"get\",\"tabla\": \"md_expiry_dates\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/c_brand\",\"tipo\": \"get\",\"tabla\": \"c_brand\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/version/data/ios-app\",\"tipo\": \"otro\",\"tabla\": \"ios-app\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/md_expiry_daterange\",\"tipo\": \"get\",\"tabla\": \"md_expiry_daterange\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/sku_sku\",\"tipo\": \"sync\",\"tabla\": \"sku_sku\",\"query\": \"select min(fecha_sync) as fecha_sync from sku_sku where fecha_sync\",\"columna\": \"fecha_sync\",\"valor_default\": \"0\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/mpr_manufacturer\",\"tipo\": \"get\",\"tabla\": \"mpr_manufacturer\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio\": \"/rest/multireport/catalog/md_registered_images\",\"tipo\": \"post\",\"tabla\": \"md_registered_images\",\"query\": \"select date as milliseconds from report_check order by date asc\",\"columna\": \"milliseconds\",\"valor_default\": \"0\",\"etiqueta\": \"Descargando Catalógo\"}, {\"servicio_get\": \"/rest/multireport/catalog/report_distribution_sync\",\"servicio_post\": \"/rest/multireport/catalog/report_distribution\",\"tipo\": \"multiple\",\"tabla\": \"report_distribution\",\"etiqueta\": \"Descargando Catalógo\"}]"
        
        
        json_servicio = "[{\"id\": \"99\",\"servicio\": \"/rest/psspolicy/status\",\"tipo\": \"policy\",\"tabla\": \"policy\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"1\",\"servicio\": \"/rest/multireport/catalog/ea_poll\",\"tipo\": \"get\",\"tabla\": \"ea_poll\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"2\",\"servicio\": \"/rest/multireport/catalog/ea_question\",\"tipo\": \"get\",\"tabla\": \"ea_question\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"3\",\"servicio\": \"/rest/multireport/catalog/ea_question_type_cat\",\"tipo\": \"get\",\"tabla\": \"ea_question_type_cat\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"4\",\"servicio\": \"/rest/multireport/catalog/ea_question_option\",\"tipo\": \"get\",\"tabla\": \"ea_question_option\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"5\",\"servicio\": \"/rest/multireport/catalog/ea_section\",\"tipo\": \"get\",\"tabla\": \"ea_section\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"6\",\"servicio\": \"/rest/multireport/catalog/md_item\",\"tipo\": \"get\",\"tabla\": \"md_item\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"7\",\"servicio\": \"/rest/multireport/catalog/md_distribution\",\"tipo\": \"get\",\"tabla\": \"md_distribution\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"8\",\"servicio\": \"/rest/multireport/catalog/mv_manufacturer\",\"tipo\": \"get\",\"tabla\": \"mv_manufacturer\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"9\",\"servicio\": \"/rest/multireport/catalog/mv_category\",\"tipo\": \"get\",\"tabla\": \"mv_category\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"10\",\"servicio\": \"/rest/multireport/catalog/mv_brand\",\"tipo\": \"get\",\"tabla\": \"mv_brand\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"11\",\"servicio\": \"/rest/multireport/catalog/mv_type\",\"tipo\": \"get\",\"tabla\": \"mv_type\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"12\",\"servicio\": \"/rest/multireport/catalog/mv_visibility\",\"tipo\": \"get\",\"tabla\": \"mv_visibility\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"13\",\"servicio\": \"/rest/multireport/catalog/mpr_category\",\"tipo\": \"get\",\"tabla\": \"mpr_category\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"14\",\"servicio\": \"/rest/multireport/catalog/mpr_brand\",\"tipo\": \"get\",\"tabla\": \"mpr_brand\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"15\",\"servicio\": \"/rest/multireport/catalog/mpr_type\",\"tipo\": \"get\",\"tabla\": \"mpr_type\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"16\",\"servicio\": \"/rest/multireport/catalog/mpr_promo\",\"tipo\": \"get\",\"tabla\": \"mpr_promo\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"17\",\"servicio\": \"/rest/multireport/catalog/pdv_pdv\",\"tipo\": \"get\",\"tabla\": \"pdv_pdv\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"18\",\"servicio\": \"/rest/multireport/catalog/c_client\",\"tipo\": \"get\",\"tabla\": \"c_client\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"19\",\"servicio\": \"/rest/multireport/catalog/c_rtm\",\"tipo\": \"get\",\"tabla\": \"c_rtm\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"20\",\"servicio\": \"/rest/multireport/catalog/c_canal\",\"tipo\": \"get\",\"tabla\": \"c_canal\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"21\",\"servicio\": \"/rest/multireport/catalog/c_category\",\"tipo\": \"get\",\"tabla\": \"c_category\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"22\",\"servicio\": \"/rest/multireport/catalog/c_subcategory\",\"tipo\": \"get\",\"tabla\": \"c_subcategory\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"23\",\"servicio\": \"/rest/schedule\",\"tipo\": \"get\",\"tabla\": \"schedule\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"24\",\"servicio\": \"/rest/multireport/catalog/c_type_report\",\"tipo\": \"get\",\"tabla\": \"c_type_report\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"25\",\"servicio\": \"/rest/multireport/catalog/contacts\",\"tipo\": \"get\",\"tabla\": \"contacts\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"26\",\"servicio\": \"/rest/multireport/catalog/pdv_type\",\"tipo\": \"get\",\"tabla\": \"pdv_type\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"27\",\"servicio\": \"/rest/multireport/catalog/pdv_type_module\",\"tipo\": \"get\",\"tabla\": \"pdv_type_module\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"28\",\"servicio\": \"/rest/multireport/catalog/md_expiry_dates\",\"tipo\": \"get\",\"tabla\": \"md_expiry_dates\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"29\",\"servicio\": \"/rest/multireport/catalog/c_brand\",\"tipo\": \"get\",\"tabla\": \"c_brand\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"30\",\"servicio\": \"/rest/version/data/ios-app\",\"tipo\": \"get\",\"tabla\": \"ios-app\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"31\",\"servicio\": \"/rest/multireport/catalog/md_expiry_daterange\",\"tipo\": \"get\",\"tabla\": \"md_expiry_daterange\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"32\",\"servicio\": \"/rest/multireport/catalog/prellenado_distribution_ss\",\"tipo\": \"post\",\"parametros\": {\"name\": \"last_update\",\"value\": \"fecha\"},\"tabla\": \"prellenado_distribution_ss\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"33\",\"servicio\": \"/rest/multireport/catalog/sku_sku\",\"tipo\": \"get\",\"tabla\": \"sku_sku\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"34\",\"servicio\": \"/rest/multireport/catalog/mpr_manufacturer\",\"tipo\": \"get\",\"tabla\": \"mpr_manufacturer\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"35\",\"servicio\": \"/rest/multireport/catalog/support_phone\",\"tipo\": \"get\",\"tabla\": \"support_phone\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"36\",\"servicio\": \"/rest/multireport/catalog/app_property\",\"tipo\": \"post\",\"parametros\": {\"name\": \"key\",\"value\": \"email_support\"},\"tabla\": \"app_property\",\"etiqueta\": \"Descargando...\"}]"
        
        
        json_servicio = "[{\"id\": \"99\",\"servicio\": \"/rest/psspolicy/status\",\"tipo\": \"policy\",\"tabla\": \"policy\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"1\",\"servicio\": \"/rest/multireport/catalog/ea_poll\",\"tipo\": \"get\",\"tabla\": \"ea_poll\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"2\",\"servicio\": \"/rest/multireport/catalog/ea_question\",\"tipo\": \"get\",\"tabla\": \"ea_question\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"3\",\"servicio\": \"/rest/multireport/catalog/ea_question_type_cat\",\"tipo\": \"get\",\"tabla\": \"ea_question_type_cat\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"4\",\"servicio\": \"/rest/multireport/catalog/ea_question_option\",\"tipo\": \"get\",\"tabla\": \"ea_question_option\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"5\",\"servicio\": \"/rest/multireport/catalog/ea_section\",\"tipo\": \"get\",\"tabla\": \"ea_section\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"6\",\"servicio\": \"/rest/multireport/catalog/md_item\",\"tipo\": \"get\",\"tabla\": \"md_item\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"7\",\"servicio\": \"/rest/multireport/catalog/md_distribution\",\"tipo\": \"get\",\"tabla\": \"md_distribution\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"8\",\"servicio\": \"/rest/multireport/catalog/mv_manufacturer\",\"tipo\": \"get\",\"tabla\": \"mv_manufacturer\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"9\",\"servicio\": \"/rest/multireport/catalog/mv_category\",\"tipo\": \"get\",\"tabla\": \"mv_category\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"10\",\"servicio\": \"/rest/multireport/catalog/mv_brand\",\"tipo\": \"get\",\"tabla\": \"mv_brand\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"11\",\"servicio\": \"/rest/multireport/catalog/mv_type\",\"tipo\": \"get\",\"tabla\": \"mv_type\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"12\",\"servicio\": \"/rest/multireport/catalog/mv_visibility\",\"tipo\": \"get\",\"tabla\": \"mv_visibility\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"13\",\"servicio\": \"/rest/multireport/catalog/mpr_category\",\"tipo\": \"get\",\"tabla\": \"mpr_category\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"14\",\"servicio\": \"/rest/multireport/catalog/mpr_brand\",\"tipo\": \"get\",\"tabla\": \"mpr_brand\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"15\",\"servicio\": \"/rest/multireport/catalog/mpr_type\",\"tipo\": \"get\",\"tabla\": \"mpr_type\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"16\",\"servicio\": \"/rest/multireport/catalog/mpr_promo\",\"tipo\": \"get\",\"tabla\": \"mpr_promo\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"17\",\"servicio\": \"/rest/multireport/catalog/pdv_pdv\",\"tipo\": \"get\",\"tabla\": \"pdv_pdv\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"18\",\"servicio\": \"/rest/multireport/catalog/c_client\",\"tipo\": \"get\",\"tabla\": \"c_client\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"19\",\"servicio\": \"/rest/multireport/catalog/c_rtm\",\"tipo\": \"get\",\"tabla\": \"c_rtm\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"20\",\"servicio\": \"/rest/multireport/catalog/c_canal\",\"tipo\": \"get\",\"tabla\": \"c_canal\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"21\",\"servicio\": \"/rest/multireport/catalog/c_category\",\"tipo\": \"get\",\"tabla\": \"c_category\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"22\",\"servicio\": \"/rest/multireport/catalog/c_subcategory\",\"tipo\": \"get\",\"tabla\": \"c_subcategory\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"23\",\"servicio\": \"/rest/schedule\",\"tipo\": \"get\",\"tabla\": \"schedule\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"24\",\"servicio\": \"/rest/multireport/catalog/c_type_report\",\"tipo\": \"get\",\"tabla\": \"c_type_report\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"25\",\"servicio\": \"/rest/multireport/catalog/contacts\",\"tipo\": \"get\",\"tabla\": \"contacts\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"26\",\"servicio\": \"/rest/multireport/catalog/pdv_type\",\"tipo\": \"get\",\"tabla\": \"pdv_type\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"27\",\"servicio\": \"/rest/multireport/catalog/pdv_type_module\",\"tipo\": \"get\",\"tabla\": \"pdv_type_module\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"28\",\"servicio\": \"/rest/multireport/catalog/md_expiry_dates\",\"tipo\": \"get\",\"tabla\": \"md_expiry_dates\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"29\",\"servicio\": \"/rest/multireport/catalog/c_brand\",\"tipo\": \"get\",\"tabla\": \"c_brand\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"30\",\"servicio\": \"/rest/version/data/ios-app\",\"tipo\": \"get\",\"tabla\": \"ios-app\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"31\",\"servicio\": \"/rest/multireport/catalog/md_expiry_daterange\",\"tipo\": \"get\",\"tabla\": \"md_expiry_daterange\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"32\",\"servicio\": \"/rest/multireport/catalog/prellenado_distribution_ss\",\"tipo\": \"post\",\"parametros\": {\"name\": \"last_update\",\"value\": \"fecha\"},\"tabla\": \"prellenado_distribution_ss\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"34\",\"servicio\": \"/rest/multireport/catalog/mpr_manufacturer\",\"tipo\": \"get\",\"tabla\": \"mpr_manufacturer\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"35\",\"servicio\": \"/rest/multireport/catalog/support_phone\",\"tipo\": \"get\",\"tabla\": \"support_phone\",\"etiqueta\": \"Descargando...\"}, {\"id\": \"36\",\"servicio\": \"/rest/multireport/catalog/app_property\",\"tipo\": \"post\",\"parametros\": {\"name\": \"key\",\"value\": \"email_support\"},\"tabla\": \"app_property\",\"etiqueta\": \"Descargando...\"}]"
        
        
        let json_servicio_enviar = "[{\"id\": \"1\",\"servicio\": \"/rest/report\",\"tipo\": \"post\",\"tabla\": \"report\",\"etiqueta\": \"Faltanporenviar\"}, {\"id\": \"2\",\"servicio\": \"/rest/multireport/insertnt/rdistribution/1\",\"tipo\": \"post\",\"tabla\": \"report_distribution\",\"etiqueta\": \"Faltanporenviar\"}, {\"id\": \"3\",\"servicio\": \"/rest/multireport/insertnt/rpromo/2\",\"tipo\": \"post\",\"tabla\": \"report_promotions\",\"etiqueta\": \"Faltanporenviar\"}, {\"id\": \"4\",\"servicio\": \"/rest/multireport/insertnt/rpromobrand/1\",\"tipo\": \"post\",\"tabla\": \"report_promtions_brands\",\"etiqueta\": \"Faltanporenviar\"}, {\"id\": \"5\",\"servicio\": \"/rest/multireport/insertnt/rvisibility/2\",\"tipo\": \"post\",\"tabla\": \"report_visibility\",\"etiqueta\": \"Faltanporenviar\"}, {\"id\": \"6\",\"servicio\": \"/rest/multireport/insertnt/rvisibilitybrand/1\",\"tipo\": \"post\",\"tabla\": \"report_visibility_brands\",\"etiqueta\": \"Faltanporenviar\"}, {\"id\": \"7\",\"servicio\": \"/rest/multireport/insertnt/poll/1\",\"tipo\": \"post\",\"tabla\": \"EARespuesta\",\"etiqueta\": \"Faltanporenviar\"}, {\"id\": \"8\",\"servicio\": \"/rest/multireport/insertnt/poll/1\",\"tipo\": \"post\",\"tabla\": \"EARespuesta\",\"etiqueta\": \"Faltanporenviar\"}, {\"id\": \"9\",\"servicio\": \"/rest/multireport/insertnt/rskarep/1\",\"tipo\": \"post\",\"tabla\": \"rskarep\",\"etiqueta\": \"Faltanporenviar\"}, {\"id\": \"11\",\"servicio\": \"/rest/multireport/insertnt/poll/1\",\"tipo\": \"foto\",\"tablas\": [{\"id\": \"id\",\"tabla\": \"report_photo_distribution\",\"ruta\": \"path\",\"query\": \"select t1.*,t2.hash as hash_report from report_photo_distribution t1,report_distribution t2 where t1.idReporteLocal='@idReporteLocal' and t1.id_report_distribution=t2.id\",\"servicio\": \"/rest/multireport/image/rdistribution/1\"}, {\"id\": \"id\",\"tabla\": \"report_photo_promotions\",\"ruta\": \"path\",\"query\": \"select t1.*,t2.hash as hash_report from report_photo_promotions t1,report_promotions t2 where t1.id_report_local='@idReporteLocal' and t1.id_report_promotion=t2.id\",\"servicio\": \"/rest/multireport/image/rpromo/2\"}, {\"id\": \"id\",\"tabla\": \"report_photo_visibility\",\"ruta\": \"path\",\"query\": \"select t1.*,t2.hash as hash_report from report_photo_visibility t1,report_visibility t2 where t1.id_report_local='@idReporteLocal' and t1.id_report_visibility=t2.id\",\"servicio\": \"/rest/multireport/image/rvisibility/2\"}, {\"id\": \"id\",\"tabla\": \"EARespuesta\",\"ruta\": \"respuesta\",\"query\": \"select t1.*,t1.hash as hash_report from EARespuesta t1,ea_question t2 where t1.idReporteLocal='@idReporteLocal' and t1.idPregunta=t2.id and t2.type_question=15\",\"servicio\": \"/rest/multireport/image/poll/1\"}],\"etiqueta\": \"SubiendoFotos\"}, {\"id\": \"3\",\"servicio\": \"/diageo-capabilities-rest/rest/report/update/@idReportServer\",\"tipo\": \"update\",\"tabla\": \"report\",\"columna\": \"idReportServer\",\"variable\": \"idReportServer\",\"etiqueta\": \"Actualizando...\"}]"
        
        //let dataFromString = json_servicio.data(using: String.Encoding.utf8, allowLossyConversion: false)
        servicios_json = JSON(cadena: json_servicio)
        
        servicios_json_enviar = JSON(cadena: json_servicio_enviar)
        
        /*
         for k in 0 ..< servicios_json.count {
         
         
         
         
         switch servicios_json[k]["tipo"]{
         
         case "get":
         
         servicios.append("http://\(dominio)\(servicios_json[k]["servicio"])")
         tablas.append("\(servicios_json[k]["tabla"])")
         etiquetas.append("Descargando Catalogos")
         
         default:
         print("tipo no manejado \(servicios_json[k]["tipo"])")
         
         
         }
         
         }
         */
        
        
        
        super.init()
        
    }
    
    //fin inicializacion
    
    
    
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
        
        
        
        
        /*var auxPort = 80
         
         
         
         if url.port !=  nil {
         
         auxPort = url.port!
         
         }
         
         
         let protectionSpace: URLProtectionSpace = URLProtectionSpace(host: url.host!,port: auxPort,protocol: url.scheme,realm: nil,authenticationMethod: NSURLAuthenticationMethodHTTPBasic);
         
         let credentialStorage: URLCredentialStorage = URLCredentialStorage.shared;
         */
        
        let configuracion:URLSessionConfiguration = URLSessionConfiguration.ephemeral
        
        
        
        let sesion = URLSession(configuration: configuracion, delegate: self, delegateQueue: nil)
        
        
        
        
        switch metodo {
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
                    
                    DispatchQueue.main.async {
                        
                        //_ =  SwiftSpinner.show(self.servicios_json.arreglo[indice!]["etiqueta"] as! String).addTapHandler({
                            
                            //SwiftSpinner.hide()
                            
                        //})
                        
                    }
                    
                    do {
                        
                        
                        
                        
                        guard let datos = try JSONSerialization.jsonObject(with: responseData, options: [])
                            as? [String: Any] else {
                                print("No es diccionario policy")
                                return
                        }
                        
                        //print(datos.description)
                        
                        
                        print("el estatus es (👾) ")
                        
                        //print(datos["status"] as Any)
                        
                        
                        if datos["status"] as! NSNumber == 2 {
                            
                            
                            if let aux_controlador = controlador as? LoginController {
                                
                                print("si entramos al controlador login")
                                
                                
                                
                                DispatchQueue.main.async {
                                    
                                    //SwiftSpinner.hide()
                                    
                                    let alertController = UIAlertController(title: "¡Atención!", message: "Su contraseña esta caduca es necesario actualizarla", preferredStyle: .alert)
                                    
                                    
                                    let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                                        UIAlertAction in
                                        
                                        print("se presiono Aceptar")
                                        
                                        aux_controlador.performSegue(withIdentifier: "logintocambiocontrasena", sender: aux_controlador)
                                        
                                    }
                                    
                                    
                                    alertController.addAction(okAction)
                                    
                                    aux_controlador.present(alertController, animated: true, completion: nil)
                                    
                                }
                                
                            }
                            
                            
                            
                            
                        }
                        
                        if datos["status"] as! NSNumber == 1 {
                            
                            print("todo bien con las credenciales")
                            
                            let aux = indice! + 1
                            
                            guard aux < self.servicios_json.arreglo.count else {
                                let hoy = Date()
                                
                                self.defaults.set(hoy, forKey: "ultimaActualizacion")
                                
                                
                                //SwiftSpinner.hide()
                                
                                /*
                                _ = SwiftSpinner.show("Actualizando Base de Datos").addTapHandler({
                                    
                                    //SwiftSpinner.hide()
                                    
                                })
                                */
                                
                                self.llenar_tablas(ids: servicios_indices,controlador: controlador,funcion: "inicio")
                                
                                return
                            }
                            
                            
                            
                            
                            let 🤖 = "\(self.protocolo)://\(self.dominio)\(self.servicios_json.arreglo[aux]["servicio"] as! String)"
                            
                            let tipo = self.servicios_json.arreglo[aux]["tipo"] as! String
                            
                            self.peticion(👾: 🤖, metodo: tipo, controlador: controlador, indice: aux)
                            
                            
                        }
                        
                        
                        
                        
                        
                        //fin checar si es diccionario o arreglo
                        
                        
                        
                    } catch  {
                        print("error al parsear el json")
                        return
                    }
                    
                case 401:
                    
                    print("Credenciales incorrectas")
                    
                default:
                    print("Estatus http no manejado \(realResponse.statusCode)")
                    
                    
                    let aux = indice! + 1
                    
                    guard aux < self.servicios_json.arreglo.count else {
                        let hoy = Date()
                        
                        self.defaults.set(hoy, forKey: "ultimaActualizacion")
                        
                        
                        //SwiftSpinner.hide()
                        
                       /* _ = SwiftSpinner.show("Actualizando Base de Datos").addTapHandler({
                            
                            //SwiftSpinner.hide()
                            
                        })
                         */
                        
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
                    
                    
                    DispatchQueue.main.async {
                        
                        /*
                        _ = SwiftSpinner.show("Hubo un error al sincronizar intentelo nuevamente. Toque para cerrar").addTapHandler({
                            
                            SwiftSpinner.hide()
                            
                            self.sincronizar(controlador:controlador!)
                            
                        })
                        */
                        
                    }
                    
                    
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
                    
                    /*
                    _ =  SwiftSpinner.show(self.servicios_json.arreglo[indice!]["etiqueta"] as! String).addTapHandler({
                        
                        //SwiftSpinner.hide()
                        
                    })
                    */
                    
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
                                    
                                    
                                    //SwiftSpinner.hide()
                                    
                                    /*
                                    _ = SwiftSpinner.show("Actualizando Base de Datos").addTapHandler({
                                        
                                        //SwiftSpinner.hide()
                                        
                                        
                                    })
                                    */
                                    
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
                            
                            
                            //SwiftSpinner.hide()
                            
                            /*
                            _ = SwiftSpinner.show("Actualizando Base de Datos").addTapHandler({
                                
                                //SwiftSpinner.hide()
                                
                            })
                            */
                            
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
                    
                default:
                    print("Estatus http no manejado \(realResponse.statusCode)")
                    
                    let aux = indice! + 1
                    
                    guard aux < self.servicios_json.arreglo.count else {
                        let hoy = Date()
                        
                        self.defaults.set(hoy, forKey: "ultimaActualizacion")
                        
                        
                        //SwiftSpinner.hide()
                        
                        /*
                        _ = SwiftSpinner.show("Actualizando Base de Datos").addTapHandler({
                            
                            //SwiftSpinner.hide()
                        
                        })
                        */
                        
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
                             
                             
                             //SwiftSpinner.hide()
                             
                                /*
                             _ = SwiftSpinner.show("Actualizando Base de Datos").addTapHandler({
                                
                                //SwiftSpinner.hide()
                             
                             
                             })
                             */
                                
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
                        
                        
                        //SwiftSpinner.hide()
                        
                        /*
                        _ = SwiftSpinner.show("Actualizando Base de Datos").addTapHandler({
                            
                            //SwiftSpinner.hide()
                        
                        })
                        */
                        
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
                
                
                //SwiftSpinner.hide()
                
                /*
                _ = SwiftSpinner.show("Actualizando Base de Datos").addTapHandler({
                    
                    
                    //SwiftSpinner.hide()
                
                
                })
                */
                
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
            
            DispatchQueue.main.async {
                
                //_ = SwiftSpinner.show("Credenciales incorrectas").addTapHandler({SwiftSpinner.hide()})
                
            }
            
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
    
    //acomodar base
    
    func acomodar_base(){
        
        print("Acomodando base.....")
        
        let base = defaults.object(forKey: "base") as! String
        
        self.db.open_database(base)
        
        var sql = ""
        
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
        
        
        let baseR = defaults.object(forKey: "baseR") as! String
        
        self.db.open_database(baseR)
        
        
        sql = "CREATE TABLE IF NOT EXISTS 'imagenesReenviar' ('imagen' TEXT)"
        
        _ = self.db.execute_query(sql)
        
        self.db.open_database(base)
        
        
        if defaults.object(forKey: "imagenesPorEnviar") == nil {
        
        
        sql = "select * from report where checkIn < 1499385600000 and checkIn > 1497052800000"
        
        let resultados_reportesImagenesFallidas = self.db.select_query_columns(sql)
        
        for renglon in resultados_reportesImagenesFallidas {
        
            var sqlImagen = "update report set enviado = 0 where id = \(renglon["id"] as! Int)"
            
            _ = self.db.execute_query(sqlImagen)
            
            
            sqlImagen = "update report_distribution set idReportServer = '',is_send = 0 where idReporteLocal = \(renglon["id"] as! Int)"
            
            _ =  self.db.execute_query(sqlImagen)
            
            
            sqlImagen = "update report_promotions set idReportServer = '',is_send = 0 where idReporteLocal = \(renglon["id"] as! Int)"
            
            
            
            _ =  self.db.execute_query(sqlImagen)
            
            sqlImagen = "update report_promotions_brands set idReportServer = '',is_send = 0 where idReporteLocal = \(renglon["id"] as! Int)"
            
            
            
            _ =  self.db.execute_query(sqlImagen)
            
            sqlImagen = "update report_visibility set idReportServer = '',is_send = 0 where idReporteLocal = \(renglon["id"] as! Int)"
            
            
            
            _ =  self.db.execute_query(sqlImagen)
            
            sqlImagen = "update report_visibility_brands set idReportServer = '',is_send = 0 where idReporteLocal = \(renglon["id"] as! Int)"
            
            _ =  self.db.execute_query(sqlImagen)
            
            
            sqlImagen = "update report_photo_distribution set is_send = 0 where idReporteLocal = '\(renglon["id"] as! Int)'"
            
            _ = self.db.execute_query(sqlImagen)
            
            sqlImagen = "update report_photo_promotions set is_send = 0 where id_report_local = '\(renglon["id"] as! Int)'"
            
            _ = self.db.execute_query(sqlImagen)
            
            sqlImagen = "update report_photo_visibility set is_send = 0 where id_report_local = '\(renglon["id"] as! Int)'"
            
            _ = self.db.execute_query(sqlImagen)
            
            
        }
         
            defaults.set(1, forKey: "imagenesPorEnviar")
            
        }
        
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
 
 
      /*
        sql = "update report set idReportServer = '',enviado = 0 where id = 30"
        
        _ = self.db.execute_query(sql)
        
        sql = "update report set idReportServer = '',enviado = 0 where id = 31"
        
        _ = self.db.execute_query(sql)
        
        sql = "update report set idReportServer = '',enviado = 0 where id = 32"
        
        _ = self.db.execute_query(sql)
        
        sql = "update report set idReportServer = '',enviado = 0 where id = 33"
        
        _ = self.db.execute_query(sql)
        
        sql = "update report_distribution set idReportServer = '',is_send = 0 where idReporteLocal = 30"
        
        _ =  self.db.execute_query(sql)
        
        sql = "update report_distribution set idReportServer = '',is_send = 0 where idReporteLocal = 31"
        
        _ =  self.db.execute_query(sql)
        
        sql = "update report_distribution set idReportServer = '',is_send = 0 where idReporteLocal = 32"
        
        _ =  self.db.execute_query(sql)
        
        sql = "update report_distribution set idReportServer = '',is_send = 0 where idReporteLocal = 33"
        
        _ =  self.db.execute_query(sql)
        
        sql = "update report_promotions set idReportServer = '',is_send = 0 where idReporteLocal = 30"
        
        _ =  self.db.execute_query(sql)
        
        sql = "update report_promotions set idReportServer = '',is_send = 0 where idReporteLocal = 31"
        
        _ =  self.db.execute_query(sql)
        
        sql = "update report_promotions set idReportServer = '',is_send = 0 where idReporteLocal = 32"
        
        _ =  self.db.execute_query(sql)
        
        sql = "update report_promotions set idReportServer = '',is_send = 0 where idReporteLocal = 33"
        
        _ =  self.db.execute_query(sql)
        
        sql = "update report_promotions_brands set idReportServer = '',is_send = 0 where idReporteLocal = 30"
        
        _ =  self.db.execute_query(sql)
        
        sql = "update report_promotions_brands set idReportServer = '',is_send = 0 where idReporteLocal = 31"
        
        _ =  self.db.execute_query(sql)
        
        sql = "update report_promotions_brands set idReportServer = '',is_send = 0 where idReporteLocal = 32"
        
        _ =  self.db.execute_query(sql)
        
        sql = "update report_promotions_brands set idReportServer = '',is_send = 0 where idReporteLocal = 33"
        
        _ =  self.db.execute_query(sql)
        
        sql = "update report_visibility set idReportServer = '',is_send = 0 where idReporteLocal = 30"
        
        _ =  self.db.execute_query(sql)
        
        sql = "update report_visibility set idReportServer = '',is_send = 0 where idReporteLocal = 31"
        
        _ =  self.db.execute_query(sql)
        
        sql = "update report_visibility set idReportServer = '',is_send = 0 where idReporteLocal = 32"
        
        _ =  self.db.execute_query(sql)
        
        sql = "update report_visibility set idReportServer = '',is_send = 0 where idReporteLocal = 33"
        
        _ =  self.db.execute_query(sql)
        
        sql = "update report_visibility_brands set idReportServer = '',is_send = 0 where idReporteLocal = 30"
        
        _ =  self.db.execute_query(sql)
        
        sql = "update report_visibility_brands set idReportServer = '',is_send = 0 where idReporteLocal = 31"
        
        _ =  self.db.execute_query(sql)
        
        sql = "update report_visibility_brands set idReportServer = '',is_send = 0 where idReporteLocal = 32"
        
        _ =  self.db.execute_query(sql)
        
        sql = "update report_visibility_brands set idReportServer = '',is_send = 0 where idReporteLocal = 33"
        
        _ =  self.db.execute_query(sql)
        
      
        */
        
        
    }
    
    //fin acomodar base
    
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
                    
                    limpiar_base()
                    
                    defaults.removeObject(forKey: "fechaSincronizacion")
                    
                }
                
            }
            else{
                defaults.removeObject(forKey: "fechaSincronizacion")
                limpiar_base()
                
            }
            
            acomodar_base()
            
            //servicio_seriado(usuario: usuario, contrasena: contrasena, indice: 0,controlador:controlador,funcion:"inicio")
            
            let 🤖 = "\(self.protocolo)://\(self.dominio)\(self.servicios_json.arreglo[0]["servicio"] as! String)"
            
            let tipo = self.servicios_json.arreglo[0]["tipo"] as! String
            
            self.peticion(👾: 🤖, metodo: tipo, controlador: controlador, indice: 0)
            
            
        }
        else{
            
            //SwiftSpinner.show("Necesitas tener una conexión a internet").addTapHandler({SwiftSpinner.hide()})
            
        }
        
    }
    
    func sincronizar(controlador:AnyObject){
        
        acomodar_base()
        
        let 🤖 = "\(self.protocolo)://\(self.dominio)\(self.servicios_json.arreglo[0]["servicio"] as! String)"
        
        let tipo = self.servicios_json.arreglo[0]["tipo"] as! String
        
        self.peticion(👾: 🤖, metodo: tipo, controlador: controlador, indice: 0)
        
    }
    
    //fin iniciar_sesion
    
    
    //servicio evaluacion
    
    func checar_evaluacion(usuario:String,contrasena:String,indice:Int,controlador:AnyObject?=nil,funcion:String?=nil) {
        print("checar si tengo evaluacion")
    }
    
    
    //fin servicio evaluacion
    
    
    
    
    //servicio seriados enviar
    
    func servicio_seriado_enviar (usuario:String,contrasena:String,indice:Int,ids:[NSNumber]?=nil,controlador:AnyObject?=nil,funcion:String?=nil){
        
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
                                self.completar_envio(idReportServer: idReportServerEnviando)
                                
                                
                                
                                
                            default:
                                print("no se que hacer con esta tabla")
                                
                            }
                            
                            let aux = indice + 1
                            
                            self.servicio_seriado_enviar(usuario: usuario,contrasena: contrasena,indice: aux,ids: servicios_indices_enviar,controlador: controlador,funcion: funcion)
                            
                            
                            
                        case 201:
                            
                            
                            
                            if self.servicios_json_enviar.arreglo[indice]["tabla"] as! String == "report" {
                                
                                
                                
                                self.defaults.set(responseData.stringValue, forKey: "idReportServerEnviando")
                            }
                            
                            
                            
                            let aux = indice + 1
                            
                            self.servicio_seriado_enviar(usuario: usuario,contrasena: contrasena,indice: aux,ids: servicios_indices_enviar,controlador: controlador,funcion: funcion)
                            
                            
                        case 401:
                            
                            print("Credenciales incorrectas")
                            
                        default:
                            print("Estatus http no manejado \(realResponse.statusCode)")
                        }
                        
                        
                    }
                    tarea.resume()
                    
                    
                    
                    
                /*
                    
                let parameters: Parameters = ["json": auxJsonstring]
                
                print(parameters)
                    
                    
                let credenciales = URLCredential(user: usuario, password: contrasena, persistence: .none)
                //let protectionSpace:URLProtectionSpace = URLProtectionSpace()
                
                
                Alamofire.request(aux_url, method: .post, parameters: parameters)
                    //Alamofire.request(.GET, "\(protocolo)://\(dominio)\(servicios_json.arreglo[indice]["servicio"])",headers:headers)
                    //.session.configuration.urlCredentialStorage!.remove(credenciales, for: protectionSpace)
                    .authenticate(usingCredential: credenciales)
                    .responseString { response in
                        print(response.request  as Any)  // original URL request
                        print(response.response as Any) // URL response
                        //print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        
                        
                        if response.result.isFailure {
                            
                            print(response.request as Any)
                            SwiftSpinner.show("Error al contactar el servidor intentalo nuevamente").addTapHandler({SwiftSpinner.hide()})
                            
                            
                            
                        }
                        else{
                        
                        /*if let JSON = response.result.value {
                         print("JSON: \(JSON)")
                         }*/
                        
                        //print(response.result.value)
                        
                        if self.servicios_json_enviar.arreglo[indice]["tabla"] as! String == "report" {
                        self.defaults.set(response.result.value!, forKey: "idReportServerEnviando")
                        }
                        
                        if self.servicios_json_enviar.arreglo[indice]["tabla"] as! String == "ea_answers" {
                            
                            let idReportServerEnviando = self.defaults.object(forKey: "idReportServerEnviando") as! String
                            self.completar_envio(idReportServer: idReportServerEnviando)
                        }
                        
                        let aux = indice + 1
                        
                        self.servicio_seriado_enviar(usuario: usuario,contrasena: contrasena,indice: aux,ids: servicios_indices_enviar,controlador: controlador,funcion: funcion)
                        
                        }
                }
                    
            */
                
            }
            else{
                print("todo enviado")
                    
                     DispatchQueue.main.async {
                    //_ = SwiftSpinner.show("Todo enviado. Toque para cerrar").addTapHandler({SwiftSpinner.hide()})
                    }
                
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
        else {
            
            //SwiftSpinner.hide()
            
            
            
            /*
            _ = SwiftSpinner.show("Actualizando Base de Datos").addTapHandler({
                
                
                
                
                //self.defaults.set(1, forKey: "sesion")
                
                SwiftSpinner.hide()
                
            })
            */
            //llenar_tablas(ids: servicios_indices,controlador: controlador,funcion: funcion)
            
        }
        
        
        
        
    }
    
    
    //fin servicio seriado enviar
    
    
    
    func completar_envio(idReportServer:String){
    
        
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
            
            
            DispatchQueue.main.async {
                
                //_ =  SwiftSpinner.show("Mandando Fotos \(indice + 1) de \(fotos.count)")
            }
            
            
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
                            
                            /* DispatchQueue.main.async {
                             
                             _ = SwiftSpinner.show("Base enviada. Toque para cerrar").addTapHandler({SwiftSpinner.hide()})
                             
                             }
                             */
                        }
                        upload.responseJSON { response in
                            
                            //Spinner.hide()
                            
                            print("Response Foto \(fotos[indice]["tabla"] as! String)")
                            debugPrint(response)
                            
                            
                            
                            let sql = "update \(fotos[indice]["tabla"] as! String) set is_send=1 where id='\(fotos[indice]["id"] as! String)'"
                            
                            
                            
                            let resultado_update = self.db.execute_query(sql)
                            
                            
                            /*
                            let baseR = self.defaults.object(forKey: "baseR") as! String
                            
                            self.db.open_database(baseR)
                            
                            let sqlImagenReenviar = "insert into imagenesReenviar (imagen) values ('\(fotos[indice]["imagen"] as! String)')"
                            
                            print(sqlImagenReenviar)
                            
                            let resultadoImagenReenviar = self.db.execute_query(sqlImagenReenviar)
                            
                            print(resultadoImagenReenviar)
                            
                            
                            print(sql)
                            print("puso el uno es \(resultado_update)")
                            
                            if (fotos[indice]["tabla"] as! String) == "recuperada" {
                            
                                let sql = "insert into imagenesReenviar (imagen) values ('\(fotos[indice]["imagen"] as! String)')"
                                
                                _ = self.db.execute_query(sql)
                                
                            }
 
 */
                            
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
    
    
    
    
    //mandar imagenes reenviar
    
    func mandarFotosrReenviar(indice:Int,fotos:[[String:AnyObject]]){
        
        
        if indice >= fotos.count {
            
            print("fotos reenviandas completo")
            
            DispatchQueue.main.async {
                //_ = SwiftSpinner.show("Fotos Recuperadas. Toque para cerrar").addTapHandler({SwiftSpinner.hide()})
            }
            
            
        }
        else{
            
            
            DispatchQueue.main.async {
                
               // _ =  SwiftSpinner.show("Mandando Fotos Recuperadas \(indice + 1) de \(fotos.count)")
            }
            
            
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
                            
                            /* DispatchQueue.main.async {
                             
                             _ = SwiftSpinner.show("Base enviada. Toque para cerrar").addTapHandler({SwiftSpinner.hide()})
                             
                             }
                             */
                        }
                        upload.responseJSON { response in
                            
                            //Spinner.hide()
                            
                            print("Response Foto \(fotos[indice]["tabla"] as! String)")
                            debugPrint(response)
                            
                            
                            
                            let sql = "update \(fotos[indice]["tabla"] as! String) set is_send=1 where id='\(fotos[indice]["id"] as! String)'"
                            
                            let resultado_update = self.db.execute_query(sql)
                            
                            let baseR = self.defaults.object(forKey: "baseR") as! String
                            
                            self.db.open_database(baseR)
                            
                            
                            let sqlImagenReenviar = "insert into imagenesReenviar (imagen) values ('\(fotos[indice]["imagen"] as! String)')"
                            
                            _ = self.db.execute_query(sqlImagenReenviar)
                            
                            
                            
                            
                            
                            
                            print(sql)
                            print("puso el uno es \(resultado_update)")
                            
                            if (fotos[indice]["tabla"] as! String) == "recuperada" {
                                
                                let sql = "insert into imagenesReenviar (imagen) values ('\(fotos[indice]["imagen"] as! String)')"
                                
                                _ = self.db.execute_query(sql)
                                
                            }
                            
                            let base = self.defaults.object(forKey: "base") as! String
                            
                            self.db.open_database(base)
                            
                            let indiceNuevo = indice + 1
                            
                            self.mandarFotosrReenviar(indice: indiceNuevo, fotos: fotos)
                            
                            
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                    }
            }
            )
            
            
            
            
            
            
        }
        
    }
    
    
    //fin mandar imagenes reenviar
    
    
    
    
    //ciclo para mandar imagenes
    
    
    func ciclo_fotos(idReporteLocal:String,usuario:String,contrasena:String, indice:Int,total:Int){
        
        var indice = indice
        print("enviando foto \(indice) de \(total)")
        
        let aux = indice + 1
        
        //_ = SwiftSpinner.show("Enviando foto \(aux) de \(total)")
        
        if indice >= total {
            
            //self.checar_enviado(idReporteLocal,usuario: usuario,contrasena: contrasena)
            
            //self.anterior = Int(idReporteLocal)!
            
            //self.ciclo_sincronizar(usuario, contrasena: contrasena)
            
            //Spinner.hide()
            
            self.indiceReporte += 1
            
            //self.reporte_unoauno(usuario, contrasena: contrasena, idReporteLocal: idReporteLocal, indice: self.indiceReporte, total: self.totalReporte)
            
        }
        else{
            
            
            
            //mandar fotos visibilidad
            
            let tipo = arregloFotosMandar[indice][1] as! String
            
            var sql = ""
            
            
            if tipo == "visibilidad" {
                
                
                sql = "select t1.hash,t2.hash,t3.place,t1.path,t1.id_report_visibility from report_photo_visibility t1,report_visibility t2, report t3   where t1.id_report_visibility = t2.id and t2.id_report_local = '\(idReporteLocal)' and t2.id_report_local=t3.id and t1.is_send = 0 and t1.id = '\(arregloFotosMandar[indice][0])'"
                
            }
            
            
            if tipo == "promocion" {
                
                
                sql = "select t1.hash,t2.hash,t3.place,t1.path from report_photo_promotions t1,report_promotions t2, report t3   where t1.id_report_promotion = t2.id and t2.id_report_local = '\(idReporteLocal)' and t2.id_report_local=t3.id and t1.is_send = 0 and t1.id = '\(arregloFotosMandar[indice][0])'"
                
            }
            
            
            if tipo == "distribucion" {
                
                
                sql = "select t1.hash,t2.hash,t3.place,t1.path from report_photo_distribution t1,report_distribution t2, report t3   where t1.id_report_distribution = t2.id and t2.id_report_local = '\(idReporteLocal)' and t2.id_report_local=t3.id and t1.mandar = 0 and t1.is_send = 0 and t1.id = '\(arregloFotosMandar[indice][0])'"
                
                
            }
            
            
            if tipo == "encuesta" {
                
                sql = "select t1.hash,t1.hash,t3.place,t1.path from EncuestaFotos t1, report t3   where t1.idReporteLocal = '\(idReporteLocal)' and t1.idReporteLocal=t3.id and t1.is_send = 0 and t1.id = '\(arregloFotosMandar[indice][0])'"
                
                
            }
            
            
            
            
            
            //sql = "select t1.hash,t2.hash,t1.path from report_photo_promotions t1,report_promotions t2 where t1.id_report_promotion = t2.id and t2.id_report_local = '\(idReporteLocal)' order by t1.id desc"
            
            // sql = "select * from report_promotions where id_report_local = '\(idReporteLocal)'"
            
            print(sql)
            
            //var respuestas_aux:[[String:AnyObject]] = []
            
            let respuestasReporte = self.db.select_query(sql)
            //print(respuestasReporte)
            
            if respuestasReporte.count < 1 {
                
                indice += 1
                
                self.ciclo_fotos(idReporteLocal: idReporteLocal, usuario: usuario, contrasena: contrasena, indice: indice, total: total)
                
            }
            
            for renglon in respuestasReporte {
                
                //print("respuestas fotos promocion")
                //print(renglon)
                
                
                //var aux_renglon:[String:AnyObject]
                
                var description = ""
                
                
                if tipo == "visibilidad" {
                    
                    
                    //let sql_descripcion = "select * from report_visibility"
                    
                    description = "Visibilidad "
                    
                }
                
                
                if tipo == "promocion" {
                    
                    
                    //let sql_descripcion = "select * from report_visibility"
                    
                    description = "Promocion "
                    
                }
                
                
                if tipo == "distribucion" {
                    
                    
                    //let sql_descripcion = "select * from report_visibility"
                    
                    description = "Distribucion "
                    
                }
                
                if tipo == "encuesta" {
                    
                    
                    //let sql_descripcion = "select * from report_visibility"
                    
                    description = "Encuesta "
                    
                }
                
                print(renglon)
                
                
                let url_foto = renglon[3] as! String
                
                //print("la url de la foto es \(url_foto)")
                
                //let aux_nombre_imagen = url_foto.componentsSeparatedByString("/")
                
                let aux_nombre_imagen = url_foto.components(separatedBy: "/")
                
                let imagen_ruta = fileInDocumentsDirectory(filename: aux_nombre_imagen[aux_nombre_imagen.count - 1])
                
                //self.getImageFromPath(url_foto)
                
                
                //let image = self.loadImageFromPath(imagen_ruta)
                
                //print("la imagen se nula? \(image)")
                
                /*
                 
                 let base64String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
                 
                 */
                
                
                /*
                 
                 
                 
                 respuestas_aux.append(aux_renglon)
                 */
                //let urlRequest = self.urlRequestWithComponents("http://ontrade.gshp-apps.com/rest/multireport/image/rpromo/1", parameters: aux_renglon, imageData: imageData!)
              /*
                if let _ = NSData(contentsOfFile: imagen_ruta) {
                    
                    if tipo == "visibilidad" {
                        
                        sql = "update report_photo_visibility set is_send=1 where id='\(self.arregloFotosMandar[indice][0])'"
                        
                    }
                    
                    
                    if tipo == "promocion" {
                        
                        sql = "update report_photo_promotions set is_send=1 where id='\(self.arregloFotosMandar[indice][0])'"
                        
                    }
                    
                    
                    if tipo == "distribucion" {
                        
                        sql = "update report_photo_distribution set is_send=1 where id='\(self.arregloFotosMandar[indice][0])'"
                        
                    }
                    
                    
                    if tipo == "encuesta" {
                        
                        sql = "update EncuestaFotos set is_send=1 where id='\(self.arregloFotosMandar[indice][0])'"
                        
                    }
                    
                    
                    let resultado_update = self.db.execute_query(sql)
                    
                    
                    print(sql)
                    print("puso el uno es \(resultado_update)")
                    
                    indice += 1
                    
                    self.ciclo_fotos(idReporteLocal: idReporteLocal, usuario: usuario, contrasena: contrasena, indice: indice, total: total)
                    
                    
                }
                */
                
                if let _ = NSData(contentsOfFile: imagen_ruta) {
                    
                    print("vamos a mandar")
                    
                    //let aux_url = NSURL(fileURLWithPath: imagen_ruta)
                    
                    
                    //let location = (url_foto as NSString).stringByExpandingTildeInPath
                    //let data = NSData(contentsOfURL: NSURL(fileURLWithPath: url_foto))
                    let data2 = NSData(contentsOfFile: imagen_ruta)!
                    
                    let datos = Data(referencing: data2)
                    
                    /*let manager = Manager.sharedInstance
                     // Specifying the Headers we need
                     manager.session.configuration.HTTPAdditionalHeaders = [
                     "Content-Type": "multipart/form-data"]
                     */
                    //let headers = ["Content-Type": "multipart/form-data"]
                    
                    //subir imagen
                    
                    
                    //Spinner.show("Sincronizando Visibilidad Fotos")
                    
                    
                    var url = ""
                    
                    if tipo == "visibilidad" {
                        
                        url = "http://\(dominio)/rest/multireport/image/rvisibility/1"
                        url = "http://\(dominio)/rest/multireport/image/rvisibility/2"
                        
                    }
                    
                    if tipo == "promocion" {
                        
                        url = "http://\(dominio)/rest/multireport/image/rpromo/1"
                        url = "http://\(dominio)/rest/multireport/image/rpromo/2"
                        
                    }
                    
                    
                    if tipo == "distribucion" {
                        
                        url = "http://\(dominio)/rest/multireport/image/rdistribution/1"
                        
                        
                    }
                    
                    if tipo == "encuesta" {
                        
                        
                        url = "http://\(dominio)/rest/multireport/image/poll/1"
                        
                    }
                    
                    
                    let usuario = defaults.object(forKey: "ultimoUsuario") as? String
                    let contrasena = defaults.object(forKey: "ultimaContrasena") as? String
                    
                    let credenciales = URLCredential(user: usuario!, password: contrasena!, persistence: .none)
                    
                    let fileUrl = URL(fileURLWithPath: imagen_ruta)
                    
                    let datosMD5 = datos.md5().base64EncodedString()
                    
                    Alamofire.upload(
                        multipartFormData: { multipartFormData in
                            multipartFormData.append(fileUrl, withName: "imagen")
                            multipartFormData.append(datosMD5.data(using: String.Encoding.utf8, allowLossyConversion: false)! ,withName: "md5")
                            multipartFormData.append((renglon[1] as! String).data(using: String.Encoding.utf8, allowLossyConversion: false)! ,withName: "hash")
                            multipartFormData.append((renglon[2] as! NSNumber).stringValue.data(using: String.Encoding.utf8, allowLossyConversion: false)! ,withName: "pdv")
                            multipartFormData.append(description.data(using: String.Encoding.utf8, allowLossyConversion: false)! ,withName: "description")
                        },
                        to: url,
                        encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.authenticate(usingCredential: credenciales)
                                upload.responseString { response in
                                    debugPrint(response)
                                    
                                   /* DispatchQueue.main.async {
                                        
                                        _ = SwiftSpinner.show("Base enviada. Toque para cerrar").addTapHandler({SwiftSpinner.hide()})
                                        
                                    }
                                    */
                                }
                                upload.responseJSON { response in
                                    
                                    //Spinner.hide()
                                    
                                    print("Response Foto \(tipo)")
                                    debugPrint(response)
                                    
                                    
                                    if tipo == "visibilidad" {
                                        
                                        sql = "update report_photo_visibility set is_send=1 where id='\(self.arregloFotosMandar[indice][0])'"
                                        
                                    }
                                    
                                    
                                    if tipo == "promocion" {
                                        
                                        sql = "update report_photo_promotions set is_send=1 where id='\(self.arregloFotosMandar[indice][0])'"
                                        
                                    }
                                    
                                    
                                    if tipo == "distribucion" {
                                        
                                        sql = "update report_photo_distribution set is_send=1 where id='\(self.arregloFotosMandar[indice][0])'"
                                        
                                    }
                                    
                                    
                                    if tipo == "encuesta" {
                                        
                                        sql = "update EncuestaFotos set is_send=1 where id='\(self.arregloFotosMandar[indice][0])'"
                                        
                                    }
                                    
                                    
                                    let resultado_update = self.db.execute_query(sql)
                                    
                                    
                                    print(sql)
                                    print("puso el uno es \(resultado_update)")
                                    
                                    indice += 1
                                    
                                    self.ciclo_fotos(idReporteLocal: idReporteLocal, usuario: usuario!, contrasena: contrasena!, indice: indice, total: total)
                                    
                                    
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                            }
                        }
                    )
                    
                    
                    
                    
                    
                    
                    //fin subir imagen
                    
                    
                }
                
            }
            
            
            
            
            //fin mandar fotos visibilidad
        }
        
        
    }
    
    
    
    //fin ciclo para mandar imagenes
    
    
    
    
    
    
    
    //servicio seraidos
    
    func servicio_seriado (usuario:String,contrasena:String,indice:Int,ids:[NSNumber]?=nil,controlador:AnyObject?=nil,funcion:String?=nil){
        
        //print("mi controlador es \(controlador) y la funcion es \(funcion)")
        
        print("voy en el indice \(indice)")
        
        print(ids as Any as Any)
        
        var servicios_indices:[NSNumber] = []
        
        
        
        if ids == nil {
            
            for q in 0 ..< servicios_json.arreglo.count {
                
                print(servicios_json.arreglo[q])
                
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
        
        print(servicios_indices)
        
        if indice < servicios_json.arreglo.count {
            
            //DispatchQueue.as
            
            DispatchQueue.main.async {
                
              //_ =  SwiftSpinner.show(self.servicios_json.arreglo[indice]["etiqueta"] as! String)
            }
            
            
            
            
            _ = ["Content-Encoding": "gzip"]
            
            let aux_idString = servicios_json.arreglo[indice]["id"] as! NSString
            
            let aux_id = NSNumber.init( value: aux_idString.integerValue)
            
            switch servicios_json.arreglo[indice]["tipo"] as! String {
                
                
                
                //case policy
                
                
            case "policy" where servicios_indices.contains(aux_id):
                
                let aux_url = "\(protocolo)://\(dominio)\(servicios_json.arreglo[indice]["servicio"] as! String)"
                
                //let aux_url = "http://gshpdiageocapabilitiesclone.jelastic.servint.net/capabilities-rest/rest/psspolicy/status"
                
                print(aux_url)
                
                let credenciales = URLCredential(user: usuario, password: contrasena, persistence: .none)
                
                Alamofire.request(aux_url, method: .get, encoding: JSONEncoding.default)
                    
                    //Alamofire.request(.GET, "\(protocolo)://\(dominio)\(servicios_json.arreglo[indice]["servicio"])",headers:headers)
                    .authenticate(usingCredential: credenciales)
                    
                    .responseJSON { response in
                        //print(response.request)  // original URL request
                        //print(response.response) // URL response
                        //print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        
                        if response.result.isFailure {
                            
                            print(response.request as Any)
                            
                            //SwiftSpinner.show("Error al contactar el servidor revisa tus datos e intentalo nuevamente").addTapHandler({SwiftSpinner.hide()})
                            
                            
                            
                        }
                        
                        /*if let JSON = response.result.value {
                         print("JSON: \(JSON)")
                         }*/
                        
                        //print(response.result.value)
                        
                        
                        
                        if  let data = response.result.value as? NSDictionary {
                            
                            //self.arregloServiciosListos.append(1)
                            
                            //print(data)
                            
                            //print(data["attempts"]!)
                            
                            //let respuesta = JSON(cadena: data as! String)
                            
                            print("el estatus es ")
                            
                            print(data["status"] as Any)
                            
                            
                            if data["status"] as! NSNumber == 2 {
                                
                                //SwiftSpinner.hide()
                                
                                
                                if let aux_controlador = controlador as? LoginController {
                                    
                                    print("si entramos al controlador")
                                    
                                    switch funcion! {
                                        
                                    case "inicio":
                                        
                                        
                                        let alertController = UIAlertController(title: "¡Atención!", message: "Su contraseña esta caduca es necesario actualizarla", preferredStyle: .alert)
                                        
                                        
                                        let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                                            UIAlertAction in
                                            
                                            print("se presiono Aceptar")
                                            
                                            aux_controlador.performSegue(withIdentifier: "logintocambiocontrasena", sender: aux_controlador)
                                            
                                        }
                                        
                                        
                                        alertController.addAction(okAction)
                                        
                                        aux_controlador.present(alertController, animated: true, completion: nil)
                                        
                                        
                                        
                                    default:
                                        break
                                        
                                    }
                                    
                                    
                                }
                                
                                
                                
                            }
                            
                            if data["status"] as! NSNumber == 1 {
                                
                                let aux = indice + 1
                                
                                self.servicio_seriado(usuario: usuario,contrasena: contrasena,indice: aux,ids: servicios_indices,controlador: controlador,funcion: funcion)
                                
                            }
                            
                        }
                        
                        
                        
                }
                
                
                
                //fin case policy
                
                
                
                
            case "get" where servicios_indices.contains(aux_id):
                
                let aux_url = "\(protocolo)://\(dominio)\(servicios_json.arreglo[indice]["servicio"] as! String)"
                
                print(aux_url)
                
                let credenciales = URLCredential(user: usuario, password: contrasena, persistence: .none)
                
                Alamofire.request(aux_url, method: .get, encoding: JSONEncoding.default)
                
                //Alamofire.request(.GET, "\(protocolo)://\(dominio)\(servicios_json.arreglo[indice]["servicio"])",headers:headers)
                    .authenticate(usingCredential: credenciales)
                    /*.responseString { response in
                    
                        let data = response.result.value
                        
                        //print(data)
                        
                        let aux_c = data?.data(using: .utf8)!
                        
                        let aux_data = try! JSONSerialization.jsonObject(with: aux_c!)
                        
                        print("aqui el json")
                        print(aux_data)
                        
                        //self.datos_servicio.append(aux_data)
                        
                        self.servicios_json.arreglo[indice]["datos"] = aux_data as AnyObject?
                        
                        let aux = indice + 1
                        
                        self.servicio_seriado(usuario: usuario,contrasena: contrasena,indice: aux,ids: servicios_indices,controlador: controlador,funcion: funcion)
                    
                    }*/
                    .responseJSON { response in
                        //print(response.request)  // original URL request
                        //print(response.response) // URL response
                        //print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        
                        if response.result.isFailure {
                            
                            print(response.request as Any as Any)
                            
                            //SwiftSpinner.show("Error al contactar el servidor revisa tus datos e inténtalo nuevamente").addTapHandler({SwiftSpinner.hide()})
                            
                            
                            
                        }
                        
                        /*if let JSON = response.result.value {
                         print("JSON: \(JSON)")
                         }*/
                        
                        //print(response.result.value)
                        
                        
                        
                        if  let data = response.result.value as? NSDictionary {
                            
                            //self.arregloServiciosListos.append(1)
                            
                            //print(data)
                            
                            //print(data["attempts"]!)
                            
                            //let respuesta = JSON(cadena: data as! String)
                            
                            var aux_elementos:[[String:AnyObject]] = []
                            
                            aux_elementos.append(data as! [String:AnyObject])
                            
                            self.datos_servicio.append(aux_elementos as AnyObject)
                            
                            self.servicios_json.arreglo[indice]["datos"] = aux_elementos as AnyObject?
                            
                            let aux = indice + 1
                            
                            self.servicio_seriado(usuario: usuario,contrasena: contrasena,indice: aux,ids: servicios_indices,controlador: controlador,funcion: funcion)
                            
                        }
                        if  let data = response.result.value as? NSArray {
                            
                            //self.arregloServiciosListos.append(1)
                            
                            //print(data)
                            
                            //print(data["attempts"]!)
                            
                            //let respuesta = JSON(cadena: data as! String)
                            
                            let aux_elementos = data as! [[String:AnyObject]]
                            
                            //for elemento in data as! [[String:AnyObject]] {
                            
                                //print("elemento del json")
                                //print(elemento)
                                //print(elemento["name"])
                                
                                
                            //}
                            
                            self.datos_servicio.append(aux_elementos as AnyObject)
                            
                            self.servicios_json.arreglo[indice]["datos"] = aux_elementos as AnyObject?
                            
                            let aux = indice + 1
                            
                            self.servicio_seriado(usuario: usuario,contrasena: contrasena,indice: aux,ids: servicios_indices,controlador: controlador,funcion: funcion)
                            
                        }
                        
                        
                }
                
            case "post","sync":
                
                let auxParametros = servicios_json.arreglo[indice]["parametros"] as! [String:AnyObject]
                
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
                
                var parametros:[[String : AnyObject]] = []
                
                let parametro_udid = [
                    "name": "\(auxParametros["name"] as! String)",
                    "value": auxValor
                ]
                
                parametros.append(parametro_udid as [String : AnyObject])
                
                let aux_url = "\(protocolo)://\(dominio)\(servicios_json.arreglo[indice]["servicio"] as! String)"
                
                print(aux_url)
                
                let auxJsonstring = parametros.toJsonString()
                
                let parameters: Parameters = ["json": auxJsonstring]
                
                print(parameters)
                
                let credenciales = URLCredential(user: usuario, password: contrasena, persistence: .none)
                
                Alamofire.request(aux_url, method: .post, parameters: parameters)
                    
                    //Alamofire.request(.GET, "\(protocolo)://\(dominio)\(servicios_json.arreglo[indice]["servicio"])",headers:headers)
                    .authenticate(usingCredential: credenciales)
                    /*.responseString { response in
                     
                     let data = response.result.value
                     
                     //print(data)
                     
                     let aux_c = data?.data(using: .utf8)!
                     
                     let aux_data = try! JSONSerialization.jsonObject(with: aux_c!)
                     
                     print("aqui el json")
                     print(aux_data)
                     
                     //self.datos_servicio.append(aux_data)
                     
                     self.servicios_json.arreglo[indice]["datos"] = aux_data as AnyObject?
                     
                     let aux = indice + 1
                     
                     self.servicio_seriado(usuario: usuario,contrasena: contrasena,indice: aux,ids: servicios_indices,controlador: controlador,funcion: funcion)
                     
                     }*/
                    .responseJSON { response in
                        //print(response.request)  // original URL request
                        //print(response.response) // URL response
                        //print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        
                        if response.result.isFailure {
                            
                            print(response.request as Any as Any)
                            
                            
                            //SwiftSpinner.show("Error al contactar el servidor revisa tus datos e inténtalo nuevamente").addTapHandler({SwiftSpinner.hide()})
                            
                            
                            
                        }
                        
                        /*if let JSON = response.result.value {
                         print("JSON: \(JSON)")
                         }*/
                        
                        //print(response.result.value)
                        
                        
                        
                        if  let data = response.result.value as? NSDictionary {
                            
                            //self.arregloServiciosListos.append(1)
                            
                            //print(data)
                            
                            //print(data["attempts"]!)
                            
                            //let respuesta = JSON(cadena: data as! String)
                            
                            var aux_elementos:[[String:AnyObject]] = []
                            
                            aux_elementos.append(data as! [String:AnyObject])
                            
                            self.datos_servicio.append(aux_elementos as AnyObject)
                            
                            self.servicios_json.arreglo[indice]["datos"] = aux_elementos as AnyObject?
                            
                            let aux = indice + 1
                            
                            self.servicio_seriado(usuario: usuario,contrasena: contrasena,indice: aux,ids: servicios_indices,controlador: controlador,funcion: funcion)
                            
                        }
                        if  let data = response.result.value as? NSArray {
                            
                            //self.arregloServiciosListos.append(1)
                            
                            //print(data)
                            
                            //print(data["attempts"]!)
                            
                            //let respuesta = JSON(cadena: data as! String)
                            
                            let aux_elementos = data as! [[String:AnyObject]]
                            
                            //for elemento in data as! [[String:AnyObject]] {
                            
                            //print("elemento del json")
                            //print(elemento)
                            //print(elemento["name"])
                            
                            
                            //}
                            
                            self.datos_servicio.append(aux_elementos as AnyObject)
                            
                            self.servicios_json.arreglo[indice]["datos"] = aux_elementos as AnyObject?
                            
                            let aux = indice + 1
                            
                            self.servicio_seriado(usuario: usuario,contrasena: contrasena,indice: aux,ids: servicios_indices,controlador: controlador,funcion: funcion)
                            
                        }
                        
                        
                }
                
            default:
                
                print("tipo  no manejado")
                
                let aux = indice + 1
                
                self.servicio_seriado(usuario: usuario,contrasena: contrasena,indice: aux,ids: servicios_indices,controlador: controlador,funcion: funcion)
                
            }
            
        }
        else {
            
            let hoy = Date()
            
            defaults.set(hoy, forKey: "ultimaActualizacion")
            
            
            //SwiftSpinner.hide()
            
            //_ = SwiftSpinner.show("Actualizando Base de Datos")
            
            llenar_tablas(ids: servicios_indices,controlador: controlador,funcion: funcion)
            
        }
        
        
        
        
    }
    
    
    //fin servicio seriado
    
    
    //llenar tablas
    
    func llenar_tablas(ids:[NSNumber]?=nil,controlador:AnyObject?=nil,funcion:String?=nil){
        
        print("mi controlador es \(String(describing: controlador)) y la funcion es \(String(describing: funcion))")
        
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
        
        print("tablas llenadas")
        
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
 
        
        
        DispatchQueue.main.async {
        
        /*
        SwiftSpinner.show("Sincronización Completa. Toque para cerar").addTapHandler({
            
            
            
            
            self.defaults.set(1, forKey: "sesion")
            
            SwiftSpinner.hide()
            
        })
        */
        
        }
        
    }
    
    //fin llenar tablas
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
