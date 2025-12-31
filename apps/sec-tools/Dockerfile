FROM rockylinux:9-minimal

ENV PYTHONUNBUFFERED=1 \
    TERM=xterm-256color \
    ZSH_CUSTOM=/root/.oh-my-zsh/custom \
    PATH="/root/.local/bin:/usr/local/go/bin:/root/go/bin:${PATH}"

RUN microdnf install -y dnf && \
    microdnf clean all

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
    python3.11 \
    python3.11-pip \
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

RUN wget https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-x86_64-unknown-linux-musl.tar.gz && \
    tar -xzf ripgrep-14.1.0-x86_64-unknown-linux-musl.tar.gz && \
    mv ripgrep-14.1.0-x86_64-unknown-linux-musl/rg /usr/local/bin/ && \
    rm -rf ripgrep-14.1.0-x86_64-unknown-linux-musl* && \
    wget https://github.com/sharkdp/fd/releases/download/v9.0.0/fd-v9.0.0-x86_64-unknown-linux-musl.tar.gz && \
    tar -xzf fd-v9.0.0-x86_64-unknown-linux-musl.tar.gz && \
    mv fd-v9.0.0-x86_64-unknown-linux-musl/fd /usr/local/bin/ && \
    rm -rf fd-v9.0.0-x86_64-unknown-linux-musl*

RUN wget https://go.dev/dl/go1.23.4.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz && \
    rm go1.23.4.linux-amd64.tar.gz

RUN wget https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-musl.tar.gz && \
    tar -xzf bat-v0.24.0-x86_64-unknown-linux-musl.tar.gz && \
    mv bat-v0.24.0-x86_64-unknown-linux-musl/bat /usr/local/bin/ && \
    rm -rf bat-v0.24.0-x86_64-unknown-linux-musl*

RUN wget https://github.com/lsd-rs/lsd/releases/download/v1.1.5/lsd-v1.1.5-x86_64-unknown-linux-gnu.tar.gz && \
    tar -xzf lsd-v1.1.5-x86_64-unknown-linux-gnu.tar.gz && \
    mv lsd-v1.1.5-x86_64-unknown-linux-gnu/lsd /usr/local/bin/ && \
    rm -rf lsd-v1.1.5-x86_64-unknown-linux-gnu*

RUN git clone --depth 1 https://github.com/junegunn/fzf.git /root/.fzf && \
    /root/.fzf/install --all

RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq

RUN dnf install -y libpcap libpcap-devel && \
    git clone https://github.com/robertdavidgraham/masscan /tmp/masscan && \
    cd /tmp/masscan && \
    make && \
    make install && \
    cd / && rm -rf /tmp/masscan && \
    dnf remove -y libpcap-devel && \
    dnf clean all

RUN go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest && \
    go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest && \
    go install -v github.com/owasp-amass/amass/v4/...@master && \
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    go install -v github.com/ffuf/ffuf/v2@latest && \
    mv /root/go/bin/* /usr/local/bin/ && \
    rm -rf /root/go/pkg

RUN pip3 install --no-cache-dir \
    sherlock-project \
    holehe \
    socialscan

RUN git clone https://github.com/jasonxtn/Argus.git /tmp/argus-install && \
    cd /tmp/argus-install && \
    mkdir -p /opt/argus && \
    cp -r argus /opt/argus/ && \
    pip3 install --no-cache-dir -r requirements.txt && \
    if [ ! -f /opt/argus/argus/__main__.py ]; then \
        echo 'from argus.cli.main import main' > /opt/argus/argus/__main__.py && \
        echo 'if __name__ == "__main__":' >> /opt/argus/argus/__main__.py && \
        echo '    main()' >> /opt/argus/argus/__main__.py; \
    fi && \
    echo '#!/bin/bash' > /usr/local/bin/argus && \
    echo 'PYTHONPATH=/opt/argus python3 -m argus "$@"' >> /usr/local/bin/argus && \
    chmod +x /usr/local/bin/argus && \
    cd / && rm -rf /tmp/argus-install

RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM}/plugins/zsh-completions

RUN sed -i 's/plugins=(git)/plugins=(git docker kubectl zsh-autosuggestions zsh-syntax-highlighting zsh-completions)/' /root/.zshrc && \
    echo 'fpath+=${ZSH_CUSTOM}/plugins/zsh-completions/src' >> /root/.zshrc

RUN echo '' >> /root/.zshrc && \
    echo 'alias cat="bat --style=plain --paging=never"' >> /root/.zshrc && \
    echo 'alias catp="bat --style=full"' >> /root/.zshrc && \
    echo 'alias ls="lsd"' >> /root/.zshrc && \
    echo 'alias ll="lsd -lah"' >> /root/.zshrc && \
    echo 'alias lt="lsd --tree"' >> /root/.zshrc && \
    echo 'alias grep="rg"' >> /root/.zshrc && \
    echo 'alias find="fd"' >> /root/.zshrc && \
    echo '' >> /root/.zshrc && \
    echo 'alias subenum="subfinder -silent | dnsx -silent | httpx -silent"' >> /root/.zshrc && \
    echo 'alias portscan="nmap -sV --open -oN"' >> /root/.zshrc && \
    echo 'alias fastscan="masscan -p1-65535 --rate=1000"' >> /root/.zshrc && \
    echo '' >> /root/.zshrc && \
    echo 'cat /etc/motd' >> /root/.zshrc && \
    echo '' >> /root/.zshrc && \
    echo 'HISTSIZE=10000' >> /root/.zshrc && \
    echo 'SAVEHIST=10000' >> /root/.zshrc && \
    echo 'setopt HIST_IGNORE_ALL_DUPS' >> /root/.zshrc && \
    echo 'set EDITOR vim' >> /root/.zshrc && \
    echo 'setopt HIST_FIND_NO_DUPS' >> /root/.zshrc && \
    echo '' >> /root/.zshrc && \
    echo '[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh' >> /root/.zshrc

RUN echo 'syntax on' > /root/.vimrc && \
    echo 'set number' >> /root/.vimrc && \
    echo 'set relativenumber' >> /root/.vimrc && \
    echo 'set tabstop=4' >> /root/.vimrc && \
    echo 'set shiftwidth=4' >> /root/.vimrc && \
    echo 'set expandtab' >> /root/.vimrc && \
    echo 'set smartindent' >> /root/.vimrc && \
    echo 'set incsearch' >> /root/.vimrc && \
    echo 'set hlsearch' >> /root/.vimrc && \
    echo 'set ignorecase' >> /root/.vimrc && \
    echo 'set smartcase' >> /root/.vimrc && \
    echo 'set mouse=a' >> /root/.vimrc && \
    echo 'set clipboard=unnamedplus' >> /root/.vimrc && \
    echo 'set cursorline' >> /root/.vimrc && \
    echo 'set wildmenu' >> /root/.vimrc && \
    echo 'set laststatus=2' >> /root/.vimrc && \
    echo 'set encoding=utf-8' >> /root/.vimrc && \
    echo 'colorscheme desert' >> /root/.vimrc

RUN echo '# Enable mouse support' > /root/.tmux.conf && \
    echo 'set -g mouse on' >> /root/.tmux.conf && \
    echo '' >> /root/.tmux.conf && \
    echo '# Set prefix to Ctrl-a' >> /root/.tmux.conf && \
    echo 'unbind C-b' >> /root/.tmux.conf && \
    echo 'set -g prefix C-a' >> /root/.tmux.conf && \
    echo 'bind C-a send-prefix' >> /root/.tmux.conf && \
    echo '' >> /root/.tmux.conf && \
    echo '# Better split commands' >> /root/.tmux.conf && \
    echo 'bind | split-window -h' >> /root/.tmux.conf && \
    echo 'bind - split-window -v' >> /root/.tmux.conf && \
    echo '' >> /root/.tmux.conf && \
    echo '# Start windows and panes at 1, not 0' >> /root/.tmux.conf && \
    echo 'set -g base-index 1' >> /root/.tmux.conf && \
    echo 'setw -g pane-base-index 1' >> /root/.tmux.conf && \
    echo '' >> /root/.tmux.conf && \
    echo '# Enable 256 colors' >> /root/.tmux.conf && \
    echo 'set -g default-terminal "screen-256color"' >> /root/.tmux.conf && \
    echo '' >> /root/.tmux.conf && \
    echo '# Status bar customization' >> /root/.tmux.conf && \
    echo 'set -g status-bg colour235' >> /root/.tmux.conf && \
    echo 'set -g status-fg colour136' >> /root/.tmux.conf && \
    echo 'set -g status-left-length 30' >> /root/.tmux.conf && \
    echo 'set -g status-right "#[fg=colour166]#H #[fg=colour245]%Y-%m-%d %H:%M"' >> /root/.tmux.conf

COPY ./apps/sec-tools/motd.txt /etc/motd
COPY ./apps/sec-tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN sed -i 's|root:/bin/bash|root:/bin/zsh|g' /etc/passwd
WORKDIR /data
SHELL ["/bin/zsh", "-c"]
ENTRYPOINT ["/entrypoint.sh"]
CMD []
