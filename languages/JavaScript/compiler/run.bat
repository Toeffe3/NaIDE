@ECHO OFF
CD %1
FOR /F "TOKENS=1,2 DELIMS==" %%G IN (project.properties) DO SET %%G=%%H
SET path=%path%;%node.path%
CLS
NODE %project.src%\%project.main% %project.args% >> LOG.TXT
EXIT /B