%w(ctags git tree unzip zsh).each do |pkg|
  package pkg do
    action :install
  end
end
