//
//  WriteDiaryViewController.swift
//  MC1_DiaryView
//
//  Created by Park Sungmin on 2022/09/21.
//

import UIKit

class WriteDiaryViewController: ViewController {

    var questionList: [QuestionModel] = []
    
    @IBOutlet weak var questionListHeight: NSLayoutConstraint!
    @IBOutlet weak var questionLabelTableView: UITableView!
    
    var isQuestionListShown = true
    
    let cellHeight: Int = 35
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        questionListHeight.constant = CGFloat(50 + (isQuestionListShown ? questionList.count * cellHeight : 0))
    }
    

    @IBAction func tapQuestionListButton(_ sender: UIButton) {
        isQuestionListShown.toggle()
        questionListHeight.constant = CGFloat(50 + (isQuestionListShown ? questionList.count * cellHeight : 0))
    }
}

