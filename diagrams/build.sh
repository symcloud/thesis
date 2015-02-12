#!/bin/sh
for txt in *.txt
do
    ditaa -E $txt
done
