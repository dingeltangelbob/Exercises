% exercises.cls
\ProvidesClass{exercises}[2025/01/10 Custom Class for Exercise Sheets]


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Essential
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Class based variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\ks@fontsize{10pt}
\def\ks@language{english}
\newif\if@ks@option@collection
\newif\if@ks@option@onefile


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Class Options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\DeclareOption{english}{\def\ks@language{english}}
\DeclareOption{ngerman}{\def\ks@language{ngerman}}
\DeclareOption{12pt}{\def\ks@fontsize{12pt}}
\DeclareOption{11pt}{\def\ks@fontsize{11pt}}
\DeclareOption{10pt}{\def\ks@fontsize{10pt}}
\DeclareOption{collection}{
    \@ks@option@collectiontrue
    \setcounter{secnumdepth}{0}% Disables numbering of sections
}
\DeclareOption{onefile}{\@ks@option@onefiletrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrartcl}}
\ProcessOptions\relax

% Load parent class
\LoadClass[\ks@fontsize, final, \ks@language]{scrartcl}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Variables and default values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\newcounter{num}

\def\ks@title@text{Exercise Sheet}
\def\ks@title@collection{Collection of exercises}
\def\ks@subtitle@text{}
\def\ks@closure@text{}
\def\ks@subclosure@text{}
\def\ks@footer@text{}
\def\ks@footer@page{Page \thepage\ of \labelcpageref{lastpage}}
\def\ks@uploadFrequency{7}
\def\ks@daysUntilDeadline{7}
\def\ks@deadlineTime{}
\def\ks@offset{0}
\def\ks@offset@sheet{0}

\if@ks@option@collection
    \def\ks@title{\ks@title@collection}
    \def\ks@subtitle{}
    \def\ks@closure{}
    \def\ks@subclosure{}
    \def\ks@footer{}
\else
    \def\ks@title{\ks@title@text}
    \def\ks@subtitle{\ks@subtitle@text}
    \def\ks@closure{\ks@closure@text}
    \def\ks@subclosure{\ks@subclosure@text}
    \def\ks@footer{\ks@footer@text}
\fi

\def\ks@lecture{}
\def\ks@lecturer{}
\def\ks@term{}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Packages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{amsmath}

% Load the babel package immideately after the language is set. And befor the title is set. See https://www.ctan.org/pkg/babel
\RequirePackage[\ks@language]{babel}

% Add german language support. Allow special caracters such as ä,ö, etc. See https://www.typeerror.org/docs/latex/fontenc-package and https://www.ctan.org/pkg/inputenc
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}

% For better referencing. Espacially for translateable page ref. See https://ctan.org/pkg/cleveref
\RequirePackage[\ks@language]{cleveref}

% For images, and graphics
\RequirePackage{graphics}
% Definie the standard path where images will be searched.
\graphicspath{{./Images}}
% Declare the default graphic extensions. If there are files with the same name but different file extensions, the .pdf file will be preffered.
\DeclareGraphicsExtensions{.pdf,.png,.jpg}

% For page layout specifications
\RequirePackage[a4paper, bottom=3.7cm, top=2cm]{geometry}

% For the header and footer
\RequirePackage[headsepline,footsepline,singlespacing]{scrlayer-scrpage}

% Increase space between two lines
\RequirePackage[onehalfspacing]{setspace}

% For date calculation. See https://www.ctan.org/pkg/scrdate and https://www.ctan.org/pkg/advdate
\RequirePackage{scrdate}
\RequirePackage{advdate}

%Save today as default value for the upload. Will be overwritten by \SetNumber.
\SaveDate[\ks@upload]
\SaveDate[\ks@deadline]


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Header and Footer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\addtokomafont{pageheadfoot}{\upshape}
\pagestyle{scrheadings}

\setlength{\headheight}{5.5em}
\setlength{\footheight}{2em}
\setlength{\footskip}{10.5mm}
\setlength{\parindent}{0em}

\ModifyLayer[addvoffset=-.3em]{scrheadings.foot.above.line}

\ihead{%
    \IfFileExists{./Utils/logo.pdf}{%
        \includegraphics[height=1cm]{./Utils/logo.pdf}%
    }{%
        \IfFileExists{./Utils/logo.png}{%
            \includegraphics[height=1cm]{./Utils/logo.png}%
        }{%
            \IfFileExists{./Utils/logo.jpg}{%
                \includegraphics[height=1cm]{./Utils/logo.jpg}%
            }{%
                No logo found (logo.pdf/png/jpg).%
            }%
        }%
    }%
}
\chead{}
\ohead{\ks@lecture\ -- \ks@term \\ \if&\ks@lecturer&\else\ks@lecturer\\\fi\GetUpload}

\ifoot{\smash{\vtop{\ks@footer}}}
\cfoot{}
\ofoot{\ks@footer@page}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Set Commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \SetNumber{<value>}. Set the number of the sheet to <value>. You have to set the number on each sheet. After the number is set, the upload date and the deadline will be calculated
\newcommand{\SetNumber}[1]{%
    \setcounter{num}{#1}%set counter
    % caculate dates
    \def\ks@upload@offset{0}% declare upload offset
    \def\ks@deadline@offset{0}% declare deadline offset
    \ifnum\ks@offset@sheet<\thenum% check whether to apply the offset
    \def\ks@upload@offset{\ks@offset}% overwrite the offset if neccessary
    \fi%
    \AdvanceDate[\the\numexpr(\thenum-1)*\ks@uploadFrequency+\ks@upload@offset\relax]% increase the date of first upload by the number of days needed for the current sheet
    \SaveDate[\ks@upload]% save the current day, which is "DateOfFirstUpload + x" at the \ks@upload macro
    \ifnum\ks@offset@sheet=\thenum% check whether to apply an offset to the deadline
    \def\ks@deadline@offset{\ks@offset}% overwrite the offset if neccessary
    \fi%
    \AdvanceDate[\the\numexpr\ks@daysUntilDeadline+\ks@deadline@offset\relax]% increase the date of current upload by the days until delivery
    \SaveDate[\ks@deadline]% save the current day, which is "DateOfFirstUpload + x + daysUntilDeadline" at the \ks@deadline macro
}

% \SetDateOfFirstUpload{<year>}{<month>}{<day>}. Set the day of the first upload to <year>-<month>-<day>. The format of the date depends on the language of the document. You should set the date for consitency. Otherwise the automatic date calculation might fail.
\newcommand{\SetDateOfFirstUpload}[3]{\SaveDate\day=#3\month=#2\year=#1}


% \SetUploadFrequence{<days>}. Set the frequency of upload in days. The default value is 7, i.e. one upload every week.
\newcommand{\SetUploadFrequence}[1]{\def\ks@uploadFrequency{#1}}


% \SetDaysUntilDeadline{<days>}. Set the number of days until which the homework has to be delivered. The default value is 7, i.e. the deadline will be one week after the upload of the sheet.
\newcommand{\SetDaysUntilDeadline}[1]{\def\ks@daysUntilDeadline{#1}}


% \SetDeadlineTime{<time>}. Set the time of the deadline.
\newcommand{\SetDeadlineTime}[1]{\def\ks@deadlineTime{#1}}

% \SetOffsetAfterSheet{<offset>}{<sheet>}. Set an offset of <offset> days after sheet <sheet>. This can be usefull if there are holidays in between the current term. For example, if there are two weeks of holidays before sheet 10 will be uploaded, you should use \SetOffsetAfterSheet{14}{9}.
\newcommand{\SetOffsetAfterSheet}[2]{\def\ks@offset{#1}\def\ks@offset@sheet{#2}}

\newcommand{\SetTitle}[1]{\def\ks@title@text{#1}}
\newcommand{\SetSubtitle}[1]{\def\ks@subtitle@text{#1}}
\newcommand{\SetClosure}[1]{\def\ks@closure@text{#1}}
\newcommand{\SetSubclosure}[1]{\def\ks@subclosure@text{#1}}
\newcommand{\SetFooter}[1]{\def\ks@footer@text{#1}}

\newcommand{\SetLecture}[1]{\def\ks@lecture{#1}}
\newcommand{\SetLecturer}[1]{\def\ks@lecturer{#1}}
\newcommand{\SetTerm}[1]{\def\ks@term{#1}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Get Commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \GetUpload contains the day of upload for usage in the document. Note that the macro \today will be overwrited by the date of upload. The result will be printed in the format "<nameOfDay>, <dateOfUpload>".
\newcommand{\GetUpload}{\SetDate[\ks@upload]\DayName{\year}{\month}{\day}, \today}


% \GetDeadline[<days>] contains the day and time of the deadline plus an additional <days> days to the deadline for usage in the document. The default value of <days> is 0. Note that the macro \today will be overwrited by the date of deadline. The result will be printed in the format "<nameOfDay>, <dateOfDeadline>, <timeOfDeadline>".
\newcommand{\GetDeadline}[1][0]{\GetDeadlineDay, \ks@deadlineTime}

% \GetDeadlineDay contains the day of the deadline plus an additional <days> days to the deadline for usage in the document. The default value of <days> is 0. Note that the macro \today will be overwrited by the date of deadline. The result will be printed in the format "<nameOfDay>, <dateOfDeadline>".
\newcommand{\GetDeadlineDay}[1][0]{%
    \SetDate[\ks@deadline]%
    \AdvanceDate[#1]%
    \DayName{\year}{\month}{\day}, \today%
}

\newcommand{\GetNumber}{\two@digits\thenum}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Title and Closure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\AtBeginDocument{
    \begin{center}
        \LARGE \textbf{\ks@title} \\[0.2em]
        \normalsize \ks@subtitle
    \end{center}
}

% Create Reference of the last page. TODO: Known bug, if the page is to full, there might be not the right reference of the last page.
\AtEndDocument{%
    \vfill%
    \begin{center}
        \if&\ks@closure&\else\ks@closure\\\fi
        \textbf{\ks@subclosure}\label{lastpage}
    \end{center}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Translations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\defcaptionname{ngerman}{\ks@footer@page}{Seite \thepage\ von \labelcpageref{lastpage}}
\defcaptionname{ngerman}{\ks@title@text}{Übungsblatt}
\defcaptionname{ngerman}{\ks@collection}{Aufgabensammlung}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Packages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For color, images and graphics. See https://www.ctan.org/pkg/latex-graphics
\RequirePackage{color}

% For the definition of the exercise and solution enviroment. See https://www.ctan.org/pkg/environ and https://www.ctan.org/pkg/ntheorem
\RequirePackage{environ}
\RequirePackage[amsmath,amsthm]{ntheorem}

% To show filenames in collection mode
\RequirePackage{currfile}

\RequirePackage{enumitem}% For better enumerating features

% For an enviroment with multiple columns. See https://www.ctan.org/pkg/multicol
\RequirePackage{multicol}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Solution switches and commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \ks@sol@save{<arg>}. Contain <arg> if and only if the current mode key \ks@solkey is TRUE. Whenever you want to execute <arg> only in the case when a specific mode is enabled use this command.
\newcommand{\ks@sol@save}[1]{%
    \expandafter\csname if@ks@\ks@solkey\endcsname%
    #1%
    \fi%
}

% \IfMode[<mode>]{<code>} Execute <code> if and only if the given mode <mode> (default: exercise) is enabled.
\newcommand{\IfMode}[2][exercise]{%
    \def\ks@solkey{#1}% set the given key
    \ks@sol@save{#2}% execute code save
    \def\ks@solkey{}% clear the given key
}

% \NewpageIfMode[<mode>] Make a new page if and only if the given mode <mode> (default: exercise) is enabled.
\newcommand{\NewpageIfMode}[1][exercise]{%
    \IfMode[#1]{\newpage}%
}

% \IfModeDisabled[<mode>]{<code>} Execute <code> if and only if the given mode <mode> (default: exercise) is disabled.
\newcommand{\IfModeDisabled}[2][exercise]{%
    \expandafter\csname if@ks@#1\endcsname\else%
    #2%
    \fi%
}

% \NewpageIfModeDisabled[<key>] Make a new page if and only if mode <mode> (default: exercise) is disabled.
\newcommand{\NewpageIfModeDisabled}[1]{%
    \IfModeDisabled[#1]{\newpage}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Enviroments styles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set the font of the body of a theorem to normal font.
\theorembodyfont{}

% Set the separator between theorem header and the optional argument to ":".
\theoremseparator{:}

% Set the spacing before a theorem
\theorempreskip{\topsep}

% Set the spacing after a theorem
\theorempostskip{2\topsep}

%% \ks@headerstyle[<opt>]{<header>} Define custome header style so that the exercises automatically start in the new line. The Style will be like: "<header>:<opt>"
\if@ks@option@collection
    % headerstyle for collection
    \newcommand\ks@headerstyle[2][]{%
        \item[\rlap{\vbox{\hbox{\hskip\labelsep\theorem@headerfont\currfilebase\theorem@separator #1}\hbox{\strut}}}]%
    }%
\else
    \newcommand\ks@headerstyle[2][]{%
        \item[\rlap{\vbox{\hbox{\hskip\labelsep\theorem@headerfont #2\theorem@separator #1}\hbox{\strut}}}]%
    }%
\fi



% \ks@headerstyle@solution[<opt>]{<header>} Define custome header style so that the exercises automatically start in the new line. The Style will be like: "<header>:"
\newcommand\ks@headerstyle@solution[1]{%
    \item[\rlap{\vbox{\hbox{\hskip\labelsep\theorem@headerfont #1\theorem@separator}\hbox{\strut}}}]%
}

% Define the exercise theoremstyle
\newtheoremstyle{exercise}{%
    \ks@headerstyle{##1\ ##2}% without optional argument
}{%
    \ks@headerstyle[{~ ##3}]{##1\ ##2}% with optional argument
}

% Define the nonumber theoremstyle. E.g. for extra tasks.
\newtheoremstyle{nonumber}{%
    \ks@headerstyle{##1}% without optional argument
}{%
    \ks@headerstyle[~ ##3]{##1}% with optional argument
}

% Define the nonumber theoremstyle. E.g. for solution or extra tasks.
\newtheoremstyle{solution}{%
    \ks@headerstyle@solution{##1}% without optional argument
}{%
    \ks@headerstyle@solution{##1}% with optional argument
}

% Define the hint theoremstyle where the body doens't start in a new line. There is no optinal argument allowed.
\newtheoremstyle{hint}{%
    \item[\theorem@headerfont\hskip\labelsep ##1\theorem@separator]%
}{%
    \item[\theorem@headerfont\hskip \labelsep ##1\theorem@separator]%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Translatable enviroments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \NewTranslatableEnviroment{<key>}{<english>}{<englishpl>}{<german>}{<germanpl>}
\newcommand{\NewTranslatableEnviroment}[5]{%
    %
    \edef\tmpsin{{ngerman}{\csname #1autorefname\endcsname}{#4}}
    \edef\tmpplu{{ngerman}{\csname #1autorefnames\endcsname}{#5}}
    \edef\tmp{{#1}{\csname #1autorefname\endcsname}{\csname #1autorefnames\endcsname}}
    \expandafter\def\csname #1autorefname\endcsname{#2}% Define the name of the translatable enviroment
    \expandafter\def\csname #1autorefnames\endcsname{#2}% Define the plural name of the enviroment (only for use with cleverref)
    \if@ks@option@onefile
        \expandafter\newtheorem{#1}{\csname #1autorefname\endcsname}% Define the enviroment
    \else
        \expandafter\newtheorem{#1}{\csname #1autorefname\endcsname}[num]% Define the enviroment
    \fi
    \expandafter\defcaptionname\tmpsin% Make the caption translatable to german
    \expandafter\defcaptionname\tmpplu% Make the plural translatable (only for use with cleverref)
    \expandafter\crefname\tmp% Tell cref the caption and its plural.
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Exercise like enviroments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \DisplayMode{<keys>} Enable the solution of an exerciselike enviroment with keys <keys> defined by \NewExerciseLikeEnviroment. Teh argument <keys> has to be a list seperatetd by ",". In addition to the exerciselike enviroments you can enable "note" for a lecturer version or "tags" for the collection mode.
\newcommand{\DisplayMode}[1]{%
    \ks@enable #1,\relax\noexpand\@eolst%
}

\def\ks@enable #1,#2\@eolst{%
    \ifx\relax#2\relax%
    \expandafter\global\csname @ks@#1true\endcsname%
    \else%
    \expandafter\global\csname @ks@#1true\endcsname%
    \ks@enable #2\@eolst%
    \fi%
}


% \NewExerciseLikeEnviroment[<style>]{<key>}{<english>}{<englishpl>}{<german>}{<germanpl>} Create a new enviroment <key> with style <style> (default: exercise). The displayed name of the enviroment is translatable. You are able to use \begin{<key>}, \end{<key>} and \begin{solution}\end{solution} within it. The solution only will displayed for all enviroments of the type <key> when you call \EnableSolution{<key>} before.
\newcommand{\NewExerciseLikeEnviroment}[6][exercise]{%
    %
    \expandafter\newif\csname if@ks@#2\endcsname% Define the switch
    %
    \expandafter\csname @ks@#2false\endcsname% Set the default value to false
    %
    \theoremstyle{#1}% Set the theoremstyle
    %
    \theoremprework{%
        \def\ks@solkey{#2}% Set the solution key at the beginning of the enviroment
        \crefname{enumi}{\csname #2autorefname\endcsname\ \csname the#2\endcsname}{\csname #2autorefnames\endcsname\ \csname the#2\endcsname}% Set the name of references for sub tasks.
    }%
    \theorempostwork{\def\ks@solkey{}}% Reset the solution key at the end of the enviroment
    %
    \NewTranslatableEnviroment{#2}{#3}{#4}{#5}{#6}
}


\NewExerciseLikeEnviroment{task}{Presence task}{Presence tasks}{Präsenzaufgabe}{Präsenzaufgaben}

\NewExerciseLikeEnviroment{homework}{Homework}{Homework}{Hausaufgabe}{Hausaufgaben}

\NewExerciseLikeEnviroment{exercise}{Exercise}{Exercises}{Aufgabe}{Aufgaben}

\NewExerciseLikeEnviroment[nonumber]{extra}{Extra}{Extra}{Zusatzaufgabe}{Zusatzaufgaben}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Solution like enviroments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set the enviroment style
\theoremstyle{solution}

% Declare the Solution enviroment
\NewTranslatableEnviroment{solutionThm}{Solution sketch}{Solution sketches}{Lösungshinweis}{Lösungshinweise}

% Make the solution enviroment save for the solution keys, i.e. only print the solution if it is enabled.
\NewEnviron{solution}{%
    \ks@sol@save{\begin{solutionThm}\BODY}%
    }[%
    \ks@sol@save{\end{solutionThm}}%
]

% Define Solution hints for useing inline.
\newcommand{\sol}[1]{%
    \ks@sol@save{(#1)}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Hint like enviroments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set the enviroment style
\theorembodyfont{\itshape}
\theorempreskip{0pt}
\theorempostskip{0pt}
\theoremstyle{hint}

\NewTranslatableEnviroment{hint}{Hint}{Hints}{Hinweis}{Hinweise}

\NewTranslatableEnviroment{info}{Information}{Information}{Information}{Informationen}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% List like enviroments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Redefine the enumeration for subexercises
\setlist[enumerate,1]{label*=\alph*)}
\setlist[enumerate,2]{label=\roman*),ref=\alph{enumi}.\roman*)}

% Item label for wrong (w) answers in quizes
\def\ks@wlable{$\square$}

% Item label for right (r) answers. By default it looks the same as the wrong item. But if the solution is enabled it will change its shape to a checked square.
\def\ks@rlable{\ks@wlable}

% \itemr Define a new item to use for right (r) answers in quizes. The item label will change to a checked square if the solution is enabled.
\newcommand{\itemr}{\item[\ks@rlable]}

% \itemw Define a new item to use for wrong (w) answers in quizes. It is the same as \item in quiz enviroments. It is just for consitency.
\newcommand{\itemw}{\item[\ks@wlable]}

% Define the quiz enviroment
\newenvironment{quiz}{%
    %
    \begin{itemize}% start a normal itemize enviroment
        %
        \renewcommand{\labelitemi}{\ks@wlable}% redefine the standard item label
        %
        \ks@sol@save{\def\ks@rlable{$\text{\rlap{$\checkmark$}}\square$}}% redefine the label for the right answers (\itemr) if and only if the solution is enabled
    }{%
    \end{itemize}% end the itemize enviroment
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Notes for tutors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define the switch and set it to false
\newif\if@ks@note\@ks@notefalse

%
\newcommand{\note}[2][]{%
    \if@ks@note{%
        \renewcommand\thefootnote{\textcolor{red}{\arabic{footnote}}}%
        \ifx\relax#2%
        \else\textcolor{red}{#2}%
        \fi%
        \ifx\relax#1\else%
        \footnote{\textcolor{red}{#1}}%
        \fi}%
    \fi%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Tags
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define the switch and set it to false
\newif\if@ks@tags\@ks@tagsfalse

\newcommand{\tags}[1]{%
    \if@ks@tags{%
        \textbf{Tags:} #1\par
    }%
    \fi%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Translations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Make "Points" translatable
\def\points{points}
\defcaptionname{ngerman}{\points}{Punkte}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\InputIfFileExists{./Utils/config.tex}{}{}
\InputIfFileExists{./Utils/custom.tex}{}{}