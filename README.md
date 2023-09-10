Vim dotfiles @mathiassm
================================================================================



Basic config (vimrc)
--------------------------------------------------------------------------------

TBD


Plugins are included as git submodules.



How to upgrade plugin versions
--------------------------------------------------------------------------------

TBD



List of plugins
--------------------------------------------------------------------------------


### Language support

Must-haves that cover most use cases:

- [sheerun/vim-polyglot](https://github.com/sheerun/vim-polyglot)

    Fast syntax highlighting for almost anything.

- [dense-analysis/ale](https://github.com/dense-analysis/ale)

    Asynchronous Lint Engine that comes pre-loaded with almost any existing (good) linter/formatter for over 150 languages. It also has very opinionated configurations so no linter can go wild using resources and all run fast.

- [vim-test/vim-test](https://github.com/vim-test/vim-test)

    (Have not used much) Run tests from vim, à la IDE-style. Compatible with testing frameworks for most well-known languages.

More specific ones:

- [vim-pandoc/vim-pandoc-syntax](https://github.com/vim-pandoc/vim-pandoc-syntax)

    Adds pandoc syntax highlighting to markdown, including embedded languages (latex, codeblocks) and pretty display using vim's `conceal` functionalities.

- [m-pilia/vim-mediawiki](https://github.com/m-pilia/vim-mediawiki)

    Adds mediawiki syntax. Closest I get to Xwiki.

- [lervag/vimtex](https://github.com/lervag/vimtex)

    LaTeX integration. Super useful when editing raw latex. But I prefer `pandoc` with markdown and latex sprinkled here and there.

- [heavenshell/vim-jsdoc](https://github.com/heavenshell/vim-jsdoc)

    Generates JSDoc comments for JS and TS.

Some syntax-related not-language-specific ones:

- [ap/vim-css-color](https://github.com/ap/vim-css-color)

    Highlights CSS-syntax colors with the actual color.

- [ntpeters/vim-better-whitespace](https://github.com/ntpeters/vim-better-whitespace)

    Highlights trailing whitespace.


### Prose (non-code) writing


- [davidbeckingsale/writegood.vim](https://github.com/davidbeckingsale/writegood.vim)

    Highlights common writing problems (passive voice, weasel words...). Maybe covered by `wordy`. Very annoying as I'll never understand why passive voice is such a problem.

- [preservim/vim-wordy](https://github.com/preservim/vim-wordy)

    Misuse/abuse/overuse of words checker. Rather annoying as it highlights a potential problem as a warning, which in code I'm used to never ignore. Useful for prose, but better to toggle it after writing, and not during. It does have many different dictionaries for different problems.

- [junegunn/goyo.vim](https://github.com/junegunn/goyo.vim)

    (Removing soon) This adds a "distraction-free mode" to vim. Great for writing prose. I'm just so used to my setup that I don't feel the need of this mode.


### Tool integration

- [junegunn/**fzf.vim**](https://github.com/junegunn/fzf.vim)

    I ocassionally use fzf (and it's great), although I rarely need to use it within vim (I prefer good-old file tree).

- [editorconfig/editorconfig-vim](https://github.com/editorconfig/editorconfig-vim)

    (Good to have) EditorConfig plugin, to be able to format your code according to your team/project's shared configuration. I prefer other ways to set and enforce these preferences, but if I work with a repository that needs it, then this is enough.

- [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)

    Git integration. It integrates with the status line (and airline), otherwise I use it for blaming specific lines or other in-file actions. It does include some higher-level commands like `:Gedit`, `:Gdiffsplit`, etc. but I don't use them.

    [tpope/vim-rhubarb](https://github.com/tpope/vim-rhubarb) allows it to integrate with Github (`hub`) for `:GBrowse` and autocompletion for issues, collaborators, etc. I haven't used it yet.

- [airblade/vim-gitgutter](https://github.com/airblade/vim-gitgutter)

    Shows git diff in the signs column. Let's you know which lines are added, where are they removed, changed, and so on.

- [jamessan/vim-gnupg](https://github.com/jamessan/vim-gnupg)

    Transparent editing of GPG-encrypted files. Also turns off viminfo, swapfile and undofile for security. Haven't used it other than for fun/exploring, but works well.

- [ledger/vim-ledger](https://github.com/ledger/vim-ledger)

    Both syntax highlighting (already from polyglot plugin), autocompletion, formatting and some integration for ledger and hledger. I don't think I have used it much, but worth taking a look at configurations before ditching.

- [vim-pandoc/vim-pandoc](https://github.com/vim-pandoc/vim-pandoc)

    Integration with `pandoc`. Folding support, TOC functionality, bibliography suport. I don't think I have used it much other than markdown folding (still worth it).

- [christoomey/vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)

    Allows moving seemlessly between vim and tmux splits/panes. Needs some extra configuration on tmux side.


### UI components

- [preservim/nerdtree](https://github.com/preservim/nerdtree)

    Vim already has a file tree viewer. But I hated it when I was starting and replaced it with NERDTree. I like the keys and I'm already used to it; I haven't found anything better, but even then it'd take some effort moving.

    There are multiple extensions:
    - [Git plugin](https://github.com/Xuyuanp/nerdtree-git-plugin) to add Git information to the tree.
    - [vim-devicons](https://github.com/ryanoasis/vim-devicons) is not nerdtree-specific but adds filetype icons both here and in other plugins like airline.
    - ["Syntax highlighting"](https://github.com/tiagofumo/vim-nerdtree-syntax-highlight) to add color to filetype icons OR to the whole filename based on filetype.

- [vim-airline/vim-airline](https://github.com/vim-airline/vim-airline)

    Lightweight status line to replace default vim's one with extra functionality. Integrates with a bunch of other plugins to display more info as well:

    - [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim)

        Adds open buffers (files) to the status line. Integrates nicely with airline status line.

- [sjl/gundo.vim](https://github.com/sjl/gundo.vim)

    (Should use more often) This nice tool lets you visualize vim's undo tree (yes, it's a freaking tree, not a stack!), making it easier/possible to find the changes you want.

- [mhinz/vim-startify](https://github.com/mhinz/vim-startify)

    Provides a nice start/home page with easy access to recent files, sessions, bookmarks, etc. I used it a lot before but not so much now, as I'm not usually on the same files but rather exploring.


### Quick vim is quick (editing files)

- [terryma/vim-expand-region](https://github.com/terryma/vim-expand-region)

    (Should use more often) Easily select expanding/super/upper regions with a single keystroke. Also allows to customize how it selects regions, but I haven't had the need.

- [junegunn/vim-easy-align](https://github.com/junegunn/vim-easy-align)

    Ridiculously easy and powerful vertical align plugin. E.g. align lines on the `=` sign, or align table columns, and so on. I love to use it for tables and configuration files when possible.

- [tomtom/tcomment_vim](https://github.com/tomtom/tcomment_vim)

    Filetype-aware comments toggle.

- [tpope/vim-surround](https://github.com/tpope/vim-surround)

    Adds the ability to change the surrounding parenthesis, tags, etc. Both ones on the same action, without going there to change each individually.

- [tpope/vim-speeddating](https://github.com/tpope/vim-speeddating)

    Allows using `<C-A>` (increase one) and `<C-X>` (reduce one) in dates, not only numbers.

- [tpope/vim-repeat](https://github.com/tpope/vim-repeat)

    Allows `.` to repeat not only the last native command but also plugin-defined commands. Supported by `surround`, `speeddating` among others.


### Other little things

- [pbrisbin/vim-mkdir](https://github.com/pbrisbin/vim-mkdir)

    Transparently create all missing folders in a path to a new file.

- [preservim/vim-indent-guides](https://github.com/preservim/vim-indent-guides)

    Makes indentation have alternating colors. Easily toggled. Color might need adjustment if not using gVim.

- [junegunn/vim-emoji](https://github.com/junegunn/vim-emoji)

    Make emojis usable in git gutter, but also enable autocomplete by name using github's `:emoji:` syntax.

    I don't use autocomplete too much, I might remove this (also because it's last updated in 2018).


### Color schemes

These colors may change depending on your terminal color configuration (and screen color, as well).

Many of these colorschemes are TextMate ports.


- [dracula/vim](https://github.com/dracula/vim)
- [tomasr/molokai](https://github.com/tomasr/molokai)
- [rakr/vim-one](https://github.com/rakr/vim-one) (Yes, from Atom editor)

- [vim-airline/vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)

    For the airline UI component. Can mix it up with the general color scheme (as using the same one is not always great).
