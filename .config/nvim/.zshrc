
<<<<<<< HEAD
=======
# Create or join tmux session based on current directory path
# Example: ~/projects/my-app -> projects_my_app
# Example: ~/.config/nvim -> config_nvim
# If session exists, attaches to it. If not, creates new session.
alias tmxa='tmux new-session -A -s $(pwd | sed "s|^$HOME/||" | sed "s/[^a-zA-Z0-9]/_/g" | sed "s/^_//")'
>>>>>>> Snippet
<<<<<<< HEAD
=======
# Create or join tmux session based on current directory path
# Example: ~/projects/my-app -> projects_my_app
# Example: ~/.config/nvim -> config_nvim
# If session exists, attaches to it. If not, creates new session.
alias tmxa='tmux new-session -A -s $(pwd | sed "s|^$HOME/||" | sed "s/[^a-zA-Z0-9]/_/g" | sed "s/^_//")'
>>>>>>> Snippet
