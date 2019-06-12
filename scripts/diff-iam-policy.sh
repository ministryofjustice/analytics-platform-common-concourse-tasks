cat policies/list.json | jq -r '.[] | [.app_name, .role, (.policy|tostring)] | @tsv' |
  while IFS=$'\t' read -r app_name role policy; do
    echo $app_name
    echo $role
    current=$(aws iam get-role-policy --role-name $role --policy-name $app_name | jq -r '.PolicyDocument')
    echo $current | jq -S . > current.json
    echo $policy | jq -S . > new.json
    export ARE_SAME=$(jq --argfile a new.json --argfile b current.json -n '$a==$b')
    if [ \"$ARE_SAME\" != \"true\" ]; then
      echo -e '\033[0;31mChange in iam_policy.json'
      diff current.json new.json
      exit 166
    fi
    echo -e '\033[0;32mNo changes in iam_policy.json'
  done
echo -e '\033[0;32mNo changes in iam_policy.json'