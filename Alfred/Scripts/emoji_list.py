#!/Users/leigh/Library/Caches/pypoetry/virtualenvs/alfred-scripts-BPvZfXzi-py3.9/bin/python

import xml.etree.ElementTree as ET
import json
from collections import defaultdict
import base64

tree = ET.parse("/Users/leigh/Downloads/cldr-common-39.0/common/annotations/en.xml")
root = tree.getroot()

output = defaultdict(lambda: {"name": None, "alt_names": []})
for annot in root.findall(".//annotation"):
    emoji = annot.attrib["cp"]
    typ = annot.attrib.get("type")
    if typ == "tts":
        output[emoji]["name"] = annot.text
    else:
        output[emoji]["alt_names"].extend(x.strip() for x in annot.text.split("|"))

# add constants here

output[""]

items = []

for emoji, props in output.items():
    items.append(
        {
            "uid": emoji,
            "title": f"{emoji} {props['name']}",
            "arg": base64.b64encode(emoji.encode('utf8')).decode('utf8'),
            "match": f"{props['name']} {' '.join(props['alt_names'])}",
        }
    )

print(json.dumps({"items": items}))
