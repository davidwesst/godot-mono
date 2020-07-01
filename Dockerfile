FROM ubuntu:focal

# environment variables
ENV GODOT_VERSION "3.2.2"
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

# setup core dependendies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    python \
    python-openssl \
    unzip \
    wget \
    zip \
    && rm -rf /var/lib/apt/lists/*

# setup and install mono
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 \
    ca-certificates
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list
RUN apt-get update && apt-get install -y --no-install-recommends \
    mono-complete

# get the application and the export templates
ADD https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/mono/Godot_v${GODOT_VERSION}-stable_mono_linux_headless_64.zip /tmp/
ADD https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/mono/Godot_v${GODOT_VERSION}-stable_mono_export_templates.tpz /tmp/

# make required directories
RUN mkdir ~/.cache/ \
    && mkdir -p ~/.config/godot/ \
    && mkdir -p ~/.local/share/godot/templates/${GODOT_VERSION}.stable.mono/

# unzip, then rename executable
RUN unzip /tmp/Godot_v${GODOT_VERSION}-stable_mono_linux_headless_64.zip -d /usr/local/bin/ \
    && mv /usr/local/bin/Godot_v${GODOT_VERSION}-stable_mono_linux_headless_64/* /usr/local/bin/ \
    && ln -s /usr/local/bin/Godot_v${GODOT_VERSION}-stable_mono_linux_headless.64 /usr/local/bin/godot \
    && rm -rf /usr/local/bin/Godot_v${GODOT_VERSION}-stable_mono_linux_headless_64/

# unzip, then rename templates directory
RUN unzip /tmp/Godot_v${GODOT_VERSION}-stable_mono_export_templates.tpz -d ~/.local/share/godot/templates/${GODOT_VERSION}.stable.mono/ \
    && mv ~/.local/share/godot/templates/${GODOT_VERSION}.stable.mono/templates/* ~/.local/share/godot/templates/${GODOT_VERSION}.stable.mono/ \
    && rm -rf ~/.local/share/godot/templates/${GODOT_VERSION}.stable.mono/templates
    