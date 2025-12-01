function sudo
  command sudo -v
  command sudo $argv
end

function docs --description 'Open Neovim in DocsNNotes and set kitty tab title'
    __project_nvim docs $HOME/DocsNNotes $argv
end

function todo --description 'Open Neovim in Todo directory and set kitty tab title'
    __project_nvim todo $HOME/Todo $argv
end

function notes --description 'Open Neovim in Notes directory and set kitty tab title'
    __project_nvim notes $HOME/Notes $argv
end

alias tree='eza --tree --all --git-ignore --ignore-glob ".git"'
