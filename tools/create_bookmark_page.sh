#!/usr/bin/env -S nix shell nixpkgs-unstable#pup --command bash

test -n "$1" || exit 1

function get_link_title(){
    curl "$1" | pup 'title text{}'
}

function file_name(){
    echo "$1" | tr -- ' ' '-'
}


BOOKMARK_LINK="$1"
BOOKMARK_TITLE="${2:-$(get_link_title $BOOKMARK_LINK)}"
BOOKMARKS_DIR=content/bookmarks
BOOKMARK_NAME="$(file_name "$BOOKMARK_TITLE").md"
BOOKMARK_FILE=$BOOKMARKS_DIR/$BOOKMARK_NAME
HUGO="/usr/bin/env hugo"

# use hugo to render archetype template
${HUGO} new "$BOOKMARKS_DIR/$BOOKMARK_NAME"
cat >> "$BOOKMARKS_DIR/$BOOKMARK_NAME" <<EOF
[$BOOKMARK_TITLE]($BOOKMARK_LINK)
EOF
$EDITOR "$BOOKMARK_FILE"
