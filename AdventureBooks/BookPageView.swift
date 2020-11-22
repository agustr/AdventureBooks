import UIKit
import PureLayout

class BookPageView: UIView {
    
    var shouldSetupConstraints = true
    
    var imageView: UIImageView!
    var imageViewContainer: UIView!
    var textView: UITextView!
    var stackView: UIStackView!
    var imageWidthConstraint: NSLayoutConstraint?
    var imageHeightConstraint: NSLayoutConstraint?
    
    @objc var showText: Bool = true {
        didSet{
            if oldValue == showText { return }
            self.textView.isHidden = !showText
            setNeedsUpdateConstraints()
        }
    }
    
    @objc var text: String? {
        set {
            self.textView.text = newValue
            setNeedsUpdateConstraints()
        }
        get{
            return self.textView.text
        }
    }
    
    @objc var image: UIImage? {
        set {
            self.imageView.image = newValue
            setNeedsUpdateConstraints()
        }
        get {
            return self.imageView.image
        }
    }
    
    override var bounds: CGRect {
        didSet{
            setNeedsUpdateConstraints()
        }
    }
    
    fileprivate func setUpView() {
        self.translatesAutoresizingMaskIntoConstraints = false;
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
    
    override init(frame: CGRect) {
        showText = true
        
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        showText = true
        
        super.init(coder: aDecoder)
        setUpView()
    }
    
    override func updateConstraints() {
        if(shouldSetupConstraints) {
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
            remainingHeight = self.frame.size.height - textView.systemLayoutSizeFitting(CGSize(width: self.bounds.width,height: CGFloat(MAXFLOAT))).height
        } else {
            remainingHeight = self.bounds.size.height
        }
        
        return imageViewSize(for: image, in: CGSize(width: self.frame.width, height: remainingHeight))
    }
    
    func imageViewSize(for image:UIImage, in size:CGSize) -> CGSize {
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