//
//  NSObject+ClassName.swift
//  MyHabits
//
//  Created by Тарас Андреев on 06.03.2021.
//

import Foundation

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
}
