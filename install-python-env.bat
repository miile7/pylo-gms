@echo off

echo Preparing python environment and installing PyLo
echo.

echo Installing modules
echo.

call activate GMS_VENV_PYTHON

python -m pip install requests
python -m pip install execdmscript
@REM python -m pip install pylo

echo.
echo.
echo.
echo ===============================================================
echo.
echo The PyLo core and all required modules are installed.
echo Now you can continue by integrating PyLo into DigitalMicrograph.
echo To do so execute the `install.s` in DigitalMicrograph.
echo.
echo.
echo.

pause