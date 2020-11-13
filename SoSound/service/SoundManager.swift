//
//  SoundManager.swift
//  SoSound
//
//  Created by David on 7/14/17.
//  Copyright © 2017 Reverie. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

public protocol SoundManagerDelegate {

    func musicFinished(error: Bool)
    func musicPlayStatus(song: Song, songPlayTime: Int32)
}

class SoundManager: NSObject, AVAudioPlayerDelegate {

    private var _player: AVAudioPlayer!
    private var _nextPlayer: AVAudioPlayer!
    var _masterVolume: Float = 1
    var _activeMusic: MusicTile?
    var _currentSongIndex = 0
    var _delegate: SoundManagerDelegate?
    var _demoPlaying = false
    var _timerSeconds: Int32 = 0
    var progressTimer: Timer?

    override init() {
        super.init()

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback,
                    mode: AVAudioSession.Mode.default,
                    options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print("Failed to set the audio session category and mode: \(error.localizedDescription)")
        }
    }

    /**
     Play the first song assigned assigned to a music tile
     */
    func playMusic(music: MusicTile, delegate: SoundManagerDelegate) -> Bool {

        _activeMusic = music
        _currentSongIndex = 0
        print("playMusic TransitionSong");
        return transitionSong(url: MusicManager().songURL(song: _activeMusic?.songs!.object(at: 0) as! Song), delegate: delegate)
    }

    func play(url: URL) -> Bool {
        var result = true
//        log("playing \(url.lastPathComponent)")
        log("func play...playing \(url)")

        do {
            if let timer = progressTimer {
                timer.invalidate()
            }

            _player = try AVAudioPlayer(contentsOf: url)
            _player.prepareToPlay()
            _player.volume = 0
            if url == songSoSoundURL {
                _player.setVolume(_masterVolume, fadeDuration: 5)
                _player.numberOfLoops = -1
            } else {
                _player.setVolume(1, fadeDuration: 5)
            }
            _player.play()

        } catch let error as NSError {
            log("Error playing song - " + url.lastPathComponent)
            result = false
        } catch {
            log("AVAudioPlayer init failed")
            result = false
        }
        return result
    }

    func isMusicPlaying() -> Bool {
        return _player.isPlaying;
    }

    func transitionSong(url: URL, delegate: SoundManagerDelegate?) -> Bool {
        var result = true
        log("transitionSong  transition to \(url.lastPathComponent)")

        do {
            self._demoPlaying = false
            self._delegate = delegate
            _nextPlayer = try AVAudioPlayer(contentsOf: url)
            _nextPlayer.volume = 0
            _nextPlayer.delegate = self
            _nextPlayer.prepareToPlay()
            _nextPlayer.play()
           // if url == songSoSoundURL {
                _nextPlayer.numberOfLoops = 1440//max 24 hours
           // }
            // fade up
            _nextPlayer.setVolume(_masterVolume, fadeDuration: 10)
            // fade to 0
            _player.setVolume(0, fadeDuration: 10)
            Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(SoundManager.updatePlayer), userInfo: nil, repeats: false)
            _timerSeconds = 0

            if let timer = progressTimer {
                timer.invalidate()
            }
            if url != songSoSoundURL {
                progressTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SoundManager.updateProgress), userInfo: nil, repeats: true)
            }
        } catch let error as NSError {
            //player = nil
            log("Error playing song - " + url.lastPathComponent)
            result = false
        } catch {
            log("AVAudioPlayer init failed")
            result = false
        }
        return result
    }


    func transitionFromDemoToSO() {

        do {
            _demoPlaying = false
            _nextPlayer = try AVAudioPlayer(contentsOf: songSoSoundURL!)
            _nextPlayer.prepareToPlay()
            _nextPlayer.volume = 0
            _nextPlayer.delegate = nil
            _nextPlayer.play()
            _nextPlayer.setVolume(_masterVolume, fadeDuration: 3)
            _nextPlayer.numberOfLoops = -1
            _player.setVolume(0, fadeDuration: 3)
            _player = _nextPlayer
            Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(SoundManager.updatePlayer), userInfo: nil, repeats: false)

        } catch let error as NSError {
            //player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }

    func transitionToDemo(url: URL) {
        print("transitioning to \(url)")

        do {

            if _demoPlaying {
                transitionFromDemoToSO()
                return
            }
            _demoPlaying = true
            _nextPlayer = try AVAudioPlayer(contentsOf: url)
            _nextPlayer.prepareToPlay()
            _nextPlayer.delegate = self
            _nextPlayer.volume = 0
            _nextPlayer.play()
//            nextPlayer.setVolume(masterVolume, fadeDuration: 10)
//            player.setVolume(0, fadeDuration: 5)
            if url == songSoSoundURL {
                _nextPlayer.setVolume(_masterVolume, fadeDuration: 10)
                _nextPlayer.numberOfLoops = -1
            } else {
                _nextPlayer.setVolume(_masterVolume, fadeDuration: 10)
            }
            _player.setVolume(0, fadeDuration: 10)

            Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(SoundManager.updatePlayer), userInfo: nil, repeats: false)
        } catch let error as NSError {
            //player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        var done = false;

        if flag == true {

            if let music = _activeMusic, let songs = music.songs, _currentSongIndex + 1 < songs.count {
                _currentSongIndex += 1
                print("audioPlayerDidFinishPlaying transitionSong")
                transitionSong(url: MusicManager().songURL(song: songs.object(at: _currentSongIndex) as! Song), delegate: _delegate)
            } else {
                done = true
            }
        } else {
            done = true
        }

        if done {
            if _demoPlaying {
                _demoPlaying = false
                print("done....audioPlayerDidFinishPlaying transitionSong")
                transitionSong(url: songSoSoundURL!, delegate: nil)
            } else if let d = _delegate {
                _delegate?.musicFinished(error: flag)
            }

        }
    }

    func changeVolume(vol: Float) {
        if _player.url == songSoSoundURL {
            _masterVolume = vol
        }
        _player.volume = vol
    }

    @objc func updatePlayer() {
        _player = _nextPlayer
    }

    @objc func updateProgress() {

        if isMusicPlaying(), let d = _delegate, let songs = _activeMusic!.songs {
            _timerSeconds += 1
            _delegate?.musicPlayStatus(song: songs[_currentSongIndex] as! Song, songPlayTime: _timerSeconds)
        }
    }

    func pause() {

        _player.pause()
        if _nextPlayer != nil && _nextPlayer.isPlaying {
            _nextPlayer.pause()
        }
    }

    func pauseWithFade() {

        if _player != nil {
            _player.setVolume(0, fadeDuration: TimeInterval(2))
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2 + 1), execute: {
                self._player.pause()
            })
        }
    }

    func resume() {

        _player.volume = _masterVolume
        _player.play()
    }

    func resumeWithFade() {

        if _player != nil {
            _player.setVolume(_masterVolume, fadeDuration: TimeInterval(2))
            _player.play()
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionMode(_ input: AVAudioSession.Mode) -> String {
    return input.rawValue
}
