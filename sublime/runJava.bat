@ECHO OFF 
cd %~dp1 
ECHO Compiling %~nx1...
IF EXIST %~n1.class ( 
DEL %~n1.class 
) 
javac -encoding utf-8 %~nx1 
IF EXIST %~n1.class ( 
ECHO Compiling Successfully...
ECHO Below is Output...
java %~n1 
)