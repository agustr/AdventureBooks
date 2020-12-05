import UIKit

class BookTableViewCell: UITableViewCell {
    static let reuseIdentifer = "BookTableViewCell"
    
    var book: Book? {
        didSet {
            if let imagePath = book?.icon?.path {
                self.bookIconImageView.image = UIImage(contentsOfFile: imagePath)
            } else {
                self.bookIconImageView.image = nil
            }
            bookTitleLabel.text = book?.title
        }
    }
    
    lazy var bookIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor

        return imageView
    }()
    
    lazy var bookTitleLabel: UILabel = {
       return UILabel()
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // add subviews
        self.addSubview(bookIconImageView)
        self.addSubview(bookTitleLabel)
        // configure layout
        bookIconImageView.autoSetDimension(.height, toSize: 60)
        bookIconImageView.autoSetDimension(.width, toSize: 60)
        bookIconImageView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 3,
                                                                          left: 3,
                                                                          bottom: 3,
                                                                          right: 3),
                                                       excludingEdge: .right)
        bookTitleLabel.autoPinEdge(.left, to: .right, of: bookIconImageView, withOffset: 15)
        bookTitleLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.book = nil
    }

}
