# Julia Practice

## 概要

Juliaの練習用のコード管理, dataはReference[3]を使用

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
