//
//  TrackControllerView.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 11.09.22.
//

import UIKit
import MarqueeLabel

class TrackControllerView: UIView {
    
    //MARK: - Variables
    weak var delegate: TrackControllerViewDelegate?
    var isPlaying: Bool = true

    //MARK: - UI Elements
    private lazy var volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    lazy var titleLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.type = .continuous
        label.textAlignment = .left
        label.speed = .duration(80)
        label.fadeLength = 15.0
        label.leadingBuffer = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        return label
    }()
    
    lazy var artistLabel = createLabel(textColor: .gray, fontSize: 20, fontWeight: .semibold)
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: UIImage.SymbolWeight.regular))
        button.setImage(image, for: .normal)
        button.tag = 1
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 38, weight: UIImage.SymbolWeight.regular))
        button.setImage(image, for: .normal)
        button.tag = 2
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var forwardButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: UIImage.SymbolWeight.regular))
        button.setImage(image, for: .normal)
        button.tag = 3
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var volumeDownImage = createImageView(imageName: "speaker.wave.1.fill")
    private lazy var volumeUpImage = createImageView(imageName: "speaker.wave.3.fill")
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "ellipsis")
        button.backgroundColor = .gray
        button.setImage(image, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Functions
    private func setupUI() {
        backgroundColor = .darkGray
        
        addSubview(titleLabel)
        addSubview(artistLabel)
        addSubview(volumeSlider)
        addSubview(backButton)
        addSubview(playButton)
        addSubview(forwardButton)
        addSubview(volumeDownImage)
        addSubview(volumeUpImage)
        addSubview(settingsButton)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.right.equalTo(settingsButton.snp.left).offset(-15)
            make.top.equalToSuperview().offset(10)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-25)
            make.width.height.equalTo(30)
        }
        
        artistLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        
        playButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(artistLabel.snp.bottom).offset(20)
            make.width.height.equalTo(130)
        }
        
        backButton.snp.makeConstraints { make in
            make.right.equalTo(playButton.snp.left).offset(-10)
            make.centerY.equalTo(playButton.snp.centerY)
            make.width.height.equalTo(100)
        }
        
        forwardButton.snp.makeConstraints { make in
            make.left.equalTo(playButton.snp.right).offset(10)
            make.centerY.equalTo(playButton.snp.centerY)
            make.width.height.equalTo(100)
        }
        
        volumeSlider.snp.makeConstraints { make in
            make.left.equalTo(volumeDownImage.snp.right).offset(10)
            make.right.equalTo(volumeUpImage.snp.left).offset(-10)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        volumeDownImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.centerY.equalTo(volumeSlider.snp.centerY)
            make.width.height.equalTo(18)
        }
        
        volumeUpImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-25)
            make.centerY.equalTo(volumeSlider.snp.centerY)
            make.height.equalTo(18)
        }
    }
    
    private func changeButtonIcon(_ sender: UIButton) {
        if isPlaying {
            UIView.animate(withDuration: 0.2, animations: {
                sender.alpha = 0.0
            }, completion:{(finished) in
                sender.setImage(UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 38, weight: UIImage.SymbolWeight.regular)), for: .normal)
                UIView.animate(withDuration: 0.5, animations:{
                    sender.alpha = 1.0
                },completion:nil)
            })
            isPlaying = false
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                sender.alpha = 0.0
            }, completion:{(finished) in
                sender.setImage(UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 38, weight: UIImage.SymbolWeight.regular)), for: .normal)
                UIView.animate(withDuration: 0.5, animations:{
                    sender.alpha = 1.0
                },completion:nil)
            })
            isPlaying = true
        }
    }
    
    @objc
    private func didTapButton(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            delegate?.didTapBackButton(self)
        case 2:
            delegate?.didTapPlayButton(self)
            changeButtonIcon(sender)
        case 3:
            delegate?.didTapForwardButton(self)
        default: return 
        }
    }
}
