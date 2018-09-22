FROM debian:jessie

MAINTAINER Derek Chafin <infomaniac50@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Microchip tools require i386 compatability libs
RUN dpkg --add-architecture i386 \
    && apt-get update -yq \
    && apt-get install -yq --no-install-recommends curl libc6:i386 \
    libx11-6:i386 libxext6:i386 libstdc++6:i386 libexpat1:i386 \
    libxext6 libxrender1 libxtst6 libgtk2.0-0 libxslt1.1

ENV XC16_VERSION 1.35

# Download and install XC16 compiler
RUN curl -fSL -A "Mozilla/4.0" -o /tmp/xc16.run "http://ww1.microchip.com/downloads/en/DeviceDoc/xc16-v${XC16_VERSION}-full-install-linux-installer.run" \
    && chmod a+x /tmp/xc16.run \
    && /tmp/xc16.run --mode unattended --unattendedmodeui none \
        --netservername localhost --LicenseType FreeMode \
    && rm /tmp/xc16.run
ENV PATH /opt/microchip/xc16/v${XC16_VERSION}/bin:$PATH

ENV MPLABX_VERSION 5.05

# Download and install MPLAB X IDE
# Use url: http://www.microchip.com/mplabx-ide-linux-installer to get the latest version
RUN curl -fSL -A "Mozilla/4.0" -o /tmp/mplabx-installer.tar "http://ww1.microchip.com/downloads/en/DeviceDoc/MPLABX-v${MPLABX_VERSION}-linux-installer.tar" \
    && tar xf /tmp/mplabx-installer.tar && rm /tmp/mplabx-installer.tar \
    && USER=root ./MPLABX-v${MPLABX_VERSION}-linux-installer.sh --nox11 \
        -- --unattendedmodeui none --mode unattended \
    && rm ./MPLABX-v${MPLABX_VERSION}-linux-installer.sh

VOLUME ["/tmp/.X11-unix"]

USER 1000:100

WORKDIR /home/developer

CMD ["/usr/bin/mplab_ide", "--userdir", "/home/developer/.mplab_ide", "--cachedir", "/home/developer/.cache/mplab_ide"]
