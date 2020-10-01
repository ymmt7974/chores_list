FROM ruby:2.6.6

# # 日本語ロケールへの変更
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
RUN mkdir -p tmp/sockets