#!/bin/bash

# Author : Anas Hamdane
# Github : AnasHamdane

# This Script Uses playerctl, curl, and hyprctl


CoverReload() {
	rm -rf /tmp/cover.png
	Control=spotify
	Cover=/tmp/cover.png
	albumart="$(playerctl --player=$Control metadata mpris:artUrl | sed -e 's/open.spotify.com/i.scdn.co/g')"
	[ $(playerctl --player=$Control metadata mpris:artUrl) ] && curl -s "$albumart" --output $Cover
}


Notify() {

	status=$(playerctl --player=spotify status)
	title=$(playerctl --player=spotify metadata title)
	
	notify-send --app-name="Spotify Control" "Spotify Control" "$status $title" -i /tmp/cover.png

}


PreviousSound() {

	playerctl --player=spotify previous
	playerctl --player=spotify previous

	sleep 0.5s

	CoverReload

	Notify
}

PlaySound() {

	playerctl --player=spotify play

	sleep 0.5s

	Notify
}


NextSound() {

	playerctl --player=spotify next

	sleep 0.5s

	CoverReload

	Notify
}


PauseSound() {

	playerctl --player=spotify pause

	sleep 0.5s

	Notify
} 

KillSpotify() {

	killall -9 spotify

	sleep 0.4s

	notify-send --app-name="Spotify Control" "Spotify Control" "Spotify Has Been Killed" -i "$HOME/.config/swaync/icons/Spotify.png"
}


# I made Hide/Unhide function because window managers like hyprland doesn't have a minimize button
Hide_Unhide_Spotify() {

	tmp=$(hyprctl activeworkspace)
	ActiveWorkspace=$(echo $tmp | sed 's@^[^0-9]*\([0-9]\+\).*@\1@')
	
	SpotifyWorkspace=$(hyprctl clients | grep -B 4 "class: Spotify" | grep "workspace:" | sed 's@^[^0-9]*\([0-9]\+\).*@\1@')
	if [[ $SpotifyWorkspace -gt 10 || $SpotifyWorkspace -lt 0 ]]; then
		SpotifyWorkspace="special"
	fi
	
	SpotifyID=$(hyprctl clients | grep -A 4 "class: Spotify" | grep "pid:" | sed 's@^[^0-9]*\([0-9]\+\).*@\1@')
	
	if [ "$SpotifyWorkspace" = "special" ]; then
		hyprctl dispatch movetoworkspacesilent "${ActiveWorkspace},pid:${SpotifyID}"
		notify-send --app-name="Spotify Control" "Spotify Control" -i $HOME/.config/swaync/icons/Spotify.png "Spotify Has Been Unhided"
	else
		hyprctl dispatch movetoworkspacesilent "special,pid:${SpotifyID}"
		notify-send --app-name="Spotify Control" "Spotify Control" -i $HOME/.config/swaync/icons/Spotify.png "Spotify Has Been Hided"
	fi
	
}

Lyrics() {

	# Detect monitor resolution and scale
	x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
	y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
	hypr_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')

	# Calculate width and height based on percentages and monitor resolution
	width=$((x_mon * hypr_scale / 100))
	height=$((y_mon * hypr_scale / 100))

	# Set maximum width and height
	max_width=1200
	max_height=1000

	# Set percentage of screen size for dynamic adjustment
	percentage_width=50
	percentage_height=70

	# Calculate dynamic width and height
	dynamic_width=$((width * percentage_width / 100))
	dynamic_height=$((height * percentage_height / 100))
	# Limit width and height to maximum values
	dynamic_width=$(($dynamic_width > $max_width ? $max_width : $dynamic_width))
	dynamic_height=$(($dynamic_height > $max_height ? $max_height : $dynamic_height))

	Title=$(playerctl --player=spotify metadata --format {{title}})
	Artist=$(playerctl --player=spotify metadata --format {{artist}})

	URL="https://api.lyrics.ovh/v1/$Artist/$Title"
	curl -s "$( echo "$URL" | sed s/" "/%20/g | sed s/"&"/%26/g | sed s/,/%2C/g | sed s/-/%2D/g)" | jq '.lyrics' > /tmp/lyrics
	[ -z $(cat /tmp/lyrics) ] &&  curl -s --get "https://makeitpersonal.co/lyrics" --data-urlencode "artist=$Artist" --data-urlencode "title=$Title" > /tmp/lyrics
	[ "$(cat /tmp/lyrics)" = "null" ] && curl -s --get "https://makeitpersonal.co/lyrics" --data-urlencode "artist=$Artist" --data-urlencode "title=$Title" > /tmp/lyrics

	# Apply New Line "\n"
	lyrics_text=$(cat /tmp/lyrics | sed 's/\\n/\n/g' | sed 's/\\r//g')

	if [ "$lyrics_text" = "Invalid params" ]; then
		notify-send --app-name="Spotify Control" "Spotify Control" "Lyrics Not Found :(" -i "$HOME"/.config/swaync/icons/warning.png
		return;
	fi

	# Remove Other "\"
	lyrics_text=${lyrics_text//"\\"/}

	first_word="${lyrics_text%% *}"

	if [ "$first_word" = "\"Paroles" ]; then

		# Restore The file
		rm -rf /tmp/lyrics
		touch /tmp/lyrics

		# Remove The First Line
		echo "$lyrics_text" > /tmp/lyrics && sed -i '1d' /tmp/lyrics

		# Restore The Lyrics After Removing The First Line
		lyrics_text=$(cat /tmp/lyrics)
	else
		# Remove The First Character (")
		lyrics_text="${lyrics_text:1}"
	fi

	# Create A New *Custom* First Line
	FirstLine="$Title  -  $Artist\n------------------------------------------\n"
	lyrics_text=$(echo "$FirstLine$lyrics_text" | sed 's/\\n/\n/g')

	# Remove The Last Character (")
	lyrics_text=${lyrics_text::-1}

	# Create html code
	lyrics_html=$(echo "$lyrics_text" | awk '{print "<div align=\"center\">" $0 "</div>"}')

	# Create html File And Add Some Customization
	touch /tmp/lyrics.html
	echo "<html><head><style>body { background-color: #191d25; color: #61AFEF; font: italic 28px "Fira Sans", serif; }</style></head><body>$lyrics_html</body></html>" > "/tmp/lyrics.html"

	# Be Sure That --html works if it's not, install libwebkit and reinstall yad from the source code in github
	yad --width=$dynamic_width --height=$dynamic_height --no-buttons --html --uri="file:///tmp/lyrics.html"

	# Removing The File
	rm -rf /tmp/lyrics.html
}

Player() {
	
	status=$(playerctl --player=spotify status)

	CoverReload

	title=$(playerctl --player=spotify metadata title)

	CharNum=$(echo -n $title | wc -m)

	if [ $CharNum -ge 30 ]; then
		title=$(echo "$title" | cut -c1-28)
		title="$title..."
	fi

	themeDIR="$HOME/.config/rofi/Spotify-Controller"
	SpotifyTheme="theme"

	choice=$( (PlayerOptions) | rofi -dmenu -i -fuzzy -p "$title"  -theme ${themeDIR}/${SpotifyTheme}.rasi)

	case "$choice" in
		' Previous Sound')
			PreviousSound
			;;
		' Play')
			PlaySound
			;;
		' Next Sound')
			NextSound
			;;
		'Hide/Unhide ')
			Hide_Unhide_Spotify
			;;
		'Kill ')
			KillSpotify
			;;
		' Pause')
			PauseSound
			;;
		'Open Lyrics ')
			Lyrics
			;;
	esac
}

PlayerOptions() {
	status=$(playerctl --player=spotify status)
		echo " Previous Sound"

		if [ "${status}" = "Paused" ]; then
			echo " Play"
		elif [ "${status}" = "Playing" ]; then
			echo " Pause"
		fi

		echo " Next Sound"
		echo "Open Lyrics "
		echo "Hide/Unhide "
		echo "Kill "
}

# Get spotify pid from hyprlctl
FullPid=$(hyprctl clients | grep -A 4 "class: Spotify" | grep "pid:")
Pid=${FullPid##* }

if [ "${Pid}" = "" ]; then
	# No Spotify Pid Means That Spotify Isn't Running So Run It and wait 1s to avoid bugs
	spotify &
	sleep 0.5s
	Player
else
	Player
fi