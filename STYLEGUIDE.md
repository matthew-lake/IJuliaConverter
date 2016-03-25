# Jupyter2Code Style Guide

## General
Follow the [Official Style Guide](http://docs.julialang.org/en/latest/manual/style-guide/) where possible, provided it does not conflict with this document.

## Indentation
Tabs

## Line Width
Generally, lines should be less than 80 characters (with a tab-width of 4). 
Use your judgement as to where to break and when to make an exception.

## Variable Names
Use `camelCase`

### Unicode
Use Unicode variable names sparingly. Unless the symbol is in common use (e.g. π), either provide an explanation in a comment, or use the English name.

## Functions

Use double-tab continuation indents to distinguish continued function declarations or calls from the first line of code within the function.
Always use explicit `returns`.
