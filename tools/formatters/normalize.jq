# https://stackoverflow.com/questions/38257725/how-can-i-completely-sort-arbitrary-json-using-jq

# This jq function/snippet is used by our bash script write_sorted_json.sh

# Apply f to composite entities recursively using keys[], and to atoms
def sorted_walk(f):
  . as $in
  | if type == "object" then
      reduce keys[] as $key
        ( {}; . + { ($key):  ($in[$key] | sorted_walk(f)) } ) | f
  elif type == "array" then map( sorted_walk(f) ) | f
  else f
  end;

def normalize: sorted_walk(if type == "array" then sort else . end);

normalize
