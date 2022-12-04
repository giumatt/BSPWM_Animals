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

    cp -r scripts ~
    chmod +x ~/scripts/*

    echo "Installo Window Manager, Display Manager (SDDM) ed Alacritty..."
    set -x
    sudo pacman -S bspwm sxhkd nitrogen sddm alacritty arandr
    set +x

    echo "\n Abilito il servizio per il Display Manager e copio i suoi file di configurazione..."
    set -x
    sudo systemctl enable sddm.service
    set +x

    echo "\n Copio i file di configurazione"
    cp -r alacritty bspwm sxhkd ~/.config
    cp -r Sfondi ~/Pictures
    sudo cp system_files/30-touchpad.conf /etc/X11/xorg.conf.d
    sudo chown root:root /etc/X11/xorg.conf.d/30-touchpad.conf

    echo "Installo l'AUR helper YAY..."
    git clone https://aur.archlinux.org/yay.git && cd yay
    makepkg -si
    cd ../BSPWM_Animals
    rm -rf ~/yay

    echo "\n Installo i fonts"
    set -x
    yay -S - < fonts.txt
    set +x

    echo "\n Ricordati di installare i Nerd Fonts, Material Icons e SanFranciscoPro.\n"

    echo "\n È consigliato riavviare il sistema.\n"

    final_step_IT
}

main_applications_IT () {
    clear

    echo "\n Installo le applicazioni principali..."
    set -x
    yay -S - < programs.txt
    set +x

    echo "\n Copio i file di configurazione"
    cp -r dunst picom polybar ranger rofi zathura ~/.config
    
    sudo chmod +x ~/.config/bspwm/layout/layout.sh
    sudo chmod +x ~/.config/bspwm/layout/startup.sh
    sudo chmod +x ~/.config/dunst/reload.sh
    sudo chmod +x ~/.config/polybar/scripts/*
    sudo chmod +x ~/.config/polybar/launch.sh
    sudo chmod +x ~/.config/rofi/launch.sh

    echo "\n Imposto lo sfondo"
    mkdir $HOME/Pictures/Wallpapers
    cp Pink-Floyd-Animals-Expanded.jpg $HOME/Pictures/Wallpapers
    nitrogen --set-auto Pictures/Sfondi/Pink-Floyd-Animals-Expanded.jpg

    sed -i '11,17 s/^#//' ~/scripts/startup.sh 
    bspc wm -r

    echo "\n Terminato."
    final_step_IT
}

user_applications_IT () {
    clear

    echo "\n Installo le applicazioni utente..."
    set -x
    yay -S - < user_programs.txt
    set +x

    echo "\n Terminato."
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
            mv BetterDiscord ~
            cd ~/BetterDiscord
            npm install
            npm run build
            npm run inject
            set +x

            cd ~/BSPWM_Animals

            echo "Clono il file CSS del tema..."
            wget https://raw.githubusercontent.com/catppuccin/discord/master/Catppuccin.theme.css
            cp Catppuccin.theme.css ~/.config/BetterDiscord/themes

            echo "Tema installato correttamente. \n"
            read -p "Tornare al menu precedente? (Y/n)" yn

            if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then
                themes_menu_IT
            elif [ "$yn" = "N" ] || [ "$yn" = "n" ]; then
                final_step
            fi
            ;;
        1)
            set -x
            wget https://github.com/catppuccin/gtk/releases/download/v-0.2.7/Catppuccin-Mocha-Mauve.zip
            unzip Catppuccin-Mocha-Mauve.zip -d Catppuccin-Mocha-Mauve-dir
            set -x
            mkdir ~/.themes
            cp -r Catppuccin-Mocha-Mauve-dir/ Catppuccin-Mocha-Mauve ~/.themes

            echo "Tema installato correttamente. Non dimenticare di selezionarlo dal tuo gestore dei temi GTK. \n"
            read -p "Tornare al menu precedente? (Y/n)" yn

            if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then
                rm -rf 
                themes_menu_IT
            elif [ "$yn" = "N" ] || [ "$yn" = "n" ]; then
                final_step
            fi
            ;;
        2)
            echo "Installo Spicetify"
            set -x
            curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh
            curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
            set +x 

            echo "Spicetify richiede i permessi di scrittura e lettura su Spotify"
            sudo chmod a+wr /opt/spotify
            sudo chmod a+wr /opt/spotify/Apps -R

            echo "Clono il tema da GitHub..."
            set -x
            git clone https://github.com/catppuccin/spicetify
            set +x
            cp -r spicetify/catppuccin-mocha ~/.config/spicetify/Themes/
            cp spicetify/js/catppuccin-mocha.js ~/.config/spicetify/Extensions/

            echo "Configuro il nuovo tema di Spicetify"
            set -x
            spicetify update
            spicetify config current_theme catppuccin-mocha
            spicetify config color_scheme mauve
            spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
            spicetify config extensions catppuccin-mocha.js
            spicetify apply
            set +x

            echo "Tema installato correttamente. \n"
            read -p "Tornare al menu precedente? (Y/n)" yn

            if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then
                rm -rf 
                themes_menu
            elif [ "$yn" = "N" ] || [ "$yn" = "n" ]; then
                final_step
            fi
            ;;
        3)
            echo "Clono il tema da GitHub..."
            set -x
            git clone https://github.com/catppuccin/sddm
            set -x
            mv sddm Catppuccin
            sudo cp -r Catppuccin /usr/share/sddm/themes

            echo "Imposto il tema per SDDM..."
            sudo rm -rf /usr/lib/sddm/sddm.conf.d/default.conf
            sudo cp system_files/SDDM/Xsetup /usr/share/sddm/scripts/
            sudo cp system_files/SDDM/default.conf /usr/lib/sddm/sddm.conf.d/
            sudo chown root:root /usr/lib/sddm/sddm.conf.d/default.conf
            sudo chown root:root /usr/share/sddm/scripts/Xsetup
            echo "Fatto.
            È consigliato riavviare il sistema."

            read -p "Tornare al menu precedente? (Y/n)" yn

            if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then
                rm -rf 
                themes_menu
            elif [ "$yn" = "N" ] || [ "$yn" = "n" ]; then
                final_step
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
    
    cp -r scripts ~
    chmod +x ~/scripts/*

    echo "Installing Window Manager, Display Manager (SDDM) and Alacritty..."
    set -x
    sudo pacman -S bspwm sxhkd nitrogen sddm alacritty arandr
    set +x

    echo "\n Enabling Display Manager service and copying his conf files..."
    set -x
    sudo systemctl enable sddm.service
    set +x

    echo "\n Copying the conf files"
    cp -r alacritty bspwm sxhkd ~/.config
    cp -r Sfondi ~/Pictures
    sudo cp system_files/30-touchpad.conf /etc/X11/xorg.conf
    sudo chown root:root /etc/X11/xorg.conf.d/30-touchpad.conf

    echo "Installing YAY, the AUR helper..."
    git clone https://aur.archlinux.org/yay.git && cd yay
    makepkg -si
    cd ../BSPWM_Animals
    rm -rf ~/yay

    echo "\n Installing fonts"
    set -x
    yay -S - < fonts.txt
    set +x

    echo "\n You still have to install Nerd Fonts, Material Icons and SanFranciscoPro manually.\n"

    echo "Is reccomended to reboot the system now.\n"

    final_step_EN
}

main_applications_EN () {
    clear

    echo "Installing main applications..."
    set -x
    yay -S - < programs.txt
    set +x

    echo "\n Copying the conf files..."
    cp -r dunst picom polybar ranger rofi zathura ~/.config
    
    sudo chmod +x ~/.config/bspwm/layout/layout.sh
    sudo chmod +x ~/.config/bspwm/layout/startup.sh
    sudo chmod +x ~/.config/dunst/reload.sh
    sudo chmod +x ~/.config/polybar/scripts/*
    sudo chmod +x ~/.config/polybar/launch.sh
    sudo chmod +x ~/.config/rofi/launch.sh

    echo "Setting the wallpaper..."
    mkdir $HOME/Pictures/Wallpapers
    cp Pink-Floyd-Animals-Expanded.jpg $HOME/Pictures/Wallpapers
    nitrogen --set-auto Pictures/Sfondi/Pink-Floyd-Animals-Expanded.jpg

    sed -i '11,17 s/^#//' ~/scripts/startup.sh 
    bspc wm -r

    echo "\n Terminated."
    final_step_EN
}

user_applications_EN () {
    clear

    echo "\n Installing user applications..."
    set -x
    yay -S - < user_programs.txt
    set +x

    echo "\n Terminated."
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
            mv BetterDiscord ~
            cd ~/BetterDiscord
            npm install
            npm run build
            npm run inject
            set +x

            cd ~/BSPWM_Animals

            echo "Cloning theme CSS file..."
            wget https://raw.githubusercontent.com/catppuccin/discord/master/Catppuccin.theme.css
            cp Catppuccin.theme.css ~/.config/BetterDiscord/themes

            echo "Theme successfully installed. \n"
            read -p "Back to previous menu? (Y/n)" yn

            if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then
                themes_menu_EN
            elif [ "$yn" = "N" ] || [ "$yn" = "n" ]; then
                final_step
            fi
            ;;
        1)
            set -x
            wget https://github.com/catppuccin/gtk/releases/download/v-0.2.7/Catppuccin-Mocha-Mauve.zip
            unzip Catppuccin-Mocha-Mauve.zip -d Catppuccin-Mocha-Mauve-dir
            set -x
            mkdir ~/.themes
            cp -r Catppuccin-Mocha-Mauve-dir/ Catppuccin-Mocha-Mauve ~/.themes

            echo "Theme successfully installed. Don't forget to select it from your GTK theme manager. \n"
            read -p "Back to previous menu? (Y/n)" yn

            if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then
                rm -rf 
                themes_menu_EN
            elif [ "$yn" = "N" ] || [ "$yn" = "n" ]; then
                final_step_EN
            fi
            ;;
        2)
            echo "Installing Spicetify...1"
            set -x
            curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh
            curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
            set +x 

            echo "Spicetify requires write and read permission on Spotify"
            sudo chmod a+wr /opt/spotify
            sudo chmod a+wr /opt/spotify/Apps -R

            echo "Cloning the theme from GitHub..."
            set -x
            git clone https://github.com/catppuccin/spicetify
            set +x
            cp -r spicetify/catppuccin-mocha ~/.config/spicetify/Themes/
            cp spicetify/js/catppuccin-mocha.js ~/.config/spicetify/Extensions/

            echo "Configuring new Spicetify theme..."
            set -x
            spicetify update
            spicetify config current_theme catppuccin-mocha
            spicetify config color_scheme mauve
            spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
            spicetify config extensions catppuccin-mocha.js
            spicetify apply
            set +x

            echo "Theme installed succesfully. \n"
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
            mv sddm Catppuccin
            sudo cp -r Catppuccin /usr/share/sddm/themes

            echo "Setting the theme for SDDM..."
            sudo rm -rf /usr/lib/sddm/sddm.conf.d/default.conf
            sudo cp system_files/SDDM/Xsetup /usr/share/sddm/scripts/
            sudo cp system_files/SDDM/default.conf /usr/lib/sddm/sddm.conf.d/
            sudo chown root:root /usr/lib/sddm/sddm.conf.d/default.conf
            sudo chown root:root /usr/share/sddm/scripts/Xsetup
            echo "Done.
            Is suggested to reboot the system."

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

# dj

# Main function
read -p "Select your language (IT or EN): " language

if [ "$language" = "IT" ] || [ "$language" = "it" ]; then
    install_ITA
elif [ "$language" = "EN" ] || [ "$language" = "en" ]; then
    install_ENG
fi