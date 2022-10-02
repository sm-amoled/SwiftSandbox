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
    @IBOutlet weak var textFieldViewBottomPadding: NSLayoutConstraint!
    
    var scrollViewFrameDefaultSize: CGRect?
    var textFieldViewDefaultHeight: CGFloat?
    
    var _isQuestionListShown: Bool = false
    
    var isQuestionListShown: Bool {
        get {
            return _isQuestionListShown
        }
        set(value) {
            _isQuestionListShown = value
            
            setViewLayout()
        }
    }
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollViewFrameDefaultSize = self.scrollView.frame
        textFieldViewDefaultHeight = textFieldViewHeight.constant
        
        setViewLayout()
    }
    

    @IBAction func tapQuestionListButton(_ sender: UIButton) {
        self.view.endEditing(true)
        isQuestionListShown.toggle()
    }
    
    @IBAction func tapNextButton(_ sender: Any) {
        self.view.endEditing(true)
        setViewLayout()
    }
    
    
    func setViewLayout() {
        if !isKeyboardExpand {
            questionListHeight.constant = CGFloat(50 + (isQuestionListShown ? questionList.count * cellHeight : 0))
            textFieldViewHeight.constant = CGFloat(textFieldViewDefaultHeight!)
            textFieldViewBottomPadding.constant = 45
            self.scrollView.frame = scrollViewFrameDefaultSize!
        } else {
            textFieldViewBottomPadding.constant = 5
        }
        
    }
    
    // MARK: Keyboard
    var isKeyboardExpand: Bool = false
    
    @objc func keyboardAppear(_ notification: Notification) {
        if !isKeyboardExpand {
            isKeyboardExpand = true

            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                
                isQuestionListShown = false
                questionListHeight.constant = 50
                
                textFieldViewHeight.constant = UIScreen.main.bounds.height - keyboardHeight - 120

                self.scrollView.frame = CGRect(origin: CGPoint(x: 0, y: 0),
                                               size: CGSize(width: self.scrollView.frame.width,
                                                            height: UIScreen.main.bounds.height - keyboardHeight))
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height + 100)

                setViewLayout()
            }
            
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height), animated: true)
        }
    }
    
    @objc func keyboardDisappear() {
        if isKeyboardExpand {
            isKeyboardExpand = false
        }
    }
}

