//
//  ViewController.swift
//  MC1_DiaryView
//
//  Created by Park Sungmin on 2022/09/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func navigationButton(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let selectQuestionVC = storyBoard.instantiateViewController(withIdentifier: "SelectQuestionView") as! SelectQuestionViewController
        
        self.navigationController?.pushViewController(selectQuestionVC, animated: true)
        
    }
}

