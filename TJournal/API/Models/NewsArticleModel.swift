import Foundation


struct NewsResponseModel: Decodable {
    let result: NewsResultModel
}

struct NewsResultModel: Decodable {
    var items: [NewsArticleModel]
    let lastId: Int
    
    mutating func filterBlocks() {
        
        var items = [NewsArticleModel]()
        for var i in self.items {
            i.data?.filter()
            items.append(i)
        }
        self.items = items
    }
}

struct NewsArticleModel: Decodable {
    let type: String
    var data: NewsArticleData?
}

extension NewsArticleModel {
    enum Key: String, CodingKey {
        case data = "data"
        case type = "type"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.type = try container.decode(String.self, forKey: .type)
        
        if self.type == "entry" {
            self.data = try container.decode(NewsArticleData.self, forKey: .data)
        } else {
            self.data = nil
        }
    }
}

struct NewsArticleData: Decodable {
    let id: Int?
    var blocks: [ArticleBlock]?
    let title: String?
    let date: Int?
    let type: Int
    
    mutating func filter() {
        self.blocks = blocks?.filter({ $0.type == "text" || $0.type == "media" })
        
    }
}

struct ArticleBlock: Decodable {
    let type: String
    let data: ArticleBlockItem?
}

struct ArticleBlockItem: Decodable {
    let text: String?
    let items: Media?
}

extension ArticleBlockItem {
    enum Key:String, CodingKey {
        case items = "items"
        case text = "text"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        if let text = try? container.decode(String.self, forKey: .text) {
            self.text = text
        } else {
            self.text = nil
        }
        
        if let items = try? container.decode([Media].self, forKey: .items) {
            self.items = items.first
        } else {
            self.items = nil
        }
    }
}

struct Media: Decodable {
    let image: ArticleBlockItemImage?
}

struct ArticleBlockItemImage: Decodable {
    let type: String
    let data: ArticleBlockItemImageData?
}

struct ArticleBlockItemImageData: Decodable {
    let uuid: String?
}
