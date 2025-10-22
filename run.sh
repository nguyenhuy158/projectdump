#!/bin/bash
set -ex

TWINE_CONFIG_FILE="$(pwd)/.pypirc"

VENV_DIR=".venv"
if [ ! -d "$VENV_DIR" ]; then
  python3 -m venv "$VENV_DIR"
fi
source "$VENV_DIR/bin/activate"

PROJECT_NAME="projectdump"

echo "🚀 Setting up package structure..."
if [ ! -d "$PROJECT_NAME" ]; then
  mkdir -p "$PROJECT_NAME"
  mv *.py "$PROJECT_NAME"/ 2>/dev/null || true
fi

if [ ! -f "$PROJECT_NAME/__init__.py" ]; then
  touch "$PROJECT_NAME/__init__.py"
fi

echo "🧹 Cleaning old builds..."
rm -rf build dist *.egg-info

echo "📦 Installing build tools..."
python3 -m ensurepip --upgrade > /dev/null 2>&1 || true
python3 -m pip install --upgrade build twine > /dev/null

echo "🏗️ Building package..."
python3 -m build

echo ""
read -p "Where to upload? TestPyPI (t), PyPI (r), or both (b)? [t/r/b]: " TARGET

if [ "$TARGET" == "r" ]; then
  echo "🚀 Uploading to PyPI..."
  twine upload dist/*
elif [ "$TARGET" == "b" ]; then
  echo "🧪 Uploading to TestPyPI..."
  twine upload --repository testpypi dist/*
  echo "🚀 Uploading to PyPI..."
  twine upload dist/*
else
  echo "🧪 Uploading to TestPyPI..."
  twine upload --repository testpypi dist/*
fi

echo ""
echo "✅ Done!"
echo "Check your package at:"
echo " - TestPyPI: https://test.pypi.org/project/${PROJECT_NAME}/"
echo " - PyPI:     https://pypi.org/project/${PROJECT_NAME}/"
