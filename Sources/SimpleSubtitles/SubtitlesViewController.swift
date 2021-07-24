import UIKit

class SubtitlesTextView: UIView {
    private let presenter: SubtitlesController
    private var viewModel: SubtitlesControl.ViewModel?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    } ()
    
    private let labelLines: SubtitlesLabel = {
        let label = SubtitlesLabel()
        label.numberOfLines = 0
        label.insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 44)
        label.layer.backgroundColor = UIColor(white: 0.0, alpha: 0.5).cgColor
        label.layer.cornerRadius = 10
        return label
    } ()
    
    init(presenter: SubtitlesController) {
        self.presenter = presenter
        super.init(frame: CGRect(x: 100, y: 100, width: 1200, height: 800))
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        stackView.addArrangedSubview(labelLines)
        stackView.addSubview(labelLines)
    }
}

extension SubtitlesTextView: SubtitlesControlViewProtocol {
    func perform(update: SubtitlesControl.Update) {
        switch update {
        case .hideSubtitles:
            labelLines.text = nil
            labelLines.isHidden = true
        case .showSubtitles(let viewModel):
            if viewModel != self.viewModel {
                labelLines.text = viewModel.lines
                labelLines.isHidden = false
            }
            self.viewModel = viewModel
        }
    }
}

class SubtitlesLabel: UILabel {
    
    var insets: UIEdgeInsets = .zero
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: text == nil ? rect : rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += insets.left + insets.right
        contentSize.height += insets.top + insets.bottom
        
        return contentSize
    }
}
