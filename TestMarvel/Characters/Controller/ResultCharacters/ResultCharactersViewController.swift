//
//  ResultCharactersViewController.swift
//  TestMarvel
//
//  Created by Reedy on 22/03/22.
//

import UIKit
import SDWebImage

class ResultCharactersViewController: UIViewController {
    
    var character: Character?
    var comicList: ComicList?
    
    @IBOutlet weak var image: UIImageView!{
        didSet {
            image.layer.cornerRadius = 7
            image.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var typeDescription: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if let url = character?.thumbnail?.url {
            DispatchQueue.main.async {
                self.image.sd_setImage(with: url as URL)
            }
        }
        
        if let description = character?.description {
            if !description.isEmpty {
                self.typeDescription.text = description
            } else {
                self.typeDescription.text = "No description"
            }
        }
        self.title = character?.name ?? ""
    }
}

extension ResultCharactersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Comics"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comicList?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula", for:
                                                    indexPath)
        cell.textLabel?.text = self.comicList?.items?[indexPath.row].name ?? ""
        return cell
    }
}
