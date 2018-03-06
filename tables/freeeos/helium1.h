C*******************************************************************************
C       Start of the header for a fortran source file for a subroutine
C       of the Free_EOS stellar interior equation of state code
C       Copyright (C) 1996, 1998, 2000, 2001, 2004, 2005, 2006 Alan W. Irwin
C
C       $Id: helium1.h 820 2008-06-24 19:26:56Z airwin $
C
C       For the latest version of this source code, please contact
C       Alan W. Irwin
C       Department of Physics and Astronomy
C       University of Victoria,
C       Box 3055
C       Victoria, B.C., Canada
C       V8W 3P6
C       e-mail: irwin@beluga.phys.uvic.ca.
C
C    This program is free software; you can redistribute it and/or modify
C    it under the terms of the GNU General Public License as published by
C    the Free Software Foundation; either version 2 of the License, or
C    (at your option) any later version.
C
C    This program is distributed in the hope that it will be useful,
C    but WITHOUT ANY WARRANTY; without even the implied warranty of
C    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
C    GNU General Public License for more details.
C
C    You should have received a copy of the GNU General Public License
C    along with this program; if not, write to the Free Software
C    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
C
C       End of the header for a fortran source file for a subroutine
C       of the Free_EOS stellar interior equation of state code
C*******************************************************************************
      integer*4 nlevels_helium1
      parameter(nlevels_helium1 = 75)
      integer*4 iz_helium1
      parameter(iz_helium1 = 1)
      real*8 neff_helium1(nlevels_helium1)
      data neff_helium1/
     &  1.85070000000000001172d+00,
     &  1.68920000000000003482d+00,
     &  2.00939999999999985292d+00,
     &  1.93769999999999997797d+00,
     &  2.85659999999999980602d+00,
     &  2.69799999999999995381d+00,
     &  3.01109999999999988773d+00,
     &  2.93400000000000016342d+00,
     &  2.99820000000000019824d+00,
     &  2.99779999999999979821d+00,
     &  3.85829999999999984084d+00,
     &  3.70049999999999990052d+00,
     &  4.01159999999999961062d+00,
     &  3.93290000000000006253d+00,
     &  3.99809999999999998721d+00,
     &  3.99750000000000005329d+00,
     &  3.99969999999999981100d+00,
     &  3.99969999999999981100d+00,
     &  4.85909999999999975273d+00,
     &  4.70160000000000000142d+00,
     &  5.01180000000000003268d+00,
     &  4.93240000000000033964d+00,
     &  4.99800000000000022027d+00,
     &  4.99730000000000007532d+00,
     &  4.99960000000000004405d+00,
     &  4.99960000000000004405d+00,
     &  4.99990000000000023306d+00,
     &  5.85949999999999970868d+00,
     &  5.70209999999999972431d+00,
     &  6.01189999999999979963d+00,
     &  5.93219999999999991758d+00,
     &  5.99800000000000022027d+00,
     &  5.99730000000000007532d+00,
     &  5.99950000000000027711d+00,
     &  5.99950000000000027711d+00,
     &  5.99979999999999957794d+00,
     &  5.99990000000000023306d+00,
     &  6.85960000000000036380d+00,
     &  6.70249999999999968026d+00,
     &  7.01199999999999956657d+00,
     &  6.93200000000000038369d+00,
     &  6.99789999999999956515d+00,
     &  6.99709999999999965326d+00,
     &  6.99960000000000004405d+00,
     &  6.99960000000000004405d+00,
     &  6.99990000000000023306d+00,
     &  6.99990000000000023306d+00,
     &  6.99990000000000023306d+00,
     &  7.86029999999999962057d+00,
     &  7.70249999999999968026d+00,
     &  8.01200000000000045475d+00,
     &  7.93179999999999996163d+00,
     &  7.99789999999999956515d+00,
     &  7.99720000000000030838d+00,
     &  7.99960000000000004405d+00,
     &  7.99960000000000004405d+00,
     &  8.00000000000000000000d+00,
     &  8.86270000000000024443d+00,
     &  8.70250000000000056843d+00,
     &  9.01200000000000045475d+00,
     &  8.93169999999999930651d+00,
     &  8.99699999999999988631d+00,
     &  8.99770000000000003126d+00,
     &  8.99929999999999985505d+00,
     &  8.99929999999999985505d+00,
     &  9.00000000000000000000d+00,
     &  9.85999999999999943157d+00,
     &  9.70270000000000010232d+00,
     &  1.00120000000000004547d+01,
     &  9.93110000000000070486d+00,
     &  9.99779999999999979821d+00,
     &  9.99649999999999927525d+00,
     &  9.99920000000000008811d+00,
     &  9.99920000000000008811d+00,
     &  1.00000000000000000000d+01/
      real*8 ell_helium1(nlevels_helium1)
      data ell_helium1/
     &  0.00000000000000000000d+00,
     &  0.00000000000000000000d+00,
     &  1.00000000000000000000d+00,
     &  1.00000000000000000000d+00,
     &  0.00000000000000000000d+00,
     &  0.00000000000000000000d+00,
     &  1.00000000000000000000d+00,
     &  1.00000000000000000000d+00,
     &  2.00000000000000000000d+00,
     &  2.00000000000000000000d+00,
     &  0.00000000000000000000d+00,
     &  0.00000000000000000000d+00,
     &  1.00000000000000000000d+00,
     &  1.00000000000000000000d+00,
     &  2.00000000000000000000d+00,
     &  2.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  0.00000000000000000000d+00,
     &  0.00000000000000000000d+00,
     &  1.00000000000000000000d+00,
     &  1.00000000000000000000d+00,
     &  2.00000000000000000000d+00,
     &  2.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  4.00000000000000000000d+00,
     &  0.00000000000000000000d+00,
     &  0.00000000000000000000d+00,
     &  1.00000000000000000000d+00,
     &  1.00000000000000000000d+00,
     &  2.00000000000000000000d+00,
     &  2.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  4.00000000000000000000d+00,
     &  5.00000000000000000000d+00,
     &  0.00000000000000000000d+00,
     &  0.00000000000000000000d+00,
     &  1.00000000000000000000d+00,
     &  1.00000000000000000000d+00,
     &  2.00000000000000000000d+00,
     &  2.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  4.00000000000000000000d+00,
     &  5.00000000000000000000d+00,
     &  6.00000000000000000000d+00,
     &  0.00000000000000000000d+00,
     &  0.00000000000000000000d+00,
     &  1.00000000000000000000d+00,
     &  1.00000000000000000000d+00,
     &  2.00000000000000000000d+00,
     &  2.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  7.00000000000000000000d+00,
     &  0.00000000000000000000d+00,
     &  0.00000000000000000000d+00,
     &  1.00000000000000000000d+00,
     &  1.00000000000000000000d+00,
     &  2.00000000000000000000d+00,
     &  2.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  8.00000000000000000000d+00,
     &  0.00000000000000000000d+00,
     &  0.00000000000000000000d+00,
     &  1.00000000000000000000d+00,
     &  1.00000000000000000000d+00,
     &  2.00000000000000000000d+00,
     &  2.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  9.00000000000000000000d+00/
      real*8 weight_helium1(nlevels_helium1)
      data weight_helium1/
     &  1.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  9.00000000000000000000d+00,
     &  1.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  9.00000000000000000000d+00,
     &  5.00000000000000000000d+00,
     &  1.50000000000000000000d+01,
     &  1.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  9.00000000000000000000d+00,
     &  5.00000000000000000000d+00,
     &  1.50000000000000000000d+01,
     &  7.00000000000000000000d+00,
     &  2.10000000000000000000d+01,
     &  1.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  9.00000000000000000000d+00,
     &  5.00000000000000000000d+00,
     &  1.50000000000000000000d+01,
     &  7.00000000000000000000d+00,
     &  2.10000000000000000000d+01,
     &  3.60000000000000000000d+01,
     &  1.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  9.00000000000000000000d+00,
     &  5.00000000000000000000d+00,
     &  1.50000000000000000000d+01,
     &  7.00000000000000000000d+00,
     &  2.10000000000000000000d+01,
     &  3.60000000000000000000d+01,
     &  4.40000000000000000000d+01,
     &  1.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  9.00000000000000000000d+00,
     &  5.00000000000000000000d+00,
     &  1.50000000000000000000d+01,
     &  7.00000000000000000000d+00,
     &  2.10000000000000000000d+01,
     &  3.60000000000000000000d+01,
     &  4.40000000000000000000d+01,
     &  5.20000000000000000000d+01,
     &  1.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  9.00000000000000000000d+00,
     &  5.00000000000000000000d+00,
     &  1.50000000000000000000d+01,
     &  7.00000000000000000000d+00,
     &  2.10000000000000000000d+01,
     &  1.92000000000000000000d+02,
     &  1.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  9.00000000000000000000d+00,
     &  5.00000000000000000000d+00,
     &  1.50000000000000000000d+01,
     &  7.00000000000000000000d+00,
     &  2.10000000000000000000d+01,
     &  2.60000000000000000000d+02,
     &  1.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  3.00000000000000000000d+00,
     &  9.00000000000000000000d+00,
     &  5.00000000000000000000d+00,
     &  1.50000000000000000000d+01,
     &  7.00000000000000000000d+00,
     &  2.10000000000000000000d+01,
     &  3.36000000000000000000d+02/