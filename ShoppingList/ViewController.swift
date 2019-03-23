//
//  ViewController.swift
//  ShoppingList
//
//  Created by Eric Brito on 23/03/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit

import Firebase
// import FirebaseAuth

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfNome: UITextField!
    
    
    var handle: AuthStateDidChangeListenerHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            print("Usuario Logado", user?.email)
            
            if let user  = user {
                
                self.showMainScreen(user: user, animated: false)
                
            }
            
            
            
            
        })
    }
    
    func showMainScreen (user: User?, animated: Bool = true){
        
        print("Indo para a proxima tela")
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: ShowTableViewController.self))else {return}
        
        
        
        navigationController?.pushViewController(vc, animated: animated)
       
    }
    
    func performUserChanger(user: User?){
        
        guard let user = user else {return}
            let changerRequest = user.createProfileChangeRequest()
            changerRequest.displayName = tfNome.text
        
            changerRequest.commitChanges { (erro) in
            if erro != nil {
                  print(erro!)
            }
               self.showMainScreen(user: user, animated: true)
            
            
           
        }
    }
    
    
    func removeListener(){
        if let handle = handle {
        Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    @IBAction func btLogin(_ sender: Any) {
        
       removeListener()
        
        Auth.auth().signIn(withEmail: tfEmail.text!, password: tfPassword.text!) { (result, error) in
            if error == nil {
                self.performUserChanger(user: result?.user)
            }else{
                print(error!)
            }
            
        }
        
        
        
    }
    
    
    @IBAction func btSingup(_ sender: Any) {
        
          removeListener()
        
        
        Auth.auth().createUser(withEmail: tfEmail.text!, password: tfPassword.text!) { (result, error) in
            
            if error == nil {
                self.performUserChanger(user: result?.user)
            }else{
                print(error!)
            }
            
            
            
            
            
            
            
            
        }
        
        
        
    }
    
}


