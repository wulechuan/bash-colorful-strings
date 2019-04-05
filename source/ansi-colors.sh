clearColor='\e[0m'

function colorful {
    # Usage:
    #    colorful    [[[[{-n|--}]    <raw string>]    <colorA>]    <colorB>]

    # Examples:
    #     colorful -- wulechuan textBlack bgndCyan     # ended without a new line
    #     colorful    wulechuan textBlack bgndCyan     # ended without a new line
    #     colorful -n wulechuan textBlack bgndCyan     # ended with    a new line
    #     colorful -n wulechuan textBlack bgndCyan     # ended with    a new line

    local endChar
    if   [ "$1" == '--' ]; then
        shift
    elif [ "$1" == '-n' ]; then
        endChar='\n'
        shift
    fi



    if [ $# -eq 0 ]; then
        return 0
    fi



    local rawString="$1"
    shift



    local colorEscapeString
    evaluate-echo-color-into-variable    $*    colorEscapeString



    local clearColorMark
    if [ -z "$colorEscapeString" ]; then
        clearColorMark=''          # 故意不做【清除颜色】的动作
    else
        clearColorMark=$clearColor # 应该清除颜色
    fi



    echo -en "${colorEscapeString}${rawString}${clearColorMark}${endChar}"
}

function evaluate-echo-color-into-variable {
    # Usage:
    #     evaluate-echo-color-into-variable    <color1>    [<color2>]    <reference of variable to store result>
    #
    # Example:
    # ---------------------------------------------
    #     color1=textRed
    #     color2=bgndWhite
    #     colorEscapeString
    #     evaluate-echo-color-into-variable    $color1    $color2   colorEscapeString
    #     echo    $colorEscapeString
    # ---------------------------------------------
    # Notice that the last argument has **no** $ sign prefixed.

    local color1=
    local color2=

    if [ $# -lt 2 ]; then # Too few arguments. At least 2 arguments are required.
        return
    fi


    map-color-name-into-ansi-code-via-if-statements       $1   color1


    if [ $# -eq 2 ]; then
        if [ ! -z "$color1" ]; then
            eval "$2='\\'\"e[${color1}m\""
        fi
    else
        map-color-name-into-ansi-code-via-if-statements   $2   color2

        if [ ! -z "$color1" ] && [ ! -z "$color2" ]; then
            eval "$3='\\'\"e[${color1};${color2}m\""

        elif [ ! -z "$color1" ] || [ ! -z "$color2" ]; then
            # There is no ';' below, because either of the colors will simply be empty.
            eval "$3='\\'\"e[${color1}${color2}m\""
        fi
    fi
}

function set-echo-color {
    # Usage:
    #     set-echo-color    <color1>    [<color2>]
    #
    # Example:
    #     set-echo-color    textRed    bgndBrightWhite

    local colorEscapeString
    evaluate-echo-color-into-variable $* colorEscapeString
    echo -en "$colorEscapeString"
}

function clear-echo-color {
    echo -en $clearColor
}


function append-string {
    # https://stackoverflow.com/questions/3236871/how-to-return-a-string-value-from-a-bash-function

    # Usage:
    #     append-string    <the string to add to the tail of old string>    to    <reference of variable of the old string>
    #
    # ---------------------------------------------
    # myVar='hello '
    # append-string    'wulechuan'    to    myVar
    # echo    "$myVar"
    # ---------------------------------------------
    # Notice that the 3rd argument has **no** $ sign prefixed.
    #
    # Also notice the 2nd argument **must** be 'to'.


    if [ $# -ne 3 ]; then
        return 3
    fi

    if [ "$2" != 'to' ]; then
        return 2
    fi

    local oldStringValue=${!3}
    eval "$3=\"${oldStringValue}${1}\""
}

function append-colorful-string-to {
    # Usage:
    # ---------------------------------------------
    # append-colorful-string-to   <string to modified>   <-n or any non-empty string>   <string to append to $1>   [<text color name>]   [<bgnd color name>]
    # ---------------------------------------------
    # The second argument must be a non-empty one.
    # And only the value '-n' means start a new line at the end of the new string.
    #
    # The 4th and 5th arguments are optional.


    local endChar=''
    if [ "$2" == '-n' ]; then
        endChar='\n'
    fi

    local colorfulStringToAppend=''
    if [ $# -ge 3 ]; then
        colorfulStringToAppend="$3"
    fi

    if [ $# -gt 3 ]; then
        local colorEscapeString
        evaluate-echo-color-into-variable   $4   $5   colorEscapeString

        if [ ! -z "$colorEscapeString" ]; then
            colorfulStringToAppend="${colorEscapeString}$3${clearColor}"
        fi
    fi

    append-string "${colorfulStringToAppend}${endChar}" to "$1"
}

function map-color-name-into-ansi-code-via-if-statements {
    if [ -z "$1" ];                     then
        eval $2=''



    # classical foreground colors

    elif [ $1 == 'textBlack' ];         then
        eval $2=30

    elif [ $1 == 'textRed' ];           then
        eval $2=31

    elif [ $1 == 'textGreen' ];         then
        eval $2=32

    elif [ $1 == 'textYellow' ];        then
        eval $2=33

    elif [ $1 == 'textBlue' ];          then
        eval $2=34

    elif [ $1 == 'textMagenta' ];       then
        eval $2=35

    elif [ $1 == 'textCyan' ];          then
        eval $2=36

    elif [ $1 == 'textWhite' ];         then
        eval $2=37



    # classical background colors

    elif [ $1 == 'bgndBlack' ];         then
        eval $2=40

    elif [ $1 == 'bgndRed' ];           then
        eval $2=41

    elif [ $1 == 'bgndGreen' ];         then
        eval $2=42

    elif [ $1 == 'bgndYellow' ];        then
        eval $2=43

    elif [ $1 == 'bgndBlue' ];          then
        eval $2=44

    elif [ $1 == 'bgndMagenta' ];       then
        eval $2=45

    elif [ $1 == 'bgndCyan' ];          then
        eval $2=46

    elif [ $1 == 'bgndWhite' ];         then
        eval $2=47



    # morden foreground colors
    # modern colors are **not** supported by Microsoft VSCode terminal

    elif [ $1 == 'textBrightBlack' ];   then
        eval $2=90

    elif [ $1 == 'textBrightRed' ];     then
        eval $2=91

    elif [ $1 == 'textBrightGreen' ];   then
        eval $2=92

    elif [ $1 == 'textBrightYellow' ];  then
        eval $2=99

    elif [ $1 == 'textBrightBlue' ];    then
        eval $2=94

    elif [ $1 == 'textBrightMagenta' ]; then
        eval $2=95

    elif [ $1 == 'textBrightCyan' ];    then
        eval $2=96

    elif [ $1 == 'textBrightWhite' ];   then
        eval $2=97



    # morden background colors
    # modern colors are **not** supported by Microsoft VSCode terminal

    elif [ $1 == 'bgndBrightBlack' ];   then
        eval $2=100

    elif [ $1 == 'bgndBrightRed' ];     then
        eval $2=101

    elif [ $1 == 'bgndBrightGreen' ];   then
        eval $2=102

    elif [ $1 == 'bgndBrightYellow' ];  then
        eval $2=103

    elif [ $1 == 'bgndBrightBlue' ];    then
        eval $2=104

    elif [ $1 == 'bgndBrightMagenta' ]; then
        eval $2=105

    elif [ $1 == 'bgndBrightCyan' ];    then
        eval $2=106

    elif [ $1 == 'bgndBrightWhite' ];   then
        eval $2=107


    else
        eval $2=''


    fi
}

# function map-color-name-into-ansi-code-via-case-statements {
    # if [ -z "$1" ]; then
    #     eval $2=''
    #     return
    # fi


    # # The `expr` approach is accurate but very slow! Thus is abandoned.
    # # local colorCategory=`expr $1 : '^\(text\|textBright\|bgnd\|bgndBright\)\(Black\|Red\|Green\|Yellow\|Blue\|Magenta\|Cyan\|White\)$'`
    # # local     colorName=`expr $1 : '.*\(Black\|Red\|Green\|Yellow\|Blue\|Magenta\|Cyan\|White\)$'`


    # # The two-segmented approach used below is NOT accurate!
    # # For example: textABCDERed    text1Red   text_Red   textRed   are all treated as textRed.

    # # Besides, this case-statements approach is NOT faster than the if-statements one.
    # # Besides, this case-statements approach is NOT faster than the if-statements one.
    # # Besides, this case-statements approach is NOT faster than the if-statements one.
    # # Besides, this case-statements approach is NOT faster than the if-statements one.
    # # Besides, this case-statements approach is NOT faster than the if-statements one.


    # local colorCategoryValue=-1
    # local colorBaseValue=-1

    # case "$colorCategory" in
    #     textBright*)
    #         colorCategoryValue=90
    #         ;;

    #     bgndBright*)
    #         colorCategoryValue=100
    #         ;;

    #     text*)
    #         colorCategoryValue=30
    #         ;;

    #     bgnd*)
    #         colorCategoryValue=40
    #         ;;
    # esac

    # case "$1" in
    #     *Black)
    #         colorBaseValue=0
    #         ;;

    #     *Red)
    #         colorBaseValue=1
    #         ;;

    #     *Green)
    #         colorBaseValue=2
    #         ;;

    #     *Yellow)
    #         colorBaseValue=3
    #         ;;

    #     *Blue)
    #         colorBaseValue=4
    #         ;;

    #     *Magenta)
    #         colorBaseValue=5
    #         ;;

    #     *Cyan)
    #         colorBaseValue=6
    #         ;;

    #     *White)
    #         colorBaseValue=7
    #         ;;
    # esac

    # local colorValue=$((colorCategoryValue+colorBaseValue))

    # if [ $colorCategoryValue -ge 0 ] && [ $colorBaseValue -ge 0 ]; then
    #     eval $2=$colorValue
    # else
    #     eval $2=''
    # fi

    # return
# }
