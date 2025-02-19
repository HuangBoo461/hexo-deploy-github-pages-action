#!/bin/sh -l

set -e

# check values

if [ -n "${PUBLISH_REPOSITORY}" ]; then
    TARGET_REPOSITORY=${PUBLISH_REPOSITORY}
else
    TARGET_REPOSITORY=${GITHUB_REPOSITORY}
fi

if [ -n "${BRANCH}" ]; then
    TARGET_BRANCH=${BRANCH}
else
    TARGET_BRANCH="gh-pages"
fi

if [ -n "${PUBLISH_DIR}" ]; then
    TARGET_PUBLISH_DIR=${PUBLISH_DIR}
else
    TARGET_PUBLISH_DIR="./public"
fi

GITEE_TARGET_PUBLISH_DIR="${TARGET_PUBLISH_DIR}_gitee"

if [ -z "$PERSONAL_TOKEN" ]
then
  echo "You must provide the action with either a Personal Access Token or the GitHub Token secret in order to deploy."
  exit 1
fi

REPOSITORY_PATH="https://x-access-token:${PERSONAL_TOKEN}@github.com/${TARGET_REPOSITORY}.git"

# start deploy

echo ">>>>> Start deploy to ${TARGET_REPOSITORY} <<<<<"

# Installs Git.
echo ">>> Install Git ..."
apt-get update && \
apt-get install -y git && \

# Directs the action to the the Github workspace.
cd "${GITHUB_WORKSPACE}"

echo ">>> Install NPM dependencies ..."
npm install

echo ">>> Clean cache files ..."
npx hexo clean

echo ">>> Generate file ..."
npx hexo generate

cp -r "${TARGET_PUBLISH_DIR}" "${GITEE_TARGET_PUBLISH_DIR}"

cd "${TARGET_PUBLISH_DIR}"

# Configures Git.

echo ">>> Config git ..."

CURRENT_DIR=$(pwd)

git init
git config --global user.name "${GITHUB_ACTOR}"
git config --global user.email "${GITHUB_ACTOR}@outlook.com"
git config --global --add safe.directory "${CURRENT_DIR}"

git remote add origin "${REPOSITORY_PATH}"
git checkout --orphan "${TARGET_BRANCH}"

git add .

echo '>>> Start Commit ...'
git commit --allow-empty -m "Building and deploying Hexo project from Github Action"

echo '>>> Start Push ...'
git push -u origin "${TARGET_BRANCH}" --force

echo ">>> Deployment successful!"

echo "开始推送至 Gitee"
cd ..

cd "${GITEE_TARGET_PUBLISH_DIR}"

if [ -n "${GITEE_PUBLISH_REPOSITORY}" ]; then
    GITEE_TARGET_REPOSITORY=${GITEE_PUBLISH_REPOSITORY}
else
    GITEE_TARGET_REPOSITORY=${GITEE_PUBLISH_REPOSITORY}
fi
if [ -n "${GITEE_BRANCH}" ]; then
    GITEE_TARGET_BRANCH=${GITEE_BRANCH}
else
    GITEE_TARGET_BRANCH=${BRANCH}
fi

if [ -n "$GITEE_PERSONAL_TOKEN" ]
then
  GITEE_REPOSITORY_PATH="https://oauth2:${GITEE_PERSONAL_TOKEN}@gitee.com//${GITEE_TARGET_REPOSITORY}.git"
  git init
  git remote add origin "${GITEE_REPOSITORY_PATH}"
  git checkout --orphan "${GITEE_TARGET_BRANCH}"
  git add .
  echo '>>> 开始提交 ...'
  git commit --allow-empty -m "Building and deploying Hexo project from Github Action"
  echo '>>> 开始推送 ...'
  git push -u origin "${GITEE_TARGET_BRANCH}" --force
  echo ">>> 发布完成!"
fi
