# a simple script that searches the file tree for dirs marked as project-bases
if [[ $# -ge 1 ]]; then
    baseDir=$1
else
    baseDir=$(pwd)
fi

findProjects() {
    # find all sub-directories
    find $1 -not -path '*/.*' -maxdepth 1 -mindepth 1 -type d &

    # find all sub-directories with a project-base marker and run this script on them
    for project in $(find $1 -maxdepth 2 -mindepth 2 -type f -name ".projectDir" -print0 | xargs -0 -r dirname)
    do
        findProjects $project
    done
}

{
    echo "/etc/nixos"
    findProjects $baseDir
}
