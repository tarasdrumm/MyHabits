//
//  Configurable.swift
//  MyHabits
//
//  Created by Тарас Андреев on 15.03.2021.
//

protocol Configurable {
    associatedtype Model
    func configure(model: Model)
}
