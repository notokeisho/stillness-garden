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

- [ ] `stillness_garden/` フォルダを作成
- [ ] 空の .pde ファイルを作成（6ファイル）

作成するファイル:

- stillness_garden/stillness_garden.pde
- stillness_garden/Seed.pde
- stillness_garden/Branch.pde
- stillness_garden/Flower.pde
- stillness_garden/Particle.pde
- stillness_garden/Plant.pde

---

## Phase 1: 基礎クラスの実装

依存関係が少ないクラスから実装する。

### Task 1.1: Particle クラスの実装

- [ ] プロパティの定義（position, velocity, lifespan, particleType, etc.）
- [ ] コンストラクタの実装（花粉用、灰用）
- [ ] update() メソッドの実装（花粉: 漂う、灰: 落ちる）
- [ ] display() メソッドの実装（透明度のフェードアウト）
- [ ] isDead() メソッドの実装

### Task 1.2: Seed クラスの実装

- [ ] プロパティの定義（position, alive, glowSize）
- [ ] コンストラクタの実装
- [ ] update() メソッドの実装
- [ ] display() メソッドの実装（発光エフェクト）
- [ ] die() メソッドの実装

### Task 1.3: Flower クラスの実装

- [ ] プロパティの定義（position, petalCount, size, bloomProgress, etc.）
- [ ] コンストラクタの実装
- [ ] bloom() メソッドの実装（開花アニメーション）
- [ ] startDying() / updateDying() メソッドの実装
- [ ] display() メソッドの実装（花びら描画、グロー効果）
- [ ] isFullyBloomed() / isDead() メソッドの実装

### Task 1.4: Branch クラスの実装

- [ ] プロパティの定義（points, growing, dying, ashProgress, angle, etc.）
- [ ] コンストラクタの実装
- [ ] grow() メソッドの実装（有機的な曲がり）
- [ ] startDying() / updateDying() メソッドの実装（灰化進行）
- [ ] display() メソッドの実装（グロー効果、灰化表現）
- [ ] isFullyDead() / isReadyForFlower() / getTip() メソッドの実装

---

## Phase 2: 統合クラスの実装

### Task 2.1: Plant クラスの実装

- [ ] プロパティの定義（seed, branches, flowers, particles, alive, dying, etc.）
- [ ] コンストラクタの実装
- [ ] initBranches() メソッドの実装（5〜8本のランダム生成）
- [ ] update() メソッドの実装（全要素の更新、花の生成タイミング）
- [ ] display() メソッドの実装（レイヤー順序を考慮）
- [ ] startDying() メソッドの実装
- [ ] isFullyDead() メソッドの実装
- [ ] spawnPollen() / spawnAsh() メソッドの実装

---

## Phase 3: メインファイルの実装

### Task 3.1: 基本構造の実装

- [ ] グローバル変数の定義（currentPlant, dyingPlants, etc.）
- [ ] setup() の実装（画面サイズ、フレームレート、初期化）
- [ ] draw() の基本構造（背景、更新、描画の順序）

### Task 3.2: マウス制御の実装

- [ ] isMouseMoving() 関数の実装
- [ ] マウス停止時の処理（新しいPlant生成）
- [ ] マウス移動時の処理（Plant灰化開始、dyingPlantsへ移動）

### Task 3.3: 描画ループの完成

- [ ] dyingPlants の更新・描画・削除処理
- [ ] currentPlant の更新・描画処理
- [ ] 全体の動作確認

---

## Phase 4: ビジュアル調整

### Task 4.1: グロー効果の調整

- [ ] 発光の強さ・サイズの調整
- [ ] blendMode の適用確認
- [ ] 背景が明るくなる効果の確認

### Task 4.2: 色と速度の調整

- [ ] 枝の色（淡い緑）の調整
- [ ] 花の色（淡いピンク）の調整
- [ ] 成長速度の調整（ゆっくり、瞑想的）
- [ ] 灰化速度の調整（成長より少し速い）

### Task 4.3: 粒子の調整

- [ ] 花粉の漂い方の調整
- [ ] 灰の落ち方の調整
- [ ] 粒子の発生頻度・サイズの調整

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

| タスク | 完了日 | コミットメッセージ |
| ------ | ------ | ------------------ |
| Task 0.1 | - | - |
| Task 1.1 | - | - |
| Task 1.2 | - | - |
| Task 1.3 | - | - |
| Task 1.4 | - | - |
| Task 2.1 | - | - |
| Task 3.1 | - | - |
| Task 3.2 | - | - |
| Task 3.3 | - | - |
| Task 4.1 | - | - |
| Task 4.2 | - | - |
| Task 4.3 | - | - |
| Task 5.1 | - | - |
| Task 5.2 | - | - |
