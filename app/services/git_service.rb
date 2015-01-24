#!/usr/bin/env ruby
class GitService
  def initialize

  end

  def log
    if Rails.env.production?
      logs = %x[cd ../scm && git log --pretty=format:"%h,%an,%ar,%cd,%s"].split(/\n/)
    else
      logs = %x[git log --pretty=format:"%h,%an,%ar,%cd,%s"].split(/\n/)
    end

    logs.map! { |list| list.split(",") }
    logs.each { |list| list[3] = list[3].to_time }
  end
end