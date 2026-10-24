## dotfiles
A dumping ground for my personal dotfiles that keep my computing life organized and productive. If you find any of this useful, go ahead and borrow any or all of it.
## What software do I use?
First and foremost is macOS. On top of that, I use the AeroSpace tiling window manager, which I’ve customized with a couple patches and a number of homegrown utilities that I use to keep myself productive. Examples include a custom notification system, dynamic per-workspace LCD backlighting, and a few other sundry scripts that integrate with AeroSpace over its IPC channel.

On top of AeroSpace, I spend almost all of my time in terminals and web browser (Chrome). My terminal font is "'CaskaydiaMono Nerd Font Mono'". I run my terminals inside a tmux session, which lets me do fun things like detach from running sessions, broadcast keystrokes to multiple terminals at once (useful when you're doing sysadmin chores on a cluster), and not losing your work if your terminal emulator crashes on you.

In half of my multitudinous terminal sessions, you will find Vim instances quietly running alongside my other work. I do all of my coding in IntelliJ IDEA, where I build full-stack web applications. On the front end, I use Bootstrap for responsive, consistent styling and HTMX to add dynamic, partial-page updates without writing heavy JavaScript. On the back end, I rely on Spring Boot to structure and run the application, Thymeleaf to render server-side templates, and Hibernate with JPA to map my Java entities to relational tables and handle persistence. For the database, I design schemas, run queries and inspect data in MySQL Workbench. I use Vim only when I need to edit files from a command line, such as tweaking configuration files, fixing a script on a remote server or making a quick change in a terminal where opening a full IDE would be unnecessary.

I rely heavily on keyboard shortcuts for my favourite applications. In fact, most of the time I have the mouse/trackpad disabled. I can run my window manager, editor, and web browser (mostly) without an active pointing device. This eases any RSI strain on my wrist/elbow and probably helps keep my mind sharp as I memorize hundreds of key combinations. Probably.

In addition to these major parts of my working environment, I lean on a number of tools, programming languages, message queues, and database systems to build my software. To name a few:

1. Tools: SSH, Git, Mutt, Postman, UTM
2. Languages: Zsh, HTML, CSS, JAVA, C
3. MQ and DB: Redis, RabbitMQ, MySQL
