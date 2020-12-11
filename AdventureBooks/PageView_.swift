import AVFoundation
import UIKit

class PageView: UIView {
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    let page: Page
    
    private lazy var stackview: UIStackView = {
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
        textView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var playButton: UIButton = {
        let playButton = UIButton(type: .roundedRect)
        playButton.setTitle("play", for: .normal)
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        return playButton
    }()
    
    lazy var showTextLabel: UILabel = {
        let showTextLabel = UILabel()
        showTextLabel.text = "Texti"
        return showTextLabel
    }()
    
    lazy var showTextSwitch: UISwitch = {
        let showTextSwitch = UISwitch()
        return showTextSwitch
    }()
    
    lazy var turnPageLabel: UILabel = {
        let turnPageLabel = UILabel()
        turnPageLabel.text = "Fletta"
        return turnPageLabel
    }()
    
    lazy var turnPageSwitch: UISwitch = {
        let turnPageSwitch = UISwitch()
        return turnPageSwitch
    }()
    
    lazy var playAudioLabel: UILabel = {
        let playAudioLabel = UILabel()
        playAudioLabel.text = "Lestur"
        return playAudioLabel
    }()
    
    lazy var playAudioSwitch: UISwitch = {
        let playAudioSwitch = UISwitch()
        return playAudioSwitch
    }()
    
    private lazy var audiPlayer: AVAudioPlayer? = {
        var audioPlayer: AVAudioPlayer?
        if let audiUrl = page.audioURL {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audiUrl)
                audioPlayer?.delegate = self
            } catch {
                print("could not instantiate a audioplayer: \(error)")
            }
        }
        return audioPlayer
    }()
    
    private var menuStackView: UIStackView = {
        let menuStackView = UIStackView()
        menuStackView.axis = .horizontal
        menuStackView.spacing = 8
        return menuStackView
    }()
    
    init(frame: CGRect, andPage page: Page) {
        self.page = page
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupViews()
        setupConstraints()
        populateContent()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func populateContent() {
        self.textView.text = page.text
        if let imagePath = page.imageURL?.path, let image = UIImage(contentsOfFile: imagePath) {
            self.imageView.image = image
            self.imageView.autoConstrainAttribute(.width,
                                                  to: .height,
                                                  of: self.imageView,
                                                  withMultiplier: image.size.aspectRatio())
            self.imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
            self.imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
    }
    
    private func setupViews() {
        let pauseGesture = UITapGestureRecognizer(target: self, action: #selector(pause))
        self.addGestureRecognizer(pauseGesture)
        self.addSubview(stackview)
        self.stackview.addArrangedSubview(imageView)
        self.stackview.addArrangedSubview(textView)
        self.stackview.addArrangedSubview(menuStackView)
        self.menuStackView.addArrangedSubview(showTextSwitch)
        self.menuStackView.addArrangedSubview(playButton)
    }

    private func setupConstraints() {
        textView.autoPinEdge(.left, to: .left, of: stackview)
        textView.autoPinEdge(.right, to: .right, of: stackview)
        stackview.autoCenterInSuperview()
        stackview.autoConstrainAttribute(.top, to: .top, of: self, withOffset: 0, relation: .greaterThanOrEqual)
        stackview.autoConstrainAttribute(.bottom, to: .bottom, of: self, withOffset: 0, relation: .lessThanOrEqual)
        stackview.autoPinEdge(.left, to: .left, of: self)
        stackview.autoPinEdge(.right, to: .right, of: self)
    }
    
    @objc func play() {
        self.audiPlayer?.play()
        self.setMenuHidden(true)
    }
    
    @objc func pause() {
        self.audiPlayer?.pause()
        self.setMenuHidden(false)
    }
    
    @objc func stop() {
        self.audiPlayer?.stop()
        self.setMenuHidden(false)
    }
    
    func setTextHidden(hidden: Bool, Animated animated: Bool = true) {
        guard self.textView.isHidden != hidden else {
            return
        }
        let animationSpeed = animated ? 0.4 : 0
        UIView.animate(withDuration: animationSpeed) {
            self.textView.isHidden = hidden
        }
    }
    
    func setMenuHidden(_ hidden: Bool, Animated animated: Bool = true) {
        guard self.menuStackView.isHidden != hidden else {
            return
        }
        let animationSpeed = animated ? 0.4 : 0
        UIView.animate(withDuration: animationSpeed) {
            self.menuStackView.isHidden = hidden
        }
    }
}

extension PageView: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {}
    
    func audioPlayerBeginInterruption(_: AVAudioPlayer) {}
}
