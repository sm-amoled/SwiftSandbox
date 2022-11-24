//
//  ViewController.swift
//  SwipePaging
//
//  Created by Park Sungmin on 2022/11/20.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 3
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [])
        view.backgroundColor = .systemBlue
        view.distribution = .fillEqually
        view.alignment = .fill
        
        return view
    }()
    
    @objc func panPrint(_ sender: UIPanGestureRecognizer) {
        let cellWidth = Int(stackView.bounds.width) / stackView.subviews.count
    
        let index = min(max(Int(sender.location(in: stackView).x) / cellWidth, 0), stackView.subviews.count-1)
        
        mainView.backgroundColor = stackView.subviews[index].backgroundColor
    }
    
    lazy var addPageButton: UIButton = {
        let view = UIButton()
        view.setTitle("+", for: .normal)
        view.setTitleColor(.systemRed, for: .normal)
        view.addTarget(self, action: #selector(tapAddButton(_:)), for: .touchUpInside)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpLayout()
    }
    
    @objc func tapAddButton(_ sender: UIButton) {
        let view = {
            let view = UIView()
//            view.isUserInteractionEnabled = false
//            view.addTarget(self, action: #selector(enterPageView(_:)), for: .allEvents)
            view.backgroundColor = .random()
            view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panPrint(_:))))
            
            return view
        }()
        
        stackView.addArrangedSubview(view)
        view.layoutIfNeeded()
    }
    
    @objc func enterPageView(_ sender: UIButton) {
        mainView.backgroundColor = sender.backgroundColor
        view.layoutIfNeeded()
    }
}

extension ViewController {
    func setUpLayout() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(100)
        }
        
        view.addSubview(addPageButton)
        addPageButton.snp.makeConstraints {
            $0.top.equalTo(mainView.snp.bottom)
            $0.trailing.equalTo(mainView.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.width.equalTo(80)
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(mainView.snp.bottom)
            $0.leading.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(addPageButton.snp.leading)
        }
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red:   .random(in: 0...1),
            green: .random(in: 0...1),
            blue:  .random(in: 0...1),
            alpha: 1.0
        )
    }
}
