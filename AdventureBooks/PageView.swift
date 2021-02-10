import PureLayout
import UIKit

class PageViewlksjdf: UIView {
    override class var requiresConstraintBasedLayout: Bool {
      return true
    }
    
    let page: Page
    
    var shouldSetupConstraints = true
    
    var imageView: UIImageView!
    var imageViewContainer: UIView!
    var textView: UITextView!
    var stackView: UIStackView!
    var imageWidthConstraint: NSLayoutConstraint?
    var imageHeightConstraint: NSLayoutConstraint?
    
    @objc var showText: Bool = true {
        didSet {
            if oldValue == showText { return }
            self.textView.isHidden = !showText
            setNeedsUpdateConstraints()
        }
    }
    
    @objc var text: String? {
        get {
            return self.textView.text
        }
        set {
            self.textView.text = newValue
            setNeedsUpdateConstraints()
        }
    }
    
    @objc var image: UIImage? {
        get {
            return self.imageView.image
        }
        set {
            self.imageView.image = newValue
            setNeedsUpdateConstraints()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    fileprivate func setUpView() {
        
        stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        imageViewContainer = UIView()
        imageViewContainer.addSubview(imageView)
        imageView.autoPinEdgesToSuperviewEdges()
        
        stackView.addArrangedSubview(imageViewContainer)
        
        textView = UITextView()
        textView.textAlignment = .justified
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        stackView.addArrangedSubview(textView)
    }
    
    init(frame: CGRect, andPage: Page) {
        showText = true
        self.page = andPage
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if shouldSetupConstraints {
            // AutoLayout constraints
            textView.autoPinEdge(toSuperviewEdge: .leading)
            textView.autoPinEdge(toSuperviewEdge: .trailing)
            
            imageWidthConstraint = imageViewContainer.autoSetDimension(.width, toSize: 20)
            imageHeightConstraint = imageViewContainer.autoSetDimension(.height, toSize: 20)
            
            stackView.autoAlignAxis(toSuperviewAxis: .horizontal)
            stackView.autoPinEdge(toSuperviewEdge: .leading)
            stackView.autoPinEdge(toSuperviewEdge: .trailing)
            
            shouldSetupConstraints = false
        }
        
        if textView.text.count == 0 {
            textView.isHidden = true
        }
        
        self.adjustImageSize()
        super.updateConstraints()
    }
    
    func adjustImageSize() {
        if let image = image {
            let imageSize = allowedImageSize(image: image)
            print("allowed image size:\(imageSize)")
            imageWidthConstraint?.constant = imageSize.width
            imageHeightConstraint?.constant = imageSize.height
        }
    }
    
    func allowedImageSize(image: UIImage) -> CGSize {
        var remainingHeight: CGFloat = 0
        if showText {
            let sizeWidthConstrained = CGSize(width: self.bounds.width, height: CGFloat(MAXFLOAT))
            let textHeight = textView.systemLayoutSizeFitting(sizeWidthConstrained).height
            remainingHeight = self.frame.size.height - textHeight
        } else {
            remainingHeight = self.bounds.size.height
        }
        
        return imageViewSize(for: image, in: CGSize(width: self.frame.width, height: remainingHeight))
    }
    
    func imageViewSize(for image: UIImage, in size: CGSize) -> CGSize {
        let aspectRatio = image.size.width/image.size.height
        var imageViewSize = CGSize(width: 0, height: 0)
        // use height as constraining factor
        if size.height * aspectRatio <= size.width {
            imageViewSize = CGSize(width: size.height * aspectRatio, height: size.height)
        } else {
            imageViewSize = CGSize(width: size.width, height: size.width/aspectRatio)
        }
        return imageViewSize
    }
}
