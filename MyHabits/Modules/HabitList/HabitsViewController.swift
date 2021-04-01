//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Тарас Андреев on 17.02.2021.
//

import UIKit

class HabitsViewController: UIViewController {

    @IBOutlet weak var addButton: UIBarButtonItem!
    
    private lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(scrollDirection: .vertical)
        collectionView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.className)
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.className)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
        
    }()
    
    private var viewModel: [Habit] {
        return HabitsStore.shared.habits
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        setupNavigationBar()
        setupViews()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didHandleStoreUpdatedNotification),
            name: HabitsStore.didUpdateNotificationName,
            object: nil
        )
    }
    
    private func setupNavigationBar() {
        
        navigationController?.navigationBar.isHidden = false
        title = "Привычки"
        self.navigationItem.title = "Сегодня"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
        
    // MARK: Actions
    
    @objc private func didHandleStoreUpdatedNotification() {
        collectionView.reloadData()
    }
        
    @objc private func buttonTapped() {
        performSegue(withIdentifier: HabitViewController.className, sender: nil)
    }
}

extension HabitsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let progressItem = 1
        
        return viewModel.count + progressItem
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier: String = indexPath.item == 0 ? ProgressCollectionViewCell.className : HabitCollectionViewCell.className
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        if indexPath.item == 0 {
            let cellModel: ProgressCollectionViewCell.Model = HabitsStore.shared.todayProgress
            (cell as? ProgressCollectionViewCell)?.configure(model: cellModel)
        } else {
            let cellModel: HabitCollectionViewCell.Model = viewModel[indexPath.item - 1]
            (cell as? HabitCollectionViewCell)?.configure(model: cellModel)
            (cell as? HabitCollectionViewCell)?.delegate = self
        }
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 12
    
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HabitsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item != 0 else {
            return
        }
        
        let habit = viewModel[indexPath.item - 1]
        let habitDetailsViewController = HabitDetailsViewController()
        habitDetailsViewController.habit = habit
        navigationController?.pushViewController(habitDetailsViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = collectionView.frame.size.width - 16 * 2
        let height: CGFloat = indexPath.item == 0 ? 60 : 130
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return section == 0 ? 18 : 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 22, left: 16, bottom: 22, right: 16)
    }
}

// MARK: - HabitCollectionViewCellDelegate
extension HabitsViewController: HabitCollectionViewCellDelegate {
    
    func didTapTrackButton(habit: Habit) {
        guard !habit.isAlreadyTakenToday else {
            return
        }
        
        HabitsStore.shared.track(habit)
        collectionView.reloadData()
    }
}
