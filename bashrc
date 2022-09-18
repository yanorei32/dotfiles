# shellcheck disable=2148
# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

if [[ -x /usr/bin/dircolors ]]; then
	# shellcheck disable=2015
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

current_uname=$(uname -a)

if [[ $current_uname  == *WSL2* ]]; then
    eval "$(grep -v '^PATH=' /etc/environment | grep -v '^#' | awk '{ print "export " $1 }')"
fi

[[ -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

alias du='du -h'
alias df='df -h'
alias ll='ls -l'
alias la='ls -lA'
alias l='ls'
alias sl='ls'

# shellcheck disable=2155
export GPG_TTY=$(tty)

if type vim > /dev/null 2>&1; then
	alias vi='vim'
	export EDITOR=vim
fi

if type bat > /dev/null 2>&1; then
	alias cat='bat'
fi

# set PATH if user has private ~/.local/bin
if [[ -d $HOME/.local/bin ]]; then
    PATH="$HOME/.local/bin:$PATH"
fi

# set PATH if user has ~/go/bin
if [[ -d $HOME/go/bin ]]; then
    PATH="$HOME/go/bin:$PATH"
fi

if [[ -d $HOME/.cargo/bin ]]; then
	PATH="$HOME/.cargo/bin:$PATH"
fi

export NPM_PACKAGES="$HOME/.npm-packages"
if [[ -d $NPM_PACKAGES ]]; then
	PATH="$NPM_PACKAGES/bin:$PATH"
	MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
	export MANPATH
	NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
	export NODE_PATH
fi

lower_hostname=$(if [[ -e /etc/hostname ]]; then cat /etc/hostname; else hostname; fi | tr '[:upper:]' '[:lower:]')

if [[ $TERM =~ xterm-*(256)color ]]; then
	PS1='\[\033[01;34m\]\w\[\033[00m\]\$ '

	if [[ $current_uname != *Android* ]]; then
		PS1="${debian_chroot:+($debian_chroot) }\[\033[01;32m\]\u@$lower_hostname\[\033[00m\]:$PS1"
	fi
else
	PS1='\w\$ '

	if [[ $current_uname != *Android* ]]; then
		PS1="${debian_chroot:+($debian_chroot) }\u@$lower_hostname:$PS1"
	fi
fi

unset color_prompt

case "$TERM" in
xterm*|rxvt*)
	PS1="\[\e]0;${debian_chroot:+($debian_chroot) }\u@$lower_hostname: \w\a\]$PS1"
	;;
*)
	;;
esac

unset lower_hostname

if [[ $current_uname == *Cygwin* ]]; then
	# Cygwin
	dotnet_dir='/cygdrive/c/Windows/Microsoft.NET/Framework'

	if [[ $current_uname == *x86_64* ]]; then
		dotnet_dir="${dotnet_dir}64/"
	else
		dotnet_dir="${dotnet_dir}/"
	fi
	
	dotnet_flags=' /nologo'

	if [[ ! -x '/bin/cygwin-console-helper.exe' ]]; then
		function wincmd() {
			CMD=$1
			shift
			$CMD "$@" 2>&1 | iconv -f cp932 -t utf-8
		}

		dotnet_flags="$dotnet_flags /utf8output"
	fi

	alias csc2.0="${dotnet_dir}v2.0.50727/csc.exe$dotnet_flags"
	alias csc3.5="${dotnet_dir}v3.5/csc.exe$dotnet_flags"
	alias csc4.0="${dotnet_dir}v4.0.30319/csc.exe$dotnet_flags"

	unset dotnet_dir

	vs_dir='/cygdrive/c/Program Files (x86)/Microsoft Visual Studio/'
	vs_builder_path='/Community/MSBuild/'
	vs_csc_path='/Bin/Roslyn/csc.exe'

	alias csc='csc4.0'

	if [[ -x "${vs_dir}2017${vs_builder_path}15.0" ]]; then
		alias csc2017="\"${vs_dir}2017${vs_builder_path}15.0${vs_csc_path}\" ${dotnet_flags}"
		alias csc='csc2017'
	fi


	if [[ -x "${vs_dir}2019${vs_builder_path}Current" ]]; then
		alias csc2019="\"${vs_dir}2019${vs_builder_path}Current${vs_csc_path}\" ${dotnet_flags}"
		alias csc='csc2019'
	fi

	unset vs_dir
	unset vs_builder_path
	unset vs_csc_path

	unset dotnet_flags
elif [[ $current_uname == *Android* ]]; then
	# termux
	export PATH="${PREFIX}/local/bin:$PATH"
else
	# others
	:
fi

unset current_uname

