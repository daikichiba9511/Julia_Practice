#!/bin/bash

# for python
apt-get install -yq bzip2 python3-tk build-essential

julia -e 'ENV["PYTHON"]=""; using Pkg;Pkg.add(["PyCall", "Conda"])'
julia -e 'using Pkg, Conda; Conda.add("python=3.7.*"); Pkg.build("PyCall"); using PyCall'

# install PyPlot and Sympy
julia -e 'using Pkg, Conda; Conda.add("matplotlib"); Pkg.add("PyPlot"); using PyPlot'
# add PackageCompiler to build Package or generate executable module
julia -e 'using Pkg; Pkg.add("PackageCompiler"); using PackageCompiler'
# install Plots
apt-get install -y qt5-default
julia -e 'using Pkg; Pkg.add(["UnicodePlots", "GR", "Plots"]);\
              using UnicodePlots, GR, Plots'
#compile Plots to reduce overhead of `using Plots`
# julia -e 'using Pkg;\
#             using PackageCompiler; create_sysimage(:Plots; sysimage_path="PlotsSysimage.so");\
#             using Plots'