@ECHO OFF
CD %1
FOR /F "TOKENS=1,2 DELIMS==" %%G IN (project.properties) DO SET %%G=%%H
SET path=%path%;%java.jre%
CD %project.output%
CLS
JAVA -server -Dfile.encoding=UTF-8 -Duser.language=da -cp ../%project.libraries%/*; %project.main% %project.args%
EXIT /B