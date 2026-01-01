FROM rockylinux:9-minimal

ARG USER=ln
ARG UID=1000
ARG GID=1000

ENV PYTHONUNBUFFERED=1 \
    TERM=xterm-256color \
    HOME=/home/${USER} \
    USER=${USER}

RUN microdnf install -y dnf shadow-utils && \
    microdnf clean all

RUN groupadd -g ${GID} ${USER} && \
    useradd -m -u ${UID} -g ${GID} -s /bin/zsh ${USER}

ENV ZSH_CUSTOM=${HOME}/.oh-my-zsh/custom \
    PATH="${HOME}/.local/bin:/usr/local/go/bin:${PATH}"

RUN dnf install -y epel-release && \
    dnf config-manager --set-enabled crb && \
    dnf install -y dnf-plugins-core && \
    dnf clean all

RUN dnf install -y \
    zsh \
    vim \
    tmux \
    git \
    curl \
    wget \
    whois \
    bind-utils \
    nmap \
    nmap-ncat \
    socat \
    perl-Image-ExifTool \
    python3.11 \
    python3.11-pip \
    python3.11-devel \
    gcc \
    gcc-c++ \
    make \
    jq \
    unzip \
    less \
    procps-ng \
    tar \
    gzip \
    && dnf clean all

RUN alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
    alternatives --install /usr/bin/pip3 pip3 /usr/bin/pip3.11 1

RUN wget -q https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-x86_64-unknown-linux-musl.tar.gz && \
    tar -xzf ripgrep-14.1.0-x86_64-unknown-linux-musl.tar.gz && \
    mv ripgrep-14.1.0-x86_64-unknown-linux-musl/rg /usr/local/bin/ && \
    rm -rf ripgrep-14.1.0-x86_64-unknown-linux-musl* && \
    wget -q https://github.com/sharkdp/fd/releases/download/v9.0.0/fd-v9.0.0-x86_64-unknown-linux-musl.tar.gz && \
    tar -xzf fd-v9.0.0-x86_64-unknown-linux-musl.tar.gz && \
    mv fd-v9.0.0-x86_64-unknown-linux-musl/fd /usr/local/bin/ && \
    rm -rf fd-v9.0.0-x86_64-unknown-linux-musl*

RUN wget -q https://go.dev/dl/go1.23.4.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz && \
    rm go1.23.4.linux-amd64.tar.gz

RUN wget -q https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-musl.tar.gz && \
    tar -xzf bat-v0.24.0-x86_64-unknown-linux-musl.tar.gz && \
    mv bat-v0.24.0-x86_64-unknown-linux-musl/bat /usr/local/bin/ && \
    rm -rf bat-v0.24.0-x86_64-unknown-linux-musl*

RUN wget -q https://github.com/lsd-rs/lsd/releases/download/v1.1.5/lsd-v1.1.5-x86_64-unknown-linux-gnu.tar.gz && \
    tar -xzf lsd-v1.1.5-x86_64-unknown-linux-gnu.tar.gz && \
    mv lsd-v1.1.5-x86_64-unknown-linux-gnu/lsd /usr/local/bin/ && \
    rm -rf lsd-v1.1.5-x86_64-unknown-linux-gnu*

RUN wget -q https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq

RUN dnf install -y libpcap libpcap-devel && \
    git clone --depth 1 https://github.com/robertdavidgraham/masscan /tmp/masscan && \
    cd /tmp/masscan && \
    make -j$(nproc) && \
    make install && \
    cd / && rm -rf /tmp/masscan && \
    dnf remove -y libpcap-devel && \
    dnf clean all

RUN GOPATH=/tmp/go go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest && \
    GOPATH=/tmp/go go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest && \
    GOPATH=/tmp/go go install -v github.com/owasp-amass/amass/v4/...@master && \
    GOPATH=/tmp/go go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    GOPATH=/tmp/go go install -v github.com/ffuf/ffuf/v2@latest && \
    GOPATH=/tmp/go go install -v github.com/lc/gau/v2/cmd/gau@latest && \
    GOPATH=/tmp/go go install -v github.com/tomnomnom/waybackurls@latest && \
    GOPATH=/tmp/go go install -v github.com/jaeles-project/gospider@latest && \
    mv /tmp/go/bin/* /usr/local/bin/ && \
    rm -rf /tmp/go

RUN pip3 install --no-cache-dir \
    wheel \
    ruamel.yaml \
    sherlock-project \
    holehe \
    socialscan \
    kube-hunter \
    h8mail \
    emailfinder

RUN git clone --depth 1 https://github.com/laramies/metagoofil.git /opt/metagoofil && \
    pip3 install --no-cache-dir -r /opt/metagoofil/requirements.txt && \
    ln -s /opt/metagoofil/metagoofil.py /usr/local/bin/metagoofil && \
    chmod +x /opt/metagoofil/metagoofil.py

RUN git clone --depth 1 https://github.com/jasonxtn/Argus.git /tmp/argus-install && \
    cd /tmp/argus-install && \
    mkdir -p /opt/argus && \
    cp -r argus /opt/argus/ && \
    pip3 install --no-cache-dir -r requirements.txt && \
    if [ ! -f /opt/argus/argus/__main__.py ]; then \
        echo 'from argus.cli.main import main' > /opt/argus/argus/__main__.py && \
        echo 'if __name__ == "__main__":' >> /opt/argus/argus/__main__.py && \
        echo '    main()' >> /opt/argus/argus/__main__.py; \
    fi && \
    printf '#!/bin/bash\nPYTHONPATH=/opt/argus python3 -m argus "$@"\n' > /usr/local/bin/argus && \
    chmod +x /usr/local/bin/argus && \
    cd / && rm -rf /tmp/argus-install

COPY ./apps/sec-tools/motd.txt /etc/motd
RUN printf '#!/bin/bash\ncat /etc/motd\n' > /usr/local/bin/help && \
    chmod +x /usr/local/bin/help

USER ${USER}
WORKDIR ${HOME}

RUN git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf && \
    ${HOME}/.fzf/install --all

RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
RUN git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions && \
    git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting && \
    git clone --depth 1 https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM}/plugins/zsh-completions

RUN sed -i 's/plugins=(git)/plugins=(git docker kubectl zsh-autosuggestions zsh-syntax-highlighting zsh-completions)/' ${HOME}/.zshrc && \
    echo 'fpath+=${ZSH_CUSTOM}/plugins/zsh-completions/src' >> ${HOME}/.zshrc

RUN { \
    echo ''; \
    echo 'alias cat="bat --style=plain --paging=never"'; \
    echo 'alias catp="bat --style=full"'; \
    echo 'alias ls="lsd"'; \
    echo 'alias ll="lsd -lah"'; \
    echo 'alias lt="lsd --tree"'; \
    echo 'alias grep="rg"'; \
    echo 'alias find="fd"'; \
    echo ''; \
    echo 'alias subenum="subfinder -silent | dnsx -silent | httpx -silent"'; \
    echo 'alias portscan="nmap -sV --open -oN"'; \
    echo 'alias fastscan="masscan -p1-65535 --rate=1000"'; \
    echo 'alias urls="gau --subs"'; \
    echo ''; \
    echo 'HISTSIZE=10000'; \
    echo 'SAVEHIST=10000'; \
    echo 'setopt HIST_IGNORE_ALL_DUPS'; \
    echo 'setopt HIST_FIND_NO_DUPS'; \
    echo 'export EDITOR=vim'; \
    echo ''; \
    echo '[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh'; \
    echo ''; \
    echo 'echo "Type '\''help'\'' to see available commands"'; \
} >> ${HOME}/.zshrc

RUN { \
    echo 'syntax on'; \
    echo 'set number'; \
    echo 'set relativenumber'; \
    echo 'set tabstop=4'; \
    echo 'set shiftwidth=4'; \
    echo 'set expandtab'; \
    echo 'set smartindent'; \
    echo 'set incsearch'; \
    echo 'set hlsearch'; \
    echo 'set ignorecase'; \
    echo 'set smartcase'; \
    echo 'set mouse=a'; \
    echo 'set clipboard=unnamedplus'; \
    echo 'set cursorline'; \
    echo 'set wildmenu'; \
    echo 'set laststatus=2'; \
    echo 'set encoding=utf-8'; \
    echo 'colorscheme desert'; \
} > ${HOME}/.vimrc

RUN { \
    echo 'set -g mouse on'; \
    echo 'unbind C-b'; \
    echo 'set -g prefix C-a'; \
    echo 'bind C-a send-prefix'; \
    echo 'bind | split-window -h'; \
    echo 'bind - split-window -v'; \
    echo 'set -g base-index 1'; \
    echo 'setw -g pane-base-index 1'; \
    echo 'set -g default-terminal "screen-256color"'; \
    echo 'set -g status-bg colour235'; \
    echo 'set -g status-fg colour136'; \
    echo 'set -g status-left-length 30'; \
    echo 'set -g status-right "#[fg=colour166]#H #[fg=colour245]%Y-%m-%d %H:%M"'; \
} > ${HOME}/.tmux.conf

COPY --chown=${UID}:${GID} ./apps/sec-tools/entrypoint.sh /entrypoint.sh

WORKDIR /data
SHELL ["/bin/zsh", "-c"]
ENTRYPOINT ["/entrypoint.sh"]
CMD []
