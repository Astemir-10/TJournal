import Foundation

protocol APIUrlProtocol {
    func generateNewsUrl() -> URL?
    func generateImageUrl(imageId: String) -> URL?
}

struct APIUrl: APIUrlProtocol {
    private let baseUrl = "https://api.dtf.ru/v2.1"
    private let urlForImages = "https://leonardo.osnova.io/"
    
    func generateNewsUrl() -> URL? {
        guard var url = URL(string: baseUrl) else { return nil }
        url.appendPathComponent("timeline")
        return url
    }
    
    func generateImageUrl(imageId: String) -> URL? {
        guard var url = URL(string: urlForImages) else { return nil }
        url.appendPathComponent(imageId)
        return url
    }
}
