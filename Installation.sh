#!/bin/bash

# ITA

install_ITA () {
    clear

    echo "Cosa vuoi fare?
    È consigliato seguire questi step in ordine:
    0) Installa il sistema ed i font;
    1) Installa le applicazioni principali ed imposta lo sfondo (polybar, rofi, picom, ...);
    2) Installa le applicazioni opzionali;
    3) Configura i temi per alcune applicazioni;
    4) Esci."
    read -p "La tua scelta (0-4): " choice

    case $choice in
        
        0)
            system_install_IT
            ;;
        1)
            main_applications_IT
            ;;
        2)
            user_applications_IT
            ;;
        3)
            themes_menu_IT
            ;;
        *)
            exit 0
            ;;
    esac    
}

final_step_IT () {
    clear

    echo "Cosa vuoi fare?
    0) Torna al menu principale;
    1) Riavvia il sistema;
    2) Esci."
    read -p "La tua scelta (0-2): " choice

    case $choice in

        0)
            install_ITA
            ;;
        1)
            sudo reboot
            ;;
        *)
            exit 0
            ;;
    esac
}

system_install_IT () {
    clear

    # TO-DO script risoluzione
    cp -r scripts $HOME
    chmod +x $HOME/scripts/*

    echo "Installo Window Manager, Display Manager (SDDM) e Alacritty..."
    set -x
    sudo pacman -S bspwm sxhkd nitrogen sddm alacritty arandr
    set +x

    printf "\n"
    echo "Abilito il servizio per il Display Manager e copio i suoi file di configurazione..."
    set -x
    sudo systemctl disable display-manager.service
    sudo systemctl enable sddm.service
    set +x

    cp -r alacritty bspwm sxhkd $HOME/.config

    sudo cp system_files/30-touchpad.conf /etc/X11/xorg.conf.d
    sudo chown root:root /etc/X11/xorg.conf.d/30-touchpad.conf

    printf "\n"
    echo "Installo l'AUR helper YAY..."
    git clone https://aur.archlinux.org/yay.git && cd yay
    makepkg -si
    cd ..
    rm -rf yay

    printf "\n"
    echo "Installo i fonts..."
    set -x
    yay -S - < fonts.txt
    set +x
    
    printf "\n"
    printf "Ricordati di installare i Nerd Fonts, Material Icons e SanFranciscoPro.\n
            È consigliato riavviare il sistema."
    printf "\n"
    
    sleep 7

    final_step_IT
}

main_applications_IT () {
    clear

    echo "Installo le applicazioni principali..."
    set -x
    yay -S - < programs.txt
    set +x

    printf "\n"
    echo "Copio i vari file di configurazione..."
    cp -r dunst picom polybar ranger rofi zathura $HOME/.config
    
    sudo chmod +x $HOME/.config/bspwm/layout/layout.sh
    sudo chmod +x $HOME/.config/bspwm/layout/startup.sh
    sudo chmod +x $HOME/.config/dunst/reload.sh
    sudo chmod +x $HOME/.config/polybar/scripts/*
    sudo chmod +x $HOME/.config/polybar/launch.sh
    sudo chmod +x $HOME/.config/rofi/launch.sh

    sleep 5

    printf "\n"
    echo "Imposto lo sfondo..."
    mkdir $HOME/Pictures/Wallpapers
    cp Pink-Floyd-Animals-Expanded.jpg $HOME/Pictures/Wallpapers
    nitrogen --set-auto Pictures/Sfondi/Pink-Floyd-Animals-Expanded.jpg

    sed -i '11,17 s/^#//' $HOME/scripts/startup.sh 
    bspc wm -r

    printf "\n"
    echo "Terminato."

    sleep 7

    final_step_IT
}

user_applications_IT () {
    clear

    echo "Installo le applicazioni utente..."
    set -x
    yay -S - < user_programs.txt
    set +x

    printf "\n"
    echo "Terminato."

    sleep 7

    final_step_IT
}

themes_menu_IT () {
    clear

    echo "Cosa vuoi fare?
    0) Installa Betterdiscord ed imposta il tema Catppuccin-mocha per Discord;
    1) Scarica il tema GTK Catppuccin;
    2) Installa Spicetify ed imposta il tema Catppuccin per Spotify;
    3) Scarica ed imposta il tema Catppuccin per SDDM;
    4) Torna al menu principale;
    5) Esci."
    read -p "La tua scelta (0-5): " choice
    app_themes_IT "$choice"
}

app_themes_IT () {
    clear

    case $choice in

        0)
            set -x
            git clone https://github.com/BetterDiscord/BetterDiscord.git
            mv BetterDiscord $HOME
	    af=$(pwd)
            cd $HOME/BetterDiscord
            sudo npm install -g pnpm
            pnpm install
            pnpm build
	    pnpm inject
            set +x

            cd $af
            echo "Clono il file CSS del tema..."
            wget https://raw.githubusercontent.com/catppuccin/discord/main/themes/mocha.theme.css
            mv mocha.theme.css $HOME/.config/BetterDiscord/themes

            echo "Tema installato correttamente."
            sleep 3
            printf "\n"
            read -p "Tornare al menu precedente? (Y/n)" yn

            if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then
                themes_menu_IT
            elif [ "$yn" = "N" ] || [ "$yn" = "n" ]; then
                final_step
            else
                install_ITA
            fi
            ;;
        1)
            set -x
            wget https://github.com/catppuccin/gtk/releases/download/v-0.2.7/Catppuccin-Mocha-Mauve.zip
            unzip Catppuccin-Mocha-Mauve.zip -d Catppuccin-Mocha-Mauve-dir
            set -x
            mkdir $HOME/.themes
            cp -r Catppuccin-Mocha-Mauve-dir/ Catppuccin-Mocha-Mauve $HOME/.themes

            echo "Tema installato correttamente. Non dimenticare di selezionarlo dal tuo gestore dei temi GTK."
            sleep 3
            printf "\n"
            read -p "Tornare al menu precedente? (Y/n)" yn

            if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then
                themes_menu_IT
            elif [ "$yn" = "N" ] || [ "$yn" = "n" ]; then
                final_step
            else
                install_ITA
            fi
            ;;
        2)
            printf "\n"
            echo "Spicetify richiede i permessi di scrittura e lettura su Spotify"
            sudo chmod a+wr /opt/spotify
            sudo chmod a+wr /opt/spotify/Apps -R

            printf "\n"
            echo "Clono il tema da GitHub..."
            set -x
            git clone https://github.com/catppuccin/spicetify
            set +x
            cp -r spicetify/catppuccin-mocha $HOME/.config/spicetify/Themes/
            cp spicetify/js/catppuccin-mocha.js $HOME/.config/spicetify/Extensions/

            printf "\n"
            echo "Configuro il nuovo tema di Spicetify..."
            set -x
	        spicetify backup apply
            spicetify update
            spicetify config current_theme catppuccin-mocha
            spicetify config color_scheme mauve
            spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
            spicetify config extensions catppuccin-mocha.js
            spicetify apply
            set +x

            printf "\n"
            echo "Tema installato correttamente."
            sleep 3
            printf "\n"
            read -p "Tornare al menu precedente? (Y/n): " yn

            if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then
                themes_menu_IT
            elif [ "$yn" = "N" ] || [ "$yn" = "n" ]; then
                final_step
            else
                install_ITA
            fi
            ;;
        3)
            echo "Clono il tema da GitHub..."
            set -x
            git clone https://github.com/catppuccin/sddm
            set -x
            sudo cp -r sddm/src/catppuccin-mocha/ usr/share/sddm/themes

            printf "\n"
            echo "Imposto il tema per SDDM..."
            sudo cp system_files/SDDM/Xsetup /usr/share/sddm/scripts/
            sudo cp -r system_files/SDDM/default.conf /etc/
            sudo chown root:root /etc/sddm.conf.d/default.conf
            sudo chown root:root /usr/share/sddm/scripts/Xsetup
            echo "Fatto.
            È consigliato riavviare il sistema."

            sleep 3
            printf "\n"
            read -p "Tornare al menu precedente? (Y/n)" yn

            if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then 
                themes_menu_IT
            elif [ "$yn" = "N" ] || [ "$yn" = "n" ]; then
                final_step
            else
                install_ITA
            fi
            ;;
        4)
            install_ITA
            ;;
        *)
            exit 0
            ;;
    esac     
}

# ENG

install_ENG () {
    clear

    echo "What do you want to do?
    Is reccomended to follow these steps in order:
    0) Install the system and fonts;
    1) Install main applications and set the wallpaper (polybar, rofi, picom, ...);
    2) Install optional applications;
    3) Configure the theme for some applications;
    4) Exit."
    read -p "Your choiche (0-4): " choice

    case $choice in

        0)
            system_install_EN
            ;;
        1)
            main_applications_EN
            ;;
        2)
            user_applications_EN
            ;;
        3)
            themes_menu_EN
            ;;
        *)
            exit 0
            ;;
    esac
}

final_step_EN () {
    clear

    echo "What do you want to do?
    0) Back to main menu;
    1) Reboot the system;
    2) Exit."
    read -p "Your choiche (0-2): " choiche

    case $choice in

        0)
            install_ENG
            ;;
        1)
            sudo reboot
            ;;
        *)
            exit 0
            ;;
    esac
}

system_install_EN () {
    clear
    
    cp -r scripts $HOME
    chmod +x $HOME/scripts/*

    echo "Installing Window Manager, Display Manager (SDDM) and Alacritty..."
    set -x
    sudo pacman -S bspwm sxhkd nitrogen sddm alacritty arandr
    set +x

    printf "\n"
    echo "Enabling Display Manager service and copying his conf files..."
    set -x
    sudo systemctl disable display-manager.service
    sudo systemctl enable sddm.service
    set +x

    printf "\n"
    echo "Copying the conf files"
    cp -r alacritty bspwm sxhkd $HOME/.config
    # cp -r Sfondi $HOME/Pictures
    sudo cp system_files/30-touchpad.conf /etc/X11/xorg.conf.d
    sudo chown root:root /etc/X11/xorg.conf.d/30-touchpad.conf

    echo "Installing YAY, the AUR helper..."
    git clone https://aur.archlinux.org/yay.git && cd yay
    makepkg -si
    cd ..
    rm -rf yay

    printf "\n"
    echo "Installing fonts"
    set -x
    yay -S - < fonts.txt
    set +x

    printf "\n"
    echo "You still have to install Nerd Fonts, Material Icons and SanFranciscoPro manually.
    Is reccomended to reboot the system now."
    printf "\n"

    sleep 7

    final_step_EN
}

main_applications_EN () {
    clear

    echo "Installing main applications..."
    set -x
    yay -S - < programs.txt
    set +x

    printf "\n"
    echo "Copying the conf files..."
    cp -r dunst picom polybar ranger rofi zathura $HOME/.config
    
    sudo chmod +x $HOME/.config/bspwm/layout/layout.sh
    sudo chmod +x $HOME/.config/bspwm/layout/startup.sh
    sudo chmod +x $HOME/.config/dunst/reload.sh
    sudo chmod +x $HOME/.config/polybar/scripts/*
    sudo chmod +x $HOME/.config/polybar/launch.sh
    sudo chmod +x $HOME/.config/rofi/launch.sh

    sleep 5

    printf "\n"
    echo "Setting the wallpaper..."
    mkdir $HOME/Pictures/Wallpapers
    cp Pink-Floyd-Animals-Expanded.jpg $HOME/Pictures/Wallpapers
    nitrogen --set-auto Pictures/Sfondi/Pink-Floyd-Animals-Expanded.jpg

    sed -i '11,17 s/^#//' $HOME/scripts/startup.sh 
    bspc wm -r

    printf "\n"
    echo "Terminated."

    sleep 7

    final_step_EN
}

user_applications_EN () {
    clear

    echo "Installing user applications..."
    set -x
    yay -S - < user_programs.txt
    set +x

    printf "\n"
    echo "Terminated."

    sleep 7

    final_step_EN
}

themes_menu_EN () {
    clear

    echo "What do you want to do?
    0) Install Betterdiscord and set the Catppuccin-mocha theme for Discord;
    1) Download the Catppuccin GTK theme;
    2) Install Spicetify and set the Catppuccin theme for Spotify;
    3) Download and set the Catppuccin theme for SDDM;
    4) Back to main menu;
    5) Exit."
    read -p "Your choice (0-5): " choice
    app_themes_EN "$choice"
}

app_themes_EN () {
    clear
    
    case $choice in

        0)
            set -x
            git clone https://github.com/BetterDiscord/BetterDiscord.git
            mv BetterDiscord $HOME
	    af=$(pwd)
            cd $HOME/BetterDiscord
            sudo npm install -g pnpm
	    pnpm install
	    pnpm build
	    pnpm inject
            set +x

            cd $af
            echo "Cloning theme CSS file..."
            wget https://raw.githubusercontent.com/catppuccin/discord/main/themes/mocha.theme.css
            mv mocha.theme.css $HOME/.config/BetterDiscord/themes

            echo "Theme successfully installed."
            sleep 3
            printf "\n"
            read -p "Back to previous menu? (Y/n)" yn

            if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then
                themes_menu_EN
            elif [ "$yn" = "N" ] || [ "$yn" = "n" ]; then
                final_step_EN
            fi
            ;;
        1)
            set -x
            wget https://github.com/catppuccin/gtk/releases/download/v-0.2.7/Catppuccin-Mocha-Mauve.zip
            unzip Catppuccin-Mocha-Mauve.zip -d Catppuccin-Mocha-Mauve-dir
            set -x
            mkdir $HOME/.themes
            cp -r Catppuccin-Mocha-Mauve-dir/ Catppuccin-Mocha-Mauve $HOME/.themes

            echo "Theme successfully installed. Don't forget to select it from your GTK theme manager."
            sleep 3
            printf "\n"
            read -p "Back to previous menu? (Y/n)" yn

            if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then
                rm -rf 
                themes_menu_EN
            elif [ "$yn" = "N" ] || [ "$yn" = "n" ]; then
                final_step_EN
            fi
            ;;
        2)
            echo "Spicetify requires write and read permission on Spotify"
            sudo chmod a+wr /opt/spotify
            sudo chmod a+wr /opt/spotify/Apps -R

            printf "\n"
            echo "Cloning the theme from GitHub..."
            set -x
            git clone https://github.com/catppuccin/spicetify
            set +x
            cp -r spicetify/catppuccin-mocha $HOME/.config/spicetify/Themes/
            cp spicetify/js/catppuccin-mocha.js $HOME/.config/spicetify/Extensions/

            printf "\n"
            echo "Configuring new Spicetify theme..."
	        set -x
	        spicetify backup apply
            spicetify update
            spicetify config current_theme catppuccin-mocha
            spicetify config color_scheme mauve
            spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
            spicetify config extensions catppuccin-mocha.js
            spicetify apply
            set +x
	    
            printf "\n"
            echo "Theme installed succesfully."
            sleep 3
            printf "\n"
            read -p "Back to previous menu? (Y/n)" yn

            if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then
                rm -rf 
                themes_menu_EN
            elif [ "$yn" = "N" ] || [ "$yn" = "n" ]; then
                final_step_EN
            fi
            ;;
        3)
            echo "Cloning the theme from GitHub..."
            set -x
            git clone https://github.com/catppuccin/sddm
            set -x
            sudo cp -r sddm/src/catppuccin-mocha/ /usr/share/sddm/themes/

            printf "\n"
            echo "Setting the theme for SDDM..."
            sudo cp system_files/SDDM/Xsetup /usr/share/sddm/scripts/
            sudo cp -r system_files/SDDM/sddm.conf.d /etc
            sudo chown root:root /etc/sddm.conf.d/default.conf
            sudo chown root:root /usr/share/sddm/scripts/Xsetup
            echo "Done.
            Is suggested to reboot the system."

            sleep 3
            printf "\n"
            read -p "Back to previous menu? (Y/n)" yn

            if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then
                rm -rf 
                themes_menu_EN
            elif [ "$yn" = "N" ] || [ "$yn" = "n" ]; then
                final_step_EN
            fi
            ;;
        4)
            install_ENG
            ;;
        *)
            exit 0
            ;;
    esac
}

# Main function
read -p "Select your language (IT or EN): " language

if [ "$language" = "IT" ] || [ "$language" = "it" ]; then
    install_ITA
elif [ "$language" = "EN" ] || [ "$language" = "en" ]; then
    install_ENG
fi
