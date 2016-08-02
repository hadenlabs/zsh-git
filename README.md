# zsh-git-aliases

<span class="badges" align="center">
[![Build Status](https://travis-ci.org/luismayta/zsh-git-aliases.svg)](https://travis-ci.org/luismayta/zsh-git-aliases)
[![Stories in Ready](https://badge.waffle.io/luismayta/zsh-git-aliases.svg?label=ready&title=Ready)](http://waffle.io/luismayta/zsh-git-aliases)
[![GitHub issues](https://img.shields.io/github/issues/luismayta/zsh-git-aliases.svg)](https://github.com/luismayta/zsh-git-aliases/issues)
[![GitHub license](https://img.shields.io/github/license/mashape/apistatus.svg?style=flat-square)](LICENSE)
</span>

## Installation

### Oh-My-Zsh

Assuming you have [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh), you can
simply write:

```bash
git clone git@github.com:luismayta/zsh-git-aliases.git ~/.oh-my-zsh/custom/plugins/git-aliases
echo "plugins+=(git-aliases)" >> ~/.zshrc
```

(Alternatively, you can place the `git-aliases` plugin in the `plugins=(...)` local in your `~/.zshrc` manually.)

(Once you have this plugin, you can clone this plugin via `clone peterhurford git-aliases.zsh` instead.  Much better!)

### Antigen
If you're using the [Antigen](https://github.com/zsh-users/antigen) framework for ZSH, all you have to do is add `antigen bundle peterhurford/git-aliases.zsh` to your `.zshrc` wherever you're adding your other antigen bundles. Antigen will automatically clone the repo and add it to your antigen configuration the next time you open a new shell.

### Bash
If you use the non-recommended alternative, bash, you can install this directly to you
r `~/.bash_profile`:

```bash
curl -s https://raw.githubusercontent.com/luismayta/zsh-git-aliases/master/zsh-git-aliases.zsh >>
~/.bash_profile
```

## Changelog

Please see [CHANGELOG](CHANGELOG.md) for more information what has changed recently.

## Contributing

Please see [CONTRIBUTING](CONTRIBUTING.md) for details.

## Credits

- [Luis Mayta][link-author]
- [All Contributors][link-contributors]

[link-nodejs]: https://nodejs.org/en/
[link-brew]: http://brew.sh/

<!-- Other -->

[link-author]: https://github.com/luismayta
[link-contributors]: contributors
