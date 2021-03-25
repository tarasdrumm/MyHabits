//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Тарас Андреев on 06.03.2021.
//

import UIKit

protocol HabitCollectionViewCellDelegate: AnyObject {
    func didTapTrackButton(habit: Habit)
}

class HabitCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: HabitCollectionViewCellDelegate?
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        return title
    }()
    
    private lazy var dateLabel: UILabel = {
        let date = UILabel()
        date.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        date.translatesAutoresizingMaskIntoConstraints = false
        
        return date
    }()
    
    private lazy var counterLabel: UILabel = {
        let counter = UILabel()
        counter.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        counter.translatesAutoresizingMaskIntoConstraints = false
        
        return counter
    }()
    
    private lazy var trackButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    /// Привычка, привязанная к конкретной ячейке
    private var habit: Habit!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HabitCollectionViewCell {
    func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(counterLabel)
        contentView.addSubview(trackButton)
        
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            counterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            trackButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 47),
            trackButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -47),
            trackButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            trackButton.heightAnchor.constraint(equalToConstant: 36),
            trackButton.widthAnchor.constraint(equalToConstant: 36)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: Actions
    @objc private func buttonTapped() {
        // Сообщеним делегату о том, что была нажата кнопка трека привычки
        // Делегатом является HabitsViewController
        
        delegate?.didTapTrackButton(habit: habit)
    }
}

    // MARK: - Configurable
extension HabitCollectionViewCell: Configurable {
    
    func configure(model: Habit) {
        self.habit = model
        
        titleLabel.text = model.name
        titleLabel.textColor = model.color
        dateLabel.text = model.dateString
        dateLabel.textColor = .systemGray2
        counterLabel.text = "Подряд: \(model.trackDates.count)"
        counterLabel.textColor = .systemGray
        
        // Установка цвета + Checkmark (если привычка была трекнута сегодня)
        let stateButtonImage = UIImage(named: "checkmark")
        trackButton.setImage(
            model.isAlreadyTakenToday ? stateButtonImage : nil,
            for: .normal
        )
        
        trackButton.layer.borderColor = model.color.cgColor
        trackButton.backgroundColor = model.isAlreadyTakenToday ? model.color : .clear
    }
    
    typealias Model = Habit
}

