#! /usr/bin/perl
# Script to generate README, help.ccc & POD for mtPaint tarball, then HTML for website
# Written for Bash by Mark Tyler, 14-10-2004
# Rewritten in Perl by Dmitry Groshev, 20-04-2007
# New help.c file format implemented, 12-05-2007
# Stored source textfiles inline, 14-01-2009

# ============================================================================
$ver = <<'VER';
mtPaint 3.40 - Copyright (C) 2004-2011 The Authors

See 'Credits' section for a list of the authors.

mtPaint is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

mtPaint is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

mtPaint is a simple GTK+1/2 painting program designed for creating icons and pixel based artwork. It can edit indexed palette or 24 bit RGB images and offers basic painting and palette manipulation tools. It also has several other more powerful features such as channels, layers and animation. Due to its simplicity and lack of dependencies it runs well on GNU/Linux, Windows and older PC hardware.

There is full documentation of mtPaint's features contained in a handbook.  If you don't already have this, you can download it from the mtPaint website.

If you like mtPaint and you want to keep up to date with new releases, or you want to give some feedback, then the mailing lists may be of interest to you:

http://sourceforge.net/mail/?group_id=155874
VER
# ============================================================================
$copy = <<'CPY';
/*	help.c
	Copyright (C) 2004-2011 Mark Tyler and Dmitry Groshev

	This file is part of mtPaint.

	mtPaint is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 3 of the License, or
	(at your option) any later version.

	mtPaint is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with mtPaint in the file COPYING.
*/
CPY
# ============================================================================
$readme = $ver . <<'__README__';

-----------
Compilation
-----------

In order to compile mtPaint on a GNU/Linux system you will need to have the libraries and headers for GTK+1 and/or GTK+2, libpng and zlib.  If you want to load or save GIF, JPEG and TIFF files you will also need libungif, libjpeg and libtiff.  If you want to compile the international version you will need to have the gettext system and headers installed.  You may then adjust the Makefile/sources to cater for your needs and then:

For GTK+2
=========

./configure
make
su -c "make install"

For GTK+1
=========

./configure gtk1
make
su -c "make install"


If you want to uninstall these files from your system, you should type:

su -c "make uninstall"

There are various configure options that may be useful for some people.  Use "./configure --help" to find out what options are available.  If you are compiling a binary for distribution to other peoples systems, the option 'asneeded' is particularly useful (if the gcc option -Wl,--as-needed is available, i.e. binutils >=2.17), as it only creates links to libraries which are absolutely necessary to mtPaint.  For example, without this option if you compile mtPaint against GTK+2.10 you will find it will not run on GTK+2.6 systems because Cairo doesn't exist on the older system.

Use "./configure release" to compile mtPaint with the same optimizations we use for distribution packages; this includes the "asneeded" option. To enable internationalization, add the "intl" option.

If you are compiling mtPaint on an older system without gtk-config, you may need to adjust the configure script so that the GTK+1 settings are done manually.  I have provided an example in the configure script to demonstrate.

You can call mtpaint with the -v option and the program will start in viewer mode so there will be no palette, menu bar, etc.  You can restore these items by pressing the "Home" key.  After installation you can create a symlink to add a viewer command, e.g.

su -c "ln -s mtpaint /usr/local/bin/mtv"

Then you can open some graphics files with "mtv *.jpg".  This is a shortcut to writing "mtpaint -v *.jpg".  mtPaint can only edit one image at a time, but when you have more than one filename in the command line a window will appear with all of the filenames in a list.  If you select one of the names, it will be loaded.  I find this is helpful for editing several icons or digital photos.

After running mtPaint for the first time, a new file is created to store your preferred settings and previously used files etc.  This file is named ".mtpaint" and stored in the user's home directory.  If you rename or remove this file then the next time mtPaint is run it will use the default settings.

The easiest way to compile mtPaint for Windows is using MinGW cross-compiler on a GNU/Linux system, and the included "winbuild.sh" shell script. The script will compile mtPaint and all required runtime files from source code, and prepare a binary package and a separate development package, with headers and development libraries; see "gtk/README" for details.

Another alternative is doing a manual build with MinGW on GNU/Linux, for which you'll need to have installed requisite library and header files, corresponding to the runtime libraries you intend to use. Since version 3.40, the official mtPaint package for Windows uses custom-built runtime files, and development libraries and headers, produced in the automated build process described above; with version 3.31 and earlier, you could use the packages listed below for MinGW/MSYS build. Either way, after the headers and libraries are installed where MinGW expects them, you configure mtPaint for cross-compiling, then run "make" as usual. Like this:

PATH=/usr/i586-mingw32/bin:$PATH ./configure --host=i586-mingw32 [options]
make

It should also still be possible to compile mtPaint for Windows the old way, using MinGW/MSYS on a Windows system. However this wasn't done for quite some time, so the description below still refers to older versions of MinGW, MSYS and library packages. mtpaint.exe compiled according to it, will only be compatible with runtime libraries packaged with mtPaint 3.31 or older; to use the newer runtime (of version 3.40+), you'll need to use library and header files produced while cross-compiling the runtime (see above).

If you want to do this you must first download the mtPaint 3.31 setup program and install the files to "C:/Program Files/mtPaint/" and then:

1) Install MinGW and MSYS - http://www.mingw.org/ 
MinGW-3.1.0-1.exe - to c:/MinGW/
MSYS-1.0.10.exe - to c:/msys/

2) Install the GTK+2 developer packages (and dependencies like libpng) - ftp://ftp.gtk.org/pub/gtk/v2.6/win32/ and http://gnuwin32.sourceforge.net/packages.html 

For GTK+2 you will need to download and extract the following zip files to c:/msys: 
gtk+-dev-2.6.4.zip
pango-dev-1.8.0.zip
atk-dev-1.9.0.zip

You will also need to download and extract the following zip files to c:/msys: 
glib-dev-2.6.4.zip
libpng-1.2.7-lib.zip
zlib-1.2.1-1-lib.zip
libungif-4.1.4-lib.zip
jpeg-6b-3-lib.zip
tiff-3.6.1-2-lib.zip

If you want to compile the internationlized version you will need to download and extract to c:/msys the following zip files from http://sourceforge.net/projects/gettext : 
gettext-runtime-0.13.1.bin.woe32.zip
gettext-tools-0.13.1.bin.woe32.zip
libiconv-1.9.1.bin.woe32.zip

For some reason I needed to move c:/msys/bin/msgfmt & xgettext to c:/msys/local/bin/ in order to get it to run properly. If you have trouble running msgfmt you may need to do the same. 

3) Download the latest mtPaint sources and unpack them to c:/msys. 

4) To compile the code you must then use MSYS to "./configure", then "make" and "make install" 

5) If all goes well, you should have mtpaint.exe which you can run using the same method described above.  You may have compiled mtPaint using more recent versions of libraries so you may need to change the filenames, such as libpng12.dll -> libpng13.dll and libungif.dll -> libungif4.dll.
 
Because I very rarely use Windows, I am sadly unable to support any other version of GTK+ but the one in the official package. That is, while mtPaint should in principle be able to compile and run with any version of GTK+2, only the packaged version has undergone real testing on Windows, and has been patched to fix all known Windows-specific bugs in it.
__README__
# ============================================================================
$D19 = <<'D19';
Keyboard shortcuts

  Ctrl-N            Create new image
  Ctrl-O            Open Image
  Ctrl-S            Save Image
  Ctrl-Shift-S      Save layers file
  Ctrl-Q            Quit program

  Ctrl-A            Select whole image
  Escape            Select nothing, cancel paste box
  J                 Lasso selection

  Ctrl-C            Copy selection to clipboard
  Ctrl-X            Copy selection to clipboard, and then paint current pattern to selection area
  Ctrl-V            Paste clipboard to centre of current view
  Ctrl-K            Paste clipboard to location it was copied from
  Ctrl-Shift-V      Paste clipboard to new layer
  Enter/Return      Commit paste to canvas
  Shift+Enter/Return  Commit paste and swap canvas into the clipboard

  Arrow keys        Paint Mode - Move the mouse pointer
  Arrow keys        Selection Mode - Nudge selection box or paste box by one pixel
  Shift+Arrow keys  Nudge mouse pointer, selection box or paste box by x pixels - x is defined by the Preferences window
  Ctrl+Arrows       Move layer or resize selection box
  Ctrl+Shift+Arrows  Move layer or resize selection box by x pixels

  Enter/Return      Paint Mode - Simulate left click
  Backspace         Paint Mode - Simulate right click

  [ or ]            Change colour A to the next or previous palette item
  Shift+[ or ]      Change colour B to the next or previous palette item

  Delete            Crop image to selection
  Insert            Transform colours - i.e. Brightness, Contrast, Saturation, Posterize, Gamma
  Ctrl-G            Greyscale the image
  Shift-Ctrl-G      Greyscale the image (Gamma corrected)
  Ctrl+M            Mirror the image
  Shift-Ctrl-I      Invert the image

  Ctrl-T            Draw a rectangle around the selection area with the current fill
  Ctrl-Shift-T      Fill in the selection area with the current fill
  Ctrl-L            Draw an ellipse spanning the selection area
  Ctrl-Shift-L      Draw a filled ellipse spanning the selection area

  Ctrl-E            Edit the RGB values for colours A & B
  Ctrl-W            Edit all palette colours

  Ctrl-P            Preferences
  Ctrl-I            Information

  Ctrl-Z            Undo last action
  Ctrl-R            Redo an undone action

  Shift-T           Text Tool (GTK+)
  T                 Text Tool (FreeType)

  V                 View Window
  L                 Layers Window

  B                 Toggle Snap to Tile Grid mode

  X                 Swap Colours A & B
  E                 Choose Colour

  A                 Draw open arrow head when using the line tool (size set by flow setting)
  S                 Draw closed arrow head when using the line tool (size set by flow setting)

  D                 Line Tool
  F                 Flood Fill Tool

  +,=               Main edit window - Zoom in
  -                 Main edit window - Zoom out
  Shift +,=         View window - Zoom in
  Shift -           View window - Zoom out

  1                 10% zoom
  2                 25% zoom
  3                 50% zoom
  4                 100% zoom
  5                 400% zoom
  6                 800% zoom
  7                 1200% zoom
  8                 1600% zoom
  9                 2000% zoom

  Shift + 1         Edit image channel
  Shift + 2         Edit alpha channel
  Shift + 3         Edit selection channel
  Shift + 4         Edit mask channel

  F1                Help
  F2                Choose Pattern
  F3                Choose Brush
  F4                Paint Tool
  F5                Toggle Main Toolbar
  F6                Toggle Tools Toolbar
  F7                Toggle Settings Toolbar
  F8                Toggle Palette
  F9                Selection Tool
  F12               Toggle Dock Area

  Ctrl + F1 - F12   Save current clipboard to file 1-12
  Shift + F1 - F12  Load clipboard from file 1-12

  Ctrl + 1, 2, ... , 0  Set opacity to 10%, 20%, ... , 100% (main or keypad numbers)
  Ctrl + + or =     Increase opacity by 1
  Ctrl + -          Decrease opacity by 1

  Home              Show or hide main window menu/toolbar/status bar/palette
  Page Up           Scale Image
  Page Down         Resize Image canvas
  End               Pan Window
D19
# ============================================================================
$D20 = <<'D20';
Mouse shortcuts

  Left button          Paint to canvas using the current tool
  Middle button        Selects the point which will be the centre of the image after the next zoom
  Right button         Commit paste to canvas / Stop drawing current line / Cancel selection

  Scroll Wheel         In GTK+2 the user can have the scroll wheel zoom in or out via the Preferences window

  Ctrl+Left button     Choose colour A from under mouse pointer
  Ctrl+Middle button   Create colour A/B and pattern based on the RGB colour in A (RGB images only)
  Ctrl+Right button    Choose colour B from under mouse pointer
  Ctrl+Scroll Wheel    Scroll the main edit window left or right

  Ctrl+Double click    Set colour A or B to average colour under brush square or selection marquee (RGB only)

  Shift+Right button   Selects the point which will be the centre of the image after the next zoom


You can fixate the X/Y co-ordinates while moving the mouse:

  Shift                Constrain mouse movements to vertical line
  Shift+Ctrl           Constrain mouse movements to horizontal line
D20
# ============================================================================
$D25 = <<'D25';
Credits

mtPaint is maintained by Dmitry Groshev.

wjaguar@users.sourceforge.net
http://mtpaint.sourceforge.net/

The following people (in alphabetical order) have contributed directly to the project, and are therefore worthy of gracious thanks for their generosity and hard work:


Authors

Dmitry Groshev - Contributing developer for version 2.30. Lead developer and maintainer from version 3.00 to the present.
Mark Tyler - Original author and maintainer up to version 3.00, occasional contributor thereafter.
Xiaolin Wu - Wrote the Wu quantizing method - see wu.c for more information.


General Contributions (Feedback and Ideas for improvements unless otherwise stated)

Abdulla Al Muhairi - Website redesign April 2005
Alan Horkan
Alexandre Prokoudine
Antonio Andrea Bianco
Dennis Lee
Donald White
Ed Jason
Eddie Kohler - Created Gifsicle which is needed for the creation and viewing of animated GIF files http://www.lcdf.org/gifsicle/
Guadalinex Team (Junta de Andalucia) - man page, Launchpad/Rosetta registration
Lou Afonso
Magnus Hjorth
Martin Zelaia
Pasi Kallinen
Pavel Ruzicka
Puppy Linux (Barry Kauler)
Vlastimil Krejcir
William Kern


Translations

Brazilian Portuguese - Paulo Trevizan, Valter Nazianzeno
Czech - Pavel Ruzicka, Martin Petricek, Roman Hornik
Dutch - Hans Strijards
French - Nicolas Velin, Pascal Billard, Sylvain Cresto, Johan Serre, Philippe Etienne
Galician - Miguel Anxo Bouzada
German - Oliver Frommel, B. Clausius, Ulrich Ringel
Hungarian - Ur Balazs
Italian - Angelo Gemmi
Japanese - Norihiro YONEDA
Polish - Bartosz Kaszubowski, LucaS
Portuguese - Israel G. Lugo, Tiago Silva
Russian - Sergey Irupin, Dmitry Groshev
Simplified Chinese - Cecc
Slovak - Jozef Riha
Spanish - Guadalinex Team (Junta de Andalucia), Antonio Sanchez Leon, Miguel Anxo Bouzada, Francisco Jose Rey, Adolfo Jayme
Swedish - Daniel Nylander, Daniel Eriksson
Tagalog - Anjelo delCarmen
Taiwanese Chinese - Wei-Lun Chao
Turkish - Muhammet Kara, Tutku Dalmaz
D25
# ============================================================================
$head1 = <<'HEAD';
<HTML>

<HEAD>
<TITLE>The mtPaint Handbook - Appendix C - The NEWS file from mtPaint</TITLE>
</HEAD>

<BODY>

<P>
<H1>Appendix C - The NEWS file from mtPaint</H1>

<HR>

HEAD
# ============================================================================
$head2 = <<'HEAD';
<HTML>

<HEAD>
<TITLE>The mtPaint Handbook - Appendix D - The README file from mtPaint</TITLE>
</HEAD>

<BODY>

<P>
<H1>Appendix D - The README file from mtPaint</H1>

<HR>

HEAD
# ============================================================================
$tail = <<'TAIL';
<P>
<HR>

</BODY>
</HTML>
TAIL
# ============================================================================



$HDOC1 = "chap_C.html";
$HDOC2 = "chap_D.html";
$HDOC_ = <mtpaint_handbook-*/docs/en_GB>;
$DISTRO = <../mtpaint-?.??*>;

# Let's read files all at once
undef $/;

# Generate README
sub lineit($)
{
	$_[0] =~ /^([^\n]*)(\n.*)$/s;
	my $l = '-' x length $1;
	return "$l\n$1\n$l$2\n";
}
$readme = lineit($readme) . lineit($D25);
open README, ">README";
binmode README;
print README $readme;
close README;

# Generate help.ccc
@inf = ( "General\n\n$ver", $D19, $D20, $D25 );

$HELP = "help.c";
open HELP, ">", $HELP;
binmode HELP;
print HELP "$copy\n#undef _\n#define _(X) X\n\n";
print HELP "#define HELP_PAGE_COUNT ", $#inf + 1, "\n";

print HELP "static char *help_titles[HELP_PAGE_COUNT] = {\n";
foreach (@inf)
{
	print HELP "_(\"", /^([^\n]*)/, "\"),\n";
}
print HELP "};\n\n";

$/ = "\n"; #for chomp()
for ($max = $i = 0; $i <= $#inf; $i++)
{
	print HELP "static char *help_page", $i, "[] = {\n";
	$inf[$i] =~ s/\\\"/\\\\\"/g;
	$inf[$i] =~ s/\n(?=\n)/\\n/g;
	@lines = split /^/m, $inf[$i];
	shift @lines;
	$max = $#lines + 1 unless $max > $#lines;
	chomp @lines;
	foreach (@lines)
	{
		print HELP "_(\"$_\"),\n";
	}
	print HELP "NULL };\n";
}
undef $/;
print HELP "#define HELP_PAGE_MAX ", $max + 1, "\n\n";

print HELP "static char **help_pages[HELP_PAGE_COUNT] = {\n\t";
for ($i = 0; $i <= $#inf; $i++)
{
	print HELP $i ? ", " : "", "help_page$i";
}
print HELP "\n};\n\n";

print HELP "#undef _\n#define _(X) __(X)\n";
close HELP;


print "----\n";
`ls -l README $HELP`;

`chmod a-w README $HELP`;
`mv -f README $DISTRO/.`;
`mv -f $HELP $DISTRO/src`;

# Replace &, >, <, characters with proper html codes
sub htmlize($)
{
	my $tmp = $_[0];
	$tmp =~ s/\&/\&amp;/g;
	$tmp =~ s/>/\&gt;/g;
	$tmp =~ s/</\&lt;/g;

	$tmp =~ s/\n/<BR>\n/g;
	return $tmp;
}

# Create HTML files from README & NEWS
open NEWS, "<", "$DISTRO/NEWS";
open HDOC, ">", $HDOC1;
binmode HDOC;
print HDOC $head1, htmlize <NEWS>, $tail;
close HDOC;

print $DISTRO, "\n";
open HDOC, ">", $HDOC2;
binmode HDOC;
print HDOC $head2, htmlize $readme, $tail;
close HDOC;

`mv $HDOC1 $HDOC_`;
`mv $HDOC2 $HDOC_`;
