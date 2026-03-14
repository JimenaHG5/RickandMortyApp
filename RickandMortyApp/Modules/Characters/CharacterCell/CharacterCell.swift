import UIKit

protocol CharacterCellDelegate: AnyObject {
    func didTapFavorite(character: Character)
}

final class CharacterCell: UITableViewCell {
    
    static let identifier = "CharacterCell"
    
    weak var delegate: CharacterCellDelegate?
    private var character: Character?
    
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "RMCard") ?? UIColor(white: 0.13, alpha: 1)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.layer.cornerRadius = 14
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private let statusIndicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(white: 0.92, alpha: 1)
        return label
    }()
    
    private let speciesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(white: 0.75, alpha: 1)
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        button.layer.cornerRadius = 20
        return button
    }()
    
    private let textStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private let statusRowStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cardView)
        cardView.addSubview(characterImageView)
        cardView.addSubview(favoriteButton)
        cardView.addSubview(textStack)
        
        statusRowStack.addArrangedSubview(statusIndicator)
        statusRowStack.addArrangedSubview(statusLabel)
        
        textStack.addArrangedSubview(nameLabel)
        textStack.addArrangedSubview(statusRowStack)
        textStack.addArrangedSubview(speciesLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            characterImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            characterImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            characterImageView.widthAnchor.constraint(equalToConstant: 85),
            characterImageView.heightAnchor.constraint(equalToConstant: 85),

            favoriteButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            favoriteButton.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40),

            textStack.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -12),
            textStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),

            statusIndicator.widthAnchor.constraint(equalToConstant: 8),
            statusIndicator.heightAnchor.constraint(equalToConstant: 8),

            cardView.bottomAnchor.constraint(greaterThanOrEqualTo: characterImageView.bottomAnchor, constant: 12),
            cardView.bottomAnchor.constraint(greaterThanOrEqualTo: textStack.bottomAnchor, constant: 16)
        ])
    }

    
    private func setupActions() {
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func favoriteButtonTapped() {
        guard let character else { return }
        delegate?.didTapFavorite(character: character)
    }
    
    func configure(with character: Character, isFavorite: Bool) {
        self.character = character
        
        nameLabel.text = character.name
        statusLabel.text = character.status.displayText.capitalized
        speciesLabel.text = character.species
        speciesLabel.isHidden = false
        statusIndicator.backgroundColor = character.status.color
        
        updateFavoriteButton(isFavorite: isFavorite)
        loadImage(from: character.image)
    }
    
    private func updateFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        let image = UIImage(systemName: imageName, withConfiguration: config)
        
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.tintColor = isFavorite
            ? .systemPink
            : (UIColor(named: "RMGreen") ?? .systemGreen)
        
        favoriteButton.backgroundColor = isFavorite
            ? UIColor.systemPink.withAlphaComponent(0.1)
            : UIColor.white.withAlphaComponent(0.08)
    }
    
    private func loadImage(from urlString: String) {
        characterImageView.image = UIImage(systemName: "person.crop.square")
        characterImageView.tintColor = .systemGray3
        
        ImageCache.shared.load(urlString: urlString) { [weak self] image in
            self?.characterImageView.image = image
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        character = nil
        characterImageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
        speciesLabel.text = nil
        favoriteButton.backgroundColor = UIColor.white.withAlphaComponent(0.08)
    }
}

