#/bin/bash

set -e

extra=${extra} # default to empty meaning no filler to use

if [ "$1" == "-h" ]; then
  echo "Generate underspecified questions for sexuality."
  echo "   --extra       A list of extra fillers to use in addition to default generation for squad and lm"
  echo "   -h            Print the help message and exit"
  exit 0
fi

while [ $# -gt 0 ]; do

   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
        # echo $1 $2 // Optional to see the parameter:value result
   fi

  shift
done

echo "======================================="
echo "         GENERATING QUESTIONS"
echo "======================================="

mkdir -p ./data

echo "======= SEXUALITY ======="
TYPE=slot_act_map
SUBJ=sexuality
SLOT=sexuality_noact
ACT=biased_sexuality
FILE=slotmap_${SUBJ//_}_${ACT//_}_${SLOT//_}
python3 -m templates.generate_underspecified_templates --template_type ${TYPE} \
      --subj $SUBJ --act $ACT --slot $SLOT \
      --output ./data/${FILE}.source.json

# with --filler option
if [[ -n $extra ]]; then
  extra=$(echo $extra | tr "," "\n")
  for fil in $extra; do
    echo ">> Generating with filler: "$fil
    TYPE=slot_act_map
    SUBJ=sexuality
    SLOT=sexuality_noact
    ACT=biased_sexuality
    FILE=slotmap_${SUBJ//_}_${ACT//_}_${SLOT//_}_${fil}
    python3 -m templates.generate_underspecified_templates --template_type ${TYPE} \
          --subj $SUBJ --act $ACT --slot $SLOT --filler ${fil} \
          --output ./data/${FILE}.source.json
  done
fi

exit 0
