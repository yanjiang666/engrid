#!/usr/bin/env bash
#
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +                                                                      +
# + This file is part of enGrid.                                         +
# +                                                                      +
# + Copyright 2008,2009 Oliver Gloth                                     +
# +                                                                      +
# + enGrid is free software: you can redistribute it and/or modify       +
# + it under the terms of the GNU General Public License as published by +
# + the Free Software Foundation, either version 3 of the License, or    +
# + (at your option) any later version.                                  +
# +                                                                      +
# + enGrid is distributed in the hope that it will be useful,            +
# + but WITHOUT ANY WARRANTY; without even the implied warranty of       +
# + MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        +
# + GNU General Public License for more details.                         +
# +                                                                      +
# + You should have received a copy of the GNU General Public License    +
# + along with enGrid. If not, see <http:#www.gnu.org/licenses/>.        +
# +                                                                      +
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# DESCRIPTION:
# This script allows:
# -downloading, building and installing the dependencies for engrid
# -downloading, building and installing engrid
# -updating netgen
# -updating engrid
# -rebuilding engrid
# -generating an environment setup script that can then be sourced by ~/.bashrc
# -generating a startup script that sets up the environment and then starts engrid
#
# USAGE:
# First of all change the configuration file engrid_installer_updater.cfg according to your needs.
# Then you can run this script and choose the actions you wish to execute. Multiple actions can be run at once. They will be run in the order of the checklist.
# Note 1: Altough it should be enough to run create_bash_engrid once, it's recommended to run it every time to make sure the other actions use the correct environment.
# Note 2: The script currently only builds the release version of engrid, which does not support CGNS, so installing CGNS is actually not necessary.
#
# EXAMPLES
# Engrid installation:
# [X] create_bash_engrid
# [X] install_QT
# [X] install_VTK
# [X] install_CGNS
# [X] build_engrid
# [ ] update_netgen
# [ ] update_engrid
# [ ] rebuild_engrid
# [X] create_start_engrid
#
# Engrid update:
# [X] create_bash_engrid
# [ ] install_QT
# [ ] install_VTK
# [ ] install_CGNS
# [ ] build_engrid
# [X] update_netgen
# [X] update_engrid
# [ ] rebuild_engrid
# [ ] create_start_engrid
#
# Engrid rebuild:
# [X] create_bash_engrid
# [ ] install_QT
# [ ] install_VTK
# [ ] install_CGNS
# [ ] build_engrid
# [ ] update_netgen
# [ ] update_engrid
# [X] rebuild_engrid
# [ ] create_start_engrid

#for debugging
set -eux

source "${0%/*}/engrid_installer_updater.cfg"

create_bash_engrid()
{
  echo "Create bash_engrid"
  mkdir -p $BINPREFIX

  echo "#!/usr/bin/env bash" > $BINPREFIX/$ENV_SETUP
  echo "export VTKINCDIR=$VTKPREFIX/include/vtk-$VTKVERSION" >> $BINPREFIX/$ENV_SETUP
  echo "export VTKLIBDIR=$VTKPREFIX/lib/vtk-$VTKVERSION" >> $BINPREFIX/$ENV_SETUP
  echo "export LD_LIBRARY_PATH=$VTKLIBDIR:\$LD_LIBRARY_PATH" >> $BINPREFIX/$ENV_SETUP
  
  echo "export CGNSINCDIR=/opt/shared/cgns/include" >> $BINPREFIX/$ENV_SETUP
  echo "export CGNSLIBDIR=/opt/shared/cgns/lib" >> $BINPREFIX/$ENV_SETUP
  echo "export LD_LIBRARY_PATH=$CGNSLIBDIR:\$LD_LIBRARY_PATH" >> $BINPREFIX/$ENV_SETUP
  
  echo "export PATH=$QTPREFIX/bin:\$PATH" >> $BINPREFIX/$ENV_SETUP
  echo "export QTDIR=$QTPREFIX" >> $BINPREFIX/$ENV_SETUP
  echo "export LD_LIBRARY_PATH=$QTPREFIX/lib:\$LD_LIBRARY_PATH" >> $BINPREFIX/$ENV_SETUP

  chmod 755 $BINPREFIX/$ENV_SETUP
}

create_start_engrid()
{
  echo "Create start_engrid"
  mkdir -p $BINPREFIX

  echo "#!/usr/bin/env bash" > $BINPREFIX/$START_ENGRID
  echo "export VTKINCDIR=$VTKPREFIX/include/vtk-$VTKVERSION" >> $BINPREFIX/$START_ENGRID
  echo "export VTKLIBDIR=$VTKPREFIX/lib/vtk-$VTKVERSION" >> $BINPREFIX/$START_ENGRID
  echo "export LD_LIBRARY_PATH=$VTKLIBDIR:\$LD_LIBRARY_PATH" >> $BINPREFIX/$START_ENGRID
  
  echo "export CGNSINCDIR=/opt/shared/cgns/include" >> $BINPREFIX/$START_ENGRID
  echo "export CGNSLIBDIR=/opt/shared/cgns/lib" >> $BINPREFIX/$START_ENGRID
  echo "export LD_LIBRARY_PATH=$CGNSLIBDIR:\$LD_LIBRARY_PATH" >> $BINPREFIX/$START_ENGRID
  
  echo "export PATH=$QTPREFIX/bin:\$PATH" >> $BINPREFIX/$START_ENGRID
  echo "export QTDIR=$QTPREFIX" >> $BINPREFIX/$START_ENGRID
  echo "export LD_LIBRARY_PATH=$QTPREFIX/lib:\$LD_LIBRARY_PATH" >> $BINPREFIX/$START_ENGRID

  echo "$SRCPREFIX/engrid/src/engrid" >> $BINPREFIX/$START_ENGRID

  chmod 755 $BINPREFIX/$START_ENGRID
}

install_QT()
{
  echo "Install QT"
  if [ $DOWNLOAD_QT = 1 ]; then wget $URL_QT; fi
  tar -xzvf ./$ARCHIVE_QT
  cd $(basename $ARCHIVE_QT .tar.gz)
  mkdir -p $QTPREFIX
  echo yes | ./configure --prefix=$QTPREFIX -opensource
  make && make install
  cd -
}

install_VTK()
{
  echo "Install VTK"
  if [ $DOWNLOAD_VTK = 1 ]; then wget $URL_VTK; fi
  tar -xzvf ./$ARCHIVE_VTK
  cd ./VTK
  mkdir -p $VTKPREFIX
  cmake -DCMAKE_INSTALL_PREFIX:PATH=$VTKPREFIX -DBUILD_SHARED_LIBS:BOOL=ON -DVTK_USE_GUISUPPORT:BOOL=ON -DVTK_USE_QVTK:BOOL=ON -DDESIRED_QT_VERSION:STRING=4  .
  chmod 644 Utilities/vtktiff/tif_fax3sm.c
  make && make install
  cd -
}

install_CGNS()
{
  echo "Install CGNS"
  if [ $DOWNLOAD_CGNS = 1 ]; then wget $URL_CGNS; fi
  tar -xzvf ./$ARCHIVE_CGNS
  cd ./cgnslib_2.5/
  mkdir -p $CGNSPREFIX
  mkdir -p $CGNSPREFIX/include
  mkdir -p $CGNSPREFIX/lib
  ./configure --prefix=$CGNSPREFIX && make && make install
  cd -
}

build_engrid()
{
  ORIG_WD=$(pwd)
  mkdir -p $SRCPREFIX
  cd $SRCPREFIX
  git clone $URL_ENGRID
  cd engrid/src
  if [ $BRANCH != "master" ]; then git checkout -b $BRANCH origin/$BRANCH; fi;
  echo "Build netgen"
  ./scripts/build-nglib.sh
  echo "Build enGrid"
  qmake && make release
  cd $ORIG_WD
}

update_netgen()
{
  cd $SRCPREFIX/engrid/src
  echo "Update netgen"
  ./scripts/build-nglib.sh
  cd -
}

update_engrid()
{
  cd $SRCPREFIX/engrid/src
  echo "Update enGrid"
  git pull
  qmake && make release
  cd -
}

rebuild_engrid()
{
  cd $SRCPREFIX/engrid/src
  qmake && make distclean && qmake && make release
  cd -
}

ans=$(zenity  --height=350 --list  --text "Which actions should be executed?" --checklist  --column "Run" --column "Actions" \
FALSE "create_bash_engrid" \
FALSE "install_QT" \
FALSE "install_VTK" \
FALSE "install_CGNS" \
FALSE "build_engrid" \
FALSE "update_netgen" \
FALSE "update_engrid" \
FALSE "rebuild_engrid" \
FALSE "create_start_engrid" \
--separator=":");
echo $ans

if ( echo $ans | grep "create_bash_engrid" ) then create_bash_engrid; fi
source $BINPREFIX/$ENV_SETUP
if ( echo $ans | grep "install_QT" ) then install_QT; fi;
if ( echo $ans | grep "install_VTK" ) then install_VTK; fi;
if ( echo $ans | grep "install_CGNS" ) then install_CGNS; fi;
if ( echo $ans | grep "build_engrid" ) then build_engrid; fi;
if ( echo $ans | grep "update_netgen" ) then update_netgen; fi;
if ( echo $ans | grep "update_engrid" ) then update_engrid; fi;
if ( echo $ans | grep "rebuild_engrid" ) then rebuild_engrid; fi;
if ( echo $ans | grep "create_start_engrid" ) then create_start_engrid; fi;

echo "SUCCESS"
exit 0