

import Foundation

class CharactersViewModel {
    
    var charactersViewModel: [Character]
    init() {
        self.charactersViewModel = [Character]()
    }
}

extension CharactersViewModel {
    func postViewModel(at index:Int) -> Character   {
        return self.charactersViewModel[index]
    }
}
