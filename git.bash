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

    echo -e "\e[1;32mA file named .fiddle has been created in the current directory.\e[0m"
    echo -e "\e[1;32mFetching git.bash content and appending to .fiddle...\e[0m"

    # Check if git.fiddle file is present, if not, curl the content of git.bash and append to .fiddle
    if [ ! -f ".fiddle" ]; then
        # Create a .fiddle file in the current directory
        touch .fiddle
    else
        echo -e "\e[1;32m.git.fiddle already exists, skipping fetch.\e[0m"
    fi

    if [ -f "git.bash" ]; then
        cat git.bash >> .fiddle
    else
        curl -sL https://raw.githubusercontent.com/mrrobot0985/fiddle/main/git.bash >> .fiddle
    fi
    echo -e "\e[1;32mThe content of git.bash has been appended to .fiddle.\e[0m"

    [ -f .fiddle ] && grep -qxF '[ -f $(pwd)/.fiddle ] && source $(pwd)/.fiddle' ~/.bashrc || echo '[ -f $(pwd)/.fiddle ] && source $(pwd)/.fiddle' >> ~/.bashrc
    echo -e "\e[1;32mAdded conditional source line for .fiddle to ~/.bashrc.\e[0m"

}

# Call the function to display the introduction message, create the .$USER file, and append git.bash content to .fiddle if not present
_fiddle_intro

########################################################################################################################

# .bashrc file for Git automation

# Define the fiddle function
fiddle() {
    if [ $# -lt 1 ]; then
        show_help
        return 0
    fi

    case "$1" in
        create)
            if [ $# -ne 2 ]; then
                echo "Usage: fiddle create <branch_type/branch_name>"
                return 1
            fi
            create_branch "$2"
            ;;
        pull|push)
            git_actions "$1"
            ;;
        hotfix-pull|hotfix-push)
            if [ $# -ne 1 ]; then
                echo "Usage: fiddle hotfix-pull or fiddle hotfix-push"
                return 1
            fi
            git_actions_main_from_hotfix "${1:7}"
            ;;
        merge)
            if [ $# -ne 2 ]; then
                echo "Usage: fiddle merge <target_branch>"
                return 1
            fi
            merge_branch "$2"
            ;;
        commit)
            automatic_commit
            ;;
        revert)
            if [ $# -ne 2 ]; then
                echo "Usage: fiddle revert <commit_hash>"
                return 1
            fi
            revert_commit "$2"
            ;;
        cherry-pick)
            if [ $# -ne 2 ]; then
                echo "Usage: fiddle cherry-pick <commit_hash>"
                return 1
            fi
            cherry_pick_commit "$2"
            ;;
        configure-webhooks)
            configure_webhooks
            ;;
        open)
            if [ $# -ne 2 ]; then
                echo "Usage: fiddle open <file>"
                return 1
            fi
            open_file_in_editor "$2"
            ;;
        home)
            git_checkout_master
            ;;
        *)
            show_help
            ;;
    esac
}

# Function to show the comprehensive help file
show_help() {
    echo "Usage: fiddle <command> [<args>]"
    echo ""
    echo "A set of Git automation commands to simplify your workflow."
    echo ""
    echo "Commands:"
    echo "  create <branch_type/branch_name>   Create and checkout a new branch of specified type with given name and an automatically determined version."
    echo "                                     branch_type: feature, bugfix, hotfix"
    echo "                                     Example: fiddle create feature/cli-test"
    echo ""
    echo "  pull                               Pull changes from the current context branch."
    echo ""
    echo "  push                               Push changes to the current context branch."
    echo ""
    echo "  hotfix-pull                        Pull changes from the 'main' branch for a hotfix."
    echo ""
    echo "  hotfix-push                        Push changes to the 'main' branch for a hotfix."
    echo ""
    echo "  merge <target_branch>              Merge the current branch into the target branch."
    echo "                                     Example: fiddle merge devel"
    echo ""
    echo "  commit                             Automatically add and commit changes with appropriate commit message."
    echo ""
    echo "  revert <commit_hash>               Revert the specified commit."
    echo ""
    echo "  cherry-pick <commit_hash>          Cherry-pick the specified commit into the current branch."
    echo ""
    echo "  configure-webhooks                 Configure webhooks for the repository."
    echo "                                     You'll be prompted for the webhook URL and event types."
    echo ""
    echo "  open <file>                        Open the specified file in the default editor."
    echo "                                     Example: fiddle open README.md"
    echo ""
    echo "  home                               Switch to the 'master' branch."
    echo ""
}

# Function to ensure development on the master branch
check_master_branch() {
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    if [ "$current_branch" = "main" ]; then
        echo "Switching to a fresh master branch..."
        git checkout -b master
    fi
}

# Function to get the latest version tag
get_latest_version() {
    git describe --tags --abbrev=0 2>/dev/null || echo "0.0.0"
}

# Function to determine the next version based on the latest commit message
get_next_version() {
    latest_version=$(get_latest_version)
    IFS='.' read -r major minor patch <<< "${latest_version#v}"

    commit_message=$(git log -1 --pretty=%B)

    if [[ "$commit_message" =~ ^breaking\ change: ]]; then
        ((major++))
        minor=0
        patch=0
    elif [[ "$commit_message" =~ ^feature: ]]; then
        ((minor++))
        patch=0
    elif [[ "$commit_message" =~ ^bugfix: ]] || [[ "$commit_message" =~ ^hotfix: ]]; then
        ((patch++))
    else
        echo "Error: Commit message must start with one of the keywords: breaking change:, bugfix:, hotfix:, feature:"
        return 1
    fi

    echo "$major.$minor.$patch"
}

# Function to create new branches
create_branch() {
    branch_info=$1
    echo "DEBUG: $1"

    if [[ ! "$branch_info" =~ ^(feature|bugfix|hotfix)/ ]]; then
        echo "Error: Branch name must start with feature/, bugfix/, or hotfix/"
        return 1
    fi

    next_version=$(get_next_version)
    if [ $? -ne 0 ]; then
        echo "Warning: Could not determine the next version."
        full_branch_name="${branch_info}"
    else
        echo "Determined next version: $next_version"
        full_branch_name="${branch_info}-${next_version}"
    fi
    

    echo "Creating and checking out branch '$full_branch_name'..."
    git checkout -b "$full_branch_name"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create branch '$full_branch_name'"
        return 1
    fi
    echo "Branch '$full_branch_name' created and checked out."
}

# Function to determine the context branch for pull and push operations
get_context_branch() {
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    case "$current_branch" in
        feature/*|bugfix/*|hotfix/*)
            echo "$current_branch"
            ;;
        devel)
            echo "devel"
            ;;
        release/v*)
            echo "$current_branch"
            ;;
        master)
            echo "devel"
            ;;
        *)
            echo "Unknown branch context: $current_branch"
            return 1
            ;;
    esac
}

# Function to perform Git actions in the context of the current branch
git_actions() {
    action=$1
    context_branch=$(get_context_branch)
    if [ $? -ne 0 ]; then
        return 1
    fi

    case "$action" in
        pull)
            git pull origin "$context_branch"
            ;;
        push)
            git push origin "$context_branch"
            ;;
        *)
            echo "Invalid action for git_actions: $action"
            return 1
            ;;
    esac
}

# Function to perform Git actions towards the main branch from hotfix branches
git_actions_main_from_hotfix() {
    action=$1

    case "$action" in
        pull)
            git checkout main
            git pull origin main
            ;;
        push)
            git checkout main
            git merge hotfix
            git push origin main
            ;;
        *)
            echo "Invalid action for git_actions_main_from_hotfix: $action"
            return 1
            ;;
    esac
}

# Function to only allow merges to main or devel from master or hotfix
merge_branch() {
    target_branch=$1
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    if [[ "$target_branch" != "main" && "$target_branch" != "devel" ]]; then
        echo "Error: You can only merge to 'main' or 'devel' branches."
        return 1
    fi

    if [[ "$current_branch" != "master" && "$current_branch" != hotfix/* ]]; then
        echo "Error: Only 'master' or 'hotfix/*' branches can merge to 'main' or 'devel'."
        return 1
    fi

    echo "Merging $current_branch into $target_branch..."
    git checkout "$target_branch"
    git merge "$current_branch"
    if [ $? -ne 0 ]; then
        echo "Error: Merge failed."
        return 1
    fi
    git push origin "$target_branch"
    echo "Merged $current_branch into $target_branch and pushed to origin."
}

# Function to automatically add and commit changes with appropriate commit message
automatic_commit() {
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    branch_prefix=$(echo "$current_branch" | awk -F'/' '{print $1}')

    if [[ ! "$branch_prefix" =~ ^(feature|bugfix|hotfix|devel|release)$ ]]; then
        branch_prefix="chore"
    fi

    git status --porcelain | grep -v "^??" | awk '{print $2}' | xargs git add
    if [ $? -ne 0 ]; then
        echo "Error: Failed to add files."
        return 1
    fi

    commit_message="${branch_prefix}: Automatic commit on branch $current_branch"
    git commit -m "$commit_message"
    if [ $? -ne 0 ]; then
        echo "Error: Commit failed."
        return 1
    fi
    echo "Committed changes with message: $commit_message"
}

# Function to revert a commit
revert_commit() {
    commit_hash=$1
    echo "Reverting commit $commit_hash..."
    git revert "$commit_hash"
    if [ $? -ne 0 ]; then
        echo "Error: Revert failed."
        return 1
    fi
    echo "Reverted commit $commit_hash."
}

# Function to cherry-pick a commit
cherry_pick_commit() {
    commit_hash=$1
    echo "Cherry-picking commit $commit_hash..."
    git cherry-pick "$commit_hash"
    if [ $? -ne 0 ]; then
        echo "Error: Cherry-pick failed."
        return 1
    fi
    echo "Cherry-picked commit $commit_hash."
}

# Function to block pushing custom branches
block_custom_branch_push() {
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    if [[ ! "$current_branch" =~ ^(feature|bugfix|hotfix|devel|release/v[0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
        git config --local receive.denyCurrentBranch updateInstead
        echo "Custom branch pushing is blocked for branch: $current_branch"
    fi
}

# Function to configure webhooks
configure_webhooks() {
    echo "Configuring webhooks..."
    read -p "Enter the webhook URL: " webhook_url

    if [ -z "$webhook_url" ]; then
        echo "Error: No webhook URL provided"
        return 1
    fi

    echo "Select events to subscribe to:"
    echo "1. Push events"
    echo "2. Pull request events"
    echo "3. Issues events"
    echo "4. Release events"
    echo "5. All of the above"
    read -p "Enter your choice (1-5): " choice

    case "$choice" in
        1) events="push" ;;
        2) events="pull_request" ;;
        3) events="issues" ;;
        4) events="release" ;;
        5) events="push,pull_request,issues,release" ;;
        *) echo "Invalid choice" ; return 1 ;;
    esac

    # Assuming the repository is already set up and the user has appropriate permissions
    repo=$(git remote get-url origin | sed 's/.*github.com[:\/]\(.*\)\.git/\1/')

    # Create the webhook using the GitHub API
    curl -u "$GITHUB_USER:$GITHUB_TOKEN" \
         -X POST \
         -H "Accept: application/vnd.github.v3+json" \
         https://api.github.com/repos/$repo/hooks \
         -d "{\"name\": \"web\", \"active\": true, \"events\": [\"$events\"], \"config\": {\"url\": \"$webhook_url\", \"content_type\": \"json\"}}"

    echo "Webhook configured for events: $events"
}

# Function to open files in editors
open_file_in_editor() {
    file=$1

    if [ -z "$file" ]; then
        echo "Error: No file specified for open_file_in_editor"
        return 1
    fi

    # Open file in the default editor
    ${EDITOR:-nano} "$file"
}

# Function to switch to the master branch
git_checkout_master() {
    echo "Switching to the 'master' branch..."
    git checkout master
    if [ $? -ne 0 ]; then
        echo "Error: Failed to switch to the 'master' branch"
        return 1
    fi
    echo "Switched to the 'master' branch."
}

# Function to initialize the shell environment
initialize_environment() {
    check_master_branch
    block_custom_branch_push
}

# Initialize the environment on shell initiation
initialize_environment

########################################################################################################################

# Autocompletion for fiddle command
_fiddle_completions() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="create pull push hotfix-pull hotfix-push configure-webhooks open"

    case "${prev}" in
        create)
            COMPREPLY=( $(compgen -W "feature bugfix hotfix" -- ${cur}) )
            return 0
            ;;
        open)
            COMPREPLY=( $(compgen -f ${cur}) )
            return 0
            ;;
        configure-webhooks)
            return 0
            ;;
        pull|push|hotfix-pull|hotfix-push)
            return 0
            ;;
        *)
            ;;
    esac

    if [[ ${cur} == -* ]]; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    else
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    fi

    return 0
}

complete -F _fiddle_completions fiddle
