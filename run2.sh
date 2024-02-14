set -euo pipefail

export ASDF_DIR=/opt/homebrew/opt/asdf/libexec
export ASDF_DATA_DIR=~/Library/asdf
export PATH=~/Library/asdf/shims:/opt/homebrew/bin:$PATH

for item in $(ls Setup/*); do
    $item
done