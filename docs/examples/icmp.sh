#!/bin/sh
# Compare 2 image files
LOC=`mktemp -d`
TMPD=${LOC:-/tmp}/tempfile.pam
mtpaint --cmd -f/open="$2" -i/rgb -s/all -e/copy -f/open="$1" -i/rgb \
	-e/set blend: =diff : blend -e/paste -f/as="$TMPD" form=pam 1>&2

info ()
{
	pamchannel -infile="$TMPD" $1 | pamsumm -$2 -brief
}

cat << DIFFS
	Maximum diff	Average diff
Red	`info 0 max`		`info 0 mean`
Green	`info 1 max`		`info 1 mean`
Blue	`info 2 max`		`info 2 mean`
DIFFS
rm "$TMPD"
rmdir "$LOC"
