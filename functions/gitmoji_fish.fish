function gitmoji_fish
  set -l CACHE_DIR $HOME/.cache/fish/gitmoji

  if not test -e $CACHE_DIR
    mkdir -p $CACHE_DIR
  end

  if not test -e $CACHE_DIR/gitmojis.json
    curl -so $CACHE_DIR/gitmojis.json 'https://raw.githubusercontent.com/carloscuesta/gitmoji/master/src/data/gitmojis.json'
  end

  if not test -e $CACHE_DIR/gitmojis.json
    echo "$CACHE_DIR/gitmojis.json is not found!!!"
    return 1
  end

  set -l CMD "
    cat $CACHE_DIR/gitmojis.json \
    | jq -r '.gitmojis[] | [.emoji , .code , .description] | @tsv' \
    | column -ts\t \
    | fzf $FZF_DEFAULT_OPTS \
    | awk '{ print(\$2) }'
  "
  set -l SHORTCODE (eval $CMD)
  if test -n "$SHORTCODE"
    set -l POSITION (commandline -C)
    commandline -i $SHORTCODE
    commandline -C (math $POSITION + (string length $SHORTCODE))
  end

  commandline -f repaint
end
