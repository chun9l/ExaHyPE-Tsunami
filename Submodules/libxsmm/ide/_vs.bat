@ECHO OFF

SET MSBUILDDISABLENODEREUSE=1

SET VS_VERSION=%1
IF "%VS_VERSION%"=="" SET VS_VERSION=9999
:SELECT_VS_VERSION
IF "%VS_VERSION%"=="2019" SET VS_COMNTOOLS="C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\Tools\"
IF "%VS_VERSION%"=="2017" SET VS_COMNTOOLS="%VS2017INSTALLDIR%\Common\Tools\"
IF "%VS_VERSION%"=="2015" SET VS_COMNTOOLS="%VS140COMNTOOLS%"
IF "%VS_VERSION%"=="2013" SET VS_COMNTOOLS="%VS120COMNTOOLS%"
IF "%VS_VERSION%"=="2010" SET VS_COMNTOOLS="%VS110COMNTOOLS%"
IF "%VS_VERSION%"=="2010" SET VS_COMNTOOLS="%VS100COMNTOOLS%"
IF "%VS_VERSION%"=="2008" SET VS_COMNTOOLS="%VS90COMNTOOLS%"
IF %VS_COMNTOOLS%=="" (
  IF %VS_VERSION% GTR 2008 (
    SET/A VS_VERSION-=1
    GOTO SELECT_VS_VERSION
  )
)

SET ICL_VERSION=%2
IF "%ICL_VERSION%"=="" SET ICL_VERSION=%VS_VERSION:~2,4%
IF "%ICL_VERSION%"=="" SET ICL_VERSION=99
:SELECT_ICL_VERSION
IF "%ICL_VERSION%"=="19" SET ICPP_COMPILER=%ICPP_COMPILER19%
IF "%ICL_VERSION%"=="18" SET ICPP_COMPILER=%ICPP_COMPILER18%
IF "%ICL_VERSION%"=="17" SET ICPP_COMPILER=%ICPP_COMPILER17%
IF "%ICL_VERSION%"=="16" SET ICPP_COMPILER=%ICPP_COMPILER16%
IF "%ICL_VERSION%"=="15" SET ICPP_COMPILER=%ICPP_COMPILER15%
IF "%ICL_VERSION%"=="14" SET ICPP_COMPILER=%ICPP_COMPILER14%
IF "%ICL_VERSION%"=="13" SET ICPP_COMPILER=%ICPP_COMPILER13%
IF "%ICL_VERSION%"=="12" SET ICPP_COMPILER=%ICPP_COMPILER12%
IF "%ICPP_COMPILER%"=="" (
  IF %ICL_VERSION% GTR 12 (
    SET/A ICL_VERSION-=1
    GOTO SELECT_ICL_VERSION
  )
)
REM CALL "%ICPP_COMPILER%bin\compilervars.bat" intel64 vs%VS_VERSION%
IF EXIST %ICPP_COMPILER%bin\compilervars.bat (
  IF "%PROCESSOR_ARCHITECTURE%"=="x86" (
    CALL "%ICPP_COMPILER%bin\compilervars.bat" ia32
  ) ELSE (
    CALL "%ICPP_COMPILER%bin\compilervars.bat" intel64
  )
) ELSE (
  IF %ICL_VERSION% GTR 12 (
    SET/A ICL_VERSION-=1
    GOTO SELECT_ICL_VERSION
  )
)

SET MPI_ROOT="%I_MPI_ROOT:-RT=%"

IF EXIST %VS_COMNTOOLS%"..\IDE\devenv.exe" (
  START/B "" %VS_COMNTOOLS%..\IDE\devenv.exe "%~d0%~p0_vs%VS_VERSION%.sln"
) ELSE (
  START/B "" "%~d0%~p0_vs%VS_VERSION%.sln"
)