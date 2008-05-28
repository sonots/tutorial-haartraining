# Microsoft Developer Studio Project File - Name="cvhaartraining" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=cvhaartraining - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "cvhaartraining.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "cvhaartraining.mak" CFG="cvhaartraining - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "cvhaartraining - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "cvhaartraining - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=xicl6.exe
RSC=rc.exe

!IF  "$(CFG)" == "cvhaartraining - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "../../../_temp/cvhaartraining_rls"
# PROP Intermediate_Dir "../../../_temp/cvhaartraining_rls"
# PROP Target_Dir ""
LINK32=link.exe
MTL=midl.exe
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_MBCS" /D "_LIB" /YX /FD /c
# ADD CPP /nologo /MD /W3 /GX /Zi /O2 /I "..\src" /I "..\include" /I "../../../cv/include" /I "../../../cv/src" /I "../../../cxcore/include" /I "../../../otherlibs/highgui" /D "WIN32" /D "NDEBUG" /D "_MBCS" /D "_LIB" /YX /FD -Qopenmp /c
# ADD BASE RSC /l 0x419 /d "NDEBUG"
# ADD RSC /l 0x419 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=xilink6.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo /out:"../../../lib/cvhaartraining.lib"

!ELSEIF  "$(CFG)" == "cvhaartraining - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "../../../_temp/cvhaartraining_dbg"
# PROP Intermediate_Dir "../../../_temp/cvhaartraining_dbg"
# PROP Target_Dir ""
LINK32=link.exe
MTL=midl.exe
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_MBCS" /D "_LIB" /YX /FD /GZ /c
# ADD CPP /nologo /MDd /W3 /Gm /GX /Zi /Od /I "..\src" /I "..\include" /I "../../../cv/include" /I "../../../cv/src" /I "../../../cxcore/include" /I "../../../otherlibs/highgui" /D "WIN32" /D "_DEBUG" /D "_MBCS" /D "_LIB" /YX /FD /GZ /c
# ADD BASE RSC /l 0x419 /d "_DEBUG"
# ADD RSC /l 0x419 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=xilink6.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo /out:"../../../lib/cvhaartrainingd.lib"

!ENDIF 

# Begin Target

# Name "cvhaartraining - Win32 Release"
# Name "cvhaartraining - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=..\src\cvboost.cpp
# End Source File
# Begin Source File

SOURCE=..\src\cvcommon.cpp
# End Source File
# Begin Source File

SOURCE=..\src\cvhaarclassifier.cpp
# End Source File
# Begin Source File

SOURCE=..\src\cvhaartraining.cpp
# End Source File
# Begin Source File

SOURCE=..\src\cvsamples.cpp
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=..\src\_cvcommon.h
# End Source File
# Begin Source File

SOURCE=..\src\_cvhaartraining.h
# End Source File
# Begin Source File

SOURCE=..\src\cvclassifier.h
# End Source File
# Begin Source File

SOURCE=..\include\cvhaartraining.h
# End Source File
# End Group
# End Target
# End Project
