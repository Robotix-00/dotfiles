# stolen from ThePrimeagen's dotfiles and adapted

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(project-finder "$HOME" | fzf-tmux -p)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
    tmux set -t$selected_name set-titles-string "Project $selected_name"
fi


if [[ -z $TMUX ]]; then
    tmux attach -t $selected_name
else
    tmux switch-client -t $selected_name
fi

