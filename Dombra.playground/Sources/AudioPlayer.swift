import Foundation
import AVFoundation

// AudioPlayer - the structure that interacts with the AVFoundation
public struct AudioPlayer {
    // MARK:- Properties
    public static var backgroundAudioPlayer: AVAudioPlayer = {
        let player = AVAudioPlayer()
        player.numberOfLoops = -1
        return player
    }()
    public static var metronomeAudioPlayer: AVAudioPlayer = {
        let player = AVAudioPlayer()
        player.numberOfLoops = -1
        return player
    }()
    public static var firstStringPlayer = AVAudioPlayer()
    public static var secondStringPlayer = AVAudioPlayer()
    
    
    // MARK:- Background Audio
    public static func turnOnBackgroundMusic() {
        let url = URL(fileReferenceLiteralResourceName: "Qosalqa.mp3")
        do {
            backgroundAudioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            return
        }
        backgroundAudioPlayer.play()
    }
    
    
    // MARK:- The Dombra Strings
    public static func playFirstStringNote(_ index: Int) {
        let url = URL(fileReferenceLiteralResourceName: "u\(index).m4a")
        do {
            firstStringPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            return
        }
        firstStringPlayer.play()
    }
    
    public static func playSecondStringNote(_ index: Int) {
        let url = URL(fileReferenceLiteralResourceName: "d\(index).m4a")
        do {
            secondStringPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            return
        }
        secondStringPlayer.play()
    }
    
    public static func playMetronomeBeat() {
        let url = URL(fileReferenceLiteralResourceName: "beat.mp3")
        do {
            metronomeAudioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            return
        }
        metronomeAudioPlayer.play()
    }
}

