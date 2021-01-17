//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import RxSwift
import SwiftyJSON
import UIKit

let MEMBER_LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"

class 나중에생기는데이터<T> {
    private let task: (@escaping (T) -> Void) -> Void
    
    init(task: @escaping (@escaping (T) -> Void) -> Void) {
        self.task = task
    }
    
    func 나중에오면(_ f: @escaping (T) -> Void) {
        task(f)
    }
}

class ViewController: UIViewController {
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var editView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timerLabel.text = "\(Date().timeIntervalSince1970)"
        }
    }

    private func setVisibleWithAnimation(_ v: UIView?, _ s: Bool) {
        guard let v = v else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak v] in
            v?.isHidden = !s
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()
        })
    }
    
    // PromiseKit
    // Bolt
    // RxSwift
    
    func downloadJson(_ url: String) -> Observable<String?> {
        // 1. 비동기로 생기는 데이터를 Observable로 감싸서 리턴하는 방법
        return Observable.create { f in
            DispatchQueue.global().async {
                let url = URL(string: url)!
                let data = try! Data(contentsOf: url)
                let json = String(data: data, encoding: .utf8)
                
                DispatchQueue.main.async {
                    f.onNext(json)
                    f.onCompleted() // 순환 참조 문제 해결
                }
            }
            return Disposables.create()
        }
    }
    
    // MARK: SYNC
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func onLoad() {
        editView.text = ""
        setVisibleWithAnimation(activityIndicator, true)
        
        // 2. Observable로 오는 데이터를 받아서 처리하는 방법
        // let disposable =
        downloadJson(MEMBER_LIST_URL)
            .subscribe { event in
                switch event {
                case let .next(json):
                    self.editView.text = json
                    self.setVisibleWithAnimation(self.activityIndicator, false)
                case .completed:
                    break
                case .error(_):
                    break
                }
            }
//        disposable.dispose()
    }
}
