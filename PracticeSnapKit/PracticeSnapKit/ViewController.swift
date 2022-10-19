//
//  ViewController.swift
//  PracticeSnapKit
//
//  Created by Park Sungmin on 2022/10/15.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private var redButton: UIButton = UIButton()
    private var blueButton: UIButton = UIButton()
    private var greenButton: UIButton = UIButton()
    private var pinkButton: UIButton = UIButton()
    
    private var resultLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLayout()
    }

    private func setupLayout() {
        self.view.addSubview(redButton)
        self.view.addSubview(blueButton)
        self.view.addSubview(greenButton)
        self.view.addSubview(pinkButton)
        self.view.addSubview(resultLabel)
        
        redButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        redButton.backgroundColor = .systemRed
        redButton.setTitle("Red Button", for: .normal)
        redButton.setTitleColor(.white, for: .normal)
        
        blueButton.snp.makeConstraints { make in
            make.top.equalTo(redButton.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        blueButton.backgroundColor = .systemBlue
        blueButton.setTitle("Blue Button", for: .normal)
        blueButton.setTitleColor(.white, for: .normal)
        
        greenButton.snp.makeConstraints { make in
            make.top.equalTo(blueButton.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        greenButton.backgroundColor = .systemGreen
        greenButton.setTitle("Green Button", for: .normal)
        greenButton.setTitleColor(.white, for: .normal)
        
        pinkButton.snp.makeConstraints { make in
            make.top.equalTo(greenButton.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        pinkButton.backgroundColor = .systemPink
        pinkButton.setTitle("Pink Button", for: .normal)
        pinkButton.setTitleColor(.white, for: .normal)
        
        
        redButton.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        blueButton.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        greenButton.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        pinkButton.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        
        
        resultLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
        }
        resultLabel.font = .systemFont(ofSize: 24, weight: .bold)
        resultLabel.textAlignment = .center
        resultLabel.text = "버튼을 클릭하세요"
    }
    
    @objc
    func onClickButton(_ sender: UIButton) {
        switch sender {
        case redButton:
            resultLabel.text = "RedButton Clicked"
        case blueButton:
            resultLabel.text = "BlueButton Clicked"
        case greenButton:
            resultLabel.text = "GreenButton Clicked"
        case pinkButton:
            resultLabel.text = "PinkButton Clicked"
        default:
            break
        }
    }
}
