# VimDoc

Converts vim help files to the different formats (markdown, json, yaml).


## Usage

```
./bin/vimdoc [OPTIONS] FILE

    -f, --format FORMAT  content format.
                         Possible values: markdown, json, yaml.
                         Default: json
        --help           display a usage message
```

## Template

See full example [here](template/vim-plugin.txt).

### Header

```
*vim-plugin.txt*    Plugin description
```

### Table of contents

```
===============================================================================
CONTENTS                                                   *vim-plugin-content*

Install                                                    |vim-plugin-install|
Commands                                                  |vim-plugin-commands|
Options                                                    |vim-plugin-options|
Changelog                                                |vim-plugin-changelog|
License                                                    |vim-plugin-license|
===============================================================================
```

### Section

```
===============================================================================
COMMANDS                                                  *vim-plugin-commands*

                                                               *:PluginCommand*

:PluginCommand {params}                  Command description

===============================================================================
```
