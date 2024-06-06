//
//  DateUtils.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 6/7/24.
//

import Foundation

final class DateUtils {
    static func yesterdayDateFormattedKST() -> Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? calendar.timeZone

        let currentDate = Date()
        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: currentDate) else { return 0 }

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = calendar.timeZone
        dateFormatter.dateFormat = "yyyyMMdd"

        return Int(dateFormatter.string(from: yesterday)) ?? 0
    }
}
