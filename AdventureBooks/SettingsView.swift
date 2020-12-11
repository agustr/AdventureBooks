import UIKit

class SettingsView: UIView {
    override class var requiresConstraintBasedLayout: Bool {
      return true
    }
    
    private lazy var showTextLabel: UILabel = {
        let showTextLabel = UILabel()
        showTextLabel.text = "Texti"
        return showTextLabel
    }()
    
    private lazy var showTextSwitch: UISwitch = {
        let showTextSwitch = UISwitch()
        showTextSwitch.addTarget(self, action: #selector(switchAction), for: .valueChanged)
        return showTextSwitch
    }()
    
    private lazy var showTextStack: UIStackView = {
        let showTextStack = UIStackView()
        showTextStack.axis = .horizontal
        showTextStack.spacing = 8
        showTextStack.addArrangedSubview(showTextLabel)
        showTextStack.addArrangedSubview(showTextSwitch)
        return showTextStack
    }()
    
    private lazy var turnPageLabel: UILabel = {
        let turnPageLabel = UILabel()
        turnPageLabel.text = "Fletta"
        return turnPageLabel
    }()
    
    private lazy var turnPageSwitch: UISwitch = {
        let turnPageSwitch = UISwitch()
        turnPageSwitch.addTarget(self, action: #selector(switchAction), for: .valueChanged)
        return turnPageSwitch
    }()
    
    private lazy var turnPageStack: UIStackView = {
        let turnPageStack = UIStackView()
        turnPageStack.axis = .horizontal
        turnPageStack.spacing = 8
        turnPageStack.addArrangedSubview(turnPageLabel)
        turnPageStack.addArrangedSubview(turnPageSwitch)
        return turnPageStack
    }()
    
    private lazy var playAudioLabel: UILabel = {
        let playAudioLabel = UILabel()
        playAudioLabel.text = "Lestur"
        return playAudioLabel
    }()
    
    private lazy var playAudioSwitch: UISwitch = {
        let playAudioSwitch = UISwitch()
        playAudioSwitch.addTarget(self, action: #selector(switchAction), for: .valueChanged)
        return playAudioSwitch
    }()
    
    private lazy var playAudioStack: UIStackView = {
        let playAudioStack = UIStackView()
        playAudioStack.axis = .horizontal
        playAudioStack.spacing = 8
        playAudioStack.addArrangedSubview(playAudioLabel)
        playAudioStack.addArrangedSubview(playAudioSwitch)
        return playAudioStack
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = self.axis
        stackView.distribution = .equalCentering
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    var axis: NSLayoutConstraint.Axis = .horizontal
    
    init(showText: Bool, playAudio: Bool, turnPage: Bool) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
        setupViews()
        setupConstraints()
        showTextSwitch.isOn = showText
        playAudioSwitch.isOn = playAudio
        turnPageSwitch.isOn = turnPage
    }
    
    func setupViews() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(playAudioStack)
        stackView.addArrangedSubview(turnPageStack)
        stackView.addArrangedSubview(showTextStack)
    }
    
    func setupConstraints() {
        stackView.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
        stackView.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
//        stackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        stackView.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
    }
    
    @objc func switchAction(sender: UISwitch, forEvent event: UIEvent) {
        print("switch: \(sender) did \(event)")
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
