FROM ubuntu:26.04

ENV MC_SERVER_USER='minecraft'

#days
ENV MC_BACKUPS_AGE_LIMIT=5
#format date for backups
ENV MC_BACKUPS_DATE_FORMAT="(d-m-y)_%d-%m-%Y_%H:%M:%S"
#crontab format value
ENV MC_BACKUP_PERIODICITY="0 0 * * *"

ENV MC_PROJECT_PATH="/var/minecraft"
ENV MC_SERVER_PATH="${MC_PROJECT_PATH}/server"
ENV MC_DATA_PATH="${MC_PROJECT_PATH}/data"
ENV MC_SCRIPTS_PATH="/usr/local/bin"
ENV MC_CRONTAB_PATH="/home/${MC_SERVER_USER}/crontab"

ENV MC_SCREENING_PROJECT_PATH="\/var\/vintage_story"
ENV MC_SCREENING_SERVER_PATH="${MC_SCREENING_PROJECT_PATH}\/server"
ENV MC_SCREENING_DATA_PATH="${MC_SCREENING_PROJECT_PATH}\/data"
ENV MC_SCREENING_SCRIPTS_PATH="\/usr\/local\/bin"

ENV SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/v0.2.49/supercronic-linux-amd64"
ENV SUPERCRONIC_FILE="supercronic-linux-amd64"
ENV SUPERCRONIC_SHA1SUM="e63c11a9726b775a6a11801e81af4f3fb926aa68"

USER root

#COPY ./dist/scripts.tar.gz /tmp/scripts.tar.gz

WORKDIR /tmp

RUN useradd -m $MC_SERVER_USER && mkdir -p $MC_SERVER_PATH && mkdir -p $MC_DATA_PATH && mkdir -p $MC_SCRIPTS_PATH \
#    && tar -xzf /tmp/scripts.tar.gz -C $MC_SCRIPTS_PATH && chown -R $MC_SERVER_USER:$MC_SERVER_USER $MC_PROJECT_PATH && chmod -R +x $MC_SCRIPTS_PATH/* \
    && apt-get update && apt-get -y install wget mc libssl-dev openjdk-25-jre \
    && wget "${SUPERCRONIC_URL}" && echo "${SUPERCRONIC_SHA1SUM} ${SUPERCRONIC_FILE}" | sha1sum -c - && chmod +x "${SUPERCRONIC_FILE}" && mv "${SUPERCRONIC_FILE}" "${MC_SCRIPTS_PATH}/${SUPERCRONIC_FILE}" && ln -s "${MC_SCRIPTS_PATH}/${SUPERCRONIC_FILE}" $MC_SCRIPTS_PATH/supercronic \
    && apt clean && rm -rf /tmp/*

USER $MC_SERVER_USER

WORKDIR $MC_SERVER_PATH

ENTRYPOINT ["bash", "./start.sh"]
