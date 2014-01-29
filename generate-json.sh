#!/bin/bash

output="package.json"
firstDir=1
firstMod=1
hadMods=0

json="{\n  \"websites\": {"

for dir in * ; do
  if [ -d "$dir" ]; then
    echo "domain: $dir"
    firstMod=1
    hadMods=0
    if [ $firstDir = 0 ]; then
      json="${json},"
    fi

    for file in $dir/*.css ; do
      if [ -e $file ]; then
        echo "section: $file"
        version=`git hash-object $file`
        file=`basename $file`

        if [ $firstMod = 1 ]; then
          json="${json}\n    \"${dir}\": {\n      \"include\": \"*.${dir}\",\n      \"mods\": {"
          hadMods=1
        else
          json="${json},"
        fi

        json="${json}\n        \"${file%%.*}\": \"${version}\""

        firstMod=0
      fi
    done

    if [ $hadMods = 1 ]; then
      json="${json}\n      }\n    }"
      firstDir=0
    fi
  fi
done

json="${json}\n  }\n}"

echo -e "$json" > $output
cat $output
