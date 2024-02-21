#!/bin/bash

main() {
    clear
    echo -e "Welcome to the MacSploit Experience!"
    echo -e "Install Script Version 2.2"
    
    echo -ne "Checking License..."
    curl -s "https://git.abyssdigital.xyz/sellix/hwid" -o "./hwid"
    chmod +x ./hwid
    
    local user_hwid=$(./hwid)
    local hwid_resp=$(curl -s "https://git.abyssdigital.xyz/api/whitelist?hwid=$user_hwid")
    rm ./hwid
    
    if [ "$hwid_resp" != "{\"success\":true,\"message\":\"Whitelist check complete.\"}" ]
    then
        echo -ne "\rEnter License Key:       \b\b\b\b\b\b"
        read input_key

        echo -n "Contacting Secure Api... "
        
        local resp=$(curl -s "https://git.abyssdigital.xyz/api/sellix?key=$input_key&hwid=$user_hwid")
        echo -e "Done.\n$resp"
        
        if [ "$resp" != 'Key Activation Complete!' ]
        then
            exit
            return
        fi
    else
        echo -e " Done.\nWhitelist Status Verified."
    fi

    echo -n "Downloading JSON Parser... "
    curl -s "https://cdn.discordapp.com/attachments/1000184107281690696/1154250203650605107/jq-macos-amd64" -o "./jq"
    chmod +x ./jq
    echo -e "Done."

    echo -e "Downloading Latest Roblox..."
    [ -f ./RobloxPlayer.zip ] && rm ./RobloxPlayer.zip
    curl "https://setup.rbxcdn.com/mac/version-02b4c0594723475b-RobloxPlayer.zip" -o "./RobloxPlayer.zip"
    rm ./jq

    echo -n "Installing Latest Roblox... "
    [ -d "/Applications/Roblox.app" ] && rm -rf "/Applications/Roblox.app"
    unzip -o -q "./RobloxPlayer.zip"
    mv ./RobloxPlayer.app /Applications/Roblox.app
    rm ./RobloxPlayer.zip
    echo -e "Done."

    echo -e "Downloading MacSploit..."
    curl "https://git.abyssdigital.xyz/main/macsploit.zip" -o "./MacSploit.zip"

    echo -n "Installing MacSploit... "
    unzip -o -q "./MacSploit.zip"
    echo -e "Done."

    echo -e "Patching Roblox..."
    mv ./macsploit.dylib "/Applications/Roblox.app/Contents/MacOS/macsploit.dylib"
    ./insert_dylib "/Applications/Roblox.app/Contents/MacOS/macsploit.dylib" "/Applications/Roblox.app/Contents/MacOS/RobloxPlayer" --strip-codesig --all-yes
    mv "/Applications/Roblox.app/Contents/MacOS/RobloxPlayer_patched" "/Applications/Roblox.app/Contents/MacOS/RobloxPlayer"
    rm ./insert_dylib

    echo -n "Installing MacSploit App... "
    [ -d "/Applications/MacSploit.app" ] && rm -rf "/Applications/MacSploit.app"
    mv ./MacSploit.app /Applications/MacSploit.app
    rm ./MacSploit.zip
    echo -e "Done."

    echo -e "Install Complete! Developed by Nexus42!"
    exit
}

main
