#!/bin/bash

# Author : Anas Hamdane
# Github : AnasHamdane

# This Script Uses playerctl, curl, imagemagick, and hyprctl


CoverReload() {
	Control=spotify
	Cover=/tmp/cover.png
	albumart="$(playerctl --player=$Control metadata mpris:artUrl | sed -e 's/open.spotify.com/i.scdn.co/g')"
	[ $(playerctl --player=$Control metadata mpris:artUrl) ] && curl -s "$albumart" --output $Cover
}

Notify() {
	status=$(playerctl --player=spotify status)
	title=$(playerctl metadata title)
	
	notify-send --app-name="Spotify Control" "Spotify Control" "$status $title" -i /tmp/cover.png
}


PreviousSound() {
	PreviousTest=$(playerctl metadata --format "{{ duration(position) }}")

	if [ "${PreviousTest}" = "0:00" ]; then
		playerctl previous spotify
	else
		playerctl previous spotify
		playerctl previous spotify
	fi

	sleep 1

	CoverReload

	Notify

	Player
}

PlaySound() {
	playerctl play spotify

	sleep 1

	#CoverReload

	Notify

	Player
}


NextSound() {
	playerctl next spotify

	sleep 1

	CoverReload

	Notify

	Player
}


PauseSound() {
	playerctl pause spotify

	sleep 1

	#CoverReload

	Notify

	Player
} 

KillSpotify() {
	killall -9 spotify

	sleep 1

	notify-send --app-name="Spotify Control" "Spotify Control" "Spotify Has Been Killed" -i "$HOME/.config/swaync/icons/Spotify.png"
}



#############################################################################################################################################################

# I made Hide/Unhide function because window managers like hyprland doesn't have a minimize button
# Also I made it using three C Programs that uses hyprctl so if you don't have hyprctl this function WILL NOT WORK
# If You Have another Way To get *Active-workspace/SpotifyID/Spotify-Workspace* try to decode it
Hide_Unhide_Spotify() {
	ActiveWorkspace=$($HOME/.config/rofi/SpotifyController/C-Scripts/GetActiveWorkspace)
	SpotifyID=$($HOME/.config/rofi/SpotifyController/C-Scripts/GetID)
	SpotifyWorkspace=$($HOME/.config/rofi/SpotifyController/C-Scripts/GetSpotifyWorkspace)
	if [ "$SpotifyWorkspace" = "special" ]; then
		hyprctl dispatch movetoworkspacesilent "${ActiveWorkspace},pid:${SpotifyID}"
		notify-send --app-name="Spotify Control" "Spotify Control" -i $HOME/.config/swaync/icons/Spotify.png "Spotify Has Been Unhided"
	else
		hyprctl dispatch movetoworkspacesilent "special,pid:${SpotifyID}"
		notify-send --app-name="Spotify Control" "Spotify Control" -i $HOME/.config/swaync/icons/Spotify.png "Spotify Has Been Hided"
	fi
}

################################################################################################################################################################




Player() {
	status=$(playerctl --player=spotify status)

	CoverReload

	# or Use convert instead of mogrify
	mogrify -resize 500x500 /tmp/cover.png

	title=$(playerctl metadata title)


	# Add Favorite Sounds Configuration
	title=${title%(*}


	if [ "${title}" != "Tohou-Bad Apple " ];then
		title=${title%-*}
	fi

	#test it in terminal With something like this
	#echo "$title"

	themeDIR="$HOME/.config/rofi/SpotifyController"
	SpotifyTheme="Spotify"
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
		echo "Hide/Unhide "
		echo "Kill "
}

# Get spotify pid from hyprlctl
FullPid=$(hyprctl clients | grep -A 4 "class: Spotify" | grep "pid:")
Pid=${FullPid##* }

if [ "${Pid}" = "" ]; then
	# No Spotify Pid Means That Spotify Isn't Running So Run It and wait 1s to avoid bugs
	hyprctl dispatch exec spotify
	sleep 2
	Player
else
	Player
fi