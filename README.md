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
function customizePrompt() {
    PS1='\n'
    PS1=`colorful ────────────────────────────────────────────────── textBrightBlack`
    PS1='\n'
    PS1=$PS1`colorful "\u" textCyan`  # user
    PS1=$PS1'@'                       # @
    PS1=$PS1`colorful "\h" textGreen` # host
    PS1=$PS1':'                       # :
    PS1=$PS1`colorful "\w" textBlue`  # working directory
}
```


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

We can also use it for string concatenations.

> Notice the mixed ways of using this tool shown in the example below.
> Both the `colorful` function and the `set-color`/`clear-color` pair are used.

```sh
mySentence=`set-color textBlue`
mySentence=$mySentence'I hope this tool can help everyone'
mySentence=$mySentence' who works with '`colorful bash textCyan`'/'`colorful zsh textCyan`', etc.'
mySentence=$mySentence`clear-color`

echo -e $mySentence
```


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