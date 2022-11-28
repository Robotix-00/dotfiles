# a simple script that searches the file tree for dirs marked as project-bases
if [[ $# -ge 1 ]]; then

    # if called with argument 'base', add all static projdirs once
    if [ $# -eq 2 ] && [ $2 = "base" ]; then
        echo "/etc/nixos"
        echo "/mnt"
    fi

    baseDir=$1
else
    baseDir=$(pwd)
fi

{
    # find all sub-directories
    find $baseDir -not -path '*/.*' -maxdepth 1 -mindepth 1 -type d &

    # find all sub-directories with a project-base marker and run this script on them
    find $baseDir -maxdepth 2 -mindepth 2 -type f -name ".projectDir" -print0 | xargs -0 -r dirname | xargs -r -L1 $0
}
