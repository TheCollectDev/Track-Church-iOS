//
//  ViewController.swift
//  Track Church
//
//  Created by Lee Watkins on 2016/12/11.
//  Copyright © 2016 Lee Watkins. All rights reserved.
//

import UIKit
import FirebaseAuthUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let authUI = FUIAuth.defaultAuthUI()
        let authViewController = authUI!.authViewController()
        self.navigationController?.present(authViewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

