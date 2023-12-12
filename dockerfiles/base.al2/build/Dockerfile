FROM public.ecr.aws/amazonlinux/amazonlinux:2

# releasever comes from https://unix.stackexchange.com/questions/19701/yum-how-can-i-view-variables-like-releasever-basearch-yum0
RUN mkdir /opt/etc && \
  cp etc/yum.conf /opt/etc/yum.conf && \
  cp -r /etc/yum /opt/etc/yum && \
  cp -r /etc/yum.repos.d /opt/etc/yum.repos.d && \
  yum \
    --installroot=/opt \
    --releasever="$(rpm --query --file --queryformat '%{VERSION}' /etc/system-release)" \
    install -y yum yum-plugin-ovl yum-plugin-priorities

FROM public.ecr.aws/shogo82148/lambda-base:al2.2023.12.12

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin \
  PIPX_BIN_DIR=/usr/local/bin \
  PIPX_HOME=/usr/local/pipx

COPY --from=0 /opt /

RUN yum install -y glibc-langpack-en && \
  yum groupinstall -y development && \
  yum install -y which clang cmake python-devel python3-devel amazon-linux-extras && \
  amazon-linux-extras install -y docker && \
  yum clean all && \
  pip3 install -U pip setuptools wheel --no-cache-dir && \
  pip3 install pipx --no-cache-dir
