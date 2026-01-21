#!/bin/bash

#===============================================================================
#  NEW MAC SETUP SCRIPT
#  Author: Nicolas Martin
#  Description: Automated installation of development tools
#
#  Usage:
#    ./setup-new-mac.sh           # Run the full setup
#    ./setup-new-mac.sh --dry-run # Simulate without executing
#===============================================================================

# Parse arguments
DRY_RUN=false
for arg in "$@"; do
    case $arg in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
    esac
done

if [ "$DRY_RUN" = false ]; then
    set -e  # Exit on error (only in real mode)
fi

# Colors for logging
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_dry() { echo -e "${CYAN}[DRY-RUN]${NC} Would execute: $1"; }

# Execute or simulate command
run() {
    if [ "$DRY_RUN" = true ]; then
        log_dry "$*"
        return 0
    else
        "$@"
    fi
}

# Check if command exists (works in both modes)
cmd_exists() {
    command -v "$1" &>/dev/null
}

#===============================================================================
#  1. XCODE COMMAND LINE TOOLS
#===============================================================================
install_xcode_tools() {
    log_info "Installing Xcode Command Line Tools..."
    if xcode-select -p &>/dev/null; then
        log_success "Xcode Command Line Tools already installed"
    else
        run xcode-select --install
        if [ "$DRY_RUN" = false ]; then
            log_warning "Press Enter once installation is complete..."
            read -r
        fi
    fi
}

#===============================================================================
#  2. HOMEBREW
#===============================================================================
install_homebrew() {
    log_info "Installing Homebrew..."
    if cmd_exists brew; then
        log_success "Homebrew already installed"
    else
        if [ "$DRY_RUN" = true ]; then
            log_dry "curl + install Homebrew"
            log_dry "echo 'eval \"\$(/opt/homebrew/bin/brew shellenv)\"' >> ~/.zprofile"
        else
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi
    run brew update
}

#===============================================================================
#  3. HOMEBREW FORMULAE (CLI Tools)
#===============================================================================
install_brew_formulae() {
    log_info "Installing Homebrew formulae..."

    # === ESSENTIALS ===
    ESSENTIALS=(
        git
        gh              # GitHub CLI
        stow            # Dotfiles manager
        wget
        curl
        jq              # JSON parser
    )

    # === SHELL & TERMINAL ===
    SHELL_TOOLS=(
        zsh
        tmux
        fzf             # Fuzzy finder
        ripgrep         # Fast search (rg)
        fd              # Alternative to find
        eza             # Alternative to ls with icons
        zoxide          # Smarter cd
        lazygit         # Git TUI
        bat             # Alternative to cat
        tree
    )

    # === EDITORS ===
    EDITORS=(
        neovim
    )

    # === LANGUAGES & RUNTIMES ===
    LANGUAGES=(
        nvm             # Node Version Manager
        python@3.12
        go
    )

    # === FLUTTER/MOBILE ===
    MOBILE_DEV=(
        cocoapods
        scrcpy          # Android mirroring
    )

    # === DATABASES ===
    DATABASES=(
        postgresql@15
    )

    # === QMK (Custom Keyboards) ===
    QMK_TOOLS=(
        qmk
    )

    # === WINDOW MANAGER ===
    WINDOW_MANAGER=(
        borders         # Window borders
    )

    # === ZSH PLUGINS ===
    ZSH_PLUGINS=(
        powerlevel10k
        zsh-autosuggestions
        zsh-syntax-highlighting
    )

    # Install all formulae
    ALL_FORMULAE=(
        "${ESSENTIALS[@]}"
        "${SHELL_TOOLS[@]}"
        "${EDITORS[@]}"
        "${LANGUAGES[@]}"
        "${MOBILE_DEV[@]}"
        "${DATABASES[@]}"
        "${QMK_TOOLS[@]}"
        "${WINDOW_MANAGER[@]}"
        "${ZSH_PLUGINS[@]}"
    )

    for formula in "${ALL_FORMULAE[@]}"; do
        if [ "$DRY_RUN" = false ] && brew list "$formula" &>/dev/null; then
            log_success "$formula already installed"
        else
            log_info "Installing $formula..."
            run brew install "$formula" || log_warning "Failed to install $formula"
        fi
    done
}

#===============================================================================
#  4. APPLICATIONS (Homebrew Cask)
#===============================================================================
install_cask_apps() {
    log_info "Installing applications..."

    CASK_APPS=(
        # Development
        visual-studio-code
        docker
        insomnia
        gitkraken
        pgadmin4
        android-studio
        jetbrains-toolbox

        # Terminal & Window Manager
        alacritty
        aerospace

        # Productivity
        raycast
        1password

        # Communication
        slack
        discord
        whatsapp

        # Utilities
        nordvpn
        cleanmymac
        qmk-toolbox       # QMK keyboard flasher

        # Browser
        brave-browser

        # Fonts
        font-hack-nerd-font
        font-sf-pro
        sf-symbols
    )

    # Add required taps
    run brew tap homebrew/cask-fonts 2>/dev/null || true
    run brew tap nikitabobko/tap 2>/dev/null || true  # For AeroSpace

    for app in "${CASK_APPS[@]}"; do
        if [ "$DRY_RUN" = false ] && brew list --cask "$app" &>/dev/null; then
            log_success "$app already installed"
        else
            log_info "Installing $app..."
            run brew install --cask "$app" || log_warning "Failed to install $app"
        fi
    done
}

#===============================================================================
#  5. OH-MY-ZSH
#===============================================================================
install_oh_my_zsh() {
    log_info "Installing Oh My Zsh..."
    if [ -d "$HOME/.oh-my-zsh" ]; then
        log_success "Oh My Zsh already installed"
    else
        if [ "$DRY_RUN" = true ]; then
            log_dry "curl + install Oh My Zsh"
        else
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        fi
    fi

    # Install custom plugins
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # zsh-autosuggestions
    if [ "$DRY_RUN" = true ] || [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        run git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    fi

    # zsh-syntax-highlighting
    if [ "$DRY_RUN" = true ] || [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        run git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    fi

    # Powerlevel10k theme
    if [ "$DRY_RUN" = true ] || [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        run git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    fi

    log_success "Oh My Zsh configured"
}

#===============================================================================
#  6. DOTFILES (with Stow)
#===============================================================================
setup_dotfiles() {
    log_info "Setting up dotfiles..."

    DOTFILES_REPO="https://github.com/Volgar04/dotfiles.git"
    DOTFILES_DIR="$HOME/dotfiles"

    if [ -d "$DOTFILES_DIR" ]; then
        log_info "Updating dotfiles..."
        run git -C "$DOTFILES_DIR" pull
    else
        log_info "Cloning dotfiles..."
        run git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    fi

    # Apply dotfiles with stow
    log_info "Applying dotfiles with stow..."

    if [ "$DRY_RUN" = true ]; then
        log_dry "cd $DOTFILES_DIR && stow --restow <each-config-folder>"
    else
        cd "$DOTFILES_DIR"
        for config in */; do
            config_name="${config%/}"
            log_info "Stow: $config_name"
            stow -v --restow "$config_name" 2>/dev/null || log_warning "Issue with $config_name"
        done
        cd "$HOME"
    fi

    log_success "Dotfiles configured"
}

#===============================================================================
#  7. RUST (via rustup)
#===============================================================================
install_rust() {
    log_info "Installing Rust..."
    if cmd_exists rustc; then
        log_success "Rust already installed ($(rustc --version))"
    else
        if [ "$DRY_RUN" = true ]; then
            log_dry "curl + install Rust via rustup"
        else
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
            source "$HOME/.cargo/env"
        fi
    fi

    # Install essential Cargo packages
    log_info "Installing Cargo packages..."
    [ "$DRY_RUN" = false ] && source "$HOME/.cargo/env" 2>/dev/null || true

    CARGO_PACKAGES=(
        create-tauri-app
        sqlx-cli
    )

    for pkg in "${CARGO_PACKAGES[@]}"; do
        if [ "$DRY_RUN" = false ] && cargo install --list | grep -q "^$pkg"; then
            log_success "$pkg already installed"
        else
            log_info "Installing $pkg..."
            run cargo install "$pkg" || log_warning "Failed to install $pkg"
        fi
    done
}

#===============================================================================
#  7b. GO TOOLS
#===============================================================================
install_go_tools() {
    log_info "Installing Go tools..."

    GO_PACKAGES=(
        golang.org/x/tools/gopls@latest           # Language server
        github.com/go-delve/delve/cmd/dlv@latest  # Debugger
        golang.org/x/tools/cmd/goimports@latest   # Import formatter
        mvdan.cc/gofumpt@latest                   # Strict formatter
    )

    for pkg in "${GO_PACKAGES[@]}"; do
        log_info "Installing $pkg..."
        run go install "$pkg" || log_warning "Failed to install $pkg"
    done

    log_success "Go tools installed"
}

#===============================================================================
#  8. FLUTTER
#===============================================================================
install_flutter() {
    log_info "Installing Flutter..."

    FLUTTER_DIR="$HOME/development/flutter"

    if [ -d "$FLUTTER_DIR" ]; then
        log_success "Flutter already installed"
    else
        run mkdir -p "$HOME/development"
        run git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_DIR"
    fi

    # Add to PATH if not already done
    if ! grep -q "flutter/bin" "$HOME/.zshrc" 2>/dev/null; then
        if [ "$DRY_RUN" = true ]; then
            log_dry "Add Flutter to PATH in .zshrc"
        else
            echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >> "$HOME/.zshrc"
        fi
    fi

    log_success "Flutter configured"
    log_info "Don't forget to run 'flutter doctor' after setup"
}

#===============================================================================
#  9. NODE.JS (via nvm)
#===============================================================================
setup_node() {
    log_info "Setting up Node.js via nvm..."

    if [ "$DRY_RUN" = true ]; then
        log_dry "source nvm.sh"
        log_dry "nvm install --lts"
        log_dry "nvm alias default 'lts/*'"
        log_dry "npm install -g pnpm"
        log_dry "npm install -g @anthropic-ai/claude-code"
    else
        export NVM_DIR="$HOME/.nvm"
        [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

        # Install latest LTS
        nvm install --lts
        nvm use --lts
        nvm alias default 'lts/*'

        # Install pnpm
        npm install -g pnpm

        # Essential global packages
        npm install -g @anthropic-ai/claude-code
    fi

    log_success "Node.js configured"
}

#===============================================================================
#  10. VS CODE EXTENSIONS
#===============================================================================
install_vscode_extensions() {
    log_info "Installing VS Code extensions..."

    EXTENSIONS=(
        anthropic.claude-code
        vscodevim.vim
        dart-code.dart-code
        dart-code.flutter
        felixangelov.bloc
        rust-lang.rust-analyzer
        tauri-apps.tauri-vscode
        keifererikson.nightfox
    )

    for ext in "${EXTENSIONS[@]}"; do
        run code --install-extension "$ext" --force 2>/dev/null || log_warning "Failed: $ext"
    done

    log_success "VS Code extensions installed"
}

#===============================================================================
#  11. MACOS CONFIGURATION
#===============================================================================
configure_macos() {
    log_info "Configuring macOS preferences..."

    # Show hidden files in Finder
    run defaults write com.apple.finder AppleShowAllFiles -bool true

    # Show file extensions
    run defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Disable key repeat delay (useful for Vim)
    run defaults write NSGlobalDomain KeyRepeat -int 2
    run defaults write NSGlobalDomain InitialKeyRepeat -int 15

    # Dock: reduce size and enable auto-hide
    run defaults write com.apple.dock tilesize -int 48
    run defaults write com.apple.dock autohide -bool true

    # Restart affected apps
    if [ "$DRY_RUN" = false ]; then
        killall Finder 2>/dev/null || true
        killall Dock 2>/dev/null || true
    else
        log_dry "killall Finder && killall Dock"
    fi

    log_success "macOS preferences configured"
}

#===============================================================================
#  12. JAVA CONFIGURATION (for Android Studio)
#===============================================================================
setup_java() {
    log_info "Setting up Java..."

    # Install Java 17 via Homebrew if not present
    if [ "$DRY_RUN" = false ] && ! brew list openjdk@17 &>/dev/null; then
        run brew install openjdk@17
    elif [ "$DRY_RUN" = true ]; then
        run brew install openjdk@17
    fi

    # Create symlink for the system
    if [ "$DRY_RUN" = true ]; then
        log_dry "sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk"
    else
        sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk 2>/dev/null || true
    fi

    log_success "Java 17 configured"
}

#===============================================================================
#  13. GIT CONFIGURATION
#===============================================================================
setup_git_config() {
    log_info "Configuring Git..."

    run git config --global user.name "Nicolas"
    run git config --global user.email "nicolasmartin0404@gmail.com"
    run git config --global init.defaultBranch main
    run git config --global core.editor "nvim"
    run git config --global pull.rebase false

    log_success "Git configured"
}

#===============================================================================
#  14. CREATE WORK DIRECTORIES
#===============================================================================
create_directories() {
    log_info "Creating work directories..."

    DIRECTORIES=(
        "$HOME/Documents/dev"
        "$HOME/projects"
    )

    for dir in "${DIRECTORIES[@]}"; do
        if [ "$DRY_RUN" = false ] && [ -d "$dir" ]; then
            log_success "$dir already exists"
        else
            run mkdir -p "$dir"
            [ "$DRY_RUN" = false ] && log_success "Created $dir"
        fi
    done
}

#===============================================================================
#  15. ANDROID SDK SETUP
#===============================================================================
setup_android() {
    log_info "Setting up Android SDK..."

    # Add Android paths to zshrc if not present
    if ! grep -q "ANDROID_HOME" "$HOME/.zshrc" 2>/dev/null; then
        if [ "$DRY_RUN" = true ]; then
            log_dry "Add ANDROID_HOME and paths to .zshrc"
        else
            cat >> "$HOME/.zshrc" << 'EOF'

# Android SDK
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
EOF
        fi
    fi

    # Accept Android licenses (requires Android Studio to be installed first)
    if [ "$DRY_RUN" = true ]; then
        log_dry "sdkmanager --licenses (accept Android licenses)"
    elif [ -d "$HOME/Library/Android/sdk" ]; then
        yes | "$HOME/Library/Android/sdk/cmdline-tools/latest/bin/sdkmanager" --licenses 2>/dev/null || true
    fi

    log_success "Android SDK configured"
}

#===============================================================================
#  MAIN
#===============================================================================
main() {
    echo ""
    echo "======================================================================="
    echo "            NEW MAC SETUP - Nicolas Martin                             "
    echo "======================================================================="

    if [ "$DRY_RUN" = true ]; then
        echo ""
        echo -e "${CYAN}>>> DRY-RUN MODE: No changes will be made <<<${NC}"
    fi
    echo ""

    install_xcode_tools
    install_homebrew
    install_brew_formulae
    install_cask_apps
    install_oh_my_zsh
    setup_dotfiles
    install_rust
    install_go_tools
    install_flutter
    setup_node
    setup_java
    setup_git_config
    create_directories
    setup_android
    install_vscode_extensions
    configure_macos

    echo ""
    echo "======================================================================="
    echo "                       SETUP COMPLETE!                                 "
    echo "======================================================================="
    echo ""
    log_info "Next steps:"
    echo "  1. Restart your terminal (or run: source ~/.zshrc)"
    echo "  2. Run 'p10k configure' to setup Powerlevel10k"
    echo "  3. Run 'flutter doctor' to verify Flutter"
    echo "  4. Open Android Studio and complete initial setup"
    echo "  5. Copy your SSH keys to ~/.ssh and run: ssh-add ~/.ssh/id_ed25519"
    echo "  6. Run 'gh auth login' to authenticate GitHub CLI"
    echo ""
    log_info "Manual downloads required:"
    echo "  - Screen Studio: https://www.screen.studio"
    echo "  - ONLYOFFICE: https://www.onlyoffice.com/download-desktop.aspx"
    echo ""
    log_info "Licenses & accounts to configure:"
    echo "  - 1Password: Sign in to your account"
    echo "  - JetBrains Toolbox: Sign in for IDE licenses"
    echo "  - CleanMyMac: Enter license key"
    echo "  - NordVPN: Sign in to your account"
    echo "  - Raycast: Sign in to sync settings"
    echo "  - Docker: Sign in (optional)"
    echo "  - Screen Studio: Enter license key"
    echo ""
}

# Run the script
main "$@"
