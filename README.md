## dotfiles
A dumping ground for my personal dotfiles that keep my computing life organized and productive. If you find any of this useful, go ahead and borrow any or all of it.
## What software do I use?
First and foremost is macOS. On top of that, I use the AeroSpace tiling window manager, which I’ve customized with a couple patches and a number of homegrown utilities that I use to keep myself productive. Examples include a custom notification system, dynamic per-workspace LCD backlighting, and a few other sundry scripts that integrate with AeroSpace over its IPC channel.

On top of AeroSpace, I spend almost all of my time in terminals and web browser (Chrome). My terminal font is "'CaskaydiaMono Nerd Font Mono'". I run my terminals inside a tmux session, which lets me do fun things like detach from running sessions, broadcast keystrokes to multiple terminals at once (useful when you're doing sysadmin chores on a cluster), and not losing your work if your terminal emulator crashes on you.

In half of my multitudinous terminal sessions, you will find Vim instances. I do all of my coding in IntelliJ IDEA, and use Vim when I need to edit files from a command line.

I rely heavily on keyboard shortcuts for my favourite applications. In fact, most of the time I have the mouse/trackpad disabled. I can run my window manager, editor, and web browser (mostly) without an active pointing device. This eases any RSI strain on my wrist/elbow and probably helps keep my mind sharp as I memorize hundreds of key combinations. Probably.

In addition to these major parts of my working environment, I lean on a number of tools, programming languages, message queues, and database systems to build my software. To name a few:

1. Tools: SSH, Git, Postman, UTM
2. Languages: Zsh, HTML, CSS, JAVA, C
3. MQ and DB: Redis, RabbitMQ, MySQL Workbench

<p>On servers I mostly run FreeBSD 8.0, but a few systems are still on 7.x (simply because I haven&rsquo;t gotten around to upgrading them yet). I use <a href="http://cr.yp.to/djbdns.html" title="DNS server software.">djbdns</a> for DNS (both authoritative and caching); <a href="http://qmail.org/top.html" title="An SMTP server.">qmail</a> for email; <a href="http://www.ezmlm.org/" title="Mailing list management software.">ezmlm</a> for mailing lists; <a href="https://httpd.apache.org/" title="Web server software.">Apache</a> for web serving (I would probably not pick Apache if I cared about performance, but I don&rsquo;t do anything which needs fantastic HTTP serving performance); <a href="https://www.stunnel.org/index.html" title="A tool to make any TCP connection over SSL.">stunnel</a> for SSL termination (for security reasons, I prefer to keep SSL termination separate from HTTP serving);</p>

For web applications, I use Java with [Spring Boot](https://spring.io/projects/spring-boot) and [Maven](https://maven.apache.org/) (the JVM is hungry for memory, but having dependency injection, data access, and an embedded server wired together is worth it), [MySQL](https://www.mysql.com/) for storage, [Thymeleaf](https://www.thymeleaf.org/) for server-side HTML, [htmx](https://htmx.org/) for interactivity by swapping HTML fragments over plain HTTP, and [Bootstrap](https://getbootstrap.com/) for layout and styling, since I'm not a designer and don't plan to become one. It all runs on [FreeBSD](https://www.freebsd.org/) at [Vultr](https://www.vultr.com/), with the app listening only on localhost, Apache proxying to it, and stunnel handling TLS. It isn't the most fashionable stack, but each piece does one job, and like djbdns and qmail, I expect it to keep working long after I've stopped thinking about it.
