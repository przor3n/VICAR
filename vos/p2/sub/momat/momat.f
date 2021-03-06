      SUBROUTINE MOMAT(OAL,OAS,SSL,SSS,SCALE,FL,SCLO,SCLA,ANGN,RANGE,
     &A,RS,SEDRNA)
c
c       Oct 92   ...WPL...   Ported for UNIX Conversion 
C     8 OCT 80   ...JJL...   INITIAL RELEASE
c
      IMPLICIT REAL*8 (A-H,O-Z)
      REAL*8 A(3,3),RS(3)
      INTEGER*4 SEDRNA
c
C THIS ROUTINE COMPUTES THE PLANET TO CAMERA ROTATION MATRIX (A) AND THE
C VECTOR FROM PLANET CENTER TO SPACECRAFT (RS), EXPRESSED IN THE PLANET
C SYSTEM. A VECTOR V IN THE PLANET SYSTEM IS THEN RELATED TO THE SAME
C VECTOR VP IN THE CAMERA SYSTEM BY
c
C          VP = A*V + RS
c
C Required NAVIGATION Information ......
C   OAL,OAS = LINE,SAMPLE LOCATION OF OPTIC AXIS
C   SSL,SSS = LINE,SAMPLE LOCATION OF PLANET CENTER
C   SCLA = PLANETOCENTRIC LATITUDE OF S/C (DEG)
C   SCLO = WEST LONGITUDE OF S/C
C   ANGN = NORTH ANGLE AT OPTIC AXIS INTERCEPT POINT
C   RANGE = RANGE FROM S/C TO PLANET CENTER
C   SCALE = SCALE IN PIXELS/MM
C   FL = FOCAL LENGTH IN MM
C   SEDRNA  is an INTEGER WHICH IS 0 IF THE NORTH ANGLE IS DEFINED AS
C   DESIRED BY MAP2  OR IS > 0 IF THE NORTH ANGLE IS DEFINED THE
C   SAME AS THE SEDR.
C
      If (SEDRNA.NE.0) GO TO 10
c
C  USE THIS ROUTINE IF THE NORTH ANGLE IS MEASURED AS IF IT WERE
C  THE ANGLE FROM UP OF THE PLANET SPIN AXIS PROJECTED ON THE
C  IMAGE.
c
      Call MomatV( OAL,OAS,SSL,SSS,SCALE,FL,SCLO,SCLA,ANGN,RANGE,
     &A,RS)
      Return
c
C  USE THIS ROUTINE IF THE NORTH ANGLE IS MEASURED AS IF IT WERE
C  THE ANGLE FROM UP OF THE PLANET SPIN AXIS PROJECTED ON THE
C  IMAGE AFTER THE CAMERAS HAVE BEEN SLEWED TO PLACE THE OPTICAL
C  AXIS COINCIDENT WITH THE PLANET CENTER.
c
10    Call MomatI( OAL,OAS,SSL,SSS,SCALE,FL,SCLO,SCLA,ANGN,RANGE,
     &A,RS)
c
      Return
      End
