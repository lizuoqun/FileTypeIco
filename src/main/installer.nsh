!macro customInstall
   WriteRegStr HKCR "*\shell\FileTypeIco" "" "上传文件demo"
   WriteRegStr HKCR "*\shell\FileTypeIco" "Icon" "$INSTDIR\FileTypeIco.exe"
   WriteRegStr HKCR "*\shell\FileTypeIco\command" "" '"$INSTDIR\FileTypeIco.exe" "read" "%1"'
!macroend
;卸载时清除
!macro customUninstall
   DeleteRegKey HKCR "*\shell\FileTypeIco"
!macroend
