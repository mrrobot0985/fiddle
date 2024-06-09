#!/bin/bash

# Function to display the introduction message for GIT Fiddle, create a .$USER file, and append git.bash content to .fiddle if not present
_fiddle_intro() {
    echo -e "\e[1;34m=======================================\e[0m"
    echo -e "\e[1;32mWelcome to GIT Fiddle!\e[0m"
    echo -e "\e[1;34m=======================================\e[0m"
    echo ""
    echo -e "\e[1;33mHello, amazing developer! 🤖\e[0m"
    echo ""
    echo -e "\e[1;37mGIT Fiddle is a set of Bash functions designed to simplify and automate Git operations within your development workflow.\e[0m"
    echo -e "\e[1;37mWith GIT Fiddle, you can easily handle branch creation, versioning, merging, committing, and more.\e[0m"
    echo -e "\e[1;37mThese functions make it easier to manage your Git repository efficiently from the command line.\e[0m"
    echo ""
    echo -e "\e[1;36mLet's get started by exploring the main commands:\e[0m"
    echo ""
    echo -e "\e[1;35m  - fiddle create <branch_type/branch_name>:\e[0m \e[1;37mCreate and checkout a new branch with an automatically determined version.\e[0m"
    echo -e "\e[1;37m    Example:\e[0m \e[1;32mfiddle create feature/cli-test\e[0m"
    echo ""
    echo -e "\e[1;35m  - fiddle pull:\e[0m \e[1;37mPull changes from the current context branch.\e[0m"
    echo ""
    echo -e "\e[1;35m  - fiddle push:\e[0m \e[1;37mPush changes to the current context branch.\e[0m"
    echo ""
    echo -e "\e[1;35m  - fiddle merge <target_branch>:\e[0m \e[1;37mMerge the current branch into the target branch (main or devel).\e[0m"
    echo -e "\e[1;37m    Example:\e[0m \e[1;32mfiddle merge devel\e[0m"
    echo ""
    echo -e "\e[1;35m  - fiddle commit:\e[0m \e[1;37mAutomatically add and commit changes with an appropriate commit message.\e[0m"
    echo ""
    echo -e "\e[1;35m  - fiddle revert <commit_hash>:\e[0m \e[1;37mRevert the specified commit.\e[0m"
    echo ""
    echo -e "\e[1;35m  - fiddle cherry-pick <commit_hash>:\e[0m \e[1;37mCherry-pick the specified commit into the current branch.\e[0m"
    echo ""
    echo -e "\e[1;35m  - fiddle configure-webhooks:\e[0m \e[1;37mConfigure webhooks for the repository.\e[0m"
    echo ""
    echo -e "\e[1;35m  - fiddle open <file>:\e[0m \e[1;37mOpen the specified file in the default editor.\e[0m"
    echo -e "\e[1;37m    Example:\e[0m \e[1;32mfiddle open README.md\e[0m"
    echo ""
    echo -e "\e[1;35m  - fiddle home:\e[0m \e[1;37mSwitch to the master branch.\e[0m"
    echo ""
    echo -e "\e[1;36mTo get started, simply use any of the above commands. For detailed instructions, refer to the documentation.\e[0m"
    echo ""
    echo -e "\e[1;33mHappy Coding!\e[0m"
    echo -e "\e[1;34m=======================================\e[0m"
    echo ""

    # Check if .fiddle file is present, if not, create and append git.bash content
    if [ ! -f ".fiddle" ]; then
        touch .fiddle
        echo -e "\e[1;32mA file named .fiddle has been created in the current directory.\e[0m"
        echo -e "\e[1;32mFetching git.bash content and appending to .fiddle...\e[0m"
        curl -sL https://raw.githubusercontent.com/mrrobot0985/fiddle/main/git.bash >> .fiddle
        echo -e "\e[1;32mThe content of git.bash has been appended to .fiddle.\e[0m"
    else
        echo -e "\e[1;32m.git.fiddle already exists, skipping fetch.\e[0m"
    fi

    # Add the conditional source line to ~/.bashrc if it doesn't already exist
    grep -qxF '[ -f $(pwd)/.fiddle ] && source $(pwd)/.fiddle' ~/.bashrc || echo '[ -f $(pwd)/.fiddle ] && source $(pwd)/.fiddle' >> ~/.bashrc
    echo -e "\e[1;32mAdded conditional source line for .fiddle to ~/.bashrc.\e[0m"

    # Reload bashrc
    source .fiddle
}

# Call the function to display the introduction message, create the .$USER file, and append git.bash content to .fiddle if not present
_fiddle_intro
