## dotfiles
A dumping ground for my personal dotfiles that keep my computing life organized and productive. If you find any of this useful, go ahead and borrow any or all of it.
## How I do my computing
## My computer
Gone are the days when I had 15 desktop computers in my bedroom as build clusters for FreeBSD. Today I’m more of a minimalist, prioritizing mobility over screen size or computing power.

I presently carry a 2012 MacBook Air 11" around with me wherever I go. I maxed out the RAM (8GB) and put an SSD in it, and it’s just a beautiful little machine. I’m not a big fan of macOS though, so it runs FreeBSD.

I use an iPhone 13 phone.

## What software do I use (What I do on my computer)?
First and foremost is FreeBSD. On top of that, I use the i3 tiling window manager, which I’ve customized with a couple patches and a number of homegrown utilities that I use to keep myself productive. Examples include a custom notification system, dynamic per-workspace LCD backlighting, and a few other sundry scripts that integrate with i3 over its IPC channel.

On top of i3, I spend almost all of my time in terminals (urxvt) and web browser (Chrome). My terminal font is "'CaskaydiaMono Nerd Font Mono'". I run my terminals inside a tmux session, which lets me do fun things like detach from running sessions, broadcast keystrokes to multiple terminals at once (useful when you're doing sysadmin chores on a cluster), and not losing your work if your terminal emulator crashes on you.

In half of my multitudinous terminal sessions, you will find Vim instances. I do all of my coding in IntelliJ IDEA + CLion, and use Vim when I need to edit files from a command line. Vim has been my editor of choice since I left the womb, and because of the entrenched muscle memory of typing things like “:wq”, I can barely function in other editors.

## How I connect to the internet (How I use the Internet)
I typically use two web browsers in tandem. Because I’m fairly cognizant of web security, I run one “clean” browser (Firefox) and one “dirty” browser (Chrome). The browser I use depends on the website I’m visiting.

For example, since a Facebook widget exists on basically every site on our green Earth, Facebook can easily see what sites you visit on any given day. So I will only login to Facebook on my dirty browser through an Incognito window. If I’m inspecting the DOM of a web application or trawling through code on GitHub, then I’ll use my clean browser, which has been more fine-tuned to my tastes with customized configuration and useful browser extensions.

I rely heavily on keyboard shortcuts for my favourite applications. In fact, most of the time I have the mouse/trackpad disabled. I can run my window manager, editor, and web browser (mostly) without an active pointing device. This eases any RSI strain on my wrist/elbow and probably helps keep my mind sharp as I memorize hundreds of key combinations. Probably.

In addition to these major parts of my working environment, I lean on a number of tools, programming languages, message queues, and database systems to build my software. To name a few:

1. Tools: SSH, Git, Mutt, Posting, DBeaver
2. Languages: Zsh, HTML, CSS, JAVA, C
3. MQ and DB: Redis, RabbitMQ, MySQL

<p>On servers I mostly run FreeBSD 8.0, but a few systems are still on 7.x (simply because I haven&rsquo;t gotten around to upgrading them yet). I use <a href="http://cr.yp.to/djbdns.html" title="DNS server software.">djbdns</a> for DNS (both authoritative and caching); <a href="http://qmail.org/top.html" title="An SMTP server.">qmail</a> for email; <a href="http://www.ezmlm.org/" title="Mailing list management software.">ezmlm</a> for mailing lists; <a href="https://httpd.apache.org/" title="Web server software.">Apache</a> for web serving (I would probably not pick Apache if I cared about performance, but I don&rsquo;t do anything which needs fantastic HTTP serving performance); <a href="https://www.stunnel.org/index.html" title="A tool to make any TCP connection over SSL.">stunnel</a> for SSL termination (for security reasons, I prefer to keep SSL termination separate from HTTP serving); and of course Tarsnap for backups.</p>
