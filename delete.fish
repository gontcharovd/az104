#!/usr/bin/env fish
for i in (seq 1 3)
  echo "deleting resource group $i"
  az group delete -g az104-06-rg$i --no-wait --yes
end
