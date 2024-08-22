//
//  PlayPianoView.swift
//  MRPiano
//
//  Created by blue ken on 2024/08/23.
//

import SwiftUI
import Combine

struct PlayPianoView: View {
    @State private var playingMusicDataHandler: PlayingMusicDataHandler
    
    @State private var offsetTime: Double
    @State private var middleTime: Double
    @State private var isCorrectFinger: Bool
    @State private var isCorrectMusic: Bool
    
    @State private var playMIDI: PlayMIDI
    
    @State private var playing: Bool = false
    @State private var progressPublisher: AnyCancellable?
    @State private var initialMiddleTime: Double = 0.0
    @State private var playbackStartTime: Date?
    
    init(playingMusicDataHandler: PlayingMusicDataHandler) {
        self.playingMusicDataHandler = playingMusicDataHandler
        self.offsetTime = playingMusicDataHandler.getOffsetTime()
        self.middleTime = playingMusicDataHandler.getMiddleTime()
        self.isCorrectFinger = playingMusicDataHandler.getIsCorrectFinger()
        self.isCorrectMusic = playingMusicDataHandler.getIsCorrectMusic()
        self.playMIDI = PlayMIDI(midiFileName:  playingMusicDataHandler.getMidiFileName())
    }
    
    var body: some View {
        VStack{
            List {
                Section(header: Text("Config")
                    .font(.title)
                    .padding(12)
                ){
                    HStack{
                        Picker("開始までの猶予", selection: $offsetTime) {
                            ForEach(0..<11) {
                                Text("\($0)s").tag(Double($0))
                            }
                        }
                        .onChange(of: offsetTime) {
                            playingMusicDataHandler.setOffsetTime(offsetTime: offsetTime)
                        }
                    }
                    Toggle("運指を表示", isOn: $isCorrectFinger)
                        .onChange(of: isCorrectFinger) {
                            playingMusicDataHandler.changeIsCorrectFinger()
                        }
                    Toggle("正しい音楽を演奏", isOn: $isCorrectMusic)
                        .onChange(of: isCorrectMusic) {
                            playingMusicDataHandler.changeIsCorrectMusic()
                        }
                }
            }
            ProgressView(value: middleTime,total: playingMusicDataHandler.getEndTime())
                .tint(.white)
                .frame(height: 20)
                .scaleEffect(x: 1, y: 40, anchor: .center)
                .clipShape(Capsule())
                .padding(24)
            HStack{
                VStack{
                    Button(action: {
                        middleTime = 0.0
                        playingMusicDataHandler.setMiddleTime(middleTime: middleTime)
                    }) {
                        Image(systemName: "backward")
                            .padding(24)
                    }
                    Text("最初に戻る")
                }
                VStack{
                    Button(action: {
                        if playingMusicDataHandler.getMiddleTime() > 1.0 {
                            middleTime -= 1.0
                        } else {
                            middleTime = 0.0
                        }
                        playingMusicDataHandler.setMiddleTime(middleTime: middleTime)
                    }) {
                        Image(systemName: "gobackward")
                            .padding(24)
                    }
                    Text("少し前に戻る")
                }
                .padding(24)
                VStack{
                    Button(action: {
                        
                        print("offset\t \(playingMusicDataHandler.getOffsetTime())")
                        print("middle\t \(playingMusicDataHandler.getMiddleTime())")
                        print("Finger\t \(playingMusicDataHandler.getIsCorrectFinger())")
                        print("Music\t \(playingMusicDataHandler.getIsCorrectMusic())")
                        
                        playing.toggle()
                        if playing {
                            // ノーツ表示・運指表示に関しては、offsetTimeを待たずに処理を開始する
                            // 正解音声と進行バーについてはoffsetTimeを待ってから処理を開始する
                            Thread.sleep(forTimeInterval: playingMusicDataHandler.getOffsetTime())
                            if isCorrectMusic {
                                playMIDI.play(middleTime: playingMusicDataHandler.getMiddleTime())
                            }
                            initialMiddleTime = middleTime
                            playbackStartTime = Date()
                            startProgressPublisher()
                        } else {
                            if isCorrectMusic {
                                playMIDI.stop()
                            }
                            stopProgressPublisher()
                        }
                    }) {
                        if !playing {
                            Image(systemName: "play.fill")
                                .font(.title)
                                .padding(24)
                        } else {
                            Image(systemName: "pause.fill")
                                .font(.title)
                                .padding(24)
                        }
                        
                    }
                    if !playing{
                        Text("スタート")
                    } else {
                        Text("ストップ")
                    }
                }
                VStack{
                    Button(action: {
                        middleTime += 1.0
                        playingMusicDataHandler.setMiddleTime(middleTime: middleTime)
                    }) {
                        Image(systemName: "goforward")
                            .padding(24)
                    }
                    Text("少し先に進む")
                }
                .padding(24)
            }
        }
        .navigationTitle("\(playingMusicDataHandler.getTitle())/\(playingMusicDataHandler.getComposer())")
    }
    
    private func startProgressPublisher() {
        progressPublisher = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                guard let startTime = playbackStartTime else { return }
                let elapsedTime = Date().timeIntervalSince(startTime)
                middleTime = max(0.0, initialMiddleTime + elapsedTime)
                playingMusicDataHandler.setMiddleTime(middleTime: middleTime)
            }
    }
    
    private func stopProgressPublisher() {
        progressPublisher?.cancel()
        progressPublisher = nil
    }
}

struct PlayPianoView_Previews: PreviewProvider {
    static var previews: some View {
        PlayPianoView(playingMusicDataHandler: PlayingMusicDataHandler(musicData: MusicData(
            title: "楽曲名",
            composer: "作者名",
            csvFileName: "csvファイル名",
            midiFileName: "midiファイル名",
            offsetTime: 0.0,
            middleTime: 0.0,
            isCorrectFinger: true,
            isCorrectMusic: true
        )))
    }
}
