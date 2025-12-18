set -euo pipefail

export PATH=/opt/homebrew/bin:$PATH

for item in $(ls Setup/*); do
    $item
done