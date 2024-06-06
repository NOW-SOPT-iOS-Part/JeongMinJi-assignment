//
//  ViewModel+.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 5/10/24.
//

import Foundation

@MainActor
protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
