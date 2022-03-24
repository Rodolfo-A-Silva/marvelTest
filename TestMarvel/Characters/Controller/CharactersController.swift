

import UIKit
import SDWebImage

class CharactersController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    var listPost = CharactersViewModel()
    var index: Int = 0
    var indexOfPageRequest = 0
    var loadingPage = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showLoading(enable: true)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        setup()
    }
  
    func setup(){
        APIService().load(nil, page: 0, resource: CharactersModel.Get) { [weak self] result in
            switch result {
            case .success(let orders):
                if let result = orders.data?.results {
                    self?.listPost.charactersViewModel = result
                    self?.tableview.reloadData()
                    self?.showLoading(enable: false)
                    self?.loadingPage = true
                }
            case .failure(let error):
                print("Error ", error)
                self?.showLoading(enable: false)
            }
        }
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listPost.charactersViewModel.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        self.performSegue(withIdentifier: "result", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:
                                                    indexPath) as! CustomCell
        cell.setupCell(self.listPost.postViewModel(at: indexPath.row))
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "result":
            let vc = segue.destination as! ResultCharactersViewController
            vc.character = self.listPost.postViewModel(at: self.index)
            vc.comicList = self.listPost.charactersViewModel[self.index].comics
            
        default:
            break;
        }
    }
    
    func nextPage (_ page: Int) {
        APIService().load(nil, page: page, resource: CharactersModel.Get) { [weak self] result in
            switch result {
            case .success(let orders):
                if let result = orders.data?.results {
                    
                    self?.listPost.charactersViewModel.append(contentsOf: result)
                    self?.tableview.reloadData()
                    self?.showLoading(enable: false)
                    self?.loadingPage = true
                }
            case .failure(let error):
                print("Error ", error)
                self?.showLoading(enable: false)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.asyncAfter(deadline : . now() + 1.0) {
            if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) && self.loadingPage) {
                self.loadingPage = false
                self.showLoading(enable: true)
                self.indexOfPageRequest += 1
                self.nextPage(self.indexOfPageRequest)
            }
        } 
    }
}


