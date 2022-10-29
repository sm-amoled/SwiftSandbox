//
//  ViewController.swift
//  f
//
//  Created by Park Sungmin on 2022/10/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpLayout()
    }

    let toolbar: UIToolbar = {
       let view = UIToolbar()
        view.barPosition
        view.backgroundColor = .systemBlue
        return view
    }()
    
    func setUpLayout() {
        view.addSubview(toolbar)
    }

}

