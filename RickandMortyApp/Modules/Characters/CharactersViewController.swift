import UIKit

final class CharactersViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: CharactersViewModel
    
    // MARK: - UI
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "RMBackground") ?? .black
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        return tableView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Buscar personaje"
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        return searchBar
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = UIColor(named: "RMGreen") ?? .systemGreen
        return indicator
    }()
    
    private let headerContainer = UIView()
    
    // MARK: - Init
    
    init(viewModel: CharactersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Personajes"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = UIColor(named: "RMBackground") ?? .black
        
        setupTableView()
        setupLayout()
        setupTableHeader()
        setupTableFooter()
        setupBindings()
        
        searchBar.delegate = self
        viewModel.fetchCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableHeaderLayout()
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
    
    private func setupTableHeader() {
        headerContainer.backgroundColor = UIColor(named: "RMBackground") ?? .black
        headerContainer.addSubview(searchBar)
        tableView.tableHeaderView = headerContainer
        updateTableHeaderLayout()
    }
    
    private func updateTableHeaderLayout() {
        let width = tableView.bounds.width
        guard width > 0 else { return }
        
        let headerHeight: CGFloat = 60
        headerContainer.frame = CGRect(x: 0, y: 0, width: width, height: headerHeight)
        searchBar.frame = CGRect(x: 16, y: 8, width: width - 32, height: 44)
        
        if tableView.tableHeaderView !== headerContainer {
            tableView.tableHeaderView = headerContainer
        } else {
            tableView.tableHeaderView = headerContainer
        }
    }
    
    private func setupTableFooter() {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 60))
        footer.backgroundColor = .clear
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        footer.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: footer.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: footer.centerYAnchor)
        ])
        
        tableView.tableFooterView = footer
    }
    
    private func setupBindings() {
        viewModel.onCharactersUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onLoadingChanged = { [weak self] isLoading in
            guard let self else { return }
            isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
        
        viewModel.onError = { [weak self] message in
            self?.showError(message: message)
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension CharactersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CharacterCell.identifier,
            for: indexPath
        ) as? CharacterCell else {
            return UITableViewCell()
        }
        
        let character = viewModel.characters[indexPath.row]
        let isFavorite = viewModel.isFavorite(id: character.id)
        
        cell.configure(with: character, isFavorite: isFavorite)
        cell.delegate = self
        
        viewModel.loadMoreIfNeeded(currentIndex: indexPath.row)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CharactersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let character = viewModel.characters[indexPath.row]
        viewModel.showDetail(character: character)
    }
}

// MARK: - CharacterCellDelegate

extension CharactersViewController: CharacterCellDelegate {
    
    func didTapFavorite(character: Character) {
        viewModel.toggleFavorite(character: character)
        
        if let index = viewModel.characters.firstIndex(where: { $0.id == character.id }) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

// MARK: - UISearchBarDelegate

extension CharactersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if query.isEmpty {
            viewModel.clearSearch()
        } else if query.count > 2 {
            viewModel.search(query: query)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

