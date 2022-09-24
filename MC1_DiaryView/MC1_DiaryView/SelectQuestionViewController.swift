//
//  SelectQuestionView.swift
//  MC1_DiaryView
//
//  Created by Park Sungmin on 2022/09/20.
//

import UIKit

class SelectQuestionViewController: UIViewController {

    @IBOutlet weak var questionTableView: UITableView!
    
    var questionList: [QuestionModel] = []
    var selectedQuestionList: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setQuestionList()
    }


    @IBAction func tapNextButton(_ sender: Any) {
        guard let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) as? UIStoryboard else { return }
        guard let writeDiaryVC = storyBoard.instantiateViewController(withIdentifier: "WriteDiaryView") as? WriteDiaryViewController else { return }
        
        writeDiaryVC.questionList = getSelectedQuestionList()
        
        self.navigationController?.pushViewController(writeDiaryVC, animated: true)
        
    }
    
    func setQuestionList() {
        questionList = QuestionModel.dummyQuestion
        selectedQuestionList = Array(repeating: false, count: questionList.count)
    }
    
    func getSelectedQuestionList() -> [QuestionModel] {
        var result: [QuestionModel] = []
        
        for (index, isSelected) in selectedQuestionList.enumerated() {
            if isSelected {
                result.append(questionList[index])
            }
        }
        
        return result
    }
}
