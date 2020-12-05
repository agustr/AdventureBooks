import UIKit

class LibraryView: UIView {

    override class var requiresConstraintBasedLayout: Bool {
      return true
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var settingsButton: UIButton = {
        let settingsButton = UIButton()
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.setTitle("settings", for: .normal)
        settingsButton.setImage(UIImage(named: "gearshape"), for: .normal)
        return settingsButton
    }()
    
    lazy var editModeButton: UIButton = {
        let editModeButton = UIButton()
        editModeButton.translatesAutoresizingMaskIntoConstraints = false
        editModeButton.setTitle("edit", for: .normal)
        editModeButton.setImage(UIImage(named: "mic"), for: .normal)
        return editModeButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        // Configure self
        backgroundColor = .blue
        // Add subviews
        addSubview(tableView)
        addSubview(settingsButton)
        addSubview(editModeButton)
        // Configure layout
        setupConstraints()
        // setup internal actions for the view
    }
    
    func setupConstraints() {
        tableView.autoPinEdge(.top, to: .top, of: self, withOffset: 15)
        tableView.autoPinEdge(.right, to: .right, of: self, withOffset: -15)
        tableView.autoPinEdge(.left, to: .left, of: self, withOffset: 15)
        tableView.autoPinEdge(.bottom, to: .top, of: settingsButton, withOffset: -15)
        settingsButton.autoPinEdge(.right, to: .right, of: self, withOffset: -15)
        settingsButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 15)
        settingsButton.autoPinEdge(.left, to: .right, of: editModeButton, withOffset: 10)
        settingsButton.autoSetDimensions(to: CGSize(width: 25, height: 25))
        editModeButton.autoPinEdge(.bottom, to: .bottom, of: settingsButton, withOffset: 0)
        editModeButton.autoSetDimensions(to: CGSize(width: 25, height: 25))
    }

}

// boilerplate for uiview subclass that is intended to be used as uiviewcontrollers
// root view using constraints.
class CustomView: UIView {
    // custom views should override this to return true if
    // they cannot layout correctly using autoresizing.
    // from apple docs https://developer.apple.com/documentation/uikit/uiview/1622549-requiresconstraintbasedlayout
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }

    lazy var subView: UIView = {
        // Snazy way of instantiating subviews
        let subView = UIView()
        subView.backgroundColor = .green
        subView.translatesAutoresizingMaskIntoConstraints = false
        return subView
    }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
  
    private func setupView() {
        // Configure self
        backgroundColor = .white
        // Add subviews
        addSubview(subView)
        // Configure layout
        setupLayout()
        // setup internal actions for the view
        setupActions()
    }
    
    private func setupActions() {
        // setup the internal actions for the view.
        // addButton.addTarget(self, action: #selector(moveHeaderView), for: .touchUpInside)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: topAnchor),
            subView.leadingAnchor.constraint(equalTo: leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: trailingAnchor),
            subView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
