# -----ベースイメージの指定-----
FROM python:3.10-slim AS base

ARG workdir="/workspace"
WORKDIR $workdir
RUN apt-get update && pip install --upgrade pip

# -----本番環境用ビルダー-----
FROM base as builder
RUN pip install pipenv 

# ライブラリをシステムへ直接書き込む
COPY Pipfile Pipfile.lock $workdir/
RUN pipenv sync --system
EXPOSE 8501

# -----本番APP用------
FROM base AS app

HEALTHCHECK CMD curl --fail <http://localhost:8501/_stcore/health>

# ビルダーで展開したライブラリをアプリ用コンテナにコピー
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages/
COPY --from=builder /usr/local/bin/streamlit /usr/local/bin/streamlit
COPY . $workdir

ENTRYPOINT streamlit run app/main.py --server.port=8501 --server.address=0.0.0.0

# -----開発用(.devcontainerが接続する用)-----
FROM base AS development
# devcontainer上では仮想環境を作って開発する
RUN apt-get install -y git \
    && pip install pipenv