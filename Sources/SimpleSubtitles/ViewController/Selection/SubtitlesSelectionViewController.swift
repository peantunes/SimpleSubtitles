import UIKit
import SubtitlesInterface

class SubtitleSelectionViewController: UICollectionViewController {
    private let interactor: SubtitlesInteractorProtocol
    private let languages: [SubtitleLanguage]
    
    init(interactor: SubtitlesInteractorProtocol, languages: [SubtitleLanguage]) {
        self.interactor = interactor
        self.languages = languages
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 200, height: 60)
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var internalIndex: Int = 0 {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var selectedIndex: Int! {
        set {
            guard let selectedIndex = newValue else { return }
            internalIndex = selectedIndex + 1
        }
        get {
            internalIndex - 1
        }
    }
    
    private var allItems: [String] {
        [labelForIndex(0)] + self.languages.map { $0.label }
    }
    
    override func viewDidLoad() {
        collectionView.register(SubtitleCollectionViewCell.self, forCellWithReuseIdentifier: SubtitleCollectionViewCell.reuseIdentifier)
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.scrollToItem(at: IndexPath(row: internalIndex, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    func selectionChanged() {
        interactor.setSubtitleFile(url: "")
    }
    
}

extension SubtitleSelectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubtitleCollectionViewCell.reuseIdentifier, for: indexPath) as! SubtitleCollectionViewCell
        let item = allItems[indexPath.row]
        cell.setup(label: item, selected: indexPath.row == internalIndex)
        return cell
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        let previous = context.previouslyFocusedItem as? SubtitleCollectionViewCell
        let next = context.nextFocusedItem as? SubtitleCollectionViewCell
        previous?.setFocused(false)
        next?.setFocused(true)
        guard let nextView = next else {
            return
        }
        collectionView.scrollRectToVisible(nextView.frame, animated: true)
    }
    
}

extension SubtitleSelectionViewController: UICollectionViewDelegateFlowLayout {
    private var cellCount: CGFloat {
        CGFloat(allItems.count)
    }
    
    private var cellWidth: CGFloat {
       160 * cellCount
    }
    
    private var cellSpacing: CGFloat {
        80
    }
    
    private func labelForIndex(_ index: Int) -> String {
        if index == 0 {
            return NSLocalizedString("subtitles_off", bundle: .module, comment: "Option for subtitles to turned off")
        } else {
            let label = languages[index-1]
            return label.label
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let totalCellWidth = cellWidth //* cellCount
        let totalSpacingWidth = cellSpacing * (cellCount - 1)

        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2

        return UIEdgeInsets(top: 0, left: max(0, leftInset), bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        internalIndex = indexPath.row
        
        if selectedIndex < 0 {
            interactor.removeSubtitles()
        } else {
            let language = languages[indexPath.row - 1]
            interactor.setSubtitleFile(url: language.url)
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = labelForIndex(indexPath.row)
        let flagSpace: Int = indexPath.row == internalIndex ? 60 : 0
        return CGSize(width: label.count*24 + flagSpace, height: 60)
    }
}
