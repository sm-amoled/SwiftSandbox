//
//  SelectQuestionView.swift
//  MC1_DiaryView
//
//  Created by Park Sungmin on 2022/09/20.
//

import UIKit

class SelectQuestionViewController: UIViewController {

    @IBOutlet weak var questionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func tapNextButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let writeDiaryVC = storyBoard.instantiateViewController(withIdentifier: "WriteDiaryView") as! WriteDiaryViewController
        
        self.navigationController?.pushViewController(writeDiaryVC, animated: true)
        
    }
}
