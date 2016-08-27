//
//  ViewController.swift
//  buscarlibro
//
//  Created by Erick Alberto Garcia Marquez on 27/08/16.
//  Copyright © 2016 erickgm. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.text != "" {
            buscarISBN(textField.text!)
            textView.text = ""
        } else {
            textView.text = "El ISBN del libro a buscar no debe de ser vacío"
        }
        
        textField.resignFirstResponder()
        return true
    }
    // 9788437604947 978-84-376-0494-7
    
    func buscarISBN(id: String) {
        
        
        let urlString = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(id)"
        let url = NSURL(string: urlString)
        
        let tarea = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            
            if error != nil {
               // print("Código de error \(error?.code)")
                //print("Error: \(error) ")
                let codigoError = error?.code
                
                if codigoError == -1009 {
                    
                    dispatch_async(dispatch_get_main_queue(), { 
                        let alertController = UIAlertController(title: "Error de Conexión", message: "No esta conectado a internet no se puede realizar la búsqueda", preferredStyle: .Alert)
                        let defaulAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                        alertController.addAction(defaulAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    })
                    
                }
            } else {
                //let datos = try?  NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
                let datos = NSString(data: data!, encoding: NSUTF8StringEncoding)
                dispatch_async(dispatch_get_main_queue(), { 
                    self.textView.text = datos! as String
                })
                
            }
        }
        
        tarea.resume()
    }
}

