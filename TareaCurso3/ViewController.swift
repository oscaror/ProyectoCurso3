//
//  ViewController.swift
//  TareaCurso3
//
//  Created by Oscar Ortega on 17/05/16.
//  Copyright © 2016 Ozzcorp. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var buscador: UITextField!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autor: UILabel!
   
    @IBOutlet weak var portada: UIImageView!
    
    var cadenaBusqueda : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buscador.delegate = self
        
      
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //ocultar teclado presionando la tecla enter
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        buscador.resignFirstResponder()
        buscar()
        return true
    }
    
    //ocultar teclado tocando la pantalla
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        buscador.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    
    func buscar (){
        //el metodo es sincrono
        cadenaBusqueda = buscador.text!
        
        let bloque2 : String = "api/books?jscmd=data&format=json&bibkeys=ISBN:"
        
        
        let urls = "http://openlibrary.org/" //se crea el string con el url del servidor
        let urls2 = urls+bloque2+cadenaBusqueda
        let url = NSURL(string: urls2) //se convierte en una URL
        //print (url)
        
        let datos : NSData? =  NSData (contentsOfURL: url!) //usando NSData, solicitamos una peticion al servidor, se espera aqui a que el servidor conteste y el resultado lo asociamos a esa variable
        if datos == nil{
            showSimpleAlert()
            self.titulo.text = "Error de conexión - Intenta de nuevo"
            buscador.text = ""
            titulo.text = ""
            autor.text = ""
            portada.image = UIImage (named: "blank")
            
        
        }else {
            let texto = NSString(data:datos!, encoding:NSUTF8StringEncoding)
            if texto == "{}"{
                showSimpleAlert2()
                buscador.text = ""
                titulo.text = ""
                autor.text = ""
                portada.image = UIImage (named: "blank")
                
            }else {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves) as! Dictionary<String, AnyObject>
                    let dico1 = json as NSDictionary
                    let dico2 = dico1["ISBN:"+cadenaBusqueda]
                    self.titulo.text = dico2!["title"] as! NSString as String
                    
                    let dico3 = dico2!["authors"] as! NSArray
                    self.autor.text = dico3[0]["name"] as! NSString as String
                    
                    let dico4 = dico2?["cover"] as? NSDictionary
                    if dico4 == nil {
                        portada.image = UIImage (named: "blank")
                        print ("NO")
                    }else {
                        let urlImg = dico4!["medium"] as! NSString
                    
                        let url = NSURL(string: urlImg as String)
                        let data2 = NSData (contentsOfURL: url!)
                        portada.image = UIImage (data: data2!)
                    }
                        
                    
                }
                catch _ {
                    
                }
            }
            
            //let texto = NSString(data:datos!, encoding:NSUTF8StringEncoding) //los datos que estamos obteniendo estan codificados como UTF
            /* dispatch_async(dispatch_get_main_queue(), {
                // para que la app no truene al llenar el textview por los autolayouts
                if datos == "{}"{
                    //self.contenido.text = "ISBN erroneo - Libro no encontrado"
                }else{
                    //self.contenido.text = texto! as String
                    
                }
            }) */

            
        }
        
        
        
        
    
        
    }
        
        
    
  

    @IBAction func limpiarBusqueda(sender: AnyObject) {
        buscador.text = ""
        //contenido.text = ""
    }
    
    
    @IBAction func buscarLibro(sender: AnyObject) {
        buscar()
        textFieldShouldReturn(buscador)
    }
    
    
    func showSimpleAlert() {
        let title = NSLocalizedString("Error", comment: "")
        let message = NSLocalizedString("No hay conexión a internet. Reintente más tarde", comment: "")
        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Create the action.
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel) { action in
            NSLog("The simple alert's cancel action occured.")
        }
        
        // Add the action.
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showSimpleAlert2() {
        let title = NSLocalizedString("Error", comment: "")
        let message = NSLocalizedString("Libro no encontrado - Compruebe ISBN", comment: "")
        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Create the action.
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel) { action in
            NSLog("The simple alert's cancel action occured.")
        }
        
        // Add the action.
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        return true
    }


}

