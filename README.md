# vimdoc2markdown

Converts vim help files to markdown format


## Usage

    vimdoc2markdown path/to/help/file


## Template


### Header

```
*vim-plugin.txt*    Plugin description
```


### Table of contents

```
===============================================================================
CONTENTS                                                           *vim-plugin*

Install                                                    |vim-plugin-install|
Commands                                                  |vim-plugin-commands|
Options                                                    |vim-plugin-options|
Changelog                                                |vim-plugin-changelog|
License                                                    |vim-plugin-license|
```


### Section

```
===============================================================================
COMMANDS                                                  *vim-plugin-commands*

                                                               *:PluginCommand*

:PluginCommand {params}                  Command description
```
