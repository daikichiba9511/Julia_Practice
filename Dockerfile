# FROMを複数記載してmulti staging
# 参考：　https://qiita.com/SatoshiTerasaki/items/896c59dbe1432f926552
## === for build ===
# FROM julia:1.5
# github actionにはDLCそもそもないのでマルチステージにする必要もない

## ===== for develop =====
FROM julia:1.5
WORKDIR /root/work


# for jupyter
EXPOSE 8888

RUN apt-get update \
    && apt-get install -y \
        cmake \
        wget \
        curl \
        git \
        texlive-latex-recommended  \
        zip \
        gcc \
    && apt-get clean && rm -rf /var/lib/apt/lists/* # clean up

# for python
COPY for_dev.sh /root/work/
RUN chmod +x ./for_dev.sh 
RUN ./for_dev.sh

# enable to call python and jupyter from bash
ENV PATH="/root/.julia/conda/3/bin:$PATH:${PATH}"

COPY Practice root/work/
WORKDIR /root/work/Practice

# using package isntall
RUN julia -e 'using Pkg;Pkg.status'
