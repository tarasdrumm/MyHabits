//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Тарас Андреев on 06.03.2021.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = " Все получится!"
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var counterLabel: UILabel = {
        let counter = UILabel()
        counter.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        counter.text = "0%"
        counter.textColor = .systemGray
        counter.translatesAutoresizingMaskIntoConstraints = false
        
        return counter
    }()
    
    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.layer.cornerRadius = 4
        progress.trackTintColor = .systemGray2
        progress.progressTintColor = #colorLiteral(red: 0.631372549, green: 0.0862745098, blue: 0.8, alpha: 1)
        progress.translatesAutoresizingMaskIntoConstraints = false
        
        return progress
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(progressView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(counterLabel)
        
        let constraints = [
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            progressView.heightAnchor.constraint(equalToConstant: 7),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -10),
            
            counterLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            counterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - Configurable
extension ProgressCollectionViewCell: Configurable {
    func configure(model: Float) {
        // Установка прогресса
        progressView.setProgress(model, animated: false)
        
        let percentValue = Int(model * 100)
        counterLabel.text = "\(percentValue)%"
    }
    
    typealias Model = Float
}
