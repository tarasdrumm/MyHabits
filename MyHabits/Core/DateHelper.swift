//
//  DateHelper.swift
//  MyHabits
//
//  Created by Loginov Anton on 21.03.2021.
//

import Foundation

final class DateHelper {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru-RU")
        return formatter
    }()
    
    static func relative(date: Date) -> String {
        DateHelper.dateFormatter.doesRelativeDateFormatting = true
        DateHelper.dateFormatter.dateStyle = .long
        return DateHelper.dateFormatter.string(from: date)
    }
    
    static func string(date: Date, with dateFormat: String) -> String {
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
}
