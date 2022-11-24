//
//  ViewController.swift
//  SwiftUItoUIKit
//
//  Created by Park Sungmin on 2022/11/18.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let label = UILabel()
        label.text = "UIKit Screen"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 21)
        view.addSubview(label)
        
        let button = UIButton()
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("Navigate to SwiftUI Screen", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openSwiftUIScreen), for: .touchUpInside)
        button.titleLabel?.font = .boldSystemFont(ofSize: 21)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 64)])
    }
    
    let swiftUIController = UIHostingController(rootView: FirstView())
    
    
    @objc func openSwiftUIScreen() {
        let test_nil: Int? = nil
        let test_value: Int? = 3
        
        if let test = test_nil {
            print("hello")
        } else {
            print("world") // 호출
        }
        if let test = test_value{
            print("hi") // 호출
        } else {
            print("ho")
        }
//        guard nil else { print("nil") } // guard else 사이 condition에는 Bool 값만 들어갈 수 있음
//
//        guard test_nil != nil else { print("test1"); return }       // return 됨
//        guard test_value != nil else { print("test2"); return }     // return 안됨
//
//        guard let t1 = test_nil else { print("test3"); return }     // return 됨
//        guard let t2 = test_value else { print("test4"); return }   // return 안됨
        
        
        let swiftUIViewController = UIHostingController(rootView: FirstView())
        self.navigationController?.pushViewController(swiftUIViewController, animated: true)
    }
}

