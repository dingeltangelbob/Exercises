# Lecture Exercise Sheet Generator

The Lecture Exercise Sheet Generator is an offline tool designed to assist instructors in creating exercise sheets for lectures. With this tool, instructors can specify lecture information once and then choose exercises from a database to generate customized exercise sheets.

## Table of Contents

- [Setup](#setup)
- [Usage](#usage)

## Setup

To set up the Lecture Exercise Sheet Generator, follow these steps:

1. Download the project files from the repository.
2. Open the `config.json` file in a text editor.
3. Configure the `config.json` file by setting the following values:
  - `"databasePath"`: Path to the database containing the exercises.
  - `"destinationPath"`: Destination path where all the created sheets will be saved.
4. Right-click on the `create.ps1` script file and select "Properties".
5. In the Properties dialog, navigate to the "Security" tab.
6. Click on "Edit" and then allow execution of the script by checking the appropriate box.
7. Save the changes and close the Properties dialog.

## Usage

Once you have set up the Lecture Exercise Sheet Generator, follow these steps to create exercise sheets:

1. Right-click on the `create.ps1` script file and select "Run with PowerShell" from the context menu. Alternatively, you can open PowerShell from your file explorer by navigating to "Files" -> "Open PowerShell", and then run the following command:
    ```powershell
    .\create.ps1
    ```
2. Follow the prompts in the PowerShell window to specify the details of the lecture, including title, date, and any additional information required.
6. Choose exercises from the provided database or add new exercises manually as prompted.
7. Once you have finished specifying the lecture details and selecting exercises, the tool will generate the exercise sheet automatically.
8. The generated exercise sheet will be saved in the destination path specified in the `config.json` file.
9. You can now distribute or print the exercise sheet as needed for your lecture.

That's it! You've successfully created an exercise sheet for your lecture using the Lecture Exercise Sheet Generator.
