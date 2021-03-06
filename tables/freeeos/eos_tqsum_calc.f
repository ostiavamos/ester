C*******************************************************************************
C       Start of the header for a fortran source file for a subroutine
C       of the Free_EOS stellar interior equation of state code
C       Copyright (C) 1996, 1998, 2000, 2001, 2004, 2005, 2006 Alan W. Irwin
C
C       $Id: eos_tqsum_calc.f 370 2006-11-29 23:57:39Z airwin $
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
      subroutine eos_tqsum_calc(
     &  partial_elements, n_partial_elements, ion_end,
     &  ifionized, ifreducedmass,
     &  ifsame_abundances, ifmtrace, iatomic_number,
     &  eps, tc2, bi, nelements_in, 
     &  ifelement, dvzero, dv, nion, nions_in, ceout, bi_refout,
     &  f)
C       the purpose of this routine is to calculate ionization fractions
C       and weighted sums over those quantities.  the weighted sums are
C       ultimately used in an iterative way to calculate chemical potentials
C       according to some free energy model.  The appropriate difference in 
C       chemical potentials are then combined to form the dv quantities, 
C       the change in the equilibrium constant of an ion relative to the
C       un-ionized reference state and the free electron
C       dv = (partial F/partial nref - partial F/partial nion -
C       ion*partial F/partial ne)/kT.
C       These dv values (held in an array) are required input to ionize.
C
C       The free energy model:
C       it is the responsibility of the calling programme to get this
C       calculated correctly and fill in the dv quantities for the
C       various ions in a consistent manner.  It should be noted that
C       at the startup of the iteration, the free-energy terms corresponding
C       to pressure ionization and the Coulomb effect are approximated as
C       functions of only ne, so the dv array elements are quite similar
C       to each other.  (The electron exchange term is always just a function
C       of ne.) Later as more complicated models are used for the Coulomb
C       effect and pressure ionization, the dv array elements can become
C       more varied.
C       input quantitites:
C       ifexcited > 0 means_use_excited states (must have Planck-Larkin or
C         ifpi = 3 or 4).
C          0 < ifexcited < 10 means_use_approximation to explicit summation
C         10 < ifexcited < 20 means_use_explicit summation
C         mod(ifexcited,10) = 1 means just apply to hydrogen (without
C           molecules) and helium.
C         mod(ifexcited,10) = 2 same as 1 + H2 and H2+.
C         mod(ifexcited,10) = 3 same as 2 + partially ionized metals.
C       ifsame_under = .true. means_use_same underflow zeroing for each
C         ion as in previous call.  This option is useful for removing
C         small discontinuities caused by variations in the underflow
C         zeroing which sometimes foil the last stages
C         of convergence.
C       ifsame_under = .false. means calculate underflow zeroing.
C       ifnr = 0
C         calculate derivatives of nuvar (delivered through common block),
C         hne, sum0, sum2, s, extrasum, h, sh, hd, he, g, hequil, and sumpl1 
C         wrt f, t and sumpl0 wrt f with no other variables fixed, i.e., use
C         input dvf and dvt and chain rule.
C       ifnr = 1
C         calculate derivatives of nuvar (delivered through common block),
C         hne, sum0, sum2, extrasum, h, hd, and he wrt dv with f, t fixed.
C         n.b. list of variables is subset of those listed for ifnr = 0
C         because we only need dv derivatives for variables used to calculate
C         (output) auxiliary variables.
C       ifnr = 2 (should not occur)
C       ifnr = 3 same as combination of ifnr = 0 and ifnr = 1.
C         Note this is quite different in detail from ifnr = 3 interpretation
C         for many other routines, but the general motivation is the same
C         for all ifnr = 3 results; calculate both f and t derivatives and
C         other derivatives.
C       inv_ion(nions_in+2) maps ion index to contiguous ion index used in NR 
C         iteration dot products.
C       partial_elements(n_partial_elements+2) index of elements treated as 
C         partially ionized consistent with ifelement.
C       ion_end(nelements_in) keeps track of largest ion index for
C       each element.
C       ifionized = 0 means all elements treated as partially ionized
C       ifionized = 1 means trace metals fully ionized.
C       ifionized = 2 means all elements treated as fully ionized.
C       if_pteh controls whether pteh approximation used for Coulomb sums (1)
C         or whether_use_detailed Coulomb sum (0).
C       if_mc controls whether special approximation used for metal part
C         of Coulomb sum for the partially ionized metals.
C       if_mc = 1,_use_approximation
C       if_mc = 0, don't_use_approximation
C       ifreducedmass = 1 (use reduced mass in equilibrium constant)
C       ifreducedmass = 0 (use electron mass in equilibrium constant)
C       ifsame_abundances = 1, if call made with same abundances as previous
C         it is the responsibility of the calling programme to set
C         this flag where appropriate.  ifsame_abundances = 0 means
C         slower execution of ionize, but is completely safe against
C         abundance changes.
C       ifmtrace just to keep track of changes in ifelement.
C       n.b. if ifionized is different from previous call or 
C         ifsame_abundances = 0, or ifmtrace different from previous
C         call, then local variables ionized_hne,
C         ionized_sum0, ionized_sum2, and ionized_extrasum(2) are
C         recalculated.
C       iatomic_number(nelements_in), the atomic number of each element.
C       n.b. the code logic now demands there are iatomic_number ionized
C         states + 1 neutral state for each element.  Thus, the
C         ionization potentials must include all ions, not just
C         first ions (as for trace metals in old code).
C       eps(nelements_in) is an array of neps = nelements = 20 values
C         of relative abundance by weight divided by the appropriate atomic
C         weight. We_use_the atomic weight scale where (un-ionized) C(12) has
C         a weight of 12.00000000....  All weights are for the un-ionized
C         element. The eps value for an element should be the sum of the
C         individual isotopic eps values for that element.  The eps array
C         refers to the elements in the following order:
C         H,He,C,N,O,Ne,Na,Mg,Al,Si,P,S,Cl,A,Ca,Ti,Cr,Mn,Fe,Ni
C       tc2 = c2/t
C       bi(nions_in+2) ionization potentials (cm**-1) in ion order:
C         h, he, he+, c, c+, etc.  H2 and H2+ are last two.
C       plop(nions_in+2), plopt, plopt2, planck-larkin occupation probability
C         and derivatives in ion order (starting with neutral in each case
C         and avoiding bare nuclei as in bi.
C       r_ion3(nions_in+2), *the cube of the*
C         effective radii (in ion order but going from neutral
C         to next to bare ion for each species) of MDH interaction between
C         all but bare nucleii species and ionized species.  last 2 are
C         H2 and H2+ (used externally)
C       r_neutral(nelements+2) effective radii for MDH neutral-neutral 
C         interactions.   Last two (used externally) are H2 and H2+ (the
C         only ionic species in the MHD model with a non-zero hard-sphere
C         radius).
C       ifelement(nelements_in) = 1 if element treated as partially ionized
C        (depending on abundance, and trace metal treatment), 0 if
C        element treated as fully ionized or has no abundance.
C       dvzero(nelements_in) is a zero point shift (zero for hydrogen) that
C         must be added to dv in all uses below.  Sometimes
C         (high density, high ionization) this quantity can be
C         larger than 1.d9 so if we avoid using it in differences
C         of dv quanties we can gain many significant digits.
C       dv(nions_in) change in equilibrium constant (explained above)
C       dvf(nions_in) = d dv/d ln f
C       dvt(nions_in) = d dv/d ln t
C       nion(nions_in), charge on ion in ion order (must be same order as bi)
C       e.g., for H+, He+, He++, etc.
C       output quantities:
C       hne, hnef, hnet, hne_dv is the accumulated nu(e) = n_e/(Navogadro*rho)
C         from the metals and helium
C         (and hydrogen if treated as fully ionized)
C         and its derivatives wrt ln f, and ln t, dv
C       s, sf, st is the accumulated entropy/R per unit mass and its 
C         derivatives with respect to lnf and ln t.
C       n.b. if not completely ionized, then the returned value of s excludes
C       the hydrogen component and sh (see below) returns the hydrogen
C       component (which is ignored from this routine and recalculated outside
C       when molecular formation is important).
C       if completely ionized s contains both the hydrogen and non
C       hydrogen components of the entropy.
C       n.b.  s returns a component of entropy/R per unit mass,
C       s = the sum over all non-electron species of
C       -nu_i*[-5/2 - 3/2 ln T + ln(alpha) - ln Na 
C         + ln (n_i/[A_i^{3/2} Q_i]) - dln Q_i/d ln T],
C       where nu_i = n_i/(Na rho), Na is the Avogadro number,
C       A_i is the atomic weight,
C       alpha =  (2 pi k/[Na h^2])^(-3/2) Na
C       (see documentation of alpha^2 in constants.h), and
C       Q_i is the internal ideal partition function
C       of the non-Rydberg states.  (Currently, we calculate this
C       partition function by the statistical weights of the ground states
C       of monatomic hydrogen and helium and the combined lower states (roughly
C       approximated) of each of the metals.  This is a superb approximation
C       for hydrogen, helium is subsequently corrected for detailed excitation
C       of the non-Rydberg states, and this crude approximation for the metals
C       is not currently corrected.  Thus, in all *current* monatomic
C       cases ln Q_i is a constant, and dln Q_i/d ln T is zero, but this
C       will change for the metals eventually.
C       From the equilibrium constant approach and the monatomic species
C       treated in this subroutine (molecules treated outside) we have
C       -nu_i ln (n_i/[A_i^{3/2} Q_i]) =
C       -nu_i * [ln (n_neutral/[A_neutral^{3/2} Q_neutral) +
C       (- chi_i/kT + dv_i)]
C       if we sum this term over all species
C       of an element without molecules (true for all species treated here
C       since molecular hydrogen treated specially outside when important)
C       we obtain
C       s_element = - eps * ln (eps*n_neutral/sum(n))
C       - eps ln (alpha/(A_neutral^{3/2} Q_neutral)) -
C       - sum over all species of the element of nu_i*(-chi/kT + dv(i))
C       where we have ignored the term
C       eps * (-5/2 - 3/2 ln T + ln rho)
C       (taking into account the first 4 terms above)
C       until a final correction of the s zero point
C       in free_eos_detailed.
C       u*avogadro, is the accumulated internal energy (cm^-1) per unit mass.
C       g, gf, gt is the h neutral fraction (n(h)/(n(h)+n(h+))) times eps(1)
C         and its derivatives with respect to ln f and ln t.
C         if no molecular formation of H2 and H2+, then
C         g =  n(H)/(rho*NA)
C       sh, shf, sht is the hydrogen contribution to the entropy and its
C         derivatives.  for the full ionization case, these terms are 
C         not calculated but instead are included in s and derivatives.
C         for the case where molecular formation is important, these
C         terms are not valid and are ignored.
C       hequil, hequilf, hequilt are the h equilibrium constant
C         ln [n(H+)/n(H)] and derivatives (only used for the case 
C         of h2 and h2+ formation).
C       h, hf, ht, h_dv is the h ionization fraction (n(h+)/(n(h)+n(h+)))
C         times eps(1) and its derivatives with respect to ln f, ln t,
C         and dv.
C         if no molecular formation of H2 and H2+, then
C         h =  n(H+)/(rho*NA)
C       hd, hdf, hdt, hd_dv = n(He+)/(rho*NA) and its 
C         derivatives with respect to ln f, ln t, and dv.
C       he, hef, het, he_dv = n(He++)/(rho*NA) and its 
C         derivatives with respect to ln f, ln t, and dv.
C         the following are returned only if ifpi = 3 or 4.
C       fh, fhf, fh_dv = hydrogen ion free_energy/(rho*t*NA) (= tc2*uh - sh)
C         and its derivatives with respect to ln f and dv.
C       f, ff, f_dv = ion free_energy/(rho*t*NA) (= tc2*u - s)
C         and its derivatives with respect to ln f and dv.
C       extrasum(maxnextrasum) weighted sums over non-H nu(i) = n(i)/(rho/H).
C         for iextrasum = 1,nextrasum-2, sum is only over neutral species and
C         weight is r_neutral^{iextrasum-1} for iextrasum = nextrasum-1, sum is
C         over all ionized species including bare nucleii, but excluding free
C         electrons, weight is Z^1.5. for iextrasum = nextrasum, sum is over
C         all species excluding bare nucleii and free electrons, the weight
C         is rion^3.
C       extrasumf(maxnextrasum) = partial of extrasum/partial ln f
C       extrasumt(maxnextrasum) = partial of extrasum/partial ln t
C       the following are returned only if ifpl = 1
C       sumpl0, sumpl1 and sumpl2 = weighted sums over
C         non-H nu(i) = n(i)/(rho/H).
C         for sumpl0 sum is over Planck-Larkin occupation probabilities.
C         for sumpl1 sum is over Planck-Larkin occupation probabilities +
C         d ln w/d ln T
C         for sumpl2, sum is over Planck-Larkin d ln w/d ln T
C       sumpl0f, sumpl0_dv = derivatives of sumpl0 wrt ln f and dv.
C       sumpl1f and sumpl1t = derivatives of sumpl1 wrt lnf and lnt.
      implicit none
      include 'nuvar.h'
      integer*4 nions
      parameter(nions = 295)
      integer*4 nelements
      parameter(nelements = 20)  !number of elements considered.
      integer*4 
     &  n_partial_elements, partial_elements(n_partial_elements+2),
     &  ifionized, ifreducedmass,
     &  nelements_in, ifelement(nelements_in),
     &  nions_in,
     &  ion_end(nelements_in)
      real*8 
     &  ionized_u, ionized_s, eps(nelements_in), tc2,
     &  dvzero(nelements_in),
     &  dv(nions_in), 
     &  fh, f
C       ionization potentials in cm-1 in ion order for the ions,
C       H+, 
C       He+, He++,
C       Li, Be, B missing from list
C       C+ through C6+,
C       N+ through N7+,
C       O+ through O8+,
C       F missing from list
C       Ne+ through Ne10+,
C       Na+ through Na11+,
C       Mg+ through Mg12+,
C       Al+ through Al13+,
C       Si+ through Si14+,
C       P+ through P15+,
C       S+ through S16+,
C       Cl+ through Cl17+,
C       A+ through A18+,
C       K missing from list
C       Ca+ through Ca20+,
C       Sc missing from list
C       Ti+ through Ti22+,
C       V missing from list
C       Cr+ through Cr24+,
C       Mn+ through Mn25+,
C       Fe+ through Fe26+,
C       Co missing from list
C       Ni+ through Ni28+,
      real*8 bi(nions_in),bi_ref(nions), bi_refout(nions_in),
     &  ce0(nions),ce(nions), ceout(nions_in)
      include 'statistical_weights.h'
      include 'constants.h'
      integer*4  nion(nions_in)  !ionization state in ion order.
C      atomic masses of most abundant isotope.  this is most consistent way
C      to treat isotopes in equilibrium constants (aside from having
C      separate abundance constraint equations for each isotope).  These
C      numbers *should not be confused* with the mean atomic weights
C      required for abundance and density calculations.  The element order
C      is H,He,C,N,O,Ne,Na,Mg,Al,Si,P,S,Cl,A,Ca,Ti,Cr,Mn,Fe,Ni. We_use_the
C      atomic weight scale where (un-ionized) C(12) has a weight of
C      12.00000000....  All weights are for the un-ionized element.
      real*8 atomic_mass(nelements)
      data atomic_mass/
     &  1.007825035d0, 4.00260324d0,
     &  12.0000000d0, 14.003074002d0, 15.99491463d0,
     &  19.9924356d0, 22.9897677d0, 23.9850423d0,
     &  26.9815386d0, 27.9769271d0, 30.9737620d0,
     &  31.972070698d0, 34.968852728d0, 39.9623837d0,
     &  39.9625906d0, 47.9479473d0, 51.9405098d0,
     &  54.9380471d0, 55.9349393d0, 57.9353462d0/
      integer*4 maxionstage
      parameter(maxionstage = 28)  !treat up to 28 ions of one element.
      real*8 fract(maxionstage),
     &  fractneutral,
     &  logalpha, constant_sh, constant_s
      integer*4 ifsame_abundances,
     &  ifmtrace, iatomic_number(nelements_in),
     &  ifmtrace_old, ifionized_old
      data ifmtrace_old, ifionized_old/2*-10000/
      integer*4 iffirst
      data iffirst/1/
      integer*4 ion, ielement, index_f, jndex_f, ion0, ion_index,
     &  index_max,
     &  index_element
      real*8 fractmax, sum_full, logsum0,
     &  sum,
     &  vz, epsilon
      integer*4 ifreducedmassold
C      need invalid value
      data ifreducedmassold/-1/
      save
C      sanity checking:
      if(nions_in.ne.nions.or.nions_in.ne.nions_stat)
     &  stop 'eos_tqsum_calc: invalid nions_in'
      if(nelements_in.ne.nelements.or.nelements_in.ne.nelements_stat)
     &  stop 'eos_tqsum_calc: invalid nelements_in'
      if(iffirst.eq.1) then
        logalpha = 0.5d0*log(alpha2)
C         refer energies to neutral species.
        do ion = 1,nions
          bi_ref(ion) = bi(ion)
          if(nion(ion).gt.1)
     &      bi_ref(ion) = bi_ref(ion) + bi_ref(ion-1)
        enddo
        ielement = 0
        do ion = 1,nions
          if(nion(ion).eq.1) ielement = ielement + 1
          ce0(ion) = log(dble(iqion(ion))/dble(iqneutral(ielement)))
        enddo
      endif
      if(ifreducedmass.ne.ifreducedmassold) then
        ifreducedmassold = ifreducedmass
        ielement = 0
        do ion = 1,nions
          ce(ion) = ce0(ion)
          if(nion(ion).eq.1) ielement = ielement + 1
          if(ifreducedmass.eq.1) ce(ion) = ce(ion) +
     &      1.5d0*log((atomic_mass(ielement) -
     &      dble(nion(ion))*electron_mass)/atomic_mass(ielement))
        enddo
      endif
      do ion = 1,nions
        ceout(ion) = ce(ion)
        bi_refout(ion) = bi_ref(ion)
      enddo
C      calculate constant component of entropy.  Keep hydrogen separate
C      for now, but add in with constant_s (see below) in full ionization
C      case.
      if(iffirst.eq.1.or.ifsame_abundances.ne.1) then
        constant_sh = eps(1)*(1.5d0*log(atomic_mass(1)) +
     &    log(dble(iqneutral(1))) - logalpha)
        constant_s = 0.d0
        do ielement = 2, nelements
          constant_s = constant_s +
     &      eps(ielement)*(1.5d0*log(atomic_mass(ielement)) +
     &      log(dble(iqneutral(ielement))) - logalpha)
        enddo
      endif
C      ionized_u is the contribution of fully ionized elements 
C      (depending on ifelement and ifionized) to u.
C      ionized_s is the contribution of fully ionized elements 
C      (depending on ifelement and ifionized) to s
      if(iffirst.eq.1.or.
     &    ifionized.ne.ifionized_old.or.
     &    ifsame_abundances.ne.1.or.
     &    ifmtrace.ne.ifmtrace_old) then
C        if first time,
C        or different ifionized flag, 
C        or if the abundances have changed,
C        or ifmtrace (ifelement) has changed,
C        then recalculate full-ionized sum approximations.
        iffirst = 0
        ifionized_old = ifionized
        ifmtrace_old = ifmtrace
        ionized_u = 0.d0
        ionized_s = 0.d0
        index_f = 0
        do ielement = 1, nelements
C          index_f should point to last index of ion for this
C          ielement.
          index_f = index_f + iatomic_number(ielement)
C          if element treated as fully ionized (or zero abundance)
C          ifelement(ielement) = 0.  For ifionized = 2, overides
C          ifelement and all elements are treated as fully ionized.
          if(eps(ielement).gt.0.d0.and.
     &        (ifionized.eq.2.or.ifelement(ielement).eq.0)) then
            ionized_u = ionized_u + eps(ielement)*bi_ref(index_f)
C            this expression is limit of expressions below
C            when all lower ions may be finite but negligible
C            relative to bare nucleus. n.b. much cancellation!
            ionized_s = ionized_s + eps(ielement)*
     &        (ce(index_f) - log(eps(ielement)))
          endif
        enddo
      endif
      if(ifionized.eq.2) then
C        everything (H, He, metals) fully ionized and ifnr irrelevant
!        u = ionized_u
!        s = ionized_s + constant_s + constant_sh
!        f = tc2*u - s
        f = tc2*ionized_u - (ionized_s + constant_s + constant_sh)
      else
        if(ifionized.eq.1) then
C          trace metals fully ionized, hydrogen effect split off
!          u = ionized_u
!          s = ionized_s + constant_s
!          f = tc2*u - s
          f = tc2*ionized_u - (ionized_s + constant_s)
        else
C          ifionized not 2 or 1 so everything treated as partially
C          ionized, hydrogen effect split off
!          u = 0.d0
!          s = constant_s
!          f = tc2*u - s
          f = -constant_s
        endif
        do index_element = 1, n_partial_elements
          ielement = partial_elements(index_element)
          epsilon = eps(ielement)
          if(ielement.gt.1) then
            ion0 = ion_end(ielement-1)
          else
            ion0 = 0
          endif
C          nuvar is n/(rho*avogadro) so its sum (weighted by 2 if
C          dealing with nu(H2) or nu(H2+) for a particular
C          element should be epsilon.  But nu(ref) is found by subtraction
C          so resulting fractneutral can be negative if the BFGS estimates
C          of the non-reference species are pinned at the maximum values.
C          guard against this bad fractneutral value below by pinning at
C          zero, but then also must renormalize all fract values to maintain
C          the correct effective sum.
          if(ielement.eq.1)
     &      stop 'eos_tqsum_calc.f: FIXME for the hydrogen case'
          fractneutral = nuvar(1,index_element)
C          guard against bad values imposed by BFGS technique.
          fractneutral = max(0.d0, fractneutral)
          fractmax = fractneutral
          index_max = 0
          do index_f = 1, iatomic_number(ielement)
            ion = ion0+index_f
            fract(index_f) = nuvar(index_f+1,index_element)
            if(fract(index_f).ge.fractmax) then
              index_max = index_f
              fractmax = fract(index_f)
            endif
          enddo
C          note that sum skips maximum component to solve significance
C          loss problems.
          if(index_max.ne.0) then
            sum = fractneutral
          else
            sum = 0.d0
          endif
C          FIXME in the case of H
          do jndex_f = 1,iatomic_number(ielement)
C            sum, sumf, sumt skips maximum component to solve
C            significance loss problems.
            if(jndex_f.ne.index_max) then
              sum = sum + fract(jndex_f)
            endif
          enddo
          if(index_max.ne.0) then
            sum_full = sum + fract(index_max)
          else
            sum_full = sum + fractneutral
          endif
C          n.b. -logsum0 = log(sum_full/fract_neut)
C          = log(fract_max/fract_neut) + log(1+sum/fract_max)
          if(fractneutral.gt.0.d0) then
            logsum0 = log(fractneutral/sum_full)
          else
            stop 'eos_tqsum_calc.f: fractneutral <= 0'
          endif
          do jndex_f = 1,iatomic_number(ielement)
C            vz = number density/(rho*Navogadro) of this particular form
C            of the element, and sum of vz over all forms of the element
C            is equal to epsilon.
C            epsilon/sum_full is renormalization factor which is normally
C            unity unless BFGS has abnormal values of nu for non-reference
C            species.
            vz = fract(jndex_f)*epsilon/sum_full
            if(ielement.eq.1.or.vz.gt.0.d0) then
              if(ielement.eq.1) then
C                save special quantities for hydrogen.
C                note, jndex_f is 1.
                fh = vz*dv(ion0+1) - constant_sh +
     &            epsilon*(log(epsilon) + logsum0)
              else
                ion_index = ion0+jndex_f
                f = f + vz*(dv(ion_index) + dvzero(ielement))
              endif
            endif
C         end of jndex_f loop
          enddo
          if(ielement.gt.1.and.epsilon.gt.0.d0) then
            f = f + epsilon*(log(epsilon) + logsum0)
          endif
C        end of do index_element = 1, n_partial_elements
        enddo
      endif
      end
