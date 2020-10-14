# FROMを複数記載してmulti staging
# 参考：　https://qiita.com/SatoshiTerasaki/items/896c59dbe1432f926552
## for === product ===
FROM julia1.5


## ===== for develop =====
FROM julia1.5
WORKDIR /root/work
COPY Practice, for_dev.sh /root/work/

# for jupyter
EXPOSE 8888

# using package isntall
RUN julia -e 'using Pkg; st'

RUN apt-get update \
    && apt-get install -y \
        cmake \
        wget \
        curl \
        git \
        texlive-latex-recommended  \
        zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/* # clean up

# for python
RUN .for_dev.sh
# enable to call python and jupyter from bash
ENV PATH="/root/.julia/conda/3/bin:$PATH:${PATH}"

WORKDIR /root/work/Practice