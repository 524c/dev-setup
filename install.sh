#!/usr/bin/env bash

function update_sudoers() {
  if ! sudo grep -q "^%admin.*NOPASSWD" /etc/sudoers; then
    if sudo grep -q "^%admin.*ALL" /etc/sudoers; then
	    if sed --version 2>&1 | grep -q "GNU"; then
	      sudo sed -i 's/^%admin.*ALL/%admin ALL=(ALL) NOPASSWD:ALL/' /etc/sudoers
	    else
	      sudo sed -i '' 's/^%admin.*ALL/%admin ALL=(ALL) NOPASSWD:ALL/' /etc/sudoers
	    fi
	  elif sudo grep -q "^#.*%admin.*NOPASSWD" /etc/sudoers; then
	    if sed --version 2>&1 | grep -q "GNU"; then
	      sudo sed -i 's/^#.*%admin.*NOPASSWD/%admin ALL=(ALL) NOPASSWD:ALL/' /etc/sudoers
	    else
	      sudo sed -i '' 's/^#.*%admin.*NOPASSWD/%admin ALL=(ALL) NOPASSWD:ALL/' /etc/sudoers
	    fi
	  else
      echo "%admin ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers > /dev/null
	  fi
	fi
}

function install_apps() {
  brew update > /dev/null 2>&1
  echo "installing packages..."

  app_names=(
    "iterm2:iTerm.app"
    "visual-studio-code:Visual Studio Code.app"
    "firefox:Firefox.app"
    "slack:Slack.app"
    "microsoft-teams:Microsoft Teams.app"
    #"microsoft-office:Microsoft Word.app"
    "docker:Docker.app"
  )

  for app_name in "${app_names[@]}"
  do
    package="${app_name%%:*}"
    application="${app_name#*:}"

    if ! [ -d "/Applications/$application" ]; then
      brew install --cask --force "$package"
    else
      echo "The application $application is already installed in /Applications"
    fi
  done

  brew install coreutils binutils diffutils gawk gnutls screen tmux watch wget curl gpatch m4 make gcc vim nano file-formula git less openssh perl python3 rsync zsh ffmpeg ed findutils wdiff grep gnu-indent gnu-sed gnu-tar unzip gzip xz gnu-which fswatch lsusb fsevents-tools openssl brotli base64 mkcert redis htop btop go tanka jsonnet-bundler readline pyenv pyenv-virtualenv pgcli jq multipass tldr kubectl kubecolor tcpdump libassuan gnupg unxip > /dev/null 2>&1
}

function install_fonts() {
  brew tap homebrew/linux-fonts > /dev/null 2>&1 # for other font options
	
	curl -s "https://raw.githubusercontent.com/524c/powerlevel10k-media/master/MesloLGS%20NF%20Regular.ttf" -o "/Library/Fonts/MesloLGS NF Regular.ttf"
}

function setup_iterm2() {
  ITERM2_PLIST="$HOME/Library/Preferences/com.googlecode.iterm2.plist"
  [ -f "$ITERM2_PLIST" ] && cp "$ITERM2_PLIST" "${ITERM2_PLIST}.bak"

# convert from binary to xml
# plutil -convert xml1 -o iterm2_prefs.xml $ITERM2_PLIST

cat <<EOF | plutil -convert binary1 -o "$ITERM2_PLIST" -- -
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>AboutToPasteTabsWithCancel</key>
	<true/>
	<key>AboutToPasteTabsWithCancel_selection</key>
	<integer>0</integer>
	<key>AdjustWindowForFontSizeChange</key>
	<true/>
	<key>AppleAntiAliasingThreshold</key>
	<integer>1</integer>
	<key>ApplePressAndHoldEnabled</key>
	<false/>
	<key>AppleScrollAnimationEnabled</key>
	<integer>0</integer>
	<key>AppleSmoothFixedFontsSizeThreshold</key>
	<integer>1</integer>
	<key>AppleWindowTabbingMode</key>
	<string>manual</string>
	<key>AutoHideTmuxClientSession</key>
	<false/>
	<key>ClickToSelectCommand</key>
	<false/>
	<key>Command</key>
	<string>/usr/local/bin/zsh</string>
	<key>CopySelection</key>
	<true/>
	<key>Default Arrangement Name</key>
	<string>Arrangement 1</string>
	<key>Default Bookmark Guid</key>
	<string>38F7D8F0-7092-48BE-914A-6D517CF031EC</string>
	<key>DimBackgroundWindows</key>
	<false/>
	<key>DimInactiveSplitPanes</key>
	<true/>
	<key>DimOnlyText</key>
	<false/>
	<key>DisableFullscreenTransparency</key>
	<false/>
	<key>DoubleClickPerformsSmartSelection</key>
	<false/>
	<key>EnableDivisionView</key>
	<true/>
	<key>EnableProxyIcon</key>
	<false/>
	<key>FocusFollowsMouse</key>
	<true/>
	<key>HapticFeedbackForEsc</key>
	<false/>
	<key>HideActivityIndicator</key>
	<false/>
	<key>HideScrollbar</key>
	<false/>
	<key>HideTabNumber</key>
	<false/>
	<key>HotkeyMigratedFromSingleToMulti</key>
	<true/>
	<key>LanguageAgnosticKeyBindings</key>
	<true/>
	<key>LoadPrefsFromCustomFolder</key>
	<false/>
	<key>MinimalEdgeDragSize</key>
	<real>20</real>
	<key>MinimumTabDragDistance</key>
	<integer>20</integer>
	<key>NSNavPanelExpandedSizeForOpenMode</key>
	<string>{800, 448}</string>
	<key>NSNavPanelExpandedSizeForSaveMode</key>
	<string>{800, 448}</string>
	<key>NSNavPanelExpandedStateForSaveMode</key>
	<true/>
	<key>NSOSPLastRootDirectory</key>
	<data>
	Ym9va+ACAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAuAEA
	AAQAAAADAwAAAAQAAAUAAAABAQAAVXNlcnMAAAAGAAAAAQEAAHJsdWNhcwAABwAAAAEB
	AABEZXNrdG9wAAwAAAABBgAAEAAAACAAAAAwAAAACAAAAAQDAACxOAAAAAAAAAgAAAAE
	AwAA0tYDAAAAAAAIAAAABAMAANfWAwAAAAAADAAAAAEGAABUAAAAZAAAAHQAAAAIAAAA
	AAQAAEHE4rzVAAAAGAAAAAECAAACAAAAAAAAAB8CAAAAAAAAHwIAAAAAAAAAAAAAAQUA
	AAgAAAAEAwAAAQAAAAAAAAAEAAAAAwMAAPUBAAAIAAAAAQkAAGZpbGU6Ly8vAwAAAAEB
	AABTU0QACAAAAAQDAAAAUKEbcwAAAAgAAAAABAAAQcY3wWoAAAAkAAAAAQEAADQ2QTYz
	OUJDLTNBRTItNDlFRi04RUZCLUUwMUM4NUQxODU3MxgAAAABAgAAgQAAAAEAAADvEwAA
	AQAAAO8TAAABAAAAAQAAAAEBAAAvAAAAMAAAAAECAABkbmliAAAAAAEAAAAAAAAAAAAA
	AAAAAAAAAAAAAAAAAAAAAABrc2VkAgAAAAAAAADwAAAA/v///wEAAAAAAAAAEwAAAAQQ
	AABAAAAAAAAAAAUQAACEAAAAAAAAABAQAACoAAAAAAAAAEAQAACYAAAAAAAAAAIgAAB0
	AQAAAAAAAAUgAADsAAAAAAAAABAgAAD8AAAAAAAAABEgAAAoAQAAAAAAABIgAAAIAQAA
	AAAAABMgAAAYAQAAAAAAACAgAABUAQAAAAAAADAgAADIAAAAAAAAAAHAAADQAAAAAAAA
	ABHAAAAgAAAAAAAAABLAAADgAAAAAAAAAAHQAADIAAAAAAAAABDQAAAEAAAAAAAAABfw
	AAAwAAAAAAAAACLwAACAAQAAAAAAAA==
	</data>
	<key>NSOverlayScrollersFallBackForAccessoryViews</key>
	<false/>
	<key>NSQuotedKeystrokeBinding</key>
	<string></string>
	<key>NSRepeatCountBinding</key>
	<string></string>
	<key>NSScrollAnimationEnabled</key>
	<false/>
	<key>NSScrollViewShouldScrollUnderTitlebar</key>
	<false/>
	<key>NSSplitView Subview Frames NSColorPanelSplitView</key>
	<array>
		<string>0.000000, 0.000000, 224.000000, 258.000000, NO, NO</string>
		<string>0.000000, 259.000000, 224.000000, 48.000000, NO, NO</string>
	</array>
	<key>NSToolbar Configuration com.apple.NSColorPanel</key>
	<dict>
		<key>TB Is Shown</key>
		<integer>1</integer>
	</dict>
	<key>NSWindow Frame NSColorPanel</key>
	<string>0 200 224 278 0 0 2048 1127 </string>
	<key>NSWindow Frame NSNavPanelAutosaveName</key>
	<string>600 540 800 448 0 0 2048 1127 </string>
	<key>NSWindow Frame ProfilesPanel</key>
	<string>226 519 735 388 0 0 1512 944 </string>
	<key>NSWindow Frame SUStatusFrame</key>
	<string>824 758 400 135 0 0 2048 1127 </string>
	<key>NSWindow Frame SUUpdateAlert</key>
	<string>683 389 681 628 0 0 2048 1127 </string>
	<key>NSWindow Frame UKCrashReporter</key>
	<string>180 611 592 590 0 0 2560 1415 </string>
	<key>NSWindow Frame iTerm Window 0</key>
	<string>256 496 985 458 0 0 2048 1127 </string>
	<key>NeverWarnAboutShortLivedSessions_38F7D8F0-7092-48BE-914A-6D517CF031EC</key>
	<true/>
	<key>NeverWarnAboutShortLivedSessions_38F7D8F0-7092-48BE-914A-6D517CF031EC_selection</key>
	<integer>0</integer>
	<key>New Bookmarks</key>
	<array>
		<dict>
			<key>ASCII Anti Aliased</key>
			<true/>
			<key>ASCII Ligatures</key>
			<true/>
			<key>Allow Change Cursor Blink</key>
			<false/>
			<key>Allow Paste Bracketing</key>
			<false/>
			<key>Allow Title Reporting</key>
			<false/>
			<key>Ambiguous Double Width</key>
			<false/>
			<key>Ansi 0 Color</key>
			<dict>
				<key>Blue Component</key>
				<real>0.0</real>
				<key>Green Component</key>
				<real>0.0</real>
				<key>Red Component</key>
				<real>0.0</real>
			</dict>
			<key>Ansi 0 Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.11764705926179886</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.098039217293262454</real>
				<key>Red Component</key>
				<real>0.078431375324726105</real>
			</dict>
			<key>Ansi 0 Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.11764705926179886</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.098039217293262454</real>
				<key>Red Component</key>
				<real>0.078431375324726105</real>
			</dict>
			<key>Ansi 1 Color</key>
			<dict>
				<key>Blue Component</key>
				<real>0.0</real>
				<key>Green Component</key>
				<real>0.0</real>
				<key>Red Component</key>
				<real>0.73333334922790527</real>
			</dict>
			<key>Ansi 1 Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.16300037503242493</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.23660069704055786</real>
				<key>Red Component</key>
				<real>0.7074432373046875</real>
			</dict>
			<key>Ansi 1 Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.16300037503242493</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.23660069704055786</real>
				<key>Red Component</key>
				<real>0.7074432373046875</real>
			</dict>
			<key>Ansi 10 Color</key>
			<dict>
				<key>Blue Component</key>
				<real>0.3333333432674408</real>
				<key>Green Component</key>
				<real>1</real>
				<key>Red Component</key>
				<real>0.3333333432674408</real>
			</dict>
			<key>Ansi 10 Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.56541937589645386</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.9042816162109375</real>
				<key>Red Component</key>
				<real>0.3450070321559906</real>
			</dict>
			<key>Ansi 10 Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.56541937589645386</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.9042816162109375</real>
				<key>Red Component</key>
				<real>0.3450070321559906</real>
			</dict>
			<key>Ansi 11 Color</key>
			<dict>
				<key>Blue Component</key>
				<real>0.3333333432674408</real>
				<key>Green Component</key>
				<real>1</real>
				<key>Red Component</key>
				<real>1</real>
			</dict>
			<key>Ansi 11 Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<integer>0</integer>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.8833775520324707</real>
				<key>Red Component</key>
				<real>0.9259033203125</real>
			</dict>
			<key>Ansi 11 Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<integer>0</integer>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.8833775520324707</real>
				<key>Red Component</key>
				<real>0.9259033203125</real>
			</dict>
			<key>Ansi 12 Color</key>
			<dict>
				<key>Blue Component</key>
				<real>1</real>
				<key>Green Component</key>
				<real>0.3333333432674408</real>
				<key>Red Component</key>
				<real>0.3333333432674408</real>
			</dict>
			<key>Ansi 12 Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.9485321044921875</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.67044717073440552</real>
				<key>Red Component</key>
				<real>0.65349078178405762</real>
			</dict>
			<key>Ansi 12 Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.9485321044921875</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.67044717073440552</real>
				<key>Red Component</key>
				<real>0.65349078178405762</real>
			</dict>
			<key>Ansi 13 Color</key>
			<dict>
				<key>Blue Component</key>
				<real>1</real>
				<key>Green Component</key>
				<real>0.3333333432674408</real>
				<key>Red Component</key>
				<real>1</real>
			</dict>
			<key>Ansi 13 Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.8821563720703125</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.4927266538143158</real>
				<key>Red Component</key>
				<real>0.8821563720703125</real>
			</dict>
			<key>Ansi 13 Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.8821563720703125</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.4927266538143158</real>
				<key>Red Component</key>
				<real>0.8821563720703125</real>
			</dict>
			<key>Ansi 14 Color</key>
			<dict>
				<key>Blue Component</key>
				<real>1</real>
				<key>Green Component</key>
				<real>1</real>
				<key>Red Component</key>
				<real>0.3333333432674408</real>
			</dict>
			<key>Ansi 14 Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<integer>1</integer>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.99263292551040649</real>
				<key>Red Component</key>
				<real>0.37597531080245972</real>
			</dict>
			<key>Ansi 14 Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<integer>1</integer>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.99263292551040649</real>
				<key>Red Component</key>
				<real>0.37597531080245972</real>
			</dict>
			<key>Ansi 15 Color</key>
			<dict>
				<key>Blue Component</key>
				<real>1</real>
				<key>Green Component</key>
				<real>1</real>
				<key>Red Component</key>
				<real>1</real>
			</dict>
			<key>Ansi 15 Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<integer>1</integer>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<integer>1</integer>
				<key>Red Component</key>
				<real>0.99999600648880005</real>
			</dict>
			<key>Ansi 15 Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<integer>1</integer>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<integer>1</integer>
				<key>Red Component</key>
				<real>0.99999600648880005</real>
			</dict>
			<key>Ansi 2 Color</key>
			<dict>
				<key>Blue Component</key>
				<real>0.0</real>
				<key>Green Component</key>
				<real>0.73333334922790527</real>
				<key>Red Component</key>
				<real>0.0</real>
			</dict>
			<key>Ansi 2 Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<integer>0</integer>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.7607843279838562</real>
				<key>Red Component</key>
				<integer>0</integer>
			</dict>
			<key>Ansi 2 Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<integer>0</integer>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.7607843279838562</real>
				<key>Red Component</key>
				<integer>0</integer>
			</dict>
			<key>Ansi 3 Color</key>
			<dict>
				<key>Blue Component</key>
				<real>0.0</real>
				<key>Green Component</key>
				<real>0.73333334922790527</real>
				<key>Red Component</key>
				<real>0.73333334922790527</real>
			</dict>
			<key>Ansi 3 Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<integer>0</integer>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.76959484815597534</real>
				<key>Red Component</key>
				<real>0.78058648109436035</real>
			</dict>
			<key>Ansi 3 Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<integer>0</integer>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.76959484815597534</real>
				<key>Red Component</key>
				<real>0.78058648109436035</real>
			</dict>
			<key>Ansi 4 Color</key>
			<dict>
				<key>Blue Component</key>
				<real>0.73333334922790527</real>
				<key>Green Component</key>
				<real>0.0</real>
				<key>Red Component</key>
				<real>0.0</real>
			</dict>
			<key>Ansi 4 Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.78216177225112915</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.26474356651306152</real>
				<key>Red Component</key>
				<real>0.15404300391674042</real>
			</dict>
			<key>Ansi 4 Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.78216177225112915</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.26474356651306152</real>
				<key>Red Component</key>
				<real>0.15404300391674042</real>
			</dict>
			<key>Ansi 5 Color</key>
			<dict>
				<key>Blue Component</key>
				<real>0.73333334922790527</real>
				<key>Green Component</key>
				<real>0.0</real>
				<key>Red Component</key>
				<real>0.73333334922790527</real>
			</dict>
			<key>Ansi 5 Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.74494361877441406</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.24931684136390686</real>
				<key>Red Component</key>
				<real>0.752197265625</real>
			</dict>
			<key>Ansi 5 Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.74494361877441406</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.24931684136390686</real>
				<key>Red Component</key>
				<real>0.752197265625</real>
			</dict>
			<key>Ansi 6 Color</key>
			<dict>
				<key>Blue Component</key>
				<real>0.73333334922790527</real>
				<key>Green Component</key>
				<real>0.73333334922790527</real>
				<key>Red Component</key>
				<real>0.0</real>
			</dict>
			<key>Ansi 6 Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.78166204690933228</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.77425903081893921</real>
				<key>Red Component</key>
				<integer>0</integer>
			</dict>
			<key>Ansi 6 Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.78166204690933228</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.77425903081893921</real>
				<key>Red Component</key>
				<integer>0</integer>
			</dict>
			<key>Ansi 7 Color</key>
			<dict>
				<key>Blue Component</key>
				<real>0.73333334922790527</real>
				<key>Green Component</key>
				<real>0.73333334922790527</real>
				<key>Red Component</key>
				<real>0.73333334922790527</real>
			</dict>
			<key>Ansi 7 Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.78104829788208008</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.78105825185775757</real>
				<key>Red Component</key>
				<real>0.7810397744178772</real>
			</dict>
			<key>Ansi 7 Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.78104829788208008</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.78105825185775757</real>
				<key>Red Component</key>
				<real>0.7810397744178772</real>
			</dict>
			<key>Ansi 8 Color</key>
			<dict>
				<key>Blue Component</key>
				<real>0.3333333432674408</real>
				<key>Green Component</key>
				<real>0.3333333432674408</real>
				<key>Red Component</key>
				<real>0.3333333432674408</real>
			</dict>
			<key>Ansi 8 Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.4078223705291748</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.40782788395881653</real>
				<key>Red Component</key>
				<real>0.40781760215759277</real>
			</dict>
			<key>Ansi 8 Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.4078223705291748</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.40782788395881653</real>
				<key>Red Component</key>
				<real>0.40781760215759277</real>
			</dict>
			<key>Ansi 9 Color</key>
			<dict>
				<key>Blue Component</key>
				<real>0.3333333432674408</real>
				<key>Green Component</key>
				<real>0.3333333432674408</real>
				<key>Red Component</key>
				<real>1</real>
			</dict>
			<key>Ansi 9 Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.45833224058151245</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.47524076700210571</real>
				<key>Red Component</key>
				<real>0.8659515380859375</real>
			</dict>
			<key>Ansi 9 Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.45833224058151245</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.47524076700210571</real>
				<key>Red Component</key>
				<real>0.8659515380859375</real>
			</dict>
			<key>BM Growl</key>
			<true/>
			<key>Background Color</key>
			<dict>
				<key>Blue Component</key>
				<real>0.0</real>
				<key>Green Component</key>
				<real>0.0</real>
				<key>Red Component</key>
				<real>0.0</real>
			</dict>
			<key>Background Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.12103271484375</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.099111050367355347</real>
				<key>Red Component</key>
				<real>0.0806884765625</real>
			</dict>
			<key>Background Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.97999999999999998</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.97999999999999998</real>
				<key>Red Component</key>
				<real>0.97999999999999998</real>
			</dict>
			<key>Badge Color</key>
			<dict>
				<key>Alpha Component</key>
				<real>0.5</real>
				<key>Blue Component</key>
				<real>0.0</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.14910030364990234</real>
				<key>Red Component</key>
				<real>1</real>
			</dict>
			<key>Badge Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<real>0.5</real>
				<key>Blue Component</key>
				<real>0.65218597462148864</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.65218597462148864</real>
				<key>Red Component</key>
				<real>0.9787440299987793</real>
			</dict>
			<key>Badge Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<real>0.5</real>
				<key>Blue Component</key>
				<real>0.11610633058398889</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.11610633058398889</real>
				<key>Red Component</key>
				<real>0.74613857269287109</real>
			</dict>
			<key>Blend</key>
			<real>0.26792346014492752</real>
			<key>Blink Allowed</key>
			<true/>
			<key>Blinking Cursor</key>
			<true/>
			<key>Blur</key>
			<false/>
			<key>Blur Radius</key>
			<real>2.5913776154213761</real>
			<key>Bold Color</key>
			<dict>
				<key>Blue Component</key>
				<real>1</real>
				<key>Green Component</key>
				<real>1</real>
				<key>Red Component</key>
				<real>1</real>
			</dict>
			<key>Bold Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<integer>1</integer>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<integer>1</integer>
				<key>Red Component</key>
				<real>0.99999600648880005</real>
			</dict>
			<key>Bold Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.062745098039215672</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.062745098039215672</real>
				<key>Red Component</key>
				<real>0.062745098039215672</real>
			</dict>
			<key>Character Encoding</key>
			<integer>4</integer>
			<key>Close Sessions On End</key>
			<true/>
			<key>Columns</key>
			<integer>90</integer>
			<key>Command</key>
			<string>/opt/homebrew/bin/zsh</string>
			<key>Cursor Color</key>
			<dict>
				<key>Blue Component</key>
				<real>0.73333334922790527</real>
				<key>Green Component</key>
				<real>0.73333334922790527</real>
				<key>Red Component</key>
				<real>0.73333334922790527</real>
			</dict>
			<key>Cursor Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.99998724460601807</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<integer>1</integer>
				<key>Red Component</key>
				<real>0.99997633695602417</real>
			</dict>
			<key>Cursor Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<integer>0</integer>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<integer>0</integer>
				<key>Red Component</key>
				<integer>0</integer>
			</dict>
			<key>Cursor Guide Color</key>
			<dict>
				<key>Alpha Component</key>
				<real>0.25</real>
				<key>Blue Component</key>
				<real>1</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.92681378126144409</real>
				<key>Red Component</key>
				<real>0.70214027166366577</real>
			</dict>
			<key>Cursor Guide Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<real>0.25</real>
				<key>Blue Component</key>
				<real>0.94099044799804688</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.80232617749205526</real>
				<key>Red Component</key>
				<real>0.37649588016392954</real>
			</dict>
			<key>Cursor Guide Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<real>0.25</real>
				<key>Blue Component</key>
				<real>0.85319280624389648</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.77217718629089516</real>
				<key>Red Component</key>
				<real>0.52338262643729649</real>
			</dict>
			<key>Cursor Shadow</key>
			<true/>
			<key>Cursor Text Color</key>
			<dict>
				<key>Blue Component</key>
				<real>1</real>
				<key>Green Component</key>
				<real>1</real>
				<key>Red Component</key>
				<real>1</real>
			</dict>
			<key>Cursor Text Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<integer>0</integer>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<integer>0</integer>
				<key>Red Component</key>
				<integer>0</integer>
			</dict>
			<key>Cursor Text Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<integer>1</integer>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<integer>1</integer>
				<key>Red Component</key>
				<integer>1</integer>
			</dict>
			<key>Cursor Type</key>
			<integer>2</integer>
			<key>Custom Command</key>
			<string>Custom Shell</string>
			<key>Custom Directory</key>
			<string>No</string>
			<key>Custom Locale</key>
			<string>en_US.UTF-8</string>
			<key>Custom Window Title</key>
			<string></string>
			<key>Default Bookmark</key>
			<string>No</string>
			<key>Description</key>
			<string>Default</string>
			<key>Disable Printing</key>
			<false/>
			<key>Disable Window Resizing</key>
			<true/>
			<key>Draw Powerline Glyphs</key>
			<true/>
			<key>Enable Triggers in Interactive Apps</key>
			<false/>
			<key>Flashing Bell</key>
			<true/>
			<key>Foreground Color</key>
			<dict>
				<key>Blue Component</key>
				<real>0.73333334922790527</real>
				<key>Green Component</key>
				<real>0.73333334922790527</real>
				<key>Red Component</key>
				<real>0.73333334922790527</real>
			</dict>
			<key>Foreground Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.86198854446411133</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.86199951171875</real>
				<key>Red Component</key>
				<real>0.86197912693023682</real>
			</dict>
			<key>Foreground Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.062745098039215672</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.062745098039215672</real>
				<key>Red Component</key>
				<real>0.062745098039215672</real>
			</dict>
			<key>Guid</key>
			<string>38F7D8F0-7092-48BE-914A-6D517CF031EC</string>
			<key>Horizontal Spacing</key>
			<real>1</real>
			<key>Icon</key>
			<integer>0</integer>
			<key>Idle Code</key>
			<integer>0</integer>
			<key>Initial Use Transparency</key>
			<true/>
			<key>Jobs to Ignore</key>
			<array>
				<string>rlogin</string>
				<string>ssh</string>
				<string>slogin</string>
				<string>telnet</string>
			</array>
			<key>Keyboard Map</key>
			<dict>
				<key>0x2d-0x40000</key>
				<dict>
					<key>Action</key>
					<integer>11</integer>
					<key>Text</key>
					<string>0x1f</string>
				</dict>
				<key>0x32-0x40000</key>
				<dict>
					<key>Action</key>
					<integer>11</integer>
					<key>Text</key>
					<string>0x00</string>
				</dict>
				<key>0x33-0x40000</key>
				<dict>
					<key>Action</key>
					<integer>11</integer>
					<key>Text</key>
					<string>0x1b</string>
				</dict>
				<key>0x34-0x40000</key>
				<dict>
					<key>Action</key>
					<integer>11</integer>
					<key>Text</key>
					<string>0x1c</string>
				</dict>
				<key>0x35-0x40000</key>
				<dict>
					<key>Action</key>
					<integer>11</integer>
					<key>Text</key>
					<string>0x1d</string>
				</dict>
				<key>0x36-0x40000</key>
				<dict>
					<key>Action</key>
					<integer>11</integer>
					<key>Text</key>
					<string>0x1e</string>
				</dict>
				<key>0x37-0x40000</key>
				<dict>
					<key>Action</key>
					<integer>11</integer>
					<key>Text</key>
					<string>0x1f</string>
				</dict>
				<key>0x38-0x40000</key>
				<dict>
					<key>Action</key>
					<integer>11</integer>
					<key>Text</key>
					<string>0x7f</string>
				</dict>
				<key>0xf700-0x220000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[1;2A</string>
				</dict>
				<key>0xf700-0x240000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[1;5A</string>
				</dict>
				<key>0xf700-0x260000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[1;6A</string>
				</dict>
				<key>0xf700-0x280000</key>
				<dict>
					<key>Action</key>
					<integer>11</integer>
					<key>Text</key>
					<string>0x1b 0x1b 0x5b 0x41</string>
				</dict>
				<key>0xf701-0x220000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[1;2B</string>
				</dict>
				<key>0xf701-0x240000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[1;5B</string>
				</dict>
				<key>0xf701-0x260000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[1;6B</string>
				</dict>
				<key>0xf701-0x280000</key>
				<dict>
					<key>Action</key>
					<integer>11</integer>
					<key>Text</key>
					<string>0x1b 0x1b 0x5b 0x42</string>
				</dict>
				<key>0xf702-0x220000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[1;2D</string>
				</dict>
				<key>0xf702-0x240000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[1;5D</string>
				</dict>
				<key>0xf702-0x260000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[1;6D</string>
				</dict>
				<key>0xf702-0x280000</key>
				<dict>
					<key>Action</key>
					<integer>11</integer>
					<key>Text</key>
					<string>0x1b 0x1b 0x5b 0x44</string>
				</dict>
				<key>0xf703-0x220000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[1;2C</string>
				</dict>
				<key>0xf703-0x240000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[1;5C</string>
				</dict>
				<key>0xf703-0x260000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[1;6C</string>
				</dict>
				<key>0xf703-0x280000</key>
				<dict>
					<key>Action</key>
					<integer>11</integer>
					<key>Text</key>
					<string>0x1b 0x1b 0x5b 0x43</string>
				</dict>
				<key>0xf704-0x20000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[1;2P</string>
				</dict>
				<key>0xf705-0x20000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[1;2Q</string>
				</dict>
				<key>0xf706-0x20000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[1;2R</string>
				</dict>
				<key>0xf707-0x20000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[1;2S</string>
				</dict>
				<key>0xf708-0x20000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[15;2~</string>
				</dict>
				<key>0xf709-0x20000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[17;2~</string>
				</dict>
				<key>0xf70a-0x20000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[18;2~</string>
				</dict>
				<key>0xf70b-0x20000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[19;2~</string>
				</dict>
				<key>0xf70c-0x20000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[20;2~</string>
				</dict>
				<key>0xf70d-0x20000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[21;2~</string>
				</dict>
				<key>0xf70e-0x20000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[23;2~</string>
				</dict>
				<key>0xf70f-0x20000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[24;2~</string>
				</dict>
				<key>0xf729-0x20000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[1;2H</string>
				</dict>
				<key>0xf729-0x40000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[1;5H</string>
				</dict>
				<key>0xf72b-0x20000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[1;2F</string>
				</dict>
				<key>0xf72b-0x40000</key>
				<dict>
					<key>Action</key>
					<integer>10</integer>
					<key>Text</key>
					<string>[1;5F</string>
				</dict>
			</dict>
			<key>Link Color</key>
			<dict>
				<key>Alpha Component</key>
				<real>1</real>
				<key>Blue Component</key>
				<real>0.73422706127166748</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.35915294289588928</real>
				<key>Red Component</key>
				<real>0.0</real>
			</dict>
			<key>Link Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.9337158203125</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.55789834260940552</real>
				<key>Red Component</key>
				<real>0.19802422821521759</real>
			</dict>
			<key>Link Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<real>0.9337158203125</real>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.55789834260940552</real>
				<key>Red Component</key>
				<real>0.19802422821521759</real>
			</dict>
			<key>Load Shell Integration Automatically</key>
			<true/>
			<key>Minimum Contrast</key>
			<real>0.0</real>
			<key>Mouse Reporting</key>
			<true/>
			<key>Mouse Reporting allow clicks and drags</key>
			<true/>
			<key>Name</key>
			<string>Default</string>
			<key>Non Ascii Font</key>
			<string>Monaco 12</string>
			<key>Non-ASCII Anti Aliased</key>
			<true/>
			<key>Normal Font</key>
			<string>MesloLGS-NF-Regular 14</string>
			<key>Only The Default BG Color Uses Transparency</key>
			<true/>
			<key>Open Toolbelt</key>
			<false/>
			<key>Option Key Sends</key>
			<integer>0</integer>
			<key>Place Prompt at First Column</key>
			<true/>
			<key>Prevent Opening in a Tab</key>
			<false/>
			<key>Prompt Before Closing 2</key>
			<false/>
			<key>Right Option Key Sends</key>
			<integer>0</integer>
			<key>Rows</key>
			<integer>25</integer>
			<key>Screen</key>
			<integer>-1</integer>
			<key>Scrollback Lines</key>
			<integer>100000</integer>
			<key>Selected Text Color</key>
			<dict>
				<key>Blue Component</key>
				<real>0.0</real>
				<key>Green Component</key>
				<real>0.0</real>
				<key>Red Component</key>
				<real>0.0</real>
			</dict>
			<key>Selected Text Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<integer>0</integer>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<integer>0</integer>
				<key>Red Component</key>
				<integer>0</integer>
			</dict>
			<key>Selected Text Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<integer>0</integer>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<integer>0</integer>
				<key>Red Component</key>
				<integer>0</integer>
			</dict>
			<key>Selection Color</key>
			<dict>
				<key>Blue Component</key>
				<real>1</real>
				<key>Green Component</key>
				<real>0.8353000283241272</real>
				<key>Red Component</key>
				<real>0.70980000495910645</real>
			</dict>
			<key>Selection Color (Dark)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<integer>1</integer>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.84313726425170898</real>
				<key>Red Component</key>
				<real>0.70196080207824707</real>
			</dict>
			<key>Selection Color (Light)</key>
			<dict>
				<key>Alpha Component</key>
				<integer>1</integer>
				<key>Blue Component</key>
				<integer>1</integer>
				<key>Color Space</key>
				<string>sRGB</string>
				<key>Green Component</key>
				<real>0.84313726425170898</real>
				<key>Red Component</key>
				<real>0.70196080207824707</real>
			</dict>
			<key>Send Code When Idle</key>
			<false/>
			<key>Set Local Environment Vars</key>
			<integer>2</integer>
			<key>Shortcut</key>
			<string></string>
			<key>Show Mark Indicators</key>
			<false/>
			<key>Show Offscreen Command line</key>
			<false/>
			<key>Silence Bell</key>
			<true/>
			<key>Space</key>
			<integer>0</integer>
			<key>Sync Title</key>
			<false/>
			<key>Tags</key>
			<array/>
			<key>Terminal Type</key>
			<string>xterm-256color</string>
			<key>Thin Strokes</key>
			<integer>4</integer>
			<key>Title Components</key>
			<integer>258</integer>
			<key>Transparency</key>
			<real>0.080000000000000002</real>
			<key>Unicode Normalization</key>
			<integer>2</integer>
			<key>Unicode Version</key>
			<integer>9</integer>
			<key>Unlimited Scrollback</key>
			<false/>
			<key>Use Bold Font</key>
			<false/>
			<key>Use Bright Bold</key>
			<true/>
			<key>Use Cursor Guide</key>
			<false/>
			<key>Use Custom Window Title</key>
			<true/>
			<key>Use Italic Font</key>
			<true/>
			<key>Use Non-ASCII Font</key>
			<false/>
			<key>Use Separate Colors for Light and Dark Mode</key>
			<true/>
			<key>Use Underline Color</key>
			<false/>
			<key>Vertical Spacing</key>
			<real>1</real>
			<key>Visual Bell</key>
			<false/>
			<key>Window Type</key>
			<integer>0</integer>
			<key>Working Directory</key>
			<string>/Users/roger</string>
		</dict>
	</array>
	<key>NoSyncAllAppVersions</key>
	<array>
		<string>3.4.19</string>
		<string>3.5.1beta1</string>
		<string>3.5.3</string>
		<string>3.5.0beta10</string>
		<string>3.5.20240816-nightly</string>
		<string>3.5.0beta11</string>
		<string>3.5.0beta12</string>
		<string>3.4.23</string>
		<string>3.5.20230914-nightly</string>
		<string>3.4.22</string>
		<string>3.5.4</string>
		<string>3.5.2</string>
		<string>3.4.21</string>
		<string>3.5.0</string>
		<string>3.4.20</string>
	</array>
	<key>NoSyncBFPFavorites</key>
	<array>
		<string>MesloLGS NF</string>
	</array>
	<key>NoSyncBFPRecents</key>
	<array>
		<string>MesloLGS NF</string>
	</array>
	<key>NoSyncCommandHistoryHasEverBeenUsed</key>
	<true/>
	<key>NoSyncFrame_SessionsPreferences</key>
	<dict>
		<key>screenFrame</key>
		<string>{{0, 0}, {2048, 1152}}</string>
		<key>topLeft</key>
		<string>{562, 817}</string>
	</dict>
	<key>NoSyncFrame_SharedPreferences</key>
	<dict>
		<key>screenFrame</key>
		<string>{{0, 0}, {2048, 1152}}</string>
		<key>topLeft</key>
		<string>{852, 779}</string>
	</dict>
	<key>NoSyncHaveUsedCopyMode</key>
	<true/>
	<key>NoSyncIgnoreSystemWindowRestoration</key>
	<true/>
	<key>NoSyncInstallationId</key>
	<string>AE7A9138-AAE3-47C3-BF8C-9E9B90F7A7F5</string>
	<key>NoSyncLastOSVersion</key>
	<string>Version 15.0 (Build 24A5327a)</string>
	<key>NoSyncLastSystemPythonVersionRequirement</key>
	<string>1.17</string>
	<key>NoSyncLastTipTime</key>
	<real>729358401.46157598</real>
	<key>NoSyncLaunchExperienceControllerRunCount</key>
	<integer>382</integer>
	<key>NoSyncNeverAskAboutSettingAlternateMouseScroll</key>
	<true/>
	<key>NoSyncNextAnnoyanceTime</key>
	<real>740175770.28358102</real>
	<key>NoSyncOnboardingWindowHasBeenShown34</key>
	<true/>
	<key>NoSyncPermissionToShowTip</key>
	<false/>
	<key>NoSyncRecordedVariables</key>
	<dict>
		<key>0</key>
		<array>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string></string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
		</array>
		<key>1</key>
		<array>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>presentationName</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>tmuxRole</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>lastCommand</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>profileName</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>showingAlternateScreen</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>id</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>termid</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>homeDirectory</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>jobName</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>columns</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>uname</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>tab.tmuxWindowTitle</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>processTitle</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>tmuxClientName</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>hostname</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>selectionLength</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>mouseInfo</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>path</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>shell</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>triggerName</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<false/>
				<key>name</key>
				<string>parentSession</string>
				<key>nonterminalContext</key>
				<integer>1</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>terminalIconName</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>tmuxWindowPane</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>mouseReportingMode</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>name</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>tmuxStatusRight</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<false/>
				<key>name</key>
				<string>iterm2</string>
				<key>nonterminalContext</key>
				<integer>4</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>tmuxPaneTitle</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>rows</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>tmuxWindowPaneIndex</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>tty</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>autoLogId</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>badge</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>username</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>logFilename</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>effective_root_pid</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>sshIntegrationLevel</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>tab.tmuxWindowName</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<false/>
				<key>name</key>
				<string>tab</string>
				<key>nonterminalContext</key>
				<integer>2</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>tmuxStatusLeft</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>selection</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>bellCount</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>autoNameFormat</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>autoName</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>terminalWindowName</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>creationTimeString</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>commandLine</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>applicationKeypad</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>jobPid</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>pid</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
		</array>
		<key>16</key>
		<array>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>style</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>frame</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentTab.currentSession.pid</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentTab.currentSession.mouseInfo</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentTab.currentSession.termid</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentTab.currentSession.terminalWindowName</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentTab.currentSession.terminalIconName</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>isHotkeyWindow</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<false/>
				<key>name</key>
				<string>currentTab</string>
				<key>nonterminalContext</key>
				<integer>2</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentTab.currentSession.processTitle</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentTab.currentSession.lastCommand</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentTab.currentSession</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentTab.window</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>id</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentTab.currentSession.name</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>titleOverride</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>number</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentTab.currentSession.commandLine</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentTab.currentSession.effective_root_pid</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentTab.currentSession.path</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentTab.currentSession.hostname</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentTab.currentSession.tty</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentTab.currentSession.username</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<false/>
				<key>name</key>
				<string>iterm2</string>
				<key>nonterminalContext</key>
				<integer>4</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>titleOverrideFormat</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentTab.currentSession.bellCount</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentTab.currentSession.jobName</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
		</array>
		<key>2</key>
		<array>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentSession.bellCount</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentSession.terminalWindowName</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentSession.commandLine</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<false/>
				<key>name</key>
				<string>title</string>
				<key>nonterminalContext</key>
				<integer>1</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>title</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>tmuxWindowTitle</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentSession.terminalIconName</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentSession.effective_root_pid</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>tmuxWindowName</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<false/>
				<key>name</key>
				<string>window</string>
				<key>nonterminalContext</key>
				<integer>16</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentSession.tty</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentSession.jobName</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentSession.name</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentSession.processTitle</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentSession.mouseInfo</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>window</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>id</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>titleOverride</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentSession.lastCommand</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentSession.username</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentSession.termid</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<false/>
				<key>name</key>
				<string>iterm2</string>
				<key>nonterminalContext</key>
				<integer>4</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>titleOverrideFormat</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentSession.hostname</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentSession.pid</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentSession.path</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>tmuxWindow</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>currentSession</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<false/>
				<key>name</key>
				<string>currentSession</string>
				<key>nonterminalContext</key>
				<integer>1</integer>
			</dict>
		</array>
		<key>4</key>
		<array>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>pid</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>localhostName</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
			<dict>
				<key>isTerminal</key>
				<true/>
				<key>name</key>
				<string>effectiveTheme</string>
				<key>nonterminalContext</key>
				<integer>0</integer>
			</dict>
		</array>
	</dict>
	<key>NoSyncRestoreWindowsCount</key>
	<integer>0</integer>
	<key>NoSyncSaveDocumentAsPathSet_saveDocumentAs:</key>
	<true/>
	<key>NoSyncSecureCopyConnectionFailedWarning</key>
	<true/>
	<key>NoSyncSecureCopyConnectionFailedWarning_selection</key>
	<integer>0</integer>
	<key>NoSyncTipOfTheDayEligibilityBeganTime</key>
	<real>711472835.62523103</real>
	<key>NoSyncTipsToNotShow</key>
	<array>
		<string>000</string>
	</array>
	<key>NoSyncUserHasSelectedCommand</key>
	<true/>
	<key>NoSyncWindowRestoresWorkspaceAtLaunch</key>
	<false/>
	<key>OnlyWhenMoreTabs</key>
	<false/>
	<key>OpenArrangementAtStartup</key>
	<false/>
	<key>OpenBookmark</key>
	<false/>
	<key>OpenNoWindowsAtStartup</key>
	<false/>
	<key>OpenTmuxWindowsIn</key>
	<integer>0</integer>
	<key>PassOnControlClick</key>
	<false/>
	<key>PerPaneBackgroundImage</key>
	<true/>
	<key>PointerActions</key>
	<dict>
		<key>Button,1,1,,</key>
		<dict>
			<key>Action</key>
			<string>kContextMenuPointerAction</string>
		</dict>
		<key>Button,2,1,,</key>
		<dict>
			<key>Action</key>
			<string>kPasteFromClipboardPointerAction</string>
		</dict>
		<key>Gesture,ThreeFingerSwipeDown,,</key>
		<dict>
			<key>Action</key>
			<string>kPrevWindowPointerAction</string>
		</dict>
		<key>Gesture,ThreeFingerSwipeLeft,,</key>
		<dict>
			<key>Action</key>
			<string>kPrevTabPointerAction</string>
		</dict>
		<key>Gesture,ThreeFingerSwipeRight,,</key>
		<dict>
			<key>Action</key>
			<string>kNextTabPointerAction</string>
		</dict>
		<key>Gesture,ThreeFingerSwipeUp,,</key>
		<dict>
			<key>Action</key>
			<string>kNextWindowPointerAction</string>
		</dict>
	</dict>
	<key>PreventEscapeSequenceFromClearingHistory</key>
	<false/>
	<key>PromptOnQuit</key>
	<false/>
	<key>QuitWhenAllWindowsClosed</key>
	<true/>
	<key>SUAutomaticallyUpdate</key>
	<true/>
	<key>SUEnableAutomaticChecks</key>
	<true/>
	<key>SUFeedAlternateAppNameKey</key>
	<string>iTerm</string>
	<key>SUFeedURL</key>
	<string>https://iterm2.com/appcasts/final_modern.xml?shard=64</string>
	<key>SUHasLaunchedBefore</key>
	<true/>
	<key>SULastCheckTime</key>
	<date>2024-08-23T22:53:03Z</date>
	<key>SUSendProfileInfo</key>
	<false/>
	<key>SUUpdateGroupIdentifier</key>
	<integer>779871828</integer>
	<key>SUUpdateRelaunchingMarker</key>
	<false/>
	<key>Secure Input</key>
	<false/>
	<key>Selection Respects Soft Boundaries</key>
	<true/>
	<key>SeparateStatusBarsPerPane</key>
	<false/>
	<key>SeparateWindowTitlePerTab</key>
	<true/>
	<key>ShowFullScreenTabBar</key>
	<true/>
	<key>ShowMetalFPSmeter</key>
	<true/>
	<key>ShowNewOutputIndicator</key>
	<true/>
	<key>ShowPaneTitles</key>
	<true/>
	<key>SmartPlacement</key>
	<true/>
	<key>SoundForEsc</key>
	<false/>
	<key>SplitPaneDimmingAmount</key>
	<real>0.20025978458737859</real>
	<key>StretchTabsToFillBar</key>
	<true/>
	<key>TabStyleWithAutomaticOption</key>
	<integer>1</integer>
	<key>TabsHaveCloseButton</key>
	<true/>
	<key>TmuxUsesDedicatedProfile</key>
	<false/>
	<key>TripleClickSelectsFullWrappedLines</key>
	<false/>
	<key>UKCrashReporterLastCrashReportDate</key>
	<real>1714256640</real>
	<key>UseBorder</key>
	<false/>
	<key>UseCustomScriptsFolder</key>
	<false/>
	<key>UseLionStyleFullscreen</key>
	<true/>
	<key>UseTmuxStatusBar</key>
	<false/>
	<key>VisualIndicatorForEsc</key>
	<false/>
	<key>Window Arrangements</key>
	<dict/>
	<key>WindowNumber</key>
	<true/>
	<key>findMode_iTerm</key>
	<integer>0</integer>
	<key>iTerm Version</key>
	<string>3.5.4</string>
	<key>kCPKSelectionViewPreferredModeKey</key>
	<integer>0</integer>
	<key>kCPKSelectionViewShowHSBTextFieldsKey</key>
	<false/>
</dict>
</plist>
EOF
}

function setup_vim () {
  cat <<'EOF' > ~/.vimrc
set history=500
set autoread
au FocusGained,BufEnter * checktime
let mapleader = ","
nmap <leader>w :w!<cr>

command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

set so=7
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
set wildmenu
set wildignore=*.o,*~,*.pyc

if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

set ruler
set cmdheight=1
set hid
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set ignorecase
set smartcase
set hlsearch
set incsearch
set lazyredraw
set magic
set showmatch
set mat=2
set noerrorbells
set novisualbell
set t_vb=
set tm=500

if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif
syntax enable

if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

try
    colorscheme desert
catch
endtry

set background=dark

if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

set encoding=utf8
set ffs=unix,dos,mac
set nobackup
set nowb
set noswapfile
set backupcopy=no
set expandtab
set lbr
set tw=500
set wrap "Wrap lines
set nopaste

set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent
set bg=dark
set nowrap

setlocal noautoindent
setlocal nocindent
setlocal nosmartindent
setlocal indentexpr=
setl noai nocin nosi inde=

vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>
map <space> /
map <C-space> ?
map <silent> <leader><cr> :noh<cr>
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
map <leader>bd :Bclose<cr>:tabclose<cr>gT
map <leader>ba :bufdo bd<cr>
map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext

let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/
map <leader>cd :cd %:p:h<cr>:pwd<cr>

try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
set laststatus=2
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c
map 0 ^
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z
if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif
map <leader>ss :setlocal spell!<cr>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm
map <leader>q :e ~/buffer<cr>
map <leader>x :e ~/buffer.md<cr>
map <leader>pp :setlocal paste!<cr>

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

imap <C-e> <End>
imap <C-a> <Home>

" autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" set formatoptions-=c formatoptions-=r formatoptions-=o
EOF
sudo cp ~/.vimrc /var/root/
}

function setup_zsh() {
  echo "setup zsh..."
  export ZSH="$HOME/.oh-my-zsh"
  export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

  [ -e $HOME/.oh-my-zsh_old ] && rm -rf $HOME/.oh-my-zsh_old
  [ -e $HOME/.zshrc.bak ] && rm -f $HOME/.zshrc.bak
  [ -e $HOME/.p10k.zsh.bak ] && rm -f $HOME/.p10k.zsh.bak

  [ -e $HOME/.oh-my-zsh ] && mv $HOME/.oh-my-zsh $HOME/.oh-my-zsh_old
  [ -f $HOME/.zshrc ] && mv $HOME/.zshrc $HOME/.zshrc.bak
  [ -f $HOME/.p10k.zsh ] && mv $HOME/.p10k.zsh $HOME/.p10k.zsh.bak

  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  if [ ! -d "${ZSH_CUSTOM}/themes/powerlevel10k" ]; then
    git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k
  fi

  ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
  if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
  fi

  if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
  fi

  if ! grep -q "zsh-syntax-highlighting" ~/.zshrc; then
    sed -i.bak '/^plugins=/ s/)$/ zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc
  fi

  cat <<'EOF' > ~/.zshrc
autoload -Uz compinit && compinit
setopt nocorrectall
setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt SHARE_HISTORY
setopt AUTO_CD
unsetopt EQUALS

HISTFILE=~/.zhistory
SAVEHIST=10000
HISTSIZE=10000

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
zstyle ':omz:update' frequency 13

ENABLE_CORRECTION="false"
DISABLE_MAGIC_FUNCTIONS="true"

HIST_STAMPS="mm/dd/yyyy"

plugins=(
git
zsh-syntax-highlighting
zsh-autosuggestions
)

alias l='ls -lhtr --color'
alias ll='ls -lh --color'
alias ls='ls --color '
alias lt='ls -lhtr --color'
alias la='ls -lAhtr --color'

alias scp='scp -C'
alias wget="wget --no-check-certificate"
alias extip='dig +time=1 +short @resolver1.opendns.com myip.opendns.com 2>/dev/null || curl ipinfo.io/ip'
alias sid='echo $SessionID'

alias ipython='ipython --no-confirm-exit'
alias venv='pyenv local'
alias py='python'
alias brew-fix='brew tap --repair; brew cleanup; brew update-reset'
alias brewski='brew update && brew upgrade; brew cleanup --prune=30; brew doctor'
alias vms='multipass shell primary'
alias sudo='sudo '
alias nc='/usr/bin/nc'
alias python=python3
alias pip='pip3'
alias podman="/usr/local/bin/podman"

alias tar=gtar
alias indent=gindent
alias sed=gsed
alias awk=gawk
alias which=gwhich
alias grep='/opt/homebrew/bin/ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias egrep='/opt/homebrew/bin/ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'

# kubernetes completions
# source <(kubectl completion zsh)

export PATH=/opt/homebrew/bin:/opt/homebrew/opt/curl/bin:/usr/local/bin:/usr/local/sbin:$PATH

export PYENV_ROOT="$HOME/.pyenv"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"
alias venv='pyenv local'

MYIPS_ONLY_IPV4=1

function myips() {
	SHOW_IPV6=0
  if [[ "$1" == "--ipv6" ]] || [[ "$1" == "-6" ]]; then
		SHOW_IPV6=1
	fi

  for iface in $(ifconfig -l); do
		[[ $iface == "lo"* ]] && continue

    ipv4=$(ifconfig "$iface" | grep 'inet ' | awk '{print $2}')
  
    if [[ -n $ipv4 ]]; then
      echo "$iface (IPv4): $ipv4"
    fi
  
		if [[ $MYIPS_ONLY_IPV4 -eq 1 ]] && [[ $SHOW_IPV6 -eq 0 ]]; then
			continue
		fi

		ipv6=$(ifconfig "$iface" | grep 'inet6 ' | awk '{printf "%s ", $2}')  
    if [[ -n $ipv6 ]]; then
      echo "$iface (IPv6): ${ipv6% }"
    fi
  done
  
  echo "public ip: $(extip)"
}

source $ZSH/oh-my-zsh.sh
export LANG=en_US.UTF-8
export EDITOR='vim'

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

for file in ~/.dev-setup/*.zsh; do
	[[ -e $file ]] || continue
	source $file
done
EOF
}

function setup_p10k() {
  cat <<'EOF' > ~/.p10k.zsh
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
emulate -L zsh -o extended_glob

# Unset all configuration options. This allows you to apply configuration changes without
# restarting zsh. Edit ~/.p10k.zsh and type `source ~/.p10k.zsh`.
unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

# Zsh >= 5.1 is required.
[[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

# The list of segments shown on the left. Fill it with the most important segments.
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
os_icon                 # os identifier
dir                     # current directory
vcs                     # git status
prompt_char             # prompt symbol
)

# The list of segments shown on the right. Fill it with less important segments.
# Right prompt on the last prompt line (where you are typing your commands) gets
# automatically hidden when the input line reaches it. Right prompt above the
# last prompt line gets hidden if it would overlap with left prompt.
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
status                  # exit code of the last command
command_execution_time  # duration of the last command
background_jobs         # presence of background jobs
direnv                  # direnv status (https://direnv.net/)
asdf                    # asdf version manager (https://github.com/asdf-vm/asdf)
virtualenv              # python virtual environment (https://docs.python.org/3/library/venv.html)
anaconda                # conda environment (https://conda.io/)
pyenv                   # python environment (https://github.com/pyenv/pyenv)
goenv                   # go environment (https://github.com/syndbg/goenv)
nodenv                  # node.js version from nodenv (https://github.com/nodenv/nodenv)
nvm                     # node.js version from nvm (https://github.com/nvm-sh/nvm)
nodeenv                 # node.js environment (https://github.com/ekalinin/nodeenv)
# node_version          # node.js version
# go_version            # go version (https://golang.org)
# rust_version          # rustc version (https://www.rust-lang.org)
# dotnet_version        # .NET version (https://dotnet.microsoft.com)
# php_version           # php version (https://www.php.net/)
# laravel_version       # laravel php framework version (https://laravel.com/)
# java_version          # java version (https://www.java.com/)
# package               # name@version from package.json (https://docs.npmjs.com/files/package.json)
rbenv                   # ruby version from rbenv (https://github.com/rbenv/rbenv)
rvm                     # ruby version from rvm (https://rvm.io)
fvm                     # flutter version management (https://github.com/leoafarias/fvm)
luaenv                  # lua version from luaenv (https://github.com/cehoffman/luaenv)
jenv                    # java version from jenv (https://github.com/jenv/jenv)
plenv                   # perl version from plenv (https://github.com/tokuhirom/plenv)
perlbrew                # perl version from perlbrew (https://github.com/gugod/App-perlbrew)
phpenv                  # php version from phpenv (https://github.com/phpenv/phpenv)
scalaenv                # scala version from scalaenv (https://github.com/scalaenv/scalaenv)
haskell_stack           # haskell version from stack (https://haskellstack.org/)
kubecontext             # current kubernetes context (https://kubernetes.io/)
terraform               # terraform workspace (https://www.terraform.io)
# terraform_version     # terraform version (https://www.terraform.io)
aws                     # aws profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
aws_eb_env              # aws elastic beanstalk environment (https://aws.amazon.com/elasticbeanstalk/)
azure                   # azure account name (https://docs.microsoft.com/en-us/cli/azure)
gcloud                  # google cloud cli account and project (https://cloud.google.com/)
google_app_cred         # google application credentials (https://cloud.google.com/docs/authentication/production)
toolbox                 # toolbox name (https://github.com/containers/toolbox)
context                 # user@hostname
nordvpn                 # nordvpn connection status, linux only (https://nordvpn.com/)
ranger                  # ranger shell (https://github.com/ranger/ranger)
yazi                    # yazi shell (https://github.com/sxyazi/yazi)
nnn                     # nnn shell (https://github.com/jarun/nnn)
lf                      # lf shell (https://github.com/gokcehan/lf)
xplr                    # xplr shell (https://github.com/sayanarijit/xplr)
vim_shell               # vim shell indicator (:sh)
midnight_commander      # midnight commander shell (https://midnight-commander.org/)
nix_shell               # nix shell (https://nixos.org/nixos/nix-pills/developing-with-nix-shell.html)
chezmoi_shell           # chezmoi shell (https://www.chezmoi.io/)
# vpn_ip                # virtual private network indicator
# load                  # CPU load
# disk_usage            # disk usage
# ram                   # free RAM
# swap                  # used swap
todo                    # todo items (https://github.com/todotxt/todo.txt-cli)
timewarrior             # timewarrior tracking status (https://timewarrior.net/)
taskwarrior             # taskwarrior task count (https://taskwarrior.org/)
per_directory_history   # Oh My Zsh per-directory-history local/global indicator
# cpu_arch              # CPU architecture
time                    # current time
# ip                    # ip address and bandwidth usage for a specified network interface
# public_ip             # public IP address
# proxy                 # system-wide http/https/ftp proxy
# battery               # internal battery
# wifi                  # wifi speed
# example               # example user-defined segment (see prompt_example function below)
)

# Defines character set used by powerlevel10k. It's best to let `p10k configure` set it for you.
typeset -g POWERLEVEL9K_MODE=nerdfont-v3
# When set to `moderate`, some icons will have an extra space after them. This is meant to avoid
# icon overlap when using non-monospace fonts. When set to `none`, spaces are not added.
typeset -g POWERLEVEL9K_ICON_PADDING=none

# Basic style options that define the overall look of your prompt. You probably don't want to
# change them.
typeset -g POWERLEVEL9K_BACKGROUND=                            # transparent background
typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=  # no surrounding whitespace
typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '  # separate segments with a space
typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=        # no end-of-line symbol

# When set to true, icons appear before content on both sides of the prompt. When set
# to false, icons go after content. If empty or not set, icons go before content in the left
# prompt and after content in the right prompt.
#
# You can also override it for a specific segment:
#
#   POWERLEVEL9K_STATUS_ICON_BEFORE_CONTENT=false
#
# Or for a specific segment in specific state:
#
#   POWERLEVEL9K_DIR_NOT_WRITABLE_ICON_BEFORE_CONTENT=false
typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=true

# Add an empty line before each prompt.
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

# Connect left prompt lines with these symbols.
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=
# Connect right prompt lines with these symbols.
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX=
typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX=
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX=

# The left end of left prompt.
typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
# The right end of right prompt.
typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=

# Ruler, a.k.a. the horizontal line before each prompt. If you set it to true, you'll
# probably want to set POWERLEVEL9K_PROMPT_ADD_NEWLINE=false above and
# POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' ' below.
typeset -g POWERLEVEL9K_SHOW_RULER=false
typeset -g POWERLEVEL9K_RULER_CHAR='─'        # reasonable alternative: '·'
typeset -g POWERLEVEL9K_RULER_FOREGROUND=242

# Filler between left and right prompt on the first prompt line. You can set it to '·' or '─'
# to make it easier to see the alignment between left and right prompt and to separate prompt
# from command output. It serves the same purpose as ruler (see above) without increasing
# the number of prompt lines. You'll probably want to set POWERLEVEL9K_SHOW_RULER=false
# if using this. You might also like POWERLEVEL9K_PROMPT_ADD_NEWLINE=false for more compact
# prompt.
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '
if [[ $POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR != ' ' ]]; then
# The color of the filler.
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=242
# Add a space between the end of left prompt and the filler.
typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=' '
# Add a space between the filler and the start of right prompt.
typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=' '
# Start filler from the edge of the screen if there are no left segments on the first line.
typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_FIRST_SEGMENT_END_SYMBOL='%{%}'
# End filler on the edge of the screen if there are no right segments on the first line.
typeset -g POWERLEVEL9K_EMPTY_LINE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='%{%}'
fi

#################################[ os_icon: os identifier ]##################################
# OS identifier color.
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=
# Custom icon.
# typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION='⭐'

################################[ prompt_char: prompt symbol ]################################
# Green prompt symbol if the last command succeeded.
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=76
# Red prompt symbol if the last command failed.
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=196
# Default prompt symbol.
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
# Prompt symbol in command vi mode.
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
# Prompt symbol in visual vi mode.
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
# Prompt symbol in overwrite vi mode.
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
# No line terminator if prompt_char is the last segment.
typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
# No line introducer if prompt_char is the first segment.
typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=

##################################[ dir: current directory ]##################################
# Default current directory color.
typeset -g POWERLEVEL9K_DIR_FOREGROUND=31
# If directory is too long, shorten some of its segments to the shortest possible unique
# prefix. The shortened directory can be tab-completed to the original.
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
# Replace removed segment suffixes with this symbol.
typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
# Color of the shortened directory segments.
typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=103
# Color of the anchor directory segments. Anchor segments are never shortened. The first
# segment is always an anchor.
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=39
# Display anchor directory segments in bold.
typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
# Don't shorten directories that contain any of these files. They are anchors.
local anchor_files=(
.bzr
.citc
.git
.hg
.node-version
.python-version
.go-version
.ruby-version
.lua-version
.java-version
.perl-version
.php-version
.tool-versions
.shorten_folder_marker
.svn
.terraform
CVS
Cargo.toml
composer.json
go.mod
package.json
stack.yaml
)
typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER="(${(j:|:)anchor_files})"
# If set to "first" ("last"), remove everything before the first (last) subdirectory that contains
# files matching $POWERLEVEL9K_SHORTEN_FOLDER_MARKER. For example, when the current directory is
# /foo/bar/git_repo/nested_git_repo/baz, prompt will display git_repo/nested_git_repo/baz (first)
# or nested_git_repo/baz (last). This assumes that git_repo and nested_git_repo contain markers
# and other directories don't.
#
# Optionally, "first" and "last" can be followed by ":<offset>" where <offset> is an integer.
# This moves the truncation point to the right (positive offset) or to the left (negative offset)
# relative to the marker. Plain "first" and "last" are equivalent to "first:0" and "last:0"
# respectively.
typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=false
# Don't shorten this many last directory segments. They are anchors.
typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
# Shorten directory if it's longer than this even if there is space for it. The value can
# be either absolute (e.g., '80') or a percentage of terminal width (e.g, '50%'). If empty,
# directory will be shortened only when prompt doesn't fit or when other parameters demand it
# (see POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS and POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT below).
# If set to `0`, directory will always be shortened to its minimum length.
typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80
# When `dir` segment is on the last prompt line, try to shorten it enough to leave at least this
# many columns for typing commands.
typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
# When `dir` segment is on the last prompt line, try to shorten it enough to leave at least
# COLUMNS * POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT * 0.01 columns for typing commands.
typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=50
# If set to true, embed a hyperlink into the directory. Useful for quickly
# opening a directory in the file manager simply by clicking the link.
# Can also be handy when the directory is shortened, as it allows you to see
# the full directory that was used in previous commands.
typeset -g POWERLEVEL9K_DIR_HYPERLINK=false

# Enable special styling for non-writable and non-existent directories. See POWERLEVEL9K_LOCK_ICON
# and POWERLEVEL9K_DIR_CLASSES below.
typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3

# The default icon shown next to non-writable and non-existent directories when
# POWERLEVEL9K_DIR_SHOW_WRITABLE is set to v3.
# typeset -g POWERLEVEL9K_LOCK_ICON='⭐'

# POWERLEVEL9K_DIR_CLASSES allows you to specify custom icons and colors for different
# directories. It must be an array with 3 * N elements. Each triplet consists of:
#
#   1. A pattern against which the current directory ($PWD) is matched. Matching is done with
#      extended_glob option enabled.
#   2. Directory class for the purpose of styling.
#   3. An empty string.
#
# Triplets are tried in order. The first triplet whose pattern matches $PWD wins.
#
# If POWERLEVEL9K_DIR_SHOW_WRITABLE is set to v3, non-writable and non-existent directories
# acquire class suffix _NOT_WRITABLE and NON_EXISTENT respectively.
#
# For example, given these settings:
#
#   typeset -g POWERLEVEL9K_DIR_CLASSES=(
#     '~/work(|/*)'  WORK     ''
#     '~(|/*)'       HOME     ''
#     '*'            DEFAULT  '')
#
# Whenever the current directory is ~/work or a subdirectory of ~/work, it gets styled with one
# of the following classes depending on its writability and existence: WORK, WORK_NOT_WRITABLE or
# WORK_NON_EXISTENT.
#
# Simply assigning classes to directories doesn't have any visible effects. It merely gives you an
# option to define custom colors and icons for different directory classes.
#
#   # Styling for WORK.
#   typeset -g POWERLEVEL9K_DIR_WORK_VISUAL_IDENTIFIER_EXPANSION='⭐'
#   typeset -g POWERLEVEL9K_DIR_WORK_FOREGROUND=31
#   typeset -g POWERLEVEL9K_DIR_WORK_SHORTENED_FOREGROUND=103
#   typeset -g POWERLEVEL9K_DIR_WORK_ANCHOR_FOREGROUND=39
#
#   # Styling for WORK_NOT_WRITABLE.
#   typeset -g POWERLEVEL9K_DIR_WORK_NOT_WRITABLE_VISUAL_IDENTIFIER_EXPANSION='⭐'
#   typeset -g POWERLEVEL9K_DIR_WORK_NOT_WRITABLE_FOREGROUND=31
#   typeset -g POWERLEVEL9K_DIR_WORK_NOT_WRITABLE_SHORTENED_FOREGROUND=103
#   typeset -g POWERLEVEL9K_DIR_WORK_NOT_WRITABLE_ANCHOR_FOREGROUND=39
#
#   # Styling for WORK_NON_EXISTENT.
#   typeset -g POWERLEVEL9K_DIR_WORK_NON_EXISTENT_VISUAL_IDENTIFIER_EXPANSION='⭐'
#   typeset -g POWERLEVEL9K_DIR_WORK_NON_EXISTENT_FOREGROUND=31
#   typeset -g POWERLEVEL9K_DIR_WORK_NON_EXISTENT_SHORTENED_FOREGROUND=103
#   typeset -g POWERLEVEL9K_DIR_WORK_NON_EXISTENT_ANCHOR_FOREGROUND=39
#
# If a styling parameter isn't explicitly defined for some class, it falls back to the classless
# parameter. For example, if POWERLEVEL9K_DIR_WORK_NOT_WRITABLE_FOREGROUND is not set, it falls
# back to POWERLEVEL9K_DIR_FOREGROUND.
#
# typeset -g POWERLEVEL9K_DIR_CLASSES=()

# Custom prefix.
# typeset -g POWERLEVEL9K_DIR_PREFIX='%fin '

#####################################[ vcs: git status ]######################################
# Branch icon. Set this parameter to '\UE0A0 ' for the popular Powerline branch icon.
typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\uF126 '

# Untracked files icon. It's really a question mark, your font isn't broken.
# Change the value of this parameter to show a different icon.
typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

# Formatter for Git status.
#
# Example output: master wip ⇣42⇡42 *42 merge ~42 +42 !42 ?42.
#
# You can edit the function to customize how Git status looks.
#
# VCS_STATUS_* parameters are set by gitstatus plugin. See reference:
# https://github.com/romkatv/gitstatus/blob/master/gitstatus.plugin.zsh.
function my_git_formatter() {
emulate -L zsh

if [[ -n $P9K_CONTENT ]]; then
    # If P9K_CONTENT is not empty, use it. It's either "loading" or from vcs_info (not from
    # gitstatus plugin). VCS_STATUS_* parameters are not available in this case.
    typeset -g my_git_format=$P9K_CONTENT
    return
fi

if (( $1 )); then
    # Styling for up-to-date Git status.
    local       meta='%f'     # default foreground
    local      clean='%76F'   # green foreground
    local   modified='%178F'  # yellow foreground
    local  untracked='%39F'   # blue foreground
    local conflicted='%196F'  # red foreground
else
    # Styling for incomplete and stale Git status.
    local       meta='%244F'  # grey foreground
    local      clean='%244F'  # grey foreground
    local   modified='%244F'  # grey foreground
    local  untracked='%244F'  # grey foreground
    local conflicted='%244F'  # grey foreground
fi

local res

if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
    local branch=${(V)VCS_STATUS_LOCAL_BRANCH}
    # If local branch name is at most 32 characters long, show it in full.
    # Otherwise show the first 12 … the last 12.
    # Tip: To always show local branch name in full without truncation, delete the next line.
    (( $#branch > 32 )) && branch[13,-13]="…"  # <-- this line
    res+="${clean}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${branch//\%/%%}"
fi

if [[ -n $VCS_STATUS_TAG
        # Show tag only if not on a branch.
        # Tip: To always show tag, delete the next line.
        && -z $VCS_STATUS_LOCAL_BRANCH  # <-- this line
    ]]; then
    local tag=${(V)VCS_STATUS_TAG}
    # If tag name is at most 32 characters long, show it in full.
    # Otherwise show the first 12 … the last 12.
    # Tip: To always show tag name in full without truncation, delete the next line.
    (( $#tag > 32 )) && tag[13,-13]="…"  # <-- this line
    res+="${meta}#${clean}${tag//\%/%%}"
fi

# Display the current Git commit if there is no branch and no tag.
# Tip: To always display the current Git commit, delete the next line.
[[ -z $VCS_STATUS_LOCAL_BRANCH && -z $VCS_STATUS_TAG ]] &&  # <-- this line
    res+="${meta}@${clean}${VCS_STATUS_COMMIT[1,8]}"

# Show tracking branch name if it differs from local branch.
if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]; then
    res+="${meta}:${clean}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}"
fi

# Display "wip" if the latest commit's summary contains "wip" or "WIP".
if [[ $VCS_STATUS_COMMIT_SUMMARY == (|*[^[:alnum:]])(wip|WIP)(|[^[:alnum:]]*) ]]; then
    res+=" ${modified}wip"
fi

if (( VCS_STATUS_COMMITS_AHEAD || VCS_STATUS_COMMITS_BEHIND )); then
    # ⇣42 if behind the remote.
    (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}"
    # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
    (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" "
    (( VCS_STATUS_COMMITS_AHEAD  )) && res+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"
elif [[ -n $VCS_STATUS_REMOTE_BRANCH ]]; then
    # Tip: Uncomment the next line to display '=' if up to date with the remote.
    # res+=" ${clean}="
fi

# ⇠42 if behind the push remote.
(( VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" ${clean}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
(( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" "
# ⇢42 if ahead of the push remote; no leading space if also behind: ⇠42⇢42.
(( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && res+="${clean}⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"
# *42 if have stashes.
(( VCS_STATUS_STASHES        )) && res+=" ${clean}*${VCS_STATUS_STASHES}"
# 'merge' if the repo is in an unusual state.
[[ -n $VCS_STATUS_ACTION     ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}"
# ~42 if have merge conflicts.
(( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}"
# +42 if have staged changes.
(( VCS_STATUS_NUM_STAGED     )) && res+=" ${modified}+${VCS_STATUS_NUM_STAGED}"
# !42 if have unstaged changes.
(( VCS_STATUS_NUM_UNSTAGED   )) && res+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}"
# ?42 if have untracked files. It's really a question mark, your font isn't broken.
# See POWERLEVEL9K_VCS_UNTRACKED_ICON above if you want to use a different icon.
# Remove the next line if you don't want to see untracked files at all.
(( VCS_STATUS_NUM_UNTRACKED  )) && res+=" ${untracked}${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}${VCS_STATUS_NUM_UNTRACKED}"
# "─" if the number of unstaged files is unknown. This can happen due to
# POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY (see below) being set to a non-negative number lower
# than the number of files in the Git index, or due to bash.showDirtyState being set to false
# in the repository config. The number of staged and untracked files may also be unknown
# in this case.
(( VCS_STATUS_HAS_UNSTAGED == -1 )) && res+=" ${modified}─"

typeset -g my_git_format=$res
}
functions -M my_git_formatter 2>/dev/null

# Don't count the number of unstaged, untracked and conflicted files in Git repositories with
# more than this many files in the index. Negative value means infinity.
#
# If you are working in Git repositories with tens of millions of files and seeing performance
# sagging, try setting POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY to a number lower than the output
# of `git ls-files | wc -l`. Alternatively, add `bash.showDirtyState = false` to the repository's
# config: `git config bash.showDirtyState false`.
typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1

# Don't show Git status in prompt for repositories whose workdir matches this pattern.
# For example, if set to '~', the Git repository at $HOME/.git will be ignored.
# Multiple patterns can be combined with '|': '~(|/foo)|/bar/baz/*'.
typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'

# Disable the default Git status formatting.
typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
# Install our own Git status formatter.
typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter(1)))+${my_git_format}}'
typeset -g POWERLEVEL9K_VCS_LOADING_CONTENT_EXPANSION='${$((my_git_formatter(0)))+${my_git_format}}'
# Enable counters for staged, unstaged, etc.
typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1

# Icon color.
typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR=76
typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR=244
# Custom icon.
# typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION='⭐'
# Custom prefix.
# typeset -g POWERLEVEL9K_VCS_PREFIX='%fon '

# Show status of repositories of these types. You can add svn and/or hg if you are
# using them. If you do, your prompt may become slow even when your current directory
# isn't in an svn or hg repository.
typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)

# These settings are used for repositories other than Git or when gitstatusd fails and
# Powerlevel10k has to fall back to using vcs_info.
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=76
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=76
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=178

##########################[ status: exit code of the last command ]###########################
# Enable OK_PIPE, ERROR_PIPE and ERROR_SIGNAL status states to allow us to enable, disable and
# style them independently from the regular OK and ERROR state.
typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true

# Status on success. No content, just an icon. No need to show it if prompt_char is enabled as
# it will signify success by turning green.
typeset -g POWERLEVEL9K_STATUS_OK=false
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=70
typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='✔'

# Status when some part of a pipe command fails but the overall exit status is zero. It may look
# like this: 1|0.
typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND=70
typeset -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION='✔'

# Status when it's just an error code (e.g., '1'). No need to show it if prompt_char is enabled as
# it will signify error by turning red.
typeset -g POWERLEVEL9K_STATUS_ERROR=false
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=160
typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'

# Status when the last command was terminated by a signal.
typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=160
# Use terse signal names: "INT" instead of "SIGINT(2)".
typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false
typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION='✘'

# Status when some part of a pipe command fails and the overall exit status is also non-zero.
# It may look like this: 1|0.
typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=160
typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION='✘'

###################[ command_execution_time: duration of the last command ]###################
# Show duration of the last command if takes at least this many seconds.
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
# Show this many fractional digits. Zero means round to seconds.
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
# Execution time color.
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=101
# Duration format: 1d 2h 3m 4s.
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
# Custom icon.
# typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION='⭐'
# Custom prefix.
# typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX='%ftook '

#######################[ background_jobs: presence of background jobs ]#######################
# Don't show the number of background jobs.
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
# Background jobs color.
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=70
# Custom icon.
# typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION='⭐'

#######################[ direnv: direnv status (https://direnv.net/) ]########################
# Direnv color.
typeset -g POWERLEVEL9K_DIRENV_FOREGROUND=178
# Custom icon.
# typeset -g POWERLEVEL9K_DIRENV_VISUAL_IDENTIFIER_EXPANSION='⭐'

###############[ asdf: asdf version manager (https://github.com/asdf-vm/asdf) ]###############
# Default asdf color. Only used to display tools for which there is no color override (see below).
# Tip:  Override this parameter for ${TOOL} with POWERLEVEL9K_ASDF_${TOOL}_FOREGROUND.
typeset -g POWERLEVEL9K_ASDF_FOREGROUND=66

# There are four parameters that can be used to hide asdf tools. Each parameter describes
# conditions under which a tool gets hidden. Parameters can hide tools but not unhide them. If at
# least one parameter decides to hide a tool, that tool gets hidden. If no parameter decides to
# hide a tool, it gets shown.
#
# Special note on the difference between POWERLEVEL9K_ASDF_SOURCES and
# POWERLEVEL9K_ASDF_PROMPT_ALWAYS_SHOW. Consider the effect of the following commands:
#
#   asdf local  python 3.8.1
#   asdf global python 3.8.1
#
# After running both commands the current python version is 3.8.1 and its source is "local" as
# it takes precedence over "global". If POWERLEVEL9K_ASDF_PROMPT_ALWAYS_SHOW is set to false,
# it'll hide python version in this case because 3.8.1 is the same as the global version.
# POWERLEVEL9K_ASDF_SOURCES will hide python version only if the value of this parameter doesn't
# contain "local".

# Hide tool versions that don't come from one of these sources.
#
# Available sources:
#
# - shell   `asdf current` says "set by ASDF_${TOOL}_VERSION environment variable"
# - local   `asdf current` says "set by /some/not/home/directory/file"
# - global  `asdf current` says "set by /home/username/file"
#
# Note: If this parameter is set to (shell local global), it won't hide tools.
# Tip:  Override this parameter for ${TOOL} with POWERLEVEL9K_ASDF_${TOOL}_SOURCES.
typeset -g POWERLEVEL9K_ASDF_SOURCES=(shell local global)

# If set to false, hide tool versions that are the same as global.
#
# Note: The name of this parameter doesn't reflect its meaning at all.
# Note: If this parameter is set to true, it won't hide tools.
# Tip:  Override this parameter for ${TOOL} with POWERLEVEL9K_ASDF_${TOOL}_PROMPT_ALWAYS_SHOW.
typeset -g POWERLEVEL9K_ASDF_PROMPT_ALWAYS_SHOW=false

# If set to false, hide tool versions that are equal to "system".
#
# Note: If this parameter is set to true, it won't hide tools.
# Tip: Override this parameter for ${TOOL} with POWERLEVEL9K_ASDF_${TOOL}_SHOW_SYSTEM.
typeset -g POWERLEVEL9K_ASDF_SHOW_SYSTEM=true

# If set to non-empty value, hide tools unless there is a file matching the specified file pattern
# in the current directory, or its parent directory, or its grandparent directory, and so on.
#
# Note: If this parameter is set to empty value, it won't hide tools.
# Note: SHOW_ON_UPGLOB isn't specific to asdf. It works with all prompt segments.
# Tip: Override this parameter for ${TOOL} with POWERLEVEL9K_ASDF_${TOOL}_SHOW_ON_UPGLOB.
#
# Example: Hide nodejs version when there is no package.json and no *.js files in the current
# directory, in `..`, in `../..` and so on.
#
#   typeset -g POWERLEVEL9K_ASDF_NODEJS_SHOW_ON_UPGLOB='*.js|package.json'
typeset -g POWERLEVEL9K_ASDF_SHOW_ON_UPGLOB=

# Ruby version from asdf.
typeset -g POWERLEVEL9K_ASDF_RUBY_FOREGROUND=168
# typeset -g POWERLEVEL9K_ASDF_RUBY_VISUAL_IDENTIFIER_EXPANSION='⭐'
# typeset -g POWERLEVEL9K_ASDF_RUBY_SHOW_ON_UPGLOB='*.foo|*.bar'

# Python version from asdf.
typeset -g POWERLEVEL9K_ASDF_PYTHON_FOREGROUND=37
# typeset -g POWERLEVEL9K_ASDF_PYTHON_VISUAL_IDENTIFIER_EXPANSION='⭐'
# typeset -g POWERLEVEL9K_ASDF_PYTHON_SHOW_ON_UPGLOB='*.foo|*.bar'

# Go version from asdf.
typeset -g POWERLEVEL9K_ASDF_GOLANG_FOREGROUND=37
# typeset -g POWERLEVEL9K_ASDF_GOLANG_VISUAL_IDENTIFIER_EXPANSION='⭐'
# typeset -g POWERLEVEL9K_ASDF_GOLANG_SHOW_ON_UPGLOB='*.foo|*.bar'

# Node.js version from asdf.
typeset -g POWERLEVEL9K_ASDF_NODEJS_FOREGROUND=70
# typeset -g POWERLEVEL9K_ASDF_NODEJS_VISUAL_IDENTIFIER_EXPANSION='⭐'
# typeset -g POWERLEVEL9K_ASDF_NODEJS_SHOW_ON_UPGLOB='*.foo|*.bar'

# Rust version from asdf.
typeset -g POWERLEVEL9K_ASDF_RUST_FOREGROUND=37
# typeset -g POWERLEVEL9K_ASDF_RUST_VISUAL_IDENTIFIER_EXPANSION='⭐'
# typeset -g POWERLEVEL9K_ASDF_RUST_SHOW_ON_UPGLOB='*.foo|*.bar'

# .NET Core version from asdf.
typeset -g POWERLEVEL9K_ASDF_DOTNET_CORE_FOREGROUND=134
# typeset -g POWERLEVEL9K_ASDF_DOTNET_CORE_VISUAL_IDENTIFIER_EXPANSION='⭐'
# typeset -g POWERLEVEL9K_ASDF_DOTNET_SHOW_ON_UPGLOB='*.foo|*.bar'

# Flutter version from asdf.
typeset -g POWERLEVEL9K_ASDF_FLUTTER_FOREGROUND=38
# typeset -g POWERLEVEL9K_ASDF_FLUTTER_VISUAL_IDENTIFIER_EXPANSION='⭐'
# typeset -g POWERLEVEL9K_ASDF_FLUTTER_SHOW_ON_UPGLOB='*.foo|*.bar'

# Lua version from asdf.
typeset -g POWERLEVEL9K_ASDF_LUA_FOREGROUND=32
# typeset -g POWERLEVEL9K_ASDF_LUA_VISUAL_IDENTIFIER_EXPANSION='⭐'
# typeset -g POWERLEVEL9K_ASDF_LUA_SHOW_ON_UPGLOB='*.foo|*.bar'

# Java version from asdf.
typeset -g POWERLEVEL9K_ASDF_JAVA_FOREGROUND=32
# typeset -g POWERLEVEL9K_ASDF_JAVA_VISUAL_IDENTIFIER_EXPANSION='⭐'
# typeset -g POWERLEVEL9K_ASDF_JAVA_SHOW_ON_UPGLOB='*.foo|*.bar'

# Perl version from asdf.
typeset -g POWERLEVEL9K_ASDF_PERL_FOREGROUND=67
# typeset -g POWERLEVEL9K_ASDF_PERL_VISUAL_IDENTIFIER_EXPANSION='⭐'
# typeset -g POWERLEVEL9K_ASDF_PERL_SHOW_ON_UPGLOB='*.foo|*.bar'

# Erlang version from asdf.
typeset -g POWERLEVEL9K_ASDF_ERLANG_FOREGROUND=125
# typeset -g POWERLEVEL9K_ASDF_ERLANG_VISUAL_IDENTIFIER_EXPANSION='⭐'
# typeset -g POWERLEVEL9K_ASDF_ERLANG_SHOW_ON_UPGLOB='*.foo|*.bar'

# Elixir version from asdf.
typeset -g POWERLEVEL9K_ASDF_ELIXIR_FOREGROUND=129
# typeset -g POWERLEVEL9K_ASDF_ELIXIR_VISUAL_IDENTIFIER_EXPANSION='⭐'
# typeset -g POWERLEVEL9K_ASDF_ELIXIR_SHOW_ON_UPGLOB='*.foo|*.bar'

# Postgres version from asdf.
typeset -g POWERLEVEL9K_ASDF_POSTGRES_FOREGROUND=31
# typeset -g POWERLEVEL9K_ASDF_POSTGRES_VISUAL_IDENTIFIER_EXPANSION='⭐'
# typeset -g POWERLEVEL9K_ASDF_POSTGRES_SHOW_ON_UPGLOB='*.foo|*.bar'

# PHP version from asdf.
typeset -g POWERLEVEL9K_ASDF_PHP_FOREGROUND=99
# typeset -g POWERLEVEL9K_ASDF_PHP_VISUAL_IDENTIFIER_EXPANSION='⭐'
# typeset -g POWERLEVEL9K_ASDF_PHP_SHOW_ON_UPGLOB='*.foo|*.bar'

# Haskell version from asdf.
typeset -g POWERLEVEL9K_ASDF_HASKELL_FOREGROUND=172
# typeset -g POWERLEVEL9K_ASDF_HASKELL_VISUAL_IDENTIFIER_EXPANSION='⭐'
# typeset -g POWERLEVEL9K_ASDF_HASKELL_SHOW_ON_UPGLOB='*.foo|*.bar'

# Julia version from asdf.
typeset -g POWERLEVEL9K_ASDF_JULIA_FOREGROUND=70
# typeset -g POWERLEVEL9K_ASDF_JULIA_VISUAL_IDENTIFIER_EXPANSION='⭐'
# typeset -g POWERLEVEL9K_ASDF_JULIA_SHOW_ON_UPGLOB='*.foo|*.bar'

##########[ nordvpn: nordvpn connection status, linux only (https://nordvpn.com/) ]###########
# NordVPN connection indicator color.
typeset -g POWERLEVEL9K_NORDVPN_FOREGROUND=39
# Hide NordVPN connection indicator when not connected.
typeset -g POWERLEVEL9K_NORDVPN_{DISCONNECTED,CONNECTING,DISCONNECTING}_CONTENT_EXPANSION=
typeset -g POWERLEVEL9K_NORDVPN_{DISCONNECTED,CONNECTING,DISCONNECTING}_VISUAL_IDENTIFIER_EXPANSION=
# Custom icon.
# typeset -g POWERLEVEL9K_NORDVPN_VISUAL_IDENTIFIER_EXPANSION='⭐'

#################[ ranger: ranger shell (https://github.com/ranger/ranger) ]##################
# Ranger shell color.
typeset -g POWERLEVEL9K_RANGER_FOREGROUND=178
# Custom icon.
# typeset -g POWERLEVEL9K_RANGER_VISUAL_IDENTIFIER_EXPANSION='⭐'

####################[ yazi: yazi shell (https://github.com/sxyazi/yazi) ]#####################
# Yazi shell color.
typeset -g POWERLEVEL9K_YAZI_FOREGROUND=178
# Custom icon.
# typeset -g POWERLEVEL9K_YAZI_VISUAL_IDENTIFIER_EXPANSION='⭐'

######################[ nnn: nnn shell (https://github.com/jarun/nnn) ]#######################
# Nnn shell color.
typeset -g POWERLEVEL9K_NNN_FOREGROUND=72
# Custom icon.
# typeset -g POWERLEVEL9K_NNN_VISUAL_IDENTIFIER_EXPANSION='⭐'

######################[ lf: lf shell (https://github.com/gokcehan/lf) ]#######################
# lf shell color.
typeset -g POWERLEVEL9K_LF_FOREGROUND=72
# Custom icon.
# typeset -g POWERLEVEL9K_LF_VISUAL_IDENTIFIER_EXPANSION='⭐'

##################[ xplr: xplr shell (https://github.com/sayanarijit/xplr) ]##################
# xplr shell color.
typeset -g POWERLEVEL9K_XPLR_FOREGROUND=72
# Custom icon.
# typeset -g POWERLEVEL9K_XPLR_VISUAL_IDENTIFIER_EXPANSION='⭐'

###########################[ vim_shell: vim shell indicator (:sh) ]###########################
# Vim shell indicator color.
typeset -g POWERLEVEL9K_VIM_SHELL_FOREGROUND=34
# Custom icon.
# typeset -g POWERLEVEL9K_VIM_SHELL_VISUAL_IDENTIFIER_EXPANSION='⭐'

######[ midnight_commander: midnight commander shell (https://midnight-commander.org/) ]######
# Midnight Commander shell color.
typeset -g POWERLEVEL9K_MIDNIGHT_COMMANDER_FOREGROUND=178
# Custom icon.
# typeset -g POWERLEVEL9K_MIDNIGHT_COMMANDER_VISUAL_IDENTIFIER_EXPANSION='⭐'

#[ nix_shell: nix shell (https://nixos.org/nixos/nix-pills/developing-with-nix-shell.html) ]##
# Nix shell color.
typeset -g POWERLEVEL9K_NIX_SHELL_FOREGROUND=74

# Display the icon of nix_shell if PATH contains a subdirectory of /nix/store.
# typeset -g POWERLEVEL9K_NIX_SHELL_INFER_FROM_PATH=false

# Tip: If you want to see just the icon without "pure" and "impure", uncomment the next line.
# typeset -g POWERLEVEL9K_NIX_SHELL_CONTENT_EXPANSION=

# Custom icon.
# typeset -g POWERLEVEL9K_NIX_SHELL_VISUAL_IDENTIFIER_EXPANSION='⭐'

##################[ chezmoi_shell: chezmoi shell (https://www.chezmoi.io/) ]##################
# chezmoi shell color.
typeset -g POWERLEVEL9K_CHEZMOI_SHELL_FOREGROUND=33
# Custom icon.
# typeset -g POWERLEVEL9K_CHEZMOI_SHELL_VISUAL_IDENTIFIER_EXPANSION='⭐'

##################################[ disk_usage: disk usage ]##################################
# Colors for different levels of disk usage.
typeset -g POWERLEVEL9K_DISK_USAGE_NORMAL_FOREGROUND=35
typeset -g POWERLEVEL9K_DISK_USAGE_WARNING_FOREGROUND=220
typeset -g POWERLEVEL9K_DISK_USAGE_CRITICAL_FOREGROUND=160
# Thresholds for different levels of disk usage (percentage points).
typeset -g POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL=90
typeset -g POWERLEVEL9K_DISK_USAGE_CRITICAL_LEVEL=95
# If set to true, hide disk usage when below $POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL percent.
typeset -g POWERLEVEL9K_DISK_USAGE_ONLY_WARNING=false
# Custom icon.
# typeset -g POWERLEVEL9K_DISK_USAGE_VISUAL_IDENTIFIER_EXPANSION='⭐'

######################################[ ram: free RAM ]#######################################
# RAM color.
typeset -g POWERLEVEL9K_RAM_FOREGROUND=66
# Custom icon.
# typeset -g POWERLEVEL9K_RAM_VISUAL_IDENTIFIER_EXPANSION='⭐'

#####################################[ swap: used swap ]######################################
# Swap color.
typeset -g POWERLEVEL9K_SWAP_FOREGROUND=96
# Custom icon.
# typeset -g POWERLEVEL9K_SWAP_VISUAL_IDENTIFIER_EXPANSION='⭐'

######################################[ load: CPU load ]######################################
# Show average CPU load over this many last minutes. Valid values are 1, 5 and 15.
typeset -g POWERLEVEL9K_LOAD_WHICH=5
# Load color when load is under 50%.
typeset -g POWERLEVEL9K_LOAD_NORMAL_FOREGROUND=66
# Load color when load is between 50% and 70%.
typeset -g POWERLEVEL9K_LOAD_WARNING_FOREGROUND=178
# Load color when load is over 70%.
typeset -g POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND=166
# Custom icon.
# typeset -g POWERLEVEL9K_LOAD_VISUAL_IDENTIFIER_EXPANSION='⭐'

################[ todo: todo items (https://github.com/todotxt/todo.txt-cli) ]################
# Todo color.
typeset -g POWERLEVEL9K_TODO_FOREGROUND=110
# Hide todo when the total number of tasks is zero.
typeset -g POWERLEVEL9K_TODO_HIDE_ZERO_TOTAL=true
# Hide todo when the number of tasks after filtering is zero.
typeset -g POWERLEVEL9K_TODO_HIDE_ZERO_FILTERED=false

# Todo format. The following parameters are available within the expansion.
#
# - P9K_TODO_TOTAL_TASK_COUNT     The total number of tasks.
# - P9K_TODO_FILTERED_TASK_COUNT  The number of tasks after filtering.
#
# These variables correspond to the last line of the output of `todo.sh -p ls`:
#
#   TODO: 24 of 42 tasks shown
#
# Here 24 is P9K_TODO_FILTERED_TASK_COUNT and 42 is P9K_TODO_TOTAL_TASK_COUNT.
#
# typeset -g POWERLEVEL9K_TODO_CONTENT_EXPANSION='$P9K_TODO_FILTERED_TASK_COUNT'

# Custom icon.
# typeset -g POWERLEVEL9K_TODO_VISUAL_IDENTIFIER_EXPANSION='⭐'

###########[ timewarrior: timewarrior tracking status (https://timewarrior.net/) ]############
# Timewarrior color.
typeset -g POWERLEVEL9K_TIMEWARRIOR_FOREGROUND=110
# If the tracked task is longer than 24 characters, truncate and append "…".
# Tip: To always display tasks without truncation, delete the following parameter.
# Tip: To hide task names and display just the icon when time tracking is enabled, set the
# value of the following parameter to "".
typeset -g POWERLEVEL9K_TIMEWARRIOR_CONTENT_EXPANSION='${P9K_CONTENT:0:24}${${P9K_CONTENT:24}:+…}'

# Custom icon.
# typeset -g POWERLEVEL9K_TIMEWARRIOR_VISUAL_IDENTIFIER_EXPANSION='⭐'

##############[ taskwarrior: taskwarrior task count (https://taskwarrior.org/) ]##############
# Taskwarrior color.
typeset -g POWERLEVEL9K_TASKWARRIOR_FOREGROUND=74

# Taskwarrior segment format. The following parameters are available within the expansion.
#
# - P9K_TASKWARRIOR_PENDING_COUNT   The number of pending tasks: `task +PENDING count`.
# - P9K_TASKWARRIOR_OVERDUE_COUNT   The number of overdue tasks: `task +OVERDUE count`.
#
# Zero values are represented as empty parameters.
#
# The default format:
#
#   '${P9K_TASKWARRIOR_OVERDUE_COUNT:+"!$P9K_TASKWARRIOR_OVERDUE_COUNT/"}$P9K_TASKWARRIOR_PENDING_COUNT'
#
# typeset -g POWERLEVEL9K_TASKWARRIOR_CONTENT_EXPANSION='$P9K_TASKWARRIOR_PENDING_COUNT'

# Custom icon.
# typeset -g POWERLEVEL9K_TASKWARRIOR_VISUAL_IDENTIFIER_EXPANSION='⭐'

######[ per_directory_history: Oh My Zsh per-directory-history local/global indicator ]#######
# Color when using local/global history.
typeset -g POWERLEVEL9K_PER_DIRECTORY_HISTORY_LOCAL_FOREGROUND=135
typeset -g POWERLEVEL9K_PER_DIRECTORY_HISTORY_GLOBAL_FOREGROUND=130

# Tip: Uncomment the next two lines to hide "local"/"global" text and leave just the icon.
# typeset -g POWERLEVEL9K_PER_DIRECTORY_HISTORY_LOCAL_CONTENT_EXPANSION=''
# typeset -g POWERLEVEL9K_PER_DIRECTORY_HISTORY_GLOBAL_CONTENT_EXPANSION=''

# Custom icon.
# typeset -g POWERLEVEL9K_PER_DIRECTORY_HISTORY_LOCAL_VISUAL_IDENTIFIER_EXPANSION='⭐'
# typeset -g POWERLEVEL9K_PER_DIRECTORY_HISTORY_GLOBAL_VISUAL_IDENTIFIER_EXPANSION='⭐'

################################[ cpu_arch: CPU architecture ]################################
# CPU architecture color.
typeset -g POWERLEVEL9K_CPU_ARCH_FOREGROUND=172

# Hide the segment when on a specific CPU architecture.
# typeset -g POWERLEVEL9K_CPU_ARCH_X86_64_CONTENT_EXPANSION=
# typeset -g POWERLEVEL9K_CPU_ARCH_X86_64_VISUAL_IDENTIFIER_EXPANSION=

# Custom icon.
# typeset -g POWERLEVEL9K_CPU_ARCH_VISUAL_IDENTIFIER_EXPANSION='⭐'

##################################[ context: user@hostname ]##################################
# Context color when running with privileges.
typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=178
# Context color in SSH without privileges.
typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND=180
# Default context color (no privileges, no SSH).
typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=180

# Context format when running with privileges: bold user@hostname.
typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%B%n@%m'
# Context format when in SSH without privileges: user@hostname.
typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_TEMPLATE='%n@%m'
# Default context format (no privileges, no SSH): user@hostname.
typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'

# Don't show context unless running with privileges or in SSH.
# Tip: Remove the next line to always show context.
typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=

# Custom icon.
# typeset -g POWERLEVEL9K_CONTEXT_VISUAL_IDENTIFIER_EXPANSION='⭐'
# Custom prefix.
# typeset -g POWERLEVEL9K_CONTEXT_PREFIX='%fwith '

###[ virtualenv: python virtual environment (https://docs.python.org/3/library/venv.html) ]###
# Python virtual environment color.
typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=37
# Don't show Python version next to the virtual environment name.
typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
# If set to "false", won't show virtualenv if pyenv is already shown.
# If set to "if-different", won't show virtualenv if it's the same as pyenv.
typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=false
# Separate environment name from Python version only with a space.
typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=
# Custom icon.
# typeset -g POWERLEVEL9K_VIRTUALENV_VISUAL_IDENTIFIER_EXPANSION='⭐'

#####################[ anaconda: conda environment (https://conda.io/) ]######################
# Anaconda environment color.
typeset -g POWERLEVEL9K_ANACONDA_FOREGROUND=37

# Anaconda segment format. The following parameters are available within the expansion.
#
# - CONDA_PREFIX                 Absolute path to the active Anaconda/Miniconda environment.
# - CONDA_DEFAULT_ENV            Name of the active Anaconda/Miniconda environment.
# - CONDA_PROMPT_MODIFIER        Configurable prompt modifier (see below).
# - P9K_ANACONDA_PYTHON_VERSION  Current python version (python --version).
#
# CONDA_PROMPT_MODIFIER can be configured with the following command:
#
#   conda config --set env_prompt '({default_env}) '
#
# The last argument is a Python format string that can use the following variables:
#
# - prefix       The same as CONDA_PREFIX.
# - default_env  The same as CONDA_DEFAULT_ENV.
# - name         The last segment of CONDA_PREFIX.
# - stacked_env  Comma-separated list of names in the environment stack. The first element is
#                always the same as default_env.
#
# Note: '({default_env}) ' is the default value of env_prompt.
#
# The default value of POWERLEVEL9K_ANACONDA_CONTENT_EXPANSION expands to $CONDA_PROMPT_MODIFIER
# without the surrounding parentheses, or to the last path component of CONDA_PREFIX if the former
# is empty.
typeset -g POWERLEVEL9K_ANACONDA_CONTENT_EXPANSION='${${${${CONDA_PROMPT_MODIFIER#\(}% }%\)}:-${CONDA_PREFIX:t}}'

# Custom icon.
# typeset -g POWERLEVEL9K_ANACONDA_VISUAL_IDENTIFIER_EXPANSION='⭐'

################[ pyenv: python environment (https://github.com/pyenv/pyenv) ]################
# Pyenv color.
typeset -g POWERLEVEL9K_PYENV_FOREGROUND=37
# Hide python version if it doesn't come from one of these sources.
typeset -g POWERLEVEL9K_PYENV_SOURCES=(shell local global)
# If set to false, hide python version if it's the same as global:
# $(pyenv version-name) == $(pyenv global).
typeset -g POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW=false
# If set to false, hide python version if it's equal to "system".
typeset -g POWERLEVEL9K_PYENV_SHOW_SYSTEM=true

# Pyenv segment format. The following parameters are available within the expansion.
#
# - P9K_CONTENT                Current pyenv environment (pyenv version-name).
# - P9K_PYENV_PYTHON_VERSION   Current python version (python --version).
#
# The default format has the following logic:
#
# 1. Display just "$P9K_CONTENT" if it's equal to "$P9K_PYENV_PYTHON_VERSION" or
#    starts with "$P9K_PYENV_PYTHON_VERSION/".
# 2. Otherwise display "$P9K_CONTENT $P9K_PYENV_PYTHON_VERSION".
typeset -g POWERLEVEL9K_PYENV_CONTENT_EXPANSION='${P9K_CONTENT}${${P9K_CONTENT:#$P9K_PYENV_PYTHON_VERSION(|/*)}:+ $P9K_PYENV_PYTHON_VERSION}'

# Custom icon.
# typeset -g POWERLEVEL9K_PYENV_VISUAL_IDENTIFIER_EXPANSION='⭐'

################[ goenv: go environment (https://github.com/syndbg/goenv) ]################
# Goenv color.
typeset -g POWERLEVEL9K_GOENV_FOREGROUND=37
# Hide go version if it doesn't come from one of these sources.
typeset -g POWERLEVEL9K_GOENV_SOURCES=(shell local global)
# If set to false, hide go version if it's the same as global:
# $(goenv version-name) == $(goenv global).
typeset -g POWERLEVEL9K_GOENV_PROMPT_ALWAYS_SHOW=false
# If set to false, hide go version if it's equal to "system".
typeset -g POWERLEVEL9K_GOENV_SHOW_SYSTEM=true
# Custom icon.
# typeset -g POWERLEVEL9K_GOENV_VISUAL_IDENTIFIER_EXPANSION='⭐'

##########[ nodenv: node.js version from nodenv (https://github.com/nodenv/nodenv) ]##########
# Nodenv color.
typeset -g POWERLEVEL9K_NODENV_FOREGROUND=70
# Hide node version if it doesn't come from one of these sources.
typeset -g POWERLEVEL9K_NODENV_SOURCES=(shell local global)
# If set to false, hide node version if it's the same as global:
# $(nodenv version-name) == $(nodenv global).
typeset -g POWERLEVEL9K_NODENV_PROMPT_ALWAYS_SHOW=false
# If set to false, hide node version if it's equal to "system".
typeset -g POWERLEVEL9K_NODENV_SHOW_SYSTEM=true
# Custom icon.
# typeset -g POWERLEVEL9K_NODENV_VISUAL_IDENTIFIER_EXPANSION='⭐'

##############[ nvm: node.js version from nvm (https://github.com/nvm-sh/nvm) ]###############
# Nvm color.
typeset -g POWERLEVEL9K_NVM_FOREGROUND=70
# If set to false, hide node version if it's the same as default:
# $(nvm version current) == $(nvm version default).
typeset -g POWERLEVEL9K_NVM_PROMPT_ALWAYS_SHOW=false
# If set to false, hide node version if it's equal to "system".
typeset -g POWERLEVEL9K_NVM_SHOW_SYSTEM=true
# Custom icon.
# typeset -g POWERLEVEL9K_NVM_VISUAL_IDENTIFIER_EXPANSION='⭐'

############[ nodeenv: node.js environment (https://github.com/ekalinin/nodeenv) ]############
# Nodeenv color.
typeset -g POWERLEVEL9K_NODEENV_FOREGROUND=70
# Don't show Node version next to the environment name.
typeset -g POWERLEVEL9K_NODEENV_SHOW_NODE_VERSION=false
# Separate environment name from Node version only with a space.
typeset -g POWERLEVEL9K_NODEENV_{LEFT,RIGHT}_DELIMITER=
# Custom icon.
# typeset -g POWERLEVEL9K_NODEENV_VISUAL_IDENTIFIER_EXPANSION='⭐'

##############################[ node_version: node.js version ]###############################
# Node version color.
typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=70
# Show node version only when in a directory tree containing package.json.
typeset -g POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY=true
# Custom icon.
# typeset -g POWERLEVEL9K_NODE_VERSION_VISUAL_IDENTIFIER_EXPANSION='⭐'

#######################[ go_version: go version (https://golang.org) ]########################
# Go version color.
typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=37
# Show go version only when in a go project subdirectory.
typeset -g POWERLEVEL9K_GO_VERSION_PROJECT_ONLY=true
# Custom icon.
# typeset -g POWERLEVEL9K_GO_VERSION_VISUAL_IDENTIFIER_EXPANSION='⭐'

#################[ rust_version: rustc version (https://www.rust-lang.org) ]##################
# Rust version color.
typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND=37
# Show rust version only when in a rust project subdirectory.
typeset -g POWERLEVEL9K_RUST_VERSION_PROJECT_ONLY=true
# Custom icon.
# typeset -g POWERLEVEL9K_RUST_VERSION_VISUAL_IDENTIFIER_EXPANSION='⭐'

###############[ dotnet_version: .NET version (https://dotnet.microsoft.com) ]################
# .NET version color.
typeset -g POWERLEVEL9K_DOTNET_VERSION_FOREGROUND=134
# Show .NET version only when in a .NET project subdirectory.
typeset -g POWERLEVEL9K_DOTNET_VERSION_PROJECT_ONLY=true
# Custom icon.
# typeset -g POWERLEVEL9K_DOTNET_VERSION_VISUAL_IDENTIFIER_EXPANSION='⭐'

#####################[ php_version: php version (https://www.php.net/) ]######################
# PHP version color.
typeset -g POWERLEVEL9K_PHP_VERSION_FOREGROUND=99
# Show PHP version only when in a PHP project subdirectory.
typeset -g POWERLEVEL9K_PHP_VERSION_PROJECT_ONLY=true
# Custom icon.
# typeset -g POWERLEVEL9K_PHP_VERSION_VISUAL_IDENTIFIER_EXPANSION='⭐'

##########[ laravel_version: laravel php framework version (https://laravel.com/) ]###########
# Laravel version color.
typeset -g POWERLEVEL9K_LARAVEL_VERSION_FOREGROUND=161
# Custom icon.
# typeset -g POWERLEVEL9K_LARAVEL_VERSION_VISUAL_IDENTIFIER_EXPANSION='⭐'

####################[ java_version: java version (https://www.java.com/) ]####################
# Java version color.
typeset -g POWERLEVEL9K_JAVA_VERSION_FOREGROUND=32
# Show java version only when in a java project subdirectory.
typeset -g POWERLEVEL9K_JAVA_VERSION_PROJECT_ONLY=true
# Show brief version.
typeset -g POWERLEVEL9K_JAVA_VERSION_FULL=false
# Custom icon.
# typeset -g POWERLEVEL9K_JAVA_VERSION_VISUAL_IDENTIFIER_EXPANSION='⭐'

###[ package: name@version from package.json (https://docs.npmjs.com/files/package.json) ]####
# Package color.
typeset -g POWERLEVEL9K_PACKAGE_FOREGROUND=117
# Package format. The following parameters are available within the expansion.
#
# - P9K_PACKAGE_NAME     The value of `name` field in package.json.
# - P9K_PACKAGE_VERSION  The value of `version` field in package.json.
#
# typeset -g POWERLEVEL9K_PACKAGE_CONTENT_EXPANSION='${P9K_PACKAGE_NAME//\%/%%}@${P9K_PACKAGE_VERSION//\%/%%}'
# Custom icon.
# typeset -g POWERLEVEL9K_PACKAGE_VISUAL_IDENTIFIER_EXPANSION='⭐'

#############[ rbenv: ruby version from rbenv (https://github.com/rbenv/rbenv) ]##############
# Rbenv color.
typeset -g POWERLEVEL9K_RBENV_FOREGROUND=168
# Hide ruby version if it doesn't come from one of these sources.
typeset -g POWERLEVEL9K_RBENV_SOURCES=(shell local global)
# If set to false, hide ruby version if it's the same as global:
# $(rbenv version-name) == $(rbenv global).
typeset -g POWERLEVEL9K_RBENV_PROMPT_ALWAYS_SHOW=false
# If set to false, hide ruby version if it's equal to "system".
typeset -g POWERLEVEL9K_RBENV_SHOW_SYSTEM=true
# Custom icon.
# typeset -g POWERLEVEL9K_RBENV_VISUAL_IDENTIFIER_EXPANSION='⭐'

#######################[ rvm: ruby version from rvm (https://rvm.io) ]########################
# Rvm color.
typeset -g POWERLEVEL9K_RVM_FOREGROUND=168
# Don't show @gemset at the end.
typeset -g POWERLEVEL9K_RVM_SHOW_GEMSET=false
# Don't show ruby- at the front.
typeset -g POWERLEVEL9K_RVM_SHOW_PREFIX=false
# Custom icon.
# typeset -g POWERLEVEL9K_RVM_VISUAL_IDENTIFIER_EXPANSION='⭐'

###########[ fvm: flutter version management (https://github.com/leoafarias/fvm) ]############
# Fvm color.
typeset -g POWERLEVEL9K_FVM_FOREGROUND=38
# Custom icon.
# typeset -g POWERLEVEL9K_FVM_VISUAL_IDENTIFIER_EXPANSION='⭐'

##########[ luaenv: lua version from luaenv (https://github.com/cehoffman/luaenv) ]###########
# Lua color.
typeset -g POWERLEVEL9K_LUAENV_FOREGROUND=32
# Hide lua version if it doesn't come from one of these sources.
typeset -g POWERLEVEL9K_LUAENV_SOURCES=(shell local global)
# If set to false, hide lua version if it's the same as global:
# $(luaenv version-name) == $(luaenv global).
typeset -g POWERLEVEL9K_LUAENV_PROMPT_ALWAYS_SHOW=false
# If set to false, hide lua version if it's equal to "system".
typeset -g POWERLEVEL9K_LUAENV_SHOW_SYSTEM=true
# Custom icon.
# typeset -g POWERLEVEL9K_LUAENV_VISUAL_IDENTIFIER_EXPANSION='⭐'

###############[ jenv: java version from jenv (https://github.com/jenv/jenv) ]################
# Java color.
typeset -g POWERLEVEL9K_JENV_FOREGROUND=32
# Hide java version if it doesn't come from one of these sources.
typeset -g POWERLEVEL9K_JENV_SOURCES=(shell local global)
# If set to false, hide java version if it's the same as global:
# $(jenv version-name) == $(jenv global).
typeset -g POWERLEVEL9K_JENV_PROMPT_ALWAYS_SHOW=false
# If set to false, hide java version if it's equal to "system".
typeset -g POWERLEVEL9K_JENV_SHOW_SYSTEM=true
# Custom icon.
# typeset -g POWERLEVEL9K_JENV_VISUAL_IDENTIFIER_EXPANSION='⭐'

###########[ plenv: perl version from plenv (https://github.com/tokuhirom/plenv) ]############
# Perl color.
typeset -g POWERLEVEL9K_PLENV_FOREGROUND=67
# Hide perl version if it doesn't come from one of these sources.
typeset -g POWERLEVEL9K_PLENV_SOURCES=(shell local global)
# If set to false, hide perl version if it's the same as global:
# $(plenv version-name) == $(plenv global).
typeset -g POWERLEVEL9K_PLENV_PROMPT_ALWAYS_SHOW=false
# If set to false, hide perl version if it's equal to "system".
typeset -g POWERLEVEL9K_PLENV_SHOW_SYSTEM=true
# Custom icon.
# typeset -g POWERLEVEL9K_PLENV_VISUAL_IDENTIFIER_EXPANSION='⭐'

###########[ perlbrew: perl version from perlbrew (https://github.com/gugod/App-perlbrew) ]############
# Perlbrew color.
typeset -g POWERLEVEL9K_PERLBREW_FOREGROUND=67
# Show perlbrew version only when in a perl project subdirectory.
typeset -g POWERLEVEL9K_PERLBREW_PROJECT_ONLY=true
# Don't show "perl-" at the front.
typeset -g POWERLEVEL9K_PERLBREW_SHOW_PREFIX=false
# Custom icon.
# typeset -g POWERLEVEL9K_PERLBREW_VISUAL_IDENTIFIER_EXPANSION='⭐'

############[ phpenv: php version from phpenv (https://github.com/phpenv/phpenv) ]############
# PHP color.
typeset -g POWERLEVEL9K_PHPENV_FOREGROUND=99
# Hide php version if it doesn't come from one of these sources.
typeset -g POWERLEVEL9K_PHPENV_SOURCES=(shell local global)
# If set to false, hide php version if it's the same as global:
# $(phpenv version-name) == $(phpenv global).
typeset -g POWERLEVEL9K_PHPENV_PROMPT_ALWAYS_SHOW=false
# If set to false, hide php version if it's equal to "system".
typeset -g POWERLEVEL9K_PHPENV_SHOW_SYSTEM=true
# Custom icon.
# typeset -g POWERLEVEL9K_PHPENV_VISUAL_IDENTIFIER_EXPANSION='⭐'

#######[ scalaenv: scala version from scalaenv (https://github.com/scalaenv/scalaenv) ]#######
# Scala color.
typeset -g POWERLEVEL9K_SCALAENV_FOREGROUND=160
# Hide scala version if it doesn't come from one of these sources.
typeset -g POWERLEVEL9K_SCALAENV_SOURCES=(shell local global)
# If set to false, hide scala version if it's the same as global:
# $(scalaenv version-name) == $(scalaenv global).
typeset -g POWERLEVEL9K_SCALAENV_PROMPT_ALWAYS_SHOW=false
# If set to false, hide scala version if it's equal to "system".
typeset -g POWERLEVEL9K_SCALAENV_SHOW_SYSTEM=true
# Custom icon.
# typeset -g POWERLEVEL9K_SCALAENV_VISUAL_IDENTIFIER_EXPANSION='⭐'

##########[ haskell_stack: haskell version from stack (https://haskellstack.org/) ]###########
# Haskell color.
typeset -g POWERLEVEL9K_HASKELL_STACK_FOREGROUND=172
# Hide haskell version if it doesn't come from one of these sources.
#
#   shell:  version is set by STACK_YAML
#   local:  version is set by stack.yaml up the directory tree
#   global: version is set by the implicit global project (~/.stack/global-project/stack.yaml)
typeset -g POWERLEVEL9K_HASKELL_STACK_SOURCES=(shell local)
# If set to false, hide haskell version if it's the same as in the implicit global project.
typeset -g POWERLEVEL9K_HASKELL_STACK_ALWAYS_SHOW=true
# Custom icon.
# typeset -g POWERLEVEL9K_HASKELL_STACK_VISUAL_IDENTIFIER_EXPANSION='⭐'

#############[ kubecontext: current kubernetes context (https://kubernetes.io/) ]#############
# Show kubecontext only when the command you are typing invokes one of these tools.
# Tip: Remove the next line to always show kubecontext.
typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito|k9s|helmfile|flux|fluxctl|stern|kubeseal|skaffold|kubent|kubecolor|cmctl|sparkctl'

# Kubernetes context classes for the purpose of using different colors, icons and expansions with
# different contexts.
#
# POWERLEVEL9K_KUBECONTEXT_CLASSES is an array with even number of elements. The first element
# in each pair defines a pattern against which the current kubernetes context gets matched.
# More specifically, it's P9K_CONTENT prior to the application of context expansion (see below)
# that gets matched. If you unset all POWERLEVEL9K_KUBECONTEXT_*CONTENT_EXPANSION parameters,
# you'll see this value in your prompt. The second element of each pair in
# POWERLEVEL9K_KUBECONTEXT_CLASSES defines the context class. Patterns are tried in order. The
# first match wins.
#
# For example, given these settings:
#
#   typeset -g POWERLEVEL9K_KUBECONTEXT_CLASSES=(
#     '*prod*'  PROD
#     '*test*'  TEST
#     '*'       DEFAULT)
#
# If your current kubernetes context is "deathray-testing/default", its class is TEST
# because "deathray-testing/default" doesn't match the pattern '*prod*' but does match '*test*'.
#
# You can define different colors, icons and content expansions for different classes:
#
#   typeset -g POWERLEVEL9K_KUBECONTEXT_TEST_FOREGROUND=28
#   typeset -g POWERLEVEL9K_KUBECONTEXT_TEST_VISUAL_IDENTIFIER_EXPANSION='⭐'
#   typeset -g POWERLEVEL9K_KUBECONTEXT_TEST_CONTENT_EXPANSION='> ${P9K_CONTENT} <'
typeset -g POWERLEVEL9K_KUBECONTEXT_CLASSES=(
    # '*prod*'  PROD    # These values are examples that are unlikely
    # '*test*'  TEST    # to match your needs. Customize them as needed.
    '*'       DEFAULT)
typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_FOREGROUND=134
# typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_VISUAL_IDENTIFIER_EXPANSION='⭐'

# Use POWERLEVEL9K_KUBECONTEXT_CONTENT_EXPANSION to specify the content displayed by kubecontext
# segment. Parameter expansions are very flexible and fast, too. See reference:
# http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion.
#
# Within the expansion the following parameters are always available:
#
# - P9K_CONTENT                The content that would've been displayed if there was no content
#                              expansion defined.
# - P9K_KUBECONTEXT_NAME       The current context's name. Corresponds to column NAME in the
#                              output of `kubectl config get-contexts`.
# - P9K_KUBECONTEXT_CLUSTER    The current context's cluster. Corresponds to column CLUSTER in the
#                              output of `kubectl config get-contexts`.
# - P9K_KUBECONTEXT_NAMESPACE  The current context's namespace. Corresponds to column NAMESPACE
#                              in the output of `kubectl config get-contexts`. If there is no
#                              namespace, the parameter is set to "default".
# - P9K_KUBECONTEXT_USER       The current context's user. Corresponds to column AUTHINFO in the
#                              output of `kubectl config get-contexts`.
#
# If the context points to Google Kubernetes Engine (GKE) or Elastic Kubernetes Service (EKS),
# the following extra parameters are available:
#
# - P9K_KUBECONTEXT_CLOUD_NAME     Either "gke" or "eks".
# - P9K_KUBECONTEXT_CLOUD_ACCOUNT  Account/project ID.
# - P9K_KUBECONTEXT_CLOUD_ZONE     Availability zone.
# - P9K_KUBECONTEXT_CLOUD_CLUSTER  Cluster.
#
# P9K_KUBECONTEXT_CLOUD_* parameters are derived from P9K_KUBECONTEXT_CLUSTER. For example,
# if P9K_KUBECONTEXT_CLUSTER is "gke_my-account_us-east1-a_my-cluster-01":
#
#   - P9K_KUBECONTEXT_CLOUD_NAME=gke
#   - P9K_KUBECONTEXT_CLOUD_ACCOUNT=my-account
#   - P9K_KUBECONTEXT_CLOUD_ZONE=us-east1-a
#   - P9K_KUBECONTEXT_CLOUD_CLUSTER=my-cluster-01
#
# If P9K_KUBECONTEXT_CLUSTER is "arn:aws:eks:us-east-1:123456789012:cluster/my-cluster-01":
#
#   - P9K_KUBECONTEXT_CLOUD_NAME=eks
#   - P9K_KUBECONTEXT_CLOUD_ACCOUNT=123456789012
#   - P9K_KUBECONTEXT_CLOUD_ZONE=us-east-1
#   - P9K_KUBECONTEXT_CLOUD_CLUSTER=my-cluster-01
typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION=
# Show P9K_KUBECONTEXT_CLOUD_CLUSTER if it's not empty and fall back to P9K_KUBECONTEXT_NAME.
POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION+='${P9K_KUBECONTEXT_CLOUD_CLUSTER:-${P9K_KUBECONTEXT_NAME}}'
# Append the current context's namespace if it's not "default".
POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION+='${${:-/$P9K_KUBECONTEXT_NAMESPACE}:#/default}'

# Custom prefix.
# typeset -g POWERLEVEL9K_KUBECONTEXT_PREFIX='%fat '

################[ terraform: terraform workspace (https://www.terraform.io) ]#################
# Don't show terraform workspace if it's literally "default".
typeset -g POWERLEVEL9K_TERRAFORM_SHOW_DEFAULT=false
# POWERLEVEL9K_TERRAFORM_CLASSES is an array with even number of elements. The first element
# in each pair defines a pattern against which the current terraform workspace gets matched.
# More specifically, it's P9K_CONTENT prior to the application of context expansion (see below)
# that gets matched. If you unset all POWERLEVEL9K_TERRAFORM_*CONTENT_EXPANSION parameters,
# you'll see this value in your prompt. The second element of each pair in
# POWERLEVEL9K_TERRAFORM_CLASSES defines the workspace class. Patterns are tried in order. The
# first match wins.
#
# For example, given these settings:
#
#   typeset -g POWERLEVEL9K_TERRAFORM_CLASSES=(
#     '*prod*'  PROD
#     '*test*'  TEST
#     '*'       OTHER)
#
# If your current terraform workspace is "project_test", its class is TEST because "project_test"
# doesn't match the pattern '*prod*' but does match '*test*'.
#
# You can define different colors, icons and content expansions for different classes:
#
#   typeset -g POWERLEVEL9K_TERRAFORM_TEST_FOREGROUND=28
#   typeset -g POWERLEVEL9K_TERRAFORM_TEST_VISUAL_IDENTIFIER_EXPANSION='⭐'
#   typeset -g POWERLEVEL9K_TERRAFORM_TEST_CONTENT_EXPANSION='> ${P9K_CONTENT} <'
typeset -g POWERLEVEL9K_TERRAFORM_CLASSES=(
    # '*prod*'  PROD    # These values are examples that are unlikely
    # '*test*'  TEST    # to match your needs. Customize them as needed.
    '*'         OTHER)
typeset -g POWERLEVEL9K_TERRAFORM_OTHER_FOREGROUND=38
# typeset -g POWERLEVEL9K_TERRAFORM_OTHER_VISUAL_IDENTIFIER_EXPANSION='⭐'

#############[ terraform_version: terraform version (https://www.terraform.io) ]##############
# Terraform version color.
typeset -g POWERLEVEL9K_TERRAFORM_VERSION_FOREGROUND=38
# Custom icon.
# typeset -g POWERLEVEL9K_TERRAFORM_VERSION_VISUAL_IDENTIFIER_EXPANSION='⭐'

#[ aws: aws profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) ]#
# Show aws only when the command you are typing invokes one of these tools.
# Tip: Remove the next line to always show aws.
typeset -g POWERLEVEL9K_AWS_SHOW_ON_COMMAND='aws|awless|cdk|terraform|pulumi|terragrunt'

# POWERLEVEL9K_AWS_CLASSES is an array with even number of elements. The first element
# in each pair defines a pattern against which the current AWS profile gets matched.
# More specifically, it's P9K_CONTENT prior to the application of context expansion (see below)
# that gets matched. If you unset all POWERLEVEL9K_AWS_*CONTENT_EXPANSION parameters,
# you'll see this value in your prompt. The second element of each pair in
# POWERLEVEL9K_AWS_CLASSES defines the profile class. Patterns are tried in order. The
# first match wins.
#
# For example, given these settings:
#
#   typeset -g POWERLEVEL9K_AWS_CLASSES=(
#     '*prod*'  PROD
#     '*test*'  TEST
#     '*'       DEFAULT)
#
# If your current AWS profile is "company_test", its class is TEST
# because "company_test" doesn't match the pattern '*prod*' but does match '*test*'.
#
# You can define different colors, icons and content expansions for different classes:
#
#   typeset -g POWERLEVEL9K_AWS_TEST_FOREGROUND=28
#   typeset -g POWERLEVEL9K_AWS_TEST_VISUAL_IDENTIFIER_EXPANSION='⭐'
#   typeset -g POWERLEVEL9K_AWS_TEST_CONTENT_EXPANSION='> ${P9K_CONTENT} <'
typeset -g POWERLEVEL9K_AWS_CLASSES=(
    # '*prod*'  PROD    # These values are examples that are unlikely
    # '*test*'  TEST    # to match your needs. Customize them as needed.
    '*'       DEFAULT)
typeset -g POWERLEVEL9K_AWS_DEFAULT_FOREGROUND=208
# typeset -g POWERLEVEL9K_AWS_DEFAULT_VISUAL_IDENTIFIER_EXPANSION='⭐'

# AWS segment format. The following parameters are available within the expansion.
#
# - P9K_AWS_PROFILE  The name of the current AWS profile.
# - P9K_AWS_REGION   The region associated with the current AWS profile.
typeset -g POWERLEVEL9K_AWS_CONTENT_EXPANSION='${P9K_AWS_PROFILE//\%/%%}${P9K_AWS_REGION:+ ${P9K_AWS_REGION//\%/%%}}'

#[ aws_eb_env: aws elastic beanstalk environment (https://aws.amazon.com/elasticbeanstalk/) ]#
# AWS Elastic Beanstalk environment color.
typeset -g POWERLEVEL9K_AWS_EB_ENV_FOREGROUND=70
# Custom icon.
# typeset -g POWERLEVEL9K_AWS_EB_ENV_VISUAL_IDENTIFIER_EXPANSION='⭐'

##########[ azure: azure account name (https://docs.microsoft.com/en-us/cli/azure) ]##########
# Show azure only when the command you are typing invokes one of these tools.
# Tip: Remove the next line to always show azure.
typeset -g POWERLEVEL9K_AZURE_SHOW_ON_COMMAND='az|terraform|pulumi|terragrunt'

# POWERLEVEL9K_AZURE_CLASSES is an array with even number of elements. The first element
# in each pair defines a pattern against which the current azure account name gets matched.
# More specifically, it's P9K_CONTENT prior to the application of context expansion (see below)
# that gets matched. If you unset all POWERLEVEL9K_AZURE_*CONTENT_EXPANSION parameters,
# you'll see this value in your prompt. The second element of each pair in
# POWERLEVEL9K_AZURE_CLASSES defines the account class. Patterns are tried in order. The
# first match wins.
#
# For example, given these settings:
#
#   typeset -g POWERLEVEL9K_AZURE_CLASSES=(
#     '*prod*'  PROD
#     '*test*'  TEST
#     '*'       OTHER)
#
# If your current azure account is "company_test", its class is TEST because "company_test"
# doesn't match the pattern '*prod*' but does match '*test*'.
#
# You can define different colors, icons and content expansions for different classes:
#
#   typeset -g POWERLEVEL9K_AZURE_TEST_FOREGROUND=28
#   typeset -g POWERLEVEL9K_AZURE_TEST_VISUAL_IDENTIFIER_EXPANSION='⭐'
#   typeset -g POWERLEVEL9K_AZURE_TEST_CONTENT_EXPANSION='> ${P9K_CONTENT} <'
typeset -g POWERLEVEL9K_AZURE_CLASSES=(
    # '*prod*'  PROD    # These values are examples that are unlikely
    # '*test*'  TEST    # to match your needs. Customize them as needed.
    '*'         OTHER)

# Azure account name color.
typeset -g POWERLEVEL9K_AZURE_OTHER_FOREGROUND=32
# Custom icon.
# typeset -g POWERLEVEL9K_AZURE_OTHER_VISUAL_IDENTIFIER_EXPANSION='⭐'

##########[ gcloud: google cloud account and project (https://cloud.google.com/) ]###########
# Show gcloud only when the command you are typing invokes one of these tools.
# Tip: Remove the next line to always show gcloud.
typeset -g POWERLEVEL9K_GCLOUD_SHOW_ON_COMMAND='gcloud|gcs|gsutil'
# Google cloud color.
typeset -g POWERLEVEL9K_GCLOUD_FOREGROUND=32

# Google cloud format. Change the value of POWERLEVEL9K_GCLOUD_PARTIAL_CONTENT_EXPANSION and/or
# POWERLEVEL9K_GCLOUD_COMPLETE_CONTENT_EXPANSION if the default is too verbose or not informative
# enough. You can use the following parameters in the expansions. Each of them corresponds to the
# output of `gcloud` tool.
#
#   Parameter                | Source
#   -------------------------|--------------------------------------------------------------------
#   P9K_GCLOUD_CONFIGURATION | gcloud config configurations list --format='value(name)'
#   P9K_GCLOUD_ACCOUNT       | gcloud config get-value account
#   P9K_GCLOUD_PROJECT_ID    | gcloud config get-value project
#   P9K_GCLOUD_PROJECT_NAME  | gcloud projects describe $P9K_GCLOUD_PROJECT_ID --format='value(name)'
#
# Note: ${VARIABLE//\%/%%} expands to ${VARIABLE} with all occurrences of '%' replaced with '%%'.
#
# Obtaining project name requires sending a request to Google servers. This can take a long time
# and even fail. When project name is unknown, P9K_GCLOUD_PROJECT_NAME is not set and gcloud
# prompt segment is in state PARTIAL. When project name gets known, P9K_GCLOUD_PROJECT_NAME gets
# set and gcloud prompt segment transitions to state COMPLETE.
#
# You can customize the format, icon and colors of gcloud segment separately for states PARTIAL
# and COMPLETE. You can also hide gcloud in state PARTIAL by setting
# POWERLEVEL9K_GCLOUD_PARTIAL_VISUAL_IDENTIFIER_EXPANSION and
# POWERLEVEL9K_GCLOUD_PARTIAL_CONTENT_EXPANSION to empty.
typeset -g POWERLEVEL9K_GCLOUD_PARTIAL_CONTENT_EXPANSION='${P9K_GCLOUD_PROJECT_ID//\%/%%}'
typeset -g POWERLEVEL9K_GCLOUD_COMPLETE_CONTENT_EXPANSION='${P9K_GCLOUD_PROJECT_NAME//\%/%%}'

# Send a request to Google (by means of `gcloud projects describe ...`) to obtain project name
# this often. Negative value disables periodic polling. In this mode project name is retrieved
# only when the current configuration, account or project id changes.
typeset -g POWERLEVEL9K_GCLOUD_REFRESH_PROJECT_NAME_SECONDS=60

# Custom icon.
# typeset -g POWERLEVEL9K_GCLOUD_VISUAL_IDENTIFIER_EXPANSION='⭐'

#[ google_app_cred: google application credentials (https://cloud.google.com/docs/authentication/production) ]#
# Show google_app_cred only when the command you are typing invokes one of these tools.
# Tip: Remove the next line to always show google_app_cred.
typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_SHOW_ON_COMMAND='terraform|pulumi|terragrunt'

# Google application credentials classes for the purpose of using different colors, icons and
# expansions with different credentials.
#
# POWERLEVEL9K_GOOGLE_APP_CRED_CLASSES is an array with even number of elements. The first
# element in each pair defines a pattern against which the current kubernetes context gets
# matched. More specifically, it's P9K_CONTENT prior to the application of context expansion
# (see below) that gets matched. If you unset all POWERLEVEL9K_GOOGLE_APP_CRED_*CONTENT_EXPANSION
# parameters, you'll see this value in your prompt. The second element of each pair in
# POWERLEVEL9K_GOOGLE_APP_CRED_CLASSES defines the context class. Patterns are tried in order.
# The first match wins.
#
# For example, given these settings:
#
#   typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_CLASSES=(
#     '*:*prod*:*'  PROD
#     '*:*test*:*'  TEST
#     '*'           DEFAULT)
#
# If your current Google application credentials is "service_account deathray-testing x@y.com",
# its class is TEST because it doesn't match the pattern '* *prod* *' but does match '* *test* *'.
#
# You can define different colors, icons and content expansions for different classes:
#
#   typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_TEST_FOREGROUND=28
#   typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_TEST_VISUAL_IDENTIFIER_EXPANSION='⭐'
#   typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_TEST_CONTENT_EXPANSION='$P9K_GOOGLE_APP_CRED_PROJECT_ID'
typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_CLASSES=(
    # '*:*prod*:*'  PROD    # These values are examples that are unlikely
    # '*:*test*:*'  TEST    # to match your needs. Customize them as needed.
    '*'             DEFAULT)
typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_DEFAULT_FOREGROUND=32
# typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_DEFAULT_VISUAL_IDENTIFIER_EXPANSION='⭐'

# Use POWERLEVEL9K_GOOGLE_APP_CRED_CONTENT_EXPANSION to specify the content displayed by
# google_app_cred segment. Parameter expansions are very flexible and fast, too. See reference:
# http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion.
#
# You can use the following parameters in the expansion. Each of them corresponds to one of the
# fields in the JSON file pointed to by GOOGLE_APPLICATION_CREDENTIALS.
#
#   Parameter                        | JSON key file field
#   ---------------------------------+---------------
#   P9K_GOOGLE_APP_CRED_TYPE         | type
#   P9K_GOOGLE_APP_CRED_PROJECT_ID   | project_id
#   P9K_GOOGLE_APP_CRED_CLIENT_EMAIL | client_email
#
# Note: ${VARIABLE//\%/%%} expands to ${VARIABLE} with all occurrences of '%' replaced by '%%'.
typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_DEFAULT_CONTENT_EXPANSION='${P9K_GOOGLE_APP_CRED_PROJECT_ID//\%/%%}'

##############[ toolbox: toolbox name (https://github.com/containers/toolbox) ]###############
# Toolbox color.
typeset -g POWERLEVEL9K_TOOLBOX_FOREGROUND=178
# Don't display the name of the toolbox if it matches fedora-toolbox-*.
typeset -g POWERLEVEL9K_TOOLBOX_CONTENT_EXPANSION='${P9K_TOOLBOX_NAME:#fedora-toolbox-*}'
# Custom icon.
# typeset -g POWERLEVEL9K_TOOLBOX_VISUAL_IDENTIFIER_EXPANSION='⭐'
# Custom prefix.
# typeset -g POWERLEVEL9K_TOOLBOX_PREFIX='%fin '

###############################[ public_ip: public IP address ]###############################
# Public IP color.
typeset -g POWERLEVEL9K_PUBLIC_IP_FOREGROUND=94
# Custom icon.
# typeset -g POWERLEVEL9K_PUBLIC_IP_VISUAL_IDENTIFIER_EXPANSION='⭐'

########################[ vpn_ip: virtual private network indicator ]#########################
# VPN IP color.
typeset -g POWERLEVEL9K_VPN_IP_FOREGROUND=81
# When on VPN, show just an icon without the IP address.
# Tip: To display the private IP address when on VPN, remove the next line.
typeset -g POWERLEVEL9K_VPN_IP_CONTENT_EXPANSION=
# Regular expression for the VPN network interface. Run `ifconfig` or `ip -4 a show` while on VPN
# to see the name of the interface.
typeset -g POWERLEVEL9K_VPN_IP_INTERFACE='(gpd|wg|(.*tun)|tailscale)[0-9]*|(zt.*)'
# If set to true, show one segment per matching network interface. If set to false, show only
# one segment corresponding to the first matching network interface.
# Tip: If you set it to true, you'll probably want to unset POWERLEVEL9K_VPN_IP_CONTENT_EXPANSION.
typeset -g POWERLEVEL9K_VPN_IP_SHOW_ALL=false
# Custom icon.
# typeset -g POWERLEVEL9K_VPN_IP_VISUAL_IDENTIFIER_EXPANSION='⭐'

###########[ ip: ip address and bandwidth usage for a specified network interface ]###########
# IP color.
typeset -g POWERLEVEL9K_IP_FOREGROUND=38
# The following parameters are accessible within the expansion:
#
#   Parameter             | Meaning
#   ----------------------+-------------------------------------------
#   P9K_IP_IP             | IP address
#   P9K_IP_INTERFACE      | network interface
#   P9K_IP_RX_BYTES       | total number of bytes received
#   P9K_IP_TX_BYTES       | total number of bytes sent
#   P9K_IP_RX_BYTES_DELTA | number of bytes received since last prompt
#   P9K_IP_TX_BYTES_DELTA | number of bytes sent since last prompt
#   P9K_IP_RX_RATE        | receive rate (since last prompt)
#   P9K_IP_TX_RATE        | send rate (since last prompt)
typeset -g POWERLEVEL9K_IP_CONTENT_EXPANSION='$P9K_IP_IP${P9K_IP_RX_RATE:+ %70F⇣$P9K_IP_RX_RATE}${P9K_IP_TX_RATE:+ %215F⇡$P9K_IP_TX_RATE}'
# Show information for the first network interface whose name matches this regular expression.
# Run `ifconfig` or `ip -4 a show` to see the names of all network interfaces.
typeset -g POWERLEVEL9K_IP_INTERFACE='[ew].*'
# Custom icon.
# typeset -g POWERLEVEL9K_IP_VISUAL_IDENTIFIER_EXPANSION='⭐'

#########################[ proxy: system-wide http/https/ftp proxy ]##########################
# Proxy color.
typeset -g POWERLEVEL9K_PROXY_FOREGROUND=68
# Custom icon.
# typeset -g POWERLEVEL9K_PROXY_VISUAL_IDENTIFIER_EXPANSION='⭐'

################################[ battery: internal battery ]#################################
# Show battery in red when it's below this level and not connected to power supply.
typeset -g POWERLEVEL9K_BATTERY_LOW_THRESHOLD=20
typeset -g POWERLEVEL9K_BATTERY_LOW_FOREGROUND=160
# Show battery in green when it's charging or fully charged.
typeset -g POWERLEVEL9K_BATTERY_{CHARGING,CHARGED}_FOREGROUND=70
# Show battery in yellow when it's discharging.
typeset -g POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND=178
# Battery pictograms going from low to high level of charge.
typeset -g POWERLEVEL9K_BATTERY_STAGES='\UF008E\UF007A\UF007B\UF007C\UF007D\UF007E\UF007F\UF0080\UF0081\UF0082\UF0079'
# Don't show the remaining time to charge/discharge.
typeset -g POWERLEVEL9K_BATTERY_VERBOSE=false

#####################################[ wifi: wifi speed ]#####################################
# WiFi color.
typeset -g POWERLEVEL9K_WIFI_FOREGROUND=68
# Custom icon.
# typeset -g POWERLEVEL9K_WIFI_VISUAL_IDENTIFIER_EXPANSION='⭐'

# Use different colors and icons depending on signal strength ($P9K_WIFI_BARS).
#
#   # Wifi colors and icons for different signal strength levels (low to high).
#   typeset -g my_wifi_fg=(68 68 68 68 68)                           # <-- change these values
#   typeset -g my_wifi_icon=('WiFi' 'WiFi' 'WiFi' 'WiFi' 'WiFi')     # <-- change these values
#
#   typeset -g POWERLEVEL9K_WIFI_CONTENT_EXPANSION='%F{${my_wifi_fg[P9K_WIFI_BARS+1]}}$P9K_WIFI_LAST_TX_RATE Mbps'
#   typeset -g POWERLEVEL9K_WIFI_VISUAL_IDENTIFIER_EXPANSION='%F{${my_wifi_fg[P9K_WIFI_BARS+1]}}${my_wifi_icon[P9K_WIFI_BARS+1]}'
#
# The following parameters are accessible within the expansions:
#
#   Parameter             | Meaning
#   ----------------------+---------------
#   P9K_WIFI_SSID         | service set identifier, a.k.a. network name
#   P9K_WIFI_LINK_AUTH    | authentication protocol such as "wpa2-psk" or "none"; empty if unknown
#   P9K_WIFI_LAST_TX_RATE | wireless transmit rate in megabits per second
#   P9K_WIFI_RSSI         | signal strength in dBm, from -120 to 0
#   P9K_WIFI_NOISE        | noise in dBm, from -120 to 0
#   P9K_WIFI_BARS         | signal strength in bars, from 0 to 4 (derived from P9K_WIFI_RSSI and P9K_WIFI_NOISE)

####################################[ time: current time ]####################################
# Current time color.
typeset -g POWERLEVEL9K_TIME_FOREGROUND=66
# Format for the current time: 09:51:02. See `man 3 strftime`.
typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
# If set to true, time will update when you hit enter. This way prompts for the past
# commands will contain the start times of their commands as opposed to the default
# behavior where they contain the end times of their preceding commands.
typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false
# Custom icon.
# typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION='⭐'
# Custom prefix.
# typeset -g POWERLEVEL9K_TIME_PREFIX='%fat '

# Example of a user-defined prompt segment. Function prompt_example will be called on every
# prompt if `example` prompt segment is added to POWERLEVEL9K_LEFT_PROMPT_ELEMENTS or
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS. It displays an icon and orange text greeting the user.
#
# Type `p10k help segment` for documentation and a more sophisticated example.
function prompt_example() {
p10k segment -f 208 -i '⭐' -t 'hello, %n'
}

# User-defined prompt segments may optionally provide an instant_prompt_* function. Its job
# is to generate the prompt segment for display in instant prompt. See
# https://github.com/romkatv/powerlevel10k#instant-prompt.
#
# Powerlevel10k will call instant_prompt_* at the same time as the regular prompt_* function
# and will record all `p10k segment` calls it makes. When displaying instant prompt, Powerlevel10k
# will replay these calls without actually calling instant_prompt_*. It is imperative that
# instant_prompt_* always makes the same `p10k segment` calls regardless of environment. If this
# rule is not observed, the content of instant prompt will be incorrect.
#
# Usually, you should either not define instant_prompt_* or simply call prompt_* from it. If
# instant_prompt_* is not defined for a segment, the segment won't be shown in instant prompt.
function instant_prompt_example() {
# Since prompt_example always makes the same `p10k segment` calls, we can call it from
# instant_prompt_example. This will give us the same `example` prompt segment in the instant
# and regular prompts.
prompt_example
}

# User-defined prompt segments can be customized the same way as built-in segments.
# typeset -g POWERLEVEL9K_EXAMPLE_FOREGROUND=208
# typeset -g POWERLEVEL9K_EXAMPLE_VISUAL_IDENTIFIER_EXPANSION='⭐'

# Transient prompt works similarly to the builtin transient_rprompt option. It trims down prompt
# when accepting a command line. Supported values:
#
#   - off:      Don't change prompt when accepting a command line.
#   - always:   Trim down prompt when accepting a command line.
#   - same-dir: Trim down prompt when accepting a command line unless this is the first command
#               typed after changing current working directory.
typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

# Instant prompt mode.
#
#   - off:     Disable instant prompt. Choose this if you've tried instant prompt and found
#              it incompatible with your zsh configuration files.
#   - quiet:   Enable instant prompt and don't print warnings when detecting console output
#              during zsh initialization. Choose this if you've read and understood
#              https://github.com/romkatv/powerlevel10k#instant-prompt.
#   - verbose: Enable instant prompt and print a warning when detecting console output during
#              zsh initialization. Choose this if you've never tried instant prompt, haven't
#              seen the warning, or if you are unsure what this all means.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

# Hot reload allows you to change POWERLEVEL9K options after Powerlevel10k has been initialized.
# For example, you can type POWERLEVEL9K_BACKGROUND=red and see your prompt turn red. Hot reload
# can slow down prompt by 1-2 milliseconds, so it's better to keep it turned off unless you
# really need it.
typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

# If p10k is already loaded, reload configuration.
# This works even with POWERLEVEL9K_DISABLE_HOT_RELOAD=true.
(( ! $+functions[p10k] )) || p10k reload
}

# Tell `p10k configure` which file it should overwrite.
typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
EOF
}

export PATH=/usr/local/bin:/usr/local/sbin:/opt/homebrew/opt/curl/bin:/bin:/sbin:/usr/bin:/usr/sbin:/opt/homebrew/bin

[[ $(uname) == "Darwin" ]] || {
  echo "This script is for macOS only."
  exit 1
}

[[ ! -x /opt/homebrew/bin/brew ]] && {
  echo "installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
}

option=$1
if [[ $option != "--reinstall" ]] &&  [[ -f ~/.dev-setup/.dev-setup ]]; then
	echo "The dev-setup has already been installed. Do you want to reinstall it? [y/n]"
	read -r redo
	[[ $redo == "y" ]] || exit 0
fi

update_sudoers
install_apps
install_fonts
setup_zsh
setup_p10k
setup_vim
setup_iterm2

# sudo chsh -s /usr/local/bin/zsh $USER
# test if zsh is the default shell
[[ $(dscl . -read /Users/$USER UserShell | awk '{print $2}') == "/opt/homebrew/bin/zsh" ]] || {
  echo "Setting zsh as the default shell"
  sudo dscl . -create /Users/$USER UserShell /opt/homebrew/bin/zsh
}

echo -e "\nQuit Terminal and reopen it to apply the changes.\n"
touch ~/.dev-setup/.dev-setup