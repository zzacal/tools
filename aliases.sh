alias cat="ccat"

newbs() {
    touch $1 && \
    chmod 775 $1 && \
    echo '#! /bin/bash\necho "Hello World!"' > $1 && \
}
