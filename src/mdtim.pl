#!/usr/bin/perl
#
#	Copyright (C) 2007-2016 Mark Tyler and Dmitry Groshev
#
#	mdtim is free software; you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation; either version 3 of the License, or
#	(at your option) any later version.
#
#	mdtim is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
#	You should have received a copy of the GNU General Public License
#	along with libmtpixel in the file COPYING.
#

# Written in C for libmtpixel 0.40 by Mark Tyler, 04-03-2008
# Rewritten in Perl for mtpaint 3.50 scripting by Dmitry Groshev, 07-02-2016

$font = "S Arial";
$title = "mtPaint Development Timeline";
$y_axis_title = "Kilobytes";
@key = ( "Code", "Binary", "Tarball" );
@balls = ( "img/ball-green.png", "img/ball-blue.png", "img/ball-yellow.png" );
@key_co = ( 641 - 7, 199 + 12, 697 - 7, 251 + 12 );
@main_co = ( 80, 50, 612, 424 );
@vnumi = ( [ 38206,  31,  24,  15, "0.03" ], [ 38243, 144,  99,  55, "0.23" ],
	   [ 38299, 334, 224, 107, "0.40" ], [ 38353, 389, 225, 123, "0.50" ],
	   [ 38454, 452, 253, 179, "0.90" ], [ 38571, 589, 322, 200, "2.00" ],
	   [ 38718, 641, 310, 233, "2.20" ], [ 38777, 713, 334, 260, "2.30" ],
# "Excel" release date; src/*.[ch]; default/gcc 3.4.6|/4.2.3|release; .tar.bz2
#/* 3.00 */	{38889,  774845 / 1024, /* 346412 */ 344464 /*361756*/ / 1024, 223640 / 1024},
	   [ 38889,  774845 / 1024, 344464 / 1024, 223640 / 1024, "3.00" ],
#/* 3.10 */	{39104,  913862 / 1024, /* 405440 */ 404472 /*439228*/ / 1024, 281619 / 1024},
	   [ 39104,  913862 / 1024, 404472 / 1024, 281619 / 1024, "3.10" ],
#/* 3.20 */	{39443, 1075317 / 1024, /* 456408 */ 451688 /*430020*/ / 1024, 389264 / 1024},
	   [ 39443, 1075317 / 1024, 451688 / 1024, 389264 / 1024, "3.20" ],
#/* 3.30 */	{40149, 1241833 / 1024, /* 513932 */ 518300 /*505972*/ / 1024, 497876 / 1024},
	   [ 40149, 1241833 / 1024, 518300 / 1024, 497876 / 1024, "3.30" ],
#/* 3.40 */	{40907, 1465096 / 1024, /* 582972 */ 585232 /*540080*/ / 1024, 600857 / 1024},
	   [ 40907, 1465096 / 1024, 585232 / 1024, 600857 / 1024, "3.40" ],
);
$VNODES = scalar @vnumi;
@axis_x = ( 38169, 40908 ); @axis_y = ( 0, 1500 );
$width = 713; $height = 455;

sub list
{
	my @v;
	push @v, int(shift @_) . "," . int(shift @_) while @_;
	return "(" . join(" ", @v) .") ";
}

$sc = "mtpaint --cmd ";
$sc .= "-f/new w=$width h=$height =24 ";
#	mtpaint_new_image(width, height, 256, 0, 3);
$sc .= "-e/set grad=1 ";
#	mtpaint_mode_set( MT_MODE_GRADIENT );
$sc .= "-e/col a=7 b=115 ";
#	mtpaint_col_a(7); mtpaint_col_b(115);
$sc .= "-e/tool grad " . list(0, 0, $width, $height);
#	mtpaint_gradient_position( 0, 0, width, height );
$sc .= "-e/tool grad: type=lin ext=mirror grad=rgb opac=only ";
#	mtpaint_gradient( 0, 0, 0, GRAD_MODE_LINEAR, GRAD_BOUND_MIRROR,
#				GRAD_TYPE_RGB, 0, GRAD_TYPE_CONST, 0 );
$sc .= "-s/all " . list(1, 1, $width - 2, $height - 2) . "-s/fill ";
#	mtpaint_rectangle( 1, 1, width-2, height-2, 0 );		// White background
$sc .= "-e/tool grad " . list(0, 0, 0, $height);
#	mtpaint_gradient_position( 0, 0, 0, height );
$sc .= "-e/col b=8 a=93 ";
#	mtpaint_col_b(8); mtpaint_col_a(93);
$sc .= "-s/all " . list($main_co[0] + 1, $main_co[1] + 1,
		$main_co[2] - 1, $main_co[3] - 1) . "-s/fill ";
#	mtpaint_rectangle( main_co[0]+1, main_co[1]+1, main_co[2]-1, main_co[3]-1, 0 );	// Main area
$sc .= "-s/all " . list($key_co[0] + 1, $key_co[1] + 1,
		$key_co[2] - 1, $key_co[3] - 1) . "-s/fill ";
#	mtpaint_rectangle( key_co[0]+1, key_co[1]+1, key_co[2]-1, key_co[3]-1, 0 );	// Key area
$sc .= "-e/set grad=0 ";
#	mtpaint_mode_clear( MT_MODE_GRADIENT );
$sc .= "-e/col a=0 ";
#	mtpaint_col_a(0);
$sc .= "-s/all " . list(@main_co) . "-s/outline ";
#	mtpaint_rectangle( main_co[0], main_co[1], main_co[2], main_co[3], 1 );	// Main area border
$sc .= "-s/all " . list(@key_co) . "-s/outline ";
#	mtpaint_rectangle( key_co[0], key_co[1], key_co[2], key_co[3], 1 );	// Key area border

$sc .= "-e/freetype font='$font' size=14 back=-1 -s/no ";
#		mtpaint_text(txt, strlen(txt), font_filename, "ASCII", 14, 0, 0, MT_TEXT_SHRINK);
for ($i = $axis_y[0]; $i <= $axis_y[1]; $i += 100)	# Y axis major gridlines
{
	$f = ($i - $axis_y[0]) / ($axis_y[1] - $axis_y[0]);
	$j = $f * $main_co[1] + (1 - $f) * $main_co[3];
	$sc .= "-e/tool line " . list($main_co[0] - 6, $j, $main_co[2], $j);
#		mtpaint_line( main_co[0]-6, j, main_co[2], j, 1 );
	$sc .= "-e/freetype t=$i ";
#		snprintf(txt, 128, "%i", i);
#		mtpaint_text(txt, strlen(txt), font_filename, "ASCII", 14, 0, 0, MT_TEXT_SHRINK);
	$sc .= "-e/paste centre right " . list($main_co[0] - 10, $j);
#		mtpaint_mem_clip_geometry( NULL, &mcw, &mch );
#		mtpaint_paste(main_co[0]-9- mcw, j-mch/2);
}

$j2 = $main_co[0];
$k = 2004;
for ($i = 38352; $i <= $axis_x[1]; $i += 365)	# X axis minor gridline
{
	$i++ if ($k > 2004 && !($k % 4));	# Leap year adjustment
	$f = ($i - $axis_x[0]) / ($axis_x[1] - $axis_x[0]);
	$j = $f * $main_co[2] + (1 - $f) * $main_co[0];
	$sc .= "-e/tool line " . list($j, $main_co[3], $j, $main_co[3] + 6);
#		mtpaint_line( j, main_co[3], j, main_co[3]+6, 1 );
	$sc .= "-e/freetype t=$k ";
#		snprintf(txt, 128, "%i", k);
#		mtpaint_text(txt, strlen(txt), font_filename, "ASCII", 14, 0, 0, MT_TEXT_SHRINK);
	$sc .= "-e/paste centre top " . list(($j + $j2) / 2, $main_co[3] + 6);
#		mtpaint_mem_clip_geometry( NULL, &mcw, &mch );
#		mtpaint_paste( (j+j2)/2 - mcw/2, main_co[3]+6);
	$j2 = $j;
	$k++;
}

$sc .= "-e/freetype t='$title' size=22 ";
#	mtpaint_text(title, strlen(title), font_filename, "ASCII", 22, 0, 0, MT_TEXT_SHRINK);
$sc .= "-e/paste centre " . list(($main_co[0] + $main_co[2]) / 2, $main_co[1] / 2);
##	mtpaint_mem_clip_geometry( NULL, &mcw, &mch );
#	mtpaint_paste( (main_co[0] + main_co[2])/2 - mcw/2, main_co[1]/2 - mch/2);
$sc .= "-e/freetype t='$y_axis_title' size=16 angle=90 ";
#	mtpaint_text(y_axis_title, strlen(y_axis_title), font_filename, "ASCII",
#			16, 0, 90, MT_TEXT_SHRINK);
$sc .= "-e/paste centre left " . list(16, ($main_co[1] + $main_co[3]) / 2);
#	mtpaint_mem_clip_geometry( NULL, &mcw, &mch );
#	mtpaint_paste( 16, (main_co[1] + main_co[3])/2 - mch/2);

$sc .= "-e/freetype size=12 angle=0 -s/no ";
#		mtpaint_text(key[i], strlen(key[i]), font_filename, "ASCII", 12, 0, 0, 0);
for ($i = 0; $i < 3; $i++)			# Key
{
	$sc .= "-e/freetype t='$key[$i]' ";
#		mtpaint_text(key[i], strlen(key[i]), font_filename, "ASCII", 12, 0, 0, 0);
	$j = $key_co[1] + 9 + $i * ($key_co[3] - $key_co[1]) / 3;
	$sc .= "-e/paste centre left " . list($key_co[0] + 17, $j);
#		mtpaint_mem_clip_geometry( NULL, &mcw, &mch );
#		mtpaint_paste( key_co[0]+17, j - mch/2 );
	$sc .= "-f/open='$balls[$i]' undo=1 -s/all -e/copy -e/undo ";
#		mtpaint_clipboard_load(balls[i]);
	$sc .= "-e/paste centre left " . list($key_co[0] + 3, $j);
#		mtpaint_mem_clip_geometry( NULL, &mcw, &mch );
#		mtpaint_paste( key_co[0]+3, j - mch/2 );
}

for ($q = 3; $q >= 0; $q--)			# Coloured balls and text labels
{
	$i = $q - !!$q;
	$sc .= "-f/open='$balls[$i]' undo=1 -s/all -e/copy -e/undo ";
#		mtpaint_clipboard_load(balls[i]);
	for ($j = 0; $j < $VNODES; $j++)
	{
#			mtpaint_opacity(255);
		$f = ($vnumi[$j][0] - $axis_x[0]) / ($axis_x[1] - $axis_x[0]);
		$x = $f * $main_co[2] + (1 - $f) * $main_co[0];
		$f = ($vnumi[$j][1 + $i] - $axis_y[0]) / ($axis_y[1] - $axis_y[0]);
		$y = $f * $main_co[1] + (1 - $f) * $main_co[3];

		$sc .= "-e/paste centre " . list($x, $y) if $q > 0;
#			mtpaint_mem_clip_geometry( NULL, &mcw, &mch );
#			mtpaint_paste( x - mcw/2, y - mch/2 );
		next if $q > 0;
#			if (i==0)
		$sc .= "-e/freetype t='$vnumi[$j][4]' ";
#			mtpaint_text(vnums[j], strlen(vnums[j]), font_filename, "ASCII",
#					12, 0, 0, MT_TEXT_SHRINK);
		$sc .= "-e/paste centre bottom " . list($x, $y - 9);
#			mtpaint_mem_clip_geometry( NULL, &mcw, &mch );
#			mtpaint_paste( x - mcw/2, y - mch - 8 );
	}
}

$sc .= "-f/as=mdtim.png ";
#	mtpaint_file_save("test1.png", FT_PNG, 5);

$sc =~ s/([\(\)])/\\$1/g; # Quote for the shell
#print "#!/bin/sh\nsrc/$sc\n";
system($sc);
