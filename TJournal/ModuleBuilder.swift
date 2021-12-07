class ModuleBuilder {
    
    static func buildFeed() -> FeedViewController {
        let feedViewController = FeedViewController()
        let api = API()
        let router = FeedRouter(vc: feedViewController)
        let presenter = NewsPresenter(api: api, view: feedViewController, router: router)
        feedViewController.presenter = presenter
        return feedViewController
    }
    
}
