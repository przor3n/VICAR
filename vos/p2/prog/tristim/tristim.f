C  02 MAY 1994 ... CRI ... MSTP S/W CONVERSION (VICAR PORTING)
c  11 Jan 2013 -lwk- fixed long CHARACTER continuation line for new compiler flag on Solaris

      INCLUDE 'VICMAIN_FOR'
      SUBROUTINE MAIN44
      REAL*4 CMFX(40), CMFY(40), CMFZ(40)
      REAL*4 AX(40), AY(40), AZ(40)
      REAL*4 BX(40), BY(40), BZ(40)
      REAL*4 CX(40), CY(40), CZ(40)
      REAL*4 XENONX(40), XENONY(40), XENONZ(40)
      REAL*4 D55X(40), D55Y(40), D55Z(40)
      REAL*4 D65X(40), D65Y(40), D65Z(40)
      REAL*4 D75X(40), D75Y(40), D75Z(40)
      REAL*4 TX(40),TY(40),TZ(40)
      REAL*4 RAD(40,10),XRAD(40),LAMBDA,CONT(40),BACK(40)
      INTEGER ISET,NSPECT
      CHARACTER*78 MSG1
      CHARACTER*80 MSG2,MSG3,MSG4,MSG5
      LOGICAL XVPTST

      DATA CMFX/.0014,.0042,.0143,.0435,.1344,.2839,.3483,.3362,
     1.2908,.1954,.0956,.032,.0049,.0093,.0633,.1655,.2904,.4334,
     2.5945,.7621,.9163,1.0263,1.0622,1.0026,.8544,.6424,.4479,.2835,
     3.1649,.0874,.0468,.0227,.0114,.0058,.0029,.0014,.0007,.0003,.0002,
     4.0001/
      DATA CMFY/0.,.0001,.0004,.0012,.004,.0116,.023,.038,
     1.06,.091,.139,.208,.323,.503,.71,.862,.954,.995,.995,.952,
     3.87,.757,.631,.503,.381,.265,.175,.107,.061,.032,.017,.0082,
     5.0041,.0021,.001,.0005,.0002,.0001,.0001,0./
      DATA CMFZ/.0065,.0201,.0679,.2074,.6456,1.3856,1.7471,
     11.7721,1.6692,1.2876,.813,.4652,.272,.1582,.0782,.0422,.0203,
     2.0087,.0039,.0021,.0017,.0011,.0008,.0003,.0002,15*0./
      DATA AX/.001,.005,.019,.071,.262,.649,.926,1.031,1.019,
     1.776,.428,.16,.027,.057,.425,1.214,2.313,3.732,5.510,7.571,
     29.719,11.579,12.704,12.669,11.373,8.98,6.558,4.336,2.628,1.448,
     3.804,.404,.209,.11,.057,.028,.014,.006,.004,.002/
      DATA AY/.000,.0,.001,.002,.008,.027,.061,.117,.21,.362,
     1.622,1.039,1.792,3.080,4.771,6.322,7.6,8.568,9.222,9.457,9.228,
     28.54,7.547,6.356,5.071,3.704,2.562,1.637,.972,.53,.292,.146,.075,
     3.04,.019,.01,.006,.002,.002,.0/
      DATA AZ/.006,.023,.093,.34,1.256,3.167,4.647,5.435,5.851,
     15.116,3.636,2.324,1.509,.969,.525,.309,.162,.075,.036,.021,
     2.018,.012,.01,.004,.003,15*0./
      DATA BX/.003,.013,.056,.217,.812,1.983,2.689,2.744,2.454,
     11.718,.87,.295,.044,.081,.541,1.458,2.689,4.183,5.84,
     27.472,8.843,9.728,9.948,9.436,8.14,6.2,4.374,2.815,1.655,.876,
     3.465,.22,.108,.053,.026,.012,.006,.002,.002,.001/
      DATA BY/0.,0.,.002,.006,.024,.081,.178,.31,.506,.8,1.265,
     21.918,2.908,4.36,6.072,7.594,8.834,9.603,9.774,9.334,8.396,
     37.176,5.909,4.734,3.63,2.558,1.709,1.062,.612,.321,.169,.08,
     4.039,.019,.009,.004,.002,.001,.001,0./
      DATA BZ/.014,.06,.268,1.033,3.899,9.678,13.489,14.462,
     214.085,11.319,7.396,4.29,2.449,1.371,.669,.372,.188,.084,.038,
     3.021,.016,.01,.007,.003,.002,15*0./
      DATA CX/.004,.019,.085,.329,1.238,2.997,3.975,3.915,3.362,
     12.272,1.112,.363,.052,.089,.576,1.523,2.785,4.282,5.88,
     37.322,8.417,8.984,8.949,8.325,7.07,5.309,3.693,2.349,1.361,
     4.708,.369,.171,.082,.039,.019,.008,.004,.002,.001,.001/
      DATA CY/0.,0.,.002,.009,.037,.122,.262,.443,.694,1.058,
     11.618,2.358,3.401,4.833,6.462,7.934,9.149,9.832,9.841,
     2 9.147,7.992,6.627,5.316,4.176,3.153,2.19,1.443,.886,.504,.259,
     3.134,.062,.029,.014,.006,.003,.002,.001,.001,.0/
      DATA CZ/.02,.089,.404,1.57,5.949,14.628,19.938,20.638,19.299
     1,14.972,9.461,5.274,2.864,1.52,.712,.388,.195,.086,.039,.02,.016,
     2.01,.007,.002,.002,15*0./
      DATA XENONX/.004,.014,.057,.193,.671,1.506,2.092,2.363,
     12.272,1.895,.803,.270,.040,.078,.553,1.484,2.651,4.045,5.657,
     27.333,9.058,10.257,10.332,9.852,8.768,6.416,4.316,2.848,1.582,
     3.874,.471,.246,.107,.060,.028,.015,.007,.003,.002,.001/
      DATA XENONY/0.,0.,.001,.005,.020,.062,.138,.267,.469,.883,
     11.168,1.756,2.634,4.233,6.203,7.730,8.709,9.287,9.468,9.160,
     28.601,7.565,6.138,4.943,3.910,2.646,1.686,1.075,.586,.320,.171,
     3.089,.039,.022,.009,.005,.002,.001,.001,0./
      DATA XENONZ/.017,.066,.270,.918,3.221,7.349,10.497,12.457,
     113.045,12.489,6.834,3.928,2.219,1.332,.684,.378,.185,.081,.037,
     2.020,.017,.011,.008,.003,.002,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,
     30.,0.,0.,0.,0./
      DATA D55X/.004,.015,.083,.284,.915,1.834,2.836,3.135,2.781,
     11.857,.935,.299,.047,.089,.602,1.641,2.821,4.248,5.656,7.048,
     28.517,8.925,9.540,9.071,7.658,5.525,3.933,2.398,1.417,.781,.400,
     3.172,.089,.047,.019,.011,.006,.002,.001,.001/
      DATA D55Y/0.0,0.,.002,.008,.027,.075,.187,.354,.574,.865,
     21.358,1.942,3.095,4.819,6.755,8.546,9.267,9.750,9.467,8.804,
     38.087,6.583,5.667,4.551,3.415,2.279,1.537,.9050,.524,.286,
     4.146,.062,.032,.017,.007,.004,.002,.001,0.,0./
      DATA D55Z/.020,.073,.394,1.354,4.398,8.951,14.228,16.523,
     215.960,12.239,7.943,4.342,2.606,1.516,.744,.418,.197,.086,.037,
     3.019,.015,.010,.007,.003,.002,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,
     40.,0.,0.,0.,0./
      DATA D65X/.006,.022,.112,.377,1.188,2.329,3.456,3.722,
     13.242,2.123,1.049,.33,.051,.095,.627,1.686,2.869,4.267,5.625,
     26.947,8.305,8.613,9.047,8.5,7.091,5.063,3.547,2.147,1.252,
     3.68,.346,.15,.077,.041,.017,.01,.005,.002,.001,.001/
      DATA D65Y/0.,.001,.003,.01,.035,.095,.228,.421,.669,
     1.989,1.525,2.142,3.342,5.131,7.04,8.784,9.425,9.796,9.415,
     28.678,7.886,6.353,5.374,4.265,3.162,2.089,1.386,.81,.463,.249,
     3.126,.054,.028,.015,.006,.003,.002,.001,.0,0./
      DATA D65Z/.031,.104,.531,1.795,5.708,11.365,17.336,19.621,
     118.608,13.995,8.917,4.79,2.815,1.614,.776,.43,.201,.086,.037,
     2.019,.015,.009,.007,.003,.002,15*0./
      DATA D75X/.009,.028,.137,.457,1.424,2.749,3.965,4.2,3.617
     1,2.336,1.139,.354,.054,.099,.646,1.716,2.9,4.271,5.584,6.843,
     28.108,8.387,8.7,8.108,6.71,4.749,3.298,1.992,1.151,.619,.315,
     3.136,.069,.037,.015,.009,.004,.002,.001,0./
      DATA D75Y/0.,.001,.004,.013,.042,.112,.262,.475,.746,
     11.088,1.656,2.302,3.538,5.372,7.249,8.939,9.526,9.804,9.346,
     28.549,7.698,6.186,5.168,4.068,2.992,1.959,1.289,.752,.426,
     3.227,.114,.049,.025,.013,.006,.003,.002,.001,0.,0./
      DATA D75Z/.04,.132,.649,2.18,6.84,13.419,19.889,22.139,
     120.759,15.397,9.683,5.147,2.979,1.69,.799,.437,.203,.086,.037,
     2.019,.015,.009,.007,.003,.001,15*0./
      DATA TX/40*0./,TY/40*0./,TZ/40*0./
      DATA ISET/0/
      DATA MSG1/'WAVELENGTH RADIANCE   XBAR      YBAR      ZBAR      R*X       R*Y       R*Z  '/

      CALL IFMESSAGE ('TRISTIM VERSION 11-JAN-2013')
      CALL XVEACTION ('SA',' ')
      IF (XVPTST( 'XENON')) THEN
	CALL XVMESSAGE('XENON ILLUMINANT',' ')
	DO I=1,40
	  TX(I)=XENONX(I)
	  TY(I)=XENONY(I)
	  TZ(I)=XENONZ(I)
	ENDDO
      ENDIF

      IF (XVPTST( 'D55')) THEN
	CALL XVMESSAGE('D55 ILLUMINANT',' ')
	DO I=1,40
	  TX(I)=D55X(I)
	  TY(I)=D55Y(I)
	  TZ(I)=D55Z(I)
	ENDDO
      ENDIF

      IF (XVPTST( 'D65')) THEN
	CALL XVMESSAGE('D65 ILLUMINANT',' ')
	DO I=1,40
	  TX(I)=D65X(I)
	  TY(I)=D65Y(I)
	  TZ(I)=D65Z(I)
	ENDDO
      ENDIF

      IF (XVPTST( 'D75')) THEN
	CALL XVMESSAGE('D75 ILLUMINANT',' ')
	DO I=1,40
	  TX(I)=D75X(I)
	  TY(I)=D75Y(I)
	  TZ(I)=D75Z(I)
	ENDDO
      ENDIF

      IF (XVPTST( 'A')) THEN
	CALLXVMESSAGE('ILLUMINANT A',' ')
	DO I=1,40
	  TX(I)=AX(I)
	  TY(I)=AY(I)
	  TZ(I)=AZ(I)
	ENDDO
      ENDIF

      IF (XVPTST( 'B')) THEN
	CALL XVMESSAGE('ILLUMINANT B',' ')
	DO I=1,40
	  TX(I)=BX(I)
	  TY(I)=BY(I)
	  TZ(I)=BZ(I)
	ENDDO
      ENDIF

      IF (XVPTST( 'C')) THEN
	CALL XVMESSAGE('ILLUMINANT C',' ')
	DO I=1,40
	  TX(I)=CX(I)
	  TY(I)=CY(I)
	  TZ(I)=CZ(I)
	ENDDO
      ENDIF

C     COLOR MATCHING FUNCTIONS
C     USER INPUTS SPECTRAL REFLECTANCE (TRANSMITTANCE) TIMES
C     SPECTRAL POWER
      IF (XVPTST( 'CMF')) THEN
	CALL XVMESSAGE('COLOR MATCHING FUNCTION',' ')
	DO I=1,40
	  TX(I)=CMFX(I)
	  TY(I)=CMFY(I)
	  TZ(I)=CMFZ(I)
	ENDDO
      ENDIF

C RADIANCES:

      NSPECT = 1	! DEFAULT

      CALL XVPARM( 'RADIANCE', RAD, ICNT, IDEF, 400) ! RADIANCES IN ALL SPECTRA
      IF (ICNT.EQ.0) THEN
	DO I = 1,40
	  RAD( I, 1) = 1.
	ENDDO
      ELSE
	NSPECT = ICNT/40
	IF (ICNT.NE.40*NSPECT) THEN
	  CALL XVMESSAGE
     &         ('** MUST SPECIFY 40 RADIANCES PER SPECTRUM **',' ')
	  CALL ABEND
	ENDIF
      ENDIF

      CALL XVPARM( 'ADD', CONST, ICNT, IDEF, 1)  ! ADD A CONSTANT TO RADIANCES
      IF (ICNT.GT.0) ISET = 1

      CALL XVPARM( 'MULT', CONSTM, ICNT, IDEF, 1) ! MULT RADIANCES BY CONSTANT
      IF (ICNT.GT.0) ISET = 1

C MULTIPLY RADIANCES TOGETHER
      DO J=1,40
	XRAD(J)=1.
	DO I=1,NSPECT
	  XRAD(J)=RAD(J,I)*XRAD(J)
	ENDDO
      ENDDO
C ADJUST RADIANCES VALUES
      DO I=1,40
        XRAD(I) = XRAD(I)*CONSTM + CONST
      ENDDO

C  OPTION TO ENTER "ABSOLUTE" INTENSITY VALUES NEEDS CONTINUUM &
C  BACKGROUND VALUES:

      CALL XVPARM( 'CONTIN', CONT, ICNT, IDEF, 40)
      IF (ICNT.GT.0) THEN
	CALL XVPARM( 'BACK', BACK, ICNT, IDEF, 40)
	IF (ICNT.LE.1) THEN
	  DO I=2,40
	    BACK(I) = BACK(1)
	  ENDDO
	ENDIF
	DO I=1,40
	  XRAD(I) = (XRAD(I)-BACK(I))/CONT(I)
	ENDDO
      ENDIF

C  PRINT OUT THE RADIANCES

      CALL XVMESSAGE(' ',' ')
      CALL XVMESSAGE(MSG1,' ')

      LAMBDA=380.
      RADSUM=0.
      XSUM=0.
      YSUM=0.
      ZSUM=0.
      DO 300 I=1,40
      X=TX(I)*XRAD(I)
      Y=TY(I)*XRAD(I)
      Z=TZ(I)*XRAD(I)
      XSUM=X+XSUM
      YSUM=Y+YSUM
      ZSUM=Z+ZSUM

      WRITE (MSG2,9900) NINT(LAMBDA),XRAD(I),TX(I),TY(I),TZ(I),X,Y,Z
9900  FORMAT ('   ',I6,F10.5,F10.4,F10.4,F10.4,F10.5,F10.5,F10.5)
      CALL XVMESSAGE(MSG2,' ')
      LAMBDA=LAMBDA+10.
      RADSUM=RADSUM+XRAD(I)
  300 CONTINUE
      WRITE (MSG3,9910) CONSTM,CONST
9910  FORMAT ('OUTPUT RADIANCE=INPUT*',F10.5,'  +     ',F5.2)
      IF(ISET.EQ.1) CALL XVMESSAGE(' ',' ')
      IF(ISET.EQ.1) CALL XVMESSAGE(MSG3,' ')

C  PRINT OUT TRISTIMULUS VALUES

      TOTAL = XSUM + YSUM + ZSUM
      XCHROM=XSUM/TOTAL
      YCHROM=YSUM/TOTAL
      ZCHROM=ZSUM/TOTAL
      WRITE (MSG4,9920) XSUM,YSUM,ZSUM
9920  FORMAT ('X TRISTIM = ',F10.6,' Y TRISTIM =',F10.6,'  Z TRISTIM ',
     +F10.6,'  ')
      CALL XVMESSAGE(' ',' ')
      CALL XVMESSAGE(MSG4,' ')
      WRITE (MSG5,9930) XCHROM,YCHROM,ZCHROM
9930  FORMAT ('X CHROM  =  ',F10.8,' Y CHROM   =',F10.8,'  Z CHROM   ',
     +F10.8,'  ')
      CALL XVMESSAGE(' ',' ')
      CALL XVMESSAGE(MSG5,' ')
      CALL XVMESSAGE(' ',' ')
      CALL XVMESSAGE('TRISTIM END',' ')
      RETURN
      END