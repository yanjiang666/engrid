//
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// +                                                                      +
// + This file is part of enGrid.                                         +
// +                                                                      +
// + Copyright 2008,2009 Oliver Gloth                                     +
// +                                                                      +
// + enGrid is free software: you can redistribute it and/or modify       +
// + it under the terms of the GNU General Public License as published by +
// + the Free Software Foundation, either version 3 of the License, or    +
// + (at your option) any later version.                                  +
// +                                                                      +
// + enGrid is distributed in the hope that it will be useful,            +
// + but WITHOUT ANY WARRANTY; without even the implied warranty of       +
// + MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        +
// + GNU General Public License for more details.                         +
// +                                                                      +
// + You should have received a copy of the GNU General Public License    +
// + along with enGrid. If not, see <http://www.gnu.org/licenses/>.       +
// +                                                                      +
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#include <QtCore>
#include <QtGui>
#include <QApplication>
#include <QFile>
#include <QTextStream>
#include <QDate>

#include "guimainwindow.h"

void makeDistribution()
{
};

int main( int argc, char ** argv )
{
  if (argc > 1) {
    if (QString(argv[1]) == QString("-appendlic")) {
      int first_year = 2008;
      QString first_year_text;
      first_year_text.setNum(first_year);
      int year = QDate::currentDate().year();
      QString year_text;
      year_text.setNum(year);
      if (year-first_year == 1) {
        year_text = first_year_text + "," + year_text;
      };
      if (year-first_year > 1) {
        year_text = first_year_text + "-" + year_text;
      };
      QString year_end_text = "                                     +\n";
      if (year == first_year) {
        year_end_text = "     " + year_end_text;
      };
      for (int i = 2; i < argc; ++i) {
        QString filename(argv[i]);
        QString buffer = "//\n";
        buffer += "// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
        buffer += "// +                                                                      +\n";
        buffer += "// + This file is part of enGrid.                                         +\n";
        buffer += "// +                                                                      +\n";
        buffer += "// + Copyright " + year_text + " Oliver Gloth" + year_end_text;
        buffer += "// +                                                                      +\n";
        buffer += "// + enGrid is free software: you can redistribute it and/or modify       +\n";
        buffer += "// + it under the terms of the GNU General Public License as published by +\n";
        buffer += "// + the Free Software Foundation, either version 3 of the License, or    +\n";
        buffer += "// + (at your option) any later version.                                  +\n";
        buffer += "// +                                                                      +\n";
        buffer += "// + enGrid is distributed in the hope that it will be useful,            +\n";
        buffer += "// + but WITHOUT ANY WARRANTY; without even the implied warranty of       +\n";
        buffer += "// + MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        +\n";
        buffer += "// + GNU General Public License for more details.                         +\n";
        buffer += "// +                                                                      +\n";
        buffer += "// + You should have received a copy of the GNU General Public License    +\n";
        buffer += "// + along with enGrid. If not, see <http://www.gnu.org/licenses/>.       +\n";
        buffer += "// +                                                                      +\n";
        buffer += "// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
        buffer += "//\n";
        {
          bool src_code = false;
          QFile file(filename);
          file.open(QIODevice::ReadOnly);
          QTextStream f(&file);
          while (!f.atEnd()) {
            QString line = f.readLine();
            if (!src_code) {
              if (line.size() >= 2) {
                if (line.left(2) != "//") {
                  src_code = true;
                };
              } else {
                src_code = true;
              };
            };
            if (src_code) {
              buffer += line + "\n";
            };
          };
        };
        {
          QFile file(filename);
          file.open(QIODevice::WriteOnly);
          QTextStream f(&file);
          f << buffer;
        };
      };
    };
    if (QString(argv[1]) == QString("-distbin")) {
      system ("ldd ./engrid > ldd.out");
      system ("mkdir enGrid");
      system ("cp engrid enGrid");
      system ("cp start_engrid enGrid");
      {
        QFile file("ldd.out");
        file.open(QIODevice::ReadOnly);
        QTextStream f(&file);
        while (!f.atEnd()) {
          QString line = f.readLine();
          QTextStream l(&line, QIODevice::ReadOnly);
          QString word;
          l >> word;
          if (word.left(1) != "/") {
            l >> word;
            l >> word;
          };
          QString cmd = "cp " + word + " enGrid";
          system(cmd.toAscii().data());
          cout << cmd.toAscii().data() << endl;
        };
      };
      system ("tar czf enGrid_bin.tar.gz enGrid/*");
      system ("rm -rf enGrid");
      system ("rm ldd.out");
    };
  } else {
    QApplication a( argc, argv );
    GuiMainWindow w;
    w.show();
    a.connect( &a, SIGNAL( lastWindowClosed() ), &a, SLOT( quit() ) );
    a.exec();
  };
};
