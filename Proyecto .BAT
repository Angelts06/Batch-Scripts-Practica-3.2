@echo off
setlocal enabledelayedexpansion
:menu_principal
cls
echo ----- Menu Principal -----
echo 1. Registrarse
echo 2. Iniciar Sesion
echo 3. Salir del Programa
set /p opcion="Seleccione una opcion (1-3): "

if "%opcion%"=="1" goto registrar
if "%opcion%"=="2" goto iniciar_sesion
if "%opcion%"=="3" exit /b

:registrar
cls
echo ----- Registro de Usuario -----
set /p usuario="Ingrese su nombre de usuario: "
set /p pass1="Ingrese su contrasena: "
set /p pass2="Repita su contrasena: "
if "%pass1%" neq "%pass2%" (
    echo Las contraseñas no coinciden. Intente nuevamente.
    pause
    goto registrar
)

rem Almacena la información en un archivo de texto (deberias mejorar esto para mayor seguridad)
echo %usuario% %pass1% >> usuarios.txt

echo Usuario registrado exitosamente.
pause
goto menu_principal

:iniciar_sesion
cls
echo ----- Inicio de Sesion -----
set /p usuario="Ingrese su nombre de usuario: "
set /p password="Ingrese su contrasena: "

rem Verifica si el usuario existe en el archivo de texto
set "encontrado="
for /f "tokens=1,2" %%a in (usuarios.txt) do (
    if "%%a"=="%usuario%" (
        set "encontrado=1"
        if "%%b"=="%password%" (
            echo ¡¡Bienvenido, %usuario%!!
            call :opciones_usuario
        ) else (
            echo Contrasena incorrecta.
            pause
            goto menu_principal
        )
    )
)

if not defined encontrado (
    echo Nombre de usuario no encontrado.
    pause
    goto menu_principal
)

exit /b

:opciones_usuario
cls
echo ----- Opciones de Usuario -----
echo 1. Modificar contrasena
echo 2. Eliminar usuario
echo 3. Cerrar sesión
set /p opcion="Seleccione una opcion (1-3): "

if "%opcion%"=="1" goto modificar_contrasena
if "%opcion%"=="2" goto eliminar_usuario
if "%opcion%"=="3" goto menu_principal

:modificar_contrasena
cls
echo ----- Modificar Contraseña -----
set /p nueva_pass="Ingrese su nueva contrasena: "

rem Actualiza la contraseña en el archivo de texto
(for /f "tokens=1,*" %%a in (usuarios.txt) do (
    if "%%a"=="%usuario%" (
        echo %usuario% %nueva_pass%
    ) else (
        echo %%a %%b
    )
)) > usuarios_temp.txt
move /y usuarios_temp.txt usuarios.txt

echo Contraseña modificada exitosamente.
pause
goto opciones_usuario

:eliminar_usuario
cls
echo ----- Eliminar Usuario -----
rem Elimina al usuario del archivo de texto
type usuarios.txt | findstr /v "%usuario%" > usuarios_temp.txt
move /y usuarios_temp.txt usuarios.txt

echo Usuario eliminado exitosamente.
pause
goto menu_principal