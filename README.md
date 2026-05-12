## dotfiles
A dumping ground for my personal dotfiles that keep my computing life organized and productive. If you find any of this useful, go ahead and borrow any or all of it.
## What software do I use?
First and foremost is Void Linux. On top of that, I use the i3 tiling window manager, which I've customized with a couple patches and a number of homegrown utilities that I use to keep myself productive. Examples include a custom notification system, dynamic per-workspace LCD backlighting, and a few other sundry scripts that integrate with i3 over its IPC channel.

On top of i3, I spend almost all of my time in terminals (urxvt) and web browser (Chrome). I run my terminals inside a tmux session, which lets me do fun things like detach from running sessions, broadcast keystrokes to multiple terminals at once (useful when you're doing sysadmin chores on a cluster), and not losing your work if your terminal emulator crashes on you.

In half of my multitudinous terminal sessions, you will find Vim instances. Vim has been my editor of choice since I left the womb, and because of the entrenched muscle memory of typing things like ":wq", I can barely function in other editors.

I rely heavily on keyboard shortcuts for my favourite applications. In fact, most of the time I have the mouse/trackpad disabled. I can run my window manager, editor, and web browser (mostly) without an active pointing device. This eases any RSI strain on my wrist/elbow and probably helps keep my mind sharp as I memorize hundreds of key combinations. Probably.

In addition to these major parts of my working environment, I lean on a number of tools, programming languages, message queues, and database systems to build my software. To name a few:

1. Tools: rsync, ssh, git, TrueCrypt, Lsyncd, ranger, tinc
2. Languages: bash, Python, JavaScript (nodejs), Lua, Go, C, PHP
3. MQ and DB: Redis, RabbitMQ, ZeroMQ, MySQL, Postgres, SQLite
