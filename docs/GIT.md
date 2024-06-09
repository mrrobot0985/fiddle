# GIT Fiddle

## Overview

Hello, amazing developer! 🤖 `GIT Fiddle` is a set of Bash functions designed to simplify and automate Git operations within a development workflow. These functions handle branch creation, versioning, merging, committing, and more, making it easier for you to manage your Git repository efficiently from the command line.

## Usage

### Setup

To use these functions, you can curl the content from the Git repository and insert it into your local `.bashrc` file.

```bash
# Curl the content and append it to your .bashrc file
curl -sL https://raw.githubusercontent.com/your-repo/your-project/main/git >> ~/.bashrc

# Reload your shell configuration
source ~/.bashrc
```

### Commands

#### Create a New Branch

Create and checkout a new branch with an automatically determined version.

```bash
fiddle create <branch_type/branch_name>
```

**Example:**
```bash
fiddle create feature/cli-test
```

#### Pull Changes

Pull changes from the current context branch.

```bash
fiddle pull
```

#### Push Changes

Push changes to the current context branch.

```bash
fiddle push
```

#### Merge Branches

Merge the current branch into the target branch (`main` or `devel`).

```bash
fiddle merge <target_branch>
```

**Example:**
```bash
fiddle merge devel
```

#### Commit Changes

Automatically add and commit changes with an appropriate commit message.

```bash
fiddle commit
```

#### Revert a Commit

Revert the specified commit.

```bash
fiddle revert <commit_hash>
```

#### Cherry-pick a Commit

Cherry-pick the specified commit into the current branch.

```bash
fiddle cherry-pick <commit_hash>
```

#### Configure Webhooks

Configure webhooks for the repository.

```bash
fiddle configure-webhooks
```

#### Open a File

Open the specified file in the default editor.

```bash
fiddle open <file>
```

**Example:**
```bash
fiddle open README.md
```

#### Switch to the Master Branch

Switch to the `master` branch.

```bash
fiddle home
```

### Detailed Functionality

#### Branch Creation and Versioning

The `create` command creates a new branch with an automatically determined version based on the latest commit message.

#### Merge Restrictions

The `merge` command only allows merging to the `main` and `devel` branches from the `master` or `hotfix` branches, protecting the integrity of these branches.

#### Automatic Commit Messages

The `commit` command automatically prefixes commit messages with the branch type, ensuring consistent and descriptive commit history.

#### Error Handling and Status Checks

Functions handle errors gracefully, providing feedback if an operation fails. The `commit` function also respects the `.gitignore` file when adding files.

### Security and Best Practices

**Environment Variables**: Ensure all necessary environment variables are set correctly.

**File Paths**: Validate and sanitize file paths to prevent security vulnerabilities.

**Error Handling**: Properly handle errors to avoid unexpected failures.

## Contributing

We welcome contributions to improve these functions. Please fork the repository and create a pull request with your changes.

## License

This project is licensed under the Unlicense License. See the [LICENSE](../LICENSE) file for details.