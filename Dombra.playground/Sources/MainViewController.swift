import UIKit

public class MainViewController: UIViewController {
    // MARK:- Properties
    private lazy var backgroundImageView = UIImageView()
    private lazy var keysCVBackground: UIImageView = {
        let iv = UIImageView()
        let image = UIImage(named: "dombraBg")
        iv.image = image
        return iv
    }()
    
    private lazy var firstKeysCV: UICollectionView = {
        return turnToKeyCV(vc: self, tag: 1000, CellClass: KeyCollectionViewCell.self, direction: .horizontal, spacing: 4, topInset: 0)
    }()
    private lazy var firstNotesCV: UICollectionView = {
        return turnToKeyCV(vc: self, tag: 1002, CellClass: TitleCollectionViewCell.self, direction: .horizontal, spacing: 4, topInset: 0)
    }()
    private lazy var firstOpenNoteLbl: UILabel = {
        let label = UILabel()
        label.turnToStateLabel(Content.firstOpenNote, font: view.frame.height * 0.04)
        return label
    }()
    private lazy var firstString: UIImageView = {
        let iv = UIImageView()
        iv.turnToString()
        return iv
    }()
    
    private lazy var secondKeysCV: UICollectionView = {
        return turnToKeyCV(vc: self, tag: 1001, CellClass: KeyCollectionViewCell.self, direction: .horizontal, spacing: 4, topInset: 0)
    }()
    private lazy var secondNotesCV: UICollectionView = {
        return turnToKeyCV(vc: self, tag: 1003, CellClass: TitleCollectionViewCell.self, direction: .horizontal, spacing: 4, topInset: 0)
    }()
    private lazy var secondOpenNoteLbl: UILabel = {
        let label = UILabel()
        label.turnToStateLabel(Content.secondOpenNote, font: view.frame.height * 0.04)
        return label
    }()
    private lazy var secondString: UIImageView = {
        let iv = UIImageView()
        iv.turnToString()
        return iv
    }()
    
    private lazy var dotsCV: UICollectionView = {
        return turnToKeyCV(vc: self, tag: 1004, CellClass: DotCollectionViewCell.self, direction: .horizontal, spacing: 4, topInset: 0)
    }()
    private lazy var openKeyView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var keysHidingSwitch: UISwitch = {
        let s = UISwitch()
        s.isOn = false
        s.addTarget(self, action: #selector(hideOrUnhideKeys), for: .valueChanged)
        return s
    }()
    private lazy var keysStateLabel: UILabel = {
        let lbl = UILabel()
        lbl.turnToStateLabel("Hide the dombra keys", font: self.view.frame.height * 0.04)
        return lbl
    }()
    
    private lazy var metronomeLabel: UILabel = {
        let lbl = UILabel()
        lbl.turnToStateLabel("Metronome", font: self.view.frame.height * 0.06)
        return lbl
    }()
    private lazy var containerView: ContainerView = {
        return ContainerView(frame: CGRect(x: 0, y: 0, width: 0, height: view.frame.height * 0.1))
    }()
    private lazy var playButton: UIButton = {
        let btn = UIButton()
        btn.configureButton(with: "play", target: self, and: #selector(toggleMetronome))
        return btn
    }()
    private lazy var plusButton: UIButton = {
        let btn = UIButton()
        btn.configureButton(with: "plus", target: self, and: #selector(increaseTempo))
        return btn
    }()
    private lazy var minusButton: UIButton = {
        let btn = UIButton()
        btn.configureButton(with: "minus", target: self, and: #selector(decreaseTempo))
        btn.isEnabled = false
        return btn
    }()
    private lazy var tempoStateLbl: UILabel = {
        let lbl = UILabel()
        lbl.turnToStateLabel("Grave", font: view.frame.height * 0.05)
        return lbl
    }()
    
    private lazy var iconsCV: UICollectionView = {
        return turnToKeyCV(vc: self, tag: 1005, CellClass: ImageCollectionViewCell.self, direction: .vertical, spacing: 20, topInset: 20)
    }()
    
    private lazy var firstOpenKeyHighlight: UIView = {
        let v = UIView()
        v.makeItDisappear()
        v.backgroundColor = Content.highlightColor
        return v
    }()
    private lazy var secondOpenKeyHighlight: UIView = {
        let v = UIView()
        v.makeItDisappear()
        v.backgroundColor = Content.highlightColor
        return v
    }()
    
    private var icons = ["question"]
    
    private var animationTimer: Timer?
    
    private var currentTempo = "Grave" {
        didSet {
            tempoStateLbl.text = currentTempo
        }
    }
    private var tempoIndex = 0
    private var isMetronomeTurnedOn = false
    private var isRight = false
        
    
    // MARK:- View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.turnToBackground(view, image: "wood")
        
        // the layout methods are in the extension
        addSubviews()
        setAutoresizingToFalse()
        activateConstraints()
        
        containerView.setupLayout(playButton)
        
        addGesturesToOpenKey()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AudioPlayer.backgroundAudioPlayer.stop()
    }
    
    private func addGesturesToOpenKey() {
        let touch = UITapGestureRecognizer(target: self, action: #selector(playStringIndividually(recognizer:)))
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(playBothStrings))
        downSwipe.direction = .down
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(playBothStrings))
        upSwipe.direction = .up
        
        openKeyView.addGestureRecognizer(touch)
        openKeyView.addGestureRecognizer(downSwipe)
        openKeyView.addGestureRecognizer(upSwipe)
    }
    
    
    // MARK:- Switches
    @objc
    private func hideOrUnhideKeys() {
        if keysHidingSwitch.isOn {
            keysStateLabel.text = "Show the dombra keys"
        } else {
            keysStateLabel.text = "Hide the dombra keys"
        }
        firstKeysCV.reloadData()
        secondKeysCV.reloadData()
    }
    
    
    // MARK:- Metronome functionality
    @objc
    private func toggleMetronome() {
        isMetronomeTurnedOn = !isMetronomeTurnedOn
        guard isMetronomeTurnedOn else {
            playButton.setImage(UIImage(named: "play"), for: .normal)
            stopMetronome()
            return
        }
        playButton.setImage(UIImage(named: "stop"), for: .normal)
        runMetronome()
    }
    
    private func runMetronome() {
        animationTimer = Timer.scheduledTimer(timeInterval: Content.tempos[currentTempo]! * 0.5, target: self, selector: #selector(updateState), userInfo: nil, repeats: true)
    }
    
    @objc
    private func updateState() {
        isRight = !isRight
        
        containerView.clearAllDots()
        if isRight {
            AudioPlayer.playMetronomeBeat()
            containerView.fillRightDot()
        } else {
            containerView.fillLeftDot()
        }
    }
    
    @objc
    private func increaseTempo() {
        minusButton.isEnabled = true
        stopMetronome()
        setCurrentTempo(increase: true)
    }
    
    @objc
    private func decreaseTempo() {
        plusButton.isEnabled = true
        stopMetronome()
        setCurrentTempo(increase: false)
    }
    
    private func setCurrentTempo(increase: Bool) {
        var dictArr = Array(Content.tempos)
        dictArr.sort{ $0.1 > $1.1 }
        var keys = [String]()
        for (key, _) in dictArr {
            keys.append(key)
        }
        if increase {
            tempoIndex += 1
            plusButton.isEnabled = (tempoIndex != keys.count - 1)
        } else {
            tempoIndex -= 1
            minusButton.isEnabled = (tempoIndex != 0)
        }
        currentTempo = keys[tempoIndex]
    }
    
    private func stopMetronome() {
        isMetronomeTurnedOn = false
        isRight = false
        playButton.setImage(UIImage(named: "play"), for: .normal)
        
        animationTimer?.invalidate()
        containerView.clearAllDots()
        AudioPlayer.metronomeAudioPlayer.stop()
    }

    
    // MARK:- Strings
    @objc
    private func playStringIndividually(recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: openKeyView)
        let height = openKeyView.frame.height
        
        if point.y < height * 0.5 {
            firstStringDragged(0)
            
            animateHighlighting(viewToHighlight: firstOpenKeyHighlight, keysCV: firstKeysCV)
        } else {
            secondStringDragged(0)
            
            animateHighlighting(viewToHighlight: secondOpenKeyHighlight, keysCV: secondKeysCV)
        }
    }
    
    @objc
    private func playBothStrings(swipe: UISwipeGestureRecognizer) {
        firstStringDragged(0)
        animateHighlighting(viewToHighlight: firstOpenKeyHighlight, keysCV: firstKeysCV)
        animateHighlighting(viewToHighlight: secondOpenKeyHighlight, keysCV: secondKeysCV)
        secondStringDragged(0)
    }
    
    private func animateHighlighting(viewToHighlight: UIView?, keysCV: UICollectionView) {
        guard keysHidingSwitch.isOn else { return }
        viewToHighlight?.alpha = 1
        UIView.animate(withDuration: 0.1, animations: {
            viewToHighlight?.alpha = 0
        })
    }
    
    private func firstStringDragged(_ index: Int) {
        AudioPlayer.playFirstStringNote(index)
        animateString(firstString)
    }
    
    private func secondStringDragged(_ index: Int) {
        AudioPlayer.playSecondStringNote(index)
        animateString(secondString)
    }
    
    private func animateString(_ string: UIImageView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: string.center.x, y: string.center.y + 1))
        animation.toValue = NSValue(cgPoint: CGPoint(x: string.center.x, y: string.center.y - 1))
        
        string.layer.add(animation, forKey: "position")
    }
}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag < 1005 {
            return 19
        } else {
            return icons.count
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath)
        cell.backgroundColor = .clear
        cell.isUserInteractionEnabled = false
        
        if collectionView.tag == 1005 {
            (cell as! ImageCollectionViewCell).imageName = icons[indexPath.row]
            cell.isUserInteractionEnabled = true
            return cell
        }
        
        if collectionView.tag == 1004 {
            configureDotCVCell(indexPath.row, cell)
            return cell
        }
        if collectionView.tag > 1001 {
            (cell as! TitleCollectionViewCell).title = collectionView.tag == 1003 ? Content.secondNotes[indexPath.row] : Content.firstNotes[indexPath.row]
            return cell
        }
        
        cell.isUserInteractionEnabled = true
        if keysHidingSwitch.isOn {
            (cell as? KeyCollectionViewCell)?.addBlurEffectViews()
        } else {
            (cell as? KeyCollectionViewCell)?.removeBlurs()
        }
        
        return cell
    }
    
    private func configureDotCVCell(_ index: Int, _ cell: UICollectionViewCell) {
        switch (index) {
        case 2, 5, 7, 9, 12, 14, 17:
            (cell as! DotCollectionViewCell).createDot()
        default: return
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? KeyCollectionViewCell
    
        let index = 19 - indexPath.row
        if collectionView.tag == 1000 {
            firstStringDragged(index)
            animateHighlighting(viewToHighlight: cell?.greenBlurEffectView, keysCV: firstKeysCV)
        } else if collectionView.tag == 1001 {
            secondStringDragged(index)
            animateHighlighting(viewToHighlight: cell?.greenBlurEffectView, keysCV: secondKeysCV)
        } else if collectionView.tag == 1005 {
            stopMetronome()
            self.show(GuideViewController(), sender: nil)
        }
    }
   
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let constant = collectionView.frame.width
        if collectionView.tag < 1005 {
            let width = (constant / 19) - 4
            return CGSize(width: width, height: collectionView.frame.height)
        } else {
            return CGSize(width: constant, height: constant)
        }
    }
}


extension MainViewController {
    // MARK:- Layout
    private func addSubviews() {
        view.addSubview(keysCVBackground)

        view.addSubview(openKeyView)
        view.addSubview(firstOpenKeyHighlight)
        view.addSubview(firstKeysCV)
        view.addSubview(firstNotesCV)
        view.addSubview(firstOpenNoteLbl)
        view.addSubview(firstString)

        view.addSubview(secondOpenKeyHighlight)
        view.addSubview(secondKeysCV)
        view.addSubview(secondNotesCV)
        view.addSubview(secondOpenNoteLbl)
        view.addSubview(secondString)

        view.addSubview(dotsCV)

        view.addSubview(keysHidingSwitch)
        view.addSubview(keysStateLabel)

        view.addSubview(metronomeLabel)
        view.addSubview(containerView)
        view.addSubview(tempoStateLbl)
        view.addSubview(playButton)
        view.addSubview(plusButton)
        view.addSubview(minusButton)
        
        view.addSubview(iconsCV)
    }

    private func setAutoresizingToFalse() {
        _ = self.view.subviews.map { $0.translatesAutoresizingMaskIntoConstraints = false }
    }

    private func activateConstraints() {
        NSLayoutConstraint.activate([
            keysCVBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keysCVBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keysCVBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            keysCVBackground.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),

            openKeyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            openKeyView.topAnchor.constraint(equalTo: keysCVBackground.topAnchor),
            openKeyView.heightAnchor.constraint(equalTo: keysCVBackground.heightAnchor),
            openKeyView.widthAnchor.constraint(equalTo: keysCVBackground.heightAnchor, multiplier: 0.7),
            
            firstOpenKeyHighlight.leadingAnchor.constraint(equalTo: openKeyView.leadingAnchor),
            firstOpenKeyHighlight.trailingAnchor.constraint(equalTo: openKeyView.trailingAnchor),
            firstOpenKeyHighlight.topAnchor.constraint(equalTo: openKeyView.topAnchor),
            firstOpenKeyHighlight.heightAnchor.constraint(equalTo: openKeyView.heightAnchor, multiplier: 0.5),
            
            secondOpenKeyHighlight.leadingAnchor.constraint(equalTo: firstOpenKeyHighlight.leadingAnchor),
            secondOpenKeyHighlight.trailingAnchor.constraint(equalTo: firstOpenKeyHighlight.trailingAnchor),
            secondOpenKeyHighlight.topAnchor.constraint(equalTo: firstOpenKeyHighlight.bottomAnchor),
            secondOpenKeyHighlight.bottomAnchor.constraint(equalTo: openKeyView.bottomAnchor),

            firstNotesCV.leadingAnchor.constraint(equalTo: openKeyView.trailingAnchor),
            firstNotesCV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            firstNotesCV.bottomAnchor.constraint(equalTo: keysCVBackground.topAnchor),
            firstNotesCV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            firstOpenNoteLbl.centerYAnchor.constraint(equalTo: firstNotesCV.centerYAnchor),
            firstOpenNoteLbl.centerXAnchor.constraint(equalTo: openKeyView.centerXAnchor),

            firstKeysCV.leadingAnchor.constraint(equalTo: openKeyView.trailingAnchor),
            firstKeysCV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            firstKeysCV.topAnchor.constraint(equalTo: keysCVBackground.topAnchor),
            firstKeysCV.heightAnchor.constraint(equalTo: openKeyView.heightAnchor, multiplier: 0.5),

            secondKeysCV.leadingAnchor.constraint(equalTo: firstKeysCV.leadingAnchor),
            secondKeysCV.trailingAnchor.constraint(equalTo: firstKeysCV.trailingAnchor),
            secondKeysCV.topAnchor.constraint(equalTo: firstKeysCV.bottomAnchor),
            secondKeysCV.heightAnchor.constraint(equalTo: firstKeysCV.heightAnchor),

            secondNotesCV.leadingAnchor.constraint(equalTo: firstNotesCV.leadingAnchor),
            secondNotesCV.trailingAnchor.constraint(equalTo: firstNotesCV.trailingAnchor),
            secondNotesCV.topAnchor.constraint(equalTo: secondKeysCV.bottomAnchor),
            secondNotesCV.heightAnchor.constraint(equalTo: firstNotesCV.heightAnchor),

            secondOpenNoteLbl.centerYAnchor.constraint(equalTo: secondNotesCV.centerYAnchor),
            secondOpenNoteLbl.centerXAnchor.constraint(equalTo: openKeyView.centerXAnchor),

            dotsCV.leadingAnchor.constraint(equalTo: secondKeysCV.leadingAnchor),
            dotsCV.trailingAnchor.constraint(equalTo: secondKeysCV.trailingAnchor),
            dotsCV.heightAnchor.constraint(equalTo: secondKeysCV.heightAnchor),
            dotsCV.centerYAnchor.constraint(equalTo: keysCVBackground.centerYAnchor),

            firstString.leadingAnchor.constraint(equalTo: keysCVBackground.leadingAnchor),
            firstString.trailingAnchor.constraint(equalTo: keysCVBackground.trailingAnchor),
            firstString.centerYAnchor.constraint(equalTo: firstKeysCV.centerYAnchor),
            firstString.heightAnchor.constraint(equalTo: firstKeysCV.heightAnchor, multiplier: 0.06),

            secondString.leadingAnchor.constraint(equalTo: keysCVBackground.leadingAnchor),
            secondString.trailingAnchor.constraint(equalTo: keysCVBackground.trailingAnchor),
            secondString.centerYAnchor.constraint(equalTo: secondKeysCV.centerYAnchor),
            secondString.heightAnchor.constraint(equalTo: firstString.heightAnchor),


            keysHidingSwitch.topAnchor.constraint(equalTo: secondNotesCV.bottomAnchor, constant: 16),
            keysHidingSwitch.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),

            keysStateLabel.topAnchor.constraint(equalTo: keysHidingSwitch.bottomAnchor, constant: 8),
            keysStateLabel.leadingAnchor.constraint(equalTo: keysHidingSwitch.leadingAnchor),

            metronomeLabel.topAnchor.constraint(equalTo: keysHidingSwitch.topAnchor),
            metronomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: metronomeLabel.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: metronomeLabel.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: metronomeLabel.bottomAnchor, constant: 8),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            
            playButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
            playButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            playButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.3, constant: -8),
            playButton.heightAnchor.constraint(equalTo: playButton.widthAnchor),
            
            minusButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            minusButton.topAnchor.constraint(equalTo: playButton.topAnchor),
            minusButton.heightAnchor.constraint(equalTo: playButton.heightAnchor),
            minusButton.widthAnchor.constraint(equalTo: playButton.widthAnchor),
            
            plusButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            plusButton.widthAnchor.constraint(equalTo: playButton.widthAnchor),
            plusButton.topAnchor.constraint(equalTo: playButton.topAnchor),
            plusButton.heightAnchor.constraint(equalTo: playButton.heightAnchor),
            
            tempoStateLbl.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 8),
            tempoStateLbl.leadingAnchor.constraint(equalTo: metronomeLabel.leadingAnchor),
            tempoStateLbl.trailingAnchor.constraint(equalTo: metronomeLabel.trailingAnchor),
            
            iconsCV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            iconsCV.topAnchor.constraint(equalTo: keysHidingSwitch.topAnchor),
            iconsCV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            iconsCV.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.07)
        ])
    }
}
