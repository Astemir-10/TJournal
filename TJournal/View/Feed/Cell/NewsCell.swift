import UIKit

protocol NewsCellDelegate: AnyObject {
    func didTapOnImage(image: UIImage?, frame: CGRect)
}

struct NewsCellModel {
    let imageUrl: URL?
    let title: String
}

class NewsCell: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    weak var delegate: NewsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureREcognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapAction))
        newsImageView.isUserInteractionEnabled = true
        newsImageView.addGestureRecognizer(tapGestureREcognizer)
    }
    
    @objc private func imageTapAction(_ : UITapGestureRecognizer) {
        let frame = newsImageView.superview!.convert(newsImageView.frame, to: nil)
        delegate?.didTapOnImage(image: newsImageView.image, frame: frame)
    }
    
    func setup(model: NewsCellModel) {
        if let url = model.imageUrl {
            self.newsImageView.loadImage(url: url)
        }
        
        titleLabel.text = model.title
    }
}
