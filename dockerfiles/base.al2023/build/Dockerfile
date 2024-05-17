FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# releasever comes from https://unix.stackexchange.com/questions/19701/yum-how-can-i-view-variables-like-releasever-basearch-yum0
RUN mkdir /opt/etc && \
  cp -r /etc/dnf /opt/etc/dnf && \
  cp -r /etc/yum.repos.d /opt/etc/yum.repos.d && \
  dnf \
  --installroot=/opt \
  --releasever="$(rpm --query --file --queryformat '%{VERSION}' /etc/system-release)" \
  install -y dnf dnf-plugins-core

FROM public.ecr.aws/shogo82148/lambda-base:al2023.2024.05.10

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin \
  PIPX_BIN_DIR=/usr/local/bin \
  PIPX_HOME=/usr/local/pipx

COPY --from=0 /opt /

RUN dnf install -y glibc-langpack-en && \
  dnf groupinstall -y development && \
  dnf install -y which clang cmake python-devel docker && \
  dnf clean all
