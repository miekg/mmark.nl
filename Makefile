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
	cp ~/go/mmark/Syntax.md content/post/syntax.md
	cp ~/go/mmark/README.md content/post/about.md
	git ci -am'Make sync'
