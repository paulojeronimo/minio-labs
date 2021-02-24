#!/usr/bin/env bash
cd "$(dirname "${BASH_SOURCE[0]}")"
export MINIO_LABS=${MINIO_LABS:-$PWD}
export PATH=$MINIO_LABS/bin:$PATH
cd "$OLDPWD"

minio-labs() {
	cd "$MINIO_LABS"
}

which wget &> /dev/null || {
	echo "Install wget!"
	return 1
}
case "$OSTYPE" in
  darwin*)
    which gsed &> /dev/null || {
      echo -e "Install gsed!\n$ brew install gnu-sed"
      return 1
    }
    sed() { gsed "$@"; }
    which ggrep &> /dev/null || {
      echo -e "Install ggrep!\n$ brew install grep"
      return 1
    }
    function grep { ggrep "$@"; }
esac
profile=~/.bash_profile
[[ $OSTYPE =~ ^linux ]] && profile=~/.bashrc
functions_sh=$MINIO_LABS/functions.sh
if ! [ -f $profile ] || ! grep -q "^source \"$functions_sh\"$" $profile; then
  echo "source \"$functions_sh\"" >> $profile
  echo "'source \"$functions_sh\"' added to $profile"
fi
