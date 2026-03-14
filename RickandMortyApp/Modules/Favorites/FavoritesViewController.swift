import UIKit

final class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: FavoritesViewModel
    
    // MARK: - UI
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "RMBackground") ?? .black
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        return tableView
    }()
    
    private let emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.configure(
            image: UIImage(systemName: "heart.slash"),
            title: "Sin favoritos",
            subtitle: "Agrega personajes a favoritos para verlos aquí sin conexión"
        )
        return view
    }()
    
    // MARK: - Init
    
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favoritos"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = UIColor(named: "RMBackground") ?? .black
        
        setupTableView()
        setupLayout()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        viewModel.fetchFavorites()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.identifier)
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.onFavoritesUpdated = { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
            self.updateEmptyState()
        }
    }
    
    private func updateEmptyState() {
        if viewModel.favorites.isEmpty {
            emptyStateView.frame = tableView.bounds
            tableView.backgroundView = emptyStateView
        } else {
            tableView.backgroundView = nil
        }
    }
}

// MARK: - UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CharacterCell.identifier,
            for: indexPath
        ) as? CharacterCell else {
            return UITableViewCell()
        }
        
        let favorite = viewModel.favorites[indexPath.row]
        let character = Character(
            id: Int(favorite.id),
            name: favorite.name ?? "",
            status: Character.Status(rawValue: favorite.status ?? "") ?? .unknown,
            species: favorite.species ?? "",
            type: "",
            gender: Character.Gender(rawValue: favorite.gender ?? "") ?? .unknown,
            origin: Location(name: favorite.originName ?? "", url: ""),
            location: Location(name: favorite.locationName ?? "", url: ""),
            image: favorite.imageURL ?? "",
            episode: [],
            url: "",
            created: ""
        )
        
        cell.configure(with: character, isFavorite: true)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let favorite = viewModel.favorites[indexPath.row]
        viewModel.showDetail(favorite: favorite)
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            let favorite = viewModel.favorites[indexPath.row]
            viewModel.removeFavorite(id: Int(favorite.id))
        }
    }
}

// MARK: - CharacterCellDelegate

extension FavoritesViewController: CharacterCellDelegate {
    
    func didTapFavorite(character: Character) {
        viewModel.removeFavorite(id: character.id)
    }
}

