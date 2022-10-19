//
//  DetailViewController.swift
//  PracticeRX
//
//  Created by Park Sungmin on 2022/10/17.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var job: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var id: UILabel!
    
    var data: Member!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    func setData() {
        loadImage(from: data.avatar)
            .observe(on: MainScheduler.instance)
            .bind(to: avatar.rx.image)
            .disposed(by: disposeBag)
        
        avatar.image = nil
        age.text = "(\(data.age))"
        job.text = data.job
        name.text = data.name
        id.text = "#\(data.id)"
    }
    
    func loadImage(from url: String)-> Observable<UIImage?> {
        return Observable.create { emitter in
            let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                
                guard let data = data,
                      let image = UIImage(data: data) else {
                    emitter.onNext(nil)
                    emitter.onCompleted()
                    return
                }
                
                emitter.onNext(image)
                emitter.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
