@c -*- Mode: texinfo -*-
@menu
* Comments::
* Files::
* Functions and Variables for File Input and Output::
* Functions and Variables for TeX Output::
* Functions and Variables for Fortran Output::
@end menu

@c -----------------------------------------------------------------------------
@node Comments, Files, File Input and Output, File Input and Output
@section Comments
@c -----------------------------------------------------------------------------

A comment in Maxima input is any text between @code{/*} and @code{*/}.

The Maxima parser treats a comment as whitespace for the purpose of finding
tokens in the input stream; a token always ends at a comment.  An input such as
@code{a/* foo */b} contains two tokens, @code{a} and @code{b},
and not a single token @code{ab}.  Comments are otherwise ignored by Maxima;
neither the content nor the location of comments is stored in parsed input
expressions.

Comments can be nested to arbitrary depth.  The @code{/*} and @code{*/}
delimiters form matching pairs.  There must be the same number of @code{/*}
as there are @code{*/}.

Examples:

@c ===beg===
@c /* aa is a variable of interest */  aa : 1234;
@c /* Value of bb depends on aa */  bb : aa^2;
@c /* User-defined infix operator */  infix ("b");
@c /* Parses same as a b c, not abc */  a/* foo */b/* bar */c;
@c /* Comments /* can be nested /* to any depth */ */ */  1 + xyz;
@c ===end===
@example
(%i1) /* aa is a variable of interest */  aa : 1234;
(%o1)                         1234
(%i2) /* Value of bb depends on aa */  bb : aa^2;
(%o2)                        1522756
(%i3) /* User-defined infix operator */  infix ("b");
(%o3)                           b
(%i4) /* Parses same as a b c, not abc */  a/* foo */b/* bar */c;
(%o4)                         a b c
(%i5) /* Comments /* can be nested /* to any depth */ */ */  1 + xyz;
(%o5)                        xyz + 1
@end example

@opencatbox
@category{Syntax}
@closecatbox

@c -----------------------------------------------------------------------------
@node Files, Functions and Variables for File Input and Output, Comments, File Input and Output
@section Files
@c -----------------------------------------------------------------------------

A file is simply an area on a particular storage device which contains data 
or text.  Files on the disks are figuratively grouped into "directories".
A directory is just a list of files.  Commands which deal with files are:

@verbatim
   appendfile           batch                 batchload
   closefile            file_output_append    filename_merge
   file_search          file_search_maxima    file_search_lisp
   file_search_demo     file_search_usage     file_search_tests
   file_type            file_type_lisp        file_type_maxima
   load                 load_pathname         loadfile
   loadprint            pathname_directory    pathname_name
   pathname_type        printfile             save
   stringout            with_stdout           writefile
@end verbatim

When a file name is passed to functions like @mrefcomma{plot2d}@w{}
@mrefcomma{save} or @mref{writefile} and the file name does not include a path,
Maxima stores the file in the current working directory.  The current working
directory depends on the system like Windows or Linux and on the installation.

@c -----------------------------------------------------------------------------
@node Functions and Variables for File Input and Output, Functions and Variables for TeX Output, Files, File Input and Output
@section Functions and Variables for File Input and Output
@c -----------------------------------------------------------------------------

@c -----------------------------------------------------------------------------
m4_setcat(File output, Console interaction)
@anchor{appendfile}
@c @deffn {Function} appendfile (@var{filename})
m4_deffn({Function}, appendfile, <<<(@var{filename})>>>)

Appends a console transcript to @var{filename}.  @code{appendfile} is the same
as @mrefcomma{writefile} except that the transcript file, if it exists, is
always appended.

@mref{closefile} closes the transcript file opened by @code{appendfile} or
@code{writefile}.

@c @opencatbox
@c @category{File output}
@c @category{Console interaction}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(Session management, File input)
@anchor{batch}
@c @deffn  {Function} batch @
m4_deffn( {Function}, batch, <<<>>>) @
@fname{batch} (@var{filename}) @
@fname{batch} (@var{filename}, @code{option})

@code{batch(@var{filename})} reads Maxima expressions from @var{filename} and 
evaluates them.  @code{batch} searches for @var{filename} in the list 
@mrefdot{file_search_maxima}  See also @mrefdot{file_search}

@code{batch(@var{filename}, @code{demo})} is like @code{demo(@var{filename})}.
In this case @code{batch} searches for @var{filename} in the list
@mrefdot{file_search_demo}  See @mrefdot{demo}

@code{batch(@var{filename}, @code{test})} is like @mref{run_testsuite} with the
option @code{display_all=true}.  For this case @code{batch} searches 
@var{filename} in the list @code{file_search_maxima} and not in the list
@mref{file_search_tests} like @code{run_testsuite}.  Furthermore,
@code{run_testsuite} runs tests which are in the list
@mrefdot{testsuite_files}  With @code{batch} it is possible to run any file in
a test mode, which can be found in the list @code{file_search_maxima}.  This is
useful, when writing a test file.

@var{filename} comprises a sequence of Maxima expressions, each terminated with
@code{;} or @code{$}.  The special variable @mref{%} and the function
@mref{%th} refer to previous results within the file.  The file may include
@code{:lisp} constructs.  Spaces, tabs, and newlines in the file are ignored.
A suitable input file may be created by a text editor or by the
@mref{stringout} function.

@code{batch} reads each input expression from @var{filename}, displays the input
to the console, computes the corresponding output expression, and displays the
output expression.  Input labels are assigned to the input expressions and
output labels are assigned to the output expressions.  @code{batch} evaluates
every input expression in the file unless there is an error.  If user input is
requested (by @mref{asksign} or @mrefcomma{askinteger} for example) @code{batch}
pauses to collect the requisite input and then continue.

@c CTRL-C BREAKS batch IN CMUCL, BUT CLISP (ALTHOUGH IT SHOWS "User break") 
@c KEEPS GOING !!! DON'T KNOW ABOUT GCL !!!
It may be possible to halt @code{batch} by typing @code{control-C} at the
console.  The effect of @code{control-C} depends on the underlying Lisp
implementation.

@code{batch} has several uses, such as to provide a reservoir for working
command lines, to give error-free demonstrations, or to help organize one's
thinking in solving complex problems.

@code{batch} evaluates its argument.  @code{batch} returns the path of
@var{filename} as a string, when called with no second argument or with the 
option @code{demo}.  When called with the option @code{test}, the return value
is a an empty list @code{[]} or a list with @var{filename} and the numbers of
the tests which have failed.

See also @mrefcomma{load} @mrefcomma{batchload} and @mrefdot{demo}

@c @opencatbox
@c @category{Session management}
@c @category{File input}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c RECOMMEND CUTTING THIS ITEM, AS THE load SUBSUMES FUNCTIONALITY OF batchload

@c -----------------------------------------------------------------------------
@anchor{batchload}
@c @deffn {Function} batchload (@var{filename})
m4_deffn({Function}, batchload, <<<(@var{filename})>>>)

Reads Maxima expressions from @var{filename} and evaluates them, without
displaying the input or output expressions and without assigning labels to
output expressions.  Printed output (such as produced by @mref{print} or
@mrefparen{describe}) is displayed, however.

The special variable @mref{%} and the function @mref{%th} refer to previous
results from the interactive interpreter, not results within the file.
The file cannot include @code{:lisp} constructs.

@code{batchload} returns the path of @var{filename}, as a string.
@code{batchload} evaluates its argument.

See also @mrefcomma{batch} and @mrefdot{load}
@c batchload APPEARS TO HAVE THE SAME EFFECT AS load.
@c WHY NOT GET RID OF batchload ???

@c @opencatbox
@c @category{Session management}
@c @category{File input}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(File output, Console interaction)
@anchor{closefile}
@c @deffn {Function} closefile ()
m4_deffn({Function}, closefile, <<<()>>>)

Closes the transcript file opened by @mref{writefile} or @mrefdot{appendfile}

@c @opencatbox
@c @category{File output}
@c @category{Console interaction}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(File output, Global flags)
@anchor{file_output_append}
@c @defvr {Option variable} file_output_append
m4_defvr({Option variable}, file_output_append)
Default value: @code{false}

@code{file_output_append} governs whether file output functions append or
truncate their output file.  When @code{file_output_append} is @code{true}, such
functions append to their output file.  Otherwise, the output file is truncated.

@mrefcomma{save} @mrefcomma{stringout} and @mref{with_stdout} respect
@code{file_output_append}.  Other functions which write output files do not
respect @code{file_output_append}.  In particular, plotting and translation
functions always truncate their output file, and @mref{tex} and
@mref{appendfile} always append.
@c WHAT ABOUT WRITEFILE ??

@c @opencatbox
@c @category{File output}
@c @category{Global flags}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c NEEDS EXAMPLES

@c -----------------------------------------------------------------------------
m4_setcat(File input, File output)
@anchor{filename_merge}
@c @deffn {Function} filename_merge (@var{path}, @var{filename})
m4_deffn({Function}, filename_merge, <<<(@var{path}, @var{filename})>>>)

Constructs a modified path from @var{path} and @var{filename}.  If the final
component of @var{path} is of the form @code{###.@var{something}}, the component
is replaced with @code{@var{filename}.@var{something}}.  Otherwise, the final
component is simply replaced by @var{filename}.

The result is a Lisp pathname object.

@c @opencatbox
@c @category{File input}
@c @category{File output}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(File input)
@anchor{file_search}
@c @deffn  {Function} file_search @
m4_deffn( {Function}, file_search, <<<>>>) @
@fname{file_search} (@var{filename}) @
@fname{file_search} (@var{filename}, @var{pathlist})

@code{file_search} searches for the file @var{filename} and returns the path to
the file (as a string) if it can be found; otherwise @code{file_search} returns
@code{false}.  @code{file_search (@var{filename})} searches in the default
search directories, which are specified by the
@mrefcomma{file_search_maxima} @mrefcomma{file_search_lisp} and
@mref{file_search_demo} variables.

@code{file_search} first checks if the actual name passed exists,
before attempting to match it to ``wildcard'' file search patterns.
See @mref{file_search_maxima} concerning file search patterns.

The argument @var{filename} can be a path and file name, or just a file name,
or, if a file search directory includes a file search pattern, just the base of
the file name (without an extension).  For example,

@example
file_search ("/home/wfs/special/zeta.mac");
file_search ("zeta.mac");
file_search ("zeta");
@end example

all find the same file, assuming the file exists and 
@code{/home/wfs/special/###.mac} is in @code{file_search_maxima}.

@code{file_search (@var{filename}, @var{pathlist})} searches only in the
directories specified by @var{pathlist}, which is a list of strings.  The
argument @var{pathlist} supersedes the default search directories, so if the
path list is given, @code{file_search} searches only the ones specified, and not
any of the default search directories.  Even if there is only one directory in
@var{pathlist}, it must still be given as a one-element list.

The user may modify the default search directories.
See @mrefdot{file_search_maxima}

@code{file_search} is invoked by @mref{load} with @code{file_search_maxima} and
@mref{file_search_lisp} as the search directories.

@c @opencatbox
@c @category{File input}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(File input, Global variables)
@anchor{file_search_maxima}
@anchor{file_search_lisp}
@anchor{file_search_demo}
@anchor{file_search_usage}
@anchor{file_search_tests}
@c @defvr  {Option variable} file_search_maxima
m4_defvr(  {Option variable}, file_search_maxima)
@c @defvrx {Option variable} file_search_lisp
m4_defvrx( {Option variable}, file_search_lisp)
@c @defvrx {Option variable} file_search_demo
m4_defvrx( {Option variable}, file_search_demo)
@c @defvrx {Option variable} file_search_usage
m4_defvrx( {Option variable}, file_search_usage)
@c @defvrx {Option variable} file_search_tests
m4_defvrx( {Option variable}, file_search_tests)

These variables specify lists of directories to be searched by
@mrefcomma{load} @mrefcomma{demo} and some other Maxima functions.  The default
values of these variables name various directories in the Maxima installation.

The user can modify these variables, either to replace the default values or to
append additional directories.  For example,

@example
file_search_maxima: ["/usr/local/foo/###.mac",
    "/usr/local/bar/###.mac"]$
@end example

replaces the default value of @code{file_search_maxima}, while

@example
file_search_maxima: append (file_search_maxima,
    ["/usr/local/foo/###.mac", "/usr/local/bar/###.mac"])$
@end example

appends two additional directories.  It may be convenient to put such an
expression in the file @code{maxima-init.mac} so that the file search path is
assigned automatically when Maxima starts.
See also @ref{Introduction for Runtime Environment}.

Multiple filename extensions and multiple paths can be specified by special 
``wildcard'' constructions.  The string @code{###} expands into the sought-after
name, while a comma-separated list enclosed in curly braces
@code{@{foo,bar,baz@}} expands into multiple strings.  For example, supposing
the sought-after name is @code{neumann},

@example
"/home/@{wfs,gcj@}/###.@{lisp,mac@}"
@end example

@flushleft
expands into @code{/home/wfs/neumann.lisp}, @code{/home/gcj/neumann.lisp},
@code{/home/wfs/neumann.mac}, and @code{/home/gcj/neumann.mac}.
@end flushleft

@c @opencatbox
@c @category{File input}
@c @category{Global variables}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat(File input)
@anchor{file_type}
@c @deffn {Function} file_type (@var{filename})
m4_deffn({Function}, file_type, <<<(@var{filename})>>>)

Returns a guess about the content of @var{filename}, based on the filename 
extension.  @var{filename} need not refer to an actual file; no attempt is made 
to open the file and inspect the content.

The return value is a symbol, either @code{object}, @code{lisp}, or
@code{maxima}.  If the extension is matches one of the values in
@code{file_type_maxima}, @code{file_type} returns @code{maxima}.  If the
extension matches one of the values in @code{file_type_lisp}, @code{file_type}
returns @code{lisp}.  If none of the above, @code{file_type} returns
@code{object}.

See also @mrefdot{pathname_type}

See @mref{file_type_maxima} and @mref{file_type_lisp} for the default values.

Examples:

@c ===beg===
@c map('file_type,
@c     ["test.lisp", "test.mac", "test.dem", "test.txt"]);
@c ===end===
@example
(%i2) map('file_type,
          ["test.lisp", "test.mac", "test.dem", "test.txt"]);
(%o2)            [lisp, maxima, maxima, object]
@end example

@c @opencatbox
@c @category{File input}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat()
@anchor{file_type_lisp}
@c @defvr {Option variable} file_type_lisp
m4_defvr( {Option variable}, file_type_lisp)
Default value:  @code{[l, lsp, lisp]}

@code{file_type_lisp} is a list of file extensions that maxima recognizes
as denoting a Lisp source file.

See also @mrefdot{file_type}
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
@anchor{file_type_maxima}
@c @defvr {Option variable} file_type_maxima
m4_defvr( {Option variable}, file_type_maxima)
Default value:  @code{[mac, mc, demo, dem, dm1, dm2, dm3, dmt, wxm]}

@code{file_type_maxima} is a list of file extensions that maxima recognizes
as denoting a Maxima source file.

See also @mrefdot{file_type}
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat(Session management, File input)
@anchor{load}
@c @deffn {Function} load (@var{filename})
m4_deffn({Function}, load, <<<(@var{filename})>>>)

Evaluates expressions in @var{filename}, thus bringing variables, functions, and
other objects into Maxima.  The binding of any existing object is clobbered by
the binding recovered from @var{filename}.  To find the file, @code{load} calls
@mref{file_search} with @mref{file_search_maxima} and
@mref{file_search_lisp} as the search directories.  If @code{load} succeeds, it
returns the name of the file.  Otherwise @code{load} prints an error message.

@code{load} works equally well for Lisp code and Maxima code.  Files created by
@mrefcomma{save} @mrefcomma{translate_file} and @mrefcomma{compile_file} which
create Lisp code, and @mrefcomma{stringout} which creates Maxima code, can all
be processed by @code{load}.  @code{load} calls @mref{loadfile} to load Lisp
files and @mref{batchload} to load Maxima files.

@code{load} does not recognize @code{:lisp} constructs in Maxima files, and
while processing @var{filename}, the global variables @code{_}, @code{__},
@code{%}, and @code{%th} have whatever bindings they had when @code{load} was
called.

Note also that structures will only be read back as structures if
they have been defined by @code{defstruct} before the @code{load} command
is called.

See also @mrefcomma{loadfile} @mrefcomma{batch} @mrefcomma{batchload} and
@mrefdot{demo}  @code{loadfile} processes Lisp files; @code{batch},
@code{batchload}, and @code{demo} process Maxima files.

See @mref{file_search} for more detail about the file search mechanism.
Additionally the chapter on @mref{numericalio} describes many functions
that allow to load files that contain csv or similar data.

@code{load} evaluates its argument.

@c @opencatbox
@c @category{Session management}
@c @category{File input}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(File input)
@anchor{load_pathname}
@c @defvr {System variable} load_pathname
m4_defvr( {System variable}, load_pathname)
Default value: @code{false}

When a file is loaded with the functions @mrefcomma{load} @mref{loadfile} or
@mref{batchload} the system variable @code{load_pathname} is bound to the
pathname of the file which is processed.

The variable @code{load_pathname} can be accessed from the file during the
loading.

Example:

Suppose we have a batchfile @code{test.mac} in the directory
@flushleft
@code{"/home/dieter/workspace/mymaxima/temp/"} with the following commands
@end flushleft

@example
print("The value of load_pathname is: ", load_pathname)$
print("End of batchfile")$
@end example

then we get the following output

@example
(%i1) load("/home/dieter/workspace/mymaxima/temp/test.mac")$
The value of load_pathname is:  
                   /home/dieter/workspace/mymaxima/temp/test.mac 
End of batchfile
@end example

@c @opencatbox
@c @category{File input}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c RECOMMEND CUTTING THIS ITEM, AS THE load SUBSUMES FUNCTIONALITY OF loadfile

@c -----------------------------------------------------------------------------
m4_setcat(Session management, File input)
@anchor{loadfile}
@c @deffn {Function} loadfile (@var{filename})
m4_deffn({Function}, loadfile, <<<(@var{filename})>>>)

Evaluates Lisp expressions in @var{filename}.  @code{loadfile} does not invoke
@mrefcomma{file_search} so @code{filename} must include the file extension and
as much of the path as needed to find the file.

@code{loadfile} can process files created by @mrefcomma{save}@w{}
@mrefcomma{translate_file} and @mrefdot{compile_file}  The user may find it
more convenient to use @mref{load} instead of @code{loadfile}.

@c @opencatbox
@c @category{Session management}
@c @category{File input}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c loadprint DOESN'T EXACTLY WORK LIKE THIS, BUT IT HARDLY SEEMS WORTH FIXING
@c I GUESS THIS COULD BE UPDATED TO DESCRIBE THE WAY IT ACTUALLY WORKS

@c -----------------------------------------------------------------------------
m4_setcat(File input, Global flags)
@anchor{loadprint}
@c @defvr {Option variable} loadprint
m4_defvr( {Option variable}, loadprint)
Default value: @code{true}

@code{loadprint} tells whether to print a message when a file is loaded.

@itemize @bullet
@item
When @code{loadprint} is @code{true}, always print a message.
@item
When @code{loadprint} is @code{'loadfile}, print a message only if
a file is loaded by the function @code{loadfile}.
@item
When @code{loadprint} is @code{'autoload},
print a message only if a file is automatically loaded.
See @mrefdot{setup_autoload}
@item
When @code{loadprint} is @code{false}, never print a message.
@end itemize

@c @opencatbox
@c @category{File input}
@c @category{Global flags}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat(File input)
@anchor{directory}
@c @deffn {Function} directory (@var{path})
m4_deffn({Function}, directory, <<<(@var{path})>>>)

Returns a list of the files and directories found in @var{path}
in the file system.

@var{path} may contain wildcard characters (i.e., characters which represent
unspecified parts of the path),
which include at least the asterisk on most systems,
and possibly other characters, depending on the system.

@code{directory} relies on the Lisp function DIRECTORY,
which may have implementation-specific behavior.

@c @opencatbox
@c @category{File input}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(File input)
@anchor{pathname_directory}
@anchor{pathname_name}
@anchor{pathname_type}
@c @deffn  {Function} pathname_directory (@var{pathname})
@c @deffnx {Function} pathname_type (@var{pathname})
@c @deffnx {Function} pathname_name (@var{pathname})
m4_deffn( {Function}, pathname_directory, <<<(@var{pathname})>>>)
m4_deffnx({Function}, pathname_name, <<<(@var{pathname})>>>)
m4_deffnx({Function}, pathname_type, <<<(@var{pathname})>>>)

These functions return the components of @var{pathname}.

Examples:

@c ===beg===
@c pathname_directory("/home/dieter/maxima/changelog.txt");
@c pathname_name("/home/dieter/maxima/changelog.txt");
@c pathname_type("/home/dieter/maxima/changelog.txt");
@c ===end===
@example 
(%i1) pathname_directory("/home/dieter/maxima/changelog.txt");
(%o1)                 /home/dieter/maxima/
(%i2) pathname_name("/home/dieter/maxima/changelog.txt");
(%o2)                       changelog
(%i3) pathname_type("/home/dieter/maxima/changelog.txt");
(%o3)                          txt
@end example

@c @opencatbox
@c @category{File input}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(File input, Console interaction)
@anchor{printfile}
@c @deffn {Function} printfile (@var{path})
m4_deffn({Function}, printfile, <<<(@var{path})>>>)

Prints the file named by @var{path} to the console.  @var{path} may be a string
or a symbol; if it is a symbol, it is converted to a string.

If @var{path} names a file which is accessible from the current working
directory, that file is printed to the console.  Otherwise, @code{printfile}
attempts to locate the file by appending @var{path} to each of the elements of
@mref{file_search_usage} via @mrefdot{filename_merge}

@code{printfile} returns @var{path} if it names an existing file,
or otherwise the result of a successful filename merge.

@c @opencatbox
@c @category{File input}
@c @category{Console interaction}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c NEEDS EXAMPLES

@c -----------------------------------------------------------------------------
m4_setcat(Session management, File output)
@anchor{save}
@c @deffn  {Function} save @
m4_deffn( {Function}, save, <<<>>>) @
@fname{save} (@var{filename}, @var{name_1}, @var{name_2}, @var{name_3}, @dots{}) @
@fname{save} (@var{filename}, values, functions, labels, @dots{}) @
@fname{save} (@var{filename}, [@var{m}, @var{n}]) @
@fname{save} (@var{filename}, @var{name_1}=@var{expr_1}, @dots{}) @
@fname{save} (@var{filename}, all) @
@fname{save} (@var{filename}, @var{name_1}=@var{expr_1}, @var{name_2}=@var{expr_2}, @dots{})

Stores the current values of @var{name_1}, @var{name_2}, @var{name_3}, @dots{},
in @var{filename}.  The arguments are the names of variables, functions, or
other objects.  If a name has no value or function associated with it, it is
ignored.  @code{save} returns @var{filename}.

@code{save} stores data in the form of Lisp expressions.
If @var{filename} ends in @code{.lisp} the
data stored by @code{save} may be recovered by @code{load (@var{filename})}.
See @mrefdot{load}

The global flag @mref{file_output_append} governs whether @code{save} appends or
truncates the output file.  When @code{file_output_append} is @code{true},
@code{save} appends to the output file.  Otherwise, @code{save} truncates the
output file.  In either case, @code{save} creates the file if it does not yet
exist.

The special form @code{save (@var{filename}, values, functions, labels, ...)}
stores the items named by @mrefcomma{values} @mrefcomma{functions}@w{}
@mrefcomma{labels} etc.  The names may be any specified by the variable
@mrefdot{infolists}  @code{values} comprises all user-defined variables.

The special form @code{save (@var{filename}, [@var{m}, @var{n}])} stores the
values of input and output labels @var{m} through @var{n}.  Note that @var{m}
and @var{n} must be literal integers.  Input and output labels may also be
stored one by one, e.g., @code{save ("foo.1", %i42, %o42)}.
@code{save (@var{filename}, labels)} stores all input and output labels.
When the stored labels are recovered, they clobber existing labels.

The special form @code{save (@var{filename}, @var{name_1}=@var{expr_1},
@var{name_2}=@var{expr_2}, ...)} stores the values of @var{expr_1},
@var{expr_2}, @dots{}, with names @var{name_1}, @var{name_2}, @dots{}
It is useful to apply this form to input and output labels, e.g.,
@code{save ("foo.1", aa=%o88)}.  The right-hand side of the equality in this
form may be any expression, which is evaluated.  This form does not introduce
the new names into the current Maxima environment, but only stores them in
@var{filename}.

These special forms and the general form of @code{save} may be mixed at will.
For example, @code{save (@var{filename}, aa, bb, cc=42, functions, [11, 17])}.

The special form @code{save (@var{filename}, all)} stores the current state of
Maxima.  This includes all user-defined variables, functions, arrays, etc., as
well as some automatically defined items.  The saved items include system
variables, such as @mref{file_search_maxima} or @mrefcomma{showtime} if they
have been assigned new values by the user; see @mrefdot{myoptions}

@code{save} evaluates @var{filename} and quotes all other arguments.

@c @opencatbox
@c @category{Session management}
@c @category{File output}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
@anchor{stringout}
@c @deffn  {Function} stringout @
m4_deffn( {Function}, stringout, <<<>>>) @
@fname{stringout} (@var{filename}, @var{expr_1}, @var{expr_2}, @var{expr_3}, @dots{}) @
@fname{stringout} (@var{filename}, [@var{m}, @var{n}]) @
@fname{stringout} (@var{filename}, input) @
@fname{stringout} (@var{filename}, functions) @
@fname{stringout} (@var{filename}, values)

@code{stringout} writes expressions to a file in the same form the expressions
would be typed for input.  The file can then be used as input for the
@mref{batch} or @mref{demo} commands, and it may be edited for any purpose.
@code{stringout} can be executed while @mref{writefile} is in progress.

The global flag @mref{file_output_append} governs whether @code{stringout}
appends or truncates the output file.  When @code{file_output_append} is
@code{true}, @code{stringout} appends to the output file.  Otherwise,
@code{stringout} truncates the output file.  In either case, @code{stringout}
creates the file if it does not yet exist.

The general form of @code{stringout} writes the values of one or more 
expressions to the output file.  Note that if an expression is a
variable, only the value of the variable is written and not the name
of the variable.  As a useful special case, the expressions may be
input labels (@code{%i1}, @code{%i2}, @code{%i3}, @dots{}) or output labels
(@code{%o1}, @code{%o2}, @code{%o3}, @dots{}).

If @mref{grind} is @code{true}, @code{stringout} formats the output using the
@code{grind} format.  Otherwise the @code{string} format is used.  See
@code{grind} and @code{string}.

The special form @code{stringout (@var{filename}, [@var{m}, @var{n}])} writes
the values of input labels m through n, inclusive.

The special form @code{stringout (@var{filename}, input)} writes all
input labels to the file.

The special form @code{stringout (@var{filename}, functions)} writes all
user-defined functions (named by the global list @mrefparen{functions}) to the
file.

The special form @code{stringout (@var{filename}, values)} writes all
user-assigned variables (named by the global list @mrefparen{values}) to the file.
Each variable is printed as an assignment statement, with the name of the
variable, a colon, and its value.  Note that the general form of
@code{stringout} does not print variables as assignment statements.

@c @opencatbox
@c @category{Session management}
@c @category{File output}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(File output)
@anchor{with_stdout}
@c @deffn  {Function} with_stdout @
m4_deffn( {Function}, with_stdout, <<<>>>) @
@fname{with_stdout} (@var{f}, @var{expr_1}, @var{expr_2}, @var{expr_3}, @dots{}) @
@fname{with_stdout} (@var{s}, @var{expr_1}, @var{expr_2}, @var{expr_3}, @dots{})

Evaluates @var{expr_1}, @var{expr_2}, @var{expr_3}, @dots{} and writes any
output thus generated to a file @var{f} or output stream @var{s}.  The evaluated
expressions are not written to the output.  Output may be generated by
@mrefcomma{print} @mrefcomma{display} @mrefcomma{grind} among other functions.

The global flag @mref{file_output_append} governs whether @code{with_stdout}
appends or truncates the output file @var{f}.  When @code{file_output_append}
is @code{true}, @code{with_stdout} appends to the output file.  Otherwise,
@code{with_stdout} truncates the output file.  In either case,
@code{with_stdout} creates the file if it does not yet exist.

@code{with_stdout} returns the value of its final argument.

See also @mref{writefile} and @mrefdot{display2d}

@c THIS DOESN'T SEEM VERY IMPORTANT TO MENTION ...
@c Note the binding of display2d to be
@c false, otherwise the printing will have things like "- 3" instead
@c of "-3".
@c
@example
@c THIS EXAMPLE USES SOME UNIX-ISH CONSTRUCTS -- WILL IT WORK IN WINDOWS ???
@c ALSO IT'S SORT OF COMPLICATED AND THE SIMPLER SECOND EXAMPLE ILLUSTRATES with_stdout BETTER !!!
@c mygnuplot (f, var, range, number_ticks) :=
@c  block ([numer:true, display2d:false],
@c  with_stdout("tmp.out",
@c    dx: (range[2]-range[1])/number_ticks,
@c    for x: range[1] thru range[2] step dx
@c       do print (x, at (f, var=x))),
@c  system ("echo \"set data style lines; set title '", f,"' ;plot '/tmp/gnu'
@c ;pause 10 \" | gnuplot"))$
(%i1) with_stdout ("tmp.out", for i:5 thru 10 do
      print (i, "! yields", i!))$
(%i2) printfile ("tmp.out")$
5 ! yields 120 
6 ! yields 720 
7 ! yields 5040 
8 ! yields 40320 
9 ! yields 362880 
10 ! yields 3628800
@end example

@c @opencatbox
@c @category{File output}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(File output, Console interaction)
@anchor{writefile}
@c @deffn {Function} writefile (@var{filename})
m4_deffn({Function}, writefile, <<<(@var{filename})>>>)

Begins writing a transcript of the Maxima session to @var{filename}.
All interaction between the user and Maxima is then recorded in this file,
@c FOLLOWING CLAIM PROBABLY NEEDS TO BE QUALIFIED
just as it appears on the console.

As the transcript is printed in the console output format, it cannot be reloaded
into Maxima.  To make a file containing expressions which can be reloaded,
see @mref{save} and @mrefdot{stringout}  @code{save} stores expressions in Lisp
form, while @code{stringout} stores expressions in Maxima form.

The effect of executing @code{writefile} when @var{filename} already exists
depends on the underlying Lisp implementation; the transcript file may be
clobbered, or the file may be appended.  @mref{appendfile} always appends to
the transcript file.

It may be convenient to execute @mref{playback} after @code{writefile} to save
the display of previous interactions.  As @code{playback} displays only the
input and output variables (@code{%i1}, @code{%o1}, etc.), any output generated
by a print statement in a function (as opposed to a return value) is not
displayed by @code{playback}.

@mref{closefile} closes the transcript file opened by @code{writefile} or
@code{appendfile}.

@c @opencatbox
@c @category{File output}
@c @category{Console interaction}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
@node Functions and Variables for TeX Output, Functions and Variables for Fortran Output, Functions and Variables for File Input and Output, File Input and Output
@section Functions and Variables for TeX Output
@c -----------------------------------------------------------------------------

@c -----------------------------------------------------------------------------

Note that the built-in TeX output functionality of wxMaxima makes no use of
the functions described here but uses its own implementation instead.

m4_setcat(TeX output, File output)
@anchor{tex}
@c @deffn  {Function} tex @
m4_deffn( {Function}, tex, <<<>>>) @
@fname{tex} (@var{expr}) @
@fname{tex} (@var{expr}, @var{destination}) @
@fname{tex} (@var{expr}, false) @
@fname{tex} (@var{label}) @
@fname{tex} (@var{label}, @var{destination}) @
@fname{tex} (@var{label}, false)

Prints a representation of an expression suitable for the TeX document
preparation system.  The result is a fragment of a document, which can be copied
into a larger document but not processed by itself.

@code{tex (@var{expr})} prints a TeX representation of @var{expr} on the
console.

@code{tex (@var{label})} prints a TeX representation of the expression named by
@var{label} and assigns it an equation label (to be displayed to the left of the
expression).  The TeX equation label is the same as the Maxima label.

@var{destination} may be an output stream or file name.  When @var{destination}
is a file name, @code{tex} appends its output to the file.  The functions
@code{openw} and @code{opena} create output streams.

@code{tex (@var{expr}, false)} and @code{tex (@var{label}, false)}
return their TeX output as a string.

@code{tex} evaluates its first argument after testing it to see if it is a
label.  Quote-quote @code{''} forces evaluation of the argument, thereby
defeating the test and preventing the label.

See also @mrefdot{texput}

Examples:

@example
(%i1) integrate (1/(1+x^3), x);
                                    2 x - 1
                  2            atan(-------)
             log(x  - x + 1)        sqrt(3)    log(x + 1)
(%o1)      - --------------- + ------------- + ----------
                    6             sqrt(3)          3
(%i2) tex (%o1);
$$-@{@{\log \left(x^2-x+1\right)@}\over@{6@}@}+@{@{\arctan \left(@{@{2\,x-1
 @}\over@{\sqrt@{3@}@}@}\right)@}\over@{\sqrt@{3@}@}@}+@{@{\log \left(x+1\right)
 @}\over@{3@}@}\leqno@{\tt (\%o1)@}$$
(%o2)                          (\%o1)
(%i3) tex (integrate (sin(x), x));
$$-\cos x$$
(%o3)                           false
(%i4) tex (%o1, "foo.tex");
(%o4)                          (\%o1)
@end example

@code{tex (@var{expr}, false)} returns its TeX output as a string.

@c ===beg===
@c S : tex (x * y * z, false);
@c S;
@c ===end===
@example
(%i1) S : tex (x * y * z, false);
(%o1) $$x\,y\,z$$
(%i2) S;
(%o2) $$x\,y\,z$$
@end example

@c @opencatbox
@c @category{TeX output}
@c @category{File output}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(TeX output)
@anchor{tex1}
@c @deffn {Function} tex1 (@var{e})
m4_deffn({Function}, tex1, <<<(@var{e})>>>)

Returns a string which represents the TeX output for the expressions @var{e}.
The TeX output is not enclosed in delimiters for an equation or any other
environment.

Examples:

@c ===beg===
@c tex1 (sin(x) + cos(x));
@c ===end===
@example
(%i1) tex1 (sin(x) + cos(x));
(%o1)                     \sin x+\cos x
@end example
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
m4_setcat(TeX output)
@anchor{texput}
@c @deffn  {Function} texput @
m4_deffn( {Function}, texput, <<<>>>) @
@fname{texput} (@var{a}, @var{s}) @
@fname{texput} (@var{a}, @var{f}) @
@fname{texput} (@var{a}, @var{s}, @var{operator_type}) @
@fname{texput} (@var{a}, [@var{s_1}, @var{s_2}], matchfix) @
@fname{texput} (@var{a}, [@var{s_1}, @var{s_2}, @var{s_3}], matchfix)

Assign the TeX output for the atom @var{a}, which can be a symbol or the name
of an operator.

@code{texput (@var{a}, @var{s})} causes the @code{tex} function to interpolate
the string @var{s} into the TeX output in place of @var{a}.

@code{texput (@var{a}, @var{f})} causes the @code{tex} function to call the
function @var{f} to generate TeX output.  @var{f} must accept one argument,
which is an expression which has operator @var{a}, and must return a string
(the TeX output).  @var{f} may call @code{tex1} to generate TeX output for the
arguments of the input expression.

@code{texput (@var{a}, @var{s}, @var{operator_type})}, where @var{operator_type}
is @code{prefix}, @code{infix}, @code{postfix}, @code{nary}, or @code{nofix},
causes the @code{tex} function to interpolate @var{s} into the TeX output in
place of @var{a}, and to place the interpolated text in the appropriate
position.

@code{texput (@var{a}, [@var{s_1}, @var{s_2}], matchfix)} causes the @code{tex}
function to interpolate @var{s_1} and @var{s_2} into the TeX output on either
side of the arguments of @var{a}.  The arguments (if more than one) are
separated by commas.

@code{texput (@var{a}, [@var{s_1}, @var{s_2}, @var{s_3}], matchfix)} causes the
@code{tex} function to interpolate @var{s_1} and @var{s_2} into the TeX output
on either side of the arguments of @var{a}, with @var{s_3} separating the
arguments.

Examples:

Assign TeX output for a variable.

@c ===beg===
@c texput (me,"\\mu_e");
@c tex (me);
@c ===end===
@example
(%i1) texput (me,"\\mu_e");
(%o1)                         \mu_e
(%i2) tex (me);
$$\mu_e$$
(%o2)                         false
@end example

Assign TeX output for an ordinary function (not an operator).

@c ===beg===
@c texput (lcm, "\\mathrm{lcm}");
@c tex (lcm (a, b));
@c ===end===
@example
(%i1) texput (lcm, "\\mathrm@{lcm@}");
(%o1)                     \mathrm@{lcm@}
(%i2) tex (lcm (a, b));
$$\mathrm@{lcm@}\left(a , b\right)$$
(%o2)                         false
@end example

Call a function to generate TeX output.

@c ===beg===
@c texfoo (e) := block ([a, b], [a, b] : args (e),
@c   concat ("\\left[\\stackrel{",tex1(b),"}{",tex1(a),"}\\right]"))$
@c texput (foo, texfoo);
@c tex (foo (2^x, %pi));
@c ===end===
@example
(%i1) texfoo (e) := block ([a, b], [a, b] : args (e),
  concat("\\left[\\stackrel@{",tex1(b),"@}@{",tex1(a),"@}\\right]"))$
(%i2) texput (foo, texfoo);
(%o2)                        texfoo
(%i3) tex (foo (2^x, %pi));
$$\left[\stackrel@{\pi@}@{2^@{x@}@}\right]$$
(%o3)                         false
@end example

Assign TeX output for a prefix operator.

@c ===beg===
@c prefix ("grad");
@c texput ("grad", " \\nabla ", prefix);
@c tex (grad f);
@c ===end===
@example
(%i1) prefix ("grad");
(%o1)                         grad
(%i2) texput ("grad", " \\nabla ", prefix);
(%o2)                        \nabla 
(%i3) tex (grad f);
$$ \nabla f$$
(%o3)                         false
@end example

Assign TeX output for an infix operator.

@c ===beg===
@c infix ("~");
@c texput ("~", " \\times ", infix);
@c tex (a ~ b);
@c ===end===
@example
(%i1) infix ("~");
(%o1)                           ~
(%i2) texput ("~", " \\times ", infix);
(%o2)                        \times 
(%i3) tex (a ~ b);
$$a \times b$$
(%o3)                         false
@end example

Assign TeX output for a postfix operator.

@c ===beg===
@c postfix ("##");
@c texput ("##", "!!", postfix);
@c tex (x ##);
@c ===end===
@example
(%i1) postfix ("##");
(%o1)                          ##
(%i2) texput ("##", "!!", postfix);
(%o2)                          !!
(%i3) tex (x ##);
$$x!!$$
(%o3)                         false
@end example

Assign TeX output for a nary operator.

@c ===beg===
@c nary ("@@");
@c texput ("@@", " \\circ ", nary);
@c tex (a @@ b @@ c @@ d);
@c ===end===
@example
(%i1) nary ("@@@@");
(%o1)                          @@@@
(%i2) texput ("@@@@", " \\circ ", nary);
(%o2)                         \circ 
(%i3) tex (a @@@@ b @@@@ c @@@@ d);
$$a \circ b \circ c \circ d$$
(%o3)                         false
@end example

Assign TeX output for a nofix operator.

@c ===beg===
@c nofix ("foo");
@c texput ("foo", "\\mathsc{foo}", nofix);
@c tex (foo);
@c ===end===
@example
(%i1) nofix ("foo");
(%o1)                          foo
(%i2) texput ("foo", "\\mathsc@{foo@}", nofix);
(%o2)                     \mathsc@{foo@}
(%i3) tex (foo);
$$\mathsc@{foo@}$$
(%o3)                         false
@end example

Assign TeX output for a matchfix operator.

@c ===beg===
@c matchfix ("<<", ">>");
@c texput ("<<", [" \\langle ", " \\rangle "], matchfix);
@c tex (<<a>>);
@c tex (<<a, b>>);
@c texput ("<<", [" \\langle ", " \\rangle ", " \\, | \\,"], 
@c       matchfix);
@c tex (<<a>>);
@c tex (<<a, b>>);
@c ===end===
@example
(%i1) matchfix ("<<", ">>");
(%o1)                          <<
(%i2) texput ("<<", [" \\langle ", " \\rangle "], matchfix);
(%o2)                [ \langle ,  \rangle ]
(%i3) tex (<<a>>);
$$ \langle a \rangle $$
(%o3)                         false
(%i4) tex (<<a, b>>);
$$ \langle a , b \rangle $$
(%o4)                         false
(%i5) texput ("<<", [" \\langle ", " \\rangle ", " \\, | \\,"],
      matchfix);
(%o5)           [ \langle ,  \rangle ,  \, | \,]
(%i6) tex (<<a>>);
$$ \langle a \rangle $$
(%o6)                         false
(%i7) tex (<<a, b>>);
$$ \langle a \, | \,b \rangle $$
(%o7)                         false
@end example

@c @opencatbox
@c @category{TeX output}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
@anchor{get_tex_environment}
@c @deffn  {Function} get_tex_environment (@var{op})
@c @deffnx {Function} set_tex_environment (@var{op}, @var{before}, @var{after})
m4_deffn( {Function}, get_tex_environment, <<<(@var{op})>>>)
m4_deffnx({Function}, set_tex_environment, <<<(@var{op}, @var{before}, @var{after})>>>)

Customize the TeX environment output by @code{tex}.
As maintained by these functions, the TeX environment comprises two strings:
one is printed before any other TeX output, and the other is printed after.

Only the TeX environment of the top-level operator in an expression
is output; TeX environments associated with other operators are ignored.

@code{get_tex_environment} returns the TeX environment which is applied
to the operator @var{op}; returns the default if no other environment
has been assigned.

@code{set_tex_environment} assigns the TeX environment for the operator
@var{op}.

Examples:

@c ===beg===
@c get_tex_environment (":=");
@c tex (f (x) := 1 - x);
@c set_tex_environment (":=", "$$", "$$");
@c tex (f (x) := 1 - x);
@c ===end===
@example
(%i1) get_tex_environment (":=");
(%o1) [
\begin@{verbatim@}
, ;
\end@{verbatim@}
]
(%i2) tex (f (x) := 1 - x);

\begin@{verbatim@}
f(x):=1-x;
\end@{verbatim@}

(%o2)                         false
(%i3) set_tex_environment (":=", "$$", "$$");
(%o3)                       [$$, $$]
(%i4) tex (f (x) := 1 - x);
$$f(x):=1-x$$
(%o4)                         false
@end example

@c @opencatbox
@c @category{TeX output}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
@anchor{get_tex_enviroment_default}
@c @deffn  {Function} get_tex_environment_default ()
@c @deffnx {Function} set_tex_environment_default (@var{before}, @var{after})
m4_deffn( {Function}, get_tex_environment_default, <<<()>>>)
m4_deffnx({Function}, set_tex_environment_default, <<<(@var{before}, @var{after})>>>)

Customize the TeX environment output by @code{tex}.
As maintained by these functions, the TeX environment comprises two strings:
one is printed before any other TeX output, and the other is printed after.

@code{get_tex_environment_default} returns the TeX environment which is
applied to expressions for which the top-level operator has no
specific TeX environment (as assigned by @code{set_tex_environment}).

@code{set_tex_environment_default} assigns the default TeX environment.

Examples:

@c ===beg===
@c get_tex_environment_default ();
@c tex (f(x) + g(x));
@c set_tex_environment_default ("\\begin{equation}
@c ", "
@c \\end{equation}");
@c tex (f(x) + g(x));
@c ===end===
@example
(%i1) get_tex_environment_default ();
(%o1)                       [$$, $$]
(%i2) tex (f(x) + g(x));
$$g\left(x\right)+f\left(x\right)$$
(%o2)                         false
(%i3) set_tex_environment_default ("\\begin@{equation@}
", "
\\end@{equation@}");
(%o3) [\begin@{equation@}
, 
\end@{equation@}]
(%i4) tex (f(x) + g(x));
\begin@{equation@}
g\left(x\right)+f\left(x\right)
\end@{equation@}
(%o4)                         false
@end example

@c @opencatbox
@c @category{TeX output}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
@node Functions and Variables for Fortran Output, , Functions and Variables for TeX Output, File Input and Output
@section Functions and Variables for Fortran Output
@c -----------------------------------------------------------------------------

@c -----------------------------------------------------------------------------
m4_setcat(Translation and compilation)
@anchor{fortindent}
@c @defvr {Option variable} fortindent
m4_defvr( {Option variable}, fortindent)
Default value: @code{0}

@code{fortindent} controls the left margin indentation of
expressions printed out by the @mref{fortran} command.  @code{0} gives normal
printout (i.e., 6 spaces), and positive values will causes the
expressions to be printed farther to the right.

@c @opencatbox
@c @category{Translation and compilation}
@c @closecatbox
@c @end defvr
m4_end_defvr()

@c -----------------------------------------------------------------------------
m4_setcat(Translation and compilation)
@anchor{fortran}
@c @deffn {Function} fortran (@var{expr})
m4_deffn({Function}, fortran, <<<(@var{expr})>>>)

Prints @var{expr} as a Fortran statement.
The output line is indented with spaces.
If the line is too long, @code{fortran} prints continuation lines.
@code{fortran} prints the exponentiation operator @code{^} as @code{**},
and prints a complex number @code{a + b %i} in the form @code{(a,b)}.

@var{expr} may be an equation.  If so, @code{fortran} prints an assignment
statement, assigning the right-hand side of the equation to the left-hand side.
In particular, if the right-hand side of @var{expr} is the name of a matrix,
then @code{fortran} prints an assignment statement for each element of the
matrix.

If @var{expr} is not something recognized by @code{fortran},
the expression is printed in @mref{grind} format without complaint.
@code{fortran} does not know about lists, arrays, or functions.

@mref{fortindent} controls the left margin of the printed lines.
@code{0} is the normal margin (i.e., indented 6 spaces).  Increasing
@code{fortindent} causes expressions to be printed further to the right.

When @mref{fortspaces} is @code{true}, @code{fortran} fills out
each printed line with spaces to 80 columns.

@code{fortran} evaluates its arguments; quoting an argument defeats evaluation.
@code{fortran} always returns @code{done}.

See also the function @mxref{function_f90, f90} for printing one or more
expressions as a Fortran 90 program.

Examples:

@verbatim
(%i1) expr: (a + b)^12$
(%i2) fortran (expr);
      (b+a)**12                                                                 
(%o2)                         done
(%i3) fortran ('x=expr);
      x = (b+a)**12                                                             
(%o3)                         done
(%i4) fortran ('x=expand (expr));
      x = b**12+12*a*b**11+66*a**2*b**10+220*a**3*b**9+495*a**4*b**8+792
     1   *a**5*b**7+924*a**6*b**6+792*a**7*b**5+495*a**8*b**4+220*a**9*b
     2   **3+66*a**10*b**2+12*a**11*b+a**12
(%o4)                         done
(%i5) fortran ('x=7+5*%i);
      x = (7,5)                                                                 
(%o5)                         done
(%i6) fortran ('x=[1,2,3,4]);
      x = [1,2,3,4]                                                             
(%o6)                         done
(%i7) f(x) := x^2$
(%i8) fortran (f);
      f                                                                         
(%o8)                         done
@end verbatim

@c @opencatbox
@c @category{Translation and compilation}
@c @closecatbox
@c @end deffn
m4_end_deffn()

@c -----------------------------------------------------------------------------
@anchor{fortspaces}
@c @defvr {Option variable} fortspaces
m4_defvr( {Option variable}, fortspaces)
Default value: @code{false}

When @code{fortspaces} is @code{true}, @code{fortran} fills out
each printed line with spaces to 80 columns.

@c @opencatbox
@c @category{Translation and compilation}
@c @closecatbox
@c @end defvr
m4_end_defvr()

