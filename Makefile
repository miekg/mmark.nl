all:
	hugo -d /var/www/mmark.nl

.PHONY: clean
clean:
	rm -rf /var/www/mmark.nl/*

.PHONY: test
test:
	hugo server

.PHONY: copy
copy:
	cp $$GOPATH/src/github.com/mmarkdown/mmark/syntax.md content/post/syntax.md
	cp $$GOPATH/src/github.com/mmarkdown/mmark/README.md content/post/about.md
