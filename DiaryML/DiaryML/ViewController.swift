//
//  ViewController.swift
//  DiaryML
//
//  Created by Park Sungmin on 2022/08/29.
//

import UIKit
import PythonKit


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sys = Python.import("sys")
        sys.path.append("./.") // path to your Python file's directory.
//        let example = Python.import("example") // import your Python file.
//        example.hello() // call your Python function.
    }
    
}

