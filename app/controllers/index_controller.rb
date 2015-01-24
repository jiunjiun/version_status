class IndexController < ApplicationController
  def index
    git = GitService.new
    @logs = git.log
  end
end
