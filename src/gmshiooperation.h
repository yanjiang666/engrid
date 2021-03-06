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
#ifndef gmshiooperation_H
#define gmshiooperation_H

class GmshIOOperation;

#include <iooperation.h>

class GmshIOOperation : public IOOperation
{
  
protected: // atributes
  
  enum format_t { ascii1, ascii2, bin2 };
  format_t format;
  
public: // methods
  
  /** The constructor sets the file format filter. */
  GmshIOOperation();
  
  /** Set the reader to v1.0 ASCII mode. */
  void setV1Ascii() { format = ascii1; };
  
  /** Set the reader to v2.0 ASCII mode. */
  void setV2Ascii() { format = ascii2; };
  
  
};

#endif


