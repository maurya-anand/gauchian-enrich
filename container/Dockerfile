FROM zhouwanding/transvar:2.5.9

RUN apt-get update && apt-get install -y cpanminus && \
    cpanm --notest Parallel::ForkManager

RUN pip install --upgrade pip && \
    pip install gauchian==1.0.2

RUN mkdir /ref && \
    wget --no-check-certificate -O /ref/hg38.fa.gz https://hgdownload.soe.ucsc.edu/goldenpath/hg38/bigZips/hg38.fa.gz && \
    gunzip /ref/hg38.fa.gz && \
    samtools faidx /ref/hg38.fa

COPY ./bin/gauchian_enrich.pl /usr/local/bin/gauchian_enrich

RUN chmod +x /usr/local/bin/gauchian_enrich

ENV PATH="/usr/local/bin:$PATH"