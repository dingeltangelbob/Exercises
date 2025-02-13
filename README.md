# Exercises Document Class

The `exercises` document class is designed for creating structured and customizable exercise sheets. This documentation provides an overview of its features, commands, and usage examples.

---

## Table of Contents

1. [**Introduction**](#1-introduction)

2. [**Getting Started**](#2-getting-started)
   1. [Installation instructions](#21-installation-instructions)
   2. [Including a Logo](#22-including-a-logo)

3. [**Usage**](#3-usage)
   1. [Class Options](#31-class-options)
   2. [Exercise Sheet Number](#32-exercise-sheet-number)
   3. [Setting Metadata](#33-setting-metadata)
       1. [Title and Subtitle](#331-title-and-subtitle)
       2. [Lecture Details](#332-lecture-details)
       3. [Exercise Schedule](#333-exercise-schedule)
       5. [Available `\Get` Commands](#334-available-get-commands)
       6. [Example usage](#335-example-usage)
       7. [Using a `config.tex` File](#336-using-a-configtex-file)
   4. [Including Exercises](#34-including-exercises)
   5. [The `\DisplayMode` Command](#35-the-displaymode-command)
       1. [Conditional Display Commands](#351-conditional-display-commands)

4. [**Creating Exercises**](#4-creating-exercises)
   1. [Exercise Environments](#41-exercise-environments)
   2. [Hints and Additional Information](#42-hints-and-additional-information)
   3. [Solutions](#43-solutions)
       1. [Inline solutions](#431-inline-solutions)
   4. [Subtasks](#44-subtasks)
       1. [Multi-column formatting](#441-multi-column-formatting)
   5. [Quiz Environment](#45-quiz-environment)
   6. [Notes for Instructors](#46-notes-for-instructors)

5. [**Using References with `cleveref`**](#5-using-references-with-cleveref)

6. [**Custom Commands**](#6-custom-commands)
   1. [Using a `custom.tex` File](#61-using-a-customtex-file)

7. [**Automating Sheet Creation and Compiling with Scripts**](#7-automating-sheet-creation-and-compiling-with-scripts)
   1. [Setup](#71-setup)
   2. [Creating a Lecture Directory](#72-creating-a-lecture-directory)
   3. [Generating Exercise Sheets](#73-generating-exercise-sheets)
   4. [Compiling Exercise Sheets](#74-compiling-exercise-sheets)


8. [**Examples**](#8-examples)
   1. [Simple Example](#81-simple-example)
   2. [Advanced Usage Scenarios](#82-advanced-usage-scenarios)

9. [**Common Issues and Troubleshooting**](#9-common-issues-and-troubleshooting)

10. [**FAQs**](#10-faqs)

11. [**Contributing**](#11-contributing)
    1. [How to contribute to the development](#111-how-to-contribute-to-the-development)
    2. [Suggestions for improvements](#112-suggestions-for-improvements)
    3. [Guidelines for submitting issues and pull requests](#113-guidelines-for-submitting-issues-and-pull-requests)
    4. [Footer layout (page numbers, custom text)](#114-footer-layout-page-numbers-custom-text)

---

## 1. Introduction

The `exercises` document class is a LaTeX class specifically designed to streamline the creation of structured exercise sheets for academic use. It provides a simple and flexible way to format exercises, quizzes, solutions, and metadata while ensuring consistency across multiple sheets. The class includes built-in automation for numbering, deadlines, and metadata retrieval, making it particularly useful for university-level coursework.

#### Key Features

- **Automatic Numbering**: Exercises and subtasks are numbered automatically.
- **Flexible Metadata Management**: Define titles, lecturers, terms, and deadlines dynamically.
- **Automated Scheduling**: Upload dates and deadlines are calculated based on predefined parameters.
- **Customizable Content Display**: Control the visibility of solutions and instructor notes.
- **Support for Various Exercise Types**: Includes environments for standard exercises, homework, quizzes, and extra tasks.
- **Configurable via `config.tex`**: Allows setting global parameters without modifying individual sheets.
- **Automated Compilation Support**: PowerShell scripts are provided for generating and compiling exercise sheets efficiently.


---

## 2. Getting Started

### 2.1. Installation Instructions

To begin, create a directory where you intend to store your exercise sheets. Place the `exercises.cls` file in this directory so that LaTeX can locate it. You can then use `\documentclass{exercises}` in any `.tex` file you create within this folder. An minimal example can look like

```latex
\documentclass{exercises}
\begin{document}
    % Your content goes here
\end{document}
```

### 2.2. Including a Logo

Create a folder named `Utils` in the working directory and add a file named `logo` with one of the following extensions: `.pdf`, `.png`, or `.jpg`. The `exercises` class will automatically include the logo if available, inserting it at about 1 cm height on the left side of the header. Ensure your file is properly cropped to maintain a clean appearance.

---

## 3. Usage

### 3.1 Class Options

The `exercises` document class provides the following options:

- **Language**:
   - `english` (default)
   - `ngerman`

- **Font Size**:
   - `10pt` (default)
   - `11pt`
   - `12pt`

- **Collection**: Enables a special mode for displaying all exercises from a centralized database in an organized and readable format. It is intended for specialized use cases and is generally *not recommended* for regular exercise sheets.
   - `collection` (default: disabled) 

An example usage of the options can look like

```latex
\documentclass[ngerman, 11pt]{exercises}
```

### 3.2 Exercise Sheet Number

The `\SetNumber` command is essential for enabling automatic date calculations for uploads and deadlines. It must be set on *every* exercise sheet, as it defines the current sheet's number. It also is the base of the numbering system for the exercises. In the following minimal example you will not see any different to the previous one. However the base for numbering and date calulation is set. 

```latex
\documentclass{exercises}
\SetNumber{1}
\begin{document}
    % Your content goes here
\end{document}
```

### 3.3 Setting Metadata

The `exercises` document class provides commands to set metadata directly within the document or in a `config.tex` file. These commands allow you to define the title, subtitle, lecturer, and other information that will be displayed in the document. Additionally, `\Get` commands can be used to dynamically retrieve metadata such as upload dates, deadlines, and exercise sheet numbers. To set up metadata within your document, use the provided commands in the preamble before `\begin{document}`.

#### 3.3.1 Title and Subtitle

   - `\SetTitle{<title>}` (default: `Exercise Sheet`): Sets the main title of the document.
   - `\SetSubtitle{<subtitle>}`: Sets a subtitle displayed below the title.
   - `\SetClosure{<text>}`: Sets a closing remark displayed at the end of the document.
   - `\SetSubclosure{<text>}`: Sets a secondary closing remark.
   - `\SetFooter{<footer-text>}`: Sets custom text displayed on the left side of the footer.

#### 3.3.2 Lecture Details

   - `\SetLecture{<lecture-name>}`: Defines the name of the lecture displayed on the right side of the header.
   - `\SetLecturer{<lecturer-name>}`: Defines the name of the lecturer displayed on the right side of the header.
   - `\SetTerm{<term>}`: Specifies the term displayed on the right side of the header.

#### 3.3.3 Exercise Schedule

   - `\SetDateOfFirstUpload{<year>}{<month>}{<day>}`: Defines the date for the first upload. Mandatory for automatic schedule calculations.
   - `\SetUploadFrequence{<days>}` (default: `7`): Defines the interval (in days) between successive uploads.
   - `\SetDaysUntilDeadline{<days>}` (default: `7`): Sets the number of days between an upload and its deadline.
   - `\SetDeadlineTime{<time>}`: Specifies the exact time for the deadline.
   - `\SetOffsetAfterSheet{<offset>}{<sheet>}` (default: `0 0` no offset): Adds a custom offset of `<offset>` days after a specific exercise sheet `<sheet>`. Useful for handling holidays or term breaks.

#### 3.3.4 Available `\Get` Commands

   - `\GetUpload`: Retrieves the upload date for the current exercise sheet. Is used by default on the right side of the header.
   - `\GetDeadline`: Retrieves the deadline date and time.
   - `\GetDeadlineDay`: Retrieves the deadline date without the time.
   - `\GetNumber`: Retrieves the exercise sheet number in a two-digit format (e.g., `01`).
   - `\thenum`: Retrieves the exercise sheet number in a single-digit format (e.g., `1`).

#### 3.3.5 Example Usage

```latex
\documentclass{exercises}

\SetNumber{1} % Set the number of the sheet

\SetTitle{Exercise Sheet \GetNumber}
\SetSubtitle{Submit by \GetDeadline\ to Moodle.}
\SetClosure{Please inform us about any typos you found.}
\SetSubclosure{Good Luck!}
\SetFooter{Department of Mathematics on \GetUpload.}

\SetLecture{Analysis 1}
\SetLecturer{Prof. Dr. Jane Doe}
\SetTerm{Winter 2025/2026}

\SetDateOfFirstUpload{2025}{01}{15}
\SetUploadFrequence{14}
\SetDaysUntilDeadline{13}
\SetDeadlineTime{11:59 pm}
\SetOffsetAfterSheet{14}{9}

\begin{document}
   % Your content goes here
\end{document}
```

#### 3.3.6 Using a `config.tex` File

To streamline the creation of exercise sheets, you can define a `config.tex` file in the `Utils` directory containing the metadata. This file is automatically loaded by the `exercises` document class if present in the `Utils` directory, applying the defined settings to the current document. Settings defined in `config.tex` can be overridden directly in individual exercise sheets if needed, ensuring flexibility for specific cases.

##### Example `config.tex` File

```latex
% Title and Subtitle
\SetTitle{Exercise Sheet \GetNumber} % Default: Exercise Sheet
\SetSubtitle{Submit by \GetDeadline\ to Moodle.} % Default: (Empty)
\SetClosure{Please inform us about any typos you found.} % Default: (Empty)
\SetSubclosure{Good Luck!} % Default: (Empty)
%\SetFooter{Department of Mathematics on \GetUpload.} % Default: (Empty)

% Lecture Details
\SetLecture{Analysis 1} % Default: (Empty)
\SetLecturer{Prof. Dr. John Doe} % Default: (Empty)
\SetTerm{Winter 2025/2026} % Default: (Empty)

% Exercise Schedule
\SetDateOfFirstUpload{2025}{01}{15} % Mandatory for automatic schedule calculations.
%\SetUploadFrequence{14} % Default: 7
%\SetDaysUntilDeadline{14} % Default: 7
\SetDeadlineTime{11:59 p.m.} % Default: (Empty)
%\SetOffsetAfterSheet{14}{9} % Default: No offset. Adds a 14-day break after sheet 9.
```

## 3.4 Including Exercises

To include exercises in the document, copy and paste an existing exercise or create a new one using the `exercise` environment. Each exercise should have a solution contained in the `solution` environment. The visibility of the solution can be controlled by the `\DisplayMode` command in the preamble.

```latex
\documentclass{exercises}
\SetNumber{1}

\DisplayMode{exercise}

\begin{document}
   \begin{exercise}[Name of exercise]
      Example exercise.

      \begin{solution}
         Example solution.
      \end{solution}
   \end{exercise}
\end{document}
```

For more details on how to structure and customize exercises, refer to [Creating Exercises](#4-creating-exercises).

## 3.5 The `\DisplayMode` Command

Solutions, notes, and tags can be included but are hidden by default. To display them in the output, use the `\DisplayMode{<list>}` command in the preamble. This command takes a comma-separated list as an argument to specify which elements should be shown. It is important to note that `\DisplayMode` only controls the visibility of solutions and annotations—it does not effect the exercises themselves.

Available display modes include:

- `exercise` (Solutions for `exercise` environment)
- `extra` (Solutions for `extra` environment)
- `homework` (Solutions for `homework` environment)
- `note` (Notes for instructors)
- `task` (Solutions for `task` environment)
- `tags` (Only for `collection` mode)

#### Example

```latex
\DisplayMode{exercise, extra, note} % Enables solutions for exercises, extra tasks, and notes
```

## 3.5.1 Conditional Display Commands

The `exercises` class provides the following commands for controlling visibility based on display modes. Each command accepts an optional argument specifying the display mode it applies to. If no argument is given, it defaults to `exercise`.

- `\IfSolution[<mode>]{<command>}`: Executes `<command>` only if the specified display mode is enabled. Defaults to `exercise`.
- `\IfSolutionDisabled[<mode>]{<command>}`: Executes `<command>` only if the specified display mode is disabled. Defaults to `exercise`.
- `\NewpageIfSolution[<mode>]`: Inserts a new page if the specified display mode is enabled. Defaults to `exercise`.
- `\NewpageIfSolutionDisabled[<mode>]`: Inserts a new page if the specified display mode is disabled. Defaults to `exercise`.

---

## 4. Creating Exercises

### 4.1 Exercise Environments

The `exercises` class provides different environments to define exercises. Each exercise environment—`exercise`, `task` (for in-class problems), `homework`, and `extra`—can contain multiple subtasks written using an `enumerate` environment and optionally include hints or solutions.

```latex
\begin{exercise}
   Describe the Pythagorean theorem and provide an example.
\end{exercise}
```
The optional argument can include both a title and a point value.

```latex
\begin{exercise}[Pythagorean Theorem (4 \points)]
   Describe the Pythagorean theorem and provide an example.
\end{exercise}
```
  

### 4.2 Hints and Additional Information

Hints can be added within an exercise using the `hint` environment:

```latex
\begin{exercise}
   Solve the equation $x^2 = 9$.
   \begin{hint}
      Consider the square root.
   \end{hint}
\end{exercise}
```

Hints are formatted distinctly to assist students.

Additional contextual information can be provided using the `info` environment.

```latex
\begin{exercise}
   Proof $a^2+b^2=c^2$.
   \begin{info}
      This identity is called Pythagorean Theorem.
   \end{info}
\end{exercise}
```

The info environment is useful for background details that may enhance understanding and provides further references but are not directly necessary for solving the exercise.

### 4.3 Solutions

Solutions can be included using the `solution` environment:

```latex
\begin{exercise}
    Compute the derivative of $f(x) = x^2$.
    \begin{solution}
        The derivative is $f'(x) = 2x$.
    \end{solution}
\end{exercise}
```

The visibility of solutions can be controlled globally.

#### 4.3.1 Inline Solutions

Alternatively, solutions can be included inline using `\sol{}`:

```latex
Compute the derivative of $f(x) = x^3$. \sol{$f'(x) = 3x^2$}
```

This method is useful for displaying solutions immediately after a problem.

### 4.4 Subtasks

Exercises can be subdivided into `enumerate` environments:

```latex
\begin{exercise}
    Solve the following problems:
    \begin{enumerate}
        \item Compute $3 + 5$.
        \item Compute $7 - 2$.
    \end{enumerate}
\end{exercise}
```

#### 4.4.1 Multi-column Formatting

Subtasks can be displayed in multiple columns using the `columns` option:

```latex
\begin{exercise}
    Calculate the following:
    \begin{multicols}{2}
        \begin{enumerate}
            \item $3+4$
            \item $7-2$
        \end{enumerate}
    \end{multicols}
\end{exercise}
```

This format is useful for compact layouts.

### 4.5 Quiz Environment

A special `quiz` environment allows for multiple-choice questions:

```latex
\begin{quiz}
    What is the capital of France?
    \begin{itemize}
        \itemw Berlin
        \itemw Madrid
        \itemr Paris
        \itemw Rome
    \end{itemize}
\end{quiz}
```

The correct answer is marked and can be revealed in the solution view.

### 4.6 Notes

Notes can be included inline using the `\note` command. The command has two forms:

Inline Highlighting: If `{}` is used, the text appears highlighted in red.

```latex
\note{Important note for the exericse.}
```

Footnote Annotation: If `[]` is used, the additional text appears as a footnote.

```latex
\note[Important note for the exericse.]{}
```

To enable or disable notes in the document add `notes` in the `\Enable` command. This functions similarly to enabling solutions, ensuring that notes are only shown when required.

---

## 5. Using References with `cleveref`

The `exercises` document class includes the [`cleveref`](https://ctan.org/pkg/cleveref) package, which simplifies the creation of cross-references in LaTeX. Although references should generally be avoided, espacially between different exercise enviroments, they can be useful in certain contexts.

##### How to Use

1. **Define a Label**: Use `\label{<label-name>}` within an exercise like environment or within an enumerate enviroment to define a reference point.
2. **Create a Reference**: Use `\cref{<label-name>}` to reference the labeled exercise.

##### Example

```latex
\begin{exercise}[Exercise Title]
   \begin{enumerate}
      \item\label{first} First task.
      \item Second task
   \end{enumerate}

   \begin{solution}
      \begin{enumerate}
         \item First solution.
         \item In the solution of \cref{first} we saw \dots
      \end{enumerate}
   \end{solution}
\end{exercise}
```

---

## 6. Custom Commands

To extend the functionality of your exercise sheets, you can define custom commands and include additional packages. There are two main ways to achieve this: using a separate `custom.tex` file or defining them directly in the document preamble.

If you only need a few additional commands or packages for a specific sheet, you can define them directly in the preamble of your document.

#### Example Preamble

```latex
\documentclass{exercises}
\SetNumber{1}

% Load additional packages
\usepackage{tikz} % For graphical elements
\usepackage{amsmath} % Additional math support

% Define custom commands
\newcommand{\vect}[1]{\mathbf{#1}} % Bold vector notation

\begin{document}
    % Your content here
\end{document}
```

### 6.1 Using a `custom.tex` File

For better organization and reusability, you can create a `custom.tex` file inside the `Utils` directory. This file should contain any additional LaTeX packages and custom commands you want to use in your sheets. Packages have to be loaded using the `\requirePackage` command instead of `\usepackage`.

#### Example `custom.tex` File

```latex
% Load additional packages
\requirePackage{tikz} % For graphical elements
\requirePackage{amsmath} % Additional math support

% Define custom commands
\newcommand{\R}{\mathbb{R}} % Shortcut for real numbers
\newcommand{\N}{\mathbb{N}} % Shortcut for natural numbers
```

This file will be automatically included if present in the `Utils` directory.

Using `custom.tex` is recommended for commonly used commands across multiple sheets, while defining them in the preamble is useful for sheet-specific configurations.

---

## 7. Automating Sheet Creation and Compiling with Scripts

To simplify the process of managing exercise sheets, PowerShell scripts are provided to automate directory creation, sheet generation, and compilation. These scripts ensure a structured workflow and reduce manual setup effort.

### 7.1 Setup

Before executing the `create.ps1` script, some initial setup steps are required to allow the execution of downloaded scripts, as Windows blocks them by default:

1. Open PowerShell as an administrator.
2. Allow signed script execution by running:
   
   ```powershell
   Set-ExecutionPolicy -Scope LocalMachine RemoteSigned
   ```
   
3. Confirm the change by entering "Y" or "Yes" when prompted and exit the console.
4. Navigate to the directory where the `create.ps1` file is located.
5. Create a `config.json` file in the directory and configure it using the following example:
   
   - `"databasePath"`: Path to the database containing the exercises.
   - `"destinationPath"`: Destination path where all the created sheets will be saved.

   ```json
   {
      "databasePath": "C:\\path\\to\\exercise_database",
      "destinationPath": "C:\\path\\to\\output_directory"
   }
   ```
7. To allow script execution, open PowerShell in the directory containing `create.ps1` and run the following command:
   
   ```powershell
      Unblock-File -Path .\create.ps1
   ```


### 7.2 Creating a Lecture Directory

A PowerShell script (`create.ps1`) is available to generate a lecture directory. This directory will contain all necessary subdirectories and files required for managing exercise sheets.

1. Ensure that there is a directory in the `databasePath` with the name of the lecture you want to create.
2. Right-click on the `create.ps1` script file and select "Run with PowerShell" from the context menu.
3. Follow the on-screen prompts to specify lecture details.
4. The script will generate a structured directory containing necessary scripts and configuration files. The directory will be saved in the `destinationPath`. The generated directory will work independently of the location where it is placed.

### 7.3 Generating Exercise Sheets

Once the lecture directory is set up, a second script is available for generating new exercise sheets.

#### Steps to Generate Exercise Sheets:

1. Navigate to the previously created lecture directory.
2. Execute the sheet creation script:
   
   ```powershell
   .\generate.ps1
   ```
3. The script will prompt for necessary inputs, such as exercise sheet number and configuration options.
4. The corresponding LaTeX files will be created and placed in the appropriate directory.

### 7.4 Compiling Exercise Sheets

After generating the LaTeX files, another script automates the compilation process to produce PDF files.

#### Steps to Compile Exercise Sheets:

1. Ensure that LaTeX is installed and accessible from the command line.
2. Navigate to the lecture directory containing the generated `.tex` files.
3. Execute the compilation script:
   
   ```powershell
   .\compile.ps1
   ```
4. The script will locate all necessary files and compile them into PDFs.
5. Upon completion, the PDFs will be available in the designated output directory.

By using these scripts, instructors can efficiently manage exercise sheets with minimal manual intervention, ensuring consistency and reducing setup time.


---

## 8. Examples

### 8.1 Simple Example

Dummy content.

### 8.2 Advanced Usage Scenarios

Dummy content.

---

## 9. Common Issues and Troubleshooting

##### Known Issue: Incorrect Last Page Number

When the last page of the document is very full, the total page number may not be displayed correctly. Instead of the expected value, it will appear as `??`. To workaround this issue:
1. Compile the document with slightly less content on the last page (e.g., by temporarily removing some text).
2. Once the page number is calculated correctly, compile the document *one* more time with the full content.

---

## 10. FAQs

Dummy content.

---

## 11. Contributing

### 11.1 How to contribute to the development

Dummy content.

### 11.2 Suggestions for improvements
   
   - Add option for multisheet: One .tex containing n sheets.
   - Seperate command for footnote notes and inline notes. Maybe star version.
   - Adding exercise by command `\printExercise{name}{type}{points}`

### 11.3 Guidelines for submitting issues and pull requests

Dummy content.

### 11.4 Footer layout (page numbers, custom text)

Dummy content.

---






