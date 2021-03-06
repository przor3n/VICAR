	INCLUDE 'VICMAIN_FOR'
C
C  89-05-24 ...REA...  new program
C  90-03-05 ...REA...  add areas and sensors options
C  90-04-25 ...REA...  add TITLE, replace SBDS with ST_CHAN, use AXISPTS2
C  90-05-15 ...REA...  allow the user to supress the 1-sigma envelope on plots
C  90-10-01 ...REA...  add pause to PRINT option, add laser plotting capability
C                      and read wavelength file
C  94-11-07 ...REA...  add NOPLOT option
C  97-08-21 ...REA...  fix bug in NOSIGMA option
C  01-06-29 ...REA...  add MASTERTIR to list of sensors
C
	SUBROUTINE MAIN44
C
	REAL WAVE(600),DN(1800)
	INTEGER IAREA(4,50)
	LOGICAL XVPTST,QPR,QCUM,QEXCL,QSIGMA,QWINDOW,QPLOT,QPSPLOT
	CHARACTER*50 TITLE
	CHARACTER*40 NAME(2)
        CHARACTER*20 SENSOR
	CHARACTER*3 ORG
C								open input file
	CALL XVUNIT(INUNIT,'INP',1,ISTAT,' ')
	CALL XVOPEN(INUNIT,ISTAT,'OPEN_ACT','SA','IO_ACT','SA',
     +		    'U_FORMAT','REAL',' ')
	CALL XVBANDS(ISB,NB,NBI)
	CALL XVGET(INUNIT,ISTAT,'ORG',ORG,' ')
C					                      process parameters
C
	QWINDOW = XVPTST('WINDOW')
	QPSPLOT = XVPTST('PSCRIPT')
	QPLOT = .NOT. XVPTST('NOPLOT')
	QPR = XVPTST('PRINT')
	QCUM = XVPTST('CUMUL')
	QEXCL = XVPTST('EXCLUDE')
	QSIGMA = .NOT. XVPTST('NOSIGMA')
	CALL XVP('TITLE',TITLE,ICNT)
        CALL XVP('SENSOR',SENSOR,ICNT)
	CALL XVPARM('ST_CHAN',JSTART,ICNT,IDEF,0)
	IF (JSTART .LE. 0) JSTART = ISB
	CALL XVPARM('LINE',LINE,ICNT,IDEF,0)
	CALL XVPARM('SAMPLE',ISAMP,ICNT,IDEF,0)
	CALL XVPARM('XAXIS',DN,ICNT,IDEF,0)
	X1 = MIN(DN(1),DN(2))
	X2 = MAX(DN(1),DN(2))
	CALL XVPARM('YAXIS',DN,ICNT,IDEF,0)
	Y1 = MIN(DN(1),DN(2))
	Y2 = MAX(DN(1),DN(2))
	CALL XVPARM('AREA',IAREA,ICNT,IDEF,0)
	NAREAS = ICNT/4
	IF (.NOT. QPLOT) QPR = .TRUE.
	IF (QPSPLOT) QPLOT = .FALSE.
	IF (4*NAREAS.NE.ICNT .AND. IDEF.EQ.0) THEN
	    CALL XVMESSAGE(' Invalid number of AREA parameters',' ')
	    CALL ABEND
	ENDIF
C				if both LINE and AREA defaulted, do entire image
	IF (NAREAS.EQ.0 .AND. LINE.EQ.0) THEN
	    CALL XVSIZE(IAREA(1,1),IAREA(2,1),IAREA(3,1),IAREA(4,1),
     +			NLIN,NSIN)
	    NAREAS = 1
	END IF
C
	CALL XVMESSAGE(TITLE,' ')
	CALL XVPCNT('INP',ICNT)
	IF (ICNT .EQ. 2) THEN
	    CALL XVP('INP',NAME,ICNT)
	    CALL READWAV(NAME(2),WAVE,NB)
	ELSE
	    CALL WAVLEN(SENSOR,JSTART,NB,WAVE)
	END IF
C								  process data
	IF (NAREAS.LT.1) THEN
	    CALL READ_POINT(ORG,INUNIT,LINE,ISAMP,ISB,NB,X1,X2,Y1,Y2,
     +			    WAVE,DN,QPR,QCUM,QWINDOW,QPLOT,QPSPLOT,
     +			    TITLE)
	ELSE
	    CALL READ_AREAS(ORG,INUNIT,IAREA,NAREAS,ISB,NB,X1,X2,Y1,Y2,
     +			    WAVE,DN,QPR,QCUM,QEXCL,QSIGMA,QWINDOW,QPLOT,
     +			    QPSPLOT,TITLE)
	END IF
C
	RETURN
	END
C*******************************************************************************
	SUBROUTINE READWAV(FILENAME,WAVE,NB)
C
C      This subroutine reads NB records from the file FILENAME, and puts
C      the first numeric value that it finds in the WAVE (wavelength) array.
C      If something other than a numeric or delimiter is encountered prior to 
C      finding a numeric field, the line is discarded.
C
	CHARACTER*40 FILENAME
	REAL WAVE(NB)
C
	OPEN (51,FILE=FILENAME,STATUS='OLD')
C
	DO I=1,NB
  100	    CONTINUE
	    READ (51,*,END=900,ERR=100) WAVE(I)
	END DO
	RETURN
  900	CONTINUE
	CALL XVMESSAGE(
     +	    ' Unexpected end-of-file while reading wavelengths',' ')
	DO I=1,NB
	    WAVE(I) = I
	END DO
	RETURN
	END
C*******************************************************************************
	SUBROUTINE READ_POINT(ORG,INUNIT,LINE,ISAMP,ISB,NB,X1,X2,Y1,Y2,
     +			      WAVE,DN,QPR,QCUM,QWINDOW,QPLOT,QPSPLOT,
     +			      TITLE)
C
C					Used when the specrum of a single point
C					is requested.
C
	REAL DN(NB),WAVE(NB)
	LOGICAL QPR,QCUM,QPSPLOT,QWINDOW,QPLOT
	CHARACTER*140 MSG2
	CHARACTER*80 PRT
	CHARACTER*50 TITLE
	CHARACTER*40 XLABEL,YLABEL
	CHARACTER*3 ORG
C
	IF (ORG .EQ. 'BIP') THEN
	    CALL XVREAD(INUNIT,DN,ISTAT,'LINE',LINE,'SAMP',ISAMP,
     +			'BAND',ISB,'NBANDS',NB,' ')
	ELSE
	    DO I=1,NB
		IB = ISB+I-1
		CALL XVREAD(INUNIT,DN(I),ISTAT,'LINE',LINE,'SAMP',ISAMP,
     +			    'BAND',IB,'NSAMPS',1,' ')
	    END DO
	END IF
C				      if requested, convert to cumulative values
	IF (QCUM) THEN
	    DO I=2,NB
		DN(I) = DN(I) + DN(I-1)
	    END DO
	END IF
C					     if requested, print out the values
	IF (QPR) THEN
	    DO I=1,NB
		WRITE (PRT,100) WAVE(I),DN(I)
  100		FORMAT(5X,G12.4,G13.5)
		CALL XVMESSAGE(PRT,' ')
	    END DO
	    IF (QPLOT) CALL XVINTRACT('IPARAM','Press RETURN')
	END IF
C							compute the axis scaling
	IF (X1.EQ.X2) THEN
	    CALL MINMAX(7,NB,WAVE,X1,X2,IMIN,IMAX)
	    IF (X1.EQ.X2) THEN
		CALL XVMESSAGE(' More than 1 channel is needed.',' ')
		CALL ABEND
	    ENDIF
	    CALL AXISPTS(X1,X2,XLO,XHI,NXTIC)
	ELSE
	    CALL AXISPTS2(X1,X2,NXTIC)
	    XLO = X1
	    XHI = X2
	END IF
C
	IF (Y1.EQ.Y2) THEN
	    CALL MINMAX(7,NB,DN,Y1,Y2,IMIN,IMAX)
	    IF (Y1.EQ.Y2) Y2 = Y1+1
	    CALL AXISPTS(Y1,Y2,YLO,YHI,NYTIC)
	ELSE
	    CALL AXISPTS2(Y1,Y2,NYTIC)
	    YLO = Y1
	    YHI = Y2
	END IF
C							    screen plot the data
	IF (QWINDOW) THEN
	    OPEN (11,FILE='scrvspec001',STATUS='NEW')
	    WRITE(11,288) XLO,XHI,YLO,YHI
	    WRITE(11,277) NXTIC,NYTIC
 277        FORMAT(2I10)
 288        FORMAT(4E16.7)
 299        FORMAT(2E16.7)
	    DO I=1,NB
		WRITE (11,299) WAVE(I),DN(I)
	    END DO
	    CLOSE(11)
	    ISTAT = SYSTEM('idl vicarspec.inp')
	    OPEN (11,FILE='scrvspec001',STATUS='OLD')
	    CLOSE(11,STATUS='DELETE')
	    CALL XVINTRACT('IPARAM','Print this plot (Yes, No) [No]? ')
	    CALL XVIPARM('PENPLOT',PRT,ICNT,IDEF,0)
	    QPSPLOT = PRT(1:1).EQ.'L' .OR. PRT(1:1).EQ.'l' .OR.
     +		      PRT(1:1).EQ.'Y' .OR. PRT(1:1).EQ.'y'
	END IF
C								submit to laser
C								printer
	IF (QPSPLOT) THEN
	    CALL XVGET(INUNIT,ISTAT,'NAME',PRT,' ')
	    WRITE (MSG2,700) PRT,LINE,ISAMP
  700	    FORMAT(A40,'####Line#=#', I5, '####Sample#=#', I5)
	    LEN = 74
	    CALL SQUEEZE(MSG2,PRT,LEN)
	    CALL XVPARM('XLABEL',XLABEL,ICNT,IDEF,0)
	    CALL ADD0(XLABEL,40,LEN)
	    CALL XVPARM('YLABEL',YLABEL,ICNT,IDEF,0)
	    CALL ADD0(YLABEL,40,LEN)
	    CALL ADD0(TITLE,50,LEN)
	    MSG2 = ' ' // CHAR(0)
	    CALL PSPLOT(WAVE,DN,NB,XLO,XHI,YLO,YHI,NXTIC,NYTIC,
     +			XLABEL,YLABEL,TITLE,PRT,MSG2,-1)
	END IF
	RETURN
	END
C*******************************************************************************
	SUBROUTINE READ_AREAS(ORG,INUNIT,IAREA,NAREAS,ISB,NB,X1,X2,Y1,Y2,
     +			      WAVE,DN,QPR,QCUM,QEXCL,QSIGMA,QWINDOW,
     +			      QPLOT,QPSPLOT,TITLE)
C
	REAL DN(NB,3),WAVE(NB),BUF(10000)
	INTEGER IAREA(4,NAREAS)
	INTEGER NZEROES(224)/224*0/
	REAL*8 SUM(224)/224*0.0/,SUMSQ(224)/224*0.0/,XMEAN,PIXELS
	LOGICAL QEXCL,QPR,QCUM,QPSPLOT,QSIGMA,QWINDOW,QPLOT
	CHARACTER*140 MSG2
	CHARACTER*80 PRT
	CHARACTER*50 TITLE
	CHARACTER*40 XLABEL,YLABEL
	CHARACTER*3 ORG
C								accumulate stats
	IF (ORG .EQ. 'BSQ') THEN
	    DO N=1,NAREAS
		ISL = IAREA(1,N)
		ISS = IAREA(2,N)
		NL = IAREA(3,N)
		NS = IAREA(4,N)
		IEL = ISL + NL - 1
		NPIXELS = NPIXELS + NL*NS
		DO IBAND = 1,NB
		    DO LINE = ISL,IEL
			CALL XVREAD(INUNIT,BUF,ISTAT,'LINE',LINE,
     +			  'SAMP',ISS,'BAND',ISB+IBAND-1,'NSAMPS',NS,' ')
			DO ISAMP=1,NS
			    SUM(IBAND) = SUM(IBAND) + BUF(ISAMP)
			    SUMSQ(IBAND) = SUMSQ(IBAND) + 
     +					   BUF(ISAMP)*BUF(ISAMP)
			    IF (BUF(ISAMP) .EQ. 0.0) 
     +				NZEROES(IBAND) = NZEROES(IBAND) + 1
			END DO
		    END DO
		END DO
	    END DO
	ELSE IF (ORG .EQ. 'BIL') THEN
	    DO N=1,NAREAS
		ISL = IAREA(1,N)
		ISS = IAREA(2,N)
		NL = IAREA(3,N)
		NS = IAREA(4,N)
		IEL = ISL + NL - 1
		NPIXELS = NPIXELS + NL*NS
		DO LINE = ISL,IEL
		    DO IBAND = 1,NB
			CALL XVREAD(INUNIT,BUF,ISTAT,'LINE',LINE,
     +			  'SAMP',ISS,'BAND',IBAND+ISB-1,'NSAMPS',NS,' ')
			DO ISAMP=1,NS
			    SUM(IBAND) = SUM(IBAND) + BUF(ISAMP)
			    SUMSQ(IBAND) = SUMSQ(IBAND) + 
     +					   BUF(ISAMP)*BUF(ISAMP)
			    IF (BUF(ISAMP) .EQ. 0.0) 
     +				NZEROES(IBAND) = NZEROES(IBAND) + 1
			END DO
		    END DO
		END DO
	    END DO
	ELSE
	    DO N=1,NAREAS
		ISL = IAREA(1,N)
		ISS = IAREA(2,N)
		NL = IAREA(3,N)
		NS = IAREA(4,N)
		IEL = ISL + NL - 1
		IES = ISS + NS - 1
		NPIXELS = NPIXELS + NL*NS
		DO LINE = ISL,IEL
		    DO ISAMP = ISS,IES
			CALL XVREAD(INUNIT,BUF,ISTAT,'LINE',LINE,
     +				'SAMP',ISAMP,'BAND',ISB,'NBANDS',NB,' ')
			DO IBAND=1,NB
			    SUM(IBAND) = SUM(IBAND) + BUF(IBAND)
			    SUMSQ(IBAND) = SUMSQ(IBAND) + 
     +					   BUF(ISAMP)*BUF(IBAND)
			    IF (BUF(IBAND) .EQ. 0.0) 
     +				NZEROES(IBAND) = NZEROES(IBAND) + 1
			END DO
		    END DO
		END DO
	    END DO
	END IF
C
	IF (QPR) CALL XVMESSAGE('Wavelength  mean-sigma     mean     mea
     +n+sigma    sigma         S/N       zeroes',' ')
C							compute mean & sigma
	PIXELS = NPIXELS
	DO I=1,NB
	    IF (QEXCL) THEN
		PIXELS = NPIXELS - NZEROES(I)
		IF (PIXELS .EQ. 0.0) PIXELS=1.0
	    END IF
	    XMEAN = SUM(I)/PIXELS
	    IF (PIXELS .EQ. 1.0) THEN
		SIGMA = 0.0
	    ELSE
		SIGMA = (SUMSQ(I)-PIXELS*XMEAN*XMEAN)/(PIXELS-1.0)
		IF (SIGMA .GT. 0.0) THEN
		    SIGMA = SQRT(SIGMA)
		ELSE
		    SIGMA = 0.0
		END IF
	    END IF
	    IF (QCUM .AND. I.GT.1) XMEAN=XMEAN+DN(I-1,2)
	    DN(I,1) = XMEAN - SIGMA
	    DN(I,2) = XMEAN
	    DN(I,3) = XMEAN + SIGMA
	    IF (QPR) THEN				! if requested, print
C							! out stats
		WRITE (PRT,100) WAVE(I),(DN(I,J),J=1,3),SIGMA,
     +				XMEAN/(SIGMA+1e-10),NZEROES(I)
  100		FORMAT(6G12.5,I6)
		CALL XVMESSAGE(PRT,' ')
	    END IF
	END DO
	IF (QPR .AND. QPLOT) CALL XVINTRACT('IPARAM','Press RETURN')
C							compute the axis scaling
	IF (X1.EQ.X2) THEN
	    CALL MINMAX(7,NB,WAVE,X1,X2,IMIN,IMAX)
	    IF (X1.EQ.X2) THEN
		CALL XVMESSAGE(' More than 1 channel is needed.',' ')
		CALL ABEND
	    ENDIF
	    CALL AXISPTS(X1,X2,XLO,XHI,NXTIC)
	ELSE
	    CALL AXISPTS2(X1,X2,NXTIC)
	    XLO = X1
	    XHI = X2
	END IF
C
	IF (Y1.EQ.Y2) THEN
	    IF (QSIGMA) THEN
		CALL MINMAX(7,3*NB,DN,Y1,Y2,IMIN,IMAX)
	    ELSE
		CALL MINMAX(7,NB,DN(1,2),Y1,Y2,IMIN,IMAX)
	    END IF
	    IF (Y1.EQ.Y2) Y2 = Y1+1
	    CALL AXISPTS(Y1,Y2,YLO,YHI,NYTIC)
	ELSE
	    CALL AXISPTS2(Y1,Y2,NYTIC)
	    YLO = Y1
	    YHI = Y2
	END IF
C							    screen plot the data
	IF (QWINDOW) THEN
	    OPEN (11,FILE='scrvspec001',STATUS='NEW')
	    WRITE(11,388) XLO,XHI,YLO,YHI
	    WRITE(11,377) NXTIC,NYTIC
 377        FORMAT(2I10)
 388        FORMAT(4E16.7)
 399        FORMAT(2E16.7)
	    IF (QSIGMA) THEN
		DO I=1,NB
		    WRITE (11,388) WAVE(I),DN(I,1),DN(I,2),DN(I,3)
		END DO
		CLOSE(11)
		ISTAT = SYSTEM('idl vicarspecb.inp')
	    ELSE
		DO I=1,NB
		    WRITE (11,399) WAVE(I),DN(I,2)
		END DO
		CLOSE(11)
		ISTAT = SYSTEM('idl vicarspec.inp')
	    END IF
	    OPEN (11,FILE='scrvspec001',STATUS='OLD')
	    CLOSE(11,STATUS='DELETE')
	    CALL XVINTRACT('IPARAM','Print this plot (Yes, No) [No]? ')
	    CALL XVIPARM('PENPLOT',PRT,ICNT,IDEF,0)
	    QPSPLOT = PRT(1:1).EQ.'Y' .OR. PRT(1:1).EQ.'y' .OR.
     +		      PRT(1:1).EQ.'L' .OR. PRT(1:1).EQ.'l'
	END IF
C								submit to laser
C								printer
	IF (QPSPLOT) THEN
	    CALL XVGET(INUNIT,ISTAT,'NAME',XLABEL,' ')
	    WRITE (PRT,400) XLABEL
  400	    FORMAT('File Name = ',A40)
	    CALL ADD0(PRT,52,LEN)
C
	    IF (NAREAS.GT.5) NAREAS=5
	    WRITE (MSG2,500) ((IAREA(J,I), J=1,4), I=1,NAREAS)
  500	    FORMAT(5('(', 3(I5,','), I5, ') '))
	    MSG2(26*NAREAS:26*NAREAS) = CHAR(0)
C
	    CALL XVP('XLABEL',XLABEL,ICNT)
	    CALL XVP('YLABEL',YLABEL,ICNT)
	    CALL ADD0(XLABEL,40,LEN)
	    CALL ADD0(YLABEL,40,LEN)
	    IF (QSIGMA) THEN
	      CALL PSPLOT(WAVE,DN(1,2),NB,XLO,XHI,YLO,YHI,NXTIC,NYTIC,
     +			  XLABEL,YLABEL,TITLE,PRT,MSG2,0)
	      CALL PSPLOT(WAVE,DN(1,1),NB,XLO,XHI,YLO,YHI,NXTIC,NYTIC,
     +			  XLABEL,YLABEL,TITLE,PRT,MSG2,0)
	      CALL PSPLOT(WAVE,DN(1,3),NB,XLO,XHI,YLO,YHI,NXTIC,NYTIC,
     +			  XLABEL,YLABEL,TITLE,PRT,MSG2,-1)
	    ELSE
	      CALL PSPLOT(WAVE,DN(1,2),NB,XLO,XHI,YLO,YHI,NXTIC,NYTIC,
     +			  XLABEL,YLABEL,TITLE,PRT,MSG2,-1)
	    END IF
	END IF
C
	RETURN
	END
