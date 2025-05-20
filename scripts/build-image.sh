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
    echo -e "${nocolor}"
    exit 1
}

# acquiring opts, prints helpFunction in case parameter is non-existent
while getopts "i:t:s:" opt
do
   case "$opt" in
        i ) image="$OPTARG" ;;
        t ) tag="$OPTARG" ;;
        s ) suffix="$OPTARG" ;;
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

#####  SCRIPT  #####

project_root=/workspaces/containers

docker build -t "armck/$image:$tag-$suffix" \
    -f "containers/$image/$tag/Dockerfile.$suffix" \
    $project_root
