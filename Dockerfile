FROM alpine:edge
ARG USERNAME=nixenv

RUN apk update && apk add --no-cache bash fish git nix direnv neovim tree-sitter stylua yazi zip unzip 7zip ripgrep stow openssh-client curl less fd fzf doas

RUN adduser -D -u 1000 -s /bin/fish $USERNAME
RUN echo "permit nopass $USERNAME as root" > /etc/doas.d/doas.conf && chmod 0400 /etc/doas.d/doas.conf

USER $USERNAME
WORKDIR /home/$USERNAME
ENV USER=$USERNAME
ENV HOME=/home/$USERNAME
ENV PATH="/home/$USERNAME/.local/bin:${PATH}"

# flake configuration
RUN mkdir -p ~/.config/nix && \
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf && \
    echo "cores = 0" >> ~/.config/nix/nix.conf && \
    echo "auto-optimise-store = true" >> ~/.config/nix/nix.conf && \
    echo "max-jobs = auto" >> ~/.config/nix/nix.conf && \
    echo "sandbox = false" >> ~/.config/nix/nix.conf

RUN curl -sSf https://raw.githubusercontent.com/infraflakes/kiru/main/install.sh | sh

RUN curl -sSf https://raw.githubusercontent.com/infraflakes/sutils/main/install.sh | sh

CMD ["sh", "-c", "/usr/bin/fish"]
