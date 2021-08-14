ibrew='arch -x86_64 /usr/local/bin/brew'
mbrew='arch -arm64e /opt/homebrew/bin/brew'

alias cat="ccat"

newbs() {
    touch $1 && \
    chmod 775 $1 && \
    echo '#! /bin/bash\necho "Hello World!"' > $1 && \
}

gex() {
    if [ -z $1 ]
    then
        echo 'current exclude:'
        cat $(git rev-parse --show-toplevel)/.git/info/exclude
        echo '\nto add more, specify a pattern. e.g.:'
        echo '% gex tools/**.*\n'
        return 0
    else
        echo 'adding' $1 'to' $(git rev-parse --show-toplevel)'/.git/info/exclude'
        echo $1 >> $(git rev-parse --show-toplevel)/.git/info/exclude
        return 0
    fi
}
