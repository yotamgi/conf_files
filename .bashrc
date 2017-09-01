# /etc/bashrc

# System wide functions and aliases
# Environment stuff goes in /etc/profile

if [ -f /auto/sw_system_project/devops/common/bashrc ]; then
	.  /auto/sw_system_project/devops/common/bashrc
fi

# are we an interactive shell?
if [ "$PS1" ]; then
  if [ -z "$PROMPT_COMMAND" ]; then
    case $TERM in
	xterm*)
		if [ -e /etc/sysconfig/bash-prompt-xterm ]; then
			PROMPT_COMMAND=/etc/sysconfig/bash-prompt-xterm
		else
            PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
		fi
		;;
	screen)
		if [ -e /etc/sysconfig/bash-prompt-screen ]; then
			PROMPT_COMMAND=/etc/sysconfig/bash-prompt-screen
		else
            PROMPT_COMMAND='printf "\033]0;%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
		fi
		;;
	*)
		[ -e /etc/sysconfig/bash-prompt-default ] && PROMPT_COMMAND=/etc/sysconfig/bash-prompt-default
	    ;;
    esac
  fi
  # Turn on checkwinsize
  shopt -s checkwinsize
  [ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u@\h \W]\\$ "
fi

if ! shopt -q login_shell ; then # We're not a login shell
	# Need to redefine pathmunge, it get's undefined at the end of /etc/profile
    pathmunge () {
		if ! echo $PATH | /bin/egrep -q "(^|:)$1($|:)" ; then
			if [ "$2" = "after" ] ; then
				PATH=$PATH:$1
			else
				PATH=$1:$PATH
			fi
		fi
	}

    # By default, we want umask to get set. This sets it for non-login shell.
    # You could check uidgid reservation validity in
    # /usr/share/doc/setup-*/uidgid file
    if [ $UID -gt 99 ] && [ "`id -gn`" = "`id -un`" ]; then
       umask 002
    else
       umask 022
    fi

	# Only display echos from profile.d scripts if we are no login shell
    # and interactive - otherwise just process them to set envvars
    for i in /etc/profile.d/*.sh; do
        if [ -r "$i" ]; then
            if [ "$PS1" ]; then
                . $i
            else
                . $i >/dev/null 2>&1
            fi
        fi
    done

	unset i
	unset pathmunge
fi

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

function cscope_build_db {
	find . -name "*.[ch]" > ./cscope_files
	cscope -b -q -k `cat ./cscope_files`
	touch .cscope_externals

    # create cscope_externals in all directories
    pwd > ./cs_extrn.tmp
    find * -type d -exec cp ./cs_extrn.tmp  {}/.cscope_externals  \;
    rm cs_extrn.tmp
}

alias qstat='/mswg/utils/bin/new_qstat/qstat.sh'
alias dtk='/mtrsysgwork/yotamg/sx_fit_regression/devtk/dev-tk.py'

if [ -f /etc/bash_completion.d/git ]; then
    . /etc/bash_completion.d/git
fi

alias ll="ls --color -l"
alias ls="ls --color"

alias ns1="sudo ip netns exec ns1"
alias ns2="sudo ip netns exec ns2"

alias rebase="git rebase --autostash --autosquash -i"
alias cont="git rebase --continue"

# vim:ts=4:sw=4
