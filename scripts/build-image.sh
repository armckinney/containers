#!/bin/bash

# constants
blue='\e[0;34m'
red='\e[0;31m'
nocolor='\e[0m'

#####  POptArts  #####
# terminal help function, exits script after execution
helpFunction()
{
    echo -e "${blue}"
    echo "Usage: $0 -i ubuntu -t 20.04 -s dev"
    echo -e "\t -i   Image name to build. Type: string."
    echo -e "\t -t   Image tag to build. Type: string."
    echo -e "\t -s   Image tag suffix to build. Type: string. Default: dev"
    echo -e "\t -a   Flag for building multiarch images. Supports: linux/amd64,linux/arm64"
    echo -e "${nocolor}"
    exit 1
}

# acquiring opts, prints helpFunction in case parameter is non-existent
while getopts "i:t:s:a" opt
do
   case "$opt" in
        i ) image="$OPTARG" ;;
        t ) tag="$OPTARG" ;;
        s ) suffix="$OPTARG" ;;
        a ) multiarch=1 ;;
        ? ) helpFunction ;;
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$image" ] || [ -z "$tag" ]
then
   echo -e "\t${red}Some or all of the parameters are empty${nocolor}";
   helpFunction
fi

# variable override
if [ -z "$suffix" ]; then suffix="dev"; fi

# set platforms if multiarch flag is set
if [ "$multiarch" = "1" ]; then
    echo -e "${blue}Building multiarch image for $image:$tag-$suffix${nocolor}"
    platforms="--platform linux/amd64,linux/arm64"
else
   echo -e "${blue}Building image for $image:$tag-$suffix${nocolor}"
   platforms=""
fi

#####  SCRIPT  #####

project_root=/workspaces/containers

docker buildx build $platforms -t "armck/$image:$tag-$suffix" \
    -f "containers/$image/$tag/Dockerfile.$suffix" \
    $project_root
