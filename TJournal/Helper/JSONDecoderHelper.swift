import Foundation


extension JSONDecoder {
    static func decode<T: Decodable>(data: Data) -> T? {
        do {
            let decoder = JSONDecoder()
            let decodedModel = try decoder.decode(T.self, from: data)
            return decodedModel
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
