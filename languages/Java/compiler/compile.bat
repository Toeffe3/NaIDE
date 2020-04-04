@ECHO OFF
CD %1
FOR /F "TOKENS=1,2 DELIMS==" %%G IN (project.properties) DO SET %%G=%%H
SET path=%path%;%java.jdk%
IF NOT EXIST %project.output% MKDIR %project.output%
CLS
JAVAC -encoding "UTF-8" -cp "%project.libraries%/*"; -d %project.output% %project.src%/*.java" >> LOG.TXT
EXIT /B