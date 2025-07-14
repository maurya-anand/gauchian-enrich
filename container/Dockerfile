FROM zhouwanding/transvar:2.5.9

RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list && \
    sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list && \
    apt-get update && apt-get install -y cpanminus && \
    cpanm --notest Parallel::ForkManager

RUN pip install --upgrade pip && \
    pip install gauchian==1.0.2

RUN mkdir /ref && \
    wget --no-check-certificate -O /ref/hg38.fa.gz https://hgdownload.soe.ucsc.edu/goldenpath/hg38/bigZips/hg38.fa.gz && \
    gunzip /ref/hg38.fa.gz && \
    samtools faidx /ref/hg38.fa

COPY ./bin/gauchian_enrich /usr/local/bin/gauchian_enrich

RUN chmod +x /usr/local/bin/gauchian_enrich

ENV PATH="/usr/local/bin:$PATH"