; 在文件开头添加安装目录设置，并修正反斜杠转义问题
InstallDir "$PROGRAMFILES64\FileTypeIco"

; 安装时添加右键菜单
Section "Register Context Menu"
    WriteRegStr HKCR "*\shell\filetypeico" "" "FileTypeIco"
    WriteRegStr HKCR "*\shell\filetypeico\command" "" "$EXEDIR\\filetypeico.exe %1"

    ; 注册主菜单，显示图标和 FileTypeIco
    WriteRegStr HKCR "Folder\shell\filetypeico" "" "FileTypeIco"
    ; 设置主菜单图标，指向 build/icon.ico 文件
    WriteRegStr HKCR "Folder\shell\filetypeico" "Icon" "$INSTDIR\\build\\icon.ico"
    ; 设置为有子菜单的形式
    WriteRegStr HKCR "Folder\shell\filetypeico" "SubCommands" "1 2 3"
    
    ; 注册子菜单 1
    WriteRegStr HKCR "Folder\shell\filetypeico\shell\1" "" "1"
    WriteRegStr HKCR "Folder\shell\filetypeico\shell\1\command" "" "$EXEDIR\\filetypeico.exe %1"

    ; 注册子菜单 2
    WriteRegStr HKCR "Folder\shell\filetypeico\shell\2" "" "2"
    WriteRegStr HKCR "Folder\shell\filetypeico\shell\2\command" "" "$EXEDIR\\filetypeico.exe %1"
    
    ; 注册子菜单 3
    WriteRegStr HKCR "Folder\shell\filetypeico\shell\3" "" "3"
    WriteRegStr HKCR "Folder\shell\filetypeico\shell\3\command" "" "$EXEDIR\\filetypeico.exe %1"
    ; 删除多余的命令注册
    ; WriteRegStr HKCR "Folder\shell\filetypeico\command" "" '"$EXEDIR\filetypeico.exe" "%1"'
SectionEnd

; 新的安装部分，设置安装目录并写入卸载程序
Section "Install"
    ; 删除错误添加的注释和指令
    ; 在文件开头添加以下内容
    ; InstallDir "$PROGRAMFILES64\FileTypeIco"
    ; 设置安装目录
    setOutPath $INSTDIR
    ; 写入卸载程序
    setShellVarContext all
    WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

; 卸载时删除注册表项
Section "Uninstall"
    DeleteRegKey HKCR "*\shell\filetypeico"
    DeleteRegKey HKCR "Folder\shell\filetypeico"
SectionEnd