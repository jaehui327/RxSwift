//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by JHKim on 2021/01/17.
//  Copyright © 2021 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift

class MenuListViewModel {
    
    var menus: [Menu] = [
        Menu(name: "튀김1", price: 100, count: 0),
        Menu(name: "튀김1", price: 100, count: 0),
        Menu(name: "튀김1", price: 100, count: 0),
        Menu(name: "튀김1", price: 100, count: 0)
    ]
    
    lazy var menuObsevable = Observable.just(menus)
    
    var itemsCount: Int = 5
    var totalPrice: PublishSubject<Int> = PublishSubject()
    
    // Subject
    
}
