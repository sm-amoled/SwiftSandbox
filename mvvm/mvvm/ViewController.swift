//
//  ViewController.swift
//  mvvm
//
//  Created by Park Sungmin on 2022/10/15.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {    
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBAction func tapYesterday(_ sender: Any) {
        viewModel.moveDay(day: -1)
    }
    
    @IBAction func tapToday(_ sender: Any) {
        dateTimeLabel.text = "Loading..."
         viewModel.reload()
    }

    @IBAction func tapTomorrow(_ sender: Any) {
        viewModel.moveDay(day: 1)
    }

    let viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        viewModel.onUpdated = { [weak self] in
//            DispatchQueue.main.async {
//                self?.dateTimeLabel.text = self?.viewModel.dateTimeString
//            }
//        }
        
        viewModel.dateTimeString
            .bind(to: dateTimeLabel.rx.text)
//            .observe(on: MainScheduler.instance)
//            .subscribe { str in
//                self.dateTimeLabel.text = str
//            }
            .disposed(by: disposeBag)
        
        viewModel.reload()
    }
}

