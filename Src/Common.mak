# ------------------------------------------------------------------------------
# This Source Code Form is subject to the terms of the Mozilla Public License,
# v. 2.0. If a copy of the MPL was not distributed with this file, You can
# obtain one at http://mozilla.org/MPL/2.0/
#
# Copyright (C) 2010-2012, Peter Johnson (www.delphidabbler.com).
#
# $Rev$
# $Date$
#
# Common code for inclusion in all make files. Defines common macros and rules.
# Files that require Common.mak must include it using the !include directive.
# ------------------------------------------------------------------------------


# The preferred compiler is Delphi 2010. If the DELPHI2010 evironment variable
# is set, it will be used and expected to reference the Delphi 2010 install
# directory.
# If DELPHI2010 is not set then the DELPHIROOT environment variable is examined.
# This can be set to any Delphi compiler. If neither DELPHI2010 nor DELPHIROOT
# is set then an error is reported
!ifdef DELPHI2010
DELPHIROOT = $(DELPHI2010)
!endif

# Requires the following macros:
#   BIN - set to the directory that is to receive .res and .dcu output.
#   DELPHIROOT - install directory of Delphi compiler to be used

# Check for required macros
!ifndef DELPHIROOT
!error DELPHIROOT environment variable required.
!endif
!ifndef BIN
!error BIN macro must be defined in calling script.
!endif

# Define common macros that access required build tools

MAKE = "$(MAKEDIR)\Make.exe" -$(MAKEFLAGS)
DCC32 = "$(DELPHIROOT)\Bin\DCC32.exe"
BRCC32 = "$(DELPHIROOT)\Bin\BRCC32.exe"
!ifdef VIEDROOT
VIED = "$(VIEDROOT)\VIEd.exe" -makerc
!else
VIED = VIEd.exe -makerc
!endif
!ifdef INNOSETUP
ISCC = "$(INNOSETUP)\ISCC.exe"
!else
ISCC = ISCC.exe
!endif
!ifdef ZIPROOT
ZIP = "$(ZIPROOT)\Zip.exe"
!else
ZIP = Zip.exe
!endif


# Implicit rules
# Delphi projects are assumed to contain required output and search path
# locations in the project options .cfg file.
.dpr.exe:
  @echo +++ Compiling Delphi Project $< +++
  @$(DCC32) $< -B

# Resource files are compiled to the directory specified by BIN macro, which
# must have been set by the caller.
.rc.res:
  @echo +++ Compiling Resource file $< +++
  @$(BRCC32) $< -fo$(BIN)\$(@F)

# Version info files are compiled by VIEd. A temporary .rc file is left behind
.vi.rc:
  @echo +++ Compiling Version Info file $< +++
  @$(VIED) .\$<
