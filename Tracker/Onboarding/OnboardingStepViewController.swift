import UIKit

final class OnboardingStepViewController: UIViewController {

    // MARK: - Private Properties
    private var background = UIImageView()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()

    }

    // MARK: - Public Methods
    func setup(with backgroundImage: UIImage, title: String) {
        self.background.image = backgroundImage
        self.titleLabel.text = title
    }

    // MARK: - Private Methods
    private func setupSubviews() {
        view.addSubview(background)
        view.addSubview(titleLabel)
    }

    private func setupConstraints() {
        background.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270)
        ])
    }

}
