# a simple script that searches the file tree for dirs marked as project-bases

if [[ $# -eq 1 ]]; then
    baseDir=$1
else
    baseDir=$(pwd)
fi

{
    # i just want to edit my dotfiles, leave me allone
    echo "$DOTFILES" &

    # find all sub-directories
    find $baseDir -maxdepth 1 -mindepth 1 -type d &

    # find all sub-directories with a project-base marker and run this script on them
    find $baseDir -maxdepth 2 -mindepth 2 -type f -name ".projectDir" -print0 | xargs -0 -r dirname | xargs -r -L 1 project-finder
}
