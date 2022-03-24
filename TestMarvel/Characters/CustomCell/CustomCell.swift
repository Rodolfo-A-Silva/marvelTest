
import UIKit
import SDWebImage

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var typeImage: UIImageView! {
        didSet {
            typeImage.layer.cornerRadius = 7
            typeImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var typeDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(_ character: Character) {
        if let url = character.thumbnail?.url {
            DispatchQueue.main.async {
                self.typeImage.sd_setImage(with: url as URL)
            }
        }
        self.title.text = character.name
        self.typeDescription.text = character.description
    }
}


