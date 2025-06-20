# Git Local Branch Cleanup Tool (Windows CMD)

This simple Windows batch script helps you safely clean up **local Git branches** that:

- Have already been **deleted from the remote** (e.g., GitHub)
- And have already been **merged** into your current branch (typically `main` or `develop`)

It only deletes **safe** branches — those merged and removed remotely.

---

## Features

- Detects local branches that are:
  - Gone from the remote (`origin`)
  - Already merged into your current branch
- Shows a preview before deleting:
  - Lists which branches will be deleted
  - Lists which branches will be kept
- Works on:
  - Windows CMD (double-clickable)

---

## Usage

1. Download or clone this repository.
2. Drop the `clean-local-branches.bat` file into any local Git repo folder.
3. Double-click the `.bat` file to run it.
4. Review the branches marked for deletion and confirm when prompted.
