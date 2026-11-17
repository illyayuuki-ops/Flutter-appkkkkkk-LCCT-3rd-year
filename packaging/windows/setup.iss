#define AppVersion "0.3.0"
[Setup]
AppId={{A86D6433-2B4A-4CE6-91C6-9AA92C28BD71}
AppName=LCCT Help Desk
AppVersion={#AppVersion}
AppPublisher=LCCT Help Desk Project
DefaultDirName={autopf}\LCCT Help Desk
DefaultGroupName=LCCT Help Desk
OutputDir=..\..\downloads
OutputBaseFilename=LCCT-Windows-Setup-x64
SetupIconFile=..\..\windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\lcct_guidance.exe
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=admin
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
CloseApplications=yes

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"; Flags: checkedonce

[Files]
Source: "..\..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\..\packaging\windows\prerequisites\vc_redist.x64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "..\..\packaging\windows\prerequisites\MicrosoftEdgeWebview2Setup.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall

[Icons]
Name: "{group}\LCCT Help Desk"; Filename: "{app}\lcct_guidance.exe"
Name: "{autodesktop}\LCCT Help Desk"; Filename: "{app}\lcct_guidance.exe"; Tasks: desktopicon

[Run]
Filename: "{tmp}\vc_redist.x64.exe"; Parameters: "/install /quiet /norestart"; StatusMsg: "Installing Microsoft Visual C++ runtime..."; Flags: waituntilterminated
Filename: "{tmp}\MicrosoftEdgeWebview2Setup.exe"; Parameters: "/silent /install"; StatusMsg: "Installing Microsoft WebView2 (internet required)..."; Flags: waituntilterminated; Check: not HasWebView2
Filename: "{app}\lcct_guidance.exe"; Description: "Open LCCT Help Desk"; Flags: nowait postinstall skipifsilent runasoriginaluser

[Code]
function HasWebView2: Boolean;
var
  Names: TArrayOfString;
  I: Integer;
  ProductName, Version: String;
  Root: Integer;
  Base: String;
begin
  Result := False;
  Base := 'Software\Microsoft\EdgeUpdate\Clients';
  for Root := 0 to 2 do begin
    if Root = 0 then begin
      if not RegGetSubkeyNames(HKLM32, Base, Names) then Continue;
    end else if Root = 1 then begin
      if not RegGetSubkeyNames(HKLM64, Base, Names) then Continue;
    end else begin
      if not RegGetSubkeyNames(HKCU, Base, Names) then Continue;
    end;
    for I := 0 to GetArrayLength(Names) - 1 do begin
      ProductName := ''; Version := '';
      if Root = 0 then begin
        RegQueryStringValue(HKLM32, Base + '\' + Names[I], 'name', ProductName);
        RegQueryStringValue(HKLM32, Base + '\' + Names[I], 'pv', Version);
      end else if Root = 1 then begin
        RegQueryStringValue(HKLM64, Base + '\' + Names[I], 'name', ProductName);
        RegQueryStringValue(HKLM64, Base + '\' + Names[I], 'pv', Version);
      end else begin
        RegQueryStringValue(HKCU, Base + '\' + Names[I], 'name', ProductName);
        RegQueryStringValue(HKCU, Base + '\' + Names[I], 'pv', Version);
      end;
      if (Pos('webview2', Lowercase(ProductName)) > 0) and
         (Version <> '') and (Version <> '0.0.0.0') then begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

