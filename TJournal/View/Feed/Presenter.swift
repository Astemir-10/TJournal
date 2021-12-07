import UIKit

protocol FeedView: AnyObject {
    func updateTable()
}

class NewsPresenter: FeedPresenterProtocol {
    
    var news: [NewsModel] = []
    
    weak private var view: FeedView!
    private var router: FeedRouterProtocol!
    private var api: APIProtocol
    private var isLoadingNews = false
    
    func loadNews() {
        if isLoadingNews { return }
        isLoadingNews = true
        if let url = Bundle.main.url(forResource: "MockData", withExtension: "json"), let data = try? Data(contentsOf: url) {
            let decoder: [NewsModel]? = JSONDecoder.decode(data: data)
            self.news = decoder ?? []
            isLoadingNews = false
            view.updateTable()
        }
        return
        let lastId = news.last?.id
        api.getNews(lastId: lastId) { result in
            self.news = result.items.map({ NewsModel(id: $0.data!.id ?? 0, imageId: $0.data?.blocks?.first?.data?.items?.image?.data?.uuid, title: $0.data?.title ?? "") })
            self.isLoadingNews = false
            self.view
                .updateTable()
        }
    }
    
    func modelForRow(at indexPath: IndexPath) -> NewsCellModel {
        let apiUrl = APIUrl()
        let news = self.news[indexPath.row]
        var imageUrl: URL? = nil
        
        if let imageId = news.imageId {
            imageUrl = apiUrl.generateImageUrl(imageId: imageId)
        }
        let model = NewsCellModel(imageUrl: imageUrl, title: news.title)
        return model
    }
    
    
    func presentImageFull(image: UIImage?, frame: CGRect) {
        if let image = image {
            router.showImagePresenter(image: image, frame: frame)
        }
    }
    
    
    
    init(api: APIProtocol, view: FeedView, router: FeedRouterProtocol) {
        self.api = api
        self.view = view
        self.router = router
    }
}
