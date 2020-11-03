# Julia Practice

## 概要

Juliaの練習用のコード管理, dataはReference[3]を使用する。データは以下の手順で作成

1. input配下でunzipする
2. make_data.jlを使用してdata配下に配置

```shell
$ tree -L 1
.
├── Dockerfile
├── Practice
├── README.md
├── bashfile_for_settings
├── data
├── docker-compose.yml
├── for_dev.sh
└── input
```

NOTE: Juliaではmp3 -> wavの変換で良さそうなパッケージが見当たらなかったのでpydubを使用
Condaパッケージを利用して`pydub` と `pyaudio` をインストールして利用した。

* 仮想環境

** activate

```julia
pkg> activate Practice
```

** deactivate

```julia
pkg> activate
```

## PackageCompiler

* package compilerを利用してできるだけ初回コンパイル時間を短くする。

** create_sysimageでprecompileが可能になる, 詳細はReference[4]

## 参考

* [1] [Juliaのプロジェクトと環境](https://qiita.com/mametank/items/9fc1c9227303d6ca304b)
* [2] [Object Orientation and Polymorphism in Julia](https://github.com/ninjaaron/oo-and-polymorphism-in-julia)
* [3] [Common Voice (Kaggle)](https://www.kaggle.com/mozillaorg/common-voice)
* [4] [PackageCompiler](https://julialang.github.io/PackageCompiler.jl/dev/)
