//
//  ViewController.swift
//  applyLint
//
//  Created by Park Sungmin on 2022/10/29.
//

import UIKit

class ViewController: UIViewController {
    
    var stringArray = ["hello", "world"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if !stringArray[0].isEmpty {
            print(stringArray[0])
        }
    }
}
