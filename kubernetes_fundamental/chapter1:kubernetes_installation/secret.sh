#!/bin/bash

TOCKEN=2278ay.8wmyktsnjzsvpwea
SHA256=5fa12e55b0185edc1680b53521b3507c35a3c04d51205fb649e6e6ef98c0ba64
sed -i -e "2a TOCKEN="2278ay.8wmyktsnjzsvpwea"" secret.sh
sed -i -e "3a SHA256="5fa12e55b0185edc1680b53521b3507c35a3c04d51205fb649e6e6ef98c0ba64"" secret.sh

if [[ worker_file.sh ]]
then
  sed -i -e "4a TOCKEN="2278ay.8wmyktsnjzsvpwea"" worker_file.sh
  sed -i -e "5a SHA256="5fa12e55b0185edc1680b53521b3507c35a3c04d51205fb649e6e6ef98c0ba64"" worker_file.sh
else
  exit
fi
