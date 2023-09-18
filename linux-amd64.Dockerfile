ARG UPSTREAM_IMAGE=adoah/base
ARG UPSTREAM_VERSION=latest

FROM ${UPSTREAM_IMAGE}:${UPSTREAM_VERSION}
EXPOSE 6969
VOLUME ["${CONFIG_DIR}"]

RUN apk add --no-cache libintl sqlite-libs icu-libs

ARG VERSION=2.0.0.269
ARG SBRANCH=nightly
ARG PACKAGE_VERSION=${VERSION}
RUN usermod -u 568 hotio
RUN mkdir "${APP_DIR}/bin" && \
    curl -fsSL "https://whisparr.servarr.com/v1/update/${SBRANCH}/updatefile?version=${VERSION}&os=linuxmusl&runtime=netcore&arch=x64" | tar xzf - -C "${APP_DIR}/bin" --strip-components=1 && \
    rm -rf "${APP_DIR}/bin/Whisparr.Update" && \
    echo -e "PackageVersion=${PACKAGE_VERSION}\nPackageAuthor=[hotio](https://github.com/hotio)\nUpdateMethod=Docker\nBranch=${SBRANCH}" > "${APP_DIR}/package_info" && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

ENTRYPOINT [ "${APP_DIR}/Whisparr" ]