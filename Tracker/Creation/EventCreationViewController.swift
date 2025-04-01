import UIKit

final class EventCreationViewController: UIViewController {

    // MARK: - Public Properties
    weak var delegate: CreationDelegate?

    // MARK: - Private Properties
    private var category: TrackerCategory? = TrackerCategory(name: "Домашний уют", trackers: [])
    private var emoji:Character? = "😄"
    private var color: UIColor? = .selection16

    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypGray
        button.isEnabled = false
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        button.layer.cornerRadius = 16
        view.addSubview(button)
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let color: UIColor = .ypRed
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(color, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = color.cgColor
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()

    private lazy var trackerNameTextField: UITextField = {
        let textField = PaddedTextField()
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = .ypBackground
        textField.layer.cornerRadius = 16
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.addSubview(textField)
        return textField
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.layer.cornerRadius = 16
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.isScrollEnabled = false

        return tableView
    }()

    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        navigationController?.navigationBar.tintColor = .ypBlack
        navigationItem.title = "Новое нерегулярное событие"
        setupConstraints()
    }

    // MARK: - Private Methods
    private func createButtonAvailabilityCheck() {
        if trackerNameTextField.hasText && category != nil {
            createButton.isEnabled = true
            createButton.backgroundColor = .ypBlack
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = .ypGray
        }
    }

    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        trackerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            trackerNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),

            tableView.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 75),

            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 60),

            cancelButton.widthAnchor.constraint(equalTo: createButton.widthAnchor)

        ])
    }

    @objc private func cancelTapped() {
        self.dismiss(animated: true)
    }

    @objc private func createTapped() {
        guard
            let category,
            let emoji,
            let color,
            let name = trackerNameTextField.text,
            !name.isEmpty
        else {
            self.dismiss(animated: true)
            return
        }

        delegate?.didCreateEvent(name: name, category: category, emoji: emoji, color: color)
        presentingViewController?.presentingViewController?.dismiss(animated: true)
    }

    @objc private func textFieldDidChange() {
        createButtonAvailabilityCheck()
    }
}

// MARK: - UITableView
extension EventCreationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")

        cell.textLabel?.text = "Категория"
        cell.detailTextLabel?.text = category?.name ?? ""

        cell.detailTextLabel?.textColor = .ypGray
        cell.textLabel?.textColor = .ypBlack
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)

        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .ypBackground
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Реализовать переход к экрану выбора категорий
    }
}
