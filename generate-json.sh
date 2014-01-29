#!/bin/bash

output="package.json"
firstDir=1
firstMod=1
hadMods=0

json="{\n  \"websites\": {"

# loop on repository files
for dir in * ; do
  # if file is dir
  if [ -d "$dir" ]; then
    # reset variables
    firstMod=1
    hadMods=0

    # if not the first domain, add trailing comma
    if [ $firstDir = 0 ]; then
      json="${json},"
    fi

    # loop on domain folder files
    for file in $dir/*.css ; do
      if [ -e $file ]; then

        # get file version
        loop=1
        for str in `git ls-files -s $file` ; do
          if [ $loop = 0 ]; then
            version="$str"
            break;
          else
            loop=0
          fi
        done

        # if file is in git index
        if [[ $version != "" ]]; then
          # if its the first mod for the domain, write domain info
          if [ $firstMod = 1 ]; then
            # echo "domain: $dir"
            json="${json}\n    \"${dir}\": {\n      \"include\": \"*.${dir}\",\n      \"mods\": {"
            hadMods=1
          else # else add trailing comma after previous mod info
            json="${json},"
          fi

          file=`basename $file`
          # echo "mod: $file $version"
          # write mod info
          json="${json}\n        \"${file%%.*}\": \"${version}\""

          firstMod=0
        fi
      fi
    done

    # if domain had mods in git index, close domain object
    if [ $hadMods = 1 ]; then
      json="${json}\n      }\n    }"
      firstDir=0
    fi
  fi
done

# close json
json="${json}\n  }\n}"

# write json to file
echo -e "new $output generated:\n$json" > $output
cat $output
