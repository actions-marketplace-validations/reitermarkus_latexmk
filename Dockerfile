FROM alpine

ENV MANPATH="/usr/local/texlive/texmf-dist/doc/man:${MANPATH}" \
    INFOPATH="/usr/local/texlive/texmf-dist/doc/info:${INFOPATH}" \
    PATH="/usr/local/texlive/bin/x86_64-linuxmusl:${PATH}"

RUN apk add --no-cache \
      fontconfig \
      perl \
      wget \
      xz \
 && wget -q http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
 && mkdir texlive \
 && tar -xf install-tl-unx.tar.gz -C texlive --strip-components=1 \
 && rm install-tl-unx.tar.gz \
 && cd texlive \
 && { \
      echo 'selected_scheme scheme-full'; \
      echo 'TEXDIR /usr/local/texlive'; \
      echo 'TEXMFLOCAL /usr/local/texlive/texmf-local'; \
      echo 'TEXMFSYSCONFIG /usr/local/texlive/texmf-config'; \
      echo 'TEXMFSYSVAR /usr/local/texlive/texmf-var'; \
      echo 'TEXMFCONFIG ~/.texlive/texmf-config'; \
      echo 'TEXMFVAR ~/.texlive/texmf-var'; \
      echo 'TEXMFHOME ~/texmf'; \
    } > texlive.profile \
 && ./install-tl --profile texlive.profile \
 && cd .. \
 && rm -r texlive \
 && tlmgr update --all --self --reinstall-forcibly-removed \
 && tlmgr backup --all --clean \
 && rm \
      /usr/local/texlive/install-tl.log \
      /usr/local/texlive/texmf-var/web2c/tlmgr.log \
      /usr/local/texlive/texmf-var/web2c/updmap.log \
      /usr/local/texlive/doc.html \
      /usr/local/texlive/index.html \
 && rm -r \
      /usr/local/texlive/readme-html.dir \
      /usr/local/texlive/readme-txt.dir \
      /usr/local/texlive/install-tl \
      /usr/local/texlive/texmf-dist/doc \
      /usr/local/texlive/texmf-dist/source \
      /usr/local/texlive/texmf-dist/fonts/source

COPY entry.pl /
ENTRYPOINT ["/entry.pl"]
