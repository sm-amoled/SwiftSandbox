//
//  WriteDiaryViewController.swift
//  MC1_DiaryView
//
//  Created by Park Sungmin on 2022/09/21.
//

import UIKit

class WriteDiaryViewController: ViewController {

    var questionList: [QuestionModel] = []
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var questionListHeight: NSLayoutConstraint!
    @IBOutlet weak var textFieldViewHeight: NSLayoutConstraint!
    @IBOutlet weak var questionLabelTableView: UITableView!
    
    var isQuestionListShown = true
    
    let cellHeight: Int = 35
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        questionListHeight.constant = CGFloat(50 + (isQuestionListShown ? questionList.count * cellHeight : 0))
    }
    

    @IBAction func tapQuestionListButton(_ sender: UIButton) {
        isQuestionListShown.toggle()
        questionListHeight.constant = CGFloat(50 + (isQuestionListShown ? questionList.count * cellHeight : 0))
    }
    
    @IBAction func tapNextButton(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    var isKeyboardExpand: Bool = false
    
    @objc func keyboardAppear(_ notification: Notification) {
        if !isKeyboardExpand {
            
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height + 100)
                
                isQuestionListShown = false
                questionListHeight.constant = 50
                
                textFieldViewHeight.constant = UIScreen.main.bounds.height - keyboardHeight - 100
            }
            
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height), animated: true)
            
            isKeyboardExpand = true
        }
    }
    
    @objc func keyboardDisappear() {
        if isKeyboardExpand {
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height - 100)
            isKeyboardExpand = false
            
            textFieldViewHeight.constant = self.view.frame.height - CGFloat((185 + 35*questionList.count))
        }
    }
}

