

import Foundation

struct CharactersModel: Codable {
    let code: Int?
    let status: String?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let data: CharacterDataContainer?
    let etag: String?
}

extension CharactersModel {
    static var Get:  Resource<CharactersModel> = {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else{
            fatalError("URL is incorrect!")
        }
        return Resource<CharactersModel>(url: url)
    }()
}

