import UIKit


protocol FeedPresenterProtocol {
    var news: [NewsModel] { get }
    func loadNews()
    func modelForRow(at indexPath: IndexPath) -> NewsCellModel
    func presentImageFull(image: UIImage?, frame: CGRect)
}

class FeedViewController: UIViewController {
    
    lazy private(set) var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NewsCell.nib, forCellReuseIdentifier: NewsCell.reuseId)
        return tableView
    }()
    
    var presenter: FeedPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.loadNews()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseId, for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        let model = presenter.modelForRow(at: indexPath)
        cell.setup(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let current = presenter.news[indexPath.row]
        let height = current.title.height(withConstrainedWidth: tableView.frame.width - 32, font: .systemFont(ofSize: 22, weight: .medium))
        
        return current.imageId == nil ? height + 44 : height + 254
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        let frameSize = scrollView.frame.size.height

        let contentSize = scrollView.contentSize.height - frameSize
        if scrollOffset >= contentSize {
            presenter.loadNews()
        }
    }
}


extension FeedViewController: FeedView {
    func updateTable() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}


extension FeedViewController: NewsCellDelegate {
    func didTapOnImage(image: UIImage?, frame: CGRect) {
        presenter.presentImageFull(image: image, frame: frame)
    }
}
