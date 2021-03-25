//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Тарас Андреев on 21.02.2021.
//

import UIKit

protocol HabitViewControllerDelegate: AnyObject {
    func didDeleteHabit()
}

enum HabitViewControllerMode {
    case create
    case change(habit: Habit)
}

final class HabitViewController: UIViewController {
    
    // MARK: Dependencies
    
    weak var delegate: HabitViewControllerDelegate?
    
    /// Если change -> показать кнопку удалить, если create - скрыть
    
    var mode = HabitViewControllerMode.create
    
    // MARK: Subviews
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.text = "НАЗВАНИЕ"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var colorLabel: UILabel = {
        let color = UILabel()
        color.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        color.textColor = .black
        color.text = "ЦВЕТ"
        color.translatesAutoresizingMaskIntoConstraints = false
        
        return color
    }()
    
    private lazy var colorButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = habitColor
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(selectColorButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var timeLabel: UILabel = {
        let time = UILabel()
        time.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        time.textColor = .black
        time.text = "ВРЕМЯ"
        time.translatesAutoresizingMaskIntoConstraints = false
        
        return time
    }()
    
    private lazy var habitLabel: UILabel = {
        let habit = UILabel()
        habit.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        habit.text = "Каждый день в"
        habit.translatesAutoresizingMaskIntoConstraints = false
        
        return habit
    }()
    
    private lazy var timeField: UITextField = {
        let timeField = UITextField()
        timeField.textColor = #colorLiteral(red: 0.631372549, green: 0.0862745098, blue: 0.8, alpha: 1)
        timeField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        timeField.translatesAutoresizingMaskIntoConstraints = false
        
        return timeField
    }()
    
    private lazy var timePicker: UIDatePicker = {
        var picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.backgroundColor = .white
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setTitle("Удалить привычку", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        return deleteButton
    }()
    
    private var habitTitle: String?
    private var habitDate: Date?
    private var habitColor: UIColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0.3098039216, alpha: 1)
    
    // MARK: Life cycle
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupObservers()
        setupSubviews()
        setupControllerMode()
        timePickerValueChanged()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = contentView.bounds.size
    }
    
    // MARK: Convenience

    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setupNavigationBar() {
       
        title = "Создать"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Отменить",
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Сохранить",
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
    }
    
    private func setupSubviews() {
        
        timePicker.addTarget(
            self,
            action: #selector(timePickerValueChanged),
            for: .valueChanged
        )
        titleTextField.addTarget(
            self,
            action: #selector(textfieldEdittingChanged),
            for: .editingChanged
        )
        
        view.backgroundColor = .white
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(titleTextField)
        contentView.addSubview(colorLabel)
        contentView.addSubview(colorButton)
        contentView.addSubview(timeLabel)
        contentView.addSubview(habitLabel)
        contentView.addSubview(timeField)
        contentView.addSubview(timePicker)
        
        
        NSLayoutConstraint.activate(
            [
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
                nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                titleTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7),
                titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

                colorLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 15),
                colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                colorLabel.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

                colorButton.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 7),
                colorButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                colorButton.heightAnchor.constraint(equalToConstant: 30),
                colorButton.widthAnchor.constraint(equalToConstant: 30),

                timeLabel.topAnchor.constraint(equalTo: colorButton.bottomAnchor, constant: 15),
                timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

                habitLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 7),
                habitLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

                timeField.leadingAnchor.constraint(equalTo: habitLabel.trailingAnchor, constant: 5),
                timeField.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 6),
                timeField.widthAnchor.constraint(equalToConstant: 100),

                timePicker.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                timePicker.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                timePicker.topAnchor.constraint(equalTo: timeField.bottomAnchor, constant: 15)
            ]
        )
    }
    
    private func setupControllerMode() {
        
        switch mode {
        case .create:
            break
        case let .change(habit):
            
            // 1) Отобразить привычку
            
            setupHabit(habit: habit)
            
            // 2) добавили кнопку удалить
            
            view.addSubview(deleteButton)
            NSLayoutConstraint.activate(
                [
                    deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
                    deleteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
                ]
            )
        }
    }
    
    private func setupHabit(habit: Habit) {
        
        // 1) Отобрразить на экране (присвоить лейблам)
        
        timePicker.setDate(habit.date, animated: true)
        titleTextField.text = habit.name
        colorButton.backgroundColor = habit.color
        
        // 2) Сохранил переменные
        
        habitDate = habit.date
        habitTitle = habit.name
        habitColor = habit.color
    }
    
    private func showError(message: String) {
        
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Action
    // Keyboard

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }
        
        let keyboardHeight = keyboardEndFrame.cgRectValue.height
        scrollView.contentInset.bottom += keyboardHeight
        scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: keyboardHeight,
            right: 0
        )
    }
    
    @objc private func keyboardWillHide() {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
    
    // Textfield
    
    @objc private func textfieldEdittingChanged() {
        habitTitle = titleTextField.text
    }
    
    // TimePicker
    
    @objc private func timePickerValueChanged() {
        let timeString = DateHelper.string(date: timePicker.date, with: "HH:mm a")
        timeField.text = timeString
        habitDate = timePicker.date
    }
    
    // Buttons
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        
        guard let habitTitle = habitTitle else {
            showError(message: "Введи название привычки")
            return
        }
        
        guard let habitDate = habitDate else {
            showError(message: "Выбери время привычки")
            return
        }
        
        switch mode {
        case .create:
            let newHabit = Habit(name: habitTitle, date: habitDate, color: habitColor)
            HabitsStore.shared.habits.append(newHabit)
        case let .change(habit):
            guard let editingHabit = HabitsStore.shared.habits.first(where: { $0 == habit }) else {
                showError(message: "Привычка не найдена")
                return
            }
            
            editingHabit.color = habitColor
            editingHabit.name = habitTitle
            editingHabit.date = habitDate
            
            NotificationCenter.default.post(Notification(name: HabitsStore.didUpdateNotificationName))
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func deleteButtonTapped() {
        
        let alertController = UIAlertController(title: "Вы хотите удалить привычку?", message: habitTitle, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in
            print("Отмена")
        }
        alertController.addAction(cancelAction)
    
        let deleteAction = UIAlertAction(title: "Удалить", style: .default) { [self] _ in
            switch mode {
            case .create:
                break
            case let .change(habit):
                guard let index = HabitsStore.shared.habits.firstIndex(of: habit) else {
                    return
                }
                
                HabitsStore.shared.habits.remove(at: index)
                self.delegate?.didDeleteHabit()
                
                dismiss(animated: true, completion: nil)
            }
        }
        
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func selectColorButtonTapped() {
        let colorPickerViewController = UIColorPickerViewController()
        colorPickerViewController.delegate = self
        present(colorPickerViewController, animated: true, completion: nil)
    }
}

// MARK: - UIColorPickerViewControllerDelegate
extension HabitViewController: UIColorPickerViewControllerDelegate {

    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        habitColor = viewController.selectedColor
        colorButton.backgroundColor = habitColor
    }
}


    
    
    

