import UIKit

class PageView: UIView {
    override class var requiresConstraintBasedLayout: Bool {
      return true
    }
    
    let page: Page
    
   lazy var stackview: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .center
        stackview.distribution = .equalSpacing
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    init(frame: CGRect, andPage page: Page) {
        self.page = page
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupViews()
        setupConstraints()
        populateContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populateContent() {
        self.textView.text = page.text
        if let imagePath = page.imageURL?.path {
            self.imageView.image = UIImage(contentsOfFile: imagePath)
        }
    }
    
    func setupViews() {
        self.addSubview(stackview)
        self.stackview.addArrangedSubview(imageView)
        self.stackview.addArrangedSubview(textView)
    }
    
    func setupConstraints() {
        imageView.autoSetDimension(.height, toSize: 100)
        imageView.autoSetDimension(.width, toSize: 100)
        textView.autoPinEdge(.left, to: .left, of: stackview)
        textView.autoPinEdge(.right, to: .right, of: stackview)
        stackview.autoCenterInSuperview()
        stackview.autoPinEdge(.left, to: .left, of: self)
        stackview.autoPinEdge(.right, to: .right, of: self)
        stackview.autoConstrainAttribute(.top, to: .top, of: self, withOffset: 0, relation: .greaterThanOrEqual)
        stackview.autoConstrainAttribute(.bottom, to: .bottom, of: self, withOffset: 0, relation: .lessThanOrEqual)
    }

}
