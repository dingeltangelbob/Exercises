# Lecture Exercise Sheet Generator

The Lecture Exercise Sheet Generator is an offline tool designed to assist instructors in creating exercise sheets for lectures. With this tool, instructors can specify lecture information once and then choose exercises from a database to generate customized exercise sheets.

## Table of Contents

- [Setup](#setup)
- [Usage](#usage)

## Setup

To set up the Lecture Exercise Sheet Generator, follow these steps:

1. Download the project files from the repository.
2. Open PowerShell as an administrator to allow PowerShell Script Execution:
    - Run the following command to set the execution policy to allow local scripts:
        ```powershell
        Set-ExecutionPolicy -Scope LocalMachine RemoteSigned
        ```
    - Confirm the change by entering "Y" or "Yes" when prompted.
3. Navigate to the extracted directory.
4. Open the `config.json` file in a text editor.
5. Configure the `config.json` file by setting the following values:
  - `"databasePath"`: Path to the database containing the exercises.
  - `"destinationPath"`: Destination path where all the created sheets will be saved.
6. Open PowerShell from your file explorer by navigating to "Files" -> "Open PowerShell" (or open PowerShell and navigate to the extracted directory), and then run the following command:
    ```powershell
    Unblock-File -Path .\create.ps1
    ```

## Usage

### Create Lecture

Once you have set up the Lecture Exercise Sheet Generator, follow these steps to create exercise sheets:

1. Ensure that there is a directory in the `databasePath` with the name of the lecture. Create one if it does not exist.
2. Open the directory where you have extracted the project files in your file browser.
3. Right-click on the `create.ps1` script file and select "Run with PowerShell" from the context menu. Alternatively, you can open PowerShell and run:
    ```powershell
    .\create.ps1
    ```
3. A window will open where you can select the lecture you want to create exercise sheets for.
4. Follow the prompts by typing "yes" or "no" to answer the questions accordingly.
5. Once you have finished, the tool will generate the setup for creating the exercise sheets, which will be saved in the destination path specified in the `config.json` file.

### Create Exercise Sheets

That's it! You've successfully created an exercise sheet for your lecture using the Lecture Exercise Sheet Generator.
