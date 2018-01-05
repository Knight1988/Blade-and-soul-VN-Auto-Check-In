#include <ScreenCapture.au3>

Opt("WinTitleMatchMode", 3)
HotKeySet("{F12}", "_Exit")

_Main()

Func _Exit()
   Exit
EndFunc

Func _Main()
   ; Read password file to array
   Local $aUsers = FileReadToArray(@ScriptDir & "\Passwords.csv")

   For $user in $aUsers
	  ; get username and password from array
	  $aArray = StringSplit($user, ",")
	  Local $Username = $aArray[1]
	  Local $Password = $aArray[2]

	  ; Process checkin
	  _Login($Username, $Password)
	  _LaunchGame()
	  _SelectCharacter()
	  _CheckIn($Username)
   Next
EndFunc

Func _Login($Username, $Password)
   ; Kill processes
   ProcessClose("Client.exe")
   ProcessClose("Garena.exe")

   ; Wait for process being killed
   Sleep(2000)

   ; Run new Garena launcher
   Run("C:\Program Files (x86)\Garena\Garena\Garena.exe")
   Const $LAUNCHER_TITLE = "Garena - Nền Tảng Game Đỉnh Cao Của Bạn";

   ; Active the launcher
   Local $hLauncher = WinWait($LAUNCHER_TITLE)
   WinActivate($hLauncher)
   WinWaitActive($hLauncher)

   ControlClick($hLauncher, "", $hLauncher, "primary", 1, 572, 126)
   ; Enter username
   Send("{TAB}{TAB}")
   Send($Username)
   ; Enter password
   Send("{TAB}")
   Send($Password)
   ; Login
   Send("{Enter}")
EndFunc

Func _LaunchGame()
   Const $LAUNCHER_TITLE = "Garena - Trò chơi";
   ; Wait launcher to load
   Sleep(10000)

   ; Active launcher
   Local $hLauncher = WinWait($LAUNCHER_TITLE)
   WinActivate($hLauncher)
   WinWaitActive($hLauncher)

   ; Select blade and soul
   ControlClick($hLauncher, "", "[CLASS:Chrome_RenderWidgetHostHWND; INSTANCE:1]", "primary", 1, 598, 235)
   Sleep(5000)

   ; Click play game
   ControlClick($hLauncher, "", "[CLASS:Chrome_RenderWidgetHostHWND; INSTANCE:1]", "primary", 1, 479, 636)
EndFunc

Func _SelectCharacter()
   Const $GAME_TITLE = "Blade & Soul"
   ; Wait for game to load
   Sleep(90000)

   ; Activate game
   Local $hGame = WinWait($GAME_TITLE)
   WinActivate($hGame)
   WinWaitActive($hGame)

   ; Select character
   Send("{Enter}")
   Sleep(1000)
   Send("{Enter}")
   Sleep(5000)
EndFunc

Func _CheckIn($Username)
   Const $GAME_TITLE = "Blade & Soul";
   ; Wait for game to load
   Sleep(60000)

   ; Activate game
   Local $hGame = WinWait($GAME_TITLE)
   WinActivate($hGame)
   WinWaitActive($hGame)

   ; Cancel anything
   Send("{ESC}")
   Sleep(1000)

   ; Open and close Item
   Send("i")
   Sleep(1000)
   Send("{ESC}")
   Sleep(1000)

   ; Open game menu
   Send("{ESC}")
   Sleep(1000)

   ; Click on check in
   MouseClick("primary", 1300, 600)
   Sleep(2000)

   ; Capture full screen
    _ScreenCapture_Capture("H:\Temp\" & $Username & ".jpg")
EndFunc