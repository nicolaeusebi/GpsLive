//
//  LoginController.swift
//  GpsLive
//
//  Created by Nicola Eusebi on 23/10/18.
//  Copyright © 2018 Nicola Eusebi. All rights reserved.
//

import UIKit

class LoginController: UIViewController, AuthDelegate {
    
    

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblError: UILabel!
    
    var parentController: MainController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLoginTouched(_ sender: Any)
    {
        APIHelper.CheckLogin(self, username: txtUsername.text!, password: txtPassword.text!)
    }
    
    func CheckLoginCompleted(success: Bool, username: String?)
    {
        if success && username != nil
        {
            SharedInfo.setUserName(username!)
            SharedInfo.setPassword(txtPassword.text!)
            if parentController != nil
            {
                self.parentController?.StartFetchData()
            }
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            DispatchQueue.main.async(execute: {
                self.lblError.isHidden = false
            })
        }
    }

}
