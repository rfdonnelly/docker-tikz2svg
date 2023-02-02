ARG ALPINE_VERSION=3.17
FROM alpine:$ALPINE_VERSION as dvisvgm-builder

RUN apk add --no-cache \
    build-base \
    clipper-dev \
    freetype-dev \
    texlive-dev \
    ghostscript-dev \
    openssl-dev \
    zlib-dev \
    curl

ARG DVISVGM_VERSION=3.0.2

RUN \
    curl -LO https://github.com/mgieseki/dvisvgm/releases/download/$DVISVGM_VERSION/dvisvgm-$DVISVGM_VERSION.tar.gz \
    && tar xf dvisvgm-$DVISVGM_VERSION.tar.gz \
    && cd dvisvgm-$DVISVGM_VERSION \
    && ./configure --enable-bundled-libs \
    && make \
    && make install

FROM alpine:$ALPINE_VERSION

RUN apk add --no-cache \
    ghostscript \
    poppler-utils \
    texlive \
    texmf-dist \
    texmf-dist-latexextra \
    texmf-dist-pictures \
    texmf-dist-pstricks \
    texmf-dist-science

COPY --from=dvisvgm-builder /usr/local/bin/dvisvgm /usr/local/bin
COPY bin/tikz2svg /usr/local/bin

ENTRYPOINT ["tikz2svg"]
