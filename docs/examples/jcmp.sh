#!/bin/sh
# Compare lossy image compression methods
INP=${1:-../img/6.8.3a.png}
LOC=`mktemp -d`
TMPL=${LOC:-/tmp}/tempfile

info ()
{
	pamchannel -infile="$TMPD" $1 | pamsumm -$2 -brief
}

diffs ()
{
TMPD=$2
cat << DIFFS

$1
	Maximum diff	Average diff
Red	`info 0 max`		`info 0 mean`
Green	`info 1 max`		`info 1 mean`
Blue	`info 2 max`		`info 2 mean`
DIFFS
}

mtpaint --cmd -f/open="$INP" -i/rgb \
	-f/as="$TMPL".t.jpg form=jpeg jpeg=95 \
	-f/as="$TMPL".t.jp2 form=jpeg2000 jpeg2000=6 \
	-s/all -e/copy -e/set blend: =diff : blend \
	-f/open="$TMPL".t.jpg -e/paste -f/as="$TMPL".tj.pam form=pam \
	-f/open="$TMPL".t.jp2 -e/paste -f/as="$TMPL".t2.pam form=pam 1>&2

diffs "JPEG (95)" "$TMPL".tj.pam
diffs "JP2 (6)" "$TMPL".t2.pam
rm "$TMPL".t.jpg "$TMPL".tj.pam
rm "$TMPL".t.jp2 "$TMPL".t2.pam
rmdir "$LOC"
