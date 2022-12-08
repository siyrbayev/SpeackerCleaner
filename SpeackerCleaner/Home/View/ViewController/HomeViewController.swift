//
//  HomeViewController.swift
//  SpeackerCleaner
//
//  Created by Nurym Siyrbayev on 04.12.2022.
//

import UIKit

protocol HomeViewDelegate: AnyObject {
    
    func presentSoundTimer()
    func updateTimerLabel(_ text: String)
    func onStopTimer()
}

class HomeViewController: UIViewController {
    
    // MARK: Private
    
    private let presenter: HomePresenterProtocol = HomePresenter()
    
    // MARK: UI Elements
    
    private let notificationCenter = NotificationCenter.default
    private var shapeLayer = CAShapeLayer()
    private var savedShapeLayer: CAShapeLayer? = nil
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        
        label.text = "30"
        label.font = UIFont.boldSystemFont(ofSize: 84)
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let speakerCleningLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Please, do not close application while cleaning"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let startLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Please, press Start button to clean speackers"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "speacker"), for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 64
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = UIColor.black
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let audioWaveImageView: UIImageView = {
        let gifImage = UIImage.gifImageWithName("audio-wave-thin")
        let image = UIImageView(image: gifImage)
        
        
        image.transform = CGAffineTransform(scaleX: 0.8, y: 0.4)
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    // MARK: Life Cicle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        presenter.setViewDelegate(delegate: self)
        
        configureStartButton()
        configureCancelButton()
        configureTimerLabel()
        configureAudioWaveImageView()
        configureSpeakerCleningLabel()
        configureShapeLayer()
        
        setConstraints()
        
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIScene.willDeactivateNotification, object: nil)

    }
    
    @objc func appMovedToBackground() {
        presenter.onAppMovedToBackground()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animationCircular()
    }
}

// MARK: HomeViewDelegate

extension HomeViewController: HomeViewDelegate {
    
    func presentSoundTimer() {
        startButton.isHidden = true
        startLabel.isHidden = true
        shapeLayer.isHidden = false
        cancelButton.isHidden = false
        audioWaveImageView.isHidden = false
        timerLabel.isHidden = false
        speakerCleningLabel.isHidden = false
        animationCircular()
        
        basicAnimation()
    }
    
    func updateTimerLabel(_ text: String) {
        timerLabel.text = String(text)
    }
    
    func onStopTimer() {
        self.timerLabel.text = "30"
        self.startButton.isHidden = false
        startLabel.isHidden = false
        shapeLayer.isHidden = true
        self.timerLabel.isHidden = true
        self.audioWaveImageView.isHidden = true
        self.cancelButton.isHidden = true
        self.speakerCleningLabel.isHidden = true
    }
}

// MARK: Private func

private extension HomeViewController {
    
    func configureStartButton() {
        
        startButton.addTarget(self, action: #selector(onTouchUpInsideStartButton), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(onTouchDragOutsideStartButton), for: .touchDragOutside)
        startButton.addTarget(self, action: #selector(onTouchDragInsideStartButton), for: .touchDragInside)
        startButton.addTarget(self, action: #selector(onTouchDownStartButton), for: .touchDown)
    }
    
    func configureCancelButton() {
        cancelButton.isHidden = true
        cancelButton.addTarget(self, action: #selector(onTouchUpInsideCancelButton), for: .touchUpInside)
    }
    
    func configureTimerLabel() {
        timerLabel.isHidden = true
    }
    
    func configureAudioWaveImageView() {
        audioWaveImageView.isHidden = true
    }
    
    func configureSpeakerCleningLabel() {
        speakerCleningLabel.isHidden = true
    }
    
    func configureShapeLayer() {
        shapeLayer.isHidden = true
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = UIColor.black.cgColor
    }
    
    func setConstraints() {
        
        view.addSubview(timerLabel)
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            timerLabel.heightAnchor.constraint(equalToConstant: 196),
            timerLabel.widthAnchor.constraint(equalToConstant: 196)
        ])
        
        view.addSubview(audioWaveImageView)
        NSLayoutConstraint.activate([
            audioWaveImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            audioWaveImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            
        ])
        
        view.addSubview(startLabel)
        NSLayoutConstraint.activate([
            startLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            startLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            startLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 64)
        ])
        
        view.addSubview(speakerCleningLabel)
        NSLayoutConstraint.activate([
            speakerCleningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            speakerCleningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            speakerCleningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            speakerCleningLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 64)
        ])
        
        view.addSubview(startButton)
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 128),
            startButton.widthAnchor.constraint(equalToConstant: 128)
        ])
        
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func onTouchDragOutsideStartButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 2,
                       options: .curveEaseIn,
                       animations: {
            
            sender.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }, completion: nil)
    }
    
    @objc private func onTouchDragInsideStartButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseIn,
                       animations: {
            
            sender.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
            
        }, completion: nil)
    }
    
    @objc private func onTouchDownStartButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseIn,
                       animations: {
            
            sender.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
            
        }, completion: nil)
       
    }
    
    @objc private func onTouchUpInsideStartButton(_ sender: UIButton) {
        let compleation: (Bool) -> Void = { [weak self] _ in
            self?.presenter.onDidTapStartButton()
        }
        springAnimateView(with: sender, compleation: compleation)
    }
    
    private func springAnimateView(with viewToAnimate: UIView, compleation: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseIn,
                       animations: {
            
            viewToAnimate.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
            
        }) { _ in
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 2,
                           options: .curveEaseIn,
                           animations: {
                
                viewToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            }, completion: compleation)
        }
    }
    
    @objc private func onTouchUpInsideCancelButton(_ sender: UIButton) {
        let compleation: (Bool) -> Void = { [weak self] _ in
            self?.presenter.onDidTapCancelButton()
        }
        
        springAnimateView(with: sender, compleation: compleation)
    }
    
    func animationCircular() {
        
        let center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        
        
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: 96,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: false)
        
        shapeLayer.path = circularPath.cgPath
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func basicAnimation() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(30)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
}
