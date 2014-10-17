function fish_prompt --description 'Write out the prompt'
	
    # Check for tmux session
    if set -q TMUX
        set -l TMUX_STATUS_LOCATION "right"
        #REPO
        set -l GIT_REPO (basename (git rev-parse --show-toplevel) 2>/dev/null) 
        if set -q GIT_REPO
            #BRANCH
            set -l GIT_BRANCH (git symbolic-ref HEAD | sed "s/^refs\/heads\///")
            #DIRTY
            set -l GIT_STATUS (git status --porcelain 2> /dev/null)
            if set -q GIT_STATUS
                set -l GIT_DIRTY "1" 
            end

            #SETTING
            set -l TMUX_STATUS "$GIT_REPO:$GIT_BRANCH"
          
            if set -q GIT_DIRTY 
                tmux set-window-option status-$TMUX_STATUS_LOCATION-attr bright > /dev/null
            else
                tmux set-window-option status-$TMUX_STATUS_LOCATION-attr none > /dev/null
            end
                
            tmux set-window-option status-$TMUX_STATUS_LOCATION "$TMUX_STATUS" > /dev/null            

         else
                tmux set-window-option status-$TMUX_STATUS_LOCATION-attr none > /dev/null
                tmux set-window-option status-$TMUX_STATUS_LOCATION "no git" > /dev/null
         end
    end

    set -l last_status $status

    set -l last_status_string ""
    if [ $last_status -ne 0 ]
        printf "[%s%*d%s " (set_color red --bold) 3 $last_status (set_color normal)
    else
        printf "[%s%*d%s " (set_color white) 3 0 (set_color normal)
    end

    # Just calculate these once, to save a few cycles when displaying the prompt
    if not set -q __fish_prompt_hostname
        set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
    end

    if not set -q __fish_prompt_normal
        set -g __fish_prompt_normal (set_color normal)
    end

    set -l home_escaped (echo -n $HOME | sed 's/\//\\\\\//g')
    set -l pwd (echo -n $PWD | sed "s/^$home_escaped/~/" | sed 's/ /%20/g')

    set -l user_prompt '$'
    switch $USER
        # Set our root colors, if we're root :)
        case root
            set user_prompt '#'
            if not set -q __fish_prompt_cwd
                if set -q fish_color_cwd_root
                    set -g __fish_prompt_cwd (set_color $fish_color_cwd_root)
                else
                    set -g __fish_prompt_cwd (set_color $fish_color_cwd)
                end
            end
        case '*'
            if not set -q __fish_prompt_cwd
                set -g __fish_prompt_cwd (set_color $fish_color_cwd)
            end
    end
    #printf '%s@%s %s%s%s# ' $USER $__fish_prompt_hostname "$__fish_prompt_cwd" $pwd "$__fish_prompt_normal"
    #printf "LAST STATUS STRING: $last_status_string \n"
    printf '%s%s:%s%s ]%s ' "$__fish_prompt_cwd" $__fish_prompt_hostname $pwd "$__fish_prompt_normal" $user_prompt

end
