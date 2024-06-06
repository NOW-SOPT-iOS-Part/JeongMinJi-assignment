//
//  PrivacyInfoManager.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 5/10/24.
//

import Foundation

enum PrivacyInfoKeys {

    static let baseURL = "BaseURL"
    static let moviekey = "MovieKey"
}

final class PrivacyInfoManager {
    
    static let shared = PrivacyInfoManager()
    
    class var baseURL: String {
        guard let url = shared.info[PrivacyInfoKeys.baseURL] else { fatalError("BaseURL: Base-Info Plist error")}
        return url
    }
    
    class var moviekey: String {
        guard let key = shared.info[PrivacyInfoKeys.moviekey] else { fatalError("MovieKey: Base-Info Plist error")}
        return key
    }
    
    private var info: [String: String] {
        guard let plistPath = Bundle.main.path(forResource: "PrivacyInfo", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: plistPath) as? [String: String] else {
            return [:]
        }
        return plist
    }
}
