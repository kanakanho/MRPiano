# CsvToView

## 注意事項

本プロジェクトではsoundfontを利用していますが、ファイル容量が大きいためgithubでの利用ができません
[こちらのサイトのファイル](https://drive.google.com/file/d/1p0jY3AgGyD9DJGWC25aEUEaydI_n1-3M/view)をお借りしていますので、[こちらの記事](https://qiita.com/kanakanho/items/85559f32e3eea5c26bca)などを参考にプロジェクトに追加してください

# 画面構成
## 全体画面
![全体画面](https://img.esa.io/uploads/production/attachments/21734/2024/08/23/148413/20dd3777-21dd-4390-9120-bf1861f47bec.png)

## 起動時の画面
![起動時の画面](https://img.esa.io/uploads/production/attachments/21734/2024/08/23/148413/88c404c4-a507-48ba-8652-905ab7d0dd63.png)

## 右側のリスト
楽曲リストと楽器リストからなる

### 楽曲リスト
楽曲名が記載され、練習したい楽器を選択する

楽曲が追加された際を考慮してリスト形式にしています
楽曲データは`DataHandler/MusicDatas.swift`に以下の形式で追記することで追加できます
```swift
init() {
    let musicData = MusicData(
        title: "楽曲名", // 楽曲の名前
        composer: "作曲者", // 楽曲の作者
        csvFileName: "notes_minuet_utf8_encoded", // csvのファイル名
        midiFileName: "bach-menuet", // midiのファイル名
        offsetTime: 2.0, // 始まりまでのオフセットの時間
        middleTime: 0.0, // 途中から再開するときの再開する時間
        isCorrectFinger: true, // 運指の表示を行うか
        isCorrectMusic: true // 演奏時に正しい音楽をやるか
    )
    
    playingMusicDataHandlers.append(PlayingMusicDataHandler(musicData: musicData))
}
```

### 楽器リスト
Pianoがトグルボタンで存在し、これをオンにするとイマーシブ空間にピアノが表示され、演奏が可能になる

練習の譜面を開かなくてもピアノを出して音が出せるような状態とするためにこのような配置にしています
将来的に現実と即したピアノ練習をする際にはこちらで、別のトグルを用意できたらよいかと考えています

## 楽曲選択後の画面
![楽曲選択後の画面](https://img.esa.io/uploads/production/attachments/21734/2024/08/23/148413/855da1b0-0257-46c6-beee-3b267687f34d.png)

上から順番に以下のような配置になっています
- 楽曲名/作曲者という形で楽曲の説明
- 練習の中で変更する各種設定
- 練習の箇所を選択するボタン

### タイトル（楽曲名/作曲者）
上記の`MusicDatas.swift`に書かれた情報を元に楽曲情報の説明が書かれます

### 設定事項
上記の`MusicDatas.swift`に書かれた情報が読み込まれ、初期状態として配置されます
変更を行うとアプリを終了してもその設定が引き継がれるようになっています

- 開始までの猶予時間
    - menu形式で 0s~10s の間で選択できる
<details><summary>猶予時間に関する設定の画面</summary>

![開始までの猶予時間](https://img.esa.io/uploads/production/attachments/21734/2024/08/23/148413/1dd8652c-e644-4f42-808a-ffd2c8e45880.png)
</details>

- 運指を表示のトグルボタン
    - 運指の実装をした際にそのフラグを提供する
- 正解音源の再生のトグルボタン
    - 正解音源を実際に再生するかの判定を行う

### シークバー
楽曲のどこを練習しているのかが可視化します
- 4つのボタンでそれぞれ以下の設定ができる
    - 最初（0.0s）に戻る
    - 少し前（-1.0s）戻る
    - 練習の開始
    - 少し後（+1.0s）進む
- 練習を途中で止めた場合、止めた時間が保存され、次回の再生はそこから始まる

> [!WARNING]
> **練習の開始について**  
練習の開始のボタンを押すと、猶予時間が発生し、その間画面が操作できなくなります。しかし、このタイミングでもう一度スタートボタンを押すと猶予時間終了後即座に、終了の処理が走るため問題ないと考えます。

# フォルダ構成
## 全体構成と簡略説明
\*があるものについては後ろで詳しく説明をする
```shell
.
├── ContentView.swift // アプリの最初に起動した画面、および全体で共有するデータを保持 *
├── CsvToViewApp.swift // Appの初期設定の通り、必要に応じて書き換え
├── DataHandler // アプリで利用するデータを全て管理する *
│   ├── FileDataHandler // ファイルからのデータの抽出と加工を行う
│   │   ├── CsvDataHandler.swift // csvからデータを抽出し、DataFrameに変換、DataFrameに関する処理を行う
│   │   └── NotesDataHandler.swift　// DataFrameからデータを抽出し、ノーツおよび判定に利用可能な状態に変換する　*
│   ├── MusicDatas.swift // アプリ全体でのデータの共有を行う *
│   └── PlayingMusicDataHandler.swift // 実際にデータの操作を行う *
├── FileData // アプリで利用するファイルを保管する
│   ├── bach-menuet.midi
│   └── notes_minuet_utf8_encoded.csv
├── ImmersiveView.swift // 必要に応じて変更
├── PlayPianoSound // ピアノの音を鳴らす処理を記述する *
│   └── PlayMIDI.swift // MIDIファイルを元に音を鳴らす処理を行う *
└── PlayPianoView // ピアノの練習を行う画面
    └── PlayPianoView.swift // ピアノの練習を行う画面 *
```

## DataHandler
アプリで利用するデータを全て管理する

### `NotesDataHandler.swift`
ノーツの生成や判定に必要なデータを作成します

`PlayingMusicDataHandler`を通じて呼び出され、利用されるのを想定しています。

### `PlayingMusicDataHandler.swift`
楽曲ごとに存在する演奏、練習、判定に必要な全てのデータを持ち、その変更を行う構造体を持つ

#### 現時点で持っている楽曲のデータ（適宜追加）
```swift
struct MusicData: Identifiable {
    var id = UUID()
    var title: String // 楽曲の名前
    var composer: String // 楽曲の作者
    var csvFileName: String // csvのファイル名
    var midiFileName: String // midiのファイル名
    var offsetTime: Double // 始まりまでのオフセットの時間
    var middleTime: Double // 途中から再開するときの再開する時間
    var isCorrectFinger: Bool // 運指の表示を行うか
    var isCorrectMusic: Bool // 演奏時に正しい音楽をやるか
}
```

これらの取得と変更の保存を行うメソッドを持ちます

#### ノーツの生成および、練習の評価
ノーツの生成および、練習判定の評価は`PlayingMusicDataHandler`が持つ`NotesDataHandler`を使って行います
別でインスタンス化は行いません

ノーツの生成および、練習の評価において必要なデータが増えた場合、それを返すメソッドを`NotesDataHandler`に追加します

### `MusicDatas.swift`
アプリ全体でのデータの共有を行う

`PlayingMusicDataHandler`のデータを配列として持つ

## `ContentView.swift`
アプリの最初に起動した画面、および全体で共有するデータを保持

`MusicDatas`の情報を元に、楽曲一覧のリスト表示を行う。楽曲選択時に楽曲情報を`MusicDatas`から読み込み、`PlayPianoView`に受け渡します。

## `PlayPianoView.swift`
ピアノの練習を行う画面

`ContentView`で選択された楽曲について、`MusicDatas`を参照し、`PlayingMusicDataHandler`のデータを元に練習に必要な情報の提供、設定の変更を行う

## `PlayPianoSound`
ピアノの音を鳴らす処理を記述します。（MIDIファイルから鳴らすものと鍵盤を元に鳴らすものの両方を予定）

### `PlayMIDI.swift`
MIDIファイルを元に音を鳴らす処理を行う

`PlayPianoView`で`PlayingMusicDataHandler`から鳴らすMIDIファイルの情報を取得し、初期化を行います。正解音源のフラグが存在する状態で練習を始めたときにMIDIからの音楽の再生を行います。練習を中断すると停止されます。
