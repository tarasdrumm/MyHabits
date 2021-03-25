//
//  HabitDetailsViewController.swift
//  MyHabits
//1
//  Created by Тарас Андреев on 14.03.2021.
//

import UIKit

final class HabitDetailsViewController: UIViewController {

    // MARK: Public properties
    
    var habit: Habit!
    
    // MARK: Subviews

    private let cellID = "cellID"
    private let tableView = UITableView(frame: .zero, style: .grouped)

    // MARK: Private properties
    
    private var viewModel: [Date] {
        HabitsStore.shared.dates.reversed()
    }
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = habit.name
        setupLayout()
        setupTableView()
        setupNavigationBar()
    }
    
    // MARK: Drawing
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }

    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Править",
            style: .plain,
            target: self,
            action: #selector(editButtonTapped)
        )
    }

    private func setupLayout() {
        view.addSubview(tableView)

        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: Actions

    @objc private func editButtonTapped() {
        let changeHabitViewController = HabitViewController()
        changeHabitViewController.mode = .change(habit: habit)
        changeHabitViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: changeHabitViewController)
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - HabitDetailsViewController
extension HabitDetailsViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let date = viewModel[indexPath.row]
     
        // Убрать выделение при нажатии
        cell.selectionStyle = .none
        
        // Checkmark
        cell.accessoryType = HabitsStore.shared.habit(habit, isTrackedIn: date) ? .checkmark : .none
        cell.tintColor = #colorLiteral(red: 0.631372549, green: 0.0862745098, blue: 0.8, alpha: 1)
        
        // Установка даты
        cell.textLabel?.text = DateHelper.relative(date: date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "АКТИВНОСТЬ"
        default:
            return nil
        }
    }
}

extension HabitDetailsViewController: HabitViewControllerDelegate {
    func didDeleteHabit() {
        navigationController?.popToRootViewController(animated: true)
    }
}

