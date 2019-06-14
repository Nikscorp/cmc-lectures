#!/usr/bin/env bash
#title           :gitbook.sh
#description     :This script generates gitbook documentation on a travis build
#==============================================================================

set -e
set -x

SRC_FOLDER="src"
MAIN_BRANCH="master"
UPSTREAM="https://$GITHUB_TOKEN@github.com/$TRAVIS_REPO_SLUG.git"
MESSAGE="Rebuild doc for revision $TRAVIS_COMMIT: $TRAVIS_COMMIT_MESSAGE"
AUTHOR="$USER <>"

if [ "$TRAVIS_PULL_REQUEST" != "false" ];then
  echo "Documentation won't build on pull request"
  exit 0
fi

if [ "$TRAVIS_BRANCH" != "$MAIN_BRANCH" ];then
  echo "Documentation won't build: Not on branch $MAIN_BRANCH"
  exit 0
fi

function setup() {
  npm install -g gitbook-cli
  apt-get install -y xdg-utils wget xz-utils
  sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
}

function build() {
  pushd "$SRC_FOLDER"
  gitbook install
  gitbook build
  gitbook pdf ./ ./lectures.pdf
  mkdir -p ./_book/pdf/
  cp ./lectures.pdf ./_book/pdf/.
  popd
}

function publish() {
  pushd "$SRC_FOLDER"/_book
  git init
  git remote add upstream "$UPSTREAM"
  git fetch --prune upstream
  git reset upstream/gh-pages
  git add --all .
  if git commit --message "$MESSAGE" --author "$AUTHOR" ; then
    git push --quiet upstream HEAD:gh-pages
  fi
  popd
}

function main() {
  setup && build && publish
}

main