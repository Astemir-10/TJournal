import Foundation

protocol APIProtocol {
    func getNews(lastId: Int?, compleation: @escaping (NewsResultModel) -> ())
    func downloadImage(id: String, compleation: @escaping (Data) -> ())
}

class API: APIProtocol {
  
    private var apiUrl: APIUrlProtocol = APIUrl()
    
    func getNews(lastId: Int? = nil, compleation: @escaping (NewsResultModel) -> ()) {
        let url = apiUrl.generateNewsUrl()
        var params: [String: Any] = [:]
        if let lastId = lastId {
            params["lastId"] = lastId
        }
        Networking.shared.makeReq(url: url, params: params) { result in
            switch result {
            case .success(let data):
                if let decoded: NewsResponseModel? = JSONDecoder.decode(data: data),
                    var resultModel = decoded?.result {
                    resultModel.items.removeAll(where: { $0.data == nil })
                    resultModel.filterBlocks()
                    resultModel.items.removeAll(where: {  $0.data?.blocks?.isEmpty ?? true })
                    compleation(resultModel)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    func downloadImage(id: String, compleation: @escaping (Data) -> ()) {
        let url = apiUrl.generateImageUrl(imageId: id)
        Networking.shared.makeReq(url: url, params: [:]) { result in
            switch result {
            case .success(let data):
                compleation(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
