//
//  ViewController.swift
//  PracticeSnapKit
//
//  Created by Park Sungmin on 2022/10/15.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    var ttv: UIView = {
       let view = UIView()
        
        
        view.backgroundColor = .systemPink
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(ttv)
        ttv.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc
    func test() {
        print("hello")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let gr = CustomPanGestureRecognizer(target: self, action: #selector(test))
        gr.delegate2 = self
        ttv.addGestureRecognizer(gr)
    }
}

extension ViewController: CustomPanGestureRecognizerDelegate {
    func hoho() {
        ttv.backgroundColor = .cyan
    }
}

class CustomPanGestureRecognizer: UIPanGestureRecognizer {
    
    var delegate2: CustomPanGestureRecognizerDelegate?
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        delegate2?.hoho()
    }
}

protocol CustomPanGestureRecognizerDelegate {
    func hoho()
}
