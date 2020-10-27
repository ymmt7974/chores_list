FROM ruby:2.6.6

# 本番環境の場合はコメントはずす
# ENV RAILS_ENV="production"

# 日本語ロケールへの変更
RUN apt-get update && \
    apt-get install -y \
    locales && \
    echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen && \
    update-locale LANG=ja_JP.UTF-8

# リポジトリを更新し依存モジュールをインストール
RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       libpq-dev \
                       nodejs \
                       vim
# chromeの追加
RUN apt-get update && apt-get install -y unzip && \
    CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/ && \
    unzip ~/chromedriver_linux64.zip -d ~/ && \
    rm ~/chromedriver_linux64.zip && \
    chown root:root ~/chromedriver && \
    chmod 755 ~/chromedriver && \
    mv ~/chromedriver /usr/bin/chromedriver && \
    sh -c 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && apt-get install -y google-chrome-stable
    
# ルート直下に作業ディレクトリを作成（コンテナ内のアプリケーションディレクトリ）
RUN mkdir /chores_list
WORKDIR /chores_list
# ホストのGemfileとGemfile.lockをコンテナにコピー
COPY Gemfile /chores_list/Gemfile
COPY Gemfile.lock /chores_list/Gemfile.lock

# bundle installの実行
# RUN gem install bundler
RUN bundle install

# ホストのアプリケーションディレクトリ内をすべてコンテナにコピー
COPY . /chores_list

# puma.sockを配置するディレクトリを作成
RUN mkdir -p tmp/pids
RUN mkdir -p tmp/sockets
