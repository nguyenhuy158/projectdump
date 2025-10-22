#!/bin/bash
set -e

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
pip install --upgrade build twine > /dev/null

echo "🏗️ Building package..."
python3 -m build

echo ""
read -p "Do you want to upload to TestPyPI (t) or real PyPI (r)? [t/r]: " TARGET

if [ "$TARGET" == "r" ]; then
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
