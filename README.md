# version_status

最近在逛APP有時候會看到目前的版本狀態，想說在開發同時也可以把`git log`

將版本狀態加入到後台裡面，也可以比較清楚目前最新的功能跟修改的內容完整始

首先先在 Rails app目錄下新增`services`，新增 `git_service.rb` 在裡面寫我們要抓的指令

```
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
```

接著在`Controller`增加一個action

```
def index
  git = GitService.new
  @logs = git.log
end
```

最後在view的index.html.haml修飾一下

```
%table
  %thead
    %tr
      %th #
      %th 時間
      %th 更新人員
      %th 內容
  %tbody
    - @logs.each do |log|
      %tr
        %td= log[0]
        %td= log[2]
        %td= log[1]
        %td= truncate(log[4], length: 25)
```

參考資料：
[http://git-scm.com/book/zh-tw/v1/Git-%E5%9F%BA%E7%A4%8E-%E6%AA%A2%E8%A6%96%E6%8F%90%E4%BA%A4%E7%9A%84%E6%AD%B7%E5%8F%B2%E8%A8%98%E9%8C%84](http://git-scm.com/book/zh-tw/v1/Git-%E5%9F%BA%E7%A4%8E-%E6%AA%A2%E8%A6%96%E6%8F%90%E4%BA%A4%E7%9A%84%E6%AD%B7%E5%8F%B2%E8%A8%98%E9%8C%84)

Blog: [http://jiunjiun.logdown.com/posts/2015/01/24/rails-version-of-git-log](http://jiunjiun.logdown.com/posts/2015/01/24/rails-version-of-git-log)

## Copyright / License
* Copyright (c) 2015 jiunjiun (quietmes At gmail.com)
* Licensed under [MIT](http://opensource.org/licenses/MIT) licenses.
