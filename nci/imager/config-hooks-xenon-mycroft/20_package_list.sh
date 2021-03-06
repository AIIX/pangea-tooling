# konsole needs installed first else xterm gets installed cos xorg deps on
# terminal | xterm and doesn't know terminal is installed later in the tree
cat << EOF > config/package-lists/ubuntu-defaults.list.chroot_install
calamares-settings-mycroft
konsole
plasma-minishell
mycroft-gui
mycroft-core
mycroft-skill-installer
mycroft-settings
breeze
fonts-hack-ttf
fonts-noto-hinted
gstreamer1.0-plugins-good
gstreamer1.0-plugins-bad
gstreamer1.0-plugins-ugly
gstreamer1.0-fluendo-mp3
gstreamer1.0-libav
gstreamer1.0-vaapi
konsole
kde-cli-tools
khotkeys
kio-extras
kwin
libsasl2-modules
libu2f-udev
neon-hardware-integration
neon-keyring
neon-settings
oxygen-sounds
plasma-nm
plasma-pa
plasma-widgets-addons
plasma-workspace-wallpapers
plasma-workspace-wayland
pm-utils
powerdevil
polkit-kde-agent-1
qml-module-org-kde-lottie
r8168-dkms
sddm
sddm-theme-breeze
software-properties-common
systemsettings
ubuntu-drivers-common
unzip
upower
wireless-tools
wpasupplicant
xdg-user-dirs
xkb-data
xorg
xserver-xorg-video-intel-arbiter
xserver-xorg-input-evdev
xserver-xorg-input-synaptics
xserver-xorg-video-intel-native-modesetting
grub-efi-ia32-bin
zip
EOF
