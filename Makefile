all:
	hugo -d /var/www/mmark.miek.nl

.PHONY: clean
clean:
	rm -rf /var/www/mmark.miek.nl/*

.PHONY: test
test:
	hugo server

.PHONY: sync
sync:
	cp /home/miek/src/github.com/mmarkdown/mmark/Syntax.md content/post/syntax.md
	cp /home/miek/src/github.com/mmarkdown/mmark/README.md content/post/about.md
	cp /home/miek/src/github.com/mmarkdown/mmark/FAQ.md content/post/faq.md
	git ci -am'Make sync'
