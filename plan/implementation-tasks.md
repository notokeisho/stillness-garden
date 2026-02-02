# 実装タスク: Stillness Garden

## 進め方

1. Phase 0 から順番に実装する
2. 各タスク完了後に git commit する
3. タスク完了後、このファイルのステータスを更新する
4. 1タスク完了したらユーザーの指示を待つ

## ステータス凡例

- [ ] 未着手
- [x] 完了

---

## Phase 0: プロジェクトセットアップ

### Task 0.1: ディレクトリ構造の作成

- [x] `stillness_garden/` フォルダを作成
- [x] 空の .pde ファイルを作成（6ファイル）

作成するファイル:

- stillness_garden/stillness_garden.pde
- stillness_garden/Seed.pde
- stillness_garden/Branch.pde
- stillness_garden/Flower.pde
- stillness_garden/Particle.pde
- stillness_garden/Plant.pde

---

## Phase 1: 基礎クラスの実装

依存関係を考慮した順序: Particle → Seed → Branch → Flower

### Task 1.1: Particle クラスの実装

- [x] プロパティの定義（position, velocity, lifespan, particleType, etc.）
- [x] コンストラクタの実装（花粉用、灰用）
- [x] update() メソッドの実装（花粉: 漂う、灰: 落ちる）
- [x] display() メソッドの実装（透明度のフェードアウト、グロー効果含む）
- [x] isDead() メソッドの実装

### Task 1.1.1: Particle 単体動作確認

- [x] メインファイルで Particle を複数生成して動作確認
- [x] 花粉（漂う）と灰（落ちる）の両方の挙動を確認
- [x] フェードアウトが正常に動作するか確認

### Task 1.2: Seed クラスの実装

- [x] プロパティの定義（position, alive, glowSize）
- [x] コンストラクタの実装
- [x] update() メソッドの実装
- [x] display() メソッドの実装（発光エフェクト、グロー効果含む）
- [x] die() メソッドの実装

### Task 1.2.1: Seed 単体動作確認

- [x] メインファイルで Seed をマウス位置に表示
- [x] 発光エフェクトが正常に描画されるか確認

### Task 1.3: Branch クラスの実装（基本機能）

- [x] プロパティの定義（points, growing, dying, ashProgress, angle, etc.）
- [x] コンストラクタの実装
- [x] grow() メソッドの実装（有機的な曲がり）
- [x] display() メソッドの実装（グロー効果含む）
- [x] getTip() メソッドの実装
- [x] isReadyForFlower() メソッドの実装

### Task 1.3.1: Branch 成長の単体動作確認

- [x] メインファイルで Branch を1本生成して成長を確認
- [x] 有機的な曲がりが自然に見えるか確認
- [x] グロー効果が正常に描画されるか確認

### Task 1.3.2: Branch クラスの実装（灰化機能）

- [x] startDying() メソッドの実装
- [x] updateDying() メソッドの実装（灰化進行）
- [x] display() の灰化表現を追加
- [x] isFullyDead() メソッドの実装

### Task 1.3.3: Branch 灰化の単体動作確認

- [x] 成長後に灰化を開始して動作確認
- [x] 根本から先端に向かって消えていくか確認
- [x] 灰化の速度が適切か確認

### Task 1.4: Flower クラスの実装

- [x] プロパティの定義（position, petalCount, size, bloomProgress, etc.）
- [x] コンストラクタの実装
- [x] bloom() メソッドの実装（開花アニメーション）
- [x] display() メソッドの実装（花びら描画、グロー効果含む）
- [x] isFullyBloomed() メソッドの実装

### Task 1.4.1: Flower 開花の単体動作確認

- [x] メインファイルで Flower を表示して開花を確認
- [x] 花びら（5〜6枚）が正常に描画されるか確認
- [x] 淡いピンクの色とグロー効果を確認

### Task 1.4.2: Flower クラスの実装（灰化機能）

- [x] startDying() メソッドの実装
- [x] updateDying() メソッドの実装
- [x] isDead() メソッドの実装

### Task 1.4.3: Flower 灰化の単体動作確認

- [x] 開花後に灰化を開始して動作確認
- [x] 灰化が正常に進行するか確認

---

## Phase 2: 統合クラスの実装

### Task 2.1: Plant クラスの実装（基本構造）

- [x] プロパティの定義（seed, branches, flowers, particles, alive, dying, etc.）
- [x] コンストラクタの実装
- [x] initBranches() メソッドの実装（5〜8本をランダムな方向に生成）

### Task 2.1.1: Plant 初期化の動作確認

- [x] メインファイルで Plant を生成して枝の初期化を確認
- [x] 5〜8本の枝がランダムな方向に向いているか確認

### Task 2.2: Plant クラスの実装（成長処理）

- [x] update() メソッドの実装（枝の成長更新）
- [x] 花の生成タイミング制御（枝が一定長さになったら花を追加）
- [x] spawnPollen() メソッドの実装（花粉粒子生成）
- [x] display() メソッドの実装（レイヤー順序を考慮）

### Task 2.2.1: Plant 成長の動作確認

- [x] マウス位置に Plant を生成して成長を確認
- [x] 枝が伸び、花が咲き、花粉が舞うか確認

### Task 2.3: Plant クラスの実装（灰化処理）

- [x] startDying() メソッドの実装（種が消え、枝の灰化開始）
- [x] update() に灰化中の処理を追加
- [x] spawnAsh() メソッドの実装（灰粒子生成）
- [x] isFullyDead() メソッドの実装

### Task 2.3.1: Plant 灰化の動作確認

- [ ] 成長後に灰化を開始して動作確認
- [ ] 種が消え、枝が根本から灰化し、灰が落ちるか確認
- [ ] 全要素が消えた後に isFullyDead() が true になるか確認

### Task 2.4: 花と花粉のバランス調整

**背景**: 花が等間隔で咲きすぎて上限に達すると、枝だけが伸び続けて見栄えが悪い

**修正内容**:
- [x] 花の生成確率を1/3に変更（各枝ごとにランダム）
- [x] 花が上限（40個）に達したら枝の成長を停止
- [x] reachedFlowerLimitフラグを追加
- [x] 通常時の花粉: 3-6個の花から30フレームごとに生成
- [x] 上限達成後の花粉: 全ての花から20フレームごとに生成

**期待する動作**:
| 項目 | 通常時 | 上限達成後 |
|------|--------|-----------|
| 枝の成長 | 伸び続ける | 停止 |
| 花の生成 | 1/3確率で咲く | 咲かない |
| 花粉の量 | 3-6個の花から | 全ての花から |
| 花粉の頻度 | 30フレームごと | 20フレームごと |

### Task 2.5: 成長停止後の風システム追加

**背景**: 花粉がその場に留まり続け、特定の場所に溜まってしまう

**修正内容**:
- [x] Plantクラスに風の情報を追加（windDirection, windStrength）
- [x] 成長停止時（reachedFlowerLimit）に風向きをランダムに決定
- [x] update()で花粉（particleType == 0）に風を適用
- [x] Particleの速度制限を調整（風で流れやすくする）

**実装詳細**:

1. Plantクラスに追加:
```java
PVector windDirection;     // 風向き
float windStrength = 0.03; // 風の強さ
```

2. 成長停止時に風向きを決定:
```java
// 風向きをランダムに決定（主に横方向、少し上下）
windDirection = new PVector(random(-1, 1), random(-0.3, 0.3));
windDirection.normalize();
```

3. パーティクル更新時に風を適用:
```java
if (reachedFlowerLimit && p.particleType == 0) {
  p.velocity.add(PVector.mult(windDirection, windStrength));
}
```

4. Particleの速度制限を調整:
```java
// 通常時は0.5、風適用時は0.8に緩める
velocity.limit(0.8);
```

**期待する動作**:
| 項目 | 通常時 | 上限達成後 |
|------|--------|-----------|
| 花粉の動き | その場でふわふわ | 風に流されながらふわふわ |
| 風向き | なし | ランダムな一方向 |

### Task 2.6: 花粉生成タイミングの個別化

**背景**: 全ての花から同時に花粉が生成され、「一斉に生成された感」がある

**修正内容**:
- [x] Flowerクラスに花粉生成用の個別タイマーを追加
- [x] 花ごとに異なる生成間隔を設定
- [x] Plant.spawnPollen()を各花の個別タイマーベースに変更

**実装詳細**:

1. Flowerクラスに追加:
```java
int pollenTimer;      // 花粉生成タイマー
int pollenInterval;   // 花粉生成間隔（花ごとにランダム）

// コンストラクタで初期化
pollenTimer = int(random(60));      // 初期値をばらけさせる
pollenInterval = int(random(40, 80)); // 間隔も花ごとに違う（40-80フレーム）
```

2. Flowerクラスにメソッド追加:
```java
// 花粉を生成すべきタイミングか判定
boolean shouldSpawnPollen() {
  if (!isFullyBloomed() || dying) return false;
  pollenTimer++;
  if (pollenTimer >= pollenInterval) {
    pollenTimer = 0;
    return true;
  }
  return false;
}
```

3. Plant.spawnPollen()を修正:
```java
void spawnPollen() {
  if (particles.size() >= maxParticles) return;

  for (Flower f : flowers) {
    if (f.shouldSpawnPollen()) {
      // この花から花粉を生成
      Particle pollen = new Particle(...);
      particles.add(pollen);
    }
  }
}
```

4. 花粉生成の呼び出しを毎フレームに変更（タイマーはFlower側で管理）

**期待する動作**:
- 各花が独立したタイミングで花粉を生成
- 花ごとに生成間隔が異なる（40-80フレーム）
- 初期タイマーがばらけているので、同時生成が起こりにくい

### Task 2.7: パーティクルのフェードイン効果

**背景**: 花粉・灰が生成された瞬間から最大の明るさ・サイズで表示され、「急に出現した感」がある

**修正内容**:
- [x] Particleクラスにフェードイン時間を追加（1.5秒 = 90フレーム）
- [x] display()で経過フレームに応じてサイズと明るさを補間
- [x] 花粉・灰の両方に適用

**実装詳細**:

1. Particleクラスにプロパティ追加:
```java
int fadeInDuration = 90;  // 1.5秒（90フレーム）
```

2. age（経過フレーム）の計算（新しい変数は不要）:
```java
float age = maxLifespan - lifespan;  // 生成からの経過フレーム
```

3. display()でフェードイン係数を計算:
```java
// フェードイン係数を計算（0.0 → 1.0）
float fadeInProgress = min(1.0, age / fadeInDuration);
float growthFactor = easeOutCubic(fadeInProgress);  // 滑らかに成長

// サイズと明るさに適用
float displaySize = size * growthFactor;
float displayAlpha = baseAlpha * growthFactor;
```

4. easeOutCubic関数を追加:
```java
float easeOutCubic(float t) {
  return 1 - pow(1 - t, 3);
}
```

**期待する動作**:
- 生成直後: 暗く・小さい状態
- 1.5秒かけて: 徐々に現在の明るさ・サイズに成長
- 「ふわっと現れる」自然な印象になる

---

## Phase 3: メインファイルの実装

### Task 3.1: 基本構造の実装

- [ ] グローバル変数の定義（currentPlant, dyingPlants, etc.）
- [ ] setup() の実装（画面サイズ 800x800、60fps、初期化）
- [ ] draw() の基本構造（背景、更新、描画の順序）

### Task 3.2: マウス制御の実装

- [ ] isMouseMoving() 関数の実装（閾値による判定）
- [ ] マウス停止時の処理（新しい Plant 生成）
- [ ] マウス移動時の処理（currentPlant の灰化開始、dyingPlants へ移動）

### Task 3.2.1: マウス制御の動作確認

- [ ] マウスを止めると種が出現し、枝が伸び始めるか確認
- [ ] マウスを動かすと灰化が始まるか確認
- [ ] 別の場所で止めると新しい植物が生えるか確認

### Task 3.3: 複数植物の管理

- [ ] dyingPlants の更新・描画・削除処理
- [ ] 古い植物が灰化中に新しい植物が成長する共存状態の確認
- [ ] 完全に消えた植物のリストからの削除

### Task 3.3.1: 複数植物の動作確認

- [ ] 灰化中の古い植物と成長中の新しい植物が同時に表示されるか確認
- [ ] 複数回繰り返してメモリリークがないか確認

---

## Phase 4: 微調整

### Task 4.1: 色の微調整

- [ ] 枝の色（淡い緑）の濃さ・色相の調整
- [ ] 花の色（淡いピンク）の濃さ・色相の調整
- [ ] 種・粒子の色のバランス調整

### Task 4.2: 速度の微調整

- [ ] 成長速度の調整（ゆっくり、瞑想的になっているか）
- [ ] 灰化速度の調整（成長より少し速いか）
- [ ] 開花速度の調整

### Task 4.3: 粒子の微調整

- [ ] 花粉の漂い方の調整（ふわふわ感）
- [ ] 灰の落ち方の調整（重力感）
- [ ] 粒子の発生頻度・サイズの調整

### Task 4.4: グロー効果の微調整

- [ ] 発光の強さ・広がりの調整
- [ ] 背景が明るくなる効果の確認・調整

---

## Phase 5: テストと仕上げ

### Task 5.1: Processing 2.2.1 での動作確認

- [ ] 学校環境での動作テスト
- [ ] 互換性問題があれば修正

### Task 5.2: 最終調整

- [ ] 全体のバランス確認
- [ ] パフォーマンス確認
- [ ] 必要に応じて微調整

---

## 完了記録

| タスク | 完了日 | 備考 |
| ------ | ------ | ---- |
| Task 0.1 | 2026-02-02 | Processingプロジェクトの初期構造を作成 |
| Task 1.1 | 2026-02-02 | Particleクラスを実装 |
| Task 1.1.1 | 2026-02-02 | Particle単体動作確認OK |
| Task 1.2 | 2026-02-02 | Seedクラスを実装 |
| Task 1.2.1 | 2026-02-02 | Seed単体動作確認OK |
| Task 1.3 | 2026-02-02 | Branchクラスの基本機能を実装 |
| Task 1.3.1 | 2026-02-02 | Branch成長確認OK、色と速度を調整 |
| Task 1.3.2 | 2026-02-02 | Branchの灰化機能を実装 |
| Task 1.3.3 | 2026-02-02 | Branch灰化確認OK |
| Task 1.4 | 2026-02-02 | Flowerクラスの開花機能を実装 |
| Task 1.4.1 | 2026-02-02 | 開花確認OK、グロー強化、白い花を追加 |
| Task 1.4.2 | 2026-02-02 | Flowerの灰化機能を実装 |
| Task 1.4.3 | 2026-02-02 | 灰化確認OK、パーティクルはTask 2.3で実装 |
| Task 2.1 | 2026-02-02 | Plantクラスの基本構造を実装 |
| Task 2.1.1 | 2026-02-02 | Plant初期化確認OK |
| Task 2.2 | 2026-02-02 | Plantの成長処理を実装 |
| Task 2.2.1 | 2026-02-02 | 成長確認OK、花生成ロジック修正（25pt間隔、上限40） |
| Task 2.3 | 2026-02-02 | Plantの灰化処理を実装 |
| Task 2.3.1 | - | パフォーマンス調査中にデバッグ |
| Task 2.4 | 2026-02-02 | 花生成確率1/3、上限で成長停止 |
| Task 2.5 | 2026-02-02 | 風システム追加（strength=0.05, limit=1.0） |
| Task 2.6 | 2026-02-02 | 花粉の個別タイマー実装、上限後は2倍生成 |
| Task 2.7 | 2026-02-02 | パーティクルのフェードイン効果（1.5秒、easeOutCubic） |
| Task 3.1 | - | - |
| Task 3.2 | - | - |
| Task 3.2.1 | - | - |
| Task 3.3 | - | - |
| Task 3.3.1 | - | - |
| Task 4.1 | - | - |
| Task 4.2 | - | - |
| Task 4.3 | - | - |
| Task 4.4 | - | - |
| Task 5.1 | - | - |
| Task 5.2 | - | - |
