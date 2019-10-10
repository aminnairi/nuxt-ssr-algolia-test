# nuxt-ssr-algolia-test

Test for Algolia with Nuxt server-side rendering.

## Requirements

- Terminal Emulator (UNIX & GNU/Linux) or [Git Bash][gitbash] for Windows
- [Docker][docker]
- [Docker Compose][dockercompose]
- [GNU/Make][gnumake]

## Usage

Command | Alias | Description
---|---
`make` | `make install` | Installs the [Node.js][nodejs] dependencies.
`make start` | N/A |Starts the server at [`localhost:1234`](http://localhost:1234).
`make stop` | N/A | Stops the server.
`make restart` | `make stop start` | Stop then start the server again.
`make mrproper` | N/A | Removes all files listed in the [`.gitignore`][gitignore] file.

[docker]: https://www.docker.com/
[dockercompose]: https://docs.docker.com/compose/
[gnumake]: https://www.gnu.org/software/make/
[gitbash]: https://git-scm.com/download/
[nodejs]: https://nodejs.org/en/
[gitignore]: ./.gitignore
