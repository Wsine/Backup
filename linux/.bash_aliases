alias tmux="tmux -2"
alias valgrindUse="valgrind --leak-check=yes --show-reachable=yes --trace-children=yes --log-file=./valgrind_result.txt"
alias op="nautilus >/dev/null 2>&1"
alias tmuxcopy="xargs tmux set-buffer"

function dockerbuild() {
  command docker build --build-arg UID=$(id -u) --build-arg GID=$(id -g) \
    --build-arg UNAME=$USER -t $(basename $PWD)-dev -f Dockerfile.dev .
}

function dockerrun() {
  export ProjName="$(basename $PWD)"
  command docker run -dit --name "$ProjName"-d -u $USER \
    -v $PWD:/"$ProjName" -w /"$ProjName" "$ProjName"-dev
}

function dockerinto() {
  command docker exec -u $USER -it $(basename $PWD)-d /bin/bash
}
