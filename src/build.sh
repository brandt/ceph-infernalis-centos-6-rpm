#!/usr/bin/env bash

set -e

if [ "$(uname)" != "Linux" ]; then
  echo "Error: This script must be run from a Linux machine" >&2
  exit 1
fi

if [ ! -f ~mockbuild/rpmbuild/SPECS/*.spec ]; then
  echo "Error: Could not find spec file in: ~mockbuild/rpmbuild/SPECS/"
  exit 1
fi

su - mockbuild -c "rpmbuild -ba rpmbuild/SPECS/*.spec"

rsync -av rpmbuild/RPMS/ /artifacts/pkgs/RPMS/
rsync -av rpmbuild/SRPMS/ /artifacts/pkgs/SRPMS/
