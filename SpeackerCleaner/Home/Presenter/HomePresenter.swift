//
//  HomePresenter.swift
//  SpeackerCleaner
//
//  Created by Nurym Siyrbayev on 04.12.2022.
//

import Foundation
import UIKit
import AVFoundation

//typealias PresenterDelegate = HomePresenterDelegate & UIViewController

protocol HomePresenterProtocol {
    
    func setViewDelegate(delegate: HomeViewDelegate)
    func onDidTapStartButton()
    func onDidTapCancelButton()
    func onAppMovedToBackground()
}

final class HomePresenter {
    
    // MARK: Private
    
    weak private var delegate: HomeViewDelegate?
    
    private var timer = Timer()
    private var durationTimer = 30
    private var audioPlayer: AVAudioPlayer?
}

// MARK: Public func

extension HomePresenter: HomePresenterProtocol {
    
    func setViewDelegate(delegate: HomeViewDelegate) {
        self.delegate = delegate
    }
    
    func onDidTapStartButton() {
        
        guard let pathToSound = Bundle.main.path(forResource: "Speacker Clean Sound", ofType: "mp3") else { return }
        
        delegate?.presentSoundTimer()
        
        let url = URL(fileURLWithPath: pathToSound)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print(error)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    func onDidTapCancelButton() {
        stopClean()
    }
    
    func onAppMovedToBackground() {
        stopClean()
    }
}

// MARK: Private func

private extension HomePresenter {
    
    func stopClean() {
        audioPlayer?.stop()
        timer.invalidate()
        durationTimer = 30
        delegate?.onStopTimer()
    }
    
    @objc private func timerAction() {
        
        durationTimer -= 1
        delegate?.updateTimerLabel(String(durationTimer))
        
        if durationTimer == 0 {
            timer.invalidate()
            durationTimer = 30
            delegate?.onStopTimer()
            
            audioPlayer?.stop()
        }
    }
}
