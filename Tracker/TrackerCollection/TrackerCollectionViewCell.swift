import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    static let identifier = "TrackerCollectionViewCell"
    
    // MARK: - Public Properties
    weak var delegate: TrackerCollectionViewCellDelegate?
    
    // MARK: - Private Properties
    private(set) var trackerID:UUID?
    
    private lazy var quantityView: UIView = {
        var view = UIView()
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var plusButton: UIButton = {
        let plusImage = UIImage(named: "plus") ?? UIImage()
        let button = UIButton.systemButton(with: plusImage, target: self, action: #selector(onButtonTapped))
        button.tintColor = .ypWhite
        button.layer.cornerRadius = 17
        quantityView.addSubview(button)
        return button
    }()
    
    private lazy var cardView: UIView = {
        let view = UIView()
        let color: UIColor = .ypBorder
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = color.cgColor
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .ypEmojiBackground
        cardView.addSubview(view)
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        circleView.addSubview(label)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypWhite
        label.numberOfLines = 2
        label.baselineAdjustment = .alignBaselines
        cardView.addSubview(label)
        return label
    }()
    
    private lazy var daysLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        quantityView.addSubview(label)
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.translatesAutoresizingMaskIntoConstraints = false
        quantityView.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        circleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            circleView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            circleView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            circleView.heightAnchor.constraint(equalToConstant: 24),
            circleView.widthAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            emojiLabel.leadingAnchor.constraint(greaterThanOrEqualTo: circleView.leadingAnchor, constant: 2),
            emojiLabel.trailingAnchor.constraint(lessThanOrEqualTo: circleView.trailingAnchor, constant: -2),
            emojiLabel.topAnchor.constraint(greaterThanOrEqualTo: circleView.topAnchor, constant: 2),
            emojiLabel.bottomAnchor.constraint(lessThanOrEqualTo: circleView.bottomAnchor, constant: -2),
            
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor,constant: -12),
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: cardView.topAnchor, constant: 44),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            quantityView.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            quantityView.bottomAnchor.constraint(equalTo: bottomAnchor),
            quantityView.leadingAnchor.constraint(equalTo: leadingAnchor),
            quantityView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            daysLabel.leadingAnchor.constraint(equalTo: quantityView.leadingAnchor,constant: 12),
            daysLabel.topAnchor.constraint(equalTo: quantityView.topAnchor,constant: 16),
            daysLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: 8),
            daysLabel.bottomAnchor.constraint(equalTo: quantityView.bottomAnchor, constant: -24),
            
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.trailingAnchor.constraint(equalTo: quantityView.trailingAnchor,constant: -12),
            plusButton.topAnchor.constraint(equalTo: quantityView.topAnchor, constant: 8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setupCell(name: String, color: UIColor, emoji: Character, days: Int,trackerID: UUID, isCompletedToday: Bool) {
        plusButton.backgroundColor = color
        cardView.backgroundColor = color
        titleLabel.text = name
        emojiLabel.text = String(emoji)
        self.trackerID = trackerID
        daysLabel.text = days.days()
        updateCompletionStatus(isCompletedToday: isCompletedToday)
    }
    
    func updateDays(days: Int, isAddition: Bool) {
        daysLabel.text = days.days()
        
        updateCompletionStatus(isCompletedToday: isAddition)
    }
    
    // MARK: - Private Methods
    private func updateCompletionStatus(isCompletedToday: Bool) {
        if isCompletedToday {
            plusButton.setImage(UIImage(named: "done"), for: .normal)
            plusButton.alpha = 0.3
        }
        else {
            plusButton.setImage(UIImage(named: "plus"), for: .normal)
            plusButton.alpha = 1
        }
    }
    
    @objc
    private func onButtonTapped() {
        delegate?.updateQuantity(cell: self)
    }
}
