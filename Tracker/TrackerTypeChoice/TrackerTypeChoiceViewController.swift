import UIKit

final class TrackerTypeChoiceViewController: UIViewController {

    // MARK: - Public Properties
    weak var delegate: CreationDelegate?

    // MARK: - Private Properties
    private var buttonsView = UIView()

    private lazy var habitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.TypeChoice.habit, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.tintColor = .ypWhite
        button.addTarget(self, action: #selector(didTapHabitButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var eventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.TypeChoice.irregular, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.tintColor = .ypWhite
        button.addTarget(self, action: #selector(didTapEventButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setupConstraints()
        navigationController?.navigationBar.tintColor = .ypBlack
        navigationItem.title = L10n.TypeChoice.title
    }

    // MARK: - Private Methods
    private func setupSubviews() {
        view.backgroundColor = .ypWhite
        view.addSubview(buttonsView)
        buttonsView.addSubview(habitButton)
        buttonsView.addSubview(eventButton)
    }

    private func setupConstraints() {
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            habitButton.topAnchor.constraint(equalTo: buttonsView.topAnchor),
            habitButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor),
            habitButton.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor),
            habitButton.heightAnchor.constraint(equalToConstant: 60),

            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor,constant: 16),
            eventButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor),
            eventButton.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor),
            eventButton.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            eventButton.heightAnchor.constraint(equalToConstant: 60),

            buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }

    private func present(viewController: UIViewController) {
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .formSheet
        present(navController, animated: true)
    }

    @objc
    private func didTapHabitButton() {
        guard let delegate = self.delegate else { return }

        let viewController = TrackerCreationViewController()
        viewController.delegate = delegate
        present(viewController: viewController)
    }

    @objc
    private func didTapEventButton() {
        guard let delegate = self.delegate else { return }

        let viewController = EventCreationViewController()
        viewController.delegate = delegate
        present(viewController: viewController)
    }
}
