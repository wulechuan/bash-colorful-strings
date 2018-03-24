<link rel="stylesheet" href="./docs/styles/markdown-styles-for-vscode-built-in-preview.css">

# Introduction

Using colors in `bash` strings is now made easier.


# Usage

## Examples

### Basic

It supports classical ANSI colors.
And you can use it either in foreground (text colors) or background, or both.

> For a complete list of supported color names,
> see below [Supported Color Names](#SupportedColorNames).

-   Shade only the foreground color:

    ```sh
    `colorful "Hello world" textGreen`
    ```

-   Shade only the background color:

    ```sh
    `colorful "Hello China" bgndRed`
    ```

-   Shade both foreground and background colors:

    ```sh
    `colorful "I'm wulechuan" textBlack bgndCyan`
    ```

It supports so-called _modern_ colors as well.
Simply insert the keyword `Bright` before color names will do.

Like this:

```sh
`colorful "Let's try some more colors" textBrightBlack bgndBrightGreen`
```
or

```sh
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_HIDE_IF_PWD_IGNORED=true

function _customize_prompt_with_git_branch_info_ {
	local osType=''

	if [ -r 'etc/issue' ]; then
		osType=`cat /etc/issue`
		osType=${osType/Kernel*/}
		osType=`colorful " $osType" textBlack bgndBrightBlack`'\n'
	fi

	PS1=`clear-color`
	PS1=$PS1$osType'\n'

	PS1=$PS1`colorful "\u" textBlack       bgndCyan`      # user
	PS1=$PS1`colorful "@"  textBlack       bgndGreen`     # @
	PS1=$PS1`colorful "\h" textBlack       bgndYellow`    # host
	PS1=$PS1`colorful " :" textBrightBlack bgndBrightRed` # :
	PS1=$PS1`colorful "\w" textBlack       bgndMagenta`   # current working directory

	PS1=$PS1'`__git_ps1_or_empty_string`'

	PS1=$PS1'\n'
	PS1=$PS1'$ '                                          # last prompt sign: $<space>
}

function __git_ps1_or_empty_string () {
	local gitBranchInfo=

	if test -z "$WINELOADERNOEXEC"
	then
		GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"
		COMPLETION_PATH="${GIT_EXEC_PATH%/libexec/git-core}"
		COMPLETION_PATH="${COMPLETION_PATH%/lib/git-core}"
		COMPLETION_PATH="$COMPLETION_PATH/share/git/completion"
		if test -f "$COMPLETION_PATH/git-prompt.sh"
		then
			. "$COMPLETION_PATH/git-completion.bash"
			. "$COMPLETION_PATH/git-prompt.sh"
			gitBranchInfo=`__git_ps1 "%s"`     # bash function
		fi
	else
		gitBranchInfo="$(__git_ps1 '%s')"
	fi

	if [ -z "$gitBranchInfo" ]; then
		echo -n ''
		return
	fi

	echo
	echo `colorful '[' textBrightBlack``colorful $gitBranchInfo textGreen``colorful ']' textBrightBlack`
}
```

Here is the snapshot of the example above:

![Git Bash Prompt Example](./docs/illustrates/git-bash-prompt-example.png "Git Bash Prompt Example")





### In case a direct function call doesn't work

You can utilize two functions as a pair to achieve the same object,
the `set-color`, and the `clear-color`.

1. You first use `set-color` to start shading.
2. Then, you can present your strings, like do some `echo`s
   or concatenate some strings into a variable.
3. When you are done, you use `clear-color` to clean color hints.

For example:

```sh
echo -e `set-color textMagenta`"I'm $(whoami)"`clear-color`
```
or use it inside multiple `echo`s:

```sh
punc='!'
echo -e `set-color textRed bgndBrightWhite`
echo -en 'Hello'
echo -en `set-color textBlue`' world'
echo -en `set-color textCayn`$punc
echo `clear-color`
```

We can also use it for string concatenations,
like this:

```sh
mySentence=`set-color textBlue`
mySentence=$mySentence'I hope this tool can help everyone'
mySentence=$mySentence' who works with '`colorful bash textCyan`'/'`colorful zsh textCyan`', etc.'
mySentence=$mySentence`clear-color`

echo -e $mySentence
```

> Notice the mixed ways of using this tool shown in the example below.
> Both the `colorful` function and the `set-color`/`clear-color` pair are used.


# Supported Color Names

> For ANSI color full table, see: <https://en.wikipedia.org/wiki/ANSI_escape_code>.

## Classical Foreground Colors

| Color Name  | ANSI Value |
| ----------- | ---------- |
| textBlack   | 30         |
| textRed     | 31         |
| textGreen   | 32         |
| textYellow  | 33         |
| textBlue    | 34         |
| textMagenta | 35         |
| textCyan    | 36         |
| textWhite   | 37         |


## Classical Background Colors

| Color Name  | ANSI Value |
| ----------- | ---------- |
| bgndBlack   | 40         |
| bgndRed     | 41         |
| bgndGreen   | 42         |
| bgndYellow  | 43         |
| bgndBlue    | 44         |
| bgndMagenta | 45         |
| bgndCyan    | 46         |
| bgndWhite   | 47         |



## Morden Foreground Colors

| Color Name        | ANSI Value |
| ----------------- | ---------- |
| textBrightBlack   | 90         |
| textBrightRed     | 91         |
| textBrightGreen   | 92         |
| textBrightYellow  | 99         |
| textBrightBlue    | 94         |
| textBrightMagenta | 95         |
| textBrightCyan    | 96         |
| textBrightWhite   | 97         |


## Morden Background Colors

| Color Name        | ANSI Value |
| ----------------- | ---------- |
| bgndBrightBlack   | 100        |
| bgndBrightRed     | 101        |
| bgndBrightGreen   | 102        |
| bgndBrightYellow  | 103        |
| bgndBrightBlue    | 1010       |
| bgndBrightMagenta | 105        |
| bgndBrightCyan    | 106        |
| bgndBrightWhite   | 107        |




# License

| Key    | Value                         |
| ------ | ----------------------------- |
| Author | wulechuan@live.com            |
| Type   | [WTFPL](http://www.wtfpl.net) |