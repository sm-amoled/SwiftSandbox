//
//  ViewController.swift
//  PracticeRX
//
//  Created by Park Sungmin on 2022/10/17.
//

import UIKit
import RxCocoa
import RxSwift

let MEMBER_LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"

struct Member: Decodable {
    let id: Int
    let name: String
    let avatar: String
    let job: String
    let age: Int
}

class ViewController: UIViewController {

    var data: [Member] = []
    var disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadMembers()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] members in
                self?.data = members
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    // 나중에 생길 데이터로 [Member]을 반환하는 함수 loadMembers()
    func loadMembers() -> Observable<[Member]> {
        // Observable.create {} 로 observable 생성
        return Observable.create { emitter in
            // task 작성
            // task 는 URL을 통해 데이터를 불러오는 것
            let task = URLSession.shared.dataTask(with: URL(string: MEMBER_LIST_URL)!) { data, _, error in
                // 만약 에러가 발생했다면
                if let error = error {
                    // emitter는 에러를 넘기고 completion 종료
                    emitter.onError(error)
                    return
                }
                
                // 데이터를 정상적으로 들고온 경우에
                guard let data = data,
                // 멤버 데이터를 JSON으로 정상적으로 파싱하지 못했다면
                      let members = try? JSONDecoder().decode([Member].self, from: data) else {
                    // Complete 하고 종료
                    emitter.onCompleted()
                    return
                }
                
                // 데이터를 next로 넘기고 종료
                emitter.onNext(members)
                emitter.onCompleted()
            }
            
            // 앞서 정의한 task를 수행하기
            task.resume()
        
            
            // Observable을 dispose한 경우, task를 취소해버리기
            return Disposables.create {
                task.cancel()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier,
            id == "DetailViewController",
            let detailVC = segue.destination as? DetailViewController,
            let data = sender as? Member else {
            return
        }
        detailVC.data = data
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberTableViewCell", for: indexPath) as! MemberTableViewCell
        let item = data[indexPath.row]
        cell.setData(item)
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        performSegue(withIdentifier: "DetailViewController", sender: item)

    }
}


class MemberTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var job: UILabel!
    
    var disposeBag = DisposeBag()
    
    func setData(_ data: Member) {
        loadImage(from: data.avatar)
            .observe(on: MainScheduler.instance)
            .bind(to: avatar.rx.image)
            .disposed(by: disposeBag)
        avatar.image = nil
        name.text = data.name
        age.text = "(\(data.age))"
        job.text = data.job
    }
    
    func loadImage(from url: String) -> Observable<UIImage?> {
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
