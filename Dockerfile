FROM python:3.6-slim-stretch
MAINTAINER Evgeny Medvedev <evge.medvedev@gmail.com>
ENV PROJECT_DIR=ethereum-etl

RUN mkdir /$PROJECT_DIR
WORKDIR /$PROJECT_DIR
COPY . .
RUN apt-get update -yqq && apt-get -y install gcc && pip install -e /$PROJECT_DIR/[streaming] \
   && apt-get purge --auto-remove -yqq gcc \
   && apt-get autoremove -yqq --purge \
   && apt-get clean \
   && rm -rf \
   /var/lib/apt/lists/* \
   /tmp/* \
   /var/tmp/* \
   /usr/share/man \
   /usr/share/doc \
   /usr/share/doc-base \
   /root/.cache


# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

ENTRYPOINT ["/tini", "--", "python", "ethereumetl"]
