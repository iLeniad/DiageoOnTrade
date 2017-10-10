//
//  Constructor.swift
//  OnTrade2
//
//  Created by Daniel Cedeño García on 10/20/16.
//  Copyright © 2016 Go Sharp. All rights reserved.
//

import Foundation

class Constructor: NSObject {
    
    
    //variables
    
    var dominio = "207.58.154.100"
    
    var db:DB_Manager = DB_Manager()
    
    
    var defaults = UserDefaults.standard
    
    var colorTexto:String
    
    var cuadros:[Int] = []
    
    var aux_posicion=UIButton()
    
    var idReporteLocal = 0
    
    var fontFamilia = "Dosis-Regular"
    
    //fin variables
    
    
    
    //inicializacion
    
    override init() {
        
        colorTexto = "be1f45"
        
        
        
        cuadros.append(200)
        cuadros.append(0)
        cuadros.append(45)
        cuadros.append(45*2)
        cuadros.append(45*3)
        cuadros.append(45*4)
        cuadros.append(45*5)
        cuadros.append(45*6)
        cuadros.append(45*7)
        
        let base = defaults.object(forKey: "base") as! String
        
        db.open_database(base)
        
        super.init()
        
        
        
    }
    
    //Label
    
    func agregar_label(VistaScroll:UIScrollView,offset:Int,indice:Int,etiqueta:String,controlador:UITextFieldDelegate,tipo:String,ancho:Int,cuadro:Int,tamano:Int,linea:Float,columna:String)->[String:AnyObject]{
        
        var offset = offset
        
        
        
        
        let aux_label = UILabel()
        
        //print(CGFloat(tamano))
        
        aux_label.font = UIFont(name: "TitilliumWeb-Bold", size: CGFloat(tamano))
        
        aux_label.font = aux_label.font.withSize(CGFloat(tamano))
        
        aux_label.textColor = UIColor(rgba: "#\(colorTexto)")
        
        aux_label.text = "Q"
        
        //aux_label.sizeToFit()
        
        //let altura_letra = aux_label.frame.height
        
        aux_label.text = etiqueta
        
        print(Int(VistaScroll.frame.width))
        
        
        
        
        aux_label.numberOfLines = 0
        aux_label.textAlignment = .center
        //aux_label.sizeToFit()
        
        aux_label.frame = CGRect(x: 10, y: offset, width: Int(VistaScroll.frame.width - 10), height: Int(VistaScroll.frame.height/6))
        
        //aux_label.sizeThatFits(CGSize(width: VistaScroll.frame.width, height: altura_letra))
        
        aux_label.adjustFontSizeToFitRect(rect: aux_label.frame, maximo: CGFloat(tamano))
        
        //offset = Int(aux_label.frame.origin.y + aux_label.frame.height)
        
        offset += Int(20 * linea) + Int(VistaScroll.frame.height/6)
        
        VistaScroll.addSubview(aux_label)
        
        self.aux_posicion.frame = CGRect(x: 10, y: offset, width: 50, height: 50)
        
        
        
        VistaScroll.contentSize = CGSize(width: VistaScroll.contentSize.width, height: aux_posicion.frame.origin.y +  aux_posicion.frame.size.height+300)
        
        let elementos = ["offset":offset,"elemento":aux_label,"label":aux_label,"indice":indice,"tipo":tipo] as [String : Any]
        
        return elementos as [String : AnyObject]
    }
    
    
    //Fin Label
    
    
    
    //campos de texto
    
    func agregar_campotexto(VistaScroll:UIScrollView,offset:Int,indice:Int,etiqueta:String,controlador:UITextFieldDelegate,tipo:String,ancho:Int,cuadro:Int,linea:Int)->[String:AnyObject]{
        
        let campo_texto = UITextField()
        
        var offset = offset
        
        campo_texto.tag = indice
        
        
        let aux_label = UILabel()
        
        aux_label.font = UIFont(name: "TitilliumWeb-Bold", size: 18)
        
        aux_label.textColor = UIColor(rgba: "#\(colorTexto)")
        
        aux_label.text = etiqueta
        
        aux_label.frame = CGRect(x: 10 + cuadros[cuadro], y: offset, width: 200, height: 100)
        
        
        aux_label.numberOfLines = 0
        aux_label.textAlignment = .left
        aux_label.sizeToFit()
        
        
        
        offset += 40
        
        var aux_ancho = 0
        
        if ancho == 3 {
            
            aux_ancho = 260
            
        }
        
        if ancho == 2 {
            
            aux_ancho = 150
            
        }
        
        if ancho == 1 {
            
            aux_ancho = 70
            
        }
        
        campo_texto.frame = CGRect(x: 22 + cuadros[cuadro], y: offset, width: aux_ancho, height: 43)
        
        
        
        campo_texto.borderStyle = .roundedRect
        
        
        if tipo == "TEXT" {
            
            campo_texto.keyboardType = .default
            campo_texto.returnKeyType = UIReturnKeyType.done
            
        }
        
        if tipo == "NUMERIC" || tipo == "REAL" {
            
            campo_texto.keyboardType = UIKeyboardType.decimalPad
            
            
        }
        
        campo_texto.delegate = controlador
        
        
        
        
        
        offset += (linea * 20)
        
        
        
        VistaScroll.addSubview(campo_texto)
        VistaScroll.addSubview(aux_label)
        
        self.aux_posicion.frame = CGRect(x: 10, y: offset, width: 50, height: 50)
        
        VistaScroll.contentSize = CGSize(width: VistaScroll.contentSize.width, height: aux_posicion.frame.origin.y +  aux_posicion.frame.size.height+300)
        
        
        
        let elementos = ["offset":offset,"elemento":campo_texto,"label":aux_label,"indice":indice,"tipo":tipo] as [String : Any]
        
        return elementos as [String : AnyObject]
        
        
    }
    
    
    //fin campos de texto
    
    
    //radio button
    
    
    func agregar_radio(VistaScroll:UIScrollView,offset:Int,indice:Int,etiqueta:String,controlador:UIViewController,tipo:String,ancho:Int,opciones:[[String:AnyObject]],grupo:Int,cuadro:Int,linea:Int)->[String:AnyObject]{
        
        var offset = offset
        
        var aux_botones:[UIButton]=[]
        
        //botonesRadio.append(aux_botones)
        
        //preguntasArreglo[indice].append(botonesRadio.count-1)
        
        var aux_opciones:[UILabel]=[]
        
        //botonesRadioOpciones.append(aux_opciones)
        
        let aux_label = UILabel()
        
        aux_label.text = etiqueta
        
        aux_label.font = UIFont(name: "TitilliumWeb-Bold", size: 18)
        
        aux_label.textColor = UIColor(rgba: "#\(colorTexto)")
        
        aux_label.frame = CGRect(x: 10 + cuadros[cuadro], y: offset, width: 200, height: 50)
        
        aux_label.numberOfLines = 0
        aux_label.textAlignment = .left
        aux_label.sizeToFit()
        
        VistaScroll.addSubview(aux_label)
        
        //botonesRadioLabel.append(aux_label)
        
        
        offset += (linea * 20)
        
        //let sql = "select * from EAOpcionPregunta where idPregunta = \(preguntasArreglo[indice][0])"
        
        //let opciones = db.select_query(sql)
        
        var k = 0
        
        
        offset += 10
        
        
        
        for renglon in opciones {
            
            //print(renglon)
            
            
            //botonesRadioSeleccion.append([AnyObject]())
            
            //botonesRadioSeleccion[botonesRadioSeleccion.count - 1].append(indice)
            //botonesRadioSeleccion[botonesRadioSeleccion.count - 1].append((renglon[1] as? String)!)
            
            //var contestada = 0
            
            //var respuesta = ""
            
            var imagenRadio = "RadioButton"
            
            
            
            //let idReporteLocal = (defaults.objectForKey("idReporteLocal") as! NSNumber).stringValue
            
            //let sql_respuesta = "select respuesta from EARespuesta where idPregunta='\(preguntasArreglo[indice][0])' and idReporteLocal='\(idReporteLocal)' and idEncuesta='\(idEncuesta)' and numeroEncuesta='\(NumeroEncuesta)'"
            
            //let resultado_respuesta = db.select_query(sql_respuesta)
            
            /*for renglon_respuesta in resultado_respuesta {
             
             respuesta = renglon_respuesta[0] as! String
             contestada = 1
             }
             */
            
            
            if renglon["seleccionado"] as! NSNumber == 1 {
                
                
                imagenRadio = "RadioButtonSeleccionado"
                
            }
            
            
            //  botonesRadioSeleccion[botonesRadioSeleccion.count - 1].append(0)
            
            let b_radio = UIButton()
            
            b_radio.tag = indice
            
            
            
            b_radio.frame = CGRect(x: 10 + cuadros[Int(renglon["cuadro"]! as! String)!], y: offset, width: 50, height: 50)
            
            //self.aux_posicion.frame = CGRect(x: 10, y: offset, width: 50, height: 50)
            
            b_radio.setImage(UIImage(named: imagenRadio), for: .normal)
            
            //b_radio.addTarget(self, action: #selector(ModuloController.b_radio_opcion(_:)), forControlEvents:.TouchDown)
            
            //botonesRadio[botonesRadio.count-1].append(b_radio)
            
            aux_botones.append(b_radio)
            
            let b_opcion = UILabel()
            
            b_opcion.font = UIFont(name: "TitilliumWeb-Bold", size: 18)
            
            b_opcion.textColor = UIColor(rgba: "#\(colorTexto)")
            
            b_opcion.frame = CGRect(x: 50 + cuadros[Int(renglon["cuadro"]! as! String)!], y: offset+15, width: 80, height: 30)
            
            b_opcion.text = renglon["opcion"] as? String
            
            b_opcion.numberOfLines = 0
            b_opcion.textAlignment = .left
            b_opcion.sizeToFit()
            
            aux_opciones.append(b_opcion)
            
            //botonesRadioOpciones[botonesRadio.count-1].append(b_opcion)
            
            k += 1
            
            offset += (30 * Int(renglon["linea"]! as! String)!)
            
            VistaScroll.addSubview(b_radio)
            VistaScroll.addSubview(b_opcion)
            
            
            
            
        }
        
        offset += (linea * 20)
        
        self.aux_posicion.frame = CGRect(x: 10, y: offset, width: 50, height: 50)
        
        VistaScroll.contentSize = CGSize(width: VistaScroll.contentSize.width, height: aux_posicion.frame.origin.y +  aux_posicion.frame.size.height+300)
        
        
        let elementos = ["offset":offset,"botones":aux_botones,"opciones":aux_opciones,"label":aux_label,"indice":indice,"tipo":tipo,"grupo":grupo] as [String : Any]
        
        return elementos as [String : AnyObject]
        
    }
    
    
    //fin de radio button
    
    
    //acomodar elementos
    
    
    
    
    
    
    
    //guardar
    
    func agregar_boton_guardar(VistaScroll:UIScrollView,offset:Int,indice:Int,controlador:UITextFieldDelegate,tipo:String,ancho:Int,cuadro:Int,linea:Int,texto:String)->[String:AnyObject]{
        
        
        var offset = offset
        
        let aux_b_guardar = UIButton()
        
        aux_b_guardar.tag = indice
        
        
        
        let barraSubTitulo:UIScrollView = UIScrollView()
        
        barraSubTitulo.frame = CGRect(x: 0, y: (VistaScroll.superview?.frame.height)! - (VistaScroll.superview?.frame.height)!/12, width:(VistaScroll.superview?.frame.width)!, height: (VistaScroll.superview?.frame.height)!/12)
        
        //barraSubTitulo.frame = CGRect(x: 0, y: barraTitulo.frame.height + barraTitulo.frame.origin.y, width: barraTitulo.frame.width, height: barraTitulo.frame.height/2)
        
        let fondoBarraSubTitulo = UIImage(named: "LineaGris")
        
        let vistaFondoBarraSubtitulo:UIImageView = UIImageView()
        
        vistaFondoBarraSubtitulo.image = fondoBarraSubTitulo
        
        vistaFondoBarraSubtitulo.frame = CGRect(x: 0, y: 0, width: barraSubTitulo.frame.width, height: barraSubTitulo.frame.height)
        
        vistaFondoBarraSubtitulo.contentMode = .scaleAspectFill
        
        
        
        aux_b_guardar.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        aux_b_guardar.titleLabel!.font = aux_b_guardar.titleLabel!.font.withSize(CGFloat(14))
        
        
        
        aux_b_guardar.setAttributedTitle(nil, for: UIControlState())
        aux_b_guardar.setTitle(texto, for: UIControlState())
        aux_b_guardar.tag = 0
        
        aux_b_guardar.isSelected = false
        aux_b_guardar.setTitleColor(UIColor(rgba: "#c70752"), for: UIControlState())
        
        
        
        aux_b_guardar.titleLabel!.textColor = UIColor(rgba: "#c70752")
        aux_b_guardar.titleLabel!.numberOfLines = 0
        aux_b_guardar.titleLabel!.textAlignment = .right
        
        
        aux_b_guardar.sizeToFit()
        
        aux_b_guardar.frame = CGRect(x: 0, y: 0, width: barraSubTitulo.frame.width - barraSubTitulo.frame.width/20, height: barraSubTitulo.frame.height)
        
        
        
        aux_b_guardar.contentHorizontalAlignment = .right
        aux_b_guardar.contentVerticalAlignment = .center
        
        
        
        
        
        
        barraSubTitulo.addSubview(vistaFondoBarraSubtitulo)
        
        barraSubTitulo.addSubview(aux_b_guardar)
        
        
        
        
        
        
        //aux_b_guardar.frame = CGRect(x: 10 + cuadros[cuadro], y: offset - 8, width: 44, height: 44)
        
        /*
         aux_b_foto.contentEdgeInsets = UIEdgeInsetsMake(0, 0, aux_b_foto.titleLabel!.bounds.height + 4, 0)
         aux_b_foto.titleEdgeInsets = UIEdgeInsetsMake((aux_b_foto.imageView?.image!.size.height)! + 18, -(aux_b_foto.imageView?.image!.size.width)!, 0, 0)
         aux_b_foto.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -aux_b_foto.titleLabel!.bounds.width)
         */
        
        
        
        
        
        VistaScroll.superview?.addSubview(barraSubTitulo)

        
        offset += (linea * 20)
        
        let elementos = ["offset":offset,"elemento":aux_b_guardar,"indice":indice,"tipo":tipo] as [String : Any]
        
        return elementos as [String : AnyObject]
        
    }
    
    //fin guardar
    
    
    
    //agregar
    
    func agregar_boton_agregar(VistaScroll:UIScrollView,offset:Int,indice:Int,controlador:UITextFieldDelegate,tipo:String,ancho:Int,cuadro:Int,linea:Int,texto:String)->[String:AnyObject]{
        
        
        var offset = offset
        
        let aux_b_guardar = UIButton()
        
        aux_b_guardar.tag = indice
        
        
        
        //aux_b_foto.setImage(UIImage(named: "CamaraInactiva"), for: .normal)
        
        //botonfoto.addTarget(self, action: "tomar_foto:", forControlEvents:.TouchDown)
        
        
        let barraSubTitulo:UIScrollView = UIScrollView()
        
        barraSubTitulo.frame = CGRect(x: 0, y: (VistaScroll.superview?.frame.height)! - (VistaScroll.superview?.frame.height)!/12, width:(VistaScroll.superview?.frame.width)!, height: (VistaScroll.superview?.frame.height)!/12)
        
        //barraSubTitulo.frame = CGRect(x: 0, y: barraTitulo.frame.height + barraTitulo.frame.origin.y, width: barraTitulo.frame.width, height: barraTitulo.frame.height/2)
        
        let fondoBarraSubTitulo = UIImage(named: "LineaGris")
        
        let vistaFondoBarraSubtitulo:UIImageView = UIImageView()
        
        vistaFondoBarraSubtitulo.image = fondoBarraSubTitulo
        
        vistaFondoBarraSubtitulo.frame = CGRect(x: 0, y: 0, width: barraSubTitulo.frame.width, height: barraSubTitulo.frame.height)
        
        vistaFondoBarraSubtitulo.contentMode = .scaleAspectFill
        
        
        
        aux_b_guardar.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        aux_b_guardar.titleLabel!.font = aux_b_guardar.titleLabel!.font.withSize(CGFloat(14))
        
        
        
        aux_b_guardar.setAttributedTitle(nil, for: UIControlState())
        aux_b_guardar.setTitle(texto, for: UIControlState())
        aux_b_guardar.tag = 0
        
        aux_b_guardar.isSelected = false
        aux_b_guardar.setTitleColor(UIColor(rgba: "#c70752"), for: UIControlState())
        
        
        
        aux_b_guardar.titleLabel!.textColor = UIColor(rgba: "#c70752")
        aux_b_guardar.titleLabel!.numberOfLines = 0
        aux_b_guardar.titleLabel!.textAlignment = .right
        
        
        aux_b_guardar.sizeToFit()
        
        aux_b_guardar.frame = CGRect(x: 0, y: 0, width: barraSubTitulo.frame.width - barraSubTitulo.frame.width/20, height: barraSubTitulo.frame.height)
        
        
        
        aux_b_guardar.contentHorizontalAlignment = .right
        aux_b_guardar.contentVerticalAlignment = .center
        
        
        
        
        
        
        barraSubTitulo.addSubview(vistaFondoBarraSubtitulo)
        
        barraSubTitulo.addSubview(aux_b_guardar)
        
        
        
        
        
        
        //aux_b_guardar.frame = CGRect(x: 10 + cuadros[cuadro], y: offset - 8, width: 44, height: 44)
        
        /*
         aux_b_foto.contentEdgeInsets = UIEdgeInsetsMake(0, 0, aux_b_foto.titleLabel!.bounds.height + 4, 0)
         aux_b_foto.titleEdgeInsets = UIEdgeInsetsMake((aux_b_foto.imageView?.image!.size.height)! + 18, -(aux_b_foto.imageView?.image!.size.width)!, 0, 0)
         aux_b_foto.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -aux_b_foto.titleLabel!.bounds.width)
         */
        
        
        
        
        
        VistaScroll.superview?.addSubview(barraSubTitulo)

        
        offset += (linea * 20)
        
        let elementos = ["offset":offset,"elemento":aux_b_guardar,"indice":indice,"tipo":tipo] as [String : Any]
        
        return elementos as [String : AnyObject]
        
    }
    
    //fin agregar
    
    
    //foto
    
    func agregar_foto(VistaScroll:UIScrollView,offset:Int,indice:Int,controlador:UITextFieldDelegate,tipo:String,ancho:Int,cuadro:Int,linea:Int)->[String:AnyObject]{
        
        
        var offset = offset
        
        let aux_b_foto = UIButton()
        
        aux_b_foto.tag = indice
        
        
        
        aux_b_foto.setImage(UIImage(named: "CamaraInactiva"), for: .normal)
        
        //botonfoto.addTarget(self, action: "tomar_foto:", forControlEvents:.TouchDown)
        
        
        aux_b_foto.setAttributedTitle(nil, for: .normal)
        aux_b_foto.setTitle("Tomar Foto 0/4", for: .normal)
        
        aux_b_foto.isSelected = false
        aux_b_foto.setTitleColor(UIColor(rgba: "#\(colorTexto)"), for: .normal)
        
        aux_b_foto.titleLabel!.font = UIFont(name: "TitilliumWeb-SemiBold", size: 4)
        
        aux_b_foto.titleLabel!.font = aux_b_foto.titleLabel!.font.withSize(8)
        
        aux_b_foto.titleLabel!.textColor = UIColor(rgba: "#\(colorTexto)")
        aux_b_foto.titleLabel!.numberOfLines = 0
        aux_b_foto.titleLabel!.textAlignment = .center
        aux_b_foto.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        
        
        aux_b_foto.frame = CGRect(x: 10 + cuadros[cuadro], y: offset - 8, width: Int(VistaScroll.frame.width/4), height: 44)
        
        aux_b_foto.contentEdgeInsets = UIEdgeInsetsMake(0, 0, aux_b_foto.titleLabel!.bounds.height + 4, 0)
        aux_b_foto.titleEdgeInsets = UIEdgeInsetsMake((aux_b_foto.imageView?.image!.size.height)! + 18, -(aux_b_foto.imageView?.image!.size.width)!, 0, 0)
        aux_b_foto.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -aux_b_foto.titleLabel!.bounds.width)
        
        
        VistaScroll.addSubview(aux_b_foto)
        
        offset += (linea * 20)
        
        let elementos = ["offset":offset,"elemento":aux_b_foto,"indice":indice,"tipo":tipo] as [String : Any]
        
        return elementos as [String : AnyObject]
        
    }
    
    //fin foto
    
    //select_one_spinner
    
    func agregar_select(VistaScroll:UIScrollView,offset:Int,indice:Int,etiqueta:String,controlador:UITextFieldDelegate,tipo:String,ancho:Int,cuadro:Int,linea:Int,fondo:Int?=nil)->[String:AnyObject]{
        
        var offset = offset
        
        let aux_b_select = UIButton()
        
        
        aux_b_select.tag = indice
        
        
        
        
        
        //botonfoto.addTarget(self, action: "tomar_foto:", forControlEvents:.TouchDown)
        
        
        aux_b_select.setAttributedTitle(nil, for: .normal)
        aux_b_select.setTitle(etiqueta, for: .normal)
        
        aux_b_select.isSelected = false
        aux_b_select.setTitleColor(UIColor(rgba: "#\(colorTexto)"), for: .normal)
        
        aux_b_select.titleLabel!.font = UIFont(name: "TitilliumWeb-SemiBold", size: 4)
        
        aux_b_select.titleLabel!.font = aux_b_select.titleLabel!.font.withSize(16)
        
        aux_b_select.titleLabel!.textColor = UIColor(rgba: "#\(colorTexto)")
        aux_b_select.titleLabel!.numberOfLines = 0
        aux_b_select.titleLabel!.textAlignment = .left
        aux_b_select.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        
        print(cuadro)
        print(cuadros)
        print(cuadros[cuadro])
        
        aux_b_select.frame = CGRect(x: 10 + cuadros[cuadro], y: offset - 8, width:Int(VistaScroll.frame.width), height: 50)
        
        print(aux_b_select.frame)
        
        aux_b_select.imageView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        //aux_b_select.contentEdgeInsets = UIEdgeInsetsMake(aux_b_select.titleLabel!.bounds.height + 4, 0, 0, 0)
        //aux_b_select.titleEdgeInsets = UIEdgeInsetsMake(0, 0,-(aux_b_select.imageView?.image!.size.width)!, (aux_b_select.imageView?.image!.size.height)! + 18)
        //aux_b_select.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -aux_b_select.titleLabel!.bounds.width)
        
        if fondo == nil {
        
        aux_b_select.setImage(UIImage(named: "FlechaSelectDerecha"), for: .normal)
            
        aux_b_select.titleEdgeInsets = UIEdgeInsetsMake(0, -aux_b_select.imageView!.frame.size.width, 0, aux_b_select.imageView!.frame.size.width);
        aux_b_select.imageEdgeInsets = UIEdgeInsetsMake(18, aux_b_select.titleLabel!.frame.size.width + 10, 18, -aux_b_select.titleLabel!.frame.size.width);
        
        }
        else{
        
            aux_b_select.setImage(UIImage(named: "SelectFondo"), for: .normal)
        
        }
        
            
        VistaScroll.addSubview(aux_b_select)
        
        
        offset += (linea * 20) + Int(aux_b_select.frame.height)
        
        let elementos = ["offset":offset,"elemento":aux_b_select,"indice":indice,"tipo":tipo] as [String : Any]
        
        return elementos as [String : AnyObject]
        
    }
    
    //fin select_one_spinner
    
    
    
    //lista doble
    
    func agregar_lista_doble(VistaScroll:UIScrollView,offset:Int,indice:Int,etiqueta:String,controlador:UITextFieldDelegate,tipo:String,ancho:Int,cuadro:Int,linea:Int)->[String:AnyObject]{
        
        var offset = offset
        
        let vistaLista:UIScrollView = UIScrollView()
        
        vistaLista.backgroundColor = UIColor.init(rgba: "#eeeeee")
        
        vistaLista.frame = CGRect(x: 10.0, y: CGFloat(offset), width: VistaScroll.superview!.frame.width - 20, height: VistaScroll.frame.height/3)
        
        let aux_b_select = UIButton()
        
        
        aux_b_select.tag = indice
        
        
        
        //aux_b_select.setImage(UIImage(named: "FlechaSelectDerecha"), for: .normal)
        
        //botonfoto.addTarget(self, action: "tomar_foto:", forControlEvents:.TouchDown)
        
        
        aux_b_select.setAttributedTitle(nil, for: .normal)
        aux_b_select.setTitle(etiqueta, for: .normal)
        
        aux_b_select.isSelected = false
        aux_b_select.setTitleColor(UIColor(rgba: "#\(colorTexto)"), for: .normal)
        
        aux_b_select.titleLabel!.font = UIFont(name: "TitilliumWeb-SemiBold", size: 4)
        
        aux_b_select.titleLabel!.font = aux_b_select.titleLabel!.font.withSize(16)
        
        aux_b_select.titleLabel!.textColor = UIColor(rgba: "#\(colorTexto)")
        aux_b_select.titleLabel!.numberOfLines = 0
        aux_b_select.titleLabel!.textAlignment = .left
        aux_b_select.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        
        
        aux_b_select.frame = CGRect(x: 10 + cuadros[cuadro], y: 0, width:Int(VistaScroll.frame.width), height: 50)
        
        //aux_b_select.imageView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        //aux_b_select.contentEdgeInsets = UIEdgeInsetsMake(aux_b_select.titleLabel!.bounds.height + 4, 0, 0, 0)
        //aux_b_select.titleEdgeInsets = UIEdgeInsetsMake(0, 0,-(aux_b_select.imageView?.image!.size.width)!, (aux_b_select.imageView?.image!.size.height)! + 18)
        //aux_b_select.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -aux_b_select.titleLabel!.bounds.width)
        
        //aux_b_select.titleEdgeInsets = UIEdgeInsetsMake(0, -aux_b_select.imageView!.frame.size.width, 0, aux_b_select.imageView!.frame.size.width);
        //aux_b_select.imageEdgeInsets = UIEdgeInsetsMake(18, aux_b_select.titleLabel!.frame.size.width + 10, 18, -aux_b_select.titleLabel!.frame.size.width);
        
        vistaLista.addSubview(aux_b_select)
        
        VistaScroll.addSubview(vistaLista)
        
        offset += (linea * 20) + Int(aux_b_select.frame.height)
        
        let elementos = ["offset":offset,"elemento":vistaLista,"indice":indice,"tipo":tipo] as [String : Any]
        
        return elementos as [String : AnyObject]
        
    }
    
    //fin lista_doble
    
    
    
    
    //boton subestructura
    
    
    func agregar_boton_subestructura(VistaScroll:UIScrollView,offset:Int,indice:Int,etiqueta:String,controlador:UITextFieldDelegate,tipo:String,ancho:Int,cuadro:Int,linea:Int)->[String:AnyObject]{
        
        var offset = offset
        
        let aux_boton = UIButton()
        
        let aux_boton_ojo = UIButton()
        
        
        aux_boton.tag = indice
        
        aux_boton.setAttributedTitle(nil, for: .normal)
        aux_boton.setTitle(etiqueta, for: .normal)
        
        aux_boton.isSelected = false
        aux_boton.setTitleColor(UIColor(rgba: "#\(colorTexto)"), for: .normal)
        
        
        
        aux_boton.titleLabel!.font = UIFont(name: "TitilliumWeb-SemiBold", size: 4)
        
        aux_boton.titleLabel!.font = aux_boton.titleLabel!.font.withSize(16)
        
        aux_boton.titleLabel!.textColor = UIColor(rgba: "#\(colorTexto)")
        aux_boton.titleLabel!.numberOfLines = 0
        aux_boton.titleLabel!.textAlignment = .left
        aux_boton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        
        
        aux_boton.frame = CGRect(x: cuadros[cuadro] - 50, y: offset, width:Int(VistaScroll.frame.width), height: 50)
        
        
        aux_boton_ojo.setImage(UIImage(named: "botonOjo"), for: .normal)
        
        
        aux_boton_ojo.setAttributedTitle(nil, for: .normal)
        aux_boton_ojo.setTitle("", for: .normal)
        
        aux_boton_ojo.isSelected = false
        aux_boton_ojo.setTitleColor(UIColor(rgba: "#\(colorTexto)"), for: .normal)
        
        aux_boton_ojo.titleLabel!.font = UIFont(name: "TitilliumWeb-SemiBold", size: 4)
        
        aux_boton_ojo.titleLabel!.font = aux_boton_ojo.titleLabel!.font.withSize(16)
        
        aux_boton_ojo.titleLabel!.textColor = UIColor(rgba: "#\(colorTexto)")
        aux_boton_ojo.titleLabel!.numberOfLines = 0
        aux_boton_ojo.titleLabel!.textAlignment = .left
        aux_boton_ojo.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        
        
        aux_boton_ojo.frame = CGRect(x: 10 + cuadros[cuadro] + (etiqueta.characters.count * 7), y: offset + 4, width:40, height: 40)
        
        aux_boton_ojo.imageView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        //aux_boton_ojo.titleEdgeInsets = UIEdgeInsetsMake(0, -aux_boton_ojo.imageView!.frame.size.width, 0, aux_boton_ojo.imageView!.frame.size.width);
        //aux_boton_ojo.imageEdgeInsets = UIEdgeInsetsMake(18, aux_boton_ojo.titleLabel!.frame.size.width + 10, 18, -aux_boton_ojo.titleLabel!.frame.size.width);
        
        
        
        VistaScroll.addSubview(aux_boton_ojo)
        VistaScroll.addSubview(aux_boton)
        
        VistaScroll.bringSubview(toFront: aux_boton_ojo)
        
        
        offset += (linea * 20) + Int(aux_boton.frame.height)
        
        
        let elementos = ["offset":offset,"elemento":aux_boton,"elemento_ojo":aux_boton_ojo,"indice":indice,"tipo":tipo] as [String : Any]
        
        return elementos as [String : AnyObject]
        
    }
    
    //fin boton subestructura
    func agregar_boton_filtro(VistaScroll:UIScrollView,offset:Int,indice:Int,etiqueta:String,controlador:UITextFieldDelegate,tipo:String,opciones:[[String:AnyObject]])->[String:AnyObject]{
        
        //var offset = offset
        
        let aux_boton = UIButton()
        
        
        aux_boton.tag = indice
        
        aux_boton.setAttributedTitle(nil, for: .normal)
        //aux_boton.setTitle("Filtro", forState: .Normal)
        
        aux_boton.isSelected = false
        aux_boton.setTitleColor(UIColor(rgba: "#\(colorTexto)"), for: .normal)
        
        
        
        aux_boton.titleLabel!.font = UIFont(name: "TitilliumWeb-SemiBold", size: 4)
        
        aux_boton.titleLabel!.font = aux_boton.titleLabel!.font.withSize(16)
        
        aux_boton.titleLabel!.textColor = UIColor(rgba: "#\(colorTexto)")
        aux_boton.titleLabel!.numberOfLines = 0
        aux_boton.titleLabel!.textAlignment = .left
        aux_boton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        aux_boton.contentVerticalAlignment = .center
        
        aux_boton.frame = CGRect(x: (VistaScroll.superview?.frame.width)! - ((VistaScroll.superview?.frame.width)!/6), y: 0, width:66, height: (VistaScroll.superview?.frame.height)!/12)
        
        aux_boton.setImage(UIImage(named: "botonFiltro"), for: .normal)
        
        VistaScroll.superview?.addSubview(aux_boton)
        
        
        let elementos = ["offset":offset,"elemento":aux_boton,"indice":indice,"tipo":tipo,"opciones":opciones] as [String : Any]
        
        return elementos as [String : AnyObject]
        
    }
    
    
    
}
