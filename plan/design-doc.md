# 技術設計書: Stillness Garden

## 技術スタック

| 項目             | 選定内容                         |
| ---------------- | -------------------------------- |
| 言語             | Processing (Java Mode)           |
| バージョン制約   | Processing 2.2.1 で動作必須      |
| レンダラー       | P2D（blendMode対応のため）       |
| 外部ライブラリ   | 使用しない（標準機能のみ）       |
| フレームレート   | 60fps                            |

## バージョン制約について

学校環境の Processing 2.2.1 で動作する必要がある。
以下の制約に注意すること。

### 使用不可の機能

- Java 8 以降の構文（ラムダ式、ストリームAPI）
- Processing 3.x 以降で追加された関数
- 外部ライブラリへの依存

### 使用可能な機能

- 基本的なProcessing関数（ellipse, line, rect, etc.）
- PVector クラス
- ArrayList
- 基本的なクラス定義とオブジェクト指向

---

## ファイル構成

```text
stillness-garden/                  # リポジトリのルート
├── stillness_garden/              # Processingプロジェクトフォルダ
│   ├── stillness_garden.pde       # メインファイル（setup, draw）
│   ├── Seed.pde                   # 種クラス
│   ├── Branch.pde                 # 枝クラス
│   ├── Flower.pde                 # 花クラス
│   ├── Particle.pde               # 粒子クラス（花粉・灰）
│   └── Plant.pde                  # 植物全体を管理するクラス
└── plan/
    ├── initial-requirements.md
    ├── requirements.md
    └── design-doc.md
```

Processingはプロジェクトフォルダ名とメインの.pdeファイル名が一致している必要がある。

---

## クラス設計

### Seed（種）

種の位置と状態を管理するクラス。
マウスが停止している位置に出現し、白く発光する。
マウスが動くと消滅し、植物全体の灰化が始まるトリガーとなる。

| 区分 | 名前 | 型 | 説明 |
| ---- | ---- | --- | ---- |
| プロパティ | position | PVector | 種の位置（マウス停止位置） |
| プロパティ | alive | boolean | 存在しているかどうか |
| プロパティ | glowSize | float | 発光エフェクトのサイズ |
| メソッド | update() | void | 状態の更新処理 |
| メソッド | display() | void | 発光エフェクト付きで描画 |
| メソッド | die() | void | 種を消滅させる |

### Branch（枝）

1本の枝の成長と灰化を管理するクラス。
種の位置から有機的に曲がりながら伸びる蔦のような形状。
灰化時は根本から先端に向かって消えていき、灰の粒子を発生させる。

| 区分 | 名前 | 型 | 説明 |
| ---- | ---- | --- | ---- |
| プロパティ | points | ArrayList of PVector | 枝を構成する点の列 |
| プロパティ | growing | boolean | 成長中かどうか |
| プロパティ | dying | boolean | 灰化中かどうか |
| プロパティ | ashProgress | float | 灰化の進行度（0.0〜1.0） |
| プロパティ | angle | float | 現在の成長方向（角度） |
| プロパティ | baseColor | color | 枝の色（淡い緑） |
| メソッド | grow() | void | 先端を伸ばす成長処理 |
| メソッド | startDying() | void | 灰化を開始する |
| メソッド | updateDying() | void | 灰化の進行を更新 |
| メソッド | display() | void | グロー効果付きで描画 |
| メソッド | isFullyDead() | boolean | 完全に消えたか判定 |
| メソッド | isReadyForFlower() | boolean | 花を咲かせる準備ができたか |
| メソッド | getTip() | PVector | 枝の先端位置を取得 |

### Flower（花）

枝の先端に咲く花を管理するクラス。
5〜6枚の花びらを持ち、淡いピンク色で描画される。
開花アニメーションがあり、灰化時は花びらから粒子を発生させながら消える。

| 区分 | 名前 | 型 | 説明 |
| ---- | ---- | --- | ---- |
| プロパティ | position | PVector | 花の位置（枝の先端） |
| プロパティ | petalCount | int | 花びらの数（5〜6枚） |
| プロパティ | size | float | 花のサイズ |
| プロパティ | bloomProgress | float | 開花の進行度（0.0〜1.0） |
| プロパティ | dying | boolean | 灰化中かどうか |
| プロパティ | rotation | float | 花の回転角度 |
| プロパティ | petalColor | color | 花びらの色（淡いピンク） |
| メソッド | bloom() | void | 開花を進行させる |
| メソッド | startDying() | void | 灰化を開始する |
| メソッド | updateDying() | void | 灰化の進行を更新 |
| メソッド | display() | void | 花びらをグロー効果付きで描画 |
| メソッド | isFullyBloomed() | boolean | 完全に開花したか判定 |
| メソッド | isDead() | boolean | 完全に消えたか判定 |

### Particle（粒子）

花粉と灰の粒子を管理するクラス。
花粉は花や枝の先端から発生し、ふわふわと漂う。
灰は灰化部分から発生し、重力に従ってゆっくり落ちる。
どちらも3〜5秒でフェードアウトして消える。

| 区分 | 名前 | 型 | 説明 |
| ---- | ---- | --- | ---- |
| プロパティ | position | PVector | 粒子の位置 |
| プロパティ | velocity | PVector | 粒子の速度 |
| プロパティ | lifespan | float | 残り寿命（フレーム数） |
| プロパティ | maxLifespan | float | 最大寿命（フレーム数） |
| プロパティ | particleType | int | 粒子の種類（0: 花粉、1: 灰） |
| プロパティ | size | float | 粒子のサイズ |
| プロパティ | particleColor | color | 粒子の色 |
| メソッド | update() | void | 位置と寿命を更新 |
| メソッド | display() | void | 透明度を寿命に応じて変化させながら描画 |
| メソッド | isDead() | boolean | 寿命が尽きたか判定 |

粒子の挙動の違い:

- 花粉（type=0）: ランダムな微小な力で漂う、重力なし
- 灰（type=1）: 下方向に重力がかかる、横方向に微小な揺れ

### Plant（植物）

1つの植物全体（種、枝、花、粒子）を統合管理するクラス。
生きている植物と灰化中の植物の両方の状態を扱う。
粒子の生成タイミングや、枝から花への成長遷移を管理する。

| 区分 | 名前 | 型 | 説明 |
| ---- | ---- | --- | ---- |
| プロパティ | seed | Seed | 種のインスタンス |
| プロパティ | branches | ArrayList of Branch | 枝のリスト（5〜8本） |
| プロパティ | flowers | ArrayList of Flower | 花のリスト |
| プロパティ | particles | ArrayList of Particle | 粒子のリスト |
| プロパティ | alive | boolean | 生きているかどうか |
| プロパティ | dying | boolean | 灰化中かどうか |
| プロパティ | branchCount | int | 枝の本数（5〜8のランダム） |
| メソッド | update() | void | 全要素の更新処理 |
| メソッド | display() | void | 全要素の描画処理 |
| メソッド | startDying() | void | 灰化を開始（種が消え、枝の灰化開始） |
| メソッド | isFullyDead() | boolean | 全要素が完全に消えたか判定 |
| メソッド | spawnPollen() | void | 花粉粒子を生成 |
| メソッド | spawnAsh() | void | 灰粒子を生成 |
| メソッド | initBranches() | void | 枝を初期化（5〜8本をランダムな方向に） |

---

## 状態管理

### グローバル状態

メインファイル（stillness_garden.pde）で管理する変数:

```java
Plant currentPlant;              // 現在生きている植物（null可）
ArrayList<Plant> dyingPlants;    // 灰化中の植物リスト
int mouseStoppedFrames;          // マウスが止まっているフレーム数
PVector lastMousePos;            // 前フレームのマウス位置
float mouseThreshold;            // マウス移動判定の閾値（2〜3ピクセル）
```

### マウス状態判定

```java
boolean isMouseMoving() {
  return dist(mouseX, mouseY, lastMousePos.x, lastMousePos.y) > mouseThreshold;
}
```

微小な揺れを無視するため、閾値を設ける。

### 状態遷移

1. マウス停止検知 → 現在位置に新しいPlantを生成
2. マウス移動検知 → currentPlant.startDying()を呼び、dyingPlantsに移動
3. 毎フレーム → dyingPlantsの更新、完全に消えたものは削除

---

## 具体的な数値パラメータ

### 成長・灰化速度

| パラメータ | 値 | 説明 |
| ---------- | --- | ---- |
| 成長速度 | 1.0 px/frame | 60fpsで1秒に60ピクセル伸びる |
| 灰化速度 | 1.5 px/frame | 成長速度の1.5倍 |
| 花が咲く条件 | 25ポイント | 枝のポイント数が25に達したら開花 |

### マウス判定

| パラメータ | 値 | 説明 |
| ---------- | --- | ---- |
| 移動判定閾値 | 2 px | この距離以上動いたら「移動」と判定 |

### 粒子

| パラメータ | 値 | 説明 |
| ---------- | --- | ---- |
| 寿命 | 180〜300 frame | 3〜5秒（60fps換算） |

### 枝の曲がりアルゴリズム

Perlin noise を使用して有機的な曲がりを実現する。

```java
// Branch クラス内
float noiseOffset;  // 各枝ごとに異なる初期値

void grow() {
  // Perlin noise で角度を滑らかに変化させる
  float noiseValue = noise(noiseOffset);
  angle += map(noiseValue, 0, 1, -0.3, 0.3);
  noiseOffset += 0.05;

  // 新しい点を追加
  PVector tip = getTip();
  float newX = tip.x + cos(angle) * growthSpeed;
  float newY = tip.y + sin(angle) * growthSpeed;
  points.add(new PVector(newX, newY));
}
```

Perlin noise の特徴:

- Processing 標準の `noise()` 関数を使用
- 連続的で滑らかな値を生成
- 蔦や植物の自然な曲がりを表現できる

---

## 描画処理

### レイヤー順序

1. 背景（黒）
2. 灰化中の植物（dyingPlants）
3. 現在の植物（currentPlant）
4. 粒子（全植物の粒子）
5. グロー効果（各オブジェクトの描画時に適用）

### グロー効果の実装方針

Processing 2.2.1 で実現可能な方法:

- 各オブジェクトを複数回、異なる透明度とサイズで描画
- 大きく薄い円 → 小さく濃い円の順で重ねる
- blendMode(ADD)を使用して発光感を出す

blendMode(ADD) の注意点:

- デフォルトレンダラー（JAVA2D）では不安定な動作をする
- P2D レンダラーを使用することで安定動作する
- そのため setup() で `size(800, 800, P2D)` を指定する

```java
void drawGlow(float x, float y, float size, color c) {
  noStroke();
  for (int i = 3; i > 0; i--) {
    fill(c, 50 / i);
    ellipse(x, y, size * i, size * i);
  }
  fill(c);
  ellipse(x, y, size * 0.5, size * 0.5);
}
```

---

## パフォーマンス考慮

### 想定される負荷

- 枝: 5〜8本 × 数十ポイント
- 花: 5〜8個
- 粒子: 数十〜数百個
- 灰化中の植物: 0〜数個

### 最適化方針

- 死んだ粒子は即座にリストから削除
- 完全に消えた植物は dyingPlants から削除
- 必要に応じて粒子数に上限を設ける（現時点では不要）

---

## 開発環境

### 推奨環境

- 開発: 最新の Processing IDE または VSCode
- 動作確認: Processing 2.2.1（学校環境と同じ）

### 動作確認環境

- MacBook Pro M3（開発機）
- 学校の Processing 2.2.1 環境（最終確認）

---

## 今後の拡張性

将来の追加実装に備えた設計:

### 育ちすぎると病気

- Plant クラスに ageTime プロパティを追加
- 一定時間経過で自動的に startDying() を呼ぶ

### 過剰な秩序は死

- 枝の総ポイント数や花の数を監視
- 閾値を超えたら startDying() を呼ぶ
