# Phoenix14Base

## System-level Dependencies

* Erlang (see .tool-versions)
* Elixir (see .tool-versions)
* Node.js (see .tool-versions)
* PostgreSQL 10.5
* Git

## Development

### Install dependencies

#### Erlang, Elixir and Node.js

Suggest managing these languages with [asdf](https://github.com/asdf-vm/asdf) as it will keep everyone working on the project in-sync when it comes to language versions.

Install `asdf`:

```bash
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.6.0
```

Add the following lines to your `.bashrc`/`.bash_profile`/`.zshrc`, etc., as applicable:

```bash
source $HOME/.asdf/asdf.sh
source $HOME/.asdf/completions/asdf.bash
```

Install the relevant utils required for your system:

```bash
# OSX
brew install coreutils automake autoconf openssl libyaml readline libxslt libtool unixodbc gnupg gnupg2

# Ubuntu
apt-get install automake autoconf libreadline-dev libncurses-dev libssl-dev libyaml-dev libxslt-dev libffi-dev libtool unixodbc-dev

# Fedora/Red Hat
yum install automake autoconf readline-devel ncurses-devel openssl-devel libyaml-devel libxslt-devel libffi-devel libtool unixODBC-devel perl-Digest-SHA
```

Install the `asdf` plugins necessary for `erlang`, `elixir` and `nodejs`:

```bash
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
```

Install the versions in the `.tool-versions` file of the present directory:

```bash
asdf install
```

#### Other software dependencies

Please install the other dependencies in the recommended way for your operating system, as long as they meet the version requirements above.

### Project-specific configuration

Install dev and test configurations. **Modify to match your development environment**.

```bash
cp config/dev.exs.sample config/dev.exs
cp config/test.exs.sample config/test.exs
```

Get Elixir deps and compile to check for errors. **Following mix tasks will fail if `mix compile` fails**.

```bash
mix deps.get
mix compile
```

Install Javascript dependencies (no need to build, it will be done when starting the dev server)

```bash
(cd assets && npm install)
```

Create, migrate and seed your database. (see `mix.exs` for all aliases)

```bash
mix ecto.setup
```

If you ever need to reset the database, run:

```bash
mix ecto.reset
```

Update your hosts file so that you can use the host-based routing:

```
# /etc/hosts

127.0.0.1	phoenix14_base.local www.phoenix14_base.local
```

Start phoenix server:

```bash
mix phx.server
```

Now you can use the following:

* [`www.phoenix14_base.local:4000`](http://www.phoenix14_base.local:4000)

## Testing

```bash
mix test
```
