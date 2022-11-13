alias ibrew='arch -x86_64 /usr/local/bin/brew'
alias mbrew='arch -arm64e /opt/homebrew/bin/brew'

alias cat='ccat'

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

gig() {
    FILE=$(git rev-parse --show-toplevel)/.gitignore
    echo $FILE
    # create .gitignore if needed
    if ! test -f "$FILE"; then
        echo "Info: Creating $FILE"
        touch $FILE
    fi

    if [ -z $1 ]; then
        echo 'current exclude:'
        cat $FILE
        echo '\nto add more, specify a pattern. e.g.:'
        echo '% gig tools/**.*\n'
        return 1
    else
        echo "adding $1 to $FILE"
        echo $1 >> $FILE
        return 0
    fi
}
