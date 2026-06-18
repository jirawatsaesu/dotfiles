FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
      curl ca-certificates git jq zsh \
    && rm -rf /var/lib/apt/lists/*

RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin

COPY . /root/.local/share/chezmoi

WORKDIR /root
CMD ["sh", "-c", "chezmoi apply -v && exec bash"]
