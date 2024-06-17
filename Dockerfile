FROM ubuntu:jammy

WORKDIR /root

RUN \
  sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.iij.ad.jp/pub/linux/ubuntu/archive/%g" /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y build-essential locales

ENV LANG en_US.UTF-8
ENV LC_ALL $LANG
RUN locale-gen $LANG && update-locale
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get install -y python3-pip flex bison git vim ninja-build nasm
RUN pip3 install meson

RUN git clone https://github.com/shihaku1223/gstreamer -b feat/videotestsrc_clock_pattern && \
  cd gstreamer && \
  meson setup --prefix=/usr -Dgst-plugins-ugly:x264=enabled -Dgpl=enabled builddir && \
  ninja -C builddir && \
  meson install -C builddir && \
  cd .. && rm -rf gstreamer
