#!/bin/bash -e

modules="."

toplevel=".idea .idea_modules"
moduleSubdirs="target project/project project/target"

restore=".idea/runConfigurations"

curr=$(pwd -P)
cd $(cd -P -- "$( dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
cd ..

echo "Manually cleaning this project..."

echo "  Backing up designated directories..."
restoreThatExist=
for dir in $restore ; do
  test -d "$dir" && {
    restoreThatExist="$restoreThatExist $dir"
  } || true
done
if [ "$restoreThatExist" != "" ]; then
  tar cf ".backup.tar" $restoreThatExist
fi

echo "  Removing the following directories:"

find . -name ".DS_Store" -exec rm -rf {} \;

for dir in $toplevel ; do
  test -d "$dir" && {
    echo "    $(cd "$dir" && pwd -P)"
    rm -rf "$dir"
  } || true
done

for module in $modules ; do
  for subdir in $moduleSubdirs ; do
    dir=$module/$subdir
    test -d "$dir" && {
      echo "    $(cd "$dir" && pwd -P)"
      rm -rf "$dir"
    } || true
  done
done

echo "  Restoring designated directories..."
if [ -f ".backup.tar" ]; then
  tar xf ".backup.tar"
  rm -f ".backup.tar"
fi

cd "$curr"

